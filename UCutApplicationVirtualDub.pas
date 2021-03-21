unit UCutApplicationVirtualDub;

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
  TCutApplicationVirtualDub = class;

  TfrmCutApplicationVirtualDub = class(TfrmCutApplicationBase)
    cbNotClose: TJvCheckBox;
    cbUseSmartRendering: TJvCheckBox;
    cbShowProgressWindow: TJvCheckBox;
  private
    { private declarations }
    procedure SetCutApplication(const Value: TCutApplicationVirtualDub);
    function GetCutApplication: TCutApplicationVirtualDub;
  public
    { public declarations }
    property CutApplication: TCutApplicationVirtualDub read GetCutApplication write SetCutApplication;
    procedure Init; override;
    procedure Apply; override;
  end;

  TCutApplicationVirtualDub = class(TCutApplicationBase)
  private
    FFindProgressWindowTimer: TTimer;
    procedure SetShowProgressWindow(const Value: Boolean);
    procedure FindProgressWindow(Sender: TObject);
  protected
    FNotClose: Boolean;
    FUseSmartRendering: Boolean;
    FScriptFileName: string;
    FShowProgressWindow: Boolean;

    function CreateScript(aCutlist: TObjectList; Inputfile, Outputfile: string; var scriptfile: string): Boolean;
  public
    constructor Create; override;
    property ShowProgressWindow: Boolean read FShowProgressWindow write SetShowProgressWindow;
    function CanDoSmartRendering: Boolean;
    function UseSmartRendering: Boolean;

    function LoadSettings(IniFile: TCustomIniFile): Boolean; override;
    function SaveSettings(IniFile: TCustomIniFile): Boolean; override;
    function InfoString: string; override;
    function WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean; override;
    function PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean; override;
    function StartCutting: Boolean; override;
    function CleanUpAfterCutting: Boolean; override;
    function CheckOutputForErrors: Boolean; override;
  end;

var
  frmCutApplicationVirtualDub: TfrmCutApplicationVirtualDub;

implementation

{$R *.dfm}

{..$WARN UNIT_PLATFORM OFF}

uses
  // Delphi
  Winapi.Windows, System.SysUtils, System.StrUtils, Winapi.ActiveX,

  // Jedi
  JvCreateProcess,

  // CA
  CAResources, Main, Utils, UCutlist;

const
  VIRTUALDUB_DEFAULT_EXENAME = 'virtualdub.exe';

type
  PFindWindowStruct = ^TFindWindowStruct;
  TFindWindowStruct = record
    Caption: string;
    ClassName: string;
    ProcessID: Cardinal;
    WindowHandle: THandle;
  end;

{ TCutApplicationVirtualDub }

constructor TCutApplicationVirtualDub.Create;
begin
  inherited;
  FrameClass := TfrmCutApplicationVirtualDub;
  DefaultExeNames.Add(VIRTUALDUB_DEFAULT_EXENAME);
  Name                              := 'VirtualDub';
  RedirectOutput                    := True;
  ShowAppWindow                     := True;
  FNotClose                         := False;
  FUseSmartRendering                := True;
  FShowProgressWindow               := True;
  FFindProgressWindowTimer          := TTimer.Create(Application);
  FFindProgressWindowTimer.OnTimer  := FindProgressWindow;
  FFindProgressWindowTimer.Enabled  := False;
  FFindProgressWindowTimer.Interval := 1000;
  FHasSmartRendering                := True;
end;

function TCutApplicationVirtualDub.CheckOutputForErrors: Boolean;
var
  outputText: TStrings;
  outputLine: string;
  idx: Integer;
begin
  Result := inherited CheckOutputForErrors;

  if Assigned(OutputMemo) then
  begin
    outputText := OutputMemo.Lines;
    for idx := 0 to Pred(outputText.Count) do
    begin
      outputLine := Trim(outputText.Strings[idx]);
      if AnsiStartsText(RsCutAppVDPattSmartRender, outputLine) then
      begin
        if AnsiContainsText(outputLine, RsCutAppVDPattSmartRenderNoCodec) then
        begin
          outputText.Append(RsCutAppVDErrorSmartRenderNoCodec);
          Result := True;
          if not batchmode then
            ErrMsgFmt(RsCutAppVDErrorSmartRenderNoCodec, []);
        end;
        if AnsiContainsText(outputLine, RsCutAppVDPattSmartRenderWrongCodec) then
        begin
          outputText.Append(RsCutAppVDErrorSmartRenderWrongCodec);
          Result := True;
          if not batchmode then
            ErrMsgFmt(RsCutAppVDErrorSmartRenderWrongCodec, []);
        end;
      end;
    end;
  end;
end;

procedure TCutApplicationVirtualDub.SetShowProgressWindow(const Value: Boolean);
begin
  FShowProgressWindow := Value;
end;

function TCutApplicationVirtualDub.LoadSettings(IniFile: TCustomIniFile): Boolean;
  procedure SetCodecSettings(var s1, s2: RCutAppSettings);
  begin
    if (s1.CutAppName = s2.CutAppName) and (s1.CodecFourCC = 0) then // do not overwrite existing settings ...
    begin
      s1.CodecName         := s2.CodecName;
      s1.CodecFourCC       := s2.CodecFourCC;
      s1.CodecVersion      := s2.CodecVersion;
      s1.CodecSettingsSize := s2.CodecSettingsSize;
      s1.CodecSettings     := s2.CodecSettings;
    end;
  end;
var
  section: string;
  success: Boolean;
  StrValue: string;
  BufferSize: Integer;
  cas: RCutAppSettings;
begin
  cas.PreferredSourceFilter := GUID_NULL;

  // This part only for compatibility issues for versions below 0.9.9
  // This Setting may be overwritten below
  section := 'External Cut Application';
  TempDir := IniFile.ReadString(section, 'VirtualDubScriptsPath', '');
  Path := IniFile.ReadString(section, 'VirtualDubPath', '');
  FNotClose := IniFile.ReadBool(section, 'VirtualDubNotClose', FNotClose);
  FUseSmartRendering := IniFile.ReadBool(section, 'VirtualDubUseSmartRendering', FUseSmartRendering);

  success := inherited LoadSettings(IniFile);
  section := GetIniSectionName;
  FNotClose := IniFile.ReadBool(section, 'NotClose', FNotClose);
  FUseSmartRendering := IniFile.ReadBool(section, 'UseSmartRendering', FUseSmartRendering);
  FShowProgressWindow := IniFile.ReadBool(section, 'ShowProgressWindow', FShowProgressWindow);

  //
  // read old settings ...
  //
  StrValue := IniFile.ReadString(section, 'CodecFourCC', '0x0');
  cas.CodecFourCC := StrToInt64Def(StrValue, $00000000);
  StrValue := IniFile.ReadString(section, 'CodecVersion', '0x0');
  cas.CodecVersion := StrToInt64Def(StrValue, $00000000);
  cas.CodecSettingsSize := IniFile.ReadInteger(section, 'CodecSettingsSize', 0);

  // ini.ReadString does work only up to 2047 characters due to restrictions in iniFiles.pas
  // CodecSettings := ini.ReadString(section, 'CodecSettings', '');
  BufferSize := cas.CodecSettingsSize div 3;
  if (cas.CodecSettingsSize mod 3) > 0 then
    Inc(BufferSize);

  BufferSize := BufferSize * 4 + 1; //+1 for terminating #0

  cas.CodecSettings := iniReadLargeString(IniFile, BufferSize, section, 'CodecSettings', '');
  if Length(cas.CodecSettings) <> BufferSize - 1 then
  begin
    cas.CodecSettings     := '';
    cas.CodecSettingsSize := 0;
  end;

  // Convert old settings if necessary ...
  if (cas.CodecFourCC <> 0) then
  begin
    cas.CutAppName := Name;
    cas.CodecName  := Settings.GetCodecNameByFourCC(cas.CodecFourCC);
    SetCodecSettings(Settings.CutAppSettingsWmv, cas);
    SetCodecSettings(Settings.CutAppSettingsAvi, cas);
    SetCodecSettings(Settings.CutAppSettingsHQAVI, cas);
    SetCodecSettings(Settings.CutAppSettingsHDAVI, cas);
    SetCodecSettings(Settings.CutAppSettingsMP4, cas);
    SetCodecSettings(Settings.CutAppSettingsOther, cas);
  end;

  Result := success;
end;

function TCutApplicationVirtualDub.SaveSettings(IniFile: TCustomIniFile): Boolean;
var
  section: string;
  success: Boolean;
begin
  success := inherited SaveSettings(IniFile);

  section := GetIniSectionName;
  IniFile.WriteBool(section, 'NotClose', FNotClose);
  IniFile.WriteBool(section, 'UseSmartRendering', FUseSmartRendering);
  IniFile.WriteBool(section, 'ShowProgressWindow', FShowProgressWindow);

  // Remove old settings ...
  IniFile.DeleteKey(section, 'CodecFourCC');
  IniFile.DeleteKey(section, 'CodecVersion');
  IniFile.DeleteKey(section, 'CodecSettings');
  IniFile.DeleteKey(section, 'CodecSettingsSize');
  Result := success;
end;

function FindWindowByWindowStructParam(wHandle: HWND; lParam: Cardinal): Bool; stdcall;
var
  Title, ClassName: array[0 .. 255] of Char;
  dwProcessId: Cardinal;
begin
  Result := True;
  if (GetClassName(wHandle, ClassName, 255) > 0) and (Pos(PFindWindowStruct(lParam).ClassName, StrPas(ClassName)) > 0) and
     (GetWindowText(wHandle, Title, 255) > 0) and (Pos(PFindWindowStruct(lParam).Caption, StrPas(Title)) > 0) then
  begin
    GetWindowThreadProcessId(wHandle, dwProcessId);
    if dwProcessId = PFindWindowStruct(lParam).ProcessId then
    begin
      PFindWindowStruct(lParam).WindowHandle := wHandle;
      Result := False;
    end;
  end;
end;

procedure TCutApplicationVirtualDub.FindProgressWindow(Sender: TObject);
const
  ID_OPTIONS_SHOWSTATUSWINDOW = 40034;
var
  WindowInfo: TFindWindowStruct;
begin
  if CutApplicationProcess.State = psReady then // CutApp not running ...
  begin
    FFindProgressWindowTimer.Enabled := False;
  end else
  begin
    with WindowInfo do
    begin
      Caption      := 'VirtualDub Status';
      ClassName    := '#32770';
      ProcessID    := CutApplicationProcess.ProcessInfo.dwProcessId;
      WindowHandle := 0;
      EnumWindows(@FindWindowByWindowStructParam, LongInt(@WindowInfo));
      if WindowHandle <> 0 then
      begin
        // if not IsWindowVisible(vDubWindow) then
        ShowWindow(WindowHandle, SW_SHOW);
        // Activate progress window
        // WM_COMMAND, lParam=0, wParam=ID_OPTIONS_SHOWSTATUSWINDOW (40034)
        // SendMessage(wnd, WM_COMMAND, ID_OPTIONS_SHOWSTATUSWINDOW, 0);
        FFindProgressWindowTimer.Enabled := False;
      end;
    end;
  end;
end;

function TCutApplicationVirtualDub.StartCutting: Boolean;
begin
  Result := inherited StartCutting;
  if Result then
  begin
    WaitForInputIdle(CutApplicationProcess.ProcessInfo.hProcess, 1000);
    if FShowProgressWindow then
      FFindProgressWindowTimer.Enabled := True;
  end;
end;

function TCutApplicationVirtualDub.PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean;
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
        FScriptFileName := SourceFileName + '.syl';
      end else
      begin
        if not DirectoryExists(TempDir) then
        begin
          if YesNoWarnMsgFmt(RsMsgCutAppTempDirMissing, [TempDir]) then
            ForceDirectories(TempDir);
        end;
        if not DirectoryExists(TempDir) then
          Exit;

        FScriptFileName := IncludeTrailingPathDelimiter(TempDir) + ExtractFileName(SourceFileName) + '.syl';
      end;

      CreateScript(TempCutlist, SourceFileName, DestFileName, FScriptFileName);

      CommandLine := '/s"' + FScriptFileName + '"';
      if RedirectOutput then
        CommandLine := '/console ' + CommandLine;

      if not FNotClose then
        CommandLine := CommandLine + ' /x';

      FCommandLines.Add(CommandLine);
      Result := True;
    finally
      if MustFreeTempCutlist then
        FreeAndNil(TempCutlist);
    end;
  end;
end;

function TCutApplicationVirtualDub.InfoString: string;
var
  HiVer, LoVer: Integer;
begin
  HiVer := HiWord(CutAppSettings.CodecVersion);
  LoVer := LoWord(CutAppSettings.CodecVersion);

  Result := Format(RsCutAppInfoVirtualDub, [inherited InfoString, BoolToStr(UseSmartRendering, True), CutAppSettings.CodecName, IntToStr(HiVer) + '.' + IntToStr(LoVer)]);
end;

function TCutApplicationVirtualDub.WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean;
begin
  Result := inherited WriteCutlistInfo(CutlistFile, section);
  if Result then
  begin
    cutlistfile.WriteBool(section, 'VDUseSmartRendering', UseSmartRendering);
    if UseSmartRendering then
    begin
      cutlistfile.WriteString(section, 'VDSmartRenderingCodecFourCC', '0x' + IntToHex(CutAppSettings.CodecFourCC, 8));
      cutlistfile.WriteString(section, 'VDSmartRenderingCodecVersion', '0x' + IntToHex(CutAppSettings.CodecVersion, 8));
    end;
  end;
end;

function TCutApplicationVirtualDub.CleanUpAfterCutting: Boolean;
var
  success: Boolean;
begin
  Result := False;
  FFindProgressWindowTimer.Enabled := False;
  if CleanUp then
  begin
    Result := inherited CleanUpAfterCutting;
    if FileExists(FScriptFileName) then
    begin
      success := DeleteFile(FScriptFileName);
      Result  := Result and success;
    end;
  end;
end;

{ TfrmCutApplicationVirtualDub }

procedure TfrmCutApplicationVirtualDub.Init;
begin
  inherited;
  cbNotClose.Checked           := CutApplication.FNotClose;
  cbUseSmartRendering.Checked  := CutApplication.FUseSmartRendering;
  cbShowProgressWindow.Checked := CutApplication.ShowProgressWindow;
end;

procedure TfrmCutApplicationVirtualDub.Apply;
begin
  inherited;
  CutApplication.FNotClose          := cbNotClose.Checked;
  CutApplication.FUseSmartRendering := cbUseSmartRendering.Checked;
  CutApplication.ShowProgressWindow := cbShowProgressWindow.Checked;
end;

procedure TfrmCutApplicationVirtualDub.SetCutApplication(const Value: TCutApplicationVirtualDub);
begin
  FCutApplication := Value;
end;

function TfrmCutApplicationVirtualDub.GetCutApplication: TCutApplicationVirtualDub;
begin
  Result := (FCutApplication as TCutApplicationVirtualDub);
end;

function TCutApplicationVirtualDub.CreateScript(aCutlist: TObjectList; Inputfile, Outputfile: string; var scriptfile: string): Boolean;

  function EscapeString(s: string): string;
  begin
    Result := AnsiReplaceStr(s, '\', '\\');
    Result := AnsiReplaceStr(Result, '''', '\''');
  end;

var
  f: Textfile;
  i: Integer;
  vdubStart, vdubLength: string;
  cutlist: TCutlist;
begin
  Result := False;
  if aCutlist is TCutlist then
  begin
    cutlist := (aCutlist as TCutlist);
    if cutlist.Mode = clmTrim then
    begin
      if scriptfile = '' then
        scriptfile := Inputfile + '.syl';
      AssignFile(f, scriptfile);
      Rewrite(f);
      Writeln(f, '// virtual Dub Sylia Script');
      Writeln(f, '// Generated by ' + Application_friendly_name);
      Writeln(f, 'VirtualDub.Open("' + EscapeString(Inputfile) + '",0,0);');
      Writeln(f, 'VirtualDub.audio.SetMode(0);');
      if UseSmartRendering then
      begin
        Writeln(f, 'VirtualDub.video.SetMode(1);'); // fast Recompression
        Writeln(f, 'VirtualDub.video.SetSmartRendering(1);');
        if CutAppSettings.CodecFourCC <> 0 then
        begin
          Writeln(f, 'VirtualDub.video.SetCompression(0x' + IntToHex(CutAppSettings.CodecFourCC, 8) + ',0,10000,0);');
          if CutAppSettings.CodecSettings <> '' then
            Writeln(f, 'VirtualDub.video.SetCompData(' + IntToStr(CutAppSettings.CodecSettingsSize) + ',"' + CutAppSettings.CodecSettings + '");');
        end;
      end else
        Writeln(f, 'VirtualDub.video.SetMode(0);');

      Writeln(f, 'VirtualDub.subset.Clear();');

      cutlist.Sort;
      for i := 0 to Pred(cutlist.Count) do
      begin
        if cutlist.FramesPresent and not cutlist.HasChanged then
        begin
          vdubstart  := IntToStr(cutlist.Cut[i].frame_from);
          vdubLength := IntToStr(cutlist.Cut[i].DurationFrames);
        end else
        begin
          vdubstart  := IntToStr(Round(cutlist.Cut[i].pos_from / MovieInfo.frame_duration));
          vdubLength := IntToStr(Round((cutlist.Cut[i].pos_to - cutlist.Cut[i].pos_from) / MovieInfo.frame_duration + 1));
        end;
        Writeln(f, 'VirtualDub.subset.AddRange(' + vdubstart + ', ' + vdubLength + ');');
      end;

      Writeln(f, 'VirtualDub.SaveAVI(U"' + OutputFile + '");'); // for OUTPUT use undecorated string!
      if not FNotClose then
        Writeln(f, 'VirtualDub.Close();');

      CloseFile(f);
      Result := True;
    end;
  end;
end;

function TCutApplicationVirtualDub.CanDoSmartRendering: Boolean;
begin
  Result := MakeLong(VersionWords[1], VersionWords[0]) >= $00010007; // only VD 1.7.0 or later can do smart rendering
end;

function TCutApplicationVirtualDub.UseSmartRendering: Boolean;
begin
  Result := FUseSmartRendering and CanDoSmartRendering;
end;

end.

