UNIT UCutApplicationVirtualDub;

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
  CodecSettings,
  StdCtrls,
  IniFiles,
  Contnrs,
  MMSystem,
  ExtCtrls,
  JvExStdCtrls,
  JvCheckBox;

CONST
  VIRTUALDUB_DEFAULT_EXENAME       = 'virtualdub.exe';

TYPE
  TCutApplicationVirtualDub = CLASS;

  TfrmCutApplicationVirtualDub = CLASS(TfrmCutApplicationBase)
    cbNotClose: TJvCheckBox;
    cbUseSmartRendering: TJvCheckBox;
    cbShowProgressWindow: TJvCheckBox;
  PRIVATE
    { Private declarations }
    PROCEDURE SetCutApplication(CONST Value: TCutApplicationVirtualDub);
    FUNCTION GetCutApplication: TCutApplicationVirtualDub;
  PUBLIC
    { Public declarations }
    PROPERTY CutApplication: TCutApplicationVirtualDub READ GetCutApplication WRITE SetCutApplication;
    PROCEDURE Init; OVERRIDE;
    PROCEDURE Apply; OVERRIDE;
  END;

  TCutApplicationVirtualDub = CLASS(TCutApplicationBase)
  PRIVATE
    FFindProgressWindowTimer: TTimer;
    PROCEDURE SetShowProgressWindow(CONST Value: boolean);
    PROCEDURE FindProgressWindow(Sender: TObject);
  PROTECTED
    FNotClose: boolean;
    FUseSmartRendering: boolean;
    FScriptFileName: STRING;
    FShowProgressWindow: boolean;

    FUNCTION CreateScript(aCutlist: TObjectList; Inputfile, Outputfile: STRING; VAR scriptfile: STRING): boolean;
  PUBLIC
    CONSTRUCTOR Create; OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;
    PROPERTY ShowProgressWindow: boolean READ FShowProgressWindow WRITE SetShowProgressWindow;
    FUNCTION CanDoSmartRendering: boolean;
    FUNCTION UseSmartRendering: boolean;

    FUNCTION LoadSettings(IniFile: TCustomIniFile): boolean; OVERRIDE;
    FUNCTION SaveSettings(IniFile: TCustomIniFile): boolean; OVERRIDE;
    FUNCTION InfoString: STRING; OVERRIDE;
    FUNCTION WriteCutlistInfo(CutlistFile: TCustomIniFile; section: STRING): boolean; OVERRIDE;
    FUNCTION PrepareCutting(SourceFileName: STRING; VAR DestFileName: STRING; Cutlist: TObjectList): boolean; OVERRIDE;
    FUNCTION StartCutting: boolean; OVERRIDE;
    FUNCTION CleanUpAfterCutting: boolean; OVERRIDE;
    FUNCTION CheckOutputForErrors: boolean; OVERRIDE;
  END;

VAR
  frmCutApplicationVirtualDub      : TfrmCutApplicationVirtualDub;

IMPLEMENTATION

{$R *.dfm}

{$WARN UNIT_PLATFORM OFF}

USES
  FileCtrl,
  StrUtils,
  JvCreateProcess,
  DirectShow9,
  CAResources,
  Utils,
  UCutlist,
  UfrmCutting,
  Main;

TYPE
  PFindWindowStruct = ^TFindWindowStruct;
  TFindWindowStruct = RECORD
    Caption: STRING;
    ClassName: STRING;
    ProcessID: Cardinal;
    WindowHandle: THandle;
  END;

  { TCutApplicationVirtualDub }

CONSTRUCTOR TCutApplicationVirtualDub.create;
BEGIN
  INHERITED;
  FrameClass := TfrmCutApplicationVirtualDub;
  DefaultExeNames.Add(VIRTUALDUB_DEFAULT_EXENAME);
  Name := 'VirtualDub';
  RedirectOutput := true;
  ShowAppWindow := true;
  FNotClose := false;
  FUseSmartRendering := true;
  FShowProgressWindow := true;
  FFindProgressWindowTimer := TTimer.Create(Application);
  FFindProgressWindowTimer.OnTimer := FindProgressWindow;
  FFindProgressWindowTimer.Enabled := false;
  FFindProgressWindowTimer.Interval := 1000;
  FHasSmartRendering := true;
END;

DESTRUCTOR TCutApplicationVirtualDub.Destroy;
BEGIN
  //FreeAndNIL(FFindProgressWindowTimer);
  INHERITED;
END;

FUNCTION TCutApplicationVirtualDub.CheckOutputForErrors: boolean;
VAR
  outputText                       : TStrings;
  outputLine                       : STRING;
  idx                              : integer;
BEGIN
  Result := INHERITED CheckOutputForErrors;
  IF NOT Assigned(OutputMemo) THEN
    Exit;
  outputText := OutputMemo.Lines;
  FOR idx := 0 TO outputText.Count - 1 DO BEGIN
    outputLine := Trim(outputText.Strings[idx]);
    IF AnsiStartsText(CAResources.RsCutAppVDPattSmartRender, outputLine) THEN BEGIN
      IF AnsiContainsText(outputLine, CAResources.RsCutAppVDPattSmartRenderNoCodec) THEN BEGIN
        outputText.Append(CAResources.RsCutAppVDErrorSmartRenderNoCodec);
        Result := true;
        IF NOT batchmode THEN
          ShowMessageFmt(CAResources.RsCutAppVDErrorSmartRenderNoCodec, []);
      END;
      IF AnsiContainsText(outputLine, CAResources.RsCutAppVDPattSmartRenderWrongCodec) THEN BEGIN
        outputText.Append(CAResources.RsCutAppVDErrorSmartRenderWrongCodec);
        Result := true;
        IF NOT batchmode THEN
          ShowMessageFmt(CAResources.RsCutAppVDErrorSmartRenderWrongCodec, []);
      END;
    END;
  END;
END;

PROCEDURE TCutApplicationVirtualDub.SetShowProgressWindow(CONST Value: boolean);
BEGIN
  FShowProgressWindow := Value;
END;


FUNCTION TCutApplicationVirtualDub.LoadSettings(IniFile: TCustomIniFile): boolean;
  PROCEDURE SetCodecSettings(VAR s1, s2: RCutAppSettings);
  BEGIN
    IF s1.CutAppName <> s2.CutAppName THEN
      Exit;
    // do not overwrite existing settings ...
    IF s1.CodecFourCC <> 0 THEN
      Exit;
    s1.CodecName := s2.CodecName;
    s1.CodecFourCC := s2.CodecFourCC;
    s1.CodecVersion := s2.CodecVersion;
    s1.CodecSettingsSize := s2.CodecSettingsSize;
    s1.CodecSettings := s2.CodecSettings;
  END;
VAR
  section                          : STRING;
  success                          : boolean;
  StrValue                         : STRING;
  BufferSize                       : Integer;
  cas                              : RCutAppSettings;
BEGIN
  cas.PreferredSourceFilter := GUID_NULL;

  //This part only for compatibility issues for versions below 0.9.9
  //This Setting may be overwritten below
  section := 'External Cut Application';
  TempDir := IniFile.ReadString(section, 'VirtualDubScriptsPath', '');
  Path := IniFile.ReadString(section, 'VirtualDubPath', '');
  self.FNotClose := IniFile.ReadBool(section, 'VirtualDubNotClose', FNotClose);
  self.FUseSmartRendering := IniFile.ReadBool(section, 'VirtualDubUseSmartRendering', FUseSmartRendering);

  success := INHERITED LoadSettings(IniFile);
  section := GetIniSectionName;
  self.FNotClose := IniFile.ReadBool(section, 'NotClose', FNotClose);
  self.FUseSmartRendering := IniFile.ReadBool(section, 'UseSmartRendering', FUseSmartRendering);
  self.FShowProgressWindow := IniFile.ReadBool(section, 'ShowProgressWindow', FShowProgressWindow);

  //
  // Read old settings ...
  //
  StrValue := IniFile.ReadString(section, 'CodecFourCC', '0x0');
  cas.CodecFourCC := StrToInt64Def(StrValue, $00000000);
  StrValue := IniFile.ReadString(section, 'CodecVersion', '0x0');
  cas.CodecVersion := StrToInt64Def(StrValue, $00000000);
  cas.CodecSettingsSize := IniFile.ReadInteger(section, 'CodecSettingsSize', 0);

  //ini.ReadString does work only up to 2047 characters due to restrictions in iniFiles.pas
  //CodecSettings := ini.ReadString(section, 'CodecSettings', '');
  BufferSize := cas.CodecSettingsSize DIV 3;
  IF (cas.CodecSettingsSize MOD 3) > 0 THEN inc(BufferSize);
  BufferSize := BufferSize * 4 + 1; //+1 for terminating #0
  cas.CodecSettings := iniReadLargeString(IniFile, BufferSize, section, 'CodecSettings', '');
  IF Length(cas.CodecSettings) <> BufferSize - 1 THEN BEGIN
    cas.CodecSettings := '';
    cas.CodecSettingsSize := 0;
  END;

  // Convert old settings if necessary ...
  IF (cas.CodecFourCC <> 0) THEN BEGIN
    cas.CutAppName := self.Name;
    cas.CodecName := Settings.GetCodecNameByFourCC(cas.CodecFourCC);
    SetCodecSettings(Settings.CutAppSettingsWmv, cas);
    SetCodecSettings(Settings.CutAppSettingsAvi, cas);
    SetCodecSettings(Settings.CutAppSettingsHQAVI, cas);
    SetCodecSettings(Settings.CutAppSettingsMP4, cas);
    SetCodecSettings(Settings.CutAppSettingsOther, cas);
  END;

  result := success;
END;

FUNCTION TCutApplicationVirtualDub.SaveSettings(IniFile: TCustomIniFile): boolean;
VAR
  section                          : STRING;
  success                          : boolean;
BEGIN
  success := INHERITED SaveSettings(IniFile);

  section := GetIniSectionName;
  IniFile.WriteBool(section, 'NotClose', self.FNotClose);
  IniFile.WriteBool(section, 'UseSmartRendering', self.FUseSmartRendering);
  IniFile.WriteBool(section, 'ShowProgressWindow', self.FShowProgressWindow);
  // Remove old settings ...
  IniFile.DeleteKey(section, 'CodecFourCC');
  IniFile.DeleteKey(section, 'CodecVersion');
  IniFile.DeleteKey(section, 'CodecSettings');
  IniFile.DeleteKey(section, 'CodecSettingsSize');
  result := success;
END;


FUNCTION FindWindowByWindowStructParam(wHandle: HWND; lParam: Cardinal): Bool; STDCALL;
VAR
  Title, ClassName                 : ARRAY[0..255] OF char;
  dwProcessId {, dwThreadId}       : cardinal;
BEGIN
  Result := True;
  IF GetClassName(wHandle, ClassName, 255) <= 0 THEN
    exit;
  IF Pos(PFindWindowStruct(lParam).ClassName, StrPas(ClassName)) = 0 THEN
    exit;
  IF GetWindowText(wHandle, Title, 255) <= 0 THEN
    exit;
  IF Pos(PFindWindowStruct(lParam).Caption, StrPas(Title)) = 0 THEN
    exit;
  {dwThreadId := }GetWindowThreadProcessId(wHandle, dwProcessId);
  IF dwProcessId <> PFindWindowStruct(lParam).ProcessId THEN
    exit;

  PFindWindowStruct(lParam).WindowHandle := wHandle;
  Result := False;
END;

PROCEDURE TCutApplicationVirtualDub.FindProgressWindow(Sender: TObject);
CONST
  ID_OPTIONS_SHOWSTATUSWINDOW      = 40034;
VAR
  WindowInfo                       : TFindWindowStruct;
BEGIN
  IF CutApplicationProcess.State = psReady THEN {// CutApp not running ...} BEGIN
    FFindProgressWindowTimer.Enabled := false;
    Exit;
  END;

  WITH WindowInfo DO BEGIN
    Caption := 'VirtualDub Status';
    ClassName := '#32770';
    ProcessID := CutApplicationProcess.ProcessInfo.dwProcessId;
    WindowHandle := 0;
    EnumWindows(@FindWindowByWindowStructParam, LongInt(@WindowInfo));
    IF WindowHandle <> 0 THEN BEGIN
      //if not IsWindowVisible(vDubWindow) then
      ShowWindow(WindowHandle, SW_SHOW);
      // Activate progress window
      // WM_COMMAND, lParam=0, wParam=ID_OPTIONS_SHOWSTATUSWINDOW (40034)
      //SendMessage(wnd, WM_COMMAND, ID_OPTIONS_SHOWSTATUSWINDOW, 0);
      FFindProgressWindowTimer.Enabled := false;
    END;
  END;
END;

FUNCTION TCutApplicationVirtualDub.StartCutting: boolean;
BEGIN
  result := INHERITED StartCutting;
  IF result THEN BEGIN
    WaitForInputIdle(CutApplicationProcess.ProcessInfo.hProcess, 1000);
    IF FShowProgressWindow THEN
      FFindProgressWindowTimer.Enabled := true;
  END;
END;

FUNCTION TCutApplicationVirtualDub.PrepareCutting(SourceFileName: STRING;
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
      FScriptFileName := SourceFileName + '.syl';
    END ELSE BEGIN
      IF NOT DirectoryExists(TempDir) THEN BEGIN
        message_string := Format(CAResources.RsMsgCutAppTempDirMissing, [TempDir]);
        IF application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONWARNING) = IDYES THEN
          ForceDirectories(TempDir);
      END;
      IF NOT DirectoryExists(TempDir) THEN
        Exit;

      FScriptFileName := IncludeTrailingPathDelimiter(TempDir) + ExtractFileName(SourceFileName) + '.syl';
    END;

    CreateScript(TempCutlist, SourceFileName, DestFileName, FScriptFileName);

    CommandLine := '/s"' + FScriptFileName + '"';
    IF self.RedirectOutput THEN
      CommandLine := '/console ' + CommandLine;
    IF NOT self.FNotClose THEN
      CommandLine := CommandLine + ' /x';

    self.FCommandLines.Add(CommandLine);
    result := true;
  FINALLY
    IF MustFreeTempCutlist THEN
      FreeAndNIL(TempCutlist);
  END;
END;


FUNCTION TCutApplicationVirtualDub.InfoString: STRING;
VAR
  HiVer, LoVer                     : integer;
BEGIN
  HiVer := HiWord(CutAppSettings.CodecVersion);
  LoVer := LoWord(CutAppSettings.CodecVersion);
  Result := Format(CAResources.RsCutAppInfoVirtualDub, [
    INHERITED InfoString,
      BoolToStr(UseSmartRendering, true),
      CutAppSettings.CodecName,
      IntToStr(HiVer) + '.' + IntToStr(LoVer)
      ]);
END;

FUNCTION TCutApplicationVirtualDub.WriteCutlistInfo(CutlistFile: TCustomIniFile;
  section: STRING): boolean;
BEGIN
  result := INHERITED WriteCutlistInfo(CutlistFile, section);
  IF result THEN BEGIN
    cutlistfile.WriteBool(section, 'VDUseSmartRendering', self.UseSmartRendering);
    IF UseSmartRendering THEN BEGIN
      cutlistfile.WriteString(section, 'VDSmartRenderingCodecFourCC', '0x' + IntToHex(CutAppSettings.CodecFourCC, 8));
      cutlistfile.WriteString(section, 'VDSmartRenderingCodecVersion', '0x' + IntToHex(CutAppSettings.CodecVersion, 8));
    END;
    result := true;
  END;
END;

FUNCTION TCutApplicationVirtualDub.CleanUpAfterCutting: boolean;
VAR
  success                          : boolean;
BEGIN
  result := false;
  FFindProgressWindowTimer.Enabled := false;
  IF self.CleanUp THEN BEGIN
    result := INHERITED CleanUpAfterCutting;
    IF FileExists(FScriptFileName) THEN BEGIN
      success := DeleteFile(FScriptFileName);
      result := result AND success;
    END;
  END;
END;

{ TfrmCutApplicationVirtualDub }

PROCEDURE TfrmCutApplicationVirtualDub.Init;
BEGIN
  INHERITED;
  cbNotClose.Checked := CutApplication.FNotClose;
  cbUseSmartRendering.Checked := CutApplication.FUseSmartRendering;
  cbShowProgressWindow.Checked := CutApplication.ShowProgressWindow;
END;

PROCEDURE TfrmCutApplicationVirtualDub.Apply;
BEGIN
  INHERITED;
  CutApplication.FNotClose := cbNotClose.Checked;
  CutApplication.FUseSmartRendering := cbUseSmartRendering.Checked;
  CutApplication.ShowProgressWindow := self.cbShowProgressWindow.Checked;
END;

PROCEDURE TfrmCutApplicationVirtualDub.SetCutApplication(
  CONST Value: TCutApplicationVirtualDub);
BEGIN
  FCutApplication := Value;
END;

FUNCTION TfrmCutApplicationVirtualDub.GetCutApplication: TCutApplicationVirtualDub;
BEGIN
  result := (self.FCutApplication AS TCutApplicationVirtualDub);
END;

FUNCTION TCutApplicationVirtualDub.CreateScript(aCutlist: TObjectList;
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
  cutlist                          : TCutlist;
BEGIN
  result := false;
  IF NOT (aCutlist IS TCutlist) THEN exit;
  cutlist := (aCutlist AS TCutlist);
  IF NOT (cutlist.Mode = clmTrim) THEN exit;

  IF scriptfile = '' THEN scriptfile := Inputfile + '.syl';
  assignfile(f, scriptfile);
  rewrite(f);
  writeln(f, '// Virtual Dub Sylia Script');
  writeln(f, '// Generated by ' + Application_friendly_name);
  writeln(f, 'VirtualDub.Open("' + EscapeString(Inputfile) + '",0,0);');
  writeln(f, 'VirtualDub.audio.SetMode(0);');
  IF self.UseSmartRendering THEN BEGIN
    writeln(f, 'VirtualDub.video.SetMode(1);'); //fast Recompression
    writeln(f, 'VirtualDub.video.SetSmartRendering(1);');
    IF CutAppSettings.CodecFourCC <> 0 THEN BEGIN
      writeln(f, 'VirtualDub.video.SetCompression(0x' + IntToHex(CutAppSettings.CodecFourCC, 8) + ',0,10000,0);');
      IF CutAppSettings.CodecSettings <> '' THEN BEGIN
        writeln(f, 'VirtualDub.video.SetCompData(' + inttostr(CutAppSettings.CodecSettingsSize) + ',"' + CutAppSettings.CodecSettings + '");');
      END;
    END;
  END ELSE BEGIN
    writeln(f, 'VirtualDub.video.SetMode(0);');
  END;
  writeln(f, 'VirtualDub.subset.Clear();');

  cutlist.sort;
  FOR i := 0 TO cutlist.Count - 1 DO BEGIN
    IF cutlist.FramesPresent AND NOT cutlist.HasChanged THEN BEGIN
      vdubstart := inttostr(cutlist.Cut[i].frame_from);
      vdubLength := inttostr(cutlist.Cut[i].DurationFrames);
    END ELSE BEGIN
      vdubstart := inttostr(round(cutlist.Cut[i].pos_from / MovieInfo.frame_duration));
      vdubLength := inttostr(round((cutlist.Cut[i].pos_to - cutlist.Cut[i].pos_from) / MovieInfo.frame_duration + 1));
    END;
    writeln(f, 'VirtualDub.subset.AddRange(' + vdubstart + ', ' + vdubLength + ');');
  END;

  writeln(f, 'VirtualDub.SaveAVI(U"' + OutputFile + '");'); //For OUTPUT use undecorated string!
  IF NOT FNotClose THEN
    writeln(f, 'VirtualDub.Close();');

  closefile(f);
  result := true;
END;

FUNCTION TCutApplicationVirtualDub.CanDoSmartRendering: boolean;
CONST
  //only VD 1.7.0 or later can do smart rendering
  MinVersion                       : DWORD = $00010007;
VAR
  VersionMS                        : DWORD;
BEGIN
  result := false;
  VersionMS := MakeLong(self.VersionWords[1], self.VersionWords[0]);
  IF VersionMS >= MinVersion THEN
    result := true;
END;

FUNCTION TCutApplicationVirtualDub.UseSmartRendering: boolean;
BEGIN
  result := (self.FUseSmartRendering AND self.CanDoSmartRendering);
END;

END.

