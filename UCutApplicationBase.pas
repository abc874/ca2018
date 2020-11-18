unit UCutApplicationBase;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, System.IniFiles, System.Contnrs, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Controls, Vcl.Forms,

  // Jedi
  JvExStdCtrls, JvCheckBox, JvCreateProcess,

  // CA
  Utils;

type
  TCutApplicationFrameClass = class of TfrmCutApplicationBase;

  TCutApplicationBase = class;

  TfrmCutApplicationBase = class(TFrame)
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
    procedure btnBrowsePathClick(Sender: TObject);
    procedure btnBrowseTempDirClick(Sender: TObject);
  private
    { private declarations }
    procedure SetCutApplication(const Value: TCutApplicationBase);
  protected
    FCutApplication: TCutApplicationBase;
  public
    { public declarations }
    property CutApplication: TCutApplicationBase read FCutApplication write SetCutApplication;
    procedure Init; virtual;
    procedure Apply; virtual;
  end;

  TCutApplicationBase = class(TObject)
  private
    FName: string;
    FPath: string;
    FVersion: string;
    FVersionWords: array[0 .. 3] of Word;
    FDefaultExeNames: TStringlist;
    FRedirectOutput: Boolean;
    FShowAppWindow: Boolean;
    FTempDir: string;

    FOutputMemo: TMemo;
    FCommandLineCounter: Integer;
    FjvcpAppProcess: TJvCreateProcess;
    FProcessAborted: Boolean;
    FCleanUp: Boolean;
    FRawRead: Boolean;
    FOnCuttingTerminate: TJvCPSTerminateEvent;

    procedure SetPath(const Value: string);
    procedure SetName(const Value: string);
    function GetVersionWords(Index: Integer): Word;
    procedure SetRedirectOutput(const Value: Boolean);
    procedure SetShowAppWindow(const Value: Boolean);
    procedure SetTempDir(const Value: string);
    procedure SetOutputMemo(const Value: TMemo);
    procedure jvcpAppProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
    procedure jvcpAppProcessRawRead(Sender: TObject; const S: string);
    procedure jvcpAppProcessTerminate(Sender: TObject; ExitCode: Cardinal);
    procedure SetCleanUp(const Value: Boolean);
    procedure SetRawRead(const Value: Boolean);
  protected
    FHasSmartRendering: Boolean;
    FCommandLines: TStringList; // ONLY command line parameters WITHOUT path to exe file!!!
    property RawRead: Boolean read FRawRead write SetRawRead;
    function ExecuteCutProcess: Boolean;
    function GetIniSectionName: string; virtual;
    procedure CommandLineTerminate(Sender: TObject; const CommandLineIndex: Integer; const CommandLine: string); virtual;
    property CutApplicationProcess: TJvCreateProcess read FjvcpAppProcess;
  public
    CutAppSettings: RCutAppSettings;
    FrameClass: TCutApplicationFrameClass;
    property OutputMemo: TMemo read FOutputMemo write SetOutputMemo;
    property OnCuttingTerminate: TJvCPSTerminateEvent read FOnCuttingTerminate write FOnCuttingTerminate;
    procedure AbortCutProcess;
    procedure EmergencyTerminateProcess;

    property Name: string read FName write SetName;
    property DefaultExeNames: TStringlist read FDefaultExeNames write FDefaultExeNames;
    property Path: string read FPath write SetPath;
    property TempDir: string read FTempDir write SetTempDir;
    property RedirectOutput: Boolean read FRedirectOutput write SetRedirectOutput;
    property ShowAppWindow: Boolean read FShowAppWindow write SetShowAppWindow;
    property CleanUp: Boolean read FCleanUp write SetCleanUp;
    property Version: string read FVersion;
    property VersionWords[Index: Integer]: Word read GetVersionWords;
    property HasSmartRendering: Boolean read FHasSmartRendering;

    constructor Create; virtual;
    destructor Destroy; override;
    function LoadSettings(IniFile: TCustomIniFile): Boolean; virtual;
    function SaveSettings(IniFile: TCustomIniFile): Boolean; virtual;
    function InfoString: string; virtual;
    function WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean; virtual;

    function PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean; virtual;
    property CommandLines: TStringList read FCommandLines;
    function StartCutting: Boolean; virtual;
    function CleanUpAfterCutting: Boolean; virtual;
    function CheckOutputForErrors: Boolean; virtual;
  end;

implementation

{$WARN UNIT_PLATFORM OFF}

uses
  // Delphi
  Winapi.Windows, Winapi.Messages, System.SysUtils, Vcl.FileCtrl,

  // CA
  CAResources;

{$R *.dfm}

{TfrmCutApplicationBase}

procedure TfrmCutApplicationBase.Apply;
begin
  if FileExists(edtPath.Text) then
    CutApplication.Path := edtPath.Text;

  CutApplication.TempDir        := edtTempDir.Text;
  CutApplication.RedirectOutput := cbRedirectOutput.Checked;
  CutApplication.ShowAppWindow  := cbShowAppWindow.Checked;
  CutApplication.CleanUp        := cbCleanUp.Checked;
end;

procedure TfrmCutApplicationBase.btnBrowsePathClick(Sender: TObject);
begin
  selectFileDlg.Title      := Format(CAResources.RsTitleSelectCutApplication, [CutApplication.Name]);
  selectFileDlg.InitialDir := ExtractFilePath(edtPath.Text);
  selectFileDlg.FileName   := ExtractFileName(edtPath.Text);

  if selectFileDlg.Execute then
    edtPath.Text := selectFileDlg.FileName;
end;

procedure TfrmCutApplicationBase.Init;
var
  S: string;
begin
  edtPath.Text             := CutApplication.Path;
  edtTempDir.Text          := CutApplication.TempDir;
  cbRedirectOutput.Checked := CutApplication.RedirectOutput;
  cbShowAppWindow.Checked  := CutApplication.ShowAppWindow;
  cbCleanUp.Checked        := CutApplication.CleanUp;

  S := '';
  AppendFilterString(S, CutApplication.Name, CutApplication.DefaultExeNames.DelimitedText);
  AppendFilterString(S, RsFilterDescriptionExecutables, '*.exe');
  AppendFilterString(S, RsFilterDescriptionAll, '*.*');
  selectFileDlg.Filter := S;
end;

procedure TfrmCutApplicationBase.SetCutApplication(const Value: TCutApplicationBase);
begin
  FCutApplication := Value;
  lblAppPath.Caption := Format(CAResources.RsCutAppPathTo, [FCutApplication.Name]);
end;

procedure TfrmCutApplicationBase.btnBrowseTempDirClick(Sender: TObject);
var
  newDir: string;
begin
  newDir := edtTempDir.Text;
  if SelectDirectory(CAResources.RsTitleSelectTemporaryDirectory, '', newDir) then
    edtTempDir.Text := newDir;
end;

{ TCutApplicationBase }

procedure TCutApplicationBase.AbortCutProcess;
begin
  if FjvcpAppProcess.State <> psReady then
  begin
    FProcessAborted := True;
    FjvcpAppProcess.CloseApplication(True);
  end;
end;

function TCutApplicationBase.CleanUpAfterCutting: Boolean;
begin
  Result := CleanUp;
end;

procedure TCutApplicationBase.CommandLineTerminate(Sender: TObject; const CommandLineIndex: Integer; const CommandLine: string);
begin
  // overwrite in descendants
end;

constructor TCutApplicationBase.Create;
begin
  inherited;
  FDefaultExeNames            := TSTringList.Create;
  FDefaultExeNames.Delimiter  := ';';
  FCommandLines               := TStringList.Create;
  FjvcpAppProcess             := TJvCreateProcess.Create(nil);
  FjvcpAppProcess.OnTerminate := jvcpAppProcessTerminate;
  FrameClass                  := TfrmCutApplicationBase;
  RedirectOutput              := False;
  ShowAppWindow               := True;
  CleanUp                     := True;
  RawRead                     := True;
  FHasSmartRendering          := False;
end;

destructor TCutApplicationBase.Destroy;
begin
  FreeAndNil(FjvcpAppProcess);
  FreeAndNil(FCommandLines);
  FreeAndNil(FDefaultExeNames);
  inherited;
end;

function TCutApplicationBase.PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean;
begin
  Result := FileExists(Path);

  if not Result then
    ErrMsgFmt(CAResources.RsCutAppNotFound, [Name, Path]);
end;

procedure TCutApplicationBase.EmergencyTerminateProcess;
begin
  if FjvcpAppProcess.State <> psReady then
  begin
    FProcessAborted := True;
    FjvcpAppProcess.Terminate;
  end;
end;

function TCutApplicationBase.ExecuteCutProcess: Boolean;
begin
  FProcessAborted := False;
  Result := False;

  if FCommandLines.Count > 0 then
  begin
    if Assigned(FOutputMemo) then
    begin
      FOutputMemo.Clear;
      if not FRedirectOutput then
        FOutputMemo.Lines.Add(CAResources.RsCutAppOutNoOutputRedirection);
    end;

    FCommandLineCounter := 0;
    jvcpAppProcessTerminate(Self, 0); // start process with first command line
    Result := True;
  end;
end;

function TCutApplicationBase.GetIniSectionName: string;
begin
  Result := Name;
end;

function TCutApplicationBase.GetVersionWords(Index: Integer): Word;
begin
  if Index in [0 .. 3] then
    Result := FVersionWords[Index]
  else
    Result := 0;
end;

function TCutApplicationBase.InfoString: string;
begin
  Result := Format(CAResources.RsCutAppInfoBase, [Name, Path, Version]);
end;

procedure TCutApplicationBase.jvcpAppProcessRawRead(Sender: TObject; const S: string);
begin
  if Assigned(FOutputMemo) and FRawRead then
  begin
    FOutputMemo.Text := FOutputMemo.Text + S;
    SendMessage(FOutputMemo.Handle, WM_VSCROLL, SB_BOTTOM, 0); // Scroll down
  end;
end;

procedure TCutApplicationBase.jvcpAppProcessRead(Sender: TObject; const S: string; const StartsOnNewLine: Boolean);
begin
  if Assigned(FOutputMemo) and not FRawRead then
  begin
    if StartsOnNewLine then
    begin
      FOutputMemo.Lines.Add(S);
      SendMessage(FOutputMemo.Handle, WM_VSCROLL, SB_BOTTOM, 0); // Scroll down
    end else
      FOutputMemo.Lines.Strings[Pred(FOutPutMemo.Lines.Count)] := S;
  end;
end;

procedure TCutApplicationBase.jvcpAppProcessTerminate(Sender: TObject; ExitCode: Cardinal);
begin
  if FCommandLineCounter > 0 then
    CommandLineTerminate(Sender, Pred(FCommandLineCounter), FCommandLines[Pred(FCommandLineCounter)]);

  if (FCommandLineCounter >= FCommandLines.Count) or (ExitCode <> 0) or FProcessAborted then
  begin
    if ExitCode = 0 then
    begin
      if Assigned(FOutputMemo) then
        FOutputMemo.Lines.Add(CAResources.RsCutAppOutFinished);
    end else
    begin
      if Assigned(FOutputMemo) then
      begin
        if not CheckOutputForErrors then
        begin
          FOutputMemo.Lines.Add(CAResources.RsCutAppOutErrorCommand);
          FOutputMemo.Lines.Add(FCommandLines[FCommandLineCounter - 1]);
        end;
      end;
    end;
    if FProcessAborted then
    begin
      if Assigned(FOutputMemo) then
        FOutputMemo.Lines.Add(CAResources.RsCutAppOutUserAbort);
      ExitCode := Cardinal(-1);
    end;
    if Assigned(FOnCuttingTerminate) then
      FOnCuttingTerminate(Sender, ExitCode);
  end else
  begin
    // Next Command Line
    FjvcpAppProcess.CommandLine := '"' + FPath + '" ' + FCommandLines[FCommandLineCounter];
    FOutputMemo.Lines.Add(FjvcpAppProcess.CommandLine);
    Inc(FCommandLineCounter);
    FjvcpAppProcess.Run;
  end;
end;

function TCutApplicationBase.CheckOutputForErrors: Boolean;
begin
  Result := False;
end;

function TCutApplicationBase.LoadSettings(IniFile: TCustomIniFile): Boolean;
const
  TEMP_DIR = 'temp';
var
  section: string;
begin
  section := GetIniSectionName;
  if Path = '' then
  begin
    if DefaultExeNames.Count > 0 then
      Path := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + DefaultExeNames.Strings[0];
  end;
  Path := IniFile.ReadString(section, 'Path', Path);
  if TempDir = '' then
    TempDir := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + TEMP_DIR);
  TempDir := IniFile.ReadString(section, 'TempDir', TempDir);
  RedirectOutput := iniFile.ReadBool(Section, 'RedirectOutput', RedirectOutput);
  ShowAppWindow := iniFile.ReadBool(Section, 'ShowAppWindow', ShowAppWindow);
  CleanUp := iniFile.ReadBool(Section, 'CleanUp', CleanUp);
  Result := True;
end;

function TCutApplicationBase.SaveSettings(IniFile: TCustomIniFile): Boolean;
var
  section: string;
begin
  section := GetIniSectionName;
  IniFile.WriteString(section, 'Path', Path);
  IniFile.WriteString(section, 'TempDir', TempDir);
  IniFile.WriteBool(section, 'RedirectOutput', RedirectOutput);
  IniFile.WriteBool(section, 'ShowAppWindow', ShowAppWindow);
  IniFile.WriteBool(section, 'CleanUp', CleanUp);
  Result := True;
end;

function TCutApplicationBase.WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean;
begin
  cutlistfile.WriteString(section, 'IntendedCutApplicationName', Name);
  cutlistfile.WriteString(section, 'IntendedCutApplication', ExtractFileName(Path));
  cutlistfile.WriteString(section, 'IntendedCutApplicationVersion', Version);
  Result := True;
end;

procedure TCutApplicationBase.SetCleanUp(const Value: Boolean);
begin
  FCleanUp := Value;
end;

procedure TCutApplicationBase.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TCutApplicationBase.SetOutputMemo(const Value: TMemo);
begin
  if Value <> FOutputMemo then
  begin
    FOutputMemo := Value;
    if Assigned(FOutputMemo) then
    begin
      if FRawRead then
      begin
        FjvcpAppProcess.OnRead := nil;
        FjvcpAppProcess.OnRawRead := jvcpAppProcessRawRead;
      end else
      begin
        FjvcpAppProcess.OnRead := jvcpAppProcessRead;
        FjvcpAppProcess.OnRawRead := nil;
      end;
    end else
    begin
      FjvcpAppProcess.OnRead := nil;
      FjvcpAppProcess.OnRawRead := nil;
    end;
  end;
end;

procedure TCutApplicationBase.SetPath(const Value: string);
var
  dwFileVersionMS, dwFileVersionLS : DWORD;
begin
  if FileExists(Value) then
  begin
    FPath := Value;
    if Get_File_Version(Value, dwFileVersionMS, dwFileVersionLS) then
    begin
      FVersion         := Get_File_Version(Value);
      FVersionWords[0] := HiWord(dwFileVersionMS);
      FVersionWords[1] := LoWord(dwFileVersionMS);
      FVersionWords[2] := HiWord(dwFileVersionLS);
      FVersionWords[3] := LoWord(dwFileVersionLS);
    end else
    begin
      FVersion         := '';
      FVersionWords[0] := 0;
      FVersionWords[1] := 0;
      FVersionWords[2] := 0;
      FVersionWords[3] := 0;
    end;
  end;
end;

procedure TCutApplicationBase.SetRawRead(const Value: Boolean);
begin
  FRawRead := Value;
  if Assigned(FOutputMemo) then
  begin
    if FRawRead then
    begin
      FjvcpAppProcess.OnRead := nil;
      FjvcpAppProcess.OnRawRead := jvcpAppProcessRawRead;
    end else
    begin
      FjvcpAppProcess.OnRead := jvcpAppProcessRead;
      FjvcpAppProcess.OnRawRead := nil;
    end;
  end;
end;

procedure TCutApplicationBase.SetRedirectOutput(const Value: Boolean);
begin
  FRedirectOutput := Value;

  if Value then
    FjvcpAppProcess.ConsoleOptions := [coRedirect, coOwnerData]
  else
    FjvcpAppProcess.ConsoleOptions := [];
end;

procedure TCutApplicationBase.SetShowAppWindow(const Value: Boolean);
begin
  FShowAppWindow := Value;
  if Value then
  begin
    FjvcpAppProcess.StartupInfo.ShowWindow := swNormal;
    FjvcpAppProcess.StartupInfo.DefaultWindowState := True;
  end else
  begin
    FjvcpAppProcess.StartupInfo.ShowWindow := swHide;
    FjvcpAppProcess.StartupInfo.DefaultWindowState := False;
  end;
end;

procedure TCutApplicationBase.SetTempDir(const Value: string);
begin
  FTempDir := Value;
end;

function TCutApplicationBase.StartCutting: Boolean;
begin
  Result := ExecuteCutProcess;
end;

end.

