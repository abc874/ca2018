UNIT UCutlist;

INTERFACE

USES
  Classes,
  Contnrs,
  Settings_dialog,
  Movie,
  Utils,
  UCutApplicationBase;

CONST
  CUTLIST_EXTENSION                = '.cutlist';

TYPE
  TCutlist = CLASS;

  RCut = RECORD
    pos_from, pos_to: double;
    frame_from, frame_to: integer;
  END;

  Tcut = CLASS
  PRIVATE
    Fpos_from, Fpos_to: double;
    Fframe_from, Fframe_to: integer;
  PUBLIC
    CONSTRUCTOR Create(pos_from, pos_to: double); OVERLOAD;
    CONSTRUCTOR Create(pos_from, pos_to: double; frame_from, frame_to: integer); OVERLOAD;
    PROPERTY pos_from: double READ Fpos_from WRITE Fpos_from;
    PROPERTY pos_to: double READ Fpos_to WRITE Fpos_to;
    PROPERTY frame_from: integer READ Fframe_from WRITE Fframe_from;
    PROPERTY frame_to: integer READ Fframe_to WRITE Fframe_to;
    FUNCTION DurationFrames: integer;
    CLASS FUNCTION Compare(CONST Item1, Item2: TCut): Integer;
    FUNCTION GetData: RCut;
  END;

  TCutlistMode = (clmCutOut, clmTrim);
  TCutlistSaveMode = (csmNeverAsk, csmAskBeforeOverwrite, csmAskWhenSavingFirstTime, csmAlwaysAsk);
  TCutlistSearchType = (cstBySize, cstByName);
  TCutlistSearchTypes = SET OF TCutlistSearchType;
  TCutlistServerCommand = (cscRate, cscDelete, cscUpload);

  TCutlistCallBackMethod = PROCEDURE(cutlist: TCutlist) OF OBJECT;

  TCutlist = CLASS(TObjectList)
  PRIVATE
    FSettings: TSettings;
    FMovieInfo: TMovieInfo;
    FIDOnServer: STRING;
    FRatingOnServer: double;
    FHasChanged: boolean;
    FRefreshCallBack: TCutlistCallBackMethod;
    FMode: TCutlistMode;
    FSuggestedMovieName: STRING;
    FFrameDuration, FFrameRate: double;
    FCutlistFile: TMemIniFileEx;
    FUNCTION GetCut(iCut: Integer): TCut;
    PROCEDURE SetIDOnServer(CONST Value: STRING);
    PROCEDURE FillCutPosArray(VAR CutPosArray: ARRAY OF double);
    PROCEDURE SetRefreshCallBack(CONST Value: TCutlistCallBackMethod);
    PROCEDURE SetMode(CONST Value: TCutlistMode);
    PROCEDURE SetSuggestedMovieName(CONST Value: STRING);
    FUNCTION CutApplication: TCutApplicationBase;
    PROCEDURE SetFrameDuration(d: double);
    PROCEDURE SetFrameRate(d: double);
    FUNCTION SaveServerInfos(cutlistfile: TMemIniFileEx): boolean;
    PROCEDURE RemoveCutSections(cutlistfile: TMemIniFileEx);
    FUNCTION FindCutLinear(fPos: double): integer;
    FUNCTION FindCutBinary(fPos: double): integer;
  PUBLIC
    AppName, AppVersion: STRING;
    ApplyToFile: STRING;
    Comments: TStrings;
    //Info
    RatingByAuthor: Integer;
    RatingByAuthorPresent: boolean;
    EPGError,
      MissingBeginning, MissingEnding,
      MissingVideo, MissingAudio,
      OtherError: boolean;
    ActualContent, OtherErrorDescription,
      UserComment, Author: STRING;

    FramesPresent: boolean;
    SavedToFilename: STRING;
    RatingSent: integer;
    OriginalFileSize: longint;
    RatingCountOnServer: integer;
    DownloadTime: Int64;

    CONSTRUCTOR create(Settings: TSettings; MovieInfo: TMovieInfo);
    DESTRUCTOR Destroy; OVERRIDE;
    PROPERTY FrameDuration: double READ FFrameDuration WRITE SetFrameDuration;
    PROPERTY FrameRate: double READ FFrameRate WRITE SetFrameRate;
    PROPERTY RefreshCallBack: TCutlistCallBackMethod READ FRefreshCallBack WRITE SetRefreshCallBack;
    PROCEDURE RefreshGUI;
    PROPERTY Cut[iCut: Integer]: TCut READ GetCut; DEFAULT;
    FUNCTION FindCutIndex(fPos: double): integer;
    FUNCTION FindCut(fPos: double): TCut;
    FUNCTION AddCut(pos_from, pos_to: double): boolean;
    FUNCTION ReplaceCut(pos_from, pos_to: double; CutToReplace: integer): boolean;
    FUNCTION SplitCut(pos_from, pos_to: double): boolean;
    FUNCTION DeleteCut(dCut: Integer): boolean;
    PROPERTY Mode: TCutlistMode READ FMode WRITE SetMode;

    PROPERTY IDOnServer: STRING READ FIDOnServer WRITE SetIDOnServer;
    PROPERTY HasChanged: boolean READ FHasChanged;
    FUNCTION UserShouldSendRating: boolean;
    FUNCTION CutCommand: STRING;
    FUNCTION cut_times_valid(VAR pos_from, pos_to: double; do_not_test_cut: integer; VAR interfering_cut: integer): boolean;
    FUNCTION FilenameSuggestion: STRING;
    PROPERTY SuggestedMovieName: STRING READ FSuggestedMovieName WRITE SetSuggestedMovieName;
    FUNCTION TotalDurationOfCuts: double;
    FUNCTION NextCutPos(CurrentPos: double): double;
    FUNCTION PreviousCutPos(CurrentPos: double): double;

    FUNCTION clear_after_confirm: boolean;
    PROCEDURE init;
    PROCEDURE Sort;
    FUNCTION Convert: TCutlist;
    FUNCTION LoadFromFile(Filename: STRING; noWarnings: boolean): boolean; OVERLOAD;
    FUNCTION LoadFromFile(Filename: STRING): boolean; OVERLOAD;
    FUNCTION EditInfo: boolean;
    FUNCTION Save(AskForPath: boolean): boolean; OVERLOAD;
    FUNCTION SaveAs(Filename: STRING): boolean;

    FUNCTION GetChecksum: Cardinal;

    FUNCTION LoadFrom(cutlistfile: TMemIniFileEx; noWarnings: boolean): boolean;
    FUNCTION StoreTo(cutlistfile: TMemIniFileEx): boolean; OVERLOAD;

    PROPERTY RatingOnServer: double READ FRatingOnServer WRITE FRatingOnServer;
    FUNCTION AddServerInfos(Filename: STRING): boolean;
  END;


IMPLEMENTATION

USES
  Forms,
  windows,
  dialogs,
  sysutils,
  cutlistINfo_dialog,
  controls,
  iniFiles,
  strutils,
  UCutApplicationAsfbin,
  UCutApplicationMP4Box,
  DateUtils,
  JclMath,
  CAResources;

{ Tcut }

CONSTRUCTOR Tcut.Create(pos_from, pos_to: double);
BEGIN
  Create(pos_from, pos_to, 0, 0);
END;

CONSTRUCTOR Tcut.Create(pos_from, pos_to: double; frame_from, frame_to: integer);
BEGIN
  IF pos_from > pos_to THEN
    RAISE Exception.CreateFmt('Invalid Range: %f - %f', [pos_from, pos_to]);
  IF frame_from > frame_to THEN
    RAISE Exception.CreateFmt('Invalid frame range: %d - %d', [frame_from, frame_to]);

  Fpos_from := pos_from;
  Fpos_to := pos_to;
  Fframe_from := frame_from;
  Fframe_to := frame_to;
END;

FUNCTION Tcut.DurationFrames: integer;
BEGIN
  result := self.frame_to - self.frame_from + 1;
END;

CLASS FUNCTION Tcut.Compare(CONST Item1, Item2: TCut): Integer;
BEGIN
  IF Assigned(Item1) <> Assigned(Item2) THEN BEGIN
    IF Assigned(Item1) THEN Result := 1
    ELSE Result := -1;
  END ELSE BEGIN
    IF NOT Assigned(Item1) THEN Result := 0
    ELSE IF Item1.pos_from < Item2.pos_from THEN Result := -1
    ELSE IF Item1.pos_from > Item2.pos_from THEN Result := 1
    ELSE IF Item1.pos_to < Item2.pos_to THEN Result := -1
    ELSE IF Item1.pos_to > Item2.pos_to THEN Result := 1
    ELSE Result := 0;
  END;
END;

FUNCTION TCut.GetData: RCut;
BEGIN
  Result.pos_from := Fpos_from;
  Result.pos_to := Fpos_to;
  Result.frame_from := Fframe_from;
  Result.frame_to := Fframe_to;
END;

{ TCutlist }

PROCEDURE TCutlist.SetFrameDuration(d: double);
BEGIN
  IF d < 0 THEN d := 0;
  FFrameDuration := d;
  IF d > 0 THEN FFrameRate := 1 / d
  ELSE FFrameRate := 0;
END;

PROCEDURE TCutlist.SetFrameRate(d: double);
BEGIN
  IF d < 0 THEN d := 0;
  FFrameRate := d;
  IF d > 0 THEN FFrameDuration := 1 / d
  ELSE FFrameDuration := 0;
END;

FUNCTION TCutlist.FindCutIndex(fPos: double): integer;
BEGIN
  //Result := FindCutBinary(fPos);
  Result := FindCutLinear(fPos);
END;

FUNCTION TCutlist.FindCut(fPos: double): TCut;
VAR
  idx                              : integer;
BEGIN
  Result := NIL;
  idx := FindCutIndex(fPos);
  IF idx >= 0 THEN
    Result := self.Cut[idx];
END;

FUNCTION TCutlist.FindCutLinear(fPos: double): integer;
VAR
  iCount                           : Integer;
  iCut                             : Integer;
  ACut                             : TCut;
BEGIN
  Result := -1;
  iCount := self.Count;
  IF iCount < 1 THEN
    exit;
  iCut := 0;
  REPEAT
    ACut := self.Cut[iCut];
    IF fPos >= ACut.pos_from THEN
      IF fPos <= ACut.pos_to THEN
        Result := iCut;
    Inc(iCut);
  UNTIL (iCut >= iCount) OR (Result >= 0);
END;

FUNCTION TCutlist.FindCutBinary(fPos: double): integer;
VAR
  iCount                           : Integer;
  iCut                             : Integer;
  iStep                            : Integer;
  ACut                             : TCut;
BEGIN
  Result := -1;
  iCount := self.Count;
  IF iCount < 1 THEN
    exit;
  iStep := iCount DIV 2;
  iCut := iStep;
  REPEAT
    ACut := self.Cut[iCut];
    IF ACut.pos_from > fPos THEN BEGIN
      iCut := iCut - iStep;
      IF iCut < 0 THEN
        break;
    END ELSE IF ACut.pos_to < fPos THEN BEGIN
      iCut := iCut + iStep;
      IF iCut >= iCount THEN
        break;
    END ELSE BEGIN
      Result := iCut;
    END;
    iStep := iStep DIV 2;
  UNTIL (iStep = 0) OR (Result >= 0);
END;

FUNCTION TCutlist.AddCut(pos_from, pos_to: double): boolean;
VAR
  icut                             : integer;
BEGIN
  result := false;
  IF NOT cut_times_valid(pos_from, pos_to, -1, iCut) THEN
    Exit;

  self.Add(Tcut.Create(pos_from, pos_to));
  self.FHasChanged := true;
  self.IDOnServer := '';
  self.FramesPresent := false;
  result := true;

  self.Sort;
  self.RefreshGUI;
END;

FUNCTION TCutlist.ReplaceCut(pos_from, pos_to: double;
  CutToReplace: integer): boolean;
VAR
  icut                             : integer;
BEGIN
  result := false;
  IF NOT cut_times_valid(pos_from, pos_to, CutToReplace, iCut) THEN
    Exit;

  self[CutToReplace].pos_from := pos_from;
  self[CutToReplace].pos_to := pos_to;
  self.FHasChanged := true;
  self.IDOnServer := '';
  self.FramesPresent := false;
  result := true;

  self.Sort;
  self.RefreshGUI;
END;

FUNCTION TCutlist.SplitCut(pos_from, pos_to: double): boolean;
VAR
  LeftIndex, RightIndex            : integer;
  LeftPos, RightPos                : double;
BEGIN
  Result := false;
  IF pos_to <= pos_from THEN
    exit;
  IF (pos_from > FMovieInfo.current_file_duration) OR (pos_to < 0) THEN
    exit;

  LeftIndex := FindCutIndex(pos_from);
  RightIndex := FindCutIndex(pos_to);
  IF LeftIndex = RightIndex THEN BEGIN
    IF LeftIndex < 0 THEN BEGIN
      Result := self.AddCut(pos_from, pos_to);
    END ELSE BEGIN
      LeftPos := self.Cut[LeftIndex].pos_from;
      RightPos := self.Cut[LeftIndex].pos_to;
      Result := Self.DeleteCut(LeftIndex);
      Result := Result AND self.AddCut(LeftPos, pos_from);
      Result := Result AND self.AddCut(pos_to, RightPos);
    END;
  END;
END;

FUNCTION TCutlist.DeleteCut(dCut: Integer): boolean;
BEGIN
  self.Delete(dCut);
  self.FHasChanged := true;
  self.IDOnServer := '';
  result := true;
  self.RefreshGUI;
END;

FUNCTION TCutlist.clear_after_confirm: boolean;
//true if cleared, false if cancelled
VAR
  CanClear                         : boolean;
BEGIN
  canClear := true;
  IF NOT batchmode AND self.HasChanged THEN BEGIN
    CASE application.messagebox(PChar(CAResources.RsMsgCutlistSaveChanges), PChar(CAResources.RsTitleCutlistSaveChanges), MB_YESNOCANCEL + MB_DEFBUTTON3 + MB_ICONQUESTION) OF
      IDYES: BEGIN
          CanClear := self.Save(false); //Can Clear if saved successfully
        END;
      IDNO: BEGIN
          CanClear := true;
        END;
    ELSE BEGIN
        CanClear := false;
      END;
    END;
  END;
  IF CanClear THEN BEGIN
    self.init;
  END;
  result := CanClear;
END;

FUNCTION TCutlist.Convert: TCutlist;
VAR
  newCutlist                       : TcutLIst;
  iCut                             : integer;
  pos_Prev                         : double;
  Frame_prev                       : integer;
  curCut, newCut                   : TCut;
  PROCEDURE AddCut(_pos_from, _pos_to: double; _frame_from, _frame_to: integer);
  BEGIN
    IF _pos_from < _pos_to THEN BEGIN
      IF self.FramesPresent AND (_frame_from <= _frame_to) THEN BEGIN
        newCut := TCut.Create(_pos_from, _pos_to,
          _frame_from, _frame_to);
      END ELSE BEGIN
        newCut := TCut.Create(_pos_from, _pos_to);
        newCutlist.FramesPresent := false;
      END;
      newCutlist.Add(newCut);
    END;
  END;
BEGIN
  newCutlist := TCutlist.Create(FSettings, FMovieInfo);
  newCutlist.FFrameRate := self.FFrameRate;
  newCutlist.FFrameDuration := self.FFrameDuration;
  newCutlist.FramesPresent := self.FramesPresent;
  newCutlist.SavedToFilename := self.SavedToFilename;
  newCutlist.Author := self.Author;
  newCutlist.RatingByAuthorPresent := self.RatingByAuthorPresent;
  newCutlist.RatingByAuthor := self.RatingByAuthor;
  newCutlist.EPGError := self.EPGError;
  newCutlist.ActualContent := self.ActualContent;
  newCutlist.MissingBeginning := self.MissingBeginning;
  newCutlist.MissingEnding := self.MissingEnding;
  newCutlist.MissingVideo := self.MissingVideo;
  newCutlist.MissingAudio := self.MissingAudio;
  newCutlist.OriginalFileSize := self.OriginalFileSize;
  newCutlist.OtherError := self.OtherError;
  newCutlist.OtherErrorDescription := self.OtherErrorDescription;
  newCutlist.SuggestedMovieName := self.SuggestedMovieName;
  newCutlist.UserComment := self.UserComment;
  newCutlist.FRatingOnServer := self.RatingOnServer;
  newCutlist.RatingCountOnServer := self.RatingCountOnServer;
  newCutlist.RatingSent := self.RatingSent;
  newCutlist.DownloadTime := self.DownloadTime;
  IF self.Mode = clmCutOut THEN
    newcutlist.FMode := clmTrim
  ELSE
    newcutlist.FMode := clmCutOut;

  IF self.Count > 0 THEN BEGIN
    self.Sort;
    pos_prev := 0;
    Frame_prev := 0;
    FOR iCut := 0 TO self.Count - 1 DO BEGIN
      curCut := self[iCut];
      AddCut(pos_prev, curCut.pos_from - FrameDuration,
        frame_prev, curCut.frame_from - 1);
      pos_prev := curCut.pos_to + FrameDuration;
      frame_prev := curCut.frame_to + 1;
    END;

    //rest to End of File
    AddCut(pos_prev, self.FMovieInfo.current_file_duration,
      frame_prev, round(self.FMovieInfo.current_file_duration * FrameRate)); // this could be more accurate
  END;

  newCutlist.Sort;
  newCutlist.FHasChanged := self.HasChanged;
  newCutlist.IDOnServer := self.IDOnServer;

  result := newcutlist;
END;

CONSTRUCTOR TCutlist.create(Settings: TSettings; MovieInfo: TMovieInfo);
BEGIN
  INHERITED create;
  FSettings := Settings;
  FMovieInfo := MovieInfo;
  Comments := TStringList.Create;
  FCutlistFile := TMemIniFileEx.Create('');
  self.init;
END;

DESTRUCTOR TCutlist.Destroy;
BEGIN
  FreeAndNil(Comments);
  FreeAndNil(FCutlistFile);
END;

FUNCTION TCutlist.CutApplication: TCutApplicationBase;
BEGIN
  result := FSettings.GetCutApplicationByMovieType(FMovieInfo.MovieType);
END;

FUNCTION TCutlist.CutCommand: STRING;
VAR
  command                          : STRING;
  iCut                             : integer;
  ConvertedCutlist                 : TCutlist;
BEGIN
  IF self.Count = 0 THEN BEGIN
    ShowMessage(CAResources.RsMsgCutlistNoCutsDefined);
    result := '';
    exit;
  END;

  IF self.Mode = clmTrim THEN BEGIN
    command := '';
    self.sort;
    FOR iCut := 0 TO self.Count - 1 DO BEGIN
      command := command + ' -start ' + FMovieInfo.FormatPosition(self[iCut].pos_from);
      command := command + ' -duration ' + FMovieInfo.FormatPosition(self[iCut].pos_to - self[iCut].pos_from);
    END;
  END ELSE BEGIN
    ConvertedCutlist := self.convert;
    command := ConvertedCutlist.CutCommand;
    FreeAndNIL(ConvertedCutlist);
  END;

  result := command;
END;

FUNCTION TCutlist.cut_times_valid(VAR pos_from, pos_to: double;
  do_not_test_cut: integer; VAR interfering_cut: integer): boolean;
VAR
  icut                             : integer;
BEGIN
  result := false;

  IF pos_to <= pos_from THEN exit;
  IF (pos_from > FMovieInfo.current_file_duration) OR (pos_to < 0) THEN exit;
  IF pos_from < 0 THEN pos_from := 0;
  IF pos_to > FMovieInfo.current_file_duration THEN BEGIN
    pos_to := FMovieInfo.current_file_duration;
  END;

  FOR iCut := 0 TO self.Count - 1 DO BEGIN
    IF iCut <> do_not_test_cut THEN BEGIN
      IF NOT ((pos_from > self[iCut].pos_to) OR (pos_to < self[iCut].pos_from)) THEN BEGIN
        ShowMessageFmt(CAResources.RsErrorCutlistCutOverlap, [icut]);
        interfering_cut := icut;
        exit;
      END;
    END;
  END;
  result := true;
END;

FUNCTION TCutlist.EditInfo: boolean;
BEGIN
  Result := false;

  IF FCutlistInfo.Visible THEN
    exit;

  FCutlistInfo.original_movie_filename := FMovieInfo.current_filename;
  FCutlistInfo.CBFramesPresent.Checked := (self.FramesPresent AND NOT self.HasChanged);
  FCutlistInfo.lblFrameRate.Caption := FMovieInfo.FormatFrameRate(self.FrameDuration, 'C');
  IF self.Author = '' THEN
    FCutlistInfo.lblAuthor.Caption := CAResources.RsCaptionCutlistAuthorUnknown
  ELSE
    FCutlistInfo.lblAuthor.Caption := Format(CAResources.RsCaptionCutlistAuthor, [self.Author]);
  IF self.RatingByAuthorPresent THEN
    FCutlistInfo.RGRatingByAuthor.ItemIndex := self.RatingByAuthor
  ELSE
    FCutlistInfo.RGRatingByAuthor.ItemIndex := -1;
  FCutlistInfo.CBEPGError.Checked := self.EPGError;
  IF self.EPGError THEN
    FCutlistInfo.edtActualContent.Text := self.ActualContent
  ELSE
    FCutlistInfo.edtActualContent.Text := '';
  FCutlistInfo.CBMissingBeginning.Checked := self.MissingBeginning;
  FCutlistInfo.CBMissingEnding.Checked := self.MissingEnding;
  FCutlistInfo.CBMissingVideo.Checked := self.MissingVideo;
  FCutlistInfo.CBMissingAudio.Checked := self.MissingAudio;
  FCutlistInfo.CBOtherError.Checked := self.OtherError;
  IF self.OtherError THEN
    FCutlistInfo.edtOtherErrorDescription.Text := self.OtherErrorDescription
  ELSE
    FCutlistInfo.edtOtherErrorDescription.Text := '';
  FCutlistInfo.edtUserComment.Text := self.UserComment;
  FCutlistInfo.edtMovieName.Text := self.SuggestedMovieName;

  // Server information
  FCutlistInfo.grpServerRating.Enabled := self.IDOnServer <> '';
  IF self.IDOnServer <> '' THEN BEGIN
    FCutlistInfo.edtRatingOnServer.Text := IfThen(self.RatingOnServer < 0, '?', Format('%f', [self.RatingOnServer]));
    FCutlistInfo.edtRatingCountOnServer.Text := IfThen(self.RatingCountOnServer < 0, '?', IntToStr(self.RatingCountOnServer));
    FCutlistInfo.edtDownloadTime.Text := IfThen(self.DownloadTime <= 0, '?', FormatDateTime('', UnixToDateTime(self.DownloadTime)));
    FCutlistInfo.edtRatingSent.Text := IfThen(self.RatingSent < 0, '', IntToStr(self.RatingSent));
  END ELSE BEGIN
    FCutlistInfo.edtRatingOnServer.Text := '';
    FCutlistInfo.edtRatingCountOnServer.Text := '';
    FCutlistInfo.edtDownloadTime.Text := '';
    FCutlistInfo.edtRatingSent.Text := '';
  END;

  IF FCutlistInfo.ShowModal = mrOK THEN BEGIN
    self.FHasChanged := true;
    IF FCutlistInfo.RGRatingByAuthor.ItemIndex = -1 THEN BEGIN
      self.RatingByAuthorPresent := false;
      result := false;
    END ELSE BEGIN
      self.RatingByAuthorPresent := true;
      self.RatingByAuthor := FCutlistInfo.RGRatingByAuthor.ItemIndex;
      result := true;
    END;
    self.EPGError := FCutlistInfo.CBEPGError.Checked;
    IF self.EPGError THEN
      self.ActualContent := FCutlistInfo.edtActualContent.Text
    ELSE
      self.ActualContent := '';
    self.MissingBeginning := FCutlistInfo.CBMissingBeginning.Checked;
    self.MissingEnding := FCutlistInfo.CBMissingEnding.Checked;
    self.MissingVideo := FCutlistInfo.CBMissingVideo.Checked;
    self.MissingAudio := FCutlistInfo.CBMissingAudio.Checked;
    self.OtherError := FCutlistInfo.CBOtherError.Checked;
    IF self.OtherError THEN
      self.OtherErrorDescription := FCutlistInfo.edtOtherErrorDescription.Text
    ELSE
      self.OtherErrorDescription := '';
    self.UserComment := FCutlistInfo.edtUserComment.Text;
    self.SuggestedMovieName := FCutlistInfo.edtMovieName.Text;

    self.RefreshGUI;
  END ELSE BEGIN
    result := false;
  END;
END;

FUNCTION TCutlist.FilenameSuggestion: STRING;
BEGIN
  IF FMovieInfo.current_filename <> '' THEN BEGIN
    result := ChangeFileExt(extractfilename(FMovieInfo.current_filename), cutlist_Extension);
  END ELSE
    result := 'Cutlist_01' + CUTLIST_EXTENSION;
END;

PROCEDURE TCutlist.FillCutPosArray(VAR CutPosArray: ARRAY OF double);
VAR
  iCut                             : integer;
BEGIN
  self.sort;
  FOR iCut := 0 TO self.Count - 1 DO BEGIN
    CutPosArray[iCut * 2] := self.Cut[iCut].pos_from;
    CutPosArray[iCut * 2 + 1] := self.Cut[iCut].pos_to;
  END;
END;

FUNCTION TCutlist.NextCutPos(CurrentPos: double): double;
VAR
  CutPosArray                      : ARRAY OF double;
  iPos                             : integer;
BEGIN
  result := -1;
  setlength(CutPosArray, self.Count * 2);
  self.FillCutPosArray(CutPosArray);
  FOR iPos := 0 TO 2 * self.Count - 1 DO BEGIN
    IF CutPosArray[iPos] > CurrentPos THEN BEGIN
      result := CutPosArray[iPos];
      break;
    END;
  END;
END;

FUNCTION TCutlist.PreviousCutPos(CurrentPos: double): double;
VAR
  CutPosArray                      : ARRAY OF double;
  iPos                             : integer;
BEGIN
  result := -1;
  setlength(CutPosArray, self.Count * 2);
  self.FillCutPosArray(CutPosArray);
  FOR iPos := 2 * self.Count - 1 DOWNTO 0 DO BEGIN
    IF CutPosArray[iPos] < CurrentPos THEN BEGIN
      result := CutPosArray[iPos];
      break;
    END;
  END;
END;

PROCEDURE TCutlist.RefreshGUI;
BEGIN
  IF assigned(self.FRefreshCallBack) THEN RefreshCallBack(self);
END;

FUNCTION TCutlist.GetCut(iCut: Integer): TCut;
BEGIN
  result := (self.items[iCut] AS TCut);
END;

FUNCTION TCutlist.GetChecksum: Cardinal;
VAR
  s                                : TMemoryStream;
  iCut                             : integer;
  PROCEDURE Write(CONST v: integer); OVERLOAD;
  BEGIN
    s.Write(v, SizeOf(v));
  END;
  PROCEDURE Write(CONST v: RCut); OVERLOAD;
  BEGIN
    s.Write(v, SizeOf(v));
  END;
  PROCEDURE Write(CONST v: PChar; CONST l: integer); OVERLOAD;
  BEGIN
    s.Write(v, l);
  END;
  PROCEDURE Write(CONST v: STRING); OVERLOAD;
  BEGIN
    Write(Length(v));
    Write(PChar(v), Length(v));
  END;
BEGIN
  s := TMemoryStream.Create();
  TRY
    Write(self.IDOnServer);
    Write(OriginalFileSize);
    Write(self.Author);
    Write(self.Count);
    FOR iCut := 0 TO self.Count - 1 DO
      Write(self.Cut[iCut].GetData);
    s.Position := 0;
    Result := Crc32_P(s.Memory, s.Size);
  FINALLY
    FreeAndNil(s);
  END;
END;

PROCEDURE TCutlist.init;
BEGIN
  self.Clear;
  self.FCutlistFile.Clear;

  self.AppName := Application_name;
  self.AppVersion := Application_version;
  self.ApplyToFile := '';
  self.Comments.Text := CAResources.RsCutlistInternalComment;
  self.FFrameRate := 0;
  self.FFrameDuration := 0;
  self.FramesPresent := false;
  self.SavedToFilename := '';
  self.Author := Fsettings.UserName;
  self.RatingByAuthorPresent := false;
  self.RatingByAuthor := 3;
  self.EPGError := false;
  self.ActualContent := '';
  self.MissingBeginning := false;
  self.MissingEnding := false;
  self.MissingVideo := false;
  self.MissingAudio := false;
  self.OtherError := false;
  self.OtherErrorDescription := '';
  self.SuggestedMovieName := '';
  self.UserComment := '';
  self.IDOnServer := '';
  self.FRatingOnServer := -1;
  self.RatingCountOnServer := -1;
  self.RatingSent := -1;
  self.OriginalFileSize := -1;
  self.FHasChanged := false;
  self.DownloadTime := 0;

  self.RefreshGUI;
END;

FUNCTION TCutlist.LoadFromFile(Filename: STRING): boolean;
BEGIN
  Result := LoadFromFile(Filename, batchmode);
END;

FUNCTION TCutlist.LoadFromFile(Filename: STRING; noWarnings: boolean): boolean;
VAR
  cutlistfile                      : TMemIniFileEx;
BEGIN
  Result := false;
  IF NOT FileExists(Filename) THEN BEGIN
    IF NOT noWarnings THEN
      ShowMessageFmt(CAResources.RsErrorFileNotFound, [Filename]);
    exit;
  END;

  cutlistfile := TMemIniFileEx.Create(Filename);
  TRY
    Result := self.LoadFrom(cutlistfile, noWarnings);
    IF Result THEN
      self.SavedToFilename := Filename;
  FINALLY
    FreeAndNil(cutlistfile);
  END;
END;

FUNCTION TCutlist.LoadFrom(cutlistfile: TMemIniFileEx; noWarnings: boolean): boolean;
VAR
  section                          : STRING;
  my_file,
    intended_options,
    intendedCutApp,
    intendedCutAppVersionStr,
    myCutApp,
    myOptions                      : STRING;
  myCutAppVersionWords,
    intendedCutAppVersionWords     : ARFileVersion;
  message_string                   : STRING;
  iCUt, cCuts, ACut                : integer;
  iFramesDifference                : integer;
  cut                              : TCut;
  _pos_from, _pos_to               : double;
  _frame_from, _frame_to           : integer;
  CutAppAsfBin                     : TCutApplicationAsfbin;
  cutChecksum                      : Cardinal;
BEGIN
  result := false;
  IF NOT assigned(cutlistfile) THEN
    exit;

  IF NOT noWarnings AND NOT self.clear_after_confirm THEN
    exit;
  self.Init;
  IF FCutlistFile <> cutlistfile THEN
    self.FCutlistFile.LoadFromString(cutlistfile.GetDataString());
  IF cutlistfile.FileName <> '' THEN
    self.SavedToFilename := cutlistfile.FileName;

  section := 'General';
  AppName := cutlistfile.ReadString(section, 'Application', '');
  AppVersion := cutlistfile.ReadString(section, 'Version', '');
  iniReadStrings(cutlistfile, section, 'comment', false, Comments);

  ApplyToFile := cutlistfile.ReadString(section, 'ApplyToFile', Format('(%s)', [CAResources.RsCutlistTargetUnknown]));
  my_file := extractfilename(FMovieInfo.current_filename);
  IF (NOT ansiSameText(ApplyToFile, my_file)) AND (NOT noWarnings) THEN BEGIN
    message_string := Format(CAResources.RsMsgCutlistTargetMismatch, [ApplyToFile, my_file]);
    IF NOT (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
      exit;
    END;
  END;

  OriginalFileSize := cutlistfile.ReadInteger(section, 'OriginalFileSizeBytes', -1);
  //App + version
  IF self.CutApplication <> NIL THEN BEGIN
    intendedCutApp := cutlistfile.ReadString(section, 'IntendedCutApplication', '');
    intendedCutAppVersionStr := cutlistfile.ReadString(section, 'IntendedCutApplicationVersion', '');
    intendedCutAppVersionWords := Parse_File_Version(intendedCutAppVersionStr);
    myCutApp := extractfilename(CutApplication.Path);
    myCutAppVersionWords := Parse_File_Version(CutApplication.Version);

    IF (NOT noWarnings) THEN BEGIN
      IF NOT ansiSameText(intendedCutApp, myCutApp) THEN BEGIN
        message_string := Format(CAResources.RsMsgCutlistCutAppMismatch, [IntendedCutApp, myCutApp]);
        IF NOT (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
          exit;
        END;
      END ELSE IF (myCutAppVersionWords[0] <> intendedCutAppVersionWords[0])
        OR (myCutAppVersionWords[1] <> intendedCutAppVersionWords[1])
        OR (myCutAppVersionWords[2] < intendedCutAppVersionWords[2]) THEN BEGIN
        message_string := Format(CAResources.RsMsgCutlistCutAppVerMismatch, [IntendedCutApp, intendedCutAppVersionStr, CutApplication.Version]);
        IF NOT (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
          exit;
        END;
      END;
    END;

    //options for asfbin
    IF self.CutApplication IS TCutApplicationAsfbin THEN BEGIN
      CutAppAsfBin := self.CutApplication AS TCutApplicationAsfbin;
      myOptions := CutAppAsfBin.CommandLineOptions;
      intended_options := cutlistfile.ReadString(section, 'IntendedCutApplicationOptions', myOptions);
      IF NOT ansiSameText(intended_options, myOptions) THEN BEGIN
        message_string := Format(CAResources.RsMsgCutlistAsfbinOptionMismatch, [intended_options, myOptions]);
        IF noWarnings OR (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
          CutAppAsfBin.CommandLineOptions := intended_options;
        END;
      END;
    END;
  END;

  //Number of Cuts
  cCuts := cutlistfile.ReadInteger(section, 'NoOfCuts', 0);
  FrameRate := cutlistfile.ReadFloat(section, 'FramesPerSecond', 0);

  IF (FrameRate > 0) AND (FMovieInfo.frame_duration > 0) THEN BEGIN
    iFramesDifference := FMovieInfo.FrameCount - Trunc(FrameRate * FMovieInfo.current_file_duration);
    IF (NOT noWarnings) AND (Abs(iFramesDifference) > 1) THEN BEGIN
      message_string := Format(CAResources.RsMsgCutlistFrameRateMismatch, [FrameRate, 1 / FMovieInfo.frame_duration, Abs(iFramesDifference)]);
      IF Application.MessageBox(
        PChar(message_string),
        PChar(CAResources.RsTitleCutlistFrameRateMismatch),
        MB_YESNO + MB_ICONEXCLAMATION + MB_DEFBUTTON2
        ) = IDNO THEN BEGIN
        FrameDuration := FMovieInfo.frame_duration;
      END;
    END;
  END
  ELSE BEGIN
    FrameDuration := FMovieInfo.frame_duration;
  END;

  section := 'Server';
  self.FRatingOnServer := cutlistfile.ReadFloat(section, 'Rating', -1);
  self.RatingCountOnServer := cutlistfile.ReadInteger(section, 'RatingCount', -1);
  self.DownloadTime := cutlistfile.ReadInteger(section, 'DownloadTime', 0);
  self.RatingSent := cutlistfile.ReadInteger(section, 'RatingSent', -1);
  self.IDOnServer := cutlistfile.ReadString(section, 'ID', '');
  cutChecksum := StrToInt64Def(cutlistfile.ReadString(section, 'Checksum', ''), 0);

  //info
  section := 'Info';
  self.Author := cutlistfile.ReadString(section, 'Author', '');
  self.RatingByAuthor := cutlistfile.ReadInteger(section, 'RatingByAuthor', -1);
  IF self.RatingByAuthor = -1 THEN
    self.RatingByAuthorPresent := false
  ELSE
    self.RatingByAuthorPresent := true;
  self.EPGError := cutlistfile.ReadBool(section, 'EPGError', false);
  IF self.EPGError THEN
    self.ActualContent := cutlistfile.ReadString(section, 'ActualContent', '')
  ELSE
    self.ActualContent := '';
  self.MissingBeginning := cutlistfile.ReadBool(section, 'MissingBeginning', false);
  self.MissingEnding := cutlistfile.ReadBool(section, 'MissingEnding', false);
  self.MissingVideo := cutlistfile.ReadBool(section, 'MissingVideo', false);
  self.MissingAudio := cutlistfile.ReadBool(section, 'MissingAudio', false);
  self.OtherError := cutlistfile.ReadBool(section, 'OtherError', false);
  IF self.OtherError THEN
    self.OtherErrorDescription := cutlistfile.ReadString(section, 'OtherErrorDescription', '')
  ELSE
    self.OtherErrorDescription := '';
  self.SuggestedMovieName := cutlistfile.ReadString(section, 'SuggestedMovieName', '');
  self.UserComment := cutlistfile.ReadString(section, 'UserComment', '');

  self.FramesPresent := true;

  FOR iCut := 0 TO cCuts - 1 DO BEGIN
    section := 'Cut' + inttostr(iCut);
    _pos_from := cutlistfile.ReadFloat(section, 'Start', 0);
    _pos_to := _pos_from + cutlistfile.ReadFloat(section, 'Duration', 0) - FrameDuration;
    _Frame_from := cutlistfile.ReadInteger(section, 'StartFrame', -1);
    _Frame_to := _frame_from + cutlistfile.ReadInteger(section, 'DurationFrames', -1) - 1;

    IF self.cut_times_valid(_pos_from, _pos_to, -1, aCut) THEN BEGIN
      cut := Tcut.Create(_pos_from, _pos_to);
      IF (_frame_from < 0) OR (_frame_to < 0) THEN BEGIN
        self.FramesPresent := false;
      END ELSE BEGIN
        cut.frame_from := _Frame_from;
        cut.frame_to := _frame_to;
      END;
      self.Add(cut);
    END;
  END;

  IF (cutCheckSum = 0) OR (cutChecksum <> self.GetChecksum) THEN BEGIN
    // Remove server and rating information, if changed
    self.IDOnServer := '';
  END;

  self.FMode := clmTrim;
  self.FHasChanged := false;
  //self.SavedToFilename := filename;
  result := true;
  IF NOT noWarnings THEN BEGIN
    ShowMessageFmt(CAResources.RsMsgCutlistLoaded, [self.Count, cCuts]);
  END;
  self.RefreshGUI;
END;

FUNCTION TCutlist.Save(AskForPath: boolean): boolean;
VAR
  cutlist_path, target_file        : STRING;
  message_string                   : STRING;
  saveDlg                          : TSaveDialog;
BEGIN
  result := false;
  IF self.Count = 0 THEN BEGIN
    ShowMessage(CAResources.RsNoCutsDefined);
    exit;
  END;

  IF self.SavedToFilename = '' THEN BEGIN
    CASE FSettings.SaveCutlistMode OF
      smWithSource: BEGIN //with source
          cutlist_path := extractFilePath(FMovieInfo.current_filename);
        END;
      smGivenDir: BEGIN //in given Dir
          cutlist_path := IncludeTrailingPathDelimiter(FSettings.CutlistSaveDir);
        END;
    ELSE BEGIN //with source
        cutlist_path := extractFilePath(FMovieInfo.current_filename);
      END;
    END;
    target_file := cutlist_path + self.FilenameSuggestion;
  END ELSE BEGIN
    target_file := self.SavedToFilename;
  END;

  IF (self.SavedToFilename = '') OR AskForPath THEN BEGIN
    //Display Save Dialog?
    AskForPath := AskForPath OR FSettings.CutlistNameAlwaysConfirm;
    IF fileexists(target_File) AND (NOT AskForPath) THEN BEGIN
      message_string := Format(CAResources.RsWarnTargetExistsOverwrite, [target_file]);
      IF application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_DEFBUTTON2 + MB_ICONWARNING) <> IDYES THEN BEGIN
        AskForPath := true;
      END;
    END;
    IF AskForPath THEN BEGIN
      saveDlg := TSaveDialog.Create(Application.MainForm);
      saveDlg.Filter := MakeFilterString(CAResources.RsFilterDescriptionCutlists, '*' + cutlist_Extension) + '|'
        + MakeFilterString(CAResources.RsFilterDescriptionAll, '*.*');
      saveDlg.FilterIndex := 1;
      saveDlg.Title := CAResources.RsSaveCutlistAs;
      saveDlg.InitialDir := cutlist_path;
      saveDlg.filename := self.FilenameSuggestion;
      saveDlg.options := saveDlg.Options + [ofOverwritePrompt, ofPathMustExist];
      IF saveDlg.Execute THEN BEGIN
        target_file := saveDlg.FileName;
        FreeAndNIL(saveDlg);
      END ELSE BEGIN
        FreeAndNIL(saveDlg);
        exit;
      END;
    END;

    cutlist_path := ExtractFilePath(target_file);
    IF NOT ForceDirectories(cutlist_path) THEN BEGIN
      IF NOT batchmode THEN
        ShowMessageFmt(CAResources.RsErrorCreatePathFailedAbort, [cutlist_path]);
      exit;
    END;
    IF fileexists(target_File) THEN BEGIN
      IF NOT deletefile(target_file) THEN BEGIN
        ShowMessageFmt(CAResources.RsCouldNotDeleteFile, [target_file]);
        exit;
      END;
    END;
  END;

  result := self.SaveAs(target_file);
END;

FUNCTION TCutlist.SaveAs(Filename: STRING): boolean;
VAR
  message_string                   : STRING;
  AdjustFileInfo                   : boolean;
  DoRefresh                        : boolean;
BEGIN
  Result := false;
  AdjustFileInfo := false;
  DoRefresh := false;
  IF (NOT self.RatingByAuthorPresent) THEN BEGIN
    IF NOT self.EditInfo THEN exit;
  END;

  IF self.HasChanged THEN BEGIN
    IF self.Author = '' THEN BEGIN
      self.Author := Fsettings.UserName;
      self.IDOnServer := '';
      DoRefresh := true;
    END ELSE BEGIN
      IF self.Author <> Fsettings.UserName THEN BEGIN
        message_string := Format(CAResources.RsMsgCutlistReplaceAuthor, [self.Author]);
        IF (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
          self.Author := Fsettings.UserName;
          self.IDOnServer := '';
          DoRefresh := true;
        END;
      END;
      IF (NOT AnsiSameText(self.ApplyToFile, extractfilename(FMovieInfo.current_filename)))
        OR (self.OriginalFileSize <> FMovieInfo.current_filesize) THEN BEGIN
        message_string := Format(CAResources.RsMsgCutlistReplaceFileInfo, [self.ApplyToFile, self.OriginalFileSize]);
        IF (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
          AdjustFileInfo := true;
          DoRefresh := true;
        END;
      END;
    END;
  END;

  IF AdjustFileInfo OR (ApplyToFile = '') THEN BEGIN
    ApplyToFile := extractfilename(FMovieInfo.current_filename);
    DoRefresh := true;
  END;

  IF AdjustFileInfo OR (OriginalFileSize < 0) THEN BEGIN
    OriginalFileSize := FMovieInfo.current_filesize;
    DoRefresh := true;
  END;
  IF AdjustFileInfo OR (FrameRate = 0) OR (FrameDuration = 0) THEN BEGIN
    FrameDuration := FMovieInfo.frame_duration;
    DoRefresh := true;
  END;

  IF DoRefresh THEN
    RefreshGUI;
  
  //IF FHasChanged OR (FCutlistFile.GetDataString() = '') THEN BEGIN
  Result := self.StoreTo(FCutlistFile);
  //END ELSE
  //  Result := true;

  IF Result THEN BEGIN
    FCutlistFile.SaveToFile(Filename);
    self.SavedToFilename := Filename;
  END;
END;

FUNCTION TCutlist.StoreTo(cutlistfile: TMemIniFileEx): boolean;
//true if saved successfully
VAR
  section                          : STRING;
  iCut, writtenCuts                : integer;
  convertedCutlist                 : TCutlist;
  CutApplication                   : TCutApplicationBase;
BEGIN
  result := false;
  IF NOT Assigned(cutlistfile) THEN
    exit;

  IF self.Mode = clmTrim THEN BEGIN
    self.sort;

    section := 'General';
    cutlistfile.WriteString(section, 'Application', AppName);
    cutlistfile.WriteString(section, 'Version', AppVersion);
    iniWriteStrings(cutlistfile, section, 'comment', false, Comments);
    cutlistfile.WriteString(section, 'ApplyToFile', ApplyToFile);
    cutlistfile.WriteInteger(section, 'OriginalFileSizeBytes', OriginalFileSize);
    cutlistfile.WriteFloat(section, 'FramesPerSecond', FrameRate);

    // ToDo: do not change contents of cutlist here, use existing values
    // if possible!
    CutApplication := FSettings.GetCutApplicationByMovieType(FMovieInfo.MovieType);
    IF assigned(CutApplication) THEN BEGIN
      CutApplication.WriteCutlistInfo(CutlistFile, section);
    END ELSE BEGIN
      cutlistfile.DeleteKey(section, 'IntendedCutApplication');
      cutlistfile.DeleteKey(section, 'IntendedCutApplicationVersion');
      cutlistfile.DeleteKey(section, 'IntendedCutApplicationOptions');
      cutlistfile.DeleteKey(section, 'CutCommandLine');
    END;

    section := 'Info';
    cutlistfile.WriteString(section, 'Author', self.Author);
    IF self.RatingByAuthorPresent THEN
      cutlistfile.WriteInteger(section, 'RatingByAuthor', self.RatingByAuthor)
    ELSE
      cutlistfile.DeleteKey(section, 'RatingByAuthor');
    cutlistfile.WriteBool(section, 'EPGError', self.EPGError);
    cutlistfile.WriteString(section, 'ActualContent', self.ActualContent);
    cutlistfile.WriteBool(section, 'MissingBeginning', self.MissingBeginning);
    cutlistfile.WriteBool(section, 'MissingEnding', self.MissingEnding);
    cutlistfile.WriteBool(section, 'MissingVideo', self.MissingVideo);
    cutlistfile.WriteBool(section, 'MissingAudio', self.MissingAudio);
    cutlistfile.WriteBool(section, 'OtherError', self.OtherError);
    cutlistfile.WriteString(section, 'OtherErrorDescription', self.OtherErrorDescription);
    cutlistfile.WriteString(section, 'SuggestedMovieName', self.SuggestedMovieName);
    cutlistfile.WriteString(section, 'UserComment', self.UserComment);

    SaveServerInfos(cutlistfile);

    RemoveCutSections(cutlistfile);

    writtenCuts := 0;
    FOR iCut := 0 TO self.Count - 1 DO BEGIN
      section := 'Cut' + inttostr(writtenCuts);
      inc(writtenCuts);
      cutlistfile.WriteFloat(section, 'Start', self[iCut].pos_from);
      cutlistfile.WriteFloat(section, 'Duration', self[iCut].pos_to - self[iCut].pos_from + FMovieInfo.frame_duration);
      IF self.FramesPresent THEN BEGIN
        cutlistfile.WriteInteger(section, 'StartFrame', self[iCut].frame_from);
        cutlistfile.WriteInteger(section, 'DurationFrames', self[iCut].DurationFrames)
      END;
    END;
    cutlistfile.WriteInteger('General', 'NoOfCuts', writtenCuts);
    result := true;

    IF self.FHasChanged THEN
      self.FHasChanged := false;

  END ELSE BEGIN
    ConvertedCutlist := self.convert;
    TRY
      result := ConvertedCutlist.StoreTo(cutlistfile);
      self.FHasChanged := ConvertedCutlist.HasChanged;
      self.IDOnServer := convertedCutlist.IDOnServer;
    FINALLY
      FreeAndNil(ConvertedCutlist);
    END;
  END;
END;

FUNCTION TCutlist.SaveServerInfos(cutlistfile: TMemIniFileEx): boolean;
VAR
  section                          : STRING;
BEGIN
  section := 'Server';
  cutlistfile.EraseSection(section);
  IF self.IDOnServer <> '' THEN BEGIN
    cutlistfile.WriteString(section, 'ID', self.IDOnServer);
    cutlistfile.WriteFloat(section, 'Rating', self.RatingOnServer);
    cutlistfile.WriteInteger(section, 'RatingCount', self.RatingCountOnServer);
    cutlistfile.WriteInteger(section, 'DownloadTime', self.DownloadTime);
    cutlistfile.WriteString(section, 'Checksum', IntToStr(self.GetChecksum));
  END;
  //IF self.RatingSent <> -1 THEN
  //  cutlistfile.WriteInteger(section, 'RatingSent', self.RatingSent);
  Result := self.IDOnServer <> '';
END;

FUNCTION TCutlist.AddServerInfos(Filename: STRING): boolean;
VAR
  cutlistfile                      : TMemIniFileEx;
BEGIN
  cutlistfile := TMemIniFileEx.Create(Filename);
  TRY
    Result := self.SaveServerInfos(cutlistfile);
    cutlistfile.UpdateFile;
  FINALLY
    FreeAndNil(cutlistfile);
  END;
END;

PROCEDURE TCutlist.RemoveCutSections(cutlistfile: TMemIniFileEx);
VAR
  sections                         : TStringList;
  sectionNumber                    : integer;
  idx                              : integer;
BEGIN
  IF NOT Assigned(cutlistfile) THEN
    Exit;
  sections := TStringList.Create;
  cutlistfile.ReadSections(sections);
  FOR idx := 0 TO sections.Count - 1 DO BEGIN
    IF AnsiStartsText('Cut', sections.Strings[idx]) AND TryStrToInt(Copy(sections.Strings[idx], 4, MaxInt), sectionNumber) THEN
      cutlistfile.EraseSection(sections.Strings[idx]);
  END;
END;

PROCEDURE TCutlist.SetIDOnServer(CONST Value: STRING);
BEGIN
  FIDOnServer := Value;
  IF Value = '' THEN BEGIN
    self.RatingSent := -1;
    self.FRatingOnServer := -1;
    self.RatingCountOnServer := -1;
    self.DownloadTime := 0;
    // ToDO: Clear other dependent values
  END;
END;

PROCEDURE TCutlist.SetMode(CONST Value: TCutlistMode);
BEGIN
  FMode := Value;
  self.RefreshGUI;
END;

PROCEDURE TCutlist.SetRefreshCallBack(CONST Value: TCutlistCallBackMethod);
BEGIN
  FRefreshCallBack := Value;
END;

PROCEDURE TCutlist.SetSuggestedMovieName(CONST Value: STRING);
BEGIN
  FSuggestedMovieName := AnsiReplaceStr(Value, '"', '''');
END;

FUNCTION TCutlistCompareItems(Item1, Item2: Pointer): Integer;
VAR
  o1, o2                           : TCut;
BEGIN
  o1 := TCut(Item1);
  o2 := TCut(Item2);
  Result := TCut.Compare(o1, o2);
END;

PROCEDURE TCutlist.Sort;
BEGIN
  INHERITED Sort(@TCutlistCompareItems);
END;

FUNCTION TCutlist.TotalDurationOfCuts: double;
VAR
  iCut                             : Integer;
  dur                              : double;
BEGIN
  dur := 0;
  FOR iCut := 0 TO self.Count - 1 DO
    dur := dur + Cut[iCut].pos_to - Cut[iCut].pos_from;
  result := dur;
END;

FUNCTION TCutlist.UserShouldSendRating: boolean;
BEGIN
  result := (self.RatingSent = -1) AND (self.IDOnServer > '');
END;

END.

