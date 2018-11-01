UNIT UCutApplicationAviDemux;

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
  UCutApplicationBase,
  StdCtrls,
  IniFiles,
  Contnrs,
  JvExStdCtrls,
  JvCheckBox;

CONST
  AVIDEMUX_DEFAULT_EXENAME         = 'avidemux2.exe';
  AVIDEMUX_DEFAULT_EXENAME_GTK     = 'avidemux2_gtk.exe';
  AVIDEMUX_DEFAULT_EXENAME_QT4     = 'avidemux2_qt4.exe';
  AVIDEMUX_DEFAULT_EXENAME_CLI     = 'avidemux2_cli.exe';

TYPE
  TCutApplicationAviDemux = CLASS;

  TfrmCutApplicationAviDemux = CLASS(TfrmCutApplicationBase)
    edtADCommandLineOptions: TEdit;
    lblCommandLineOptions: TLabel;
    cbADRebuildIndex: TJvCheckBox;
    cbADScanVBR: TJvCheckBox;
    cbADSmartCopy: TJvCheckBox;
    cbADNoGUI: TJvCheckBox;
    cbADAutoSave: TJvCheckBox;
    cbADNotClose: TJvCheckBox;
  PRIVATE
    { Private declarations }
    PROCEDURE SetCutApplication(CONST Value: TCutApplicationAviDemux);
    FUNCTION GetCutApplication: TCutApplicationAviDemux;
  PUBLIC
    { Public declarations }
    PROPERTY CutApplication: TCutApplicationAviDemux READ GetCutApplication WRITE SetCutApplication;
    PROCEDURE Init; OVERRIDE;
    PROCEDURE Apply; OVERRIDE;
  END;

  TCutApplicationAviDemux = CLASS(TCutApplicationBase)
  PROTECTED
    FScriptFileName: STRING;
    FUNCTION CreateADScript(cutlist: TObjectList; Inputfile, Outputfile: STRING; VAR scriptfile: STRING): boolean;
  PUBLIC
    CommandLineOptions: STRING;
    RebuildIndex,
      ScanVBR,
      SmartCopy,
      NoGUI,
      AutoSave,
      NotClose: boolean;

    //TempDir: string;
    CONSTRUCTOR create; OVERRIDE;
    FUNCTION LoadSettings(IniFile: TCustomIniFile): boolean; OVERRIDE;
    FUNCTION SaveSettings(IniFile: TCustomIniFile): boolean; OVERRIDE;
    FUNCTION InfoString: STRING; OVERRIDE;
    FUNCTION WriteCutlistInfo(CutlistFile: TCustomIniFile; section: STRING): boolean; OVERRIDE;
    FUNCTION PrepareCutting(SourceFileName: STRING; VAR DestFileName: STRING; Cutlist: TObjectList): boolean; OVERRIDE;
    FUNCTION CleanUpAfterCutting: boolean; OVERRIDE;
  END;

VAR
  frmCutApplicationAviDemux        : TfrmCutApplicationAviDemux;

IMPLEMENTATION

{$R *.dfm}

{$WARN UNIT_PLATFORM OFF}

USES
  CAResources,
  FileCtrl,
  StrUtils,
  Utils,
  UCutlist,
  UfrmCutting,
  Main;


{ TCutApplicationAviDemux }

CONSTRUCTOR TCutApplicationAviDemux.create;
BEGIN
  INHERITED;
  FrameClass := TfrmCutApplicationAviDemux;
  Name := 'AviDemux';
  DefaultExeNames.Add(AVIDEMUX_DEFAULT_EXENAME);
  DefaultExeNames.Add(AVIDEMUX_DEFAULT_EXENAME_GTK);
  DefaultExeNames.Add(AVIDEMUX_DEFAULT_EXENAME_QT4);
  DefaultExeNames.Add(AVIDEMUX_DEFAULT_EXENAME_CLI);
  RedirectOutput := false;
  ShowAppWindow := true;
END;

FUNCTION TCutApplicationAviDemux.LoadSettings(IniFile: TCustomIniFile): boolean;
VAR
  section                          : STRING;
  success                          : boolean;
BEGIN
  //This part only for compatibility issues for versions below 0.9.9
  //This Setting may be overwritten below
  self.TempDir := IniFile.ReadString('AviDemux', 'ScriptsPath', '');

  success := INHERITED LoadSettings(IniFile);
  section := GetIniSectionName;
  CommandLineOptions := IniFile.ReadString(section, 'CommandLineOptions', CommandLineOptions);

  self.NotClose := IniFile.ReadBool(section, 'NotClose', false);
  self.AutoSave := IniFile.ReadBool(section, 'StartAndRun', true); //only for Compatibility to 0.9.7.x
  self.AutoSave := IniFile.ReadBool(section, 'AutoSave', self.AutoSave);
  self.RebuildIndex := IniFile.ReadBool(section, 'RebuildIndex', false);
  self.ScanVBR := IniFile.ReadBool(section, 'ScanVBR', true);
  self.SmartCopy := IniFile.ReadBool(section, 'SmartCopy', true);
  self.NoGUI := IniFile.ReadBool(section, 'NoGUI', false);
  result := success;
END;

FUNCTION TCutApplicationAviDemux.SaveSettings(IniFile: TCustomIniFile): boolean;
VAR
  section                          : STRING;
  success                          : boolean;
BEGIN
  success := INHERITED SaveSettings(IniFile);

  section := GetIniSectionName;
  IniFile.WriteString(section, 'CommandLineOptions', CommandLineOptions);

  IniFile.WriteBool(section, 'RebuildIndex', self.RebuildIndex);
  IniFile.WriteBool(section, 'ScanVBR', self.ScanVBR);
  IniFile.WriteBool(section, 'AutoSave', self.AutoSave);
  IniFile.WriteBool(section, 'NoGUI', self.NoGUI);
  IniFile.WriteBool(section, 'NotClose', self.NotClose);
  IniFile.WriteBool(section, 'SmartCopy', self.SmartCopy);
  result := success;
END;

FUNCTION TCutApplicationAviDemux.PrepareCutting(SourceFileName: STRING;
  VAR DestFileName: STRING; Cutlist: TObjectList): boolean;
VAR
  TempCutlist                      : TCutlist;
  MustFreeTempCutlist              : boolean;
  CommandLine, message_string      : STRING;
BEGIN
  result := INHERITED PrepareCutting(SourceFileName, DestFileName, Cutlist);
  IF NOT Result THEN
    Exit;

  self.FCommandLines.Clear;
  MustFreeTempCutlist := false;
  TempCutlist := (Cutlist AS TCutlist);

  IF TempCutlist.Mode <> clmTrim THEN BEGIN
    TempCutlist := TempCutlist.convert;
    MustFreeTempCutlist := True;
  END;

  TRY
    FScriptFileName := '';
    IF self.TempDir = '' THEN BEGIN
      FScriptFileName := SourceFileName + '.avidemux';
    END ELSE BEGIN
      IF NOT DirectoryExists(TempDir) THEN BEGIN
        message_string := Format(CAResources.RsMsgCutAppTempDirMissing, [TempDir]);
        IF application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONWARNING) = IDYES THEN
          ForceDirectories(TempDir);
      END;
      IF NOT DirectoryExists(TempDir) THEN
        Exit;

      FScriptFileName := IncludeTrailingPathDelimiter(TempDir) + ExtractFileName(SourceFileName) + '.avidemux';
    END;

    CreateADScript(TempCutlist, SourceFileName, DestFileName, FScriptFileName);

    CommandLine := '';
    IF NoGUI THEN
      CommandLine := '--nogui ';
    CommandLine := CommandLine + '--run "' + FScriptFileName + '"';
    IF SmartCopy THEN
      CommandLine := CommandLine + ' --force-smart ';
    IF AutoSave THEN
      CommandLine := CommandLine + ' --save "' + DestFileName + '"';
    IF (NOT NotClose) AND AutoSave THEN
      CommandLine := CommandLine + ' --quit';
    CommandLine := CommandLine + ' ' + self.CommandLineOptions;

    self.FCommandLines.Add(CommandLine);
    result := true;
  FINALLY
    IF MustFreeTempCutlist THEN
      FreeAndNIL(TempCutlist);
  END;
END;


FUNCTION TCutApplicationAviDemux.InfoString: STRING;
BEGIN
  Result := Format(CAResources.RsCutAppInfoAviDemux, [
    INHERITED InfoString,
      self.CommandLineOptions,
      BoolToStr(self.RebuildIndex, true),
      BoolToStr(self.ScanVBR, true),
      BoolToStr(self.SmartCopy, true)
      ]);
END;

FUNCTION TCutApplicationAviDemux.WriteCutlistInfo(CutlistFile: TCustomIniFile;
  section: STRING): boolean;
BEGIN
  result := INHERITED WriteCutlistInfo(CutlistFile, section);
  IF result THEN BEGIN
    cutlistfile.WriteString(section, 'IntendedCutApplicationOptions', self.CommandLineOptions);
    cutlistfile.WriteBool(section, 'AviDemuxRebuildIndex', self.RebuildIndex);
    cutlistfile.WriteBool(section, 'AviDemuxScanVBR', self.ScanVBR);
    cutlistfile.WriteBool(section, 'AviDemuxSmartCopy', self.SmartCopy);
    result := true;
  END;
END;

FUNCTION TCutApplicationAviDemux.CreateADScript(cutlist: TObjectList;
  Inputfile, Outputfile: STRING; VAR scriptfile: STRING): boolean;

  FUNCTION EscapeString(s: STRING): STRING;
  BEGIN
    result := AnsiReplaceStr(s, '\', '\\');
    result := AnsiReplaceStr(Result, '''', '\''');
  END;

VAR
  f                                : Textfile;
  i                                : integer;
  vdubStart, vdubLength            : STRING;
  cutlist_tmp                      : TCutlist;
BEGIN
  cutlist_tmp := cutlist AS TCutlist;
  IF scriptfile = '' THEN
    scriptfile := Inputfile + '.avidemux';
  assignfile(f, scriptfile);
  rewrite(f);
  writeln(f, '//AD  <- Needed to identify//');
  writeln(f, '//--Generated by ' + Application_friendly_name);
  writeln(f, '');
  writeln(f, 'var app = new Avidemux();');
  writeln(f, '');
  writeln(f, '//** Video **');
  writeln(f, 'app.load("' + EscapeString(Inputfile) + '");');
  writeln(f, 'app.clearSegments();');

  cutlist_tmp.sort;
  FOR i := 0 TO cutlist_tmp.Count - 1 DO BEGIN
    IF cutlist_tmp.FramesPresent AND NOT cutlist_tmp.HasChanged THEN BEGIN
      vdubstart := inttostr(cutlist_tmp.Cut[i].frame_from);
      vdubLength := inttostr(cutlist_tmp.Cut[i].DurationFrames);
    END ELSE BEGIN
      vdubstart := inttostr(round(cutlist_tmp.Cut[i].pos_from / MovieInfo.frame_duration));
      vdubLength := inttostr(round((cutlist_tmp.Cut[i].pos_to - cutlist_tmp.Cut[i].pos_from) / MovieInfo.frame_duration + 1));
    END;
    writeln(f, 'app.addSegment(0,' + vdubstart + ', ' + vdubLength + ');');
  END;

  IF RebuildIndex THEN
    writeln(f, 'app.rebuildIndex();');
  writeln(f, '');
  writeln(f, '//** Postproc **');
  writeln(f, 'app.video.setPostProc(3,3,0);');
  writeln(f, 'app.video.codec("Copy","CQ=4","0 ");');
  writeln(f, '');
  writeln(f, '//** Audio **');
  writeln(f, 'app.audio.reset();');
  writeln(f, 'app.audio.codec("copy",128);');
  writeln(f, 'app.audio.normalize=false;');
  writeln(f, 'app.audio.delay=0;');
  IF ScanVBR THEN
    writeln(f, 'app.audio.scanVBR();');
  writeln(f, '');
  writeln(f, 'app.setContainer("AVI");');
  IF SmartCopy THEN
    writeln(f, 'app.smartCopyMode();');
  IF AutoSave THEN BEGIN
    writeln(f, 'setSuccess(app.save("' + EscapeString(Outputfile) + '"));');
  END ELSE BEGIN
    writeln(f, 'setSuccess(1);');
  END;

  closefile(f);
  result := true;
END;

FUNCTION TCutApplicationAviDemux.CleanUpAfterCutting: boolean;
VAR
  success                          : boolean;
BEGIN
  result := false;
  IF self.CleanUp THEN BEGIN
    result := INHERITED CleanUpAfterCutting;
    IF FileExists(FScriptFileName) THEN BEGIN
      success := DeleteFile(FScriptFileName);
      result := result AND success;
    END;
  END;
END;

{ TfrmCutApplicationAviDemux }

PROCEDURE TfrmCutApplicationAviDemux.Init;
BEGIN
  INHERITED;
  self.edtADCommandLineOptions.Text := CutApplication.CommandLineOptions;
  CBADAutoSave.Checked := CutApplication.AutoSave;
  CBADNotClose.Checked := CutApplication.NotClose;
  CBADRebuildIndex.Checked := CutApplication.RebuildIndex;
  CBADScanVBR.Checked := CutApplication.ScanVBR;
  CBADSmartCopy.Checked := CutApplication.SmartCopy;
  CBADNoGUI.Checked := CutApplication.NoGUI;
END;

PROCEDURE TfrmCutApplicationAviDemux.Apply;
BEGIN
  INHERITED;
  CutApplication.CommandLineOptions := edtADCommandLineOptions.Text;

  CutApplication.AutoSave := CBADAutoSave.Checked;
  CutApplication.NotClose := CBADNotClose.Checked;
  CutApplication.RebuildIndex := CBADRebuildIndex.Checked;
  CutApplication.ScanVBR := CBADScanVBR.Checked;
  CutApplication.SmartCopy := CBADSmartCopy.Checked;
  CutApplication.NoGUI := CBADNoGUI.Checked;
END;

PROCEDURE TfrmCutApplicationAviDemux.SetCutApplication(
  CONST Value: TCutApplicationAviDemux);
BEGIN
  FCutApplication := Value;
END;

FUNCTION TfrmCutApplicationAviDemux.GetCutApplication: TCutApplicationAviDemux;
BEGIN
  result := (self.FCutApplication AS TCutApplicationAviDemux);
END;

END.
