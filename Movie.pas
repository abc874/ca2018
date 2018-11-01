UNIT Movie;

INTERFACE

USES
  MMsystem;

CONST
  WMV_EXTENSIONS                   : ARRAY[0..1] OF STRING = ('.wmv', '.asf');
  AVI_EXTENSIONS                   : ARRAY[0..1] OF STRING = ('.avi', '.divx');
  MP4_EXTENSIONS                   : ARRAY[0..2] OF STRING = ('.mp4', '.m4v', '.mp4v');

  //Class IDs
  CLSID_HAALI                      : TGUID = '{55DA30FC-F16B-49FC-BAA5-AE59FC65F82D}'; //Haali File Source and Media Splitter
  //   CLSID_AVI_DECOMPRESSOR ='{CF49D4E0-1115-11CE-B03A-0020AF0BA770}';  //Use CLSID_AVIDec from DirectShow9

TYPE

  TMovieType = (mtUnknown, mtWMV, mtAVI, mtMP4, mtHQAVI, mtNone);

  TMovieInfo = CLASS
  PRIVATE
    FMovieType: TMovieType;
    PROCEDURE SetMovieType(CONST Value: TMovieType);
    FUNCTION GetFrameCount: Int64;
    //movie params
  PUBLIC
    MovieLoaded: boolean;
    CanStepForward: boolean;
    FFourCC: FOURCC;
    TimeFormat: TGUID;
    ratio: double;
    nat_w, nat_h: integer;
    current_file_duration, frame_duration: double;
    frame_duration_source: char;
    current_filename, target_filename: STRING;
    current_filesize: Longint;
    {current_position_seconds: double;
    function current_position_string: string;}
    PROPERTY FrameCount: Int64 READ GetFrameCount;
    PROPERTY MovieType: TMovieType READ FMovieType WRITE SetMovieType;
    FUNCTION FormatPosition(Position: double): STRING; OVERLOAD;
    FUNCTION FormatPosition(Position: double; TimeFormat: TGUID): STRING; OVERLOAD;
    FUNCTION FormatFrameRate: STRING; OVERLOAD;
    FUNCTION FormatFrameRate(CONST frame_duration: double; CONST frame_duration_source: char): STRING; OVERLOAD;
    FUNCTION MovieTypeString: STRING;
    FUNCTION GetStringFromMovieType(aMovieType: TMovieType): STRING;
    FUNCTION InitMovie(FileName: STRING): boolean;
  PRIVATE
    PROCEDURE GetAviInformation;
  END;

IMPLEMENTATION

USES
  Windows,
  SysUtils,
  StrUtils,
  VfW,
  DirectShow9,
  Utils,
  CAResources;

{ TMovieInfo }

FUNCTION TMovieInfo.FormatFrameRate(CONST frame_duration: double; CONST frame_duration_source: char): STRING;
BEGIN
  IF frame_duration <= 0 THEN
    Result := CAResources.RsMovieFrameRateNotAvailable
  ELSE
    Result := Format(CAResources.RsMovieFrameRateAvailable, [1.0 / frame_duration]);
  IF frame_duration_source <> #0 THEN
    Result := Format(CAResources.RsMovieFrameRateSource, [Result, STRING(frame_duration_source)]);
END;

FUNCTION TMovieInfo.FormatFrameRate: STRING;
BEGIN
  IF NOT MovieLoaded THEN
    Result := FormatFrameRate(-1, '-')
  ELSE
    Result := FormatFrameRate(frame_duration, frame_duration_source);
END;

FUNCTION TMovieInfo.GetFrameCount: Int64;
BEGIN
  Result := Trunc(current_file_duration / frame_duration);
END;

FUNCTION TMovieInfo.InitMovie(FileName: STRING): boolean;
VAR
  FileData                         : ARRAY[0..63] OF byte;
  s, file_ext                      : STRING;
  f                                : FILE OF byte;
BEGIN
  result := false;
  IF NOT fileexists(filename) THEN
    exit;

  //determine filesize
  AssignFile(f, filename);
  FileMode := fmOpenRead;
  reset(f);
  TRY
    current_filename := filename;
    current_filesize := filesize(f);
    BlockRead(f, FileData, Length(FileData));
  FINALLY
    closefile(f)
  END;

  MovieType := mtUnknown;
  frame_duration := 0;
  frame_duration_source := '-';
  FFourCC := 0;
  Result := true;

  //detect Avi File
  setstring(s, Pchar(@FileData[0]), 4);
  IF s = 'RIFF' THEN BEGIN
    SetString(s, Pchar(@FileData[8]), 4);
    IF s = 'AVI ' THEN
      MovieType := mtAVI;
  END;

  //detect ISO FIle
  SetString(s, Pchar(@FileData[4]), 4);
  IF s = 'ftyp' THEN
    MovieType := mtMP4;

  //for OTR
  IF MovieType = mtUnknown THEN BEGIN
    IF AnsiEndsText('.hq.avi', FileName) THEN
      MovieType := mtHQAVI;
  END;

  //Try to detect MovieType from file extension
  IF MovieType = mtUnknown THEN BEGIN
    file_ext := ExtractFileExt(FileName);
    IF AnsiMatchText(file_ext, WMV_EXTENSIONS) THEN
      MovieType := mtWMV
    ELSE IF AnsiMatchText(file_ext, AVI_EXTENSIONS) THEN
      MovieType := mtAVI
    ELSE IF AnsiMatchText(file_ext, MP4_EXTENSIONS) THEN
      MovieType := mtMP4;
  END;

  //Try to get Video FourCC from AVI
  IF MovieType IN [mtAVI, mtHQAVI] THEN BEGIN
    GetAviInformation;
    s := fcc2String(FFourCC);
    IF FFourCC = 0 THEN MovieType := mtUnknown
    ELSE IF AnsiSameText(s, 'H264') THEN MovieType := mtHQAVI;
  END;
END;

FUNCTION TMovieInfo.FormatPosition(Position: double): STRING;
BEGIN
  IF isEqualGUID(self.TimeFormat, TIME_FORMAT_MEDIA_TIME) THEN
    result := secondsToTimeString(Position)
  ELSE
    result := format('%.0n', [Position]);
END;

FUNCTION TMovieInfo.FormatPosition(Position: double; TimeFormat: TGUID): STRING;
BEGIN
  IF isEqualGUID(TimeFormat, TIME_FORMAT_MEDIA_TIME) THEN
    result := secondsToTimeString(Position)
  ELSE IF IsEqualGUID(TimeFormat, TIME_FORMAT_FRAME) THEN
    result := format('%.0n', [Position])
  ELSE
    result := format('%n', [Position]);
END;

FUNCTION TMovieInfo.GetStringFromMovieType(aMovieType: TMovieType): STRING;
BEGIN
  CASE aMovieType OF
    mtUnknown: result := CAResources.RsMovieTypeUnknown;
    mtWMV: result := CAResources.RsMovieTypeWmf;
    mtAVI: result := CAResources.RsMovieTypeAvi;
    mtMP4: result := CAResources.RsMovieTypeMp4;
    mtHQAVI: result := CAResources.RsMovieTypeHqAvi;
  ELSE result := CAResources.RsMovieTypeNone;
  END;
END;

FUNCTION TMovieInfo.MovieTypeString: STRING;
BEGIN
  result := GetStringFromMovieType(FMovieType);
END;

PROCEDURE TMovieInfo.SetMovieType(CONST Value: TMovieType);
BEGIN
  FMovieType := Value;
END;

PROCEDURE TMovieInfo.GetAviInformation;
VAR
  AVIStream                        : IAVIStream;
  StreamInfo                       : TAVIStreamInfoW;
  {  AInfo : TAVIFileInfo;
    AVIFile : IAVIFile;
    ErrorMsg : String;
    MsgBox : String;
    Height, Width: DWord;}
  hr                               : HRESULT;
BEGIN
  // Init VfW API
  AVIFileInit;
  TRY
    hr := AVIStreamOpenFromFile(AVIStream, PAnsiChar(current_filename), streamtypeVIDEO, 0, OF_READ, NIL);
    IF NOT succeeded(hr) THEN exit;
    AVIStream.Info(StreamInfo, sizeof(streamInfo));
    FFourCC := StreamInfo.fccHandler;
    IF StreamInfo.dwRate <> 0 THEN BEGIN
      frame_duration_source := 'A';
      frame_duration := StreamInfo.dwScale / StreamInfo.dwRate;
      //frame_duration := 1000000.0 / StreamInfo.dwRate;
    END ELSE BEGIN
      frame_duration_source := 'a';
      frame_duration := 0.04;
    END;

    {//AVIFileOpen
    Result := AVIFileOpen(AVIFile,PChar(Filename), OF_READ, nil);
    ErrorMsg := 'Bad AVI Format !';
    If (Result = AVIERR_BADFORMAT) Then ErrorMsg := 'Bad AVI Format !';
    If (Result = AVIERR_MEMORY) Then ErrorMsg := 'Insufficent Memory !';
    If (Result = AVIERR_FILEREAD) Then ErrorMsg := 'Error while reading from AVI file !';
    If (Result = AVIERR_FILEOPEN) Then ErrorMsg := 'Error while opening AVI file !';
    If (Result = REGDB_E_CLASSNOTREG) Then ErrorMsg := 'No process handle !';

    If (ErrorMsg <> '') Then Begin
      MessageBox(Application.Handle,PChar(ErrorMsg),PChar(MsgBox),MB_OK);
    End;

    // If AVIFile handle available then read AVI File Infos
    If (AVIFile <> NIL) Then begin;


      //AVIFileInfo
      Result := AVIFileInfo(AVIFile,AInfo,SizeOf(TAVIFILEINFO));
      Height := AInfo.dwHeight;
      Width := AInfo.dwWidth;
      //AVIFileRelease
      AVIFileRelease(AVIFile);
    end;  }
  FINALLY
    AVIFileExit;
  END;
END;

END.
