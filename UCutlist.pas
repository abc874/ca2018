unit UCutlist;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, System.Contnrs,

  // CA
  Settings_dialog, Movie, Utils, UCutApplicationBase;

const
  CUTLIST_EXT = 'cutlist';
  CUTLIST_EXTENSION = '.' + CUTLIST_EXT;

type
  TCutList = class;

  RCut = record
    pos_from, pos_to: Double;
    frame_from, frame_to: Integer;
  end;

  TCut = class
  private
    Fpos_from, Fpos_to: Double;
    Fframe_from, Fframe_to: Integer;
  public
    constructor Create(pos_from, pos_to: Double); overload;
    constructor Create(pos_from, pos_to: Double; frame_from, frame_to: Integer); overload;
    property pos_from: Double read Fpos_from write Fpos_from;
    property pos_to: Double read Fpos_to write Fpos_to;
    property frame_from: Integer read Fframe_from write Fframe_from;
    property frame_to: Integer read Fframe_to write Fframe_to;
    function DurationFrames: Integer;
    function GetData: RCut;
  end;

  TCutlistMode = (clmCutOut, clmTrim);
  TCutlistSaveMode = (csmNeverAsk, csmAskBeforeOverwrite, csmAskWhenSavingFirstTime, csmAlwaysAsk);
  TCutlistSearchType = (cstBySize, cstByName);
  TCutlistSearchTypes = set of TCutlistSearchType;
  TCutlistServerCommand = (cscRate, cscDelete, cscUpload);

  TCutlistCallBackMethod = procedure(cutlist: TCutList) of object;

  TCutList = class(TObjectList)
  private
    FSettings: TSettings;
    FMovieInfo: TMovieInfo;
    FIDOnServer: string;
    FRatingOnServer: Double;
    FHasChanged: Boolean;
    FRefreshCallBack: TCutlistCallBackMethod;
    FMode: TCutlistMode;
    FSuggestedMovieName: string;
    FFrameDuration, FFrameRate: Double;
    FCutlistFile: TMemIniFileEx;
    function GetCut(iCut: Integer): TCut;
    procedure SetIDOnServer(const Value: string);
    procedure FillCutPosArray(var CutPosArray: array of Double);
    procedure SetMode(const Value: TCutlistMode);
    procedure SetSuggestedMovieName(const Value: string);
    function CutApplication: TCutApplicationBase;
    procedure SetFrameDuration(d: Double);
    procedure SetFrameRate(d: Double);
    function SaveServerInfos(cutlistfile: TMemIniFileEx): Boolean;
    procedure RemoveCutSections(cutlistfile: TMemIniFileEx);
    function FindCutLinear(fPos: Double): Integer;
  public
    AppName, AppVersion: string;
    ApplyToFile: string;
    Comments: TStrings;
    //Info
    RatingByAuthor: Integer;
    RatingByAuthorPresent: Boolean;
    EPGError,
    MissingBeginning,
    MissingEnding,
    MissingVideo,
    MissingAudio,
    OtherError: Boolean;
    ActualContent,
    OtherErrorDescription,
    UserComment,
    Author: string;
    FramesPresent: Boolean;
    SavedToFilename: string;
    RatingSent: Integer;
    OriginalFileSize: Int64;
    RatingCountOnServer: Integer;
    DownloadTime: Int64;

    constructor Create(Settings: TSettings; MovieInfo: TMovieInfo);
    destructor Destroy; override;

    property FrameDuration: Double read FFrameDuration write SetFrameDuration;
    property FrameRate: Double read FFrameRate write SetFrameRate;
    property RefreshCallBack: TCutlistCallBackMethod read FRefreshCallBack write FRefreshCallBack;
    procedure RefreshGUI;
    property Cut[iCut: Integer]: TCut read GetCut; default;
    function FindCutIndex(fPos: Double): Integer;
    function FindCut(fPos: Double): TCut;
    function AddCut(pos_from, pos_to: Double): Boolean;
    function ReplaceCut(pos_from, pos_to: Double; CutToReplace: Integer): Boolean;
    function SplitCut(pos_from, pos_to: Double): Boolean;
    function DeleteCut(dCut: Integer): Boolean;
    property Mode: TCutlistMode read FMode write SetMode;

    property IDOnServer: string read FIDOnServer write SetIDOnServer;
    property HasChanged: Boolean read FHasChanged;
    function UserShouldSendRating: Boolean;
    function CutCommand: string;
    function cut_times_valid(var pos_from, pos_to: Double; do_not_test_cut: Integer; var interfering_cut: Integer): Boolean;
    function FilenameSuggestion: string;
    property SuggestedMovieName: string read FSuggestedMovieName write SetSuggestedMovieName;
    function TotalDurationOfCuts: Double;
    function NextCutPos(CurrentPos: Double): Double;
    function PreviousCutPos(CurrentPos: Double): Double;

    function clear_after_confirm: Boolean;
    procedure Init;
    procedure Sort;
    function Convert: TCutList;
    function LoadFromFile(FileName: string; noWarnings: Boolean): Boolean; overload;
    function LoadFromFile(FileName: string): Boolean; overload;
    function EditInfo: Boolean;
    function Save(AskForPath: Boolean): Boolean; overload;
    function SaveAs(FileName: string): Boolean;

    function GetChecksum: Cardinal;

    function LoadFrom(cutlistfile: TMemIniFileEx; noWarnings: Boolean): Boolean;
    function StoreTo(cutlistfile: TMemIniFileEx): Boolean; overload;

    property RatingOnServer: Double read FRatingOnServer write FRatingOnServer;
    function AddServerInfos(FileName: string): Boolean;
  end;

implementation

uses
  // Delphi
  Winapi.Windows, System.SysUtils, System.StrUtils, System.DateUtils, System.IniFiles, System.Math, System.UITypes,
  Vcl.Forms, Vcl.Dialogs, Vcl.Controls,

  // Jedi
  JclMath,

  // CA
  cutlistInfo_dialog, UCutApplicationAsfbin, UCutApplicationMP4Box, CAResources;

function CutlistCompareItems(Item1, Item2: Pointer): Integer;
begin
  if Assigned(Item1) and Assigned(Item2) then
    Result := CompareValue(TCut(Item1).pos_from, TCut(Item2).pos_from) // no overlap, compare from only
  else
    Result := CompareValue(Integer(Item1), Integer(Item2)); // Should be always Assigned?
end;

{ TCut }

constructor TCut.Create(pos_from, pos_to: Double);
begin
  Create(pos_from, pos_to, 0, 0);
end;

constructor TCut.Create(pos_from, pos_to: Double; frame_from, frame_to: Integer);
begin
  if pos_from > pos_to then
    raise Exception.CreateFmt('Invalid Range: %f - %f', [pos_from, pos_to]);

  if frame_from > frame_to then
    raise Exception.CreateFmt('Invalid frame range: %d - %d', [frame_from, frame_to]);

  Fpos_from   := pos_from;
  Fpos_to     := pos_to;
  Fframe_from := frame_from;
  Fframe_to   := frame_to;
end;

function TCut.DurationFrames: Integer;
begin
  Result := frame_to - frame_from + 1;
end;

function TCut.GetData: RCut;
begin
  Result.pos_from   := Fpos_from;
  Result.pos_to     := Fpos_to;
  Result.frame_from := Fframe_from;
  Result.frame_to   := Fframe_to;
end;

{ TCutList }

procedure TCutList.SetFrameDuration(d: Double);
begin
  if d < 0 then
    d := 0;

  FFrameDuration := d;

  if d > 0 then
    FFrameRate := 1 / d
  else
    FFrameRate := 0;
end;

procedure TCutList.SetFrameRate(d: Double);
begin
  if d < 0 then
    d := 0;

  FFrameRate := d;

  if d > 0 then
    FFrameDuration := 1 / d
  else
    FFrameDuration := 0;
end;

function TCutList.FindCutIndex(fPos: Double): Integer;
begin
  Result := FindCutLinear(fPos);
end;

function TCutList.FindCut(fPos: Double): TCut;
var
  idx: Integer;
begin
  Result := nil;
  idx := FindCutIndex(fPos);
  if idx >= 0 then
    Result := Cut[idx];
end;

function TCutList.FindCutLinear(fPos: Double): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to Pred(Count) do
    with Cut[I] do
      if (fPos >= pos_from) and (fPos <= pos_to) then
      begin
        Result := I;
        Break;
      end;
end;

function TCutList.AddCut(pos_from, pos_to: Double): Boolean;
var
  icut: Integer;
begin
  if cut_times_valid(pos_from, pos_to, -1, iCut) then
  begin
    Add(TCut.Create(pos_from, pos_to));
    FHasChanged   := True;
    IDOnServer    := '';
    FramesPresent := False;

    Sort;
    RefreshGUI;

    Result := True;
  end else
    Result := False;
end;

function TCutList.ReplaceCut(pos_from, pos_to: Double; CutToReplace: Integer): Boolean;
var
  icut: Integer;
begin
  if cut_times_valid(pos_from, pos_to, CutToReplace, iCut) then
  begin
    Cut[CutToReplace].pos_from := pos_from;
    Cut[CutToReplace].pos_to   := pos_to;

    FHasChanged   := True;
    IDOnServer    := '';
    FramesPresent := False;

    Sort;
    RefreshGUI;

    Result := True;
  end else
    Result := False;
end;

function TCutList.SplitCut(pos_from, pos_to: Double): Boolean;
var
  LeftIndex, RightIndex: Integer;
  LeftPos, RightPos: Double;
begin
  Result := False;

  if (pos_to > pos_from) and (pos_from <= FMovieInfo.current_file_duration) and (pos_to >= 0) then
  begin
    LeftIndex  := FindCutIndex(pos_from);
    RightIndex := FindCutIndex(pos_to);

    if LeftIndex = RightIndex then
    begin
      if LeftIndex < 0 then
      begin
        Result := AddCut(pos_from, pos_to);
      end else
      begin
        LeftPos  := Cut[LeftIndex].pos_from;
        RightPos := Cut[LeftIndex].pos_to;
        Result   := DeleteCut(LeftIndex) and AddCut(LeftPos, pos_from) and AddCut(pos_to, RightPos);
      end;
    end;
  end;
end;

function TCutList.DeleteCut(dCut: Integer): Boolean;
begin
  Delete(dCut);
  FHasChanged := True;
  IDOnServer  := '';
  Result      := True;
  RefreshGUI;
end;

function TCutList.clear_after_confirm: Boolean; // True if cleared, False if cancelled
begin
  Result := True;
  if not batchmode and HasChanged then
  begin
    case MessageDlg(RsTitleCutlistSaveChanges + #13#13 + RsMsgCutlistSaveChanges, mtConfirmation, mbYesNoCancel, 0, mbCancel) of
      mrYes : Result := Save(False); // Can Clear if saved successfully
      mrNo  : Result := True;
      else    Result := False;
    end;
  end;

  if Result then
    Init;
end;

function TCutList.Convert: TCutList;
  procedure AddCut(_pos_from, _pos_to: Double; _frame_from, _frame_to: Integer);
  var
    newCut: TCut;
  begin
    if _pos_from < _pos_to then
    begin
      if FramesPresent and (_frame_from <= _frame_to) then
      begin
        newCut := TCut.Create(_pos_from, _pos_to, _frame_from, _frame_to);
      end else
      begin
        newCut := TCut.Create(_pos_from, _pos_to);
        Result.FramesPresent := False;
      end;
      Result.Add(newCut);
    end;
  end;
var
  iCut: Integer;
  pos_Prev: Double;
  Frame_prev: Integer;
  curCut: TCut;
begin
  Result := TCutList.Create(FSettings, FMovieInfo);
  Result.FFrameRate            := FFrameRate;
  Result.FFrameDuration        := FFrameDuration;
  Result.FramesPresent         := FramesPresent;
  Result.SavedToFilename       := SavedToFilename;
  Result.Author                := Author;
  Result.RatingByAuthorPresent := RatingByAuthorPresent;
  Result.RatingByAuthor        := RatingByAuthor;
  Result.EPGError              := EPGError;
  Result.ActualContent         := ActualContent;
  Result.MissingBeginning      := MissingBeginning;
  Result.MissingEnding         := MissingEnding;
  Result.MissingVideo          := MissingVideo;
  Result.MissingAudio          := MissingAudio;
  Result.OriginalFileSize      := OriginalFileSize;
  Result.OtherError            := OtherError;
  Result.OtherErrorDescription := OtherErrorDescription;
  Result.SuggestedMovieName    := SuggestedMovieName;
  Result.UserComment           := UserComment;
  Result.FRatingOnServer       := RatingOnServer;
  Result.RatingCountOnServer   := RatingCountOnServer;
  Result.RatingSent            := RatingSent;
  Result.DownloadTime          := DownloadTime;
  Result.ApplyToFile           := ApplyToFile;

  if Mode = clmCutOut then
    Result.FMode := clmTrim
  else
    Result.FMode := clmCutOut;

  if Count > 0 then
  begin
    Sort;
    pos_prev   := 0;
    Frame_prev := 0;
    for iCut := 0 to Pred(Count) do
    begin
      curCut := Cut[iCut];
      AddCut(pos_prev, curCut.pos_from - FrameDuration, frame_prev, curCut.frame_from - 1);
      pos_prev   := curCut.pos_to + FrameDuration;
      frame_prev := curCut.frame_to + 1;
    end;

    //rest to end of file - this could be more accurate
    AddCut(pos_prev, FMovieInfo.current_file_duration, frame_prev, Round(FMovieInfo.current_file_duration * FrameRate));
  end;

  Result.Sort;
  Result.FHasChanged := HasChanged;
  Result.IDOnServer  := IDOnServer;

  Result := Result;
end;

constructor TCutList.Create(Settings: TSettings; MovieInfo: TMovieInfo);
begin
  inherited Create;
  FSettings    := Settings;
  FMovieInfo   := MovieInfo;
  Comments     := TStringList.Create;
  FCutlistFile := TMemIniFileEx.Create('');
  Init;
end;

destructor TCutList.Destroy;
begin
  FreeAndNil(Comments);
  FreeAndNil(FCutlistFile);
  inherited;
end;

function TCutList.CutApplication: TCutApplicationBase;
begin
  Result := FSettings.GetCutApplicationByMovieType(FMovieInfo.MovieType);
end;

function TCutList.CutCommand: string;
var
  command: string;
  iCut: Integer;
  ConvertedCutlist: TCutList;
begin
  if Count > 0 then
  begin
    if Mode = clmTrim then
    begin
      command := '';
      Sort;
      for iCut := 0 to Pred(Count) do
      begin
        command := command + ' -start ' + FMovieInfo.FormatPosition(Cut[iCut].pos_from);
        command := command + ' -duration ' + FMovieInfo.FormatPosition(Cut[iCut].pos_to - Cut[iCut].pos_from);
      end;
    end else
    begin
      ConvertedCutlist := Convert;
      command := ConvertedCutlist.CutCommand;
      FreeAndNil(ConvertedCutlist);
    end;

    Result := command;
  end else
  begin
    ErrMsg(RsMsgCutlistNoCutsDefined);
    Result := '';
  end;
end;

function TCutList.cut_times_valid(var pos_from, pos_to: Double; do_not_test_cut: Integer; var interfering_cut: Integer): Boolean;
var
  icut: Integer;
begin
  if (pos_to > pos_from) and (pos_from <= FMovieInfo.current_file_duration) and (pos_to >= 0) then
  begin
    if pos_from < 0 then
      pos_from := 0;

    if pos_to > FMovieInfo.current_file_duration then
      pos_to := FMovieInfo.current_file_duration;

    interfering_cut := -1;

    for iCut := 0 to Pred(Count) do
    begin
      if iCut <> do_not_test_cut then
      begin
        if (pos_from < Cut[iCut].pos_to) and (pos_to > Cut[iCut].pos_from) then
        begin
          ErrMsgFmt(RsErrorCutlistCutOverlap, [icut]);
          interfering_cut := icut;
          Break;
        end;
      end;
    end;

    Result := interfering_cut < 0;
  end else
    Result := False;
end;

function TCutList.EditInfo: Boolean;
begin
  Result := False;

  if not FCutlistInfo.Visible then
  begin
    FCutlistInfo.original_movie_filename := FMovieInfo.current_filename;
    FCutlistInfo.CBFramesPresent.Checked := (FramesPresent and not HasChanged);
    FCutlistInfo.lblFrameRate.Caption    := FrameRateToStr(FrameDuration, 'C');

    if Author = '' then
      FCutlistInfo.lblAuthor.Text := RsCaptionCutlistAuthorUnknown
    else
      FCutlistInfo.lblAuthor.Text := Format(RsCaptionCutlistAuthor, [Author]);

    if RatingByAuthorPresent then
      FCutlistInfo.RGRatingByAuthor.ItemIndex := RatingByAuthor
    else
      FCutlistInfo.RGRatingByAuthor.ItemIndex := -1;

    FCutlistInfo.CBEPGError.Checked := EPGError;

    if EPGError then
      FCutlistInfo.edtActualContent.Text := ActualContent
    else
      FCutlistInfo.edtActualContent.Text := '';

    FCutlistInfo.CBMissingBeginning.Checked := MissingBeginning;
    FCutlistInfo.CBMissingEnding.Checked    := MissingEnding;
    FCutlistInfo.CBMissingVideo.Checked     := MissingVideo;
    FCutlistInfo.CBMissingAudio.Checked     := MissingAudio;
    FCutlistInfo.CBOtherError.Checked       := OtherError;

    if OtherError then
      FCutlistInfo.edtOtherErrorDescription.Text := OtherErrorDescription
    else
      FCutlistInfo.edtOtherErrorDescription.Text := '';

    FCutlistInfo.edtUserComment.Text := UserComment;
    FCutlistInfo.edtMovieName.Text   := SuggestedMovieName;

    // Server information
    FCutlistInfo.grpServerRating.Enabled := IDOnServer <> '';
    if IDOnServer <> '' then
    begin
      FCutlistInfo.edtRatingOnServer.Text      := IfThen(RatingOnServer < 0, '?', Format('%f', [RatingOnServer]));
      FCutlistInfo.edtRatingCountOnServer.Text := IfThen(RatingCountOnServer < 0, '?', IntToStr(RatingCountOnServer));
      FCutlistInfo.edtDownloadTime.Text        := IfThen(DownloadTime <= 0, '?', FormatDateTime('', UnixToDateTime(DownloadTime)));
      FCutlistInfo.edtRatingSent.Text          := IfThen(RatingSent < 0, '', IntToStr(RatingSent));
    end else
    begin
      FCutlistInfo.edtRatingOnServer.Text      := '';
      FCutlistInfo.edtRatingCountOnServer.Text := '';
      FCutlistInfo.edtDownloadTime.Text        := '';
      FCutlistInfo.edtRatingSent.Text          := '';
    end;

    if FCutlistInfo.ShowModal = mrOK then
    begin
      FHasChanged := True;
      if FCutlistInfo.RGRatingByAuthor.ItemIndex = -1 then
      begin
        RatingByAuthorPresent := False;
        Result := False;
      end else
      begin
        RatingByAuthorPresent := True;
        RatingByAuthor := FCutlistInfo.RGRatingByAuthor.ItemIndex;
        Result := True;
      end;
      EPGError := FCutlistInfo.CBEPGError.Checked;

      if EPGError then
        ActualContent := FCutlistInfo.edtActualContent.Text
      else
        ActualContent := '';

      MissingBeginning := FCutlistInfo.CBMissingBeginning.Checked;
      MissingEnding    := FCutlistInfo.CBMissingEnding.Checked;
      MissingVideo     := FCutlistInfo.CBMissingVideo.Checked;
      MissingAudio     := FCutlistInfo.CBMissingAudio.Checked;
      OtherError       := FCutlistInfo.CBOtherError.Checked;

      if OtherError then
        OtherErrorDescription := FCutlistInfo.edtOtherErrorDescription.Text
      else
        OtherErrorDescription := '';

      UserComment        := FCutlistInfo.edtUserComment.Text;
      SuggestedMovieName := FCutlistInfo.edtMovieName.Text;

      RefreshGUI;
    end;
  end;
end;

function TCutList.FilenameSuggestion: string;
begin
  if FMovieInfo.current_filename <> '' then
    Result := ExtractFileName(FMovieInfo.current_filename) + CUTLIST_EXTENSION
  else
    Result := 'Cutlist_01' + CUTLIST_EXTENSION;
end;

procedure TCutList.FillCutPosArray(var CutPosArray: array of Double);
var
  iCut: Integer;
begin
  Sort;
  for iCut := 0 to Pred(Count) do
  begin
    CutPosArray[iCut * 2]     := Cut[iCut].pos_from;
    CutPosArray[iCut * 2 + 1] := Cut[iCut].pos_to;
  end;
end;

function TCutList.NextCutPos(CurrentPos: Double): Double;
var
  CutPosArray: array of Double;
  iPos: Integer;
begin
  Result := -1;
  SetLength(CutPosArray, Count * 2);
  FillCutPosArray(CutPosArray);
  for iPos := 0 to Pred(2 * Count) do
  begin
    if CutPosArray[iPos] > CurrentPos then
    begin
      Result := CutPosArray[iPos];
      Break;
    end;
  end;
end;

function TCutList.PreviousCutPos(CurrentPos: Double): Double;
var
  CutPosArray: array of Double;
  iPos: Integer;
begin
  Result := -1;
  SetLength(CutPosArray, Count * 2);
  FillCutPosArray(CutPosArray);
  for iPos := Pred(2 * Count) downto 0 do
  begin
    if CutPosArray[iPos] < CurrentPos then
    begin
      Result := CutPosArray[iPos];
      Break;
    end;
  end;
end;

procedure TCutList.RefreshGUI;
begin
  if Assigned(FRefreshCallBack) then
    RefreshCallBack(Self);
end;

function TCutList.GetCut(iCut: Integer): TCut;
begin
  Result := TCut(items[iCut]);
end;

function TCutList.GetChecksum: Cardinal;
var
  s: TMemoryStream;
  iCut: Integer;

  procedure Write(const v : Integer); overload;
  begin
    s.Write(v, SizeOf(v));
  end;
  procedure Write(const v: RCut); overload;
  begin
    s.Write(v, SizeOf(v));
  end;
  procedure Write(const v: PChar; const l: Integer); overload;
  begin
    s.Write(v, l);
  end;
  procedure Write(const v: string); overload;
  begin
    Write(Length(v));
    Write(PChar(v), Length(v));
  end;
begin
  s := TMemoryStream.Create();
  try
    Write(IDOnServer);
    Write(OriginalFileSize);
    Write(Author);
    Write(Count);
    for iCut := 0 to Pred(Count) do
      Write(Cut[iCut].GetData);
    s.Position := 0;
    Result := Crc32_P(s.Memory, s.Size);
  finally
    FreeAndNil(s);
  end;
end;

procedure TCutList.Init;
begin
  Clear;
  FCutlistFile.Clear;

  AppName               := Application_name;
  AppVersion            := Application_version;
  ApplyToFile           := '';
  Comments.Text         := RsCutlistInternalComment;
  FFrameRate            := 0;
  FFrameDuration        := 0;
  FramesPresent         := False;
  SavedToFilename       := '';
  Author                := Fsettings.UserName;
  RatingByAuthorPresent := False;
  RatingByAuthor        := 3;
  EPGError              := False;
  ActualContent         := '';
  MissingBeginning      := False;
  MissingEnding         := False;
  MissingVideo          := False;
  MissingAudio          := False;
  OtherError            := False;
  OtherErrorDescription := '';
  SuggestedMovieName    := '';
  UserComment           := '';
  IDOnServer            := '';
  FRatingOnServer       := -1;
  RatingCountOnServer   := -1;
  RatingSent            := -1;
  OriginalFileSize      := -1;
  FHasChanged           := False;
  DownloadTime          := 0;

  RefreshGUI;
end;

function TCutList.LoadFromFile(FileName: string): Boolean;
begin
  Result := LoadFromFile(FileName, batchmode);
end;

function TCutList.LoadFromFile(FileName: string; noWarnings: Boolean): Boolean;
var
  cutlistfile: TMemIniFileEx;
begin
  if FileExists(FileName) then
  begin
    cutlistfile := TMemIniFileEx.Create(FileName);
    try
      Result := LoadFrom(cutlistfile, noWarnings);
      if Result then
        SavedToFilename := FileName;
    finally
      cutlistfile.Free;
    end;
  end else
  begin
    Result := False;

    if not noWarnings then
      ErrMsgFmt(RsErrorFileNotFound, [FileName]);
  end;
end;

function TCutList.LoadFrom(cutlistfile: TMemIniFileEx; noWarnings: Boolean): Boolean;
var
  section, my_file, intended_options, intendedCutApp, intendedCutAppVersionStr, myCutApp, myOptions: string;
  myCutAppVersionWords, intendedCutAppVersionWords: ARFileVersion;
  iCUt, cCuts, ACut, iFramesDifference: Integer;
  cut: TCut;
  _pos_from, _pos_to: Double;
  _frame_from, _frame_to: Integer;
  CutAppAsfBin: TCutApplicationAsfbin;
  cutChecksum: Cardinal;
begin
  Result := False;

  if Assigned(cutlistfile) and (noWarnings or clear_after_confirm) then
  begin
    Init;
    if FCutlistFile <> cutlistfile then
      FCutlistFile.LoadFromString(cutlistfile.GetDataString());
    if cutlistfile.FileName <> '' then
      SavedToFilename := cutlistfile.FileName;

    section := 'General';
    AppName := cutlistfile.ReadString(section, 'Application', '');
    AppVersion := cutlistfile.ReadString(section, 'Version', '');
    iniReadStrings(cutlistfile, section, 'comment', False, Comments);

    ApplyToFile := cutlistfile.ReadString(section, 'ApplyToFile', Format('(%s)', [RsCutlistTargetUnknown]));
    my_file     := ExtractFileName(FMovieInfo.current_filename);

    if AnsiSameText(ApplyToFile, my_file) or noWarnings or YesNoMsgFmt(RsMsgCutlistTargetMismatch, [ApplyToFile, my_file]) then
    begin
      OriginalFileSize := cutlistfile.ReadInt64(section, 'OriginalFileSizeBytes', -1);
      // App + version
      if CutApplication <> nil then
      begin
        intendedCutApp := cutlistfile.ReadString(section, 'IntendedCutApplication', '');
        intendedCutAppVersionStr := cutlistfile.ReadString(section, 'IntendedCutApplicationVersion', '');
        intendedCutAppVersionWords := Parse_File_Version(intendedCutAppVersionStr);
        myCutApp := ExtractFileName(CutApplication.Path);
        myCutAppVersionWords := Parse_File_Version(CutApplication.Version);

        if (not noWarnings) then
        begin
          if not AnsiSameText(intendedCutApp, myCutApp) then
          begin
            if not YesNoMsgFmt(RsMsgCutlistCutAppMismatch, [IntendedCutApp, myCutApp]) then
              Exit;
          end else
            if (myCutAppVersionWords[0] <> intendedCutAppVersionWords[0]) or (myCutAppVersionWords[1] <> intendedCutAppVersionWords[1]) or (myCutAppVersionWords[2] < intendedCutAppVersionWords[2]) then
            begin
              if not YesNoMsgFmt(RsMsgCutlistCutAppVerMismatch, [IntendedCutApp, intendedCutAppVersionStr, CutApplication.Version]) then
                Exit;
            end;
        end;

        // options for asfbin
        if CutApplication is TCutApplicationAsfbin then
        begin
          CutAppAsfBin := CutApplication as TCutApplicationAsfbin;
          myOptions := CutAppAsfBin.CommandLineOptions;
          intended_options := cutlistfile.ReadString(section, 'IntendedCutApplicationOptions', myOptions);
          if not AnsiSameText(intended_options, myOptions) then
          begin
            if noWarnings or YesNoMsgFmt(RsMsgCutlistAsfbinOptionMismatch, [intended_options, myOptions]) then
              CutAppAsfBin.CommandLineOptions := intended_options;
          end;
        end;
      end;

      // Number of Cuts
      cCuts := cutlistfile.ReadInteger(section, 'NoOfCuts', 0);
      FrameRate := cutlistfile.ReadFloat(section, 'FramesPerSecond', 0);

      if (FrameRate > 0) and (FMovieInfo.frame_duration > 0) then
      begin
        iFramesDifference := FMovieInfo.FrameCount - Trunc(FrameRate * FMovieInfo.current_file_duration);
        if not noWarnings and (Abs(iFramesDifference) > 1) and not NoYesMsgFmt(RsMsgCutlistFrameRateMismatch, [FrameRate, 1 / FMovieInfo.frame_duration, Abs(iFramesDifference)]) then
          FrameDuration := FMovieInfo.frame_duration;
      end else
        FrameDuration := FMovieInfo.frame_duration;

      section := 'Server';
      FRatingOnServer := cutlistfile.ReadFloat(section, 'Rating', -1);
      RatingCountOnServer := cutlistfile.ReadInteger(section, 'RatingCount', -1);
      DownloadTime := cutlistfile.ReadInteger(section, 'DownloadTime', 0);
      RatingSent := cutlistfile.ReadInteger(section, 'RatingSent', -1);
      IDOnServer := cutlistfile.ReadString(section, 'ID', '');
      cutChecksum := StrToInt64Def(cutlistfile.ReadString(section, 'Checksum', ''), 0);

      // info
      section := 'Info';
      Author := cutlistfile.ReadString(section, 'Author', '');
      RatingByAuthor := cutlistfile.ReadInteger(section, 'RatingByAuthor', -1);
      RatingByAuthorPresent := RatingByAuthor <> -1;
      EPGError := cutlistfile.ReadBool(section, 'EPGError', False);

      if EPGError then
        ActualContent := cutlistfile.ReadString(section, 'ActualContent', '')
      else
        ActualContent := '';

      MissingBeginning := cutlistfile.ReadBool(section, 'MissingBeginning', False);
      MissingEnding    := cutlistfile.ReadBool(section, 'MissingEnding', False);
      MissingVideo     := cutlistfile.ReadBool(section, 'MissingVideo', False);
      MissingAudio     := cutlistfile.ReadBool(section, 'MissingAudio', False);
      OtherError       := cutlistfile.ReadBool(section, 'OtherError', False);

      if OtherError then
        OtherErrorDescription := cutlistfile.ReadString(section, 'OtherErrorDescription', '')
      else
        OtherErrorDescription := '';

      SuggestedMovieName := cutlistfile.ReadString(section, 'SuggestedMovieName', '');
      UserComment := cutlistfile.ReadString(section, 'UserComment', '');

      FramesPresent := True;

      for iCut := 0 to Pred(cCuts) do
      begin
        section     := 'Cut' + IntToStr(iCut);
        _pos_from   := cutlistfile.ReadFloat(section, 'Start', 0);
        _pos_to     := _pos_from + cutlistfile.ReadFloat(section, 'Duration', 0) - FrameDuration;
        _Frame_from := cutlistfile.ReadInteger(section, 'StartFrame', -1);
        _Frame_to   := _frame_from + cutlistfile.ReadInteger(section, 'DurationFrames', -1) - 1;

        if cut_times_valid(_pos_from, _pos_to, -1, aCut) then
        begin
          cut := TCut.Create(_pos_from, _pos_to);
          if (_frame_from >= 0) and (_frame_to >= 0) then
          begin
            cut.frame_from := _Frame_from;
            cut.frame_to   := _frame_to;
          end else
            FramesPresent := False;

          Add(cut);
        end;
      end;

      if (cutCheckSum = 0) or (cutChecksum <> GetChecksum) then // Remove server and rating information, if changed
        IDOnServer := '';

      FMode       := clmTrim;
      FHasChanged := False;
      Result      := True;

      if not noWarnings then
        InfMsgFmt(RsMsgCutlistLoaded, [Count, cCuts]);

      RefreshGUI;
    end;
  end;
end;

function TCutList.Save(AskForPath: Boolean): Boolean;
var
  cutlist_path, target_file: string;
  saveDlg: TSaveDialog;
begin
  Result := False;

  if Count > 0 then
  begin
    if SavedToFilename = '' then
    begin
      case FSettings.SaveCutlistMode of
        smWithSource : cutlist_path := ExtractFilePath(FMovieInfo.current_filename);           // with source
        smGivenDir   : cutlist_path := IncludeTrailingPathDelimiter(FSettings.CutlistSaveDir); // in given Dir
        else           cutlist_path := ExtractFilePath(FMovieInfo.current_filename);           // with source
      end;
      target_file := cutlist_path + FilenameSuggestion;
    end else
      target_file := SavedToFilename;

    if (SavedToFilename = '') or AskForPath then
    begin
      // Display Save Dialog?
      AskForPath := AskForPath or FSettings.CutlistNameAlwaysConfirm;

      if FileExists(target_File) and (not AskForPath) and NoYesWarnMsgFmt(RsWarnTargetExistsOverwrite, [target_file]) then
        AskForPath := True;

      if AskForPath then
      begin
        saveDlg := TSaveDialog.Create(Application.MainForm);
        saveDlg.Filter := MakeFilterString(RsFilterDescriptionCutlists, '*' + CUTLIST_EXTENSION) + '|' + MakeFilterString(RsFilterDescriptionAll, '*.*');
        saveDlg.FilterIndex := 1;
        saveDlg.Title := RsSaveCutlistAs;
        saveDlg.InitialDir := cutlist_path;
        saveDlg.FileName := FilenameSuggestion;
        saveDlg.DefaultExt := CUTLIST_EXT;
        saveDlg.Options := saveDlg.Options + [ofOverwritePrompt, ofPathMustExist];
        if saveDlg.Execute then
        begin
          target_file := saveDlg.FileName;
          FreeAndNil(saveDlg);
        end else
        begin
          FreeAndNil(saveDlg);
          Exit;
        end;
      end;

      cutlist_path := ExtractFilePath(target_file);

      if not ForceDirectories(cutlist_path) then
      begin
        if not batchmode then
          ErrMsgFmt(RsErrorCreatePathFailedAbort, [cutlist_path]);
        Exit;
      end;

      if FileExists(target_File) then
      begin
        if not deletefile(target_file) then
        begin
          ErrMsgFmt(RsCouldNotDeleteFile, [target_file]);
          Exit;
        end;
      end;
    end;

    Result := SaveAs(target_file);
  end else
    InfMsg(RsNoCutsDefined);
end;

function TCutList.SaveAs(FileName: string): Boolean;
var
  AdjustFileInfo: Boolean;
  DoRefresh: Boolean;
begin
  Result := False;

  if RatingByAuthorPresent or EditInfo then
  begin
    AdjustFileInfo := False;
    DoRefresh      := False;

    if HasChanged then
    begin
      if Author = '' then
      begin
        Author     := Fsettings.UserName;
        IDOnServer := '';
        DoRefresh  := True;
      end else
      begin
        if Author <> Fsettings.UserName then
        begin
          if YesNoMsgFmt(RsMsgCutlistReplaceAuthor, [Author]) then
          begin
            Author     := Fsettings.UserName;
            IDOnServer := '';
            DoRefresh  := True;
          end;
        end;
        if (not AnsiSameText(ApplyToFile, ExtractFileName(FMovieInfo.current_filename)))
          or (OriginalFileSize <> FMovieInfo.current_filesize) then
        begin
          if (OriginalFileSize < 0) or (ApplyToFile = '') or YesNoMsgFmt(RsMsgCutlistReplaceFileInfo, [ApplyToFile, OriginalFileSize]) then
          begin
            AdjustFileInfo := True;
            DoRefresh      := True;
          end;
        end;
      end;
    end;

    if AdjustFileInfo or (ApplyToFile = '') then
    begin
      ApplyToFile := ExtractFileName(FMovieInfo.current_filename);
      DoRefresh   := True;
    end;

    if AdjustFileInfo or (OriginalFileSize < 0) then
    begin
      OriginalFileSize := FMovieInfo.current_filesize;
      DoRefresh        := True;
    end;

    if AdjustFileInfo or (FrameRate = 0) or (FrameDuration = 0) then
    begin
      FrameDuration := FMovieInfo.frame_duration;
      DoRefresh     := True;
    end;

    if DoRefresh then
      RefreshGUI;

    Result := StoreTo(FCutlistFile);

    if Result then
    begin
      FCutlistFile.SaveToFile(FileName);
      SavedToFilename := FileName;
    end;
  end;
end;

function TCutList.StoreTo(cutlistfile: TMemIniFileEx): Boolean; // True if saved successfully
var
  section: string;
  iCut, writtenCuts: Integer;
  convertedCutlist: TCutList;
  CutApplication: TCutApplicationBase;
begin
  Result := False;
  if Assigned(cutlistfile) then
  begin
    if Mode = clmTrim then
    begin
      Sort;

      section := 'General';
      cutlistfile.WriteString(section, 'Application', Application_name);
      cutlistfile.WriteString(section, 'Version', Application_version);
      iniWriteStrings(cutlistfile, section, 'comment', False, Comments);
      cutlistfile.WriteString(section, 'ApplyToFile', ApplyToFile);
      cutlistfile.WriteInt64(section, 'OriginalFileSizeBytes', OriginalFileSize);
      cutlistfile.WriteFloat(section, 'FramesPerSecond', FrameRate);

      // ToDo: do not change contents of cutlist here, use existing values
      // if possible!
      CutApplication := FSettings.GetCutApplicationByMovieType(FMovieInfo.MovieType);
      if Assigned(CutApplication) then
      begin
        CutApplication.WriteCutlistInfo(CutlistFile, section);
      end else
      begin
        cutlistfile.DeleteKey(section, 'IntendedCutApplication');
        cutlistfile.DeleteKey(section, 'IntendedCutApplicationVersion');
        cutlistfile.DeleteKey(section, 'IntendedCutApplicationOptions');
        cutlistfile.DeleteKey(section, 'CutCommandLine');
      end;

      section := 'Info';
      if RatingByAuthorPresent then
        cutlistfile.WriteInteger(section, 'RatingByAuthor', RatingByAuthor)
      else
        cutlistfile.DeleteKey(section, 'RatingByAuthor');

      cutlistfile.WriteString(section, 'Author', Author);
      cutlistfile.WriteBool(section, 'EPGError', EPGError);
      cutlistfile.WriteString(section, 'ActualContent', ActualContent);
      cutlistfile.WriteBool(section, 'MissingBeginning', MissingBeginning);
      cutlistfile.WriteBool(section, 'MissingEnding', MissingEnding);
      cutlistfile.WriteBool(section, 'MissingVideo', MissingVideo);
      cutlistfile.WriteBool(section, 'MissingAudio', MissingAudio);
      cutlistfile.WriteBool(section, 'OtherError', OtherError);
      cutlistfile.WriteString(section, 'OtherErrorDescription', OtherErrorDescription);
      cutlistfile.WriteString(section, 'SuggestedMovieName', SuggestedMovieName);
      cutlistfile.WriteString(section, 'UserComment', UserComment);

      SaveServerInfos(cutlistfile);

      RemoveCutSections(cutlistfile);

      writtenCuts := 0;
      for iCut := 0 to Pred(Count) do
      begin
        section := 'Cut' + IntToStr(writtenCuts);
        Inc(writtenCuts);
        cutlistfile.WriteFloat(section, 'Start', Cut[iCut].pos_from);
        cutlistfile.WriteFloat(section, 'Duration', Cut[iCut].pos_to - Cut[iCut].pos_from + FMovieInfo.frame_duration);
        if FramesPresent then
        begin
          cutlistfile.WriteInteger(section, 'StartFrame', Cut[iCut].frame_from);
          cutlistfile.WriteInteger(section, 'DurationFrames', Cut[iCut].DurationFrames)
        end;
      end;
      cutlistfile.WriteInteger('General', 'NoOfCuts', writtenCuts);
      Result := True;

      if FHasChanged then
        FHasChanged := False;
    end else
    begin
      ConvertedCutlist := Convert;
      try
        Result := ConvertedCutlist.StoreTo(cutlistfile);
        FHasChanged := ConvertedCutlist.HasChanged;
        IDOnServer := convertedCutlist.IDOnServer;
      finally
        FreeAndNil(ConvertedCutlist);
      end;
    end;
  end;
end;

function TCutList.SaveServerInfos(cutlistfile: TMemIniFileEx): Boolean;
var
  section: string;
begin
  section := 'Server';
  cutlistfile.EraseSection(section);
  if IDOnServer <> '' then
  begin
    cutlistfile.WriteString(section, 'ID', IDOnServer);
    cutlistfile.WriteFloat(section, 'Rating', RatingOnServer);
    cutlistfile.WriteInteger(section, 'RatingCount', RatingCountOnServer);
    cutlistfile.WriteInteger(section, 'DownloadTime', DownloadTime);
    cutlistfile.WriteString(section, 'Checksum', IntToStr(GetChecksum));
  end;

  Result := IDOnServer <> '';
end;

function TCutList.AddServerInfos(FileName: string): Boolean;
var
  cutlistfile: TMemIniFileEx;
begin
  cutlistfile := TMemIniFileEx.Create(FileName);
  try
    Result := SaveServerInfos(cutlistfile);
    cutlistfile.UpdateFile;
  finally
    FreeAndNil(cutlistfile);
  end;
end;

procedure TCutList.RemoveCutSections(cutlistfile: TMemIniFileEx);
var
  sections: TStringList;
  sectionNumber: Integer;
  idx: Integer;
begin
  if Assigned(cutlistfile) then
  begin
    sections := TStringList.Create;
    try
      cutlistfile.ReadSections(sections);
      for idx := 0 to Pred(sections.Count) do
      begin
        if AnsiStartsText('Cut', sections.Strings[idx]) and TryStrToInt(Copy(sections.Strings[idx], 4, MaxInt), sectionNumber) then
          cutlistfile.EraseSection(sections.Strings[idx]);
      end;
    finally
      sections.Free;
    end;
  end;
end;

procedure TCutList.SetIDOnServer(const Value: string);
begin
  FIDOnServer := Value;
  if Value = '' then
  begin
    RatingSent          := -1;
    FRatingOnServer     := -1;
    RatingCountOnServer := -1;
    DownloadTime        := 0;
    // ToDO: Clear other dependent values
  end;
end;

procedure TCutList.SetMode(const Value: TCutlistMode);
begin
  if Mode <> Value then
  begin
    FMode := Value;
    RefreshGUI;
  end;
end;

procedure TCutList.SetSuggestedMovieName(const Value: string);
begin
  FSuggestedMovieName := AnsiReplaceStr(Value, '"', '''');
end;

procedure TCutList.Sort;
begin
  inherited Sort(@CutlistCompareItems);
end;

function TCutList.TotalDurationOfCuts: Double;
var
  iCut: Integer;
begin
  Result := 0;
  for iCut := 0 to Pred(Count) do
    Result := Result + Cut[iCut].pos_to - Cut[iCut].pos_from;
end;

function TCutList.UserShouldSendRating: Boolean;
begin
  Result := (RatingSent = -1) and (IDOnServer > '');
end;

end.

