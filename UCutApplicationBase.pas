UNIT UCutApplicationBase;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  IniFiles,
  Contnrs,
  JvComponentBase,
  JvCreateProcess,
  Utils,
  JvExStdCtrls,
  JvCheckBox;

TYPE
  TCutApplicationFrameClass = CLASS OF TfrmCutApplicationBase;

  TCutApplicationBase = CLASS;

  TfrmCutApplicationBase = CLASS(TFrame)
    edtPath: TEdit;
    lblAppPath: TLabel;
    btnBrowsePath: TButton;
    edtTempDir: TEdit;
    lblTempDir: TLabel;
    btnBrowseTempDir: TButton;
    selectFileDlg: TOpenDialog;
    cbRedirectOutput: TJvCheckBox;
    cbShowAppWindow: TJvCheckBox;
    cbCleanUp: TJvCheckBox;
    PROCEDURE btnBrowsePathClick(Sender: TObject);
    PROCEDURE btnBrowseTempDirClick(Sender: TObject);
  PRIVATE
    { Private declarations }
    PROCEDURE SetCutApplication(CONST Value: TCutApplicationBase);
  PROTECTED
    FCutApplication: TCutApplicationBase;
  PUBLIC
    { Public declarations }
    PROPERTY CutApplication: TCutApplicationBase READ FCutApplication WRITE SetCutApplication;
    PROCEDURE Init; VIRTUAL;
    PROCEDURE Apply; VIRTUAL;
  END;

  TCutApplicationCommandLineEvent = PROCEDURE(Sender: TObject; CONST CommandLineIndex: Integer; CONST CommandLine: STRING) OF OBJECT;

  TCutApplicationBase = CLASS(TObject)
  PRIVATE
    FName: STRING;
    FPath: STRING;
    FVersion: STRING;
    FVersionWords: ARRAY[0..3] OF word;
    FDefaultExeNames: TStringlist;
    FRedirectOutput: boolean;
    FShowAppWindow: boolean;
    FTempDir: STRING;

    FOutputMemo: TMemo;
    FCommandLineCounter: Integer;
    FjvcpAppProcess: TJvCreateProcess;
    FProcessAborted: boolean;
    FCleanUp: boolean;
    FRawRead: boolean;
    FOnCuttingTerminate: TJvCPSTerminateEvent;
    FOnCommandLineTerminate: TCutApplicationCommandLineEvent;

    PROCEDURE SetPath(CONST Value: STRING);
    PROCEDURE SetName(CONST Value: STRING);
    FUNCTION GetVersionWords(Index: Integer): word;
    PROCEDURE SetRedirectOutput(CONST Value: boolean);
    PROCEDURE SetShowAppWindow(CONST Value: boolean);
    PROCEDURE SetTempDir(CONST Value: STRING);
    PROCEDURE SetOutputMemo(CONST Value: TMemo);
    PROCEDURE jvcpAppProcessRead(Sender: TObject; CONST S: STRING; CONST StartsOnNewLine: Boolean);
    PROCEDURE jvcpAppProcessRawRead(Sender: TObject; CONST S: STRING);
    PROCEDURE jvcpAppProcessTerminate(Sender: TObject; ExitCode: Cardinal);
    PROCEDURE SetCleanUp(CONST Value: boolean);
    PROCEDURE SetRawRead(CONST Value: boolean);
    PROCEDURE SetOnCommandLineTerminate(
      CONST Value: TCutApplicationCommandLineEvent);
  PROTECTED
    FHasSmartRendering: boolean;
    FCommandLines: TStringList; //ONLY command line parameters WITHOUT path to exe file!!!
    PROPERTY RawRead: boolean READ FRawRead WRITE SetRawRead;
    FUNCTION ExecuteCutProcess: boolean;
    FUNCTION GetIniSectionName: STRING; VIRTUAL;
    PROPERTY CutApplicationProcess: TJvCreateProcess READ FjvcpAppProcess;
  PUBLIC
    CutAppSettings: RCutAppSettings;
    FrameClass: TCutApplicationFrameClass;
    PROPERTY OutputMemo: TMemo READ FOutputMemo WRITE SetOutputMemo;
    PROPERTY OnCommandLineTerminate: TCutApplicationCommandLineEvent READ FOnCommandLineTerminate WRITE SetOnCommandLineTerminate;
    PROPERTY OnCuttingTerminate: TJvCPSTerminateEvent READ FOnCuttingTerminate WRITE FOnCuttingTerminate;
    PROCEDURE AbortCutProcess;
    PROCEDURE EmergencyTerminateProcess;

    PROPERTY Name: STRING READ FName WRITE SetName;
    PROPERTY DefaultExeNames: TStringlist READ FDefaultExeNames WRITE FDefaultExeNames;
    PROPERTY Path: STRING READ FPath WRITE SetPath;
    PROPERTY TempDir: STRING READ FTempDir WRITE SetTempDir;
    PROPERTY RedirectOutput: boolean READ FRedirectOutput WRITE SetRedirectOutput;
    PROPERTY ShowAppWindow: boolean READ FShowAppWindow WRITE SetShowAppWindow;
    PROPERTY CleanUp: boolean READ FCleanUp WRITE SetCleanUp;
    PROPERTY Version: STRING READ FVersion;
    PROPERTY VersionWords[Index: Integer]: word READ GetVersionWords;
    PROPERTY HasSmartRendering: boolean READ FHasSmartRendering;

    CONSTRUCTOR create; VIRTUAL;
    DESTRUCTOR Destroy; OVERRIDE;
    FUNCTION LoadSettings(IniFile: TCustomIniFile): boolean; VIRTUAL;
    FUNCTION SaveSettings(IniFile: TCustomIniFile): boolean; VIRTUAL;
    FUNCTION InfoString: STRING; VIRTUAL;
    FUNCTION WriteCutlistInfo(CutlistFile: TCustomIniFile; section: STRING): boolean; VIRTUAL;

    FUNCTION PrepareCutting(SourceFileName: STRING; VAR DestFileName: STRING; Cutlist: TObjectList): boolean; VIRTUAL;
    PROPERTY CommandLines: TStringList READ FCommandLines;
    FUNCTION StartCutting: boolean; VIRTUAL;
    FUNCTION CleanUpAfterCutting: boolean; VIRTUAL;
    FUNCTION CheckOutputForErrors: boolean; VIRTUAL;
  END;

IMPLEMENTATION

{$WARN UNIT_PLATFORM OFF}

USES
  CAResources,
  FileCtrl;

{$R *.dfm}

{TfrmCutApplicationBase}

PROCEDURE TfrmCutApplicationBase.Apply;
BEGIN
  IF fileexists(edtPath.Text) THEN CutApplication.Path := edtPath.Text;
  CutApplication.TempDir := self.edtTempDir.Text;
  CutApplication.RedirectOutput := self.cbRedirectOutput.Checked;
  CutApplication.ShowAppWindow := self.cbShowAppWindow.Checked;
  CutApplication.CleanUp := self.cbCleanUp.Checked;
END;

PROCEDURE TfrmCutApplicationBase.btnBrowsePathClick(Sender: TObject);
BEGIN
  selectFileDlg.Title := Format(CAResources.RsTitleSelectCutApplication, [CutApplication.Name]);
  selectFileDlg.InitialDir := ExtractFilePath(self.edtPath.Text);
  selectFileDlg.FileName := ExtractFileName(self.edtPath.Text);
  IF selectFileDlg.Execute THEN BEGIN
    edtPath.Text := selectFileDlg.FileName;
  END ELSE BEGIN
    exit;
  END;
END;

PROCEDURE TfrmCutApplicationBase.Init;
  PROCEDURE AppendFilterString(CONST description: STRING; CONST extensions: STRING); OVERLOAD;
  VAR
    filter                         : STRING;
  BEGIN
    filter := MakeFilterString(description, extensions);
    IF selectFileDlg.Filter <> '' THEN
      selectFileDlg.Filter := selectFileDlg.Filter + '|' + filter
    ELSE
      selectFileDlg.Filter := filter
  END;
BEGIN
  self.edtPath.Text := CutApplication.Path;
  self.edtTempDir.Text := CutApplication.TempDir;
  self.cbRedirectOutput.Checked := CutApplication.RedirectOutput;
  self.cbShowAppWindow.Checked := CutApplication.ShowAppWindow;
  self.cbCleanUp.Checked := CutApplication.CleanUp;
  selectFileDlg.Filter := '';
  AppendFilterString(CutApplication.Name, CutApplication.DefaultExeNames.DelimitedText);
  AppendFilterString(CAResources.RsFilterDescriptionExecutables, '*.exe');
  AppendFilterString(CAResources.RsFilterDescriptionAll, '*.*');
END;

PROCEDURE TfrmCutApplicationBase.SetCutApplication(
  CONST Value: TCutApplicationBase);
VAR
  lbl                              : STRING;
  {
  i: INteger;
  exeNames: TStrings;
  cnt: integer;
  }
BEGIN
  FCutApplication := Value;
  lbl := Format(CAResources.RsCutAppPathTo, [FCutApplication.Name]);
  {
  exeNames := FCutApplication.DefaultExeNames;
  cnt := exeNames.Count;
  if cnt > 0 then begin
    lbl := lbl + ' (' + exeNames[0];
    for i := 1 to cnt - 1 do begin
      lbl := Format(CAResources.RsCutAppPathToMore, [ lbl, exeNames[i] ]);
    end;
    lbl := lbl + ')';
  end;
  }
  lblAppPath.Caption := lbl;
END;

PROCEDURE TfrmCutApplicationBase.btnBrowseTempDirClick(Sender: TObject);
VAR
  newDir                           : STRING;
BEGIN
  newDir := self.edtTempDir.Text;
  IF SelectDirectory(CAResources.RsTitleSelectTemporaryDirectory, '', newDir) THEN
    self.edtTempDir.Text := newDir;
END;

{ TCutApplicationBase }

PROCEDURE TCutApplicationBase.AbortCutProcess;
BEGIN
  IF self.FjvcpAppProcess.State <> psReady THEN BEGIN
    FProcessAborted := true;
    self.FjvcpAppProcess.CloseApplication(true);
  END;
END;

FUNCTION TCutApplicationBase.CleanUpAfterCutting: boolean;
BEGIN
  result := false;
  IF self.CleanUp THEN BEGIN

    result := true;
  END;
END;

CONSTRUCTOR TCutApplicationBase.create;
BEGIN
  INHERITED;
  FDefaultExeNames := TSTringList.Create;
  FDefaultExeNames.Delimiter := ';';
  FCommandLines := TStringList.Create;
  FjvcpAppProcess := TJvCreateProcess.Create(NIL);
  FjvcpAppProcess.OnTerminate := self.jvcpAppProcessTerminate;
  FrameClass := TfrmCutApplicationBase;
  RedirectOutput := false;
  ShowAppWindow := true;
  CleanUp := true;
  RawRead := true;
  FHasSmartRendering := false;
END;

DESTRUCTOR TCutApplicationBase.destroy;
BEGIN
  FreeAndNIL(FjvcpAppProcess);
  FreeAndNIL(FCommandLines);
  FreeAndNIL(FDefaultExeNames);
  INHERITED;
END;

FUNCTION TCutApplicationBase.PrepareCutting(SourceFileName: STRING; VAR DestFileName: STRING; Cutlist: TObjectList): boolean;
BEGIN
  Result := false;
  IF NOT FileExists(self.Path) THEN BEGIN
    ShowMessageFmt(CAResources.RsCutAppNotFound, [self.Name, self.Path]);
    exit;
  END;

  Result := true;
END;

PROCEDURE TCutApplicationBase.EmergencyTerminateProcess;
BEGIN
  IF self.FjvcpAppProcess.State <> psReady THEN BEGIN
    FProcessAborted := true;
    self.FjvcpAppProcess.Terminate;
  END;
END;

FUNCTION TCutApplicationBase.ExecuteCutProcess: boolean;
BEGIN
  FProcessAborted := false;
  result := false;
  IF self.FCommandLines.Count < 1 THEN exit;

  IF assigned(FOutputMemo) THEN BEGIN
    FOutputMemo.Clear;
    IF NOT FRedirectOutput THEN
      FOutputMemo.Lines.Add(CAResources.RsCutAppOutNoOutputRedirection);
  END;

  FCommandLineCounter := 0;
  self.jvcpAppProcessTerminate(self, 0); //start process with first command line
  result := true;
END;

FUNCTION TCutApplicationBase.GetIniSectionName: STRING;
BEGIN
  result := Name;
END;

FUNCTION TCutApplicationBase.GetVersionWords(Index: Integer): word;
BEGIN
  result := 0;
  IF Index IN [0..3] THEN BEGIN
    result := FVersionWords[Index];
  END;
END;

FUNCTION TCutApplicationBase.InfoString: STRING;
BEGIN
  Result := Format(CAResources.RsCutAppInfoBase, [
    self.Name,
      self.Path,
      self.Version
      ]);
END;

PROCEDURE TCutApplicationBase.jvcpAppProcessRawRead(Sender: TObject;
  CONST S: STRING);
BEGIN
  IF assigned(self.FOutputMemo) AND FRawRead THEN BEGIN
    FOutputMemo.Text := FOutputMemo.Text + S;
    SendMessage(FOutputMemo.Handle, WM_VSCROLL, SB_BOTTOM, 0); //Scroll down
  END;
END;

PROCEDURE TCutApplicationBase.jvcpAppProcessRead(Sender: TObject;
  CONST S: STRING; CONST StartsOnNewLine: Boolean);
BEGIN
  IF assigned(self.FOutputMemo) AND NOT FRawRead THEN BEGIN
    IF StartsOnNewLine THEN BEGIN
      FOutputMemo.Lines.Add(S);
      SendMessage(FOutputMemo.Handle, WM_VSCROLL, SB_BOTTOM, 0); //Scroll down
    END ELSE BEGIN
      FOutputMemo.Lines.Strings[FOutPutMemo.Lines.Count - 1] := S;
    END;
  END;
END;

PROCEDURE TCutApplicationBase.jvcpAppProcessTerminate(Sender: TObject;
  ExitCode: Cardinal);
BEGIN
  IF (FCommandLineCounter > 0) AND assigned(FOnCommandLineTerminate) THEN BEGIN
    FOnCommandLineTerminate(Sender, FCommandLineCounter - 1, FCommandLines[FCommandLineCounter - 1]);
  END;
  IF (FCommandLineCounter >= FCommandLines.Count)
    OR (ExitCode <> 0)
    OR FProcessAborted THEN BEGIN

    IF ExitCode = 0 THEN BEGIN
      IF assigned(FOutputMemo) THEN
        FOutputMemo.Lines.Add(CAResources.RsCutAppOutFinished);
    END ELSE BEGIN
      IF assigned(FOutputMemo) THEN BEGIN
        IF NOT CheckOutputForErrors THEN BEGIN
          FOutputMemo.Lines.Add(CAResources.RsCutAppOutErrorCommand);
          FOutputMemo.Lines.Add(FCommandLines[FCommandLineCounter - 1]);
        END;
      END;
    END;
    IF FProcessAborted THEN BEGIN
      IF assigned(FOutputMemo) THEN
        FOutputMemo.Lines.Add(CAResources.RsCutAppOutUserAbort);
      ExitCode := Cardinal(-1);
    END;
    IF assigned(FOnCuttingTerminate) THEN
      FOnCuttingTerminate(Sender, ExitCode);

  END ELSE BEGIN
    //Next Command Line
    self.FjvcpAppProcess.CommandLine := '"' + FPath + '" ' + FCommandLines[FCommandLineCounter];
    inc(FCommandLineCounter);
    self.FjvcpAppProcess.Run;
  END;
END;

FUNCTION TCutApplicationBase.CheckOutputForErrors: boolean;
BEGIN
  Result := false;
END;

FUNCTION TCutApplicationBase.LoadSettings(IniFile: TCustomIniFile): boolean;
CONST
  TEMP_DIR                         = 'temp';
VAR
  section                          : STRING;
BEGIN
  section := GetIniSectionName;
  IF Path = '' THEN BEGIN
    IF DefaultExeNames.Count > 0 THEN
      Path := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + DefaultExeNames.Strings[0];
  END;
  Path := IniFile.ReadString(section, 'Path', Path);
  IF TempDir = '' THEN
    TempDir := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName)) + TEMP_DIR);
  TempDir := IniFile.ReadString(section, 'TempDir', TempDir);
  RedirectOutput := iniFile.ReadBool(Section, 'RedirectOutput', RedirectOutput);
  ShowAppWindow := iniFile.ReadBool(Section, 'ShowAppWindow', ShowAppWindow);
  CleanUp := iniFile.ReadBool(Section, 'CleanUp', CleanUp);
  result := true;
END;

FUNCTION TCutApplicationBase.SaveSettings(IniFile: TCustomIniFile): boolean;
VAR
  section                          : STRING;
BEGIN
  section := GetIniSectionName;
  IniFile.WriteString(section, 'Path', Path);
  IniFile.WriteString(section, 'TempDir', TempDir);
  IniFile.WriteBool(section, 'RedirectOutput', RedirectOutput);
  IniFile.WriteBool(section, 'ShowAppWindow', ShowAppWindow);
  IniFile.WriteBool(section, 'CleanUp', CleanUp);
  result := true;
END;

FUNCTION TCutApplicationBase.WriteCutlistInfo(
  CutlistFile: TCustomIniFile; section: STRING): boolean;
BEGIN
  cutlistfile.WriteString(section, 'IntendedCutApplicationName', Name);
  cutlistfile.WriteString(section, 'IntendedCutApplication', extractfilename(Path));
  cutlistfile.WriteString(section, 'IntendedCutApplicationVersion', Version);
  result := true;
END;

PROCEDURE TCutApplicationBase.SetCleanUp(CONST Value: boolean);
BEGIN
  FCleanUp := Value;
END;

PROCEDURE TCutApplicationBase.SetName(CONST Value: STRING);
BEGIN
  FName := Value;
END;

PROCEDURE TCutApplicationBase.SetOnCommandLineTerminate(
  CONST Value: TCutApplicationCommandLineEvent);
BEGIN
  FOnCommandLineTerminate := Value;
END;

PROCEDURE TCutApplicationBase.SetOutputMemo(CONST Value: TMemo);
BEGIN
  IF Value <> FOutputMemo THEN BEGIN
    FOutputMemo := Value;
    IF assigned(FOutputMemo) THEN BEGIN
      IF FRawRead THEN BEGIN
        self.FjvcpAppProcess.OnRead := NIL;
        self.FjvcpAppProcess.OnRawRead := self.jvcpAppProcessRawRead;
      END ELSE BEGIN
        self.FjvcpAppProcess.OnRead := self.jvcpAppProcessRead;
        self.FjvcpAppProcess.OnRawRead := NIL;
      END;
    END ELSE BEGIN
      self.FjvcpAppProcess.OnRead := NIL;
      self.FjvcpAppProcess.OnRawRead := NIL;
    END;
  END;
END;

PROCEDURE TCutApplicationBase.SetPath(CONST Value: STRING);
VAR
  dwFileVersionMS, dwFileVersionLS : DWORD;
BEGIN
  IF fileexists(Value) THEN BEGIN
    FPath := Value;
    IF Get_File_Version(Value, dwFileVersionMS, dwFileVersionLS) THEN BEGIN
      FVersion := Get_File_Version(Value);
      FVersionWords[0] := HiWord(dwFileVersionMS);
      FVersionWords[1] := LoWord(dwFileVersionMS);
      FVersionWords[2] := HiWord(dwFileVersionLS);
      FVersionWords[3] := LoWord(dwFileVersionLS);
    END ELSE BEGIN
      FVersion := '';
      FVersionWords[0] := 0;
      FVersionWords[1] := 0;
      FVersionWords[2] := 0;
      FVersionWords[3] := 0;
    END;
  END;
END;

PROCEDURE TCutApplicationBase.SetRawRead(CONST Value: boolean);
BEGIN
  FRawRead := Value;
  IF assigned(FOutputMemo) THEN BEGIN
    IF FRawRead THEN BEGIN
      self.FjvcpAppProcess.OnRead := NIL;
      self.FjvcpAppProcess.OnRawRead := self.jvcpAppProcessRawRead;
    END ELSE BEGIN
      self.FjvcpAppProcess.OnRead := self.jvcpAppProcessRead;
      self.FjvcpAppProcess.OnRawRead := NIL;
    END;
  END;
END;

PROCEDURE TCutApplicationBase.SetRedirectOutput(CONST Value: boolean);
BEGIN
  FRedirectOutput := Value;
  IF Value THEN BEGIN
    FjvcpAppProcess.ConsoleOptions := [coRedirect, coOwnerData];
  END ELSE BEGIN
    FjvcpAppProcess.ConsoleOptions := [];
  END;
END;

PROCEDURE TCutApplicationBase.SetShowAppWindow(CONST Value: boolean);
BEGIN
  FShowAppWindow := Value;
  IF Value THEN BEGIN
    FjvcpAppProcess.StartupInfo.ShowWindow := swNormal;
    FjvcpAppProcess.StartupInfo.DefaultWindowState := true;
  END ELSE BEGIN
    FjvcpAppProcess.StartupInfo.ShowWindow := swHide;
    FjvcpAppProcess.StartupInfo.DefaultWindowState := false;
  END;
END;

PROCEDURE TCutApplicationBase.SetTempDir(CONST Value: STRING);
BEGIN
  FTempDir := Value;
END;

FUNCTION TCutApplicationBase.StartCutting: boolean;
BEGIN
  result := ExecuteCutProcess;
END;

END.

