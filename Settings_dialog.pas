unit Settings_dialog;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.Windows, System.Classes, System.SysUtils, System.Contnrs, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.CheckLst,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.Buttons, System.IOUtils,

  // Jedi
  JvExMask, JvSpin, JvExStdCtrls, JvCheckBox,

  // DSPack
  DXSUtils,

  // CA
  CodecSettings, Movie, Utils, UCutApplicationBase, ReplaceFrame, ReplaceList;

const
  //Settings Save...Mode
  smWithSource                     = $00; //How to Save Cutlists and cut movies
  smGivenDir                       = $01;
  smAutoSaveBeforeCutting          = $40; //Only Cutlist
  smAlwaysAsk                      = $80;
  DEFAULT_UPDATE_XML               = 'http://cutassistant.sourceforge.net/cut_assistant_info.xml';

type
  TFSettings = class(TForm)
    cmdCancel: TButton;
    cmdOK: TButton;
    pgSettings: TPageControl;
    tabUserData: TTabSheet;
    lblUsername: TLabel;
    lblUserID: TLabel;
    edtUserName_nl: TEdit;
    edtUserID_nl: TEdit;
    tabSaveMovie: TTabSheet;
    lblCutMovieExtension: TLabel;
    rgSaveCutMovieMode: TRadioGroup;
    edtCutMovieSaveDir_nl: TEdit;
    edtCutMovieExtension_nl: TEdit;
    cmdCutMovieSaveDir: TButton;
    tabSaveCutlist: TTabSheet;
    rgSaveCutlistMode: TRadioGroup;
    edtCutListSaveDir_nl: TEdit;
    cmdCutlistSaveDir: TButton;
    tabURLs: TTabSheet;
    lblServerUrl: TLabel;
    lblInfoUrl: TLabel;
    lblHelpUrl: TLabel;
    lblUploadUrl: TLabel;
    edtURL_Cutlist_Home_nl: TEdit;
    edtURL_Info_File_nl: TEdit;
    edtURL_Cutlist_Upload_nl: TEdit;
    edtURL_Help_nl: TEdit;
    grpProxy: TGroupBox;
    lblProxyServer: TLabel;
    lblProxyPort: TLabel;
    lblProxyPass: TLabel;
    lblProxyUser: TLabel;
    lblProxyPassWarning: TLabel;
    edtProxyServerName_nl: TEdit;
    edtProxyPort_nl: TEdit;
    edtProxyPassword_nl: TEdit;
    edtProxyUserName_nl: TEdit;
    tabInfoCheck: TTabSheet;
    grpInfoCheck: TGroupBox;
    lblCheckInterval: TLabel;
    ECheckInfoInterval_nl: TEdit;
    TabExternalCutApplication: TTabSheet;
    lblCutWithWMV: TLabel;
    lblCutWithAvi: TLabel;
    lblCutWithOther: TLabel;
    lblSelectCutApplication: TLabel;
    CBWmvApp_nl: TComboBox;
    CBAviApp_nl: TComboBox;
    CBOtherApp_nl: TComboBox;
    lblCutWithMP4: TLabel;
    cbMP4App_nl: TComboBox;
    tabSourceFilter: TTabSheet;
    cmbSourceFilterListAVI_nl: TComboBox;
    cmbSourceFilterListMP4_nl: TComboBox;
    cmbSourceFilterListOther_nl: TComboBox;
    cmdRefreshFilterList: TButton;
    lblSourceFilter: TLabel;
    lblSourceFilterAvi: TLabel;
    lblSourceFilterMP4: TLabel;
    lblSourceFilterOther: TLabel;
    lblSourceFilterWmv: TLabel;
    cmbSourceFilterListWMV_nl: TComboBox;
    pnlPleaseWait_nl: TPanel;
    pnlButtons: TPanel;
    lbchkBlackList_nl: TCheckListBox;
    lblBlacklist: TLabel;
    lblFramesSize: TLabel;
    edtFrameWidth_nl: TEdit;
    lblFramesSizex_nl: TLabel;
    edtFrameHeight_nl: TEdit;
    lblFramesCount: TLabel;
    edtFrameCount_nl: TEdit;
    lblFramesSizeChangeHint: TLabel;
    lblFramesCountChangeHint: TLabel;
    rgCutMode: TRadioGroup;
    lblAutoCloseCuttingWindow: TLabel;
    spnWaitTimeout: TJvSpinEdit;
    lblWaitTimeout: TLabel;
    edtSmallSkip_nl: TEdit;
    lblSmallSkip: TLabel;
    lblLargeSkip: TLabel;
    edtLargeSkip_nl: TEdit;
    lblSmallSkipSecs: TLabel;
    lblLargeSkipSecs: TLabel;
    lblFramesSizey_nl: TLabel;
    edtNetTimeout_nl: TEdit;
    lblNetTimeout: TLabel;
    lblNetTimeoutSecs: TLabel;
    cmbCodecWmv_nl: TComboBox;
    btnCodecConfigWmv: TButton;
    btnCodecAboutWmv: TButton;
    cmbCodecAvi_nl: TComboBox;
    btnCodecConfigAvi: TButton;
    btnCodecAboutAvi: TButton;
    cmbCodecMP4_nl: TComboBox;
    btnCodecConfigMP4: TButton;
    btnCodecAboutMP4: TButton;
    cmbCodecOther_nl: TComboBox;
    btnCodecConfigOther: TButton;
    btnCodecAboutOther: TButton;
    lblSmartRenderingCodec: TLabel;
    lblCutWithHQAvi: TLabel;
    CBHQAviApp_nl: TComboBox;
    cmbCodecHQAvi_nl: TComboBox;
    btnCodecConfigHQAvi: TButton;
    btnCodecAboutHQAvi: TButton;
    lblSourceFilterHQAvi: TLabel;
    cmbSourceFilterListHQAVI_nl: TComboBox;
    lblLanguage: TLabel;
    cmbLanguage_nl: TComboBox;
    lblLanguageChangeHint: TLabel;
    cbAutoMuteOnSeek: TJvCheckBox;
    cbExceptionLogging: TJvCheckBox;
    cbMovieNameAlwaysConfirm: TJvCheckBox;
    cbUseMovieNameSuggestion: TJvCheckBox;
    cbCutlistNameAlwaysConfirm: TJvCheckBox;
    cbCutlistAutoSaveBeforeCutting: TJvCheckBox;
    CBInfoCheckStable: TJvCheckBox;
    CBInfoCheckBeta: TJvCheckBox;
    CBInfoCheckMessages: TJvCheckBox;
    CBInfoCheckEnabled: TJvCheckBox;
    cbAutoSearchCutlists: TJvCheckBox;
    cbSearchLocalCutlists: TJvCheckBox;
    cbSearchServerCutlists: TJvCheckBox;
    cbAutoSaveDownloadedCutlists: TJvCheckBox;
    cbSearchCutlistsByName: TJvCheckBox;
    cbNoRateSuccMsg: TJvCheckBox;
    cbNoWarnUseRate: TJvCheckBox;
    cbNewNextFrameMethod: TJvCheckBox;
    tabReplace: TTabSheet;
    scrBox: TScrollBox;
    ReplaceFrameX: TReplaceFrame;
    rgExtSearchMode: TRadioGroup;
    lblCutWithHDAvi: TLabel;
    CBHDAviApp_nl: TComboBox;
    cmbCodecHDAvi_nl: TComboBox;
    btnCodecConfigHDAvi: TButton;
    btnCodecAboutHDAvi: TButton;
    lblSourceFilterHDAvi: TLabel;
    cmbSourceFilterListHDAVI_nl: TComboBox;
    procedure cmdCutMovieSaveDirClick(Sender: TObject);
    procedure cmdCutlistSaveDirClick(Sender: TObject);
    procedure edtProxyPort_nlKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);

    procedure ECheckInfoInterval_nlKeyPress(Sender: TObject; var Key: Char);
    procedure tabSourceFilterShow(Sender: TObject);
    procedure cmdRefreshFilterListClick(Sender: TObject);
    procedure lbchkBlackList_nlClickCheck(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtFrameWidth_nlExit(Sender: TObject);
    procedure cmbCodecChange(Sender: TObject);
    procedure btnCodecConfigClick(Sender: TObject);
    procedure btnCodecAboutClick(Sender: TObject);
    procedure cbCutAppChange(Sender: TObject);
    procedure cmbSourceFilterListChange(Sender: TObject);
  private
    { private declarations }
    HQAviAppSettings, HDAviAppSettings, AviAppSettings, WmvAppSettings, MP4AppSettings, OtherAppSettings: RCutAppSettings;
    EnumFilters: TSysDevEnum;
    procedure FillBlackList;
    function GetCodecList: TCodecList;
    property CodecList: TCodecList read GetCodecList;
  private
    function GetMovieTypeFromControl(const Sender: TObject; var MovieType: TMovieType): Boolean;
    function GetCodecSettingsControls(const Sender: TObject;
      var cbx: TComboBox; var btnConfig, btnAbout: TButton): Boolean; overload;
    function GetCodecSettingsControls(const MovieType: TMovieType;
      var cbx: TComboBox; var btnConfig, btnAbout: TButton): Boolean; overload;
  public
    procedure Init;
    function GetCodecNameByFourCC(FourCC: DWORD): string;
    procedure GetCutAppSettings(const MovieType: TMovieType; var ASettings: RCutAppSettings);
    procedure SetCutAppSettings(const MovieType: TMovieType; var ASettings: RCutAppSettings);
    { public declarations }
  end;

  //deprecated:
  TCutApp = (caAsfBin = 0, caVirtualDub = 1, caAviDemux = 2);

  TExtendedSearchMode = (esmNever, esmOnDemand, esmAlways);

  TSettings = class(TObject)
  private
    IniFileAtExe, IniFileAtUser: string;
    UseIniFileAtUser: Boolean;
    SourceFilterList: TSourceFilterList;
    _SaveCutListMode, _SaveCutMovieMode: Byte;
    _NewSettingsCreated: Boolean;
    FCodecList: TCodecList;
    FLanguageList: TStringList;
    FAdditional: TStringList;
    function GetLanguageIndex: Integer;
    function GetLanguageByIndex(index: Integer): string;
    function GetLangDesc(const langFile: TFileName): string;
    function GetLanguageFile: string;
    function GetAdditional(const name: string): string;
    procedure SetAdditional(const name: string; const value: string);
    function GetLanguageList: TStrings;
    function GetFilter(Index: Integer): TFilCatNode;
    property CodecList: TCodecList read FCodecList;
  public
    // window state
    MainFormBounds, FramesFormBounds, PreviewFormBounds, LoggingFormBounds: TRect;
    MainFormWindowState, FramesFormWindowState, PreviewFormWindowState: TWindowState;
    LoggingFormVisible: Boolean;

    //CutApplications
    CutApplicationList: TObjectList;

    //User
    UserName, UserID: string;

    // Preview frame window
    FramesWidth, FramesHeight, FramesCount: Integer;

    //General
    CutlistSaveDir, CutMovieSaveDir, CutMovieExtension, CurrentMovieDir: string;
    UseMovieNameSuggestion: Boolean;
    DefaultCutMode: Integer;
    SmallSkipTime, LargeSkipTime: Integer;
    NetTimeout: Integer;
    AutoMuteOnSeek: Boolean;
    AutoSearchCutlists: Boolean;
    SearchLocalCutlists: Boolean;
    SearchServerCutlists: Boolean;
    AutoSaveDownloadedCutlists: Boolean;
    SearchCutlistsByName: Boolean;
    ExtendedSearchMode: TExtendedSearchMode;
    NoRateSuccMsg: Boolean;
    NoWarnUseRate: Boolean;
    NewNextFrameMethod: Boolean;

    FinePosFrameCount: Integer;

    //Warnings
    WarnOnWrongCutApp: Boolean;

    //Server messages
    MsgServerRatingDone: string;

    //Mplayer
    MPlayerPath: string;

    //CutApps
    CuttingWaitTimeout: Integer;

    //SourceFilter, CodecSettings
    CutAppSettingsAvi, CutAppSettingsWmv, CutAppSettingsMP4, CutAppSettingsOther: RCutAppSettings;
    CutAppSettingsHQAvi: RCutAppSettings;
    CutAppSettingsHDAvi: RCutAppSettings;

    //Blacklist of Filters
    FilterBlackList: TGUIDList;

    //URLs and Proxy
    url_cutlists_home, url_cutlists_upload, url_info_file, url_help: string;
    proxyServerName, proxyUserName, proxyPassword: string;
    proxyPort: Integer;

    //Other settings
    OffsetSecondsCutChecking: Integer;
    InfoCheckInterval: Integer;
    InfoLastChecked: TDate;
    InfoShowMessages, InfoShowStable, InfoShowBeta: Boolean;
    ExceptionLogging: Boolean;
    CutPreview: Boolean;

    // UI Language
    Language: string;

    ReplaceList: TReplaceList;

    // Additional settings
    property Additional[const name: string]: string read GetAdditional write SetAdditional;

    procedure UpdateLanguageList;
    property LanguageList: TStrings read GetLanguageList;
    property LanguageFile: string read GetLanguageFile;

    function CheckInfos: Boolean;

    constructor Create;
    destructor Destroy; override;

  protected
    //deprecated
    function GetCutAppNameByCutAppType(CAType: TCutApp): string;
  public
    function GetCutAppName(MovieType: TMovieType): string;
    function GetCutApplicationByName(CAName: string): TCutApplicationBase;
    function GetCutAppSettingsByMovieType(MovieType: TMovieType): RCutAppSettings;
    function GetCutApplicationByMovieType(MovieType: TMovieType): TCutApplicationBase;

    function GetPreferredSourceFilterByMovieType(MovieType: TMovieType): TGUID;
    function SaveCutlistMode: Byte;
    function SaveCutMovieMode: Byte;
    function MovieNameAlwaysConfirm: Boolean;
    function CutlistNameAlwaysConfirm: Boolean;
    function CutlistAutoSaveBeforeCutting: Boolean;
    function FilterIsInBlackList(ClassID: TGUID): Boolean;

    procedure Load;
    procedure Edit;
    procedure Save;

    function GetCodecNameByFourCC(FourCC: DWORD): string;
    property GetFilterInfo[Index: Integer]: TFilCatNode read GetFilter;

    property NewSettingsCreated: Boolean read _NewSettingsCreated;
  end;

var
  FSettings: TFSettings;

implementation

{$WARN UNIT_PLATFORM OFF}

uses
  // Delphi
  Winapi.DirectShow9, System.StrUtils, System.Types, System.IniFiles, System.Math, Vcl.FileCtrl,

  // FreeLocalizer
  uFreeLocalizer,

  // CA
  CAResources, Main, UCutApplicationAsfbin, UCutApplicationVirtualDub, UCutApplicationAviDemux, UCutApplicationMP4Box,
  UCutlist;

var
  EmptyRect: TRect;

{$R *.dfm}

function TFSettings.GetCodecList: TCodecList;
begin
  Result := Settings.CodecList;
end;

function TFSettings.GetCodecNameByFourCC(FourCC: DWORD): string;
begin
  Result := Settings.GetCodecNameByFourCC(FourCC);
end;

function TSettings.GetCodecNameByFourCC(FourCC: DWORD): string;
var
  idx: Integer;
  codec: TICInfoObject;
begin
  codec := nil;
  idx := FCodecList.IndexOfCodec(FourCC);
  if idx > -1 then
    codec := FCodecList.CodecInfoObject[idx];

  if Assigned(codec) then
    Result := codec.Name
  else
    Result := '';
end;

procedure TFSettings.cmdCutMovieSaveDirClick(Sender: TObject);
var
  newDir, currentDir: string;
begin
  newDir := edtCutMovieSaveDir_nl.Text;
  currentDir := edtCutMovieSaveDir_nl.Text;
  if not IsPathRooted(currentDir) then
    currentDir := '';
  if SelectDirectory(RSTitleCutMovieDestinationDirectory, currentDir, newDir) then
    edtCutMovieSaveDir_nl.Text := newDir;
end;

procedure TFSettings.cmdCutlistSaveDirClick(Sender: TObject);
var
  newDir, currentDir: string;
begin
  newDir := edtCutlistSaveDir_nl.Text;
  currentDir := edtCutlistSaveDir_nl.Text;
  if not IsPathRooted(currentDir) then
    currentDir := '';
  if SelectDirectory(RSTitleCutlistDestinationDirectory, currentDir, newDir) then
    edtCutlistSaveDir_nl.Text := newDir;
end;

procedure TFSettings.edtProxyPort_nlKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, [#0..#31, '0'..'9']) then
    Key := Chr(0);
end;

{ TSettings }

function TSettings.GetLangDesc(const langFile: TFileName): string;
const
  DESC_PATTERN = 'description:';
var
  f: TextFile;
  line: string;
  idx: Integer;
begin
  Result := ExtractFileName(langFile);
  AssignFile(f, langFile);
  {$I-}
  FileMode := fmOpenRead;
  Reset(f);
  if IOResult = 0 then
  begin
    while IOResult = 0 do
    begin
      ReadLn(f, line);
      if (IOResult <> 0) or (line = '') then
        Break;
      if not AnsiStartsText(';', line) then
        Continue;
      idx := AnsiPos(DESC_PATTERN, AnsiLowerCase(line));
      if idx < 1 then
        Continue;
      Delete(line, 1, idx + Length(DESC_PATTERN));
      idx := AnsiPos('=', line);
      if idx > 0 then
        Delete(line, idx, MaxInt);
      Result := Trim(line);
      Break;
    end;
    CloseFile(f);
  end;
  {$I+}
end;

procedure TSettings.UpdateLanguageList;
var
  lang_dir, lang_desc: string;
  lang_found: Boolean;
  sr: TSearchRec;
begin
  lang_dir := IncludeTrailingPathDelimiter(FreeLocalizer.LanguageDir);
  FLanguageList.Clear;
  lang_found := Language = '';
  if FindFirst(lang_dir + ChangeFileExt(Application_File, '.*.lng'), faReadOnly, sr) = 0 then
  begin
    repeat
      lang_desc := GetLangDesc(lang_dir + sr.Name);
      if AnsiSameText(sr.Name, Language) then
        lang_found := True;
      FLanguageList.Add(lang_desc + ' (' + sr.Name + ')');
    until FindNext(sr) <> 0;
  end;
  if not lang_found then
    FLanguageList.Add(Language + ' (' + Language + ')');
  FLanguageList.Sort;
  FLanguageList.Insert(0, 'Standard');
end;

function TSettings.GetLanguageFile: string;
begin
  Result := Language;
end;

function TSettings.GetLanguageList: TStrings;
begin
  Result := FLanguageList;
end;

function TSettings.GetAdditional(const name: string): string;
begin
  Result := FAdditional.Values[name];
end;

procedure TSettings.SetAdditional(const name: string; const value: string);
begin
  FAdditional.Values[name] := value;
end;

function TSettings.GetLanguageIndex: Integer;
var
  idx: Integer;
  lang: string;
begin
  if Language <> '' then
  begin
    lang := '(' + Language + ')';
    idx := 0;
    while idx < FLanguageList.Count do
    begin
      if AnsiEndsText(lang, FLanguageList[idx]) then
        Break;
      Inc(idx);
    end;
    Result := idx;
  end else
    Result := 0;
end;

function TSettings.GetLanguageByIndex(index: Integer): string;
var
  lang: string;
  idx: Integer;
begin
  lang := FLanguageList[index];
  idx := Pos('(', lang);
  if idx = 0 then
    idx := MaxInt;
  Delete(lang, 1, idx);
  Delete(lang, Pos(')', lang), MaxInt);
  Result := lang;
end;

function TSettings.CheckInfos: Boolean;
begin
  Result := (InfoCheckInterval >= 0);
end;

constructor TSettings.Create;
begin
  inherited;

  IniFileAtExe     := ChangeFileExt(Application.ExeName, '.ini');
  IniFileAtUser    := IncludeTrailingPathDelimiter(TPath.GetHomePath) + 'CutAsisstant\' + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');
  UseIniFileAtUser := FileExists(IniFileAtUser);

  Language := '';
  ExceptionLogging := False;

  FLanguageList := TStringList.Create;
  FLanguageList.CaseSensitive := False;
  UpdateLanguageList;

  FCodecList := TCodecList.Create;

  CutApplicationList := TObjectList.Create;
  CutApplicationList.Add(TCutApplicationAsfbin.Create);
  CutApplicationList.Add(TCutApplicationVirtualDub.Create);
  CutApplicationList.Add(TCutApplicationAviDemux.Create);
  CutApplicationList.Add(TCutApplicationMP4Box.Create);

  SourceFilterList := TSourceFilterList.Create;
  FilterBlackList := TGUIDList.Create;

  CutAppSettingsWmv.PreferredSourceFilter   := GUID_NULL;
  CutAppSettingsAvi.PreferredSourceFilter   := GUID_NULL;
  CutAppSettingsHQAvi.PreferredSourceFilter := GUID_NULL;
  CutAppSettingsHDAvi.PreferredSourceFilter := GUID_NULL;
  CutAppSettingsMP4.PreferredSourceFilter   := GUID_NULL;
  CutAppSettingsOther.PreferredSourceFilter := GUID_NULL;

  FAdditional := TStringList.Create;

  ReplaceList := TReplaceList.Create;
end;

function TSettings.GetFilter(Index: Integer): TFilCatNode;
begin
  Result := SourceFilterList.GetFilterInfo[Index];
end;

function TSettings.CutlistAutoSaveBeforeCutting: Boolean;
begin
  Result := ((_SaveCutlistMOde and smAutoSaveBeforeCutting) > 0);
end;

function TSettings.CutlistNameAlwaysConfirm: Boolean;
begin
  Result := ((_SaveCutlistMode and smAlwaysAsk) > 0);
end;

destructor TSettings.Destroy;
begin
  FreeAndNil(ReplaceList);
  FreeAndNil(FAdditional);
  FreeAndNil(FLanguageList);
  FreeAndNil(FCodecList);
  FreeAndNil(FilterBlackList);
  FreeAndNil(SourceFilterList);
  FreeAndNil(CutApplicationList);
  inherited;
end;

procedure TSettings.Edit;
var
  newLanguage: string;
  Data_Valid: Boolean;
  iTabSheet: Integer;
  TabSheet: TTabSheet;
  FrameClass: TCutApplicationFrameClass;
begin
  for iTabSheet := 0 to Pred(FSettings.pgSettings.PageCount) do
  begin
    TabSheet := FSettings.pgSettings.Pages[iTabSheet];
    if TabSheet.Tag <> 0 then
    begin
      FrameClass := TCutApplicationFrameClass(TabSheet.Tag);
      (FSettings.pgSettings.Pages[iTabSheet].Controls[0] as FrameClass).Init;
    end;
  end;

  FSettings.SetCutAppSettings(mtWMV, CutAppSettingsWmv);
  FSettings.SetCutAppSettings(mtAVI, CutAppSettingsAvi);
  FSettings.SetCutAppSettings(mtHQAVI, CutAppSettingsHQAvi);
  FSettings.SetCutAppSettings(mtHDAVI, CutAppSettingsHDAvi);
  FSettings.SetCutAppSettings(mtMP4, CutAppSettingsMP4);
  FSettings.SetCutAppSettings(mtUnknown, CutAppSettingsOther);

  FSettings.spnWaitTimeout.AsInteger               := CuttingWaitTimeout;
  FSettings.rgSaveCutMovieMode.ItemIndex           := SaveCutMovieMode;
  FSettings.edtCutMovieSaveDir_nl.Text             := CutMovieSaveDir;
  FSettings.edtCutMovieExtension_nl.Text           := CutMovieExtension;
  FSettings.cbUseMovieNameSuggestion.Checked       := UseMovieNameSuggestion;
  FSettings.cbMovieNameAlwaysConfirm.Checked       := MovieNameAlwaysConfirm;
  FSettings.rgSaveCutlistMode.ItemIndex            := SaveCutlistMode;
  FSettings.edtCutlistSaveDir_nl.Text              := CutlistSaveDir;
  FSettings.cbCutlistNameAlwaysConfirm.Checked     := CutlistNameAlwaysConfirm;
  Fsettings.cbCutlistAutoSaveBeforeCutting.Checked := CutlistAutoSaveBeforeCutting;
  Fsettings.rgCutMode.ItemIndex                    := DefaultCutMode;
  FSettings.edtSmallSkip_nl.Text                   := IntToStr(SmallSkipTime);
  FSettings.edtLargeSkip_nl.Text                   := IntToStr(LargeSkipTime);
  FSettings.edtNetTimeout_nl.Text                  := IntToStr(NetTimeout);
  FSettings.cbAutoMuteOnSeek.Checked               := AutoMuteOnSeek;
  FSettings.cbNoRateSuccMsg.Checked                := NoRateSuccMsg;
  FSettings.cbNoWarnUseRate.Checked                := NoWarnUseRate;
  FSettings.cbNewNextFrameMethod.Checked           := NewNextFrameMethod;
  FSettings.cbExceptionLogging.Checked             := ExceptionLogging;
  FSettings.cbAutoSaveDownloadedCutlists.Checked   := AutoSaveDownloadedCutlists;

  FSettings.cbAutoSearchCutlists.Checked   := AutoSearchCutlists;
  FSettings.cbSearchLocalCutlists.Checked  := SearchLocalCutlists;
  FSettings.cbSearchServerCutlists.Checked := SearchServerCutlists;
  FSettings.cbSearchCutlistsByName.Checked := SearchCutlistsByName;
  FSettings.rgExtSearchMode.ItemIndex      := Ord(ExtendedSearchMode);

  Fsettings.edtURL_Cutlist_Home_nl.Text   := url_cutlists_home;
  Fsettings.edtURL_Info_File_nl.Text      := url_info_file;
  Fsettings.edtURL_Cutlist_Upload_nl.Text := url_cutlists_upload;
  Fsettings.edtURL_Help_nl.Text           := url_help;

  FSettings.edtProxyServerName_nl.Text := proxyServerName;
  FSettings.edtProxyPort_nl.Text       := IntToStr(proxyPort);
  FSettings.edtProxyUserName_nl.Text   := proxyUserName;
  FSettings.edtProxyPassword_nl.Text   := proxyPassword;

  Fsettings.edtUserName_nl.Text := UserName;
  Fsettings.edtUserID_nl.Text   := UserID;

  FSettings.edtFrameWidth_nl.Text  := IntToStr(FramesWidth);
  FSettings.edtFrameHeight_nl.Text := IntToStr(FramesHeight);
  FSettings.edtFrameCount_nl.Text  := IntToStr(FramesCount);

  FSettings.cmbLanguage_nl.Items.Assign(FLanguageList);
  FSettings.cmbLanguage_nl.ItemIndex := GetLanguageIndex;

  FSettings.CBInfoCheckMessages.Checked := InfoShowMessages;
  FSettings.CBInfoCheckStable.Checked   := InfoShowStable;
  FSettings.CBInfoCheckBeta.Checked     := InfoShowBeta;
  if CheckInfos then
    FSettings.ECheckInfoInterval_nl.Text := IntToStr(InfoCheckInterval)
  else
    FSettings.ECheckInfoInterval_nl.Text := '0';
  FSettings.CBInfoCheckEnabled.Checked := CheckInfos;

  ReplaceList.SaveToDialogFrames(FSettings.scrBox);

  FSettings.Init;

  Data_Valid := False;
  while not Data_Valid do
  begin
    if FSettings.ShowModal <> mrOK then
      Break; // User Cancelled

    Data_Valid := True;
    if (Fsettings.rgSaveCutMovieMode.ItemIndex = 1) then
    begin
      if IsPathRooted(FSettings.edtCutMovieSaveDir_nl.Text) and (not System.SysUtils.DirectoryExists(FSettings.edtCutMovieSaveDir_nl.Text)) then
      begin
        if YesNoWarnMsgFmt(RsCutMovieDirectoryMissing, [FSettings.edtCutMovieSaveDir_nl.Text]) then
        begin
          Data_Valid := System.SysUtils.ForceDirectories(FSettings.edtCutMovieSaveDir_nl.Text);
        end else
        begin
          Data_Valid := False;
          FSettings.pgSettings.ActivePage := Fsettings.tabSaveMovie;
          FSettings.ActiveControl := FSettings.edtCutMovieSaveDir_nl;
        end;
      end;
    end;
    if Data_Valid and (Fsettings.rgSaveCutlistMode.ItemIndex = 1) then
    begin
      if IsPathRooted(FSettings.edtCutlistSaveDir_nl.Text) and (not System.SysUtils.DirectoryExists(FSettings.edtCutlistSaveDir_nl.Text)) then
      begin
        if YesNoWarnMsgFmt(RsCutlistDirectoryMissing, [FSettings.edtCutlistSaveDir_nl.Text]) then
        begin
          Data_Valid := System.SysUtils.ForceDirectories(FSettings.edtCutlistSaveDir_nl.Text);
        end else
        begin
          Data_Valid := False;
          FSettings.pgSettings.ActivePage := Fsettings.TabSaveCutlist;
          FSettings.ActiveControl := FSettings.edtCutlistSaveDir_nl;
        end;
      end;
    end;
    if Data_Valid then // Apply new settings and save them
    begin
      CuttingWaitTimeout := FSettings.spnWaitTimeout.AsInteger;

      FSettings.GetCutAppSettings(mtWMV, CutAppSettingsWmv);
      FSettings.GetCutAppSettings(mtAVI, CutAppSettingsAvi);
      FSettings.GetCutAppSettings(mtHQAVI, CutAppSettingsHQAvi);
      FSettings.GetCutAppSettings(mtHDAVI, CutAppSettingsHDAvi);
      FSettings.GetCutAppSettings(mtMP4, CutAppSettingsMP4);
      FSettings.GetCutAppSettings(mtUnknown, CutAppSettingsOther);

      case FSettings.rgSaveCutMovieMode.ItemIndex of
        1  : _SaveCutMovieMode := smGivenDir;
        else _SaveCutMovieMode := smWithSource;
      end;
      CutMovieSaveDir   := FSettings.edtCutMovieSaveDir_nl.Text;
      CutMovieExtension := FSettings.edtCutMovieExtension_nl.Text;
      if FSettings.cbMovieNameAlwaysConfirm.Checked then _SaveCutMovieMode := _saveCutMovieMode or smAlwaysAsk;
      UseMovieNameSuggestion := FSettings.CBUseMovieNameSuggestion.Checked;

      case FSettings.rgSaveCutlistMode.ItemIndex of
        1  : _SaveCutlistMode := smGivenDir;
        else _SaveCutlistMode := smWithSource;
      end;
      CutlistSaveDir := FSettings.edtCutlistSaveDir_nl.Text;

      if FSettings.cbCutlistNameAlwaysConfirm.Checked then
        _SaveCutlistMode := _SaveCutlistMode or smAlwaysAsk;

      if Fsettings.cbCutlistAutoSaveBeforeCutting.Checked then
        _SaveCutlistMOde := _SaveCutlistMOde or smAutoSaveBeforeCutting;

      AutoSaveDownloadedCutlists := FSettings.cbAutoSaveDownloadedCutlists.Checked;
      DefaultCutMode := Fsettings.rgCutMode.ItemIndex;

      url_cutlists_home := Trim(Fsettings.edtURL_Cutlist_Home_nl.Text);
      if not AnsiEndsText('/', url_cutlists_home) then
        url_cutlists_home := url_cutlists_home + '/';
      url_info_file := Trim(Fsettings.edtURL_Info_File_nl.Text);
      url_cutlists_upload := Trim(Fsettings.edtURL_Cutlist_Upload_nl.Text);
      url_help := Trim(Fsettings.edtURL_Help_nl.Text);

      proxyServerName := FSettings.edtProxyServerName_nl.Text;
      proxyPort       := StrToIntDef(FSettings.edtProxyPort_nl.Text, proxyPort);
      proxyUserName   := FSettings.edtProxyUserName_nl.Text;
      proxyPassword   := FSettings.edtProxyPassword_nl.Text;

      UserName := Fsettings.edtUserName_nl.Text;

      FramesWidth  := StrToInt(FSettings.edtFrameWidth_nl.Text);
      FramesHeight := StrToInt(FSettings.edtFrameHeight_nl.Text);
      FramesCount  := StrToInt(FSettings.edtFrameCount_nl.Text);

      SmallSkipTime      := StrToInt(FSettings.edtSmallSkip_nl.Text);
      LargeSkipTime      := StrToInt(FSettings.edtLargeSkip_nl.Text);
      NetTimeout         := StrToInt(FSettings.edtNetTimeout_nl.Text);
      AutoMuteOnSeek     := FSettings.cbAutoMuteOnSeek.Checked;
      NoRateSuccMsg      := FSettings.cbNoRateSuccMsg.Checked;
      NoWarnUseRate      := FSettings.cbNoWarnUseRate.Checked;
      NewNextFrameMethod := FSettings.cbNewNextFrameMethod.Checked;

      ExceptionLogging := FSettings.cbExceptionLogging.Checked;

      AutoSearchCutlists   := FSettings.cbAutoSearchCutlists.Checked;
      SearchLocalCutlists  := FSettings.cbSearchLocalCutlists.Checked;
      SearchServerCutlists := FSettings.cbSearchServerCutlists.Checked;
      SearchCutlistsByName := FSettings.cbSearchCutlistsByName.Checked;
      ExtendedSearchMode   := TExtendedSearchMode(FSettings.rgExtSearchMode.ItemIndex);

      newLanguage := GetLanguageByIndex(FSettings.cmbLanguage_nl.ItemIndex);
      if Language <> newLanguage then
      begin
        Language := newLanguage;
        //Show__Message(RsChangeLanguageNeedsRestart);
      end;

      InfoShowMessages := FSettings.CBInfoCheckMessages.Checked;
      InfoShowStable   := FSettings.CBInfoCheckStable.Checked;
      InfoShowBeta     := FSettings.CBInfoCheckBeta.Checked;

      if FSettings.CBInfoCheckEnabled.Checked then
        InfoCheckInterval := StrToIntDef(FSettings.ECheckInfoInterval_nl.Text, 0)
      else
        InfoCheckInterval := -1;

      for iTabSheet := 0 to Pred(FSettings.pgSettings.PageCount) do
      begin
        TabSheet := FSettings.pgSettings.Pages[iTabSheet];
        if TabSheet.Tag <> 0 then
        begin
          FrameClass := TCutApplicationFrameClass(TabSheet.Tag);
          (FSettings.pgSettings.Pages[iTabSheet].Controls[0] as FrameClass).Apply;
        end;
      end;

      ReplaceList.LoadFromDialogFrames(FSettings.scrBox);

      Save;
    end;
  end;
end;

function TSettings.FilterIsInBlackList(ClassID: TGUID): Boolean;
begin
  Result := FilterBlackList.IsInList(ClassID);
end;

function TSettings.GetCutApplicationByMovieType(MovieType: TMovieType): TCutApplicationBase;
begin
  Result := GetCutApplicationByName(GetCutAppName(MovieType));
  if Assigned(Result) then
    Result.CutAppSettings := GetCutAppSettingsByMovieType(MovieType);
end;

function TSettings.GetCutApplicationByName(CAName: string): TCutApplicationBase;
var
  iCutApplication: Integer;
  FoundCutApplication: TCutApplicationBase;
begin
  Result := nil;
  for iCutApplication := 0 to Pred(CutApplicationList.Count) do
  begin
    FoundCutApplication := (CutApplicationList[iCutApplication] as TCutApplicationBase);
    if AnsiSameText(FoundCutApplication.Name, CAName) then
    begin
      Result := FoundCutApplication;
      Break;
    end;
  end;
end;

function TSettings.GetCutAppSettingsByMovieType(MovieType: TMovieType): RCutAppSettings;
begin
  case MovieType of
    mtWMV   : Result := CutAppSettingsWmv;
    mtAVI   : Result := CutAppSettingsAvi;
    mtHQAVI : Result := CutAppSettingsHQAvi;
    mtHDAVI : Result := CutAppSettingsHDAvi;
    mtMP4   : Result := CutAppSettingsMP4;
    else      Result := CutAppSettingsOther;
  end;
end;

function TSettings.GetCutAppName(MovieType: TMovieType): string;
begin
  Result := GetCutAppSettingsByMovieType(MovieType).CutAppName;
end;

function TSettings.GetPreferredSourceFilterByMovieType(MovieType: TMovieType): TGUID;
begin
  Result := GetCutAppSettingsByMovieType(MovieType).PreferredSourceFilter;
end;

function TSettings.GetCutAppNameByCutAppType(CAType: TCutApp): string; // deprecated
begin
  case CAType of
    caAsfBin     : Result := 'AsfBin';
    caVirtualDub : Result := 'VirtualDub';
    caAviDemux   : Result := 'AviDemux';
    else           Result := '';
  end;
end;

procedure TSettings.Load;
var
  ini: TIniFile;
  FileName: string;
  section: string;
  iFilter, iCutApplication: Integer;

  procedure ReadOldCutAppName(var ASettings: RCutAppSettings; const s1: string; t1: TCutApp; s2, default: string);
  begin
    with ASettings do
    begin
      //defaults and old ini files (belw 0.9.11.6)
      if CutAppName = '' then
        CutAppName := ini.ReadString(section, s2, '');
      //old ini Files (for Compatibility with versions below 0.9.9):
      if (CutAppName = '') and (s1 <> '') then
        CutAppName := GetCutAppNameByCutAppType(TCutApp(ini.ReadInteger(section, s1, Integer(t1))));
      if CutAppName = '' then
        CutAppName := default;
    end;
  end;

begin
  if UseIniFileAtUser then
    FileName := IniFileAtUser
  else
    FileName := IniFileAtExe;

  ini := TIniFile.Create(FileName);
  try
    section := 'General';
    UserName         := ini.ReadString(section, 'UserName', '');
    UserID           := ini.ReadString(section, 'UserID', '');
    Language         := ini.ReadString(section, 'Language', '');
    ExceptionLogging := ini.ReadBool(section, 'ExceptionLogging', False);

    section := 'FrameWindow';
    FramesWidth  := ini.ReadInteger(section, 'Width', 180);
    FramesHeight := ini.ReadInteger(section, 'Height', 135);
    FramesCount  := ini.ReadInteger(section, 'Count', 12);

    section := 'WMV Files';
    ReadCutAppSettings(ini, section, CutAppSettingsWmv);

    section := 'AVI Files';
    ReadCutAppSettings(ini, section, CutAppSettingsAVI);

    section := 'HQ AVI Files';
    ReadCutAppSettings(ini, section, CutAppSettingsHQAVI);

    section := 'HD AVI Files';
    ReadCutAppSettings(ini, section, CutAppSettingsHDAVI);

    section := 'MP4 Files';
    ReadCutAppSettings(ini, section, CutAppSettingsMP4);

    section := 'OtherMediaFiles';
    ReadCutAppSettings(ini, section, CutAppSettingsOther);

    section := 'External Cut Application';
    CuttingWaitTimeout := ini.ReadInteger(section, 'CuttingWaitTimeout', 20);
    ReadOldCutAppName(CutAppSettingsWmv, 'CutAppWmv', caAsfBin, 'CutAppNameWmv', 'AsfBin');
    ReadOldCutAppName(CutAppSettingsAvi, 'CutAppAvi', caVirtualDub, 'CutAppNameAvi', 'VirtualDub');
    ReadOldCutAppName(CutAppSettingsAvi, 'CutAppHQAvi', caVirtualDub, 'CutAppNameHQAvi', 'VirtualDub');
    ReadOldCutAppName(CutAppSettingsMP4, '', TCutApp(0), 'CutAppNameMP4', 'MP4Box');
    ReadOldCutAppName(CutAppSettingsOther, 'CutAppOther', caVirtualDub, 'CutAppNameOther', 'VirtualDub');

    //provisorisch
    section := 'Filter Blacklist';
    for iFilter := 0 to Pred(ini.ReadInteger(section, 'Count', 0)) do
      FilterBlackList.AddFromString(ini.ReadString(section, 'Filter_' + IntToStr(iFilter), ''));

    section := 'Files';
    _SaveCutlistMode           := ini.ReadInteger(section, 'SaveCutlistMode', smWithSource or smAlwaysAsk);
    CutlistSaveDir             := ini.ReadString(section, 'CutlistSaveDir', '');
    _SaveCutMovieMode          := ini.ReadInteger(section, 'SaveCutMovieMode', smWithSource);
    UseMovieNameSuggestion     := ini.ReadBool(section, 'UseMovieNameSuggestion', False);
    CutMovieSaveDir            := ini.ReadString(section, 'CutMovieSaveDir', '');
    CutMovieExtension          := ini.ReadString(section, 'CutMovieExtension', '.cut');
    AutoSaveDownloadedCutlists := ini.ReadBool(section, 'AutoSaveDownloadedCutlists', True);

    section := 'URLs';
    url_cutlists_home   := ini.ReadString(section, 'CutlistServerHome', 'http://www.cutlist.at/');
    url_cutlists_upload := ini.ReadString(section, 'CutlistServerUpload', 'http://www.cutlist.at/index.php?upload=2');
    url_info_file       := ini.ReadString(section, 'ApplicationInfoFile', DEFAULT_UPDATE_XML);
    url_help            := ini.ReadString(section, 'ApplicationHelp', 'http://wiki.onlinetvrecorder.com/index.php/Cut_Assistant');

    section := 'Connection';
    NetTimeout      := ini.ReadInteger(section, 'Timeout', 20);
    proxyServerName := ini.ReadString(section, 'ProxyServerName', '');
    proxyPort       := ini.ReadInteger(section, 'ProxyPort', 0);
    proxyUserName   := ini.ReadString(section, 'ProxyUserName', '');
    proxyPassword   := ini.ReadString(section, 'ProxyPassword', '');

    section := 'Settings';
    OffsetSecondsCutChecking := ini.ReadInteger(section, 'OffsetSecondsCutChecking', 2);
    CurrentMovieDir          := ini.ReadString(section, 'CurrentMovieDir', ExtractFilePath(Application.ExeName));
    InfoCheckInterval        := ini.ReadInteger(section, 'InfoCheckIntervalDays', -1);
    InfoLastChecked          := ini.ReadDate(section, 'InfoLastChecked', 0);
    InfoShowMessages         := ini.ReadBool(section, 'InfoShowMessages', False);
    InfoShowStable           := ini.ReadBool(section, 'InfoShowStable', False);
    InfoShowBeta             := ini.ReadBool(section, 'InfoShowBeta', False);
    DefaultCutMode           := ini.ReadInteger(section, 'DefaultCutMode', Integer(clmTrim));
    SmallSkipTime            := ini.ReadInteger(section, 'SmallSkipTime', 2);
    LargeSkipTime            := ini.ReadInteger(section, 'LargeSkipTime', 25);
    FinePosFrameCount        := ini.ReadInteger(section, 'FinePosFrameCount', 5);
    AutoMuteOnSeek           := ini.ReadBool(section, 'AutoMuteOnSeek', False);
    NoRateSuccMsg            := ini.ReadBool(section, 'NoRateSuccMsg', False);
    NoWarnUseRate            := ini.ReadBool(section, 'NoWarnUseRate', False);
    NewNextFrameMethod       := ini.ReadBool(section, 'NewNextFrameMethod', False);
    AutoSearchCutlists       := ini.ReadBool(section, 'AutoSearchCutlists', False);
    SearchLocalCutlists      := ini.ReadBool(section, 'SearchLocalCutlists', False);
    SearchServerCutlists     := ini.ReadBool(section, 'SearchServerCutlists', True);
    SearchCutlistsByName     := ini.ReadBool(section, 'SearchCutlistsByName', False);
    CutPreview               := ini.ReadBool(section, 'CutPreview', False);

    section := 'Warnings';
    WarnOnWrongCutApp := ini.ReadBool(section, 'WarnOnWrongCutApp', True);

    section := 'ServerMessages';
    MsgServerRatingDone := ini.ReadString(section, 'RatingDone', 'Cutlist wurde bewertet');

    section := 'WindowStates';
    MainFormWindowState    := TWindowState(ini.ReadInteger(section, 'Main_WindowState', Integer(wsNormal)));
    MainFormBounds         := iniReadRect(ini, section, 'Main', EmptyRect);
    FramesFormWindowState  := TWindowState(ini.ReadInteger(section, 'Frames_WindowState', Integer(wsNormal)));
    FramesFormBounds       := iniReadRect(ini, section, 'Frames', EmptyRect);
    PreviewFormWindowState := TWindowState(ini.ReadInteger(section, 'Preview_WindowState', Integer(wsNormal)));
    PreviewFormBounds      := iniReadRect(ini, section, 'Preview', EmptyRect);
    LoggingFormBounds      := iniReadRect(ini, section, 'Logging', EmptyRect);
    LoggingFormVisible     := ini.ReadBool(section, 'LoggingFormVisible', False);

    for iCutApplication := 0 to Pred(CutApplicationList.Count) do
      TCutApplicationBase(CutApplicationList[iCutApplication]).LoadSettings(ini);

    section := 'Additional';
    ini.ReadSectionValues(section, FAdditional);

    ReplaceList.LoadFromIni(ini);
  finally
    FreeAndNil(ini);
  end;

  if userID = '' then
  begin
    // Generate Random ID and save it immediately
    userID := rand_string;
    save;
  end;
end;

function TSettings.MovieNameAlwaysConfirm: Boolean;
begin
  Result := ((_SaveCutMovieMode and smAlwaysAsk) > 0);
end;

procedure TSettings.save;
var
  ini: TIniFile;
  FileName: string;
  section: string;
  idx: Integer;
  iCutApplication: Integer;
  iFilter: Integer;
begin
  // If Ini in profile - use it.
  FileName := IniFileAtUser;

  if not UseIniFileAtUser then
  begin
    ini := TIniFile.Create(IniFileAtExe);
    try
      ini.WriteString('Test', 'Test', 'Test');
      FileName := IniFileAtExe;
    except
      on E: Exception do
      begin
        // Too late for message dialog (not working in finalization)
        // ErrMsg(E.Message + sLineBreak + sLineBreak + Format(RSIniInProfile, [IniFileAtUser]));
        System.SysUtils.ForceDirectories(ExtractFileDir(IniFileAtUser));
      end;
    end;
    ini.Free;
  end;

  ini := TIniFile.Create(FileName);
  try
    section := 'General';
    ini.WriteString(section, 'Version', Application_version);
    ini.WriteString(section, 'UserName', UserName);
    ini.WriteString(section, 'UserID', UserID);
    ini.WriteString(section, 'Language', Language);

    if not ExceptionLogging then ini.DeleteKey(section, 'ExceptionLogging')
    else ini.WriteBool(section, 'ExceptionLogging', True);

    section := 'FrameWindow';
    ini.WriteInteger(section, 'Width', FramesWidth);
    ini.WriteInteger(section, 'Height', FramesHeight);
    ini.WriteInteger(section, 'Count', FramesCount);

    section := 'External Cut Application';
    ini.WriteInteger(section, 'CuttingWaitTimeout', CuttingWaitTimeout);

    section := 'WMV Files';
    WriteCutAppSettings(ini, section, CutAppSettingsWmv);

    section := 'AVI Files';
    WriteCutAppSettings(ini, section, CutAppSettingsAvi);

    section := 'HQ AVI Files';
    WriteCutAppSettings(ini, section, CutAppSettingsHQAvi);

    section := 'HD AVI Files';
    WriteCutAppSettings(ini, section, CutAppSettingsHDAvi);

    section := 'MP4 Files';
    WriteCutAppSettings(ini, section, CutAppSettingsMP4);

    section := 'OtherMediaFiles';
    WriteCutAppSettings(ini, section, CutAppSettingsOther);

    section := 'Filter Blacklist';
    ini.WriteInteger(section, 'Count', FilterBlackList.Count);
    for iFilter := 0 to Pred(FilterBlackList.Count) do
      ini.WriteString(section, 'Filter_' + IntToStr(iFilter), GUIDToString(FilterBlackList.Item[iFilter]));

    section := 'Files';
    ini.WriteInteger(section, 'SaveCutlistMode', _SaveCutlistMode);
    ini.WriteString(section, 'CutlistSaveDir', CutlistSaveDir);
    ini.WriteInteger(section, 'SaveCutMovieMode', _SaveCutMovieMode);
    ini.WriteBool(section, 'UseMovieNameSuggestion', UseMovieNameSuggestion);
    ini.WriteString(section, 'CutMovieSaveDir', CutMovieSaveDir);
    ini.WriteString(section, 'CutMovieExtension', CutMovieExtension);
    ini.WriteBool(section, 'AutoSaveDownloadedCutlists', AutoSaveDownloadedCutlists);

    section := 'URLs';
    ini.WriteString(section, 'CutlistServerHome', url_cutlists_home);
    ini.WriteString(section, 'CutlistServerUpload', url_cutlists_upload);
    ini.WriteString(section, 'ApplicationInfoFile', url_info_file);
    ini.WriteString(section, 'ApplicationHelp', url_help);

    section := 'Connection';
    ini.WriteString(section, 'ProxyServerName', ProxyServerName);
    ini.WriteInteger(section, 'ProxyPort', ProxyPort);
    ini.WriteString(section, 'ProxyUserName', ProxyUserName);
    ini.WriteString(section, 'ProxyPassword', ProxyPassword);
    ini.WriteInteger(section, 'Timeout', NetTimeout);

    section := 'Settings';
    ini.WriteInteger(section, 'OffsetSecondsCutChecking', OffsetSecondsCutChecking);
    ini.WriteString(section, 'CurrentMovieDir', CurrentMovieDir);
    ini.WriteInteger(section, 'InfoCheckIntervalDays', InfoCheckInterval);
    ini.WriteDate(section, 'InfoLastChecked', InfoLastChecked);
    ini.WriteBool(section, 'InfoShowMessages', InfoShowMessages);
    ini.WriteBool(section, 'InfoShowBeta', InfoShowBeta);
    ini.WriteBool(section, 'InfoShowStable', InfoShowStable);
    ini.WriteInteger(section, 'DefaultCutMode', DefaultCutMode);
    ini.WriteInteger(section, 'SmallSkipTime', SmallSkipTime);
    ini.WriteInteger(section, 'LargeSkipTime', LargeSkipTime);
    ini.WriteInteger(section, 'FinePosFrameCount', FinePosFrameCount);
    ini.WriteBool(section, 'AutoMuteOnSeek', AutoMuteOnSeek);
    ini.WriteBool(section, 'NoRateSuccMsg', NoRateSuccMsg);
    ini.WriteBool(section, 'NoWarnUseRate', NoWarnUseRate);
    ini.WriteBool(section, 'NewNextFrameMethod', NewNextFrameMethod);
    ini.WriteBool(section, 'AutoSearchCutlists', AutoSearchCutlists);
    ini.WriteBool(section, 'SearchLocalCutlists', SearchLocalCutlists);
    ini.WriteBool(section, 'SearchServerCutlists', SearchServerCutlists);
    ini.WriteBool(section, 'SearchCutlistsByName', SearchCutlistsByName);
    ini.WriteBool(section, 'CutPreview', CutPreview);

    section := 'Warnings';
    ini.WriteBool(section, 'WarnOnWrongCutApp', WarnOnWrongCutApp);

    section := 'WindowStates';
    ini.WriteInteger(section, 'Main_WindowState', Integer(MainFormWindowState));
    iniWriteRect(ini, section, 'Main', MainFormBounds);
    if FramesFormWindowState <> wsNormal then
      ini.WriteInteger(section, 'Frames_WindowState', Integer(FramesFormWindowState));
    iniWriteRect(ini, section, 'Frames', FramesFormBounds);
    if PreviewFormWindowState <> wsNormal then
      ini.WriteInteger(section, 'Preview_WindowState', Integer(PreviewFormWindowState));
    iniWriteRect(ini, section, 'Preview', PreviewFormBounds);
    iniWriteRect(ini, section, 'Logging', LoggingFormBounds);
    ini.WriteBool(section, 'LoggingFormVisible', LoggingFormVisible);

    for iCutApplication := 0 to Pred(CutApplicationList.Count) do
      (CutApplicationList[iCutApplication] as TCutApplicationBase).SaveSettings(ini);

    section := 'Additional';
    with FAdditional do
      for idx := 0 to Pred(Count) do
        ini.WriteString(section, Names[idx], ValueFromIndex[idx]);

    ReplaceList.SaveToIni(ini);
  finally
    FreeAndNil(ini);
    _NewSettingsCreated := not FileExists(FileName);
  end;
end;

function TSettings.SaveCutlistMode: Byte;
begin
  Result := _SaveCutListMode and $0F;
end;

function TSettings.SaveCutMovieMode: Byte;
begin
  Result := _SaveCutMovieMode and $0F;
end;

procedure TFSettings.FormCreate(Sender: TObject);
var
  frame: TfrmCutApplicationBase;
  newTabsheet: TTabsheet;
  iCutApplication: Integer;
  CutApplication: TCutApplicationBase;
  MinSize: TSizeConstraints;
begin
  CBOtherApp_nl.Items.Clear;
  MinSize := tabURLs.Constraints;
  EnumFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); //DirectShow Filters

  for iCutApplication := 0 to Pred(Settings.CutApplicationList.Count) do
  begin
    CutApplication := (Settings.CutApplicationList[iCutApplication] as TCutApplicationBase);
    newTabsheet := TTabsheet.Create(pgSettings);
    newTabsheet.PageControl := pgSettings;
    newTabsheet.Caption := CutApplication.Name;
    newTabsheet.Tag := Integer(CutApplication.FrameClass);
    frame := CutApplication.FrameClass.Create(newTabsheet);
    frame.Parent := newTabsheet;
    frame.Align := alClient;
    frame.CutApplication := CutApplication;
    frame.Init;

    newTabsheet.Constraints := frame.Constraints;
    MinSize.MinWidth := Max(MinSize.MinWidth, frame.Constraints.MinWidth);
    MinSize.MinHeight := Max(MinSize.MinHeight, frame.Constraints.MinHeight);

    CBOtherApp_nl.Items.Add(CutApplication.Name);
  end;

  if tabUserData.Height < MinSize.MinHeight then
    Constraints.MinHeight := Height - (tabUserData.Height - MinSize.MinHeight);
  if tabUserData.Width < MinSize.MinWidth then
    Constraints.MinWidth := Width - (tabUserData.Width - MinSize.MinWidth);

  CBWmvApp_nl.Items.Assign(CBOtherApp_nl.Items);
  CBAviApp_nl.Items.Assign(CBOtherApp_nl.Items);
  CBHQAviApp_nl.Items.Assign(CBOtherApp_nl.Items);
  CBHDAviApp_nl.Items.Assign(CBOtherApp_nl.Items);
  CBMP4App_nl.Items.Assign(CBOtherApp_nl.Items);

  CodecList.Fill;
  cmbCodecWmv_nl.Items   := CodecList;
  cmbCodecAvi_nl.Items   := CodecList;
  cmbCodecHQAvi_nl.Items := CodecList;
  cmbCodecHDAvi_nl.Items := CodecList;
  cmbCodecMP4_nl.Items   := CodecList;
  cmbCodecOther_nl.Items := CodecList;

  Caption := Caption  + ' - ' + IfThen(Settings.UseIniFileAtUser, Settings.IniFileAtUser, Settings.IniFileAtExe);
end;

procedure TFSettings.FormDestroy(Sender: TObject);
begin
  if EnumFilters <> nil then
    FreeAndNil(EnumFilters);
end;

procedure TFSettings.ECheckInfoInterval_nlKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(key, [#0 .. #31, '0'..'9']) then
    Key := #0;
end;

procedure TFSettings.edtFrameWidth_nlExit(Sender: TObject);
var
  val: Integer;
  Edit: TEdit;
begin
  if Assigned(Sender) then
  begin
    Edit := Sender as TEdit;

    val := StrToIntDef(Edit.Text, -1);
    if val < 1 then
    begin
      ActiveControl := Edit;
      raise EConvertError.CreateFmt(RsErrorInvalidValue, [Edit.Text]);
    end
  end;
end;

procedure TFSettings.lbchkBlackList_nlClickCheck(Sender: TObject);
var
  FilterGuid: TGUID;
  idx: Integer;
begin
  if Assigned(EnumFilters) then
  begin
    idx := lbchkBlackList_nl.ItemIndex;
    if idx >= 0 then
    begin
      if idx < EnumFilters.CountFilters then
        FilterGuid := StringToFilterGUID(lbchkBlackList_nl.Items[idx])
      else
        FilterGuid := EnumFilters.Filters[idx].CLSID;

      if lbchkBlackList_nl.Checked[idx] then
        Settings.FilterBlackList.Add(FilterGuid)
      else
        Settings.FilterBlackList.Delete(FilterGuid);
    end;
  end;
end;

procedure TFSettings.FillBlackList;
var
  I,M: Integer;
  filterInfo: TFilCatNode;
  blackList: TGUIDList;
  L: TStringList;
begin
  blackList := TGUIDList.Create;
  for I := 0 to Pred(Settings.FilterBlackList.Count) do
    blackList.Add(Settings.FilterBlackList.Item[I]);

  try
    lbchkBlackList_nl.Clear;
    if EnumFilters <> nil then
      FreeAndNil(EnumFilters);
    EnumFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); //DirectShow Filters
    if Assigned(EnumFilters) then
    begin
      M := 0;
      L := TStringList.Create;
      try
        for I := 0 to Pred(EnumFilters.CountFilters) do
        begin
          filterInfo := EnumFilters.Filters[I];
          if blackList.IsInList(filterInfo.CLSID) then
            blackList.Delete(filterInfo.CLSID);

          M := Max(M, Length(filterInfo.FriendlyName));
          L.AddObject(filterInfo.FriendlyName, TObject(I));
        end;

        L.Sort;
        for I := 0 to Pred(L.Count) do
        begin
          filterInfo := EnumFilters.Filters[Integer(L.Objects[I])];

          lbchkBlackList_nl.AddItem(FilterInfoToString(filterInfo, M), nil);
          lbchkBlackList_nl.Checked[Pred(lbchkBlackList_nl.Count)] := Settings.FilterIsInBlackList(filterInfo.CLSID);
          lbchkBlackList_nl.ItemEnabled[Pred(lbchkBlackList_nl.Count)] := not IsEqualGUID(GUID_NULL, filterInfo.CLSID);
        end;

        // abc874: what is this? blacklisted GUIDs but not in enum? list at bottom (or better discard?)
        filterInfo.FriendlyName := '???';
        for I := 0 to Pred(blackList.Count) do
        begin
          filterInfo.CLSID := blackList.Item[I];
          lbchkBlackList_nl.AddItem(FilterInfoToString(filterInfo, M), nil);
          lbchkBlackList_nl.Checked[Pred(lbchkBlackList_nl.Count)] := True;
          lbchkBlackList_nl.ItemEnabled[Pred(lbchkBlackList_nl.Count)] := not IsEqualGUID(GUID_NULL, filterInfo.CLSID);
        end;
      finally
        L.Free;
      end;
    end;
    // lbchkBlackList_nl.Sorted := True; --> not useful: list disappears
  finally
    FreeAndNil(blackList);
  end;
end;

procedure TFSettings.tabSourceFilterShow(Sender: TObject);
var
  i: Integer;
  filterInfo: TFilCatNode;
begin
  if lbchkBlackList_nl.Count = 0 then
    FillBlackList;

  if Settings.SourceFilterList.Count = 0 then
  begin
    cmbSourceFilterListWMV_nl.Enabled   := False;
    cmbSourceFilterListAVI_nl.Enabled   := False;
    cmbSourceFilterListHQAVI_nl.Enabled := False;
    cmbSourceFilterListHDAVI_nl.Enabled := False;
    cmbSourceFilterListMP4_nl.Enabled   := False;
    cmbSourceFilterListOther_nl.Enabled := False;

    cmbSourceFilterListWMV_nl.Items.Clear;
    cmbSourceFilterListWMV_nl.ItemIndex := -1;
    cmbSourceFilterListAVI_nl.Items.Clear;
    cmbSourceFilterListAVI_nl.ItemIndex := -1;
    cmbSourceFilterListHQAVI_nl.Items.Clear;
    cmbSourceFilterListHQAVI_nl.ItemIndex := -1;
    cmbSourceFilterListHDAVI_nl.Items.Clear;
    cmbSourceFilterListHDAVI_nl.ItemIndex := -1;
    cmbSourceFilterListMP4_nl.Items.Clear;
    cmbSourceFilterListMP4_nl.ItemIndex := -1;
    cmbSourceFilterListOther_nl.Items.Clear;
    cmbSourceFilterListOther_nl.ItemIndex := -1;
  end else
    if cmbSourceFilterListOther_nl.Items.Count = 0 then
    begin
      // lazy initialize
      for i := 0 to Pred(Settings.SourceFilterList.Count) do
      begin
        filterInfo := Settings.SourceFilterList.GetFilterInfo[i];
        cmbSourceFilterListOther_nl.AddItem(FilterInfoToString(filterInfo), nil);
      end;
      cmbSourceFilterListWMV_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);
      cmbSourceFilterListAVI_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);
      cmbSourceFilterListHQAVI_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);
      cmbSourceFilterListHDAVI_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);
      cmbSourceFilterListMP4_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);

      cmbSourceFilterListWMV_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsWmv.PreferredSourceFilter);
      cmbSourceFilterListChange(cmbSourceFilterListWMV_nl);
      cmbSourceFilterListAVI_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsAvi.PreferredSourceFilter);
      cmbSourceFilterListChange(cmbSourceFilterListAVI_nl);
      cmbSourceFilterListHQAVI_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsHQAvi.PreferredSourceFilter);
      cmbSourceFilterListChange(cmbSourceFilterListHQAVI_nl);
      cmbSourceFilterListHDAVI_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsHDAvi.PreferredSourceFilter);
      cmbSourceFilterListChange(cmbSourceFilterListHDAVI_nl);
      cmbSourceFilterListMP4_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsMP4.PreferredSourceFilter);
      cmbSourceFilterListChange(cmbSourceFilterListMP4_nl);
      cmbSourceFilterListOther_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsOther.PreferredSourceFilter);
      cmbSourceFilterListChange(cmbSourceFilterListOther_nl);

      cmbSourceFilterListWMV_nl.Enabled   := True;
      cmbSourceFilterListAVI_nl.Enabled   := True;
      cmbSourceFilterListHQAVI_nl.Enabled := True;
      cmbSourceFilterListHDAVI_nl.Enabled := True;
      cmbSourceFilterListMP4_nl.Enabled   := True;
      cmbSourceFilterListOther_nl.Enabled := True;
    end;
end;

procedure TFSettings.cmdRefreshFilterListClick(Sender: TObject);
var
  cur: TCursor;
begin
  cur := Cursor;
  try
    screen.cursor := crHourglass;
    pnlPleaseWait_nl.Visible := True;
    Application.ProcessMessages;

    cmbSourceFilterListWMV_nl.Clear;
    cmbSourceFilterListAVI_nl.Clear;
    cmbSourceFilterListHQAVI_nl.Clear;
    cmbSourceFilterListHDAVI_nl.Clear;
    cmbSourceFilterListMP4_nl.Clear;
    cmbSourceFilterListOther_nl.Clear;

    FillBlackList;
    Settings.SourceFilterList.Fill(pnlPleaseWait_nl, Settings.FilterBlackList);

    tabSourceFilterShow(sender);
  finally
    screen.cursor := cur;
    pnlPleaseWait_nl.Visible := False;
  end;
end;

function TFSettings.GetMovieTypeFromControl(const Sender: TObject; var MovieType: TMovieType): Boolean;
begin
  if (Sender = cmbSourceFilterListWMV_nl) or (Sender = CBWmvApp_nl) or (Sender = cmbCodecWmv_nl) or (Sender = btnCodecConfigWmv) or (Sender = btnCodecAboutWmv) then
  begin
    MovieType := mtWMV;
    Result    := True;
  end
  else if (Sender = cmbSourceFilterListAVI_nl) or (Sender = CBAviApp_nl) or (Sender = cmbCodecAvi_nl) or (Sender = btnCodecConfigAvi) or (Sender = btnCodecAboutAvi) then
  begin
    MovieType := mtAVI;
    Result    := True;
  end
  else if (Sender = cmbSourceFilterListHQAVI_nl) or (Sender = CBHQAviApp_nl) or (Sender = cmbCodecHQAvi_nl) or (Sender = btnCodecConfigHQAvi) or (Sender = btnCodecAboutHQAvi) then
  begin
    MovieType := mtHQAvi;
    Result    := True;
  end
  else if (Sender = cmbSourceFilterListHDAVI_nl) or (Sender = CBHDAviApp_nl) or (Sender = cmbCodecHDAvi_nl) or (Sender = btnCodecConfigHDAvi) or (Sender = btnCodecAboutHDAvi) then
  begin
    MovieType := mtHDAvi;
    Result    := True;
  end
  else if (Sender = cmbSourceFilterListMP4_nl) or (Sender = CBMP4App_nl) or (Sender = cmbCodecMP4_nl) or (Sender = btnCodecConfigMP4) or (Sender = btnCodecAboutMP4) then
  begin
    MovieType := mtMP4;
    Result    := True;
  end
  else if (Sender = cmbSourceFilterListOther_nl) or (Sender = CBOtherApp_nl) or (Sender = cmbCodecOther_nl) or (Sender = btnCodecConfigOther) or (Sender = btnCodecAboutOther) then
  begin
    MovieType := mtUnknown;
    Result    := True;
  end
  else begin
    Result := False;
  end;
end;

function TFSettings.GetCodecSettingsControls(const Sender: TObject; var cbx: TComboBox; var btnConfig, btnAbout: TButton): Boolean;
var
  MovieType: TMovieType;
begin
  Result := GetMovieTypeFromControl(Sender, MovieType);
  if Result then
    Result := GetCodecSettingsControls(MovieType, cbx, btnConfig, btnAbout);
end;

function TFSettings.GetCodecSettingsControls(const MovieType: TMovieType; var cbx: TComboBox; var btnConfig, btnAbout: TButton): Boolean;
begin
  case MovieType of
    mtWMV     : begin
                  cbx       := cmbCodecWmv_nl;
                  btnConfig := btnCodecConfigWmv;
                  btnAbout  := btnCodecAboutWmv;
                  Result    := True;
                end;
    mtAVI     : begin
                  cbx       := cmbCodecAvi_nl;
                  btnConfig := btnCodecConfigAvi;
                  btnAbout  := btnCodecAboutAvi;
                  Result    := True;
                end;
    mtHQAVI   : begin
                  cbx       := cmbCodecHQAvi_nl;
                  btnConfig := btnCodecConfigHQAvi;
                  btnAbout  := btnCodecAboutHQAvi;
                  Result    := True;
                end;
    mtHDAVI   : begin
                  cbx       := cmbCodecHDAvi_nl;
                  btnConfig := btnCodecConfigHDAvi;
                  btnAbout  := btnCodecAboutHDAvi;
                  Result    := True;
                end;
    mtMP4     : begin
                  cbx       := cmbCodecMP4_nl;
                  btnConfig := btnCodecConfigMP4;
                  btnAbout  := btnCodecAboutMP4;
                  Result    := True;
                end;
    mtUnknown : begin
                  cbx       := cmbCodecOther_nl;
                  btnConfig := btnCodecConfigOther;
                  btnAbout  := btnCodecAboutOther;
                  Result    := True;
                end;
    else        Result := False;
  end;
end;


procedure TFSettings.Init;
begin
  CBWmvApp_nl.ItemIndex   := CBWmvApp_nl.Items.IndexOf(WmvAppSettings.CutAppName);
  CBAviApp_nl.ItemIndex   := CBAviApp_nl.Items.IndexOf(AviAppSettings.CutAppName);
  CBHQAviApp_nl.ItemIndex := CBHQAviApp_nl.Items.IndexOf(HQAviAppSettings.CutAppName);
  CBHDAviApp_nl.ItemIndex := CBHDAviApp_nl.Items.IndexOf(HDAviAppSettings.CutAppName);
  CBMP4App_nl.ItemIndex   := CBMP4App_nl.Items.IndexOf(MP4AppSettings.CutAppName);
  CBOtherApp_nl.ItemIndex := CBOtherApp_nl.Items.IndexOf(OtherAppSettings.CutAppName);

  cmbCodecWmv_nl.ItemIndex   := CodecList.IndexOfCodec(WmvAppSettings.CodecFourCC);
  cmbCodecAvi_nl.ItemIndex   := CodecList.IndexOfCodec(AviAppSettings.CodecFourCC);
  cmbCodecHQAvi_nl.ItemIndex := CodecList.IndexOfCodec(HQAviAppSettings.CodecFourCC);
  cmbCodecHDAvi_nl.ItemIndex := CodecList.IndexOfCodec(HDAviAppSettings.CodecFourCC);
  cmbCodecMP4_nl.ItemIndex   := CodecList.IndexOfCodec(MP4AppSettings.CodecFourCC);
  cmbCodecOther_nl.ItemIndex := CodecList.IndexOfCodec(OtherAppSettings.CodecFourCC);

  cbCutAppChange(CBWmvApp_nl);
  cbCutAppChange(CBAviApp_nl);
  cbCutAppChange(CBHQAviApp_nl);
  cbCutAppChange(CBHDAviApp_nl);
  cbCutAppChange(CBMP4App_nl);
  cbCutAppChange(CBOtherApp_nl);

  cmbCodecChange(CBWmvApp_nl);
  cmbCodecChange(CBAviApp_nl);
  cmbCodecChange(CBHQAviApp_nl);
  cmbCodecChange(CBHDAviApp_nl);
  cmbCodecChange(CBMP4App_nl);
  cmbCodecChange(CBOtherApp_nl);
end;

procedure TFSettings.SetCutAppSettings(const MovieType: TMovieType; var ASettings: RCutAppSettings);
begin
  case MovieType of
    mtWMV     : WmvAppSettings   := ASettings;
    mtAVI     : AviAppSettings   := ASettings;
    mtHQAVI   : HQAviAppSettings := ASettings;
    mtHDAVI   : HDAviAppSettings := ASettings;
    mtMP4     : MP4AppSettings   := ASettings;
    mtUnknown : OtherAppSettings := ASettings;
  end;
end;

procedure TFSettings.GetCutAppSettings(const MovieType: TMovieType; var ASettings: RCutAppSettings);
begin
  case MovieType of
    mtWMV     : begin
                  WmvAppSettings.CutAppName := CBWmvApp_nl.Text;
                  ASettings := WmvAppSettings;
                end;
    mtAVI     : begin
                  AviAppSettings.CutAppName := CBAviApp_nl.Text;
                  ASettings := AviAppSettings;
                end;
    mtHQAvi   : begin
                  HQAviAppSettings.CutAppName := CBHQAviApp_nl.Text;
                  ASettings := HQAviAppSettings;
                end;
    mtHDAvi   : begin
                  HDAviAppSettings.CutAppName := CBHDAviApp_nl.Text;
                  ASettings := HDAviAppSettings;
                end;
    mtMP4     : begin
                  MP4AppSettings.CutAppName := CBMP4App_nl.Text;
                  ASettings := MP4AppSettings;
                end;
    mtUnknown : begin
                  OtherAppSettings.CutAppName := CBOtherApp_nl.Text;
                  ASettings := OtherAppSettings;
                end;
  end;
end;

procedure TFSettings.cmbCodecChange(Sender: TObject);
var
  Codec: TICInfoObject;
  cmbCodec: TComboBox;
  btnConfig, btnAbout: TButton;
  MovieType: TMovieType;
  CutAppSettings: RCutAppSettings;
begin
  if GetMovieTypeFromControl(Sender, MovieType) and GetCodecSettingsControls(MovieType, cmbCodec, btnConfig, btnAbout) then
  begin
    GetCutAppSettings(MovieType, CutAppSettings);

    CutAppSettings.CodecName := cmbCodec.Text;
    // Reset codec settings ...
    CutAppSettings.CodecSettingsSize := 0;
    CutAppSettings.CodecSettings := '';

    Codec := nil;
    if cmbCodec.ItemIndex >= 0 then
      Codec := (cmbCodec.Items.Objects[cmbCodec.ItemIndex] as TICInfoObject);

    if Assigned(Codec) then
    begin
      CutAppSettings.CodecFourCC  := Codec.ICInfo.fccHandler;
      CutAppSettings.CodecVersion := Codec.ICInfo.dwVersion;
      btnConfig.Enabled           := cmbCodec.Enabled and Codec.HasConfigureBox;
      btnAbout.Enabled            := cmbCodec.Enabled and Codec.HasAboutBox;
    end else
    begin
      CutAppSettings.CodecFourCC  := 0;
      CutAppSettings.CodecVersion := 0;
      btnConfig.Enabled           := False;
      btnAbout.Enabled            := False;
    end;
    // only set settings, if sender is codec combo (else called from init)
    if Sender = cmbCodec then
      SetCutAppSettings(MovieType, CutAppSettings);
  end;
end;

procedure TFSettings.btnCodecConfigClick(Sender: TObject);
var
  Codec: TICInfoObject;
  cmbCodec: TComboBox;
  btnConfig, btnAbout: TButton;
  MovieType: TMovieType;
  CutAppSettings: RCutAppSettings;
begin
  if GetMovieTypeFromControl(Sender, MovieType) and GetCodecSettingsControls(MovieType, cmbCodec, btnConfig, btnAbout) then
  begin
    Codec := nil;
    if cmbCodec.ItemIndex >= 0 then
      Codec := (cmbCodec.Items.Objects[cmbCodec.ItemIndex] as TICInfoObject);

    if Assigned(Codec) then
    begin
      GetCutAppSettings(MovieType, CutAppSettings);
      Assert(CutAppSettings.CodecFourCC = Codec.ICInfo.fccHandler);
      if (CutAppSettings.CodecVersion <> Codec.ICInfo.dwVersion) then
      begin
        // Reset settings, if codec version changes ...
        // TODO: Log message or ask user.
        CutAppSettings.CodecVersion := Codec.ICInfo.dwVersion;
        CutAppSettings.CodecSettings := '';
        CutAppSettings.CodecSettingsSize := 0;
      end;
      if Codec.Config(Handle, CutAppSettings.CodecSettings, CutAppSettings.CodecSettingsSize) then
        SetCutAppSettings(MovieType, CutAppSettings);
    end;
  end;
end;

procedure TFSettings.btnCodecAboutClick(Sender: TObject);
var
  Codec: TICInfoObject;
  cmbCodec: TComboBox;
  btnConfig, btnAbout: TButton;
begin
  if GetCodecSettingsControls(Sender, cmbCodec, btnConfig, btnAbout) then
  begin
    Codec := nil;
    if cmbCodec.ItemIndex >= 0 then
      Codec := (cmbCodec.Items.Objects[cmbCodec.ItemIndex] as TICInfoObject);

    if Assigned(Codec) and Codec.HasAboutBox then
      Codec.About(Handle);
  end;
end;

procedure TFSettings.cbCutAppChange(Sender: TObject);
var
  cmbCodec: TComboBox;
  btnConfig, btnAbout: TButton;
  CutApp: TCutApplicationBase;
begin
  if (Sender is TComboBox) and GetCodecSettingsControls(Sender, cmbCodec, btnConfig, btnAbout) then
  begin
    CutApp := Settings.GetCutApplicationByName(TComboBox(Sender).Text);
    cmbCodec.Enabled := Assigned(CutApp) and CutApp.HasSmartRendering;
    // enable / disable controls
    cmbCodecChange(Sender);
  end;
end;

procedure TFSettings.cmbSourceFilterListChange(Sender: TObject);
var
  idx: Integer;
  MovieType: TMovieType;
  CutAppSettings: RCutAppSettings;
begin
  if (Sender is TComboBox) and GetMovieTypeFromControl(Sender, MovieType) then
  begin
    GetCutAppSettings(MovieType, CutAppSettings);
    idx := TComboBox(Sender).ItemIndex;
    if idx >= 0 then
      CutAppSettings.PreferredSourceFilter := Settings.GetFilterInfo[idx].CLSID
    else
      CutAppSettings.PreferredSourceFilter := GUID_NULL;

    SetCutAppSettings(MovieType, CutAppSettings);
  end;
end;

initialization
  EmptyRect := Rect(-1, -1, -1, -1);
end.

