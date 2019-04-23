unit Movie;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.MMSystem;

const
  WMV_EXTENSIONS: array[0..1] of string = ('.wmv', '.asf');
  AVI_EXTENSIONS: array[0..1] of string = ('.avi', '.divx');
  MP4_EXTENSIONS: array[0..2] of string = ('.mp4', '.m4v', '.mp4v');

type
  TMovieType = (mtUnknown, mtWMV, mtAVI, mtMP4, mtHQAVI, mtNone);

  TMovieInfo = class
  private
    FMovieType: TMovieType;
    function GetFrameCount: Int64;
    procedure SetMovieType(const Value: TMovieType);
    procedure GetAviInformation;
  public
    // movie params
    MovieLoaded: Boolean;
    CanStepForward: Boolean;
    FFourCC: FOURCC;
    TimeFormat: TGUID;
    ratio: Double;
    nat_w, nat_h: Integer;
    current_file_duration, frame_duration: Double;
    frame_duration_source: Char;
    current_filename, target_filename: string;
    current_filesize: Int64;
    property FrameCount: Int64 read GetFrameCount;
    property MovieType: TMovieType read FMovieType write SetMovieType;
    function FormatPosition(Position: Double): string; overload;
    function FormatPosition(Position: Double; TimeFormat: TGUID): string; overload;
    function FormatFrameRate: string;
    function MovieTypeString: string;
    function GetStringFromMovieType(aMovieType: TMovieType): string;
    function InitMovie(FileName: string): Boolean;
  end;

function FrameRateToStr(const frame_duration: Double; const frame_duration_source: Char): string;

implementation

uses
  // Delphi
  Winapi.Windows, Winapi.DirectShow9, System.SysUtils, System.StrUtils,

  // Jedi
  VfW,

  // CA
  CAResources, Utils;

function FrameRateToStr(const frame_duration: Double; const frame_duration_source: Char): string;
begin
  if frame_duration <= 0 then
    Result := CAResources.RsMovieFrameRateNotAvailable
  else
    Result := Format(CAResources.RsMovieFrameRateAvailable, [1.0 / frame_duration]);

  if frame_duration_source <> #0 then
    Result := Format(CAResources.RsMovieFrameRateSource, [Result, string(frame_duration_source)]);
end;

{ TMovieInfo }

function TMovieInfo.FormatFrameRate: string;
begin
  if MovieLoaded then
    Result := FrameRateToStr(frame_duration, frame_duration_source)
  else
    Result := FrameRateToStr(-1, '-');
end;

function TMovieInfo.GetFrameCount: Int64;
begin
  Result := Trunc(current_file_duration / frame_duration);
end;

function TMovieInfo.InitMovie(FileName: string): Boolean;
  function FileSize64: Int64;
  var
    R: TSearchRec;
  begin
    if FindFirst(FileName, faAnyFile, R) = 0 then
    begin
      Result := R.Size;
      FindClose(R);
    end else
      Result := -1;
  end;
const
  BytesToRead = 32;
var
  FileData: AnsiString;
  s, file_ext: string;
  f: file;
begin
  Result := False;
  if FileExists(FileName) then
  begin
    // determine filesize
    AssignFile(f, FileName);
    FileMode := fmOpenRead;
    Reset(f, 1);
    try
      SetLength(FileData, BytesToRead);
      current_filename := FileName;
      // current_filesize := Filesize(f);
      BlockRead(f, FileData[1], BytesToRead);
    finally
      CloseFile(f)
    end;
    current_filesize := FileSize64;

    MovieType             := mtUnknown;
    frame_duration        := 0;
    frame_duration_source := '-';
    FFourCC               := 0;
    Result                := True;

    // detect Avi file
    if (Copy(FileData, 1, 4) = 'RIFF') and (Copy(FileData, 9, 4) = 'AVI ') then
      MovieType := mtAVI;

    // detect ISO file
    if Copy(FileData, 5, 4) = 'ftyp' then
      MovieType := mtMP4;

    // for OTR
    if (MovieType = mtUnknown) and FileName.EndsWith('.hq.avi', True) then
      MovieType := mtHQAVI;

    // try to detect MovieType from file extension
    if MovieType = mtUnknown then
    begin
      file_ext := ExtractFileExt(FileName);
      if AnsiMatchText(file_ext, WMV_EXTENSIONS) then
        MovieType := mtWMV
      else if AnsiMatchText(file_ext, AVI_EXTENSIONS) then
        MovieType := mtAVI
      else if AnsiMatchText(file_ext, MP4_EXTENSIONS) then
        MovieType := mtMP4;
    end;

    // try to get Video FourCC from AVI
    if MovieType in [mtAVI, mtHQAVI] then
    begin
      GetAviInformation;
      s := fcc2String(FFourCC);
      if FFourCC = 0 then
        MovieType := mtUnknown
      else
        if SameText(s, 'H264') then
          MovieType := mtHQAVI;
    end;
  end;
end;

function TMovieInfo.FormatPosition(Position: Double): string;
begin
  if isEqualGUID(TimeFormat, TIME_FORMAT_MEDIA_TIME) then
    Result := secondsToTimeString(Position)
  else
    Result := format('%.0n', [Position]);
end;

function TMovieInfo.FormatPosition(Position: Double; TimeFormat: TGUID): string;
begin
  if isEqualGUID(TimeFormat, TIME_FORMAT_MEDIA_TIME) then
    Result := secondsToTimeString(Position)
  else if IsEqualGUID(TimeFormat, TIME_FORMAT_FRAME) then
    Result := format('%.0n', [Position])
  else
    Result := format('%n', [Position]);
end;

function TMovieInfo.GetStringFromMovieType(aMovieType: TMovieType): string;
begin
  case aMovieType of
    mtUnknown : Result := CAResources.RsMovieTypeUnknown;
    mtWMV     : Result := CAResources.RsMovieTypeWmf;
    mtAVI     : Result := CAResources.RsMovieTypeAvi;
    mtMP4     : Result := CAResources.RsMovieTypeMp4;
    mtHQAVI   : Result := CAResources.RsMovieTypeHqAvi;
    else        Result := CAResources.RsMovieTypeNone;
  end;
end;

function TMovieInfo.MovieTypeString: string;
begin
  Result := GetStringFromMovieType(FMovieType);
end;

procedure TMovieInfo.SetMovieType(const Value: TMovieType);
begin
  FMovieType := Value;
end;

procedure TMovieInfo.GetAviInformation;
var
  AVIStream: IAVIStream;
  StreamInfo: TAVIStreamInfoW;
begin
  AVIFileInit; // Init VfW API
  try
    if Succeeded(AVIStreamOpenFromFile(AVIStream, PChar(current_filename), streamtypeVIDEO, 0, OF_READ, nil)) then
    begin
      AVIStream.Info(StreamInfo, SizeOf(streamInfo));
      FFourCC := StreamInfo.fccHandler;
      if StreamInfo.dwRate <> 0 then
      begin
        frame_duration_source := 'A';
        frame_duration := StreamInfo.dwScale / StreamInfo.dwRate;
      end else
      begin
        frame_duration_source := 'a';
        frame_duration := 0.04;
      end;
    end;
  finally
    AVIFileExit;
  end;
end;

end.

