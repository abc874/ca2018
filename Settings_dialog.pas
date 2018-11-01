UNIT Settings_dialog;

INTERFACE

{$WARN UNIT_PLATFORM OFF}

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  COntnrs,
  Dialogs,
  FileCtrl,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  IniFiles,
  Utils,
  CodecSettings,
  MMSystem,
  Movie,
  UCutApplicationBase,

  DirectShow9,
  DSPack,
  DSUtil,
  CheckLst,
  Mask,
  JvExMask,
  JvSpin,
  JvExStdCtrls,
  JvCheckBox;

CONST
  //Settings Save...Mode
  smWithSource                     = $00; //How to Save Cutlists and cut movies
  smGivenDir                       = $01;
  smAutoSaveBeforeCutting          = $40; //Only Cutlist
  smAlwaysAsk                      = $80;
  DEFAULT_UPDATE_XML               = 'http://cutassistant.sourceforge.net/cut_assistant_info.xml';

TYPE

  TFSettings = CLASS(TForm)
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
    PROCEDURE cmdCutMovieSaveDirClick(Sender: TObject);
    PROCEDURE cmdCutlistSaveDirClick(Sender: TObject);
    PROCEDURE edtProxyPort_nlKeyPress(Sender: TObject; VAR Key: Char);
    PROCEDURE FormCreate(Sender: TObject);

    PROCEDURE ECheckInfoInterval_nlKeyPress(Sender: TObject; VAR Key: Char);
    PROCEDURE tabSourceFilterShow(Sender: TObject);
    PROCEDURE cmdRefreshFilterListClick(Sender: TObject);
    PROCEDURE lbchkBlackList_nlClickCheck(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE edtFrameWidth_nlExit(Sender: TObject);
    PROCEDURE cmbCodecChange(Sender: TObject);
    PROCEDURE btnCodecConfigClick(Sender: TObject);
    PROCEDURE btnCodecAboutClick(Sender: TObject);
    PROCEDURE cbCutAppChange(Sender: TObject);
    PROCEDURE cmbSourceFilterListChange(Sender: TObject);
  PRIVATE
    { Private declarations }
    HQAviAppSettings, AviAppSettings, WmvAppSettings, MP4AppSettings, OtherAppSettings: RCutAppSettings;
    EnumFilters: TSysDevEnum;
    PROCEDURE FillBlackList;
    FUNCTION GetCodecList: TCodecList;
    PROPERTY CodecList: TCodecList READ GetCodecList;
  PRIVATE
    FUNCTION GetMovieTypeFromControl(CONST Sender: TObject; VAR MovieType: TMovieType): boolean;
    FUNCTION GetCodecSettingsControls(CONST Sender: TObject;
      VAR cbx: TComboBox; VAR btnConfig, btnAbout: TButton): boolean; OVERLOAD;
    FUNCTION GetCodecSettingsControls(CONST MovieType: TMovieType;
      VAR cbx: TComboBox; VAR btnConfig, btnAbout: TButton): boolean; OVERLOAD;
  PUBLIC
    PROCEDURE Init;
    FUNCTION GetCodecNameByFourCC(FourCC: DWord): STRING;
    PROCEDURE GetCutAppSettings(CONST MovieType: TMovieType; VAR ASettings: RCutAppSettings);
    PROCEDURE SetCutAppSettings(CONST MovieType: TMovieType; VAR ASettings: RCutAppSettings);
    { Public declarations }
  END;

  //deprecated:
  TCutApp = (caAsfBin = 0, caVirtualDub = 1, caAviDemux = 2);

  TSettings = CLASS(TObject)
  PRIVATE
    SourceFilterList: TSourceFilterList;
    _SaveCutListMode, _SaveCutMovieMode: byte;
    _NewSettingsCreated: boolean;
    FCodecList: TCodecList;
    FLanguageList: TStringList;
    FAdditional: TStringList;
    FUNCTION GetLanguageIndex: integer;
    FUNCTION GetLanguageByIndex(index: integer): STRING;
    FUNCTION GetLangDesc(CONST langFile: TFileName): STRING;
    FUNCTION GetLanguageFile: STRING;
    FUNCTION GetAdditional(CONST name: STRING): STRING;
    PROCEDURE SetAdditional(CONST name: STRING; CONST value: STRING);
    FUNCTION GetLanguageList: TStrings;
    FUNCTION GetFilter(Index: Integer): TFilCatNode;
    PROPERTY CodecList: TCodecList READ FCodecList;
  PUBLIC
    // window state
    MainFormBounds, FramesFormBounds, PreviewFormBounds, LoggingFormBounds: TRect;
    MainFormWindowState, FramesFormWindowState, PreviewFormWindowState: TWindowState;
    LoggingFormVisible: boolean;

    //CutApplications
    CutApplicationList: TObjectList;

    //User
    UserName, UserID: STRING;

    // Preview frame window
    FramesWidth, FramesHeight, FramesCount: integer;

    //General
    CutlistSaveDir, CutMovieSaveDir, CutMovieExtension, CurrentMovieDir: STRING;
    UseMovieNameSuggestion: boolean;
    DefaultCutMode: integer;
    SmallSkipTime, LargeSkipTime: integer;
    NetTimeout: integer;
    AutoMuteOnSeek: boolean;
    AutoSearchCutlists: boolean;
    SearchLocalCutlists: boolean;
    SearchServerCutlists: boolean;
    AutoSaveDownloadedCutlists: boolean;
    SearchCutlistsByName: boolean;

    //Warnings
    WarnOnWrongCutApp: boolean;

    //Server messages
    MsgServerRatingDone: STRING;

    //Mplayer
    MPlayerPath: STRING;

    //CutApps
    CuttingWaitTimeout: integer;

    //SourceFilter, CodecSettings
    CutAppSettingsAvi, CutAppSettingsWmv, CutAppSettingsMP4, CutAppSettingsOther: RCutAppSettings;
    CutAppSettingsHQAvi: RCutAppSettings;

    //Blacklist of Filters
    FilterBlackList: TGUIDList;

    //URLs and Proxy
    url_cutlists_home,
      url_cutlists_upload,
      url_info_file,
      url_help: STRING;
    proxyServerName, proxyUserName, proxyPassword: STRING;
    proxyPort: Integer;

    //Other settings
    OffsetSecondsCutChecking: Integer;
    InfoCheckInterval: Integer;
    InfoLastChecked: TDate;
    InfoShowMessages, InfoShowStable, InfoShowBeta: boolean;
    ExceptionLogging: boolean;
    CutPreview: boolean;

    // UI Language
    Language: STRING;

    // Additional settings
    PROPERTY Additional[CONST name: STRING]: STRING READ GetAdditional WRITE SetAdditional;

    PROCEDURE UpdateLanguageList;
    PROPERTY LanguageList: TStrings READ GetLanguageList;
    PROPERTY LanguageFile: STRING READ GetLanguageFile;

    FUNCTION CheckInfos: boolean;

    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;

  PROTECTED
    //deprecated
    FUNCTION GetCutAppNameByCutAppType(CAType: TCutApp): STRING;
  PUBLIC
    FUNCTION GetCutAppName(MovieType: TMovieType): STRING;
    FUNCTION GetCutApplicationByName(CAName: STRING): TCutApplicationBase;
    FUNCTION GetCutAppSettingsByMovieType(MovieType: TMovieType): RCutAppSettings;
    FUNCTION GetCutApplicationByMovieType(MovieType: TMovieType): TCutApplicationBase;

    FUNCTION GetPreferredSourceFilterByMovieType(MovieType: TMovieType): TGUID;
    FUNCTION SaveCutlistMode: byte;
    FUNCTION SaveCutMovieMode: byte;
    FUNCTION MovieNameAlwaysConfirm: boolean;
    FUNCTION CutlistNameAlwaysConfirm: boolean;
    FUNCTION CutlistAutoSaveBeforeCutting: boolean;
    FUNCTION FilterIsInBlackList(ClassID: TGUID): boolean;

    PROCEDURE load;
    PROCEDURE edit;
    PROCEDURE save;
  PUBLISHED
    PROPERTY NewSettingsCreated: boolean READ _NewSettingsCreated;
  PUBLIC
    FUNCTION GetCodecNameByFourCC(FourCC: DWord): STRING;
    PROPERTY GetFilterInfo[Index: Integer]: TFilCatNode READ GetFilter;
  END;

VAR
  FSettings                        : TFSettings;

IMPLEMENTATION

USES
  Math,
  Types,
  Main,
  UCutApplicationAsfbin,
  UCutApplicationVirtualDub,
  UCutApplicationAviDemux,
  UCutApplicationMP4Box,
  UCutlist,
  VFW,
  CAResources,
  uFreeLocalizer,
  StrUtils;

VAR
  EmptyRect                        : TRect;

{$R *.dfm}
{$WARN SYMBOL_PLATFORM OFF}

FUNCTION TFSettings.GetCodecList: TCodecList;
BEGIN
  Result := Settings.CodecList;
END;

FUNCTION TFSettings.GetCodecNameByFourCC(FourCC: DWord): STRING;
BEGIN
  Result := Settings.GetCodecNameByFourCC(FourCC);
END;

FUNCTION TSettings.GetCodecNameByFourCC(FourCC: DWord): STRING;
VAR
  idx                              : integer;
  codec                            : TICInfoObject;
BEGIN
  codec := NIL;
  idx := FCodecList.IndexOfCodec(FourCC);
  IF idx > -1 THEN
    codec := FCodecList.CodecInfoObject[idx];
  IF Assigned(codec) THEN Result := codec.Name
  ELSE Result := '';
END;

PROCEDURE TFSettings.cmdCutMovieSaveDirClick(Sender: TObject);
VAR
  newDir                           : STRING;
  currentDir                       : STRING;
BEGIN
  newDir := self.edtCutMovieSaveDir_nl.Text;
  currentDir := self.edtCutMovieSaveDir_nl.Text;
  IF NOT IsPathRooted(currentDir) THEN
    currentDir := '';
  IF SelectDirectory(CAResources.RSTitleCutMovieDestinationDirectory, currentDir, newDir) THEN
    self.edtCutMovieSaveDir_nl.Text := newDir;
END;

PROCEDURE TFSettings.cmdCutlistSaveDirClick(Sender: TObject);
VAR
  newDir                           : STRING;
  currentDir                       : STRING;
BEGIN
  newDir := self.edtCutlistSaveDir_nl.Text;
  currentDir := self.edtCutlistSaveDir_nl.Text;
  IF NOT IsPathRooted(currentDir) THEN
    currentDir := '';
  IF SelectDirectory(CAResources.RSTitleCutlistDestinationDirectory, currentDir, newDir) THEN
    self.edtCutlistSaveDir_nl.Text := newDir;
END;

PROCEDURE TFSettings.edtProxyPort_nlKeyPress(Sender: TObject; VAR Key: Char);
BEGIN
  IF NOT (key IN [#0..#31, '0'..'9']) THEN
    key := chr(0);
END;

{ TSettings }

FUNCTION TSettings.GetLangDesc(CONST langFile: TFileName): STRING;
CONST
  DESC_PATTERN                     = 'description:';
VAR
  f                                : TextFile;
  line                             : STRING;
  idx                              : integer;
BEGIN
  Result := ExtractFileName(langFile);
  AssignFile(f, langFile);
{$I-}
  FileMode := fmOpenRead;
  Reset(f);
  IF IOResult <> 0 THEN
    Exit;
  WHILE IOResult = 0 DO BEGIN
    ReadLn(f, line);
    IF (IOResult <> 0) OR (line = '') THEN
      Break;
    IF NOT AnsiStartsText(';', line) THEN
      Continue;
    idx := AnsiPos(DESC_PATTERN, AnsiLowerCase(line));
    IF idx < 1 THEN
      Continue;
    Delete(line, 1, idx + Length(DESC_PATTERN));
    idx := AnsiPos('=', line);
    IF idx > 0 THEN
      Delete(line, idx, MaxInt);
    Result := Trim(line);
    Break;
  END;
  CloseFile(f);
{$I+}
END;

PROCEDURE TSettings.UpdateLanguageList;
VAR
  lang_dir, lang_desc              : STRING;
  lang_found                       : boolean;
  sr                               : TSearchRec;
BEGIN
  lang_dir := IncludeTrailingPathDelimiter(FreeLocalizer.LanguageDir);
  FLanguageList.Clear;
  lang_found := self.Language = '';
  IF FindFirst(lang_dir + ChangeFileExt(Application_File, '.*.lng'), faReadOnly, sr) = 0 THEN BEGIN
    REPEAT
      lang_desc := GetLangDesc(lang_dir + sr.Name);
      IF AnsiSameText(sr.Name, self.Language) THEN
        lang_found := true;
      FLanguageList.Add(lang_desc + ' (' + sr.Name + ')');
    UNTIL FindNext(sr) <> 0;
  END;
  IF NOT lang_found THEN
    FLanguageList.Add(self.Language + ' (' + self.Language + ')');
  FLanguageList.Sort;
  FLanguageList.Insert(0, 'Standard');
END;

FUNCTION TSettings.GetLanguageFile: STRING;
BEGIN
  Result := self.Language;
  //if Result = '' then
  //  Result := ChangeFileExt(Application_File, '.lng');
END;

FUNCTION TSettings.GetLanguageList: TStrings;
BEGIN
  Result := FLanguageList;
END;

FUNCTION TSettings.GetAdditional(CONST name: STRING): STRING;
BEGIN
  Result := FAdditional.Values[name];
END;

PROCEDURE TSettings.SetAdditional(CONST name: STRING; CONST value: STRING);
BEGIN
  FAdditional.Values[name] := value;
END;

FUNCTION TSettings.GetLanguageIndex: integer;
VAR
  idx                              : integer;
  lang                             : STRING;
BEGIN
  IF self.Language = '' THEN BEGIN
    Result := 0;
    Exit;
  END;
  lang := '(' + self.Language + ')';
  idx := 0;
  WHILE idx < FLanguageList.Count DO BEGIN
    IF AnsiEndsText(lang, FLanguageList[idx]) THEN
      Break;
    Inc(idx);
  END;
  Result := idx;
END;

FUNCTION TSettings.GetLanguageByIndex(index: integer): STRING;
VAR
  lang                             : STRING;
  idx                              : integer;
BEGIN
  lang := FLanguageList[index];
  idx := Pos('(', lang);
  IF idx = 0 THEN idx := MaxInt;
  Delete(lang, 1, idx);
  Delete(lang, Pos(')', lang), MaxInt);
  Result := lang;
END;

FUNCTION TSettings.CheckInfos: boolean;
BEGIN
  result := (self.InfoCheckInterval >= 0);
END;

CONSTRUCTOR TSettings.create;
BEGIN
  INHERITED;

  Language := '';
  ExceptionLogging := false;

  FLanguageList := TStringList.Create;
  FLanguageList.CaseSensitive := false;
  UpdateLanguageList;

  FCodecList := TCodecList.Create;
  //FCodecList.Fill;

  CutApplicationList := TObjectList.Create;
  CutApplicationList.Add(TCutApplicationAsfbin.Create);
  CutApplicationList.Add(TCutApplicationVirtualDub.Create);
  CutApplicationList.Add(TCutApplicationAviDemux.Create);
  CutApplicationList.Add(TCutApplicationMP4Box.Create);

  SourceFilterList := TSourceFilterList.create;
  FilterBlackList := TGUIDList.Create;

  CutAppSettingsWmv.PreferredSourceFilter := GUID_NULL;
  CutAppSettingsAvi.PreferredSourceFilter := GUID_NULL;
  CutAppSettingsHQAvi.PreferredSourceFilter := GUID_NULL;
  CutAppSettingsMP4.PreferredSourceFilter := GUID_NULL;
  CutAppSettingsOther.PreferredSourceFilter := GUID_NULL;
  FAdditional := TStringList.Create;
END;

FUNCTION TSettings.GetFilter(Index: Integer): TFilCatNode;
BEGIN
  Result := SourceFilterList.GetFilterInfo[Index];
END;

FUNCTION TSettings.CutlistAutoSaveBeforeCutting: boolean;
BEGIN
  result := ((_SaveCutlistMOde AND smAutoSaveBeforeCutting) > 0);
END;

FUNCTION TSettings.CutlistNameAlwaysConfirm: boolean;
BEGIN
  result := ((_SaveCutlistMode AND smAlwaysAsk) > 0);
END;

DESTRUCTOR TSettings.destroy;
BEGIN
  FreeAndNil(FAdditional);
  FreeAndNil(FLanguageList);
  FreeAndNil(FCodecList);
  FreeAndNIL(FilterBlackList);
  FreeAndNIL(SourceFilterList);
  FreeAndNIL(CutApplicationList);
  INHERITED;
END;

PROCEDURE TSettings.edit;
VAR
  message_string                   : STRING;
  newLanguage                      : STRING;
  Data_Valid                       : boolean;
  iTabSheet                        : Integer;
  TabSheet                         : TTabSheet;
  FrameClass                       : TCutApplicationFrameClass;
BEGIN
  FOR iTabSheet := 0 TO FSettings.pgSettings.PageCount - 1 DO BEGIN
    TabSheet := FSettings.pgSettings.Pages[iTabSheet];
    IF TabSheet.Tag <> 0 THEN BEGIN
      FrameClass := TCutApplicationFrameClass(TabSheet.Tag);
      (FSettings.pgSettings.Pages[iTabSheet].Controls[0] AS FrameClass).Init;
    END;
  END;

  FSettings.SetCutAppSettings(mtWMV, self.CutAppSettingsWmv);
  FSettings.SetCutAppSettings(mtAVI, self.CutAppSettingsAvi);
  FSettings.SetCutAppSettings(mtHQAVI, self.CutAppSettingsHQAvi);
  FSettings.SetCutAppSettings(mtMP4, self.CutAppSettingsMP4);
  FSettings.SetCutAppSettings(mtUnknown, self.CutAppSettingsOther);

  FSettings.spnWaitTimeout.AsInteger := self.CuttingWaitTimeout;
  FSettings.rgSaveCutMovieMode.ItemIndex := self.SaveCutMovieMode;
  FSettings.edtCutMovieSaveDir_nl.Text := self.CutMovieSaveDir;
  FSettings.edtCutMovieExtension_nl.Text := self.CutMovieExtension;
  FSettings.cbUseMovieNameSuggestion.Checked := self.UseMovieNameSuggestion;
  FSettings.cbMovieNameAlwaysConfirm.Checked := self.MovieNameAlwaysConfirm;
  FSettings.rgSaveCutlistMode.ItemIndex := self.SaveCutlistMode;
  FSettings.edtCutlistSaveDir_nl.Text := self.CutlistSaveDir;
  FSettings.cbCutlistNameAlwaysConfirm.Checked := self.CutlistNameAlwaysConfirm;
  Fsettings.cbCutlistAutoSaveBeforeCutting.Checked := self.CutlistAutoSaveBeforeCutting;
  Fsettings.rgCutMode.ItemIndex := self.DefaultCutMode;
  FSettings.edtSmallSkip_nl.Text := IntToStr(self.SmallSkipTime);
  FSettings.edtLargeSkip_nl.Text := IntToStr(self.LargeSkipTime);
  FSettings.edtNetTimeout_nl.Text := IntToStr(self.NetTimeout);
  FSettings.cbAutoMuteOnSeek.Checked := self.AutoMuteOnSeek;
  FSettings.cbExceptionLogging.Checked := self.ExceptionLogging;
  FSettings.cbAutoSaveDownloadedCutlists.Checked := self.AutoSaveDownloadedCutlists;

  FSettings.cbAutoSearchCutlists.Checked := self.AutoSearchCutlists;
  FSettings.cbSearchLocalCutlists.Checked := self.SearchLocalCutlists;
  FSettings.cbSearchServerCutlists.Checked := self.SearchServerCutlists;
  FSettings.cbSearchCutlistsByName.Checked := self.SearchCutlistsByName;

  Fsettings.edtURL_Cutlist_Home_nl.Text := self.url_cutlists_home;
  Fsettings.edtURL_Info_File_nl.Text := self.url_info_file;
  Fsettings.edtURL_Cutlist_Upload_nl.Text := self.url_cutlists_upload;
  Fsettings.edtURL_Help_nl.Text := self.url_help;

  FSettings.edtProxyServerName_nl.Text := self.proxyServerName;
  FSettings.edtProxyPort_nl.Text := IntToStr(self.proxyPort);
  FSettings.edtProxyUserName_nl.Text := self.proxyUserName;
  FSettings.edtProxyPassword_nl.Text := self.proxyPassword;

  Fsettings.edtUserName_nl.Text := self.UserName;
  Fsettings.edtUserID_nl.Text := self.UserID;

  FSettings.edtFrameWidth_nl.Text := IntToStr(self.FramesWidth);
  FSettings.edtFrameHeight_nl.Text := IntToStr(self.FramesHeight);
  FSettings.edtFrameCount_nl.Text := IntToStr(self.FramesCount);

  FSettings.cmbLanguage_nl.Items.Assign(self.FLanguageList);
  FSettings.cmbLanguage_nl.ItemIndex := self.GetLanguageIndex;

  FSettings.CBInfoCheckMessages.Checked := self.InfoShowMessages;
  FSettings.CBInfoCheckStable.Checked := self.InfoShowStable;
  FSettings.CBInfoCheckBeta.Checked := self.InfoShowBeta;
  IF self.CheckInfos THEN
    FSettings.ECheckInfoInterval_nl.Text := inttostr(self.InfoCheckInterval)
  ELSE
    FSettings.ECheckInfoInterval_nl.Text := '0';
  FSettings.CBInfoCheckEnabled.Checked := self.CheckInfos;

  FSettings.Init;

  Data_Valid := false;
  WHILE NOT Data_Valid DO BEGIN
    IF FSettings.ShowModal <> mrOK THEN break; //User Cancelled
    Data_Valid := true;
    IF (Fsettings.rgSaveCutMovieMode.ItemIndex = 1) THEN BEGIN
      IF IsPathRooted(FSettings.edtCutMovieSaveDir_nl.Text) AND (NOT DirectoryExists(FSettings.edtCutMovieSaveDir_nl.Text)) THEN BEGIN
        message_string := Format(CAResources.RsCutMovieDirectoryMissing, [FSettings.edtCutMovieSaveDir_nl.Text]);
        IF application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONWARNING) = IDYES THEN BEGIN
          Data_Valid := forceDirectories(FSettings.edtCutMovieSaveDir_nl.Text);
        END ELSE BEGIN
          Data_Valid := false;
          FSettings.pgSettings.ActivePage := Fsettings.tabSaveMovie;
          FSettings.ActiveControl := FSettings.edtCutMovieSaveDir_nl;
        END;
      END;
    END;
    IF Data_Valid AND (Fsettings.rgSaveCutlistMode.ItemIndex = 1) THEN BEGIN
      IF IsPathRooted(FSettings.edtCutlistSaveDir_nl.Text) AND (NOT DirectoryExists(FSettings.edtCutlistSaveDir_nl.Text)) THEN BEGIN
        message_string := Format(CAResources.RsCutlistDirectoryMissing, [FSettings.edtCutlistSaveDir_nl.Text]);
        IF application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONWARNING) = IDYES THEN BEGIN
          Data_Valid := forceDirectories(FSettings.edtCutlistSaveDir_nl.Text);
        END ELSE BEGIN
          Data_Valid := false;
          FSettings.pgSettings.ActivePage := Fsettings.TabSaveCutlist;
          FSettings.ActiveControl := FSettings.edtCutlistSaveDir_nl;
        END;
      END;
    END;
    IF Data_Valid THEN BEGIN //Apply new settings and save them

      self.CuttingWaitTimeout := FSettings.spnWaitTimeout.AsInteger;

      FSettings.GetCutAppSettings(mtWMV, self.CutAppSettingsWmv);
      FSettings.GetCutAppSettings(mtAVI, self.CutAppSettingsAvi);
      FSettings.GetCutAppSettings(mtHQAVI, self.CutAppSettingsHQAvi);
      FSettings.GetCutAppSettings(mtMP4, self.CutAppSettingsMP4);
      FSettings.GetCutAppSettings(mtUnknown, self.CutAppSettingsOther);

      CASE FSettings.rgSaveCutMovieMode.ItemIndex OF
        1: _SaveCutMovieMode := smGivenDir;
      ELSE _SaveCutMovieMode := smWithSource;
      END;
      CutMovieSaveDir := FSettings.edtCutMovieSaveDir_nl.Text;
      CutMovieExtension := FSettings.edtCutMovieExtension_nl.Text;
      IF FSettings.cbMovieNameAlwaysConfirm.Checked THEN _SaveCutMovieMode := _saveCutMovieMode OR smAlwaysAsk;
      UseMovieNameSuggestion := FSettings.CBUseMovieNameSuggestion.Checked;

      CASE FSettings.rgSaveCutlistMode.ItemIndex OF
        1: _SaveCutlistMode := smGivenDir;
      ELSE _SaveCutlistMode := smWithSource;
      END;
      CutlistSaveDir := FSettings.edtCutlistSaveDir_nl.Text;
      IF FSettings.cbCutlistNameAlwaysConfirm.Checked THEN _SaveCutlistMode := _SaveCutlistMode OR smAlwaysAsk;
      IF Fsettings.cbCutlistAutoSaveBeforeCutting.Checked THEN _SaveCutlistMOde := _SaveCutlistMOde OR smAutoSaveBeforeCutting;

      AutoSaveDownloadedCutlists := FSettings.cbAutoSaveDownloadedCutlists.Checked;
      DefaultCutMode := Fsettings.rgCutMode.ItemIndex;

      self.url_cutlists_home := Trim(Fsettings.edtURL_Cutlist_Home_nl.Text);
      IF NOT AnsiEndsText('/', self.url_cutlists_home) THEN
        self.url_cutlists_home := self.url_cutlists_home + '/';
      self.url_info_file := Trim(Fsettings.edtURL_Info_File_nl.Text);
      self.url_cutlists_upload := Trim(Fsettings.edtURL_Cutlist_Upload_nl.Text);
      self.url_help := Trim(Fsettings.edtURL_Help_nl.Text);

      self.proxyServerName := FSettings.edtProxyServerName_nl.Text;
      self.proxyPort := strToIntDef(FSettings.edtProxyPort_nl.Text, self.proxyPort);
      self.proxyUserName := FSettings.edtProxyUserName_nl.Text;
      self.proxyPassword := FSettings.edtProxyPassword_nl.Text;

      self.UserName := Fsettings.edtUserName_nl.Text;

      self.FramesWidth := StrToInt(FSettings.edtFrameWidth_nl.Text);
      self.FramesHeight := StrToInt(FSettings.edtFrameHeight_nl.Text);
      self.FramesCount := StrToInt(FSettings.edtFrameCount_nl.Text);

      self.SmallSkipTime := StrToInt(FSettings.edtSmallSkip_nl.Text);
      self.LargeSkipTime := StrToInt(FSettings.edtLargeSkip_nl.Text);
      self.NetTimeout := StrToInt(FSettings.edtNetTimeout_nl.Text);
      self.AutoMuteOnSeek := FSettings.cbAutoMuteOnSeek.Checked;
      self.ExceptionLogging := FSettings.cbExceptionLogging.Checked;

      self.AutoSearchCutlists := FSettings.cbAutoSearchCutlists.Checked;
      self.SearchLocalCutlists := FSettings.cbSearchLocalCutlists.Checked;
      self.SearchServerCutlists := FSettings.cbSearchServerCutlists.Checked;
      self.SearchCutlistsByName := FSettings.cbSearchCutlistsByName.Checked;

      newLanguage := GetLanguageByIndex(FSettings.cmbLanguage_nl.ItemIndex);
      IF self.Language <> newLanguage THEN BEGIN
        self.Language := newLanguage;
        //ShowMessage(CAResources.RsChangeLanguageNeedsRestart);
      END;

      self.InfoShowMessages := FSettings.CBInfoCheckMessages.Checked;
      self.InfoShowStable := FSettings.CBInfoCheckStable.Checked;
      self.InfoShowBeta := FSettings.CBInfoCheckBeta.Checked;
      IF FSettings.CBInfoCheckEnabled.Checked THEN BEGIN
        self.InfoCheckInterval := strToIntDef(FSettings.ECheckInfoInterval_nl.Text, 0);
      END ELSE BEGIN
        self.InfoCheckInterval := -1;
      END;

      FOR iTabSheet := 0 TO FSettings.pgSettings.PageCount - 1 DO BEGIN
        TabSheet := FSettings.pgSettings.Pages[iTabSheet];
        IF TabSheet.Tag <> 0 THEN BEGIN
          FrameClass := TCutApplicationFrameClass(TabSheet.Tag);
          (FSettings.pgSettings.Pages[iTabSheet].Controls[0] AS FrameClass).Apply;
        END;
      END;

      self.save;
    END;
  END;
END;

FUNCTION TSettings.FilterIsInBlackList(ClassID: TGUID): boolean;
BEGIN
  result := FilterBlackList.IsInList(ClassID);
END;

FUNCTION TSettings.GetCutApplicationByMovieType(
  MovieType: TMovieType): TCutApplicationBase;
BEGIN
  result := self.GetCutApplicationByName(GetCutAppName(MovieType));
  IF Assigned(Result) THEN
    result.CutAppSettings := GetCutAppSettingsByMovieType(MovieType);
END;

FUNCTION TSettings.GetCutApplicationByName(
  CAName: STRING): TCutApplicationBase;
VAR
  iCutApplication                  : Integer;
  FoundCutApplication              : TCutApplicationBase;
BEGIN
  result := NIL;
  FOR iCutApplication := 0 TO CutApplicationList.Count - 1 DO BEGIN
    FoundCutApplication := (CutApplicationList[iCutApplication] AS TCutApplicationBase);
    IF AnsiSameText(FoundCutApplication.Name, CAName) THEN BEGIN
      result := FoundCutApplication;
      break;
    END;
  END;
END;

FUNCTION TSettings.GetCutAppSettingsByMovieType(
  MovieType: TMovieType): RCutAppSettings;
BEGIN
  CASE MovieType OF
    mtWMV: result := self.CutAppSettingsWmv;
    mtAVI: result := self.CutAppSettingsAvi;
    mtHQAVI: result := self.CutAppSettingsHQAvi;
    mtMP4: result := self.CutAppSettingsMP4;
  ELSE result := self.CutAppSettingsOther;
  END;
END;

FUNCTION TSettings.GetCutAppName(MovieType: TMovieType): STRING;
BEGIN
  Result := GetCutAppSettingsByMovieType(MovieType).CutAppName;
END;

FUNCTION TSettings.GetPreferredSourceFilterByMovieType(
  MovieType: TMovieType): TGUID;
BEGIN
  Result := GetCutAppSettingsByMovieType(MovieType).PreferredSourceFilter;
END;

FUNCTION TSettings.GetCutAppNameByCutAppType(CAType: TCutApp): STRING;
//deprecated
BEGIN
  CASE CAType OF
    caAsfBin: result := 'AsfBin';
    caVirtualDub: result := 'VirtualDub';
    caAviDemux: result := 'AviDemux';
  ELSE result := '';
  END;
END;


PROCEDURE TSettings.load;
VAR
  ini                              : TCustomIniFile;
  FileName                         : STRING;
  section                          : STRING;
  iFilter, iCutApplication         : integer;

  PROCEDURE ReadOldCutAppName(VAR ASettings: RCutAppSettings;
    CONST s1: STRING; t1: TCutApp; s2, default: STRING);
  BEGIN
    WITH ASettings DO BEGIN
      //defaults and old ini files (belw 0.9.11.6)
      IF CutAppName = '' THEN
        CutAppName := ini.ReadString(section, s2, '');
      //old ini Files (for Compatibility with versions below 0.9.9):
      IF (CutAppName = '') AND (s1 <> '') THEN
        CutAppName := GetCutAppNameByCutAppType(TCutApp(ini.ReadInteger(section, s1, integer(t1))));
      IF CutAppName = '' THEN
        CutAppName := default;
    END;
  END;
BEGIN
  FileName := ChangeFileExt(Application.ExeName, '.ini');
  self._NewSettingsCreated := NOT FileExists(FileName);
  ini := TIniFile.Create(FileName);
  TRY
    section := 'General';
    UserName := ini.ReadString(section, 'UserName', '');
    UserID := ini.ReadString(section, 'UserID', '');
    Language := ini.ReadString(section, 'Language', '');
    ExceptionLogging := ini.ReadBool(section, 'ExceptionLogging', false);

    section := 'FrameWindow';
    FramesWidth := ini.ReadInteger(section, 'Width', 180);
    FramesHeight := ini.ReadInteger(section, 'Height', 135);
    FramesCount := ini.ReadInteger(section, 'Count', 12);

    section := 'WMV Files';
    ReadCutAppSettings(ini, section, CutAppSettingsWmv);

    section := 'AVI Files';
    ReadCutAppSettings(ini, section, CutAppSettingsAVI);

    section := 'HQ AVI Files';
    ReadCutAppSettings(ini, section, CutAppSettingsHQAVI);

    section := 'MP4 Files';
    ReadCutAppSettings(ini, section, CutAppSettingsMP4);

    section := 'OtherMediaFiles';
    ReadCutAppSettings(ini, section, CutAppSettingsOther);

    section := 'External Cut Application';
    self.CuttingWaitTimeout := ini.ReadInteger(section, 'CuttingWaitTimeout', 20);
    ReadOldCutAppName(self.CutAppSettingsWmv, 'CutAppWmv', caAsfBin, 'CutAppNameWmv', 'AsfBin');
    ReadOldCutAppName(self.CutAppSettingsAvi, 'CutAppAvi', caVirtualDub, 'CutAppNameAvi', 'VirtualDub');
    ReadOldCutAppName(self.CutAppSettingsAvi, 'CutAppHQAvi', caVirtualDub, 'CutAppNameHQAvi', 'VirtualDub');
    ReadOldCutAppName(self.CutAppSettingsMP4, '', TCutApp(0), 'CutAppNameMP4', 'MP4Box');
    ReadOldCutAppName(self.CutAppSettingsOther, 'CutAppOther', caVirtualDub, 'CutAppNameOther', 'VirtualDub');

    //provisorisch
    section := 'Filter Blacklist';
    FOR iFilter := 0 TO ini.ReadInteger(section, 'Count', 0) - 1 DO BEGIN
      self.FilterBlackList.AddFromString(ini.ReadString(section, 'Filter_' + inttostr(iFilter), ''));
    END;

    section := 'Files';
    _SaveCutlistMode := ini.ReadInteger(section, 'SaveCutlistMode', smWithSource OR smAlwaysAsk);
    CutlistSaveDir := ini.ReadString(section, 'CutlistSaveDir', '');
    _SaveCutMovieMode := ini.ReadInteger(section, 'SaveCutMovieMode', smWithSource);
    self.UseMovieNameSuggestion := ini.ReadBool(section, 'UseMovieNameSuggestion', false);

    CutMovieSaveDir := ini.ReadString(section, 'CutMovieSaveDir', '');
    CutMovieExtension := ini.ReadString(section, 'CutMovieExtension', '.cut');

    AutoSaveDownloadedCutlists := ini.ReadBool(section, 'AutoSaveDownloadedCutlists', true);

    section := 'URLs';
    self.url_cutlists_home := ini.ReadString(section, 'CutlistServerHome', 'http://www.cutlist.at/');
    self.url_cutlists_upload := ini.ReadString(section, 'CutlistServerUpload', 'http://www.cutlist.at/index.php?upload=2');
    self.url_info_file := ini.ReadString(section, 'ApplicationInfoFile', DEFAULT_UPDATE_XML);
    self.url_help := ini.ReadString(section, 'ApplicationHelp', 'http://wiki.onlinetvrecorder.com/index.php/Cut_Assistant');

    section := 'Connection';
    self.NetTimeout := ini.ReadInteger(section, 'Timeout', 20);
    self.proxyServerName := ini.ReadString(section, 'ProxyServerName', '');
    self.proxyPort := ini.ReadInteger(section, 'ProxyPort', 0);
    self.proxyUserName := ini.ReadString(section, 'ProxyUserName', '');
    self.proxyPassword := ini.ReadString(section, 'ProxyPassword', '');

    section := 'Settings';
    self.OffsetSecondsCutChecking := ini.ReadInteger(section, 'OffsetSecondsCutChecking', 2);
    self.CurrentMovieDir := ini.ReadString(section, 'CurrentMovieDir', extractfilepath(application.ExeName));
    self.InfoCheckInterval := ini.ReadInteger(section, 'InfoCheckIntervalDays', 1);
    self.InfoLastChecked := ini.ReadDate(section, 'InfoLastChecked', 0);
    self.InfoShowMessages := ini.ReadBool(section, 'InfoShowMessages', true);
    self.InfoShowStable := ini.ReadBool(section, 'InfoShowStable', true);
    self.InfoShowBeta := ini.ReadBool(section, 'InfoShowBeta', false);
    self.DefaultCutMode := ini.ReadInteger(section, 'DefaultCutMode', integer(clmTrim));
    self.SmallSkipTime := ini.ReadInteger(section, 'SmallSkipTime', 2);
    self.LargeSkipTime := ini.ReadInteger(section, 'LargeSkipTime', 25);
    self.AutoMuteOnSeek := ini.ReadBool(section, 'AutoMuteOnSeek', false);
    self.AutoSearchCutlists := ini.ReadBool(section, 'AutoSearchCutlists', false);
    self.SearchLocalCutlists := ini.ReadBool(section, 'SearchLocalCutlists', false);
    self.SearchServerCutlists := ini.ReadBool(section, 'SearchServerCutlists', true);
    self.SearchCutlistsByName := ini.ReadBool(section, 'SearchCutlistsByName', false);
    self.CutPreview := ini.ReadBool(section, 'CutPreview', false);

    section := 'Warnings';
    self.WarnOnWrongCutApp := ini.ReadBool(section, 'WarnOnWrongCutApp', true);

    section := 'ServerMessages';
    self.MsgServerRatingDone := ini.ReadString(section, 'RatingDone', 'Cutlist wurde bewertet');

    section := 'WindowStates';
    self.MainFormWindowState := TWindowState(ini.ReadInteger(section, 'Main_WindowState', integer(wsNormal)));
    self.MainFormBounds := iniReadRect(ini, section, 'Main', EmptyRect);
    self.FramesFormWindowState := TWindowState(ini.ReadInteger(section, 'Frames_WindowState', integer(wsNormal)));
    self.FramesFormBounds := iniReadRect(ini, section, 'Frames', EmptyRect);
    self.PreviewFormWindowState := TWindowState(ini.ReadInteger(section, 'Preview_WindowState', integer(wsNormal)));
    self.PreviewFormBounds := iniReadRect(ini, section, 'Preview', EmptyRect);
    self.LoggingFormBounds := iniReadRect(ini, section, 'Logging', EmptyRect);
    self.LoggingFormVisible := ini.ReadBool(section, 'LoggingFormVisible', false);

    FOR iCutApplication := 0 TO CutApplicationList.Count - 1 DO BEGIN
      TCutApplicationBase(CutApplicationList[iCutApplication]).LoadSettings(ini);
    END;

    section := 'Additional';
    ini.ReadSectionValues(section, self.FAdditional);
  FINALLY
    FreeAndNil(ini);
  END;

  IF userID = '' THEN BEGIN
    //Generade Random ID and save it immediately
    userID := rand_string;
    self.save;
  END;
END;

FUNCTION TSettings.MovieNameAlwaysConfirm: boolean;
BEGIN
  result := ((_SaveCutMovieMode AND smAlwaysAsk) > 0);
END;

PROCEDURE TSettings.save;
VAR
  ini                              : TCustomIniFile;
  FileName                         : STRING;
  section                          : STRING;
  idx                              : integer;
  iCutApplication                  : integer;
  iFilter                          : integer;
BEGIN
  FileName := ChangeFileExt(Application.ExeName, '.ini');
  ini := TIniFile.Create(FileName);
  TRY
    section := 'General';
    ini.WriteString(section, 'Version', Application_version);
    ini.WriteString(section, 'UserName', UserName);
    ini.WriteString(section, 'UserID', UserID);
    ini.WriteString(section, 'Language', Language);

    IF NOT ExceptionLogging THEN ini.DeleteKey(section, 'ExceptionLogging')
    ELSE ini.WriteBool(section, 'ExceptionLogging', true);

    section := 'FrameWindow';
    ini.WriteInteger(section, 'Width', FramesWidth);
    ini.WriteInteger(section, 'Height', FramesHeight);
    ini.WriteInteger(section, 'Count', FramesCount);

    section := 'External Cut Application';
    ini.WriteInteger(section, 'CuttingWaitTimeout', self.CuttingWaitTimeout);

    section := 'WMV Files';
    WriteCutAppSettings(ini, section, CutAppSettingsWmv);

    section := 'AVI Files';
    WriteCutAppSettings(ini, section, CutAppSettingsAvi);

    section := 'HQ AVI Files';
    WriteCutAppSettings(ini, section, CutAppSettingsHQAvi);

    section := 'MP4 Files';
    WriteCutAppSettings(ini, section, CutAppSettingsMP4);

    section := 'OtherMediaFiles';
    WriteCutAppSettings(ini, section, CutAppSettingsOther);

    section := 'Filter Blacklist';
    ini.WriteInteger(section, 'Count', self.FilterBlackList.Count);
    FOR iFilter := 0 TO self.FilterBlackList.Count - 1 DO BEGIN
      ini.WriteString(section, 'Filter_' + IntToStr(iFilter), GUIDToString(self.FilterBlackList.Item[iFilter]));
    END;

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
    ini.WriteString(section, 'CurrentMovieDir', self.CurrentMovieDir);
    ini.WriteInteger(section, 'InfoCheckIntervalDays', self.InfoCheckInterval);
    ini.WriteDate(section, 'InfoLastChecked', self.InfoLastChecked);
    ini.WriteBool(section, 'InfoShowMessages', self.InfoShowMessages);
    ini.WriteBool(section, 'InfoShowBeta', self.InfoShowBeta);
    ini.WriteBool(section, 'InfoShowStable', self.InfoShowStable);
    ini.WriteInteger(section, 'DefaultCutMode', self.DefaultCutMode);
    ini.WriteInteger(section, 'SmallSkipTime', self.SmallSkipTime);
    ini.WriteInteger(section, 'LargeSkipTime', self.LargeSkipTime);
    ini.WriteBool(section, 'AutoMuteOnSeek', self.AutoMuteOnSeek);
    ini.WriteBool(section, 'AutoSearchCutlists', self.AutoSearchCutlists);
    ini.WriteBool(section, 'SearchLocalCutlists', self.SearchLocalCutlists);
    ini.WriteBool(section, 'SearchServerCutlists', self.SearchServerCutlists);
    ini.WriteBool(section, 'SearchCutlistsByName', self.SearchCutlistsByName);
    ini.WriteBool(section, 'CutPreview', self.CutPreview);

    section := 'Warnings';
    ini.WriteBool(section, 'WarnOnWrongCutApp', WarnOnWrongCutApp);

    section := 'WindowStates';
    ini.WriteInteger(section, 'Main_WindowState', integer(self.MainFormWindowState));
    iniWriteRect(ini, section, 'Main', self.MainFormBounds);
    IF self.FramesFormWindowState <> wsNormal THEN
      ini.WriteInteger(section, 'Frames_WindowState', integer(self.FramesFormWindowState));
    iniWriteRect(ini, section, 'Frames', self.FramesFormBounds);
    IF self.PreviewFormWindowState <> wsNormal THEN
      ini.WriteInteger(section, 'Preview_WindowState', integer(self.PreviewFormWindowState));
    iniWriteRect(ini, section, 'Preview', self.PreviewFormBounds);
    iniWriteRect(ini, section, 'Logging', self.LoggingFormBounds);
    ini.WriteBool(section, 'LoggingFormVisible', self.LoggingFormVisible);

    FOR iCutApplication := 0 TO CutApplicationList.Count - 1 DO BEGIN
      (CutApplicationList[iCutApplication] AS TCutApplicationBase).SaveSettings(ini);
    END;

    section := 'Additional';
    WITH self.FAdditional DO
      FOR idx := 0 TO Count - 1 DO
        ini.WriteString(section, Names[idx], ValueFromIndex[idx]);

  FINALLY
    FreeAndNil(ini);
    self._NewSettingsCreated := NOT FileExists(FileName);
  END;
END;

FUNCTION TSettings.SaveCutlistMode: byte;
BEGIN
  result := self._SaveCutListMode AND $0F;
END;

FUNCTION TSettings.SaveCutMovieMode: byte;
BEGIN
  result := self._SaveCutMovieMode AND $0F;
END;

PROCEDURE TFSettings.FormCreate(Sender: TObject);
VAR
  frame                            : TfrmCutApplicationBase;
  newTabsheet                      : TTabsheet;
  iCutApplication                  : integer;
  CutApplication                   : TCutApplicationBase;
  MinSize                          : TSizeConstraints;
BEGIN
  CBOtherApp_nl.Items.Clear;
  MinSize := tabURLs.Constraints;
  EnumFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); //DirectShow Filters

  FOR iCutApplication := 0 TO Settings.CutApplicationList.Count - 1 DO BEGIN
    CutApplication := (Settings.CutApplicationList[iCutApplication] AS TCutApplicationBase);
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
  END;

  IF tabUserData.Height < MinSize.MinHeight THEN
    self.Constraints.MinHeight := self.Height - (tabUserData.Height - MinSize.MinHeight);
  IF tabUserData.Width < MinSize.MinWidth THEN
    self.Constraints.MinWidth := self.Width - (tabUserData.Width - MinSize.MinWidth);

  CBWmvApp_nl.Items.Assign(CBOtherApp_nl.Items);
  CBAviApp_nl.Items.Assign(CBOtherApp_nl.Items);
  CBHQAviApp_nl.Items.Assign(CBOtherApp_nl.Items);
  CBMP4App_nl.Items.Assign(CBOtherApp_nl.Items);

  CodecList.Fill;
  cmbCodecWmv_nl.Items := CodecList;
  cmbCodecAvi_nl.Items := CodecList;
  cmbCodecHQAvi_nl.Items := CodecList;
  cmbCodecMP4_nl.Items := CodecList;
  cmbCodecOther_nl.Items := CodecList;
END;


PROCEDURE TFSettings.FormDestroy(Sender: TObject);
BEGIN
  IF EnumFilters <> NIL THEN
    FreeAndNil(EnumFilters);
END;

PROCEDURE TFSettings.ECheckInfoInterval_nlKeyPress(Sender: TObject;
  VAR Key: Char);
BEGIN
  IF NOT (key IN [#0..#31, '0'..'9']) THEN key := chr(0);
END;

PROCEDURE TFSettings.edtFrameWidth_nlExit(Sender: TObject);
VAR
  val                              : integer;
  Edit                             : TEdit;
BEGIN
  Edit := Sender AS TEdit;
  IF Edit = NIL THEN exit;
  val := StrToIntDef(Edit.Text, -1);
  IF val < 1 THEN BEGIN
    ActiveControl := Edit;
    RAISE EConvertError.CreateFmt(CAResources.RsErrorInvalidValue, [Edit.Text]);
  END
END;

PROCEDURE TFSettings.lbchkBlackList_nlClickCheck(Sender: TObject);
VAR
  FilterGuid                       : TGUID;
  idx                              : integer;
BEGIN
  IF NOT assigned(EnumFilters) THEN exit;

  idx := lbchkBlackList_nl.ItemIndex;
  IF idx = -1 THEN
    exit;
  IF idx < EnumFilters.CountFilters THEN
    FilterGuid := StringToFilterGUID(lbchkBlackList_nl.Items[idx])
  ELSE
    FilterGuid := EnumFilters.Filters[idx].CLSID;
  IF lbchkBlackList_nl.Checked[idx] THEN BEGIN
    Settings.FilterBlackList.Add(FilterGuid);
  END
  ELSE BEGIN
    Settings.FilterBlackList.Delete(FilterGuid);
  END;
END;

PROCEDURE TFSettings.FillBlackList;
VAR
  i, filterCount                   : Integer;
  filterInfo                       : TFilCatNode;
  blackList                        : TGUIDList;
BEGIN
  blackList := TGUIDList.Create;
  FOR I := 0 TO Settings.FilterBlackList.Count - 1 DO
    blackList.Add(Settings.FilterBlackList.Item[i]);
  TRY
    lbchkBlackList_nl.Clear;
    IF EnumFilters <> NIL THEN
      FreeAndNil(EnumFilters);
    EnumFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); //DirectShow Filters
    IF NOT assigned(EnumFilters) THEN exit;

    filterCount := EnumFilters.CountFilters;
    FOR i := 0 TO filterCount - 1 DO BEGIN
      filterInfo := EnumFilters.Filters[i];
      IF blackList.IsInList(filterInfo.CLSID) THEN
        blackList.Delete(filterInfo.CLSID);
      lbchkBlackList_nl.AddItem(FilterInfoToString(filterInfo), NIL);
      lbchkBlackList_nl.Checked[lbchkBlackList_nl.Count - 1] := Settings.FilterIsInBlackList(filterInfo.CLSID);
      lbchkBlackList_nl.ItemEnabled[lbchkBlackList_nl.Count - 1] := NOT IsEqualGUID(GUID_NULL, filterInfo.CLSID);
    END;
    filterInfo.FriendlyName := '???';
    FOR I := 0 TO blackList.Count - 1 DO BEGIN
      filterInfo.CLSID := blackList.Item[i];
      lbchkBlackList_nl.AddItem(FilterInfoToString(filterInfo), NIL);
      lbchkBlackList_nl.Checked[lbchkBlackList_nl.Count - 1] := true;
      lbchkBlackList_nl.ItemEnabled[lbchkBlackList_nl.Count - 1] := NOT IsEqualGUID(GUID_NULL, filterInfo.CLSID);
    END;
  FINALLY
    FreeAndNil(blackList);
  END;
END;

PROCEDURE TFSettings.tabSourceFilterShow(Sender: TObject);
VAR
  i                                : Integer;
  filterInfo                       : TFilCatNode;
BEGIN
  IF lbchkBlackList_nl.Count = 0 THEN BEGIN
    FillBlackList;
  END;
  IF Settings.SourceFilterList.count = 0 THEN BEGIN
    cmbSourceFilterListWMV_nl.Enabled := false;
    cmbSourceFilterListAVI_nl.Enabled := false;
    cmbSourceFilterListHQAVI_nl.Enabled := false;
    cmbSourceFilterListMP4_nl.Enabled := false;
    cmbSourceFilterListOther_nl.Enabled := false;

    cmbSourceFilterListWMV_nl.Items.Clear;
    cmbSourceFilterListWMV_nl.ItemIndex := -1;
    cmbSourceFilterListAVI_nl.Items.Clear;
    cmbSourceFilterListAVI_nl.ItemIndex := -1;
    cmbSourceFilterListHQAVI_nl.Items.Clear;
    cmbSourceFilterListHQAVI_nl.ItemIndex := -1;
    cmbSourceFilterListMP4_nl.Items.Clear;
    cmbSourceFilterListMP4_nl.ItemIndex := -1;
    cmbSourceFilterListOther_nl.Items.Clear;
    cmbSourceFilterListOther_nl.ItemIndex := -1;
  END ELSE IF self.cmbSourceFilterListOther_nl.Items.Count = 0 THEN BEGIN
    // lazy initialize
    FOR i := 0 TO Settings.SourceFilterList.count - 1 DO BEGIN
      filterInfo := Settings.SourceFilterList.GetFilterInfo[i];
      self.cmbSourceFilterListOther_nl.AddItem(FilterInfoToString(filterInfo), NIL);
    END;
    cmbSourceFilterListWMV_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);
    cmbSourceFilterListAVI_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);
    cmbSourceFilterListHQAVI_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);
    cmbSourceFilterListMP4_nl.Items.Assign(cmbSourceFilterListOther_nl.Items);

    cmbSourceFilterListWMV_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsWmv.PreferredSourceFilter);
    cmbSourceFilterListChange(cmbSourceFilterListWMV_nl);
    cmbSourceFilterListAVI_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsAvi.PreferredSourceFilter);
    cmbSourceFilterListChange(cmbSourceFilterListAVI_nl);
    cmbSourceFilterListHQAVI_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsHQAvi.PreferredSourceFilter);
    cmbSourceFilterListChange(cmbSourceFilterListHQAVI_nl);
    cmbSourceFilterListMP4_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsMP4.PreferredSourceFilter);
    cmbSourceFilterListChange(cmbSourceFilterListMP4_nl);
    cmbSourceFilterListOther_nl.ItemIndex := Settings.SourceFilterList.GetFilterIndexByCLSID(Settings.CutAppSettingsOther.PreferredSourceFilter);
    cmbSourceFilterListChange(cmbSourceFilterListOther_nl);

    cmbSourceFilterListWMV_nl.Enabled := true;
    cmbSourceFilterListAVI_nl.Enabled := true;
    cmbSourceFilterListHQAVI_nl.Enabled := true;
    cmbSourceFilterListMP4_nl.Enabled := true;
    cmbSourceFilterListOther_nl.Enabled := true;
  END;
END;

PROCEDURE TFSettings.cmdRefreshFilterListClick(Sender: TObject);
VAR
  cur                              : TCursor;
BEGIN
  cur := self.Cursor;
  TRY
    screen.cursor := crHourglass;
    self.pnlPleaseWait_nl.Visible := true;
    application.ProcessMessages;

    cmbSourceFilterListWMV_nl.Clear;
    cmbSourceFilterListAVI_nl.Clear;
    cmbSourceFilterListHQAVI_nl.Clear;
    cmbSourceFilterListMP4_nl.Clear;
    cmbSourceFilterListOther_nl.Clear;

    FillBlackList;
    Settings.SourceFilterList.Fill(pnlPleaseWait_nl, Settings.FilterBlackList);

    tabSourceFilterShow(sender);
  FINALLY
    screen.cursor := cur;
    self.pnlPleaseWait_nl.Visible := false;
  END;
END;

FUNCTION TFSettings.GetMovieTypeFromControl(CONST Sender: TObject; VAR MovieType: TMovieType): boolean;
BEGIN
  IF (Sender = cmbSourceFilterListWMV_nl) OR (Sender = CBWmvApp_nl) OR (Sender = cmbCodecWmv_nl) OR (Sender = btnCodecConfigWmv) OR (Sender = btnCodecAboutWmv) THEN BEGIN
    MovieType := mtWMV;
    Result := true;
  END
  ELSE IF (Sender = cmbSourceFilterListAVI_nl) OR (Sender = CBAviApp_nl) OR (Sender = cmbCodecAvi_nl) OR (Sender = btnCodecConfigAvi) OR (Sender = btnCodecAboutAvi) THEN BEGIN
    MovieType := mtAVI;
    Result := true;
  END
  ELSE IF (Sender = cmbSourceFilterListHQAVI_nl) OR (Sender = CBHQAviApp_nl) OR (Sender = cmbCodecHQAvi_nl) OR (Sender = btnCodecConfigHQAvi) OR (Sender = btnCodecAboutHQAvi) THEN BEGIN
    MovieType := mtHQAvi;
    Result := true;
  END
  ELSE IF (Sender = cmbSourceFilterListMP4_nl) OR (Sender = CBMP4App_nl) OR (Sender = cmbCodecMP4_nl) OR (Sender = btnCodecConfigMP4) OR (Sender = btnCodecAboutMP4) THEN BEGIN
    MovieType := mtMP4;
    Result := true;
  END
  ELSE IF (Sender = cmbSourceFilterListOther_nl) OR (Sender = CBOtherApp_nl) OR (Sender = cmbCodecOther_nl) OR (Sender = btnCodecConfigOther) OR (Sender = btnCodecAboutOther) THEN BEGIN
    MovieType := mtUnknown;
    Result := true;
  END
  ELSE BEGIN
    Result := false;
  END;
END;

FUNCTION TFSettings.GetCodecSettingsControls(CONST Sender: TObject;
  VAR cbx: TComboBox; VAR btnConfig, btnAbout: TButton): boolean;
VAR
  MovieType                        : TMovieType;
BEGIN
  Result := GetMovieTypeFromControl(Sender, MovieType);
  IF Result THEN
    Result := GetCodecSettingsControls(MovieType, cbx, btnConfig, btnAbout);
END;

FUNCTION TFSettings.GetCodecSettingsControls(CONST MovieType: TMovieType;
  VAR cbx: TComboBox; VAR btnConfig, btnAbout: TButton): boolean;
BEGIN
  CASE MovieType OF
    mtWMV: BEGIN
        cbx := cmbCodecWmv_nl;
        btnConfig := btnCodecConfigWmv;
        btnAbout := btnCodecAboutWmv;
        Result := true;
      END;
    mtAVI: BEGIN
        cbx := cmbCodecAvi_nl;
        btnConfig := btnCodecConfigAvi;
        btnAbout := btnCodecAboutAvi;
        Result := true;
      END;
    mtHQAVI: BEGIN
        cbx := cmbCodecHQAvi_nl;
        btnConfig := btnCodecConfigHQAvi;
        btnAbout := btnCodecAboutHQAvi;
        Result := true;
      END;
    mtMP4: BEGIN
        cbx := cmbCodecMP4_nl;
        btnConfig := btnCodecConfigMP4;
        btnAbout := btnCodecAboutMP4;
        Result := true;
      END;
    mtUnknown: BEGIN
        cbx := cmbCodecOther_nl;
        btnConfig := btnCodecConfigOther;
        btnAbout := btnCodecAboutOther;
        Result := true;
      END;
  ELSE
    Result := false;
  END;
END;


PROCEDURE TFSettings.Init;
BEGIN
  CBWmvApp_nl.ItemIndex := CBWmvApp_nl.Items.IndexOf(WmvAppSettings.CutAppName);
  CBAviApp_nl.ItemIndex := CBAviApp_nl.Items.IndexOf(AviAppSettings.CutAppName);
  CBHQAviApp_nl.ItemIndex := CBHQAviApp_nl.Items.IndexOf(HQAviAppSettings.CutAppName);
  CBMP4App_nl.ItemIndex := CBMP4App_nl.Items.IndexOf(MP4AppSettings.CutAppName);
  CBOtherApp_nl.ItemIndex := CBOtherApp_nl.Items.IndexOf(OtherAppSettings.CutAppName);

  cmbCodecWmv_nl.ItemIndex := CodecList.IndexOfCodec(WmvAppSettings.CodecFourCC);
  cmbCodecAvi_nl.ItemIndex := CodecList.IndexOfCodec(AviAppSettings.CodecFourCC);
  cmbCodecHQAvi_nl.ItemIndex := CodecList.IndexOfCodec(HQAviAppSettings.CodecFourCC);
  cmbCodecMP4_nl.ItemIndex := CodecList.IndexOfCodec(MP4AppSettings.CodecFourCC);
  cmbCodecOther_nl.ItemIndex := CodecList.IndexOfCodec(OtherAppSettings.CodecFourCC);

  cbCutAppChange(CBWmvApp_nl);
  cbCutAppChange(CBAviApp_nl);
  cbCutAppChange(CBHQAviApp_nl);
  cbCutAppChange(CBMP4App_nl);
  cbCutAppChange(CBOtherApp_nl);

  cmbCodecChange(CBWmvApp_nl);
  cmbCodecChange(CBAviApp_nl);
  cmbCodecChange(CBHQAviApp_nl);
  cmbCodecChange(CBMP4App_nl);
  cmbCodecChange(CBOtherApp_nl);
END;

PROCEDURE TFSettings.SetCutAppSettings(CONST MovieType: TMovieType; VAR ASettings: RCutAppSettings);
BEGIN
  CASE MovieType OF
    mtWMV: WmvAppSettings := ASettings;
    mtAVI: AviAppSettings := ASettings;
    mtHQAVI: HQAviAppSettings := ASettings;
    mtMP4: MP4AppSettings := ASettings;
    mtUnknown: OtherAppSettings := ASettings;
  END;
END;

PROCEDURE TFSettings.GetCutAppSettings(CONST MovieType: TMovieType; VAR ASettings: RCutAppSettings);
BEGIN
  CASE MovieType OF
    mtWMV: BEGIN
        WmvAppSettings.CutAppName := CBWmvApp_nl.Text;
        ASettings := WmvAppSettings;
      END;
    mtAVI: BEGIN
        AviAppSettings.CutAppName := CBAviApp_nl.Text;
        ASettings := AviAppSettings;
      END;
    mtHQAvi: BEGIN
        HQAviAppSettings.CutAppName := CBHQAviApp_nl.Text;
        ASettings := HQAviAppSettings;
      END;
    mtMP4: BEGIN
        MP4AppSettings.CutAppName := CBMP4App_nl.Text;
        ASettings := MP4AppSettings;
      END;
    mtUnknown: BEGIN
        OtherAppSettings.CutAppName := CBOtherApp_nl.Text;
        ASettings := OtherAppSettings;
      END;
  END;
END;

PROCEDURE TFSettings.cmbCodecChange(Sender: TObject);
VAR
  Codec                            : TICInfoObject;
  cmbCodec                         : TComboBox;
  btnConfig, btnAbout              : TButton;
  MovieType                        : TMovieType;
  CutAppSettings                   : RCutAppSettings;
BEGIN
  IF NOT GetMovieTypeFromControl(Sender, MovieType) THEN
    Exit;
  IF NOT GetCodecSettingsControls(MovieType, cmbCodec, btnConfig, btnAbout) THEN
    Exit;

  GetCutAppSettings(MovieType, CutAppSettings);

  CutAppSettings.CodecName := cmbCodec.Text;
  // Reset codec settings ...
  CutAppSettings.CodecSettingsSize := 0;
  CutAppSettings.CodecSettings := '';

  Codec := NIL;
  IF cmbCodec.ItemIndex >= 0 THEN BEGIN
    Codec := (cmbCodec.Items.Objects[cmbCodec.ItemIndex] AS TICInfoObject);
  END;
  IF Assigned(Codec) THEN BEGIN
    CutAppSettings.CodecFourCC := Codec.ICInfo.fccHandler;
    CutAppSettings.CodecVersion := Codec.ICInfo.dwVersion;
    btnConfig.Enabled := cmbCodec.Enabled AND Codec.HasConfigureBox;
    btnAbout.Enabled := cmbCodec.Enabled AND Codec.HasAboutBox;
  END ELSE BEGIN
    CutAppSettings.CodecFourCC := 0;
    CutAppSettings.CodecVersion := 0;
    btnConfig.Enabled := false;
    btnAbout.Enabled := false;
  END;
  // only set settings, if sender is codec combo (else called from init)
  IF Sender = cmbCodec THEN
    SetCutAppSettings(MovieType, CutAppSettings);
END;

PROCEDURE TFSettings.btnCodecConfigClick(Sender: TObject);
VAR
  Codec                            : TICInfoObject;
  cmbCodec                         : TComboBox;
  btnConfig, btnAbout              : TButton;
  MovieType                        : TMovieType;
  CutAppSettings                   : RCutAppSettings;
BEGIN
  IF NOT GetMovieTypeFromControl(Sender, MovieType) THEN
    Exit;
  IF NOT GetCodecSettingsControls(MovieType, cmbCodec, btnConfig, btnAbout) THEN
    Exit;
  Codec := NIL;
  IF cmbCodec.ItemIndex >= 0 THEN
    Codec := (cmbCodec.Items.Objects[cmbCodec.ItemIndex] AS TICInfoObject);
  IF Assigned(Codec) THEN BEGIN
    GetCutAppSettings(MovieType, CutAppSettings);
    Assert(CutAppSettings.CodecFourCC = Codec.ICInfo.fccHandler);
    IF (CutAppSettings.CodecVersion <> Codec.ICInfo.dwVersion) THEN BEGIN
      // Reset settings, if codec version changes ...
      // TODO: Log message or ask user.
      CutAppSettings.CodecVersion := Codec.ICInfo.dwVersion;
      CutAppSettings.CodecSettings := '';
      CutAppSettings.CodecSettingsSize := 0;
    END;
    IF Codec.Config(self.Handle, CutAppSettings.CodecSettings, CutAppSettings.CodecSettingsSize) THEN BEGIN
      SetCutAppSettings(MovieType, CutAppSettings);
    END;
  END;
END;

PROCEDURE TFSettings.btnCodecAboutClick(Sender: TObject);
VAR
  Codec                            : TICInfoObject;
  cmbCodec                         : TComboBox;
  btnConfig, btnAbout              : TButton;
BEGIN
  IF NOT GetCodecSettingsControls(Sender, cmbCodec, btnConfig, btnAbout) THEN
    Exit;
  Codec := NIL;
  IF cmbCodec.ItemIndex >= 0 THEN
    Codec := (cmbCodec.Items.Objects[cmbCodec.ItemIndex] AS TICInfoObject);
  IF Assigned(Codec) THEN BEGIN
    IF Codec.HasAboutBox THEN
      Codec.About(self.Handle);
  END;
END;

PROCEDURE TFSettings.cbCutAppChange(Sender: TObject);
VAR
  cbx, cmbCodec                    : TComboBox;
  btnConfig, btnAbout              : TButton;
  CutApp                           : TCutApplicationBase;
BEGIN
  cbx := Sender AS TComboBox;
  IF NOT Assigned(cbx) THEN exit;
  IF NOT GetCodecSettingsControls(Sender, cmbCodec, btnConfig, btnAbout) THEN
    Exit;

  CutApp := Settings.GetCutApplicationByName(cbx.Text);
  cmbCodec.Enabled := Assigned(CutApp) AND CutApp.HasSmartRendering;
  // enable / disable controls
  cmbCodecChange(Sender);
END;

PROCEDURE TFSettings.cmbSourceFilterListChange(Sender: TObject);
VAR
  idx                              : integer;
  cbx                              : TComboBox;
  MovieType                        : TMovieType;
  CutAppSettings                   : RCutAppSettings;
BEGIN
  cbx := Sender AS TComboBox;
  IF NOT Assigned(cbx) THEN exit;
  IF NOT GetMovieTypeFromControl(Sender, MovieType) THEN
    Exit;
  GetCutAppSettings(MovieType, CutAppSettings);
  idx := cbx.ItemIndex;
  IF idx >= 0 THEN
    CutAppSettings.PreferredSourceFilter := Settings.GetFilterInfo[idx].CLSID
  ELSE
    CutAppSettings.PreferredSourceFilter := GUID_NULL;
  SetCutAppSettings(MovieType, CutAppSettings);
END;

INITIALIZATION
  BEGIN
    EmptyRect := Rect(-1, -1, -1, -1);
  END;

END.

