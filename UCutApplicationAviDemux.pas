unit UCutApplicationAviDemux;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, System.IniFiles, System.Contnrs, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms,

  // Jedi
  JvExStdCtrls, JvCheckBox,

  // CA
  UCutApplicationBase;

type
  TCutApplicationAviDemux = class;

  TfrmCutApplicationAviDemux = class(TfrmCutApplicationBase)
    edtADCommandLineOptions: TEdit;
    lblCommandLineOptions: TLabel;
    cbADRebuildIndex: TJvCheckBox;
    cbADScanVBR: TJvCheckBox;
    cbADSmartCopy: TJvCheckBox;
    cbADNoGUI: TJvCheckBox;
    cbADAutoSave: TJvCheckBox;
    cbADNotClose: TJvCheckBox;
  private
    { private declarations }
    procedure SetCutApplication(const Value: TCutApplicationAviDemux);
    function GetCutApplication: TCutApplicationAviDemux;
  public
    { public declarations }
    property CutApplication: TCutApplicationAviDemux read GetCutApplication write SetCutApplication;
    procedure Init; override;
    procedure Apply; override;
  end;

  TCutApplicationAviDemux = class(TCutApplicationBase)
  protected
    FScriptFileName: string;
    function CreateADScript(cutlist: TObjectList; Inputfile, Outputfile: string; var scriptfile: string): Boolean;
  public
    CommandLineOptions: string;
    RebuildIndex,
    ScanVBR,
    SmartCopy,
    NoGUI,
    AutoSave,
    NotClose: Boolean;
    //TempDir: string;
    constructor Create; override;
    function LoadSettings(IniFile: TCustomIniFile): Boolean; override;
    function SaveSettings(IniFile: TCustomIniFile): Boolean; override;
    function InfoString: string; override;
    function WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean; override;
    function PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean; override;
    function CleanUpAfterCutting: Boolean; override;
  end;

var
  frmCutApplicationAviDemux: TfrmCutApplicationAviDemux;

implementation

{$R *.dfm}

{....$WARN UNIT_PLATFORM OFF}

uses
  // Delphi
  Winapi.Windows, System.SysUtils, System.StrUtils, Winapi.ActiveX,

  // Jedi
  JvCreateProcess,

  // CA
  CAResources, Main, Utils, UCutlist;

const
  AVIDEMUX_DEFAULT_EXENAME     = 'avidemux2.exe';
  AVIDEMUX_DEFAULT_EXENAME_GTK = 'avidemux2_gtk.exe';
  AVIDEMUX_DEFAULT_EXENAME_QT4 = 'avidemux2_qt4.exe';
  AVIDEMUX_DEFAULT_EXENAME_CLI = 'avidemux2_cli.exe';

{ TCutApplicationAviDemux }

constructor TCutApplicationAviDemux.Create;
begin
  inherited;
  FrameClass := TfrmCutApplicationAviDemux;
  Name       := 'AviDemux';
  DefaultExeNames.Add(AVIDEMUX_DEFAULT_EXENAME);
  DefaultExeNames.Add(AVIDEMUX_DEFAULT_EXENAME_GTK);
  DefaultExeNames.Add(AVIDEMUX_DEFAULT_EXENAME_QT4);
  DefaultExeNames.Add(AVIDEMUX_DEFAULT_EXENAME_CLI);
  RedirectOutput := False;
  ShowAppWindow  := True;
end;

function TCutApplicationAviDemux.LoadSettings(IniFile: TCustomIniFile): Boolean;
var
  section: string;
  success: Boolean;
begin
  // This part only for compatibility issues for versions below 0.9.9
  // This Setting may be overwritten below
  TempDir := IniFile.ReadString('AviDemux', 'ScriptsPath', '');

  success := inherited LoadSettings(IniFile);
  section := GetIniSectionName;
  CommandLineOptions := IniFile.ReadString(section, 'CommandLineOptions', CommandLineOptions);

  NotClose     := IniFile.ReadBool(section, 'NotClose', False);
  AutoSave     := IniFile.ReadBool(section, 'StartAndRun', True); //only for Compatibility to 0.9.7.x
  AutoSave     := IniFile.ReadBool(section, 'AutoSave', AutoSave);
  RebuildIndex := IniFile.ReadBool(section, 'RebuildIndex', False);
  ScanVBR      := IniFile.ReadBool(section, 'ScanVBR', True);
  SmartCopy    := IniFile.ReadBool(section, 'SmartCopy', True);
  NoGUI        := IniFile.ReadBool(section, 'NoGUI', False);
  Result       := success;
end;

function TCutApplicationAviDemux.SaveSettings(IniFile: TCustomIniFile): Boolean;
var
  section: string;
  success: Boolean;
begin
  success := inherited SaveSettings(IniFile);

  section := GetIniSectionName;
  IniFile.WriteString(section, 'CommandLineOptions', CommandLineOptions);

  IniFile.WriteBool(section, 'RebuildIndex', RebuildIndex);
  IniFile.WriteBool(section, 'ScanVBR', ScanVBR);
  IniFile.WriteBool(section, 'AutoSave', AutoSave);
  IniFile.WriteBool(section, 'NoGUI', NoGUI);
  IniFile.WriteBool(section, 'NotClose', NotClose);
  IniFile.WriteBool(section, 'SmartCopy', SmartCopy);
  Result := success;
end;

function TCutApplicationAviDemux.PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean;
var
  TempCutlist: TCutlist;
  MustFreeTempCutlist: Boolean;
  CommandLine: string;
begin
  Result := inherited PrepareCutting(SourceFileName, DestFileName, Cutlist);
  if Result then
  begin
    FCommandLines.Clear;
    MustFreeTempCutlist := False;
    TempCutlist := (Cutlist as TCutlist);

    if TempCutlist.Mode <> clmTrim then
    begin
      TempCutlist := TempCutlist.convert;
      MustFreeTempCutlist := True;
    end;

    try
      FScriptFileName := '';
      if TempDir = '' then
      begin
        FScriptFileName := SourceFileName + '.avidemux';
      end else begin
        if not DirectoryExists(TempDir) then
        begin
          if YesNoWarnMsgFmt(CAResources.RsMsgCutAppTempDirMissing, [TempDir]) then
            ForceDirectories(TempDir);
        end;
        if not DirectoryExists(TempDir) then
          Exit;

        FScriptFileName := IncludeTrailingPathDelimiter(TempDir) + ExtractFileName(SourceFileName) + '.avidemux';
      end;

      CreateADScript(TempCutlist, SourceFileName, DestFileName, FScriptFileName);

      CommandLine := '';
      if NoGUI then
        CommandLine := '--nogui ';
      CommandLine := CommandLine + '--run "' + FScriptFileName + '"';
      if SmartCopy then
        CommandLine := CommandLine + ' --force-smart ';
      if AutoSave then
        CommandLine := CommandLine + ' --save "' + DestFileName + '"';
      if (not NotClose) and AutoSave then
        CommandLine := CommandLine + ' --quit';
      CommandLine := CommandLine + ' ' + CommandLineOptions;

      FCommandLines.Add(CommandLine);
      Result := True;
    finally
      if MustFreeTempCutlist then
        FreeAndNil(TempCutlist);
    end;
  end;
end;

function TCutApplicationAviDemux.InfoString: string;
begin
  Result := Format(CAResources.RsCutAppInfoAviDemux, [inherited InfoString, CommandLineOptions, BoolToStr(RebuildIndex, True), BoolToStr(ScanVBR, True), BoolToStr(SmartCopy, True)]);
end;

function TCutApplicationAviDemux.WriteCutlistInfo(CutlistFile: TCustomIniFile;
  section: string): Boolean;
begin
  Result := inherited WriteCutlistInfo(CutlistFile, section);
  if Result then
  begin
    cutlistfile.WriteString(section, 'IntendedCutApplicationOptions', CommandLineOptions);
    cutlistfile.WriteBool(section, 'AviDemuxRebuildIndex', RebuildIndex);
    cutlistfile.WriteBool(section, 'AviDemuxScanVBR', ScanVBR);
    cutlistfile.WriteBool(section, 'AviDemuxSmartCopy', SmartCopy);
  end;
end;

function TCutApplicationAviDemux.CreateADScript(cutlist: TObjectList; Inputfile, Outputfile: string; var scriptfile: string): Boolean;

  function EscapeString(s: string): string;
  begin
    Result := AnsiReplaceStr(s, '\', '\\');
    Result := AnsiReplaceStr(Result, '''', '\''');
  end;

var
  f: Textfile;
  i: Integer;
  vdubStart, vdubLength: string;
  cutlist_tmp: TCutlist;
begin
  cutlist_tmp := cutlist as TCutlist;
  if scriptfile = '' then
    scriptfile := Inputfile + '.avidemux';
  AssignFile(f, scriptfile);
  Rewrite(f);
  Writeln(f, '//AD  <- Needed to identify//');
  Writeln(f, '//--Generated by ' + Application_friendly_name);
  Writeln(f, '');
  Writeln(f, 'var app = new Avidemux();');
  Writeln(f, '');
  Writeln(f, '//** Video **');
  Writeln(f, 'app.load("' + EscapeString(Inputfile) + '");');
  Writeln(f, 'app.clearSegments();');

  cutlist_tmp.sort;
  for i := 0 to Pred(cutlist_tmp.Count) do
  begin
    if cutlist_tmp.FramesPresent and not cutlist_tmp.HasChanged then
    begin
      vdubstart  := IntToStr(cutlist_tmp.Cut[i].frame_from);
      vdubLength := IntToStr(cutlist_tmp.Cut[i].DurationFrames);
    end else
    begin
      vdubstart  := IntToStr(Round(cutlist_tmp.Cut[i].pos_from / MovieInfo.frame_duration));
      vdubLength := IntToStr(Round((cutlist_tmp.Cut[i].pos_to - cutlist_tmp.Cut[i].pos_from) / MovieInfo.frame_duration + 1));
    end;
    Writeln(f, 'app.addSegment(0,' + vdubstart + ', ' + vdubLength + ');');
  end;

  if RebuildIndex then
    Writeln(f, 'app.rebuildIndex();');
  Writeln(f, '');
  Writeln(f, '//** Postproc **');
  Writeln(f, 'app.video.setPostProc(3,3,0);');
  Writeln(f, 'app.video.codec("Copy","CQ=4","0 ");');
  Writeln(f, '');
  Writeln(f, '//** Audio **');
  Writeln(f, 'app.audio.reset();');
  Writeln(f, 'app.audio.codec("Copy",128);');
  Writeln(f, 'app.audio.normalize=False;');
  Writeln(f, 'app.audio.delay=0;');
  if ScanVBR then
    Writeln(f, 'app.audio.scanVBR();');
  Writeln(f, '');
  Writeln(f, 'app.setContainer("AVI");');
  if SmartCopy then
    Writeln(f, 'app.smartCopyMode();');
  if AutoSave then
    Writeln(f, 'setSuccess(app.save("' + EscapeString(Outputfile) + '"));')
  else
    Writeln(f, 'setSuccess(1);');

  CloseFile(f);
  Result := True;
end;

function TCutApplicationAviDemux.CleanUpAfterCutting: Boolean;
var
  success: Boolean;
begin
  if CleanUp then
  begin
    Result := inherited CleanUpAfterCutting;
    if FileExists(FScriptFileName) then
    begin
      success := DeleteFile(FScriptFileName);
      Result  := Result and success;
    end;
  end else
    Result := False;
end;

{ TfrmCutApplicationAviDemux }

procedure TfrmCutApplicationAviDemux.Init;
begin
  inherited;
  edtADCommandLineOptions.Text := CutApplication.CommandLineOptions;
  CBADAutoSave.Checked         := CutApplication.AutoSave;
  CBADNotClose.Checked         := CutApplication.NotClose;
  CBADRebuildIndex.Checked     := CutApplication.RebuildIndex;
  CBADScanVBR.Checked          := CutApplication.ScanVBR;
  CBADSmartCopy.Checked        := CutApplication.SmartCopy;
  CBADNoGUI.Checked            := CutApplication.NoGUI;
end;

procedure TfrmCutApplicationAviDemux.Apply;
begin
  inherited;
  CutApplication.CommandLineOptions := edtADCommandLineOptions.Text;
  CutApplication.AutoSave           := CBADAutoSave.Checked;
  CutApplication.NotClose           := CBADNotClose.Checked;
  CutApplication.RebuildIndex       := CBADRebuildIndex.Checked;
  CutApplication.ScanVBR            := CBADScanVBR.Checked;
  CutApplication.SmartCopy          := CBADSmartCopy.Checked;
  CutApplication.NoGUI              := CBADNoGUI.Checked;
end;

procedure TfrmCutApplicationAviDemux.SetCutApplication(const Value: TCutApplicationAviDemux);
begin
  FCutApplication := Value;
end;

function TfrmCutApplicationAviDemux.GetCutApplication: TCutApplicationAviDemux;
begin
  Result := (FCutApplication as TCutApplicationAviDemux);
end;

end.

