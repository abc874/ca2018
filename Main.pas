UNIT Main;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  DateUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  OleCtrls,
  StdCtrls,
  contnrs,
  shellapi,
  Buttons,
  ExtCtrls,
  strutils,
  iniFiles,
  Registry,
  ComObj,
  Menus,
  math,
  ToolWin,
  Clipbrd,

  ImgList,
  ActnList,

  IdException,
  IdBaseComponent,
  IdComponent,
  IdThreadComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  IdMultipartFormData,
  IdAntiFreezeBase,
  IdAntiFreeze,

  DSPack,
  DSUtil,
  DirectShow9,
  wmf9,
  ActiveX,

  Settings_dialog,
  ManageFilters,
  UploadList,
  CutlistInfo_dialog,
  UCutlist,
  Movie,
  Unit_DSTrackBarEx,
  trackBarEx,
  Utils,
  CodecSettings,

  JvComponentBase,
  JvSimpleXml,
  JclSimpleXML,
  JvGIF,
  JvSpeedbar,
  JvExExtCtrls,
  JvExtComponent,
  JvExControls,
  JvBaseDlg,
  JvProgressDialog,
  JvAppCommand,
  JvExStdCtrls,
  JvCheckBox,
  JvDialogs;

CONST
  //Registry Keys
  CutlistID                        = 'CutAssistant.Cutlist';
  CUTLIST_CONTENT_TYPE             = 'text/plain';
  ProgID                           = 'Cut_Assistant.exe';
  ShellEditKey                     = 'CutAssistant.edit';

TYPE

  TFMain = CLASS(TForm)
    cmdStop: TButton;
    cmdPlayPause: TButton;
    lvCutlist: TListView;
    cmdAddCut: TButton;
    cmdDeleteCut: TButton;
    edtFrom: TEdit;
    edtDuration: TEdit;
    edtTo: TEdit;
    lblCutFrom: TLabel;
    lblCutDuration: TLabel;
    lblCutTo: TLabel;
    cmdSetFrom: TButton;
    cmdSetTo: TButton;
    cmdFromStart: TButton;
    cmdToEnd: TButton;
    cmdJumpFrom: TButton;
    cmdJumpTo: TButton;
    cmdReplaceCut: TButton;
    cmdEditCut: TButton;
    rgCutMode: TRadioGroup;
    cmdPrev12: TButton;
    cmdStepBack: TButton;
    cmdStepForwards: TButton;
    tbVolume: TTrackBar;
    lblVolume: TLabel;
    lblPos_nl: TLabel;
    cmdNext12: TButton;
    tbFinePos: TtrackBarEx;
    lblMinFinepos_nl: TLabel;
    lblMaxFinepos_nl: TLabel;
    lblDuration_nl: TLabel;
    bvCutilistInfo: TBevel;
    bvMovieControl: TBevel;
    odCutlist: TOpenDialog;
    VideoWindow: TVideoWindow;
    lblFinePos_nl: TLabel;
    tbFilePos: TDSTrackBarEx;
    SampleGrabber: TSampleGrabber;
    TeeFilter: TFilter;
    NullRenderer: TFilter;
    lblStartPosition_nl: TLabel;
    pnlVideoWindow: TPanel;
    cmd12FromTo: TButton;
    cmdConvert: TButton;
    actOpenMovie: TAction;
    actOpenCutlist: TAction;
    actFileExit: TAction;
    ImageList: TImageList;
    actSaveCutlistAs: TAction;
    actAddCut: TAction;
    actReplaceCut: TAction;
    actEditCut: TAction;
    actDeleteCut: TAction;
    actShowFramesForm: TAction;
    actNextFrames: TAction;
    actPrevFrames: TAction;
    actScanInterval: TAction;
    actStartCutting: TAction;
    actEditSettings: TAction;
    actMovieMetaData: TAction;
    actAbout: TAction;
    actUsedFilters: TAction;
    actWriteToRegisty: TAction;
    actRemoveRegistryEntries: TAction;
    actCutlistUpload: TAction;
    WebRequest_nl: TIdHTTP;
    actStepForward: TAction;
    actStepBackward: TAction;
    actBrowseWWWHelp: TAction;
    actOpenCutlistHome: TAction;
    actRepairMovie: TAction;
    cmdCutlistInfo: TBitBtn;
    actCutlistInfo: TAction;
    ICutlistWarning: TImage;
    actSaveCutlist: TAction;
    actCalculateResultingTimes: TAction;
    actAsfbinInfo: TAction;
    pnlAuthor: TPanel;
    lblCutlistAuthor_nl: TLabel;
    actSearchCutlistByFileSize: TAction;
    actSendRating: TAction;
    actDeleteCutlistFromServer: TAction;
    lblTotalCutoff_nl: TLabel;
    lblResultingDuration_nl: TLabel;
    tbRate: TtrackBarEx;
    lblRate: TLabel;
    lblCurrentRate_nl: TLabel;
    lblTrueRate_nl: TLabel;
    cmdNextCut: TButton;
    cmdPrevCut: TButton;
    actNextCut: TAction;
    actPrevCut: TAction;
    cmdFF: TButton;
    FilterGraph: TFilterGraph;
    actFullScreen: TAction;
    actCloseMovie: TAction;
    actSnapshotCopy: TAction;
    actSnapshotSave: TAction;
    mnuVideo: TPopupMenu;
    miVideoCopySnapshottoClipboard_nl: TMenuItem;
    miVideoSaveSnapshotas_nl: TMenuItem;
    actPlayInMPlayerAndSkip: TAction;
    miVideoNextXFrames_nl: TMenuItem;
    miVideoPreviousXFrames_nl: TMenuItem;
    miN1_nl: TMenuItem;
    XMLResponse: TJvSimpleXML;
    ActionList: TActionList;
    SpeedBar_nl: TJvSpeedBar;
    mnuMain: TMainMenu;
    miFile: TMenuItem;
    miCutlist: TMenuItem;
    miEdit: TMenuItem;
    miFrames: TMenuItem;
    miInfo: TMenuItem;
    miOptions: TMenuItem;
    miHelp: TMenuItem;
    miOpenMovie_nl: TMenuItem;
    miStartCutting_nl: TMenuItem;
    miPlayMovieinMPlayer_nl: TMenuItem;
    miRepairMovie_nl: TMenuItem;
    miCloseMovie_nl: TMenuItem;
    miN2_nl: TMenuItem;
    miExit_nl: TMenuItem;
    miOpenCutlist_nl: TMenuItem;
    miSearchCutlistsonServer_nl: TMenuItem;
    miN3_nl: TMenuItem;
    miSaveCutlistAs_nl: TMenuItem;
    miSaveCutlist_nl: TMenuItem;
    miUploadCutlisttoServer_nl: TMenuItem;
    miDeleteCutlistfromServer_nl: TMenuItem;
    miN4_nl: TMenuItem;
    miCutlistInfo_nl: TMenuItem;
    miCheckcutMovie_nl: TMenuItem;
    miSendRating_nl: TMenuItem;
    miAddnewcut_nl: TMenuItem;
    miReplaceselectedcut_nl: TMenuItem;
    miEditselectedcut_nl: TMenuItem;
    miDeleteselectedcut_nl: TMenuItem;
    miShowForm_nl: TMenuItem;
    miN5_nl: TMenuItem;
    miScanInterval_nl: TMenuItem;
    miPreviousXFrames_nl: TMenuItem;
    miNextXFrames_nl: TMenuItem;
    miMovieMetaData_nl: TMenuItem;
    miUsedFilters_nl: TMenuItem;
    miCutApplications_nl: TMenuItem;
    miSettings_nl: TMenuItem;
    miN6_nl: TMenuItem;
    miAssociatewithfileextensions_nl: TMenuItem;
    miRemoveregistryentries_nl: TMenuItem;
    miCutlistHomepage_nl: TMenuItem;
    miInternetHelpPages_nl: TMenuItem;
    miN7_nl: TMenuItem;
    miAbout_nl: TMenuItem;
    JvSpeedBarSection1: TJvSpeedBarSection;
    JvSpeedItem1: TJvSpeedItem;
    JvSpeedItem2: TJvSpeedItem;
    JvSpeedItem3: TJvSpeedItem;
    JvSpeedItem4: TJvSpeedItem;
    JvSpeedItem5: TJvSpeedItem;
    JvSpeedItem6: TJvSpeedItem;
    JvSpeedItem7: TJvSpeedItem;
    JvSpeedItem8: TJvSpeedItem;
    JvSpeedItem9: TJvSpeedItem;
    JvSpeedItem10: TJvSpeedItem;
    JvSpeedItem11: TJvSpeedItem;
    JvSpeedItem12: TJvSpeedItem;
    JvSpeedItem13: TJvSpeedItem;
    JvSpeedItem14: TJvSpeedItem;
    JvSpeedItem15: TJvSpeedItem;
    actSmallSkipForward: TAction;
    actSmallSkipBackward: TAction;
    actLargeSkipForward: TAction;
    actLargeSkipBackward: TAction;
    miNavigation: TMenuItem;
    miStepForward_nl: TMenuItem;
    miStepBack_nl: TMenuItem;
    miN8_nl: TMenuItem;
    miSmallSkipForward_nl: TMenuItem;
    miSmallSkipBack_nl: TMenuItem;
    miN9_nl: TMenuItem;
    miLargeSkipForward_nl: TMenuItem;
    miLargeSkipBack_nl: TMenuItem;
    miN10_nl: TMenuItem;
    miNextCut_nl: TMenuItem;
    miPrevCut_nl: TMenuItem;
    actShowLogging: TAction;
    miN13_nl: TMenuItem;
    miShowLoggingMessages_nl: TMenuItem;
    actTestExceptionHandling: TAction;
    miTestExceptionHandling_nl: TMenuItem;
    actCheckInfoOnServer: TAction;
    miCheckinfoonserver_nl: TMenuItem;
    actOpenCutassistantHome: TAction;
    miCutAssistantProject_nl: TMenuItem;
    dlgRequestProgress: TJvProgressDialog;
    RequestWorker: TIdThreadComponent;
    actSupportRequest: TAction;
    miMakeasupportrequest_nl: TMenuItem;
    lblMovieType_nl: TLabel;
    lblCutApplication_nl: TLabel;
    lblMovieFPS_nl: TLabel;
    actStop: TAction;
    actPlayPause: TAction;
    miPlayPause_nl: TMenuItem;
    miStop_nl: TMenuItem;
    miN16_nl: TMenuItem;
    actPlay: TAction;
    actPause: TAction;
    miPlay_nl: TMenuItem;
    miPause_nl: TMenuItem;
    AppCommand: TJvAppCommand;
    actCurrentFrames: TAction;
    miFramesAround_nl: TMenuItem;
    JvSpeedItem16: TJvSpeedItem;
    cbMute: TJvCheckBox;
    actSearchCutlistLocal: TAction;
    JvSpeedItem17: TJvSpeedItem;
    SearchCutlistsinDirectory_nl: TMenuItem;
    KeyFrameGrabber: TSampleGrabber;
    odMovie: TJvOpenDialog;
    cbCutPreview: TJvCheckBox;
    actSetCutStart: TAction;
    actSetCutEnd: TAction;
    actJumpCutStart: TAction;
    actJumpCutEnd: TAction;
    actSelectNextCut: TAction;
    actSelectPrevCut: TAction;
    miN17_nl: TMenuItem;
    miSetendofcut_nl: TMenuItem;
    miSetstartofcut_nl: TMenuItem;
    miJumptostartofcut_nl: TMenuItem;
    miJumptoendofcut_nl: TMenuItem;
    actShiftCut: TAction;
    shiftCut1: TMenuItem;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
    PROCEDURE FormKeyDown(Sender: TObject; VAR Key: Word;
      Shift: TShiftState);
    PROCEDURE cmdFromStartClick(Sender: TObject);
    PROCEDURE cmdToEndClick(Sender: TObject);
    PROCEDURE actStepForwardExecute(Sender: TObject);
    PROCEDURE actStepBackwardExecute(Sender: TObject);

    PROCEDURE lvCutlistSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    PROCEDURE lvCutlistDblClick(Sender: TObject);
    PROCEDURE rgCutModeClick(Sender: TObject);

    PROCEDURE tbVolumeChange(Sender: TObject);
    PROCEDURE cbMuteClick(Sender: TObject);

    PROCEDURE tbFilePosTimer(sender: TObject; CurrentPos,
      StopPos: Cardinal);
    PROCEDURE tbFilePosPositionChangedByMouse(Sender: TObject);
    PROCEDURE tbFilePosChange(Sender: TObject);
    PROCEDURE tbFilePosSelChanged(Sender: TObject);
    PROCEDURE tbFilePosChannelPostPaint(Sender: TDSTrackBarEx;
      CONST ARect: TRect);
    PROCEDURE tbFinePosMOuseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    PROCEDURE tbFinePosChange(Sender: TObject);
    PROCEDURE FilterGraphGraphStepComplete(Sender: TObject);
    PROCEDURE pnlVideoWindowResize(Sender: TObject);
    PROCEDURE actOpenMovieExecute(Sender: TObject);
    PROCEDURE actOpenCutlistExecute(Sender: TObject);
    PROCEDURE actSaveCutlistExecute(Sender: TObject);
    PROCEDURE actSaveCutlistAsExecute(Sender: TObject);
    PROCEDURE actFileExitExecute(Sender: TObject);
    PROCEDURE actAddCutExecute(Sender: TObject);
    PROCEDURE actReplaceCutExecute(Sender: TObject);
    PROCEDURE actEditCutExecute(Sender: TObject);
    PROCEDURE actDeleteCutExecute(Sender: TObject);
    PROCEDURE cmdConvertClick(Sender: TObject);
    PROCEDURE actCutlistInfoExecute(Sender: TObject);
    PROCEDURE actSearchCutlistByFileSizeExecute(Sender: TObject);
    PROCEDURE actCutlistUploadExecute(Sender: TObject);
    PROCEDURE actSendRatingExecute(Sender: TObject);
    PROCEDURE actDeleteCutlistFromServerExecute(Sender: TObject);

    PROCEDURE actShowFramesFormExecute(Sender: TObject);
    PROCEDURE actNextFramesExecute(Sender: TObject);
    PROCEDURE actPrevFramesExecute(Sender: TObject);
    PROCEDURE actScanIntervalExecute(Sender: TObject);

    PROCEDURE actRepairMovieExecute(Sender: TObject);
    PROCEDURE actStartCuttingExecute(Sender: TObject);
    PROCEDURE actAsfbinInfoExecute(Sender: TObject);
    PROCEDURE actMovieMetaDataExecute(Sender: TObject);
    PROCEDURE actEditSettingsExecute(Sender: TObject);
    PROCEDURE actUsedFiltersExecute(Sender: TObject);
    PROCEDURE actAboutExecute(Sender: TObject);
    PROCEDURE actBrowseWWWHelpExecute(Sender: TObject);
    PROCEDURE actOpenCutlistHomeExecute(Sender: TObject);

    PROCEDURE actWriteToRegistyExecute(Sender: TObject);
    PROCEDURE actRemoveRegistryEntriesExecute(Sender: TObject);

    PROCEDURE actCalculateResultingTimesExecute(Sender: TObject);
    PROCEDURE VideoWindowClick(Sender: TObject);
    PROCEDURE tbRateChange(Sender: TObject);
    PROCEDURE lblCurrentRate_nlDblClick(Sender: TObject);
    PROCEDURE actNextCutExecute(Sender: TObject);
    PROCEDURE actPrevCutExecute(Sender: TObject);
    PROCEDURE cmdFFMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    PROCEDURE cmdFFMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    PROCEDURE VideoWindowDblClick(Sender: TObject);
    PROCEDURE actFullScreenExecute(Sender: TObject);
    PROCEDURE VideoWindowKeyDown(Sender: TObject; VAR Key: Word;
      Shift: TShiftState);
    PROCEDURE actCloseMovieExecute(Sender: TObject);
    PROCEDURE actSnapshotCopyExecute(Sender: TObject);
    PROCEDURE actSnapshotSaveExecute(Sender: TObject);
    PROCEDURE actPlayInMPlayerAndSkipExecute(Sender: TObject);
    FUNCTION FilterGraphSelectedFilter(Moniker: IMoniker; FilterName: WideString; ClassID: TGUID): Boolean;
    PROCEDURE FramePopUpNext12FramesClick(Sender: TObject);
    PROCEDURE FramePopUpPrevious12FramesClick(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE actShowLoggingExecute(Sender: TObject);
    PROCEDURE actTestExceptionHandlingExecute(Sender: TObject);
    PROCEDURE actCheckInfoOnServerExecute(Sender: TObject);
    PROCEDURE actOpenCutassistantHomeExecute(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE dlgRequestProgressShow(Sender: TObject);
    PROCEDURE dlgRequestProgressProgress(Sender: TObject;
      VAR AContinue: Boolean);
    PROCEDURE RequestWorkerRun(Sender: TIdCustomThreadComponent);
    PROCEDURE RequestWorkerException(Sender: TIdCustomThreadComponent;
      AException: Exception);
    PROCEDURE WebRequest_nlStatus(ASender: TObject; CONST AStatus: TIdStatus;
      CONST AStatusText: STRING);
    PROCEDURE actSupportRequestExecute(Sender: TObject);
    PROCEDURE dlgRequestProgressCancel(Sender: TObject);
    PROCEDURE WebRequest_nlWork(Sender: TObject; AWorkMode: TWorkMode;
      CONST AWorkCount: Integer);
    PROCEDURE actStopExecute(Sender: TObject);
    PROCEDURE actPlayPauseExecute(Sender: TObject);
    PROCEDURE actPlayExecute(Sender: TObject);
    PROCEDURE actPauseExecute(Sender: TObject);
    PROCEDURE AppCommandAppCommand(Handle: Cardinal; Cmd: Word;
      Device: TJvAppCommandDevice; KeyState: Word; VAR Handled: Boolean);
    PROCEDURE actCurrentFramesExecute(Sender: TObject);
    PROCEDURE FilterGraphGraphComplete(sender: TObject; Result: HRESULT;
      Renderer: IBaseFilter);
    PROCEDURE actSearchCutlistLocalExecute(Sender: TObject);
    PROCEDURE FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; VAR Handled: Boolean);
    PROCEDURE SampleGrabberSample(sender: TObject; SampleTime: Double;
      ASample: IMediaSample);
    PROCEDURE KeyFrameGrabberSample(sender: TObject; SampleTime: Double;
      ASample: IMediaSample);
    PROCEDURE actSetCutStartExecute(Sender: TObject);
    PROCEDURE actSetCutEndExecute(Sender: TObject);
    PROCEDURE actJumpCutStartExecute(Sender: TObject);
    PROCEDURE actJumpCutEndExecute(Sender: TObject);
    PROCEDURE actSelectNextCutExecute(Sender: TObject);
    PROCEDURE actSelectPrevCutExecute(Sender: TObject);
    PROCEDURE actShiftCutExecute(Sender: TObject);
  PRIVATE
    { Private declarations }
    UploadDataEntries: TStringList;
    StepComplete: boolean;
    SampleInfo: RMediaSample;
    KeyFrameSampleInfo: RMediaSample;
    PROCEDURE ResetForm;
    PROCEDURE EnableMovieControls(value: boolean);
    PROCEDURE InitVideo;
    PROCEDURE InsertKeyFrameGrabber;
    PROCEDURE InsertSampleGrabber;
    FUNCTION GetSampleGrabberMediaType(VAR MediaType: TAMMediaType): HResult;
    FUNCTION CustomGetSampleGrabberBitmap(Bitmap: TBitmap; Buffer: Pointer; BufferLen: Integer): boolean;
    {
    function SampleCB(SampleTime: double; MediaSample: IMediaSample): HRESULT; stdcall;
    function  BufferCB(SampleTime: Double; pBuffer: PByte; BufferLen: longint): HResult; stdcall;
    }
    PROCEDURE refresh_lvCutlist(cutlist: TCutlist);
    FUNCTION WaitForStep(TimeOut: Integer; CONST WaitForSampleInfo: Boolean): boolean;
    PROCEDURE WaitForFilterGraph;
    PROCEDURE HandleParameter(CONST param: STRING);
    FUNCTION CalcTrueRate(Interval: double): double;
    PROCEDURE FF_Start;
    PROCEDURE FF_Stop;
    FUNCTION ConvertUploadData: boolean;
    PROCEDURE AddUploadDataEntry(CutlistDate: TDateTime; CutlistName: STRING; CutlistID: Integer);
    PROCEDURE UpdateMovieInfoControls;
  PUBLIC
    { Public declarations }
    PROCEDURE ProcessFileList(FileList: TStringList; IsMyOwnCommandLine: boolean);
    PROCEDURE refresh_times;
    PROCEDURE enable_del_buttons(value: boolean);
    FUNCTION CurrentPosition: double;
    PROCEDURE JumpTo(NewPosition: double);
    PROCEDURE JumpToEx(NewPosition: double; NewStop: double);
    PROCEDURE SetStartPosition(Position: double);
    PROCEDURE SetStopPosition(Position: double);

    PROCEDURE ShowFrames(startframe, endframe: Integer);
    PROCEDURE ShowFramesAbs(startframe, endframe: double; numberOfFrames: Integer);

    FUNCTION OpenFile(Filename: STRING): boolean;
    FUNCTION BuildFilterGraph(FileName: STRING; FileType: TMovieType): boolean;
    FUNCTION CloseCutlist: boolean;
    FUNCTION CloseMovieAndCutlist: boolean;
    PROCEDURE CloseMovie;
    FUNCTION GraphPlayPause: boolean;
    FUNCTION GraphPlay: boolean;
    FUNCTION GraphPause: boolean;
    FUNCTION ToggleFullScreen: boolean;
    PROCEDURE ShowMetaData;
    FUNCTION RepairMovie: boolean;
    FUNCTION StartCutting: boolean;
    //    function CreateVDubScript(cutlist: TCutlist; Inputfile, Outputfile: String; var scriptfile: string): boolean;
    FUNCTION CreateMPlayerEDL(cutlist: TCutlist; Inputfile, Outputfile: STRING; VAR scriptfile: STRING): boolean;

    FUNCTION DownloadInfo(settings: TSettings; CONST UseDate, ShowAll: boolean): boolean;
    PROCEDURE LoadCutList;
    //    function search_cutlist: boolean;
    FUNCTION SearchCutlists(AutoOpen: boolean; SearchLocal, SearchWeb: boolean; SearchTypes: TCutlistSearchTypes): boolean;
    FUNCTION SearchCutlistsByFileSize_Local(SearchType: TCutlistSearchType): integer;
    FUNCTION SearchCutlistsByFileSize_XML(SearchType: TCutlistSearchType): integer;
    //    function DownloadCutlist(cutlist_name: string): boolean;
    FUNCTION DownloadCutlistByID(CONST cutlist_id, TargetFileName: STRING): boolean; OVERLOAD;
    FUNCTION UploadCutlist(filename: STRING): boolean;
    FUNCTION DeleteCutlistFromServer(CONST cutlist_id: STRING): boolean;
    FUNCTION AskForUserRating(Cutlist: TCutlist): boolean;
    FUNCTION SendRating(Cutlist: TCutlist): boolean;
  PROTECTED
    PROCEDURE WMDropFiles(VAR message: TWMDropFiles); MESSAGE WM_DROPFILES;
    PROCEDURE WMCopyData(VAR msg: TWMCopyData); MESSAGE WM_COPYDATA;
    FUNCTION DoHttpGet(CONST url: STRING; CONST handleRedirects: boolean; CONST Error_message: STRING; VAR Response: STRING): boolean;
    FUNCTION DoHttpRequest(data: THttpRequest): boolean;
    FUNCTION CheckResponse(CONST Response: STRING; CONST Protocol: integer; CONST Command: TCutlistServerCommand): STRING;
    FUNCTION CheckResponseProto1(CONST Response: STRING; CONST Command: TCutlistServerCommand): STRING;
    PROCEDURE SettingsChanged;
    FUNCTION HandleWorkerException(data: THttpRequest): boolean;
    PROCEDURE InitFramesProperties(CONST AAction: TAction; CONST s: STRING);
    FUNCTION FormatMoviePosition(CONST position: double): STRING; OVERLOAD;
    FUNCTION FormatMoviePosition(CONST frame: longint; CONST duration: double): STRING; OVERLOAD;
    PROCEDURE UpdateCutControls(APreviousPos, ANewPos: double);
  END;

VAR
  FMain                            : TFMain;
  CutList                          : TCutList;
  Settings                         : TSettings;
  pos_to, pos_from                 : double;
  vol_temp                         : integer;
  last_pos                         : double;


  //Batch flags
  exit_after_commandline, TryCutting: boolean;

  //movie params
  MovieInfo                        : TMovieInfo;

  //Interfaces
  BasicVideo                       : IBasicVideo;
  Seeking                          : IMediaSeeking;
  MediaEvent                       : IMediaEvent;
  Framestep                        : IVideoFrameStep;
  VMRWindowlessControl             : IVMRWindowlessControl;
  VMRWindowlessControl9            : IVMRWindowlessControl9;

IMPLEMENTATION

USES madExcept,
  madNVBitmap,
  madNVAssistant,
  Frames,
  CutlistRate_Dialog,
  ResultingTimes,
  CutlistSearchResults,
  PBOnceOnly,
  UfrmCutting,
  UCutApplicationBase,
  UCutApplicationAsfbin,
  UCutApplicationMP4Box,
  UMemoDialog,
  DateTools,
  UAbout,
  ULogging,
  UDSAStorage,
  IdResourceStrings,
  IdURI,
  CAResources,
  TypInfo,
  uFreeLocalizer,
  JvParameterList,
  JvParameterListParameter,
  JvParameterListTools;

{$R *.dfm}
{$WARN SYMBOL_PLATFORM OFF}

CONST
  ServerProtocol                   = 1;

PROCEDURE UpdateStaticSettings; FORWARD;

FUNCTION TFMain.CheckResponse(CONST Response: STRING; CONST Protocol: integer; CONST Command: TCutlistServerCommand): STRING;
BEGIN
  CASE protocol OF
    1:
      Result := CheckResponseProto1(Response, Command);
  ELSE
    Result := Format(CAResources.RsMsgServerCommandErrorProtocol, [Protocol]);
  END;
END;

FUNCTION TFMain.CheckResponseProto1(CONST Response: STRING; CONST Command: TCutlistServerCommand): STRING;
VAR
  ErrorCode                        : integer;
  ResponseFields                   : TStringList;
BEGIN
  ResponseFields := TStringList.Create;
  TRY
    WITH ResponseFields DO BEGIN
      CaseSensitive := false;
      Duplicates := dupAccept;
      Delimiter := #10;
      NameValueSeparator := '=';
      DelimitedText := Response;
      ErrorCode := StrToIntDef(Values['error'], -3);
    END;
    IF ErrorCode = -3 THEN
      Result := CAResources.RsMsgServerCommandErrorResponse
    ELSE IF ErrorCode = -2 THEN
      Result := CAResources.RsMsgServerCommandErrorUnspecified
    ELSE IF ErrorCode = -1 THEN
      Result := Format(CAResources.RsMsgServerCommandErrorMySql, [ResponseFields.Values['mysql_errno']])
    ELSE IF ErrorCode = 0 THEN
      Result := ''
    ELSE BEGIN
      CASE Command OF
        cscDelete: // Delete cutlist from server
          CASE ErrorCode OF
            1: Result := CAResources.RsMsgCutlistDeleteEntryNotRemoved;
            2: Result := CAResources.RsMsgServerCommandErrorArgMissing;
          ELSE
            Result := CAResources.RsMsgCutlistDeleteUnexpected;
          END;
        cscRate: // Rate cutlist on server
          CASE ErrorCode OF
            1: Result := CAResources.RsMsgCutlistRateAlreadyRated;
            2: Result := CAResources.RsMsgServerCommandErrorArgMissing;
          ELSE
            Result := CAResources.RsMsgServerCommandErrorUnspecified
          END;
      ELSE
        Result := Format(CAResources.RsMsgServerCommandErrorCommand, [GetEnumName(TypeInfo(TCutlistServerCommand), Ord(Command))]);
      END;
    END;
  FINALLY
    FreeAndNil(ResponseFields);
  END;
END;

FUNCTION TFMain.FormatMoviePosition(CONST position: double): STRING;
BEGIN
  IF MovieInfo.frame_duration = 0 THEN
    Result := FormatMoviePosition(0, 0)
  ELSE
    Result := FormatMoviePosition(Trunc(position / MovieInfo.frame_duration), position)
END;

FUNCTION TFMain.FormatMoviePosition(CONST frame: longint; CONST duration: double): STRING;
BEGIN
  Result := IntToStr(frame)
    + ' / '
    + MovieInfo.FormatPosition(duration);
END;

PROCEDURE TFMain.UpdateMovieInfoControls;
BEGIN
  IF NOT Assigned(MovieInfo) THEN
    self.lblMovieFPS_nl.Caption := MovieInfo.FormatFrameRate(0, #0)
  ELSE
    self.lblMovieFPS_nl.Caption := MovieInfo.FormatFrameRate;

  IF NOT Assigned(MovieInfo) OR NOT MovieInfo.MovieLoaded THEN BEGIN
    self.lblMovieType_nl.Caption := MovieInfo.GetStringFromMovieType(mtNone);
    self.lblCutApplication_nl.Caption := Format(CAResources.RsCaptionCutApplication, [CAResources.RsNotAvailable]);
  END ELSE BEGIN
    self.lblMovieType_nl.Caption := MovieInfo.MovieTypeString;
    self.lblCutApplication_nl.Caption := Format(CAResources.RsCaptionCutApplication, [Settings.GetCutAppName(MovieInfo.MovieType)]);
  END;
END;

PROCEDURE TFMain.InitFramesProperties(CONST AAction: TAction; CONST s: STRING);
BEGIN
  IF NOT Assigned(AAction) THEN
    Exit;
  AAction.Caption := AnsiReplaceText(AAction.Caption, '$$', s);
  AAction.Hint := AnsiReplaceText(AAction.Hint, '$$', s);
END;

PROCEDURE TFMain.refresh_times;
BEGIN
  self.edtFrom.Text := MovieInfo.FormatPosition(pos_from);
  self.edtTo.Text := MovieInfo.FormatPosition(pos_to);
  IF pos_to >= pos_from THEN BEGIN
    self.edtDuration.Text := MovieInfo.FormatPosition(pos_to - pos_from);
    self.actAddCut.Enabled := true;
  END ELSE BEGIN
    self.edtDuration.Text := '';
    self.actAddCut.Enabled := false;
  END;
END;

PROCEDURE TFMain.FormCreate(Sender: TObject);
VAR
  numFrames                        : STRING;
BEGIN
  {
  procedure TModalForm.CreateParams(var Params: TCreateParams);
    // override;
  begin
    inherited;
    if (Parent <> nil) or (ParentWindow <> 0) then
      Exit;  // must not mess with wndparent if form is embedded

    if Assigned(Owner) and (Owner is TWincontrol) then
      Params.WndParent := TWinControl(Owner).handle
    else if Assigned(Screen.Activeform) then
      Params.WndParent := Screen.Activeform.Handle;
  end;
  }
  AdjustFormConstraints(self);
  IF screen.WorkAreaWidth < self.Constraints.MinWidth THEN BEGIN
    self.Constraints.MinWidth := screen.Width;
    //self.WindowState := wsMaximized;
  END;
  IF screen.WorkAreaHeight < self.Constraints.MinHeight THEN BEGIN
    self.Constraints.MinHeight := screen.Height;
    //self.WindowState := wsMaximized;
  END;

  IF ValidRect(Settings.MainFormBounds) THEN
    self.BoundsRect := Settings.MainFormBounds
  ELSE BEGIN
    self.Top := Screen.WorkAreaTop + Max(0, (Screen.WorkAreaHeight - self.Height) DIV 2);
    self.Left := Screen.WorkAreaLeft + Max(0, (Screen.WorkAreaWidth - self.Width) DIV 2);
  END;

  self.WindowState := Settings.MainFormWindowState;


  numFrames := IntToStr(Settings.FramesCount);
  InitFramesProperties(self.actNextFrames, numFrames);
  InitFramesProperties(self.actCurrentFrames, numFrames);
  InitFramesProperties(self.actPrevFrames, numFrames);
  InitFramesProperties(self.actScanInterval, numFrames);

  ResetForm;

  DragAcceptFiles(self.Handle, true);
  ExitCode := 0;

  UploadDataEntries := TStringList.Create;
  UploadDataEntries := TStringList.Create;
  IF fileexists(UploadData_Path(true)) THEN
    UploadDataEntries.LoadFromFile(UploadData_Path(true));

  IF fileexists(UploadData_Path(false)) THEN BEGIN
    ConvertUploadData;
  END;

  SettingsChanged;

  self.rgCutMode.ItemIndex := settings.DefaultCutMode;

  Cutlist.RefreshCallBack := self.refresh_lvCutlist;
  cutlist.RefreshGUI;

  filtergraph.Volume := 5000;
  tbVolume.PageSize := tbVolume.Frequency;
  tbVolume.LineSize := round(tbVolume.PageSize / 10);
  tbVolume.Position := filtergraph.Volume;

  KeyFrameSampleInfo.Active := false;
  SampleInfo.Active := false;
  SampleInfo.Bitmap := TBitmap.Create;

  cbCutPreview.Checked := Settings.CutPreview;
END;

PROCEDURE TFMain.FormDestroy(Sender: TObject);
BEGIN
  Settings.MainFormBounds := self.BoundsRect;
  Settings.MainFormWindowState := self.WindowState;
  Settings.CutPreview := cbCutPreview.Checked;
  FreeAndNil(SampleInfo.Bitmap);
  FreeAndNIL(UploadDataEntries);
END;

PROCEDURE TFMain.cmdFromStartClick(Sender: TObject);
BEGIN
  pos_from := 0;
  refresh_times;
END;

PROCEDURE TFMain.cmdToEndClick(Sender: TObject);
BEGIN
  pos_to := MovieInfo.current_file_duration;
  refresh_times;
END;

PROCEDURE TFMain.lvCutlistSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
BEGIN
  self.enable_del_buttons(true);
END;

PROCEDURE TFMain.enable_del_buttons(value: boolean);
BEGIN
  self.actDeleteCut.enabled := value;
  self.actEditCut.Enabled := value;
  self.actReplaceCut.Enabled := value;
  self.actShiftCut.Enabled := value;
END;


FUNCTION TFMain.StartCutting: boolean;
VAR
  message_string                   : STRING;
  sourcefile, sourceExtension, targetfile, targetpath: STRING;
  AskForPath                       : boolean;
  saveDlg                          : TSaveDialog;
  CutApplication                   : TCutApplicationBase;
BEGIN
  result := false;
  IF cutlist.Count = 0 THEN BEGIN
    IF NOT batchmode THEN
      ShowMessage(CAResources.RsNoCutsDefined);
    exit;
  END;

  IF settings.CutlistAutoSaveBeforeCutting AND cutlist.HasChanged THEN cutlist.Save(false);

  sourcefile := extractfilename(MovieInfo.current_filename);
  sourceExtension := extractfileext(sourcefile);

  IF settings.UseMovieNameSuggestion AND (trim(cutlist.SuggestedMovieName) <> '') THEN
    targetfile := trim(cutlist.SuggestedMovieName) + SourceExtension
  ELSE
    targetfile := changefileExt(sourcefile, Settings.CutMovieExtension + SourceExtension);

  CASE Settings.SaveCutMovieMode OF
    smWithSource: BEGIN //with source
        targetpath := extractFilePath(MovieInfo.current_filename);
      END;
    smGivenDir: BEGIN //in given Dir
        targetpath := IncludeTrailingPathDelimiter(Settings.CutMovieSaveDir);
      END;
  ELSE BEGIN //with source
      targetpath := extractFilePath(MovieInfo.current_filename);
    END;
  END;

  targetfile := CleanFileName(targetfile);
  {// The following is possible only with shell32.dll V 5.0 or higer (WInXp SP2 or higher)
  case PathCleanupSpec(PWideChar(targetPath), PWideChar(targetfile)) of
    PCS_TRUNCATED: begin
        if not batchmode then showmessage('File name for cut movie is too long and will be truncated.');
      end;
    PCS_FATAL: begin
        if not batchmode then showmessage('File name for cut movie is not valid. Abort.');
        exit;
      end;
  end;
  }
  IF NOT ForceDirectories(targetpath) THEN BEGIN
    IF NOT batchmode THEN
      ShowMessageFmt(CAResources.RsCouldNotCreateTargetPath, [targetpath]);
    exit;
  END;

  MovieInfo.target_filename := targetpath + targetfile;

  //Display Save Dialog?
  AskForPath := Settings.MovieNameAlwaysConfirm;

  IF fileexists(MovieInfo.target_FileName) AND (NOT AskForPath) AND (NOT batchmode) THEN BEGIN
    message_string := Format(CAResources.RsTargetMovieAlreadyExists, [MovieInfo.target_filename]);
    IF Application.MessageBox(PChar(message_string), NIL, MB_YESNO + MB_DEFBUTTON2 + MB_ICONWARNING) <> IDYES THEN AskForPath := true;
  END;
  IF AskForPath AND (NOT batchmode) THEN BEGIN
    saveDlg := TSaveDialog.Create(self);
    saveDlg.Filter := '*' + SourceExtension + '|*' + SourceExtension;
    saveDlg.Title := CAResources.RsSaveCutMovieAs;
    saveDlg.InitialDir := targetpath;
    saveDlg.filename := targetfile;
    saveDlg.options := saveDlg.Options + [ofOverwritePrompt, ofPathMustExist];
    IF saveDlg.Execute THEN BEGIN
      MovieInfo.target_filename := trim(saveDlg.FileName);
      IF NOT ansiSameText(extractFileExt(MovieInfo.target_filename), SourceExtension) THEN BEGIN
        MovieInfo.target_filename := MovieInfo.target_filename + sourceExtension;
      END;
    END ELSE
      exit;
  END;

  IF fileexists(MovieInfo.target_FileName) THEN BEGIN
    IF NOT deletefile(MovieInfo.target_filename) THEN BEGIN
      IF NOT batchmode THEN
        ShowMessageFmt(CAResources.RsCouldNotDeleteFile, [MovieInfo.target_filename]);
      exit;
    END;
  END;

  CutApplication := Settings.GetCutApplicationByMovieType(MovieInfo.MovieType);
  IF assigned(CutApplication) THEN BEGIN
    CutApplication.CutAppSettings := Settings.GetCutAppSettingsByMovieType(MovieInfo.MovieType);
    frmCutting.CutApplication := CutApplication;
    result := CutApplication.PrepareCutting(MovieInfo.current_filename, MovieInfo.target_filename, cutlist);
    IF result THEN BEGIN
      CASE frmCutting.ExecuteCutApp OF
        mrOK: result := true;
      ELSE result := false;
      END;
    END;
  END;
END;

PROCEDURE TFMain.cbMuteClick(Sender: TObject);
BEGIN
  IF CBMUte.Checked THEN BEGIN
    FilterGraph.Volume := 0;
  END ELSE BEGIN
    FilterGraph.Volume := tbVolume.Position;
  END;

END;

PROCEDURE TFMain.tbVolumeChange(Sender: TObject);
BEGIN
  IF NOT CBMute.Checked THEN
    FilterGraph.Volume := tbVolume.Position;
END;

PROCEDURE TFMain.tbFinePosMOuseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
VAR
  timeToSkip                       : double;
BEGIN
  //if Button = mbMiddle then Exit;
  timeToSkip := tbFinePos.Position * MovieInfo.frame_duration;
  IF Button = mbRight THEN // Invert direction on right mouse button ...
    timeToSkip := timeToSkip * -1;

  IF tbFinePos.Tag = tbFinePos.Position THEN
    JumpTo(currentPosition + timeToSkip);
  tbFinePos.Tag := tbFinePos.Position;
END;

PROCEDURE TFMain.refresh_lvCutlist(cutlist: TCutlist);
VAR
  icut                             : integer;
  cut                              : tcut;
  cut_view                         : tlistitem;
  i_column                         : integer;
  total_cutoff, resulting_duration : Double;
BEGIN
  self.lvCutlist.Clear;
  self.actSendRating.Enabled := cutlist.IDOnServer <> '';

  IF cutlist.Count = 0 THEN BEGIN
    self.actStartCutting.Enabled := false;
    self.actCalculateResultingTimes.Enabled := false;
    self.actSaveCutlistAs.Enabled := false;
    self.actSaveCutlist.Enabled := false;
    self.actCutlistUpload.Enabled := false;
    self.actNextCut.Enabled := false;
    self.actPrevCut.Enabled := false;
    self.enable_del_buttons(false);
  END ELSE BEGIN
    self.actStartCutting.Enabled := true;
    self.actCalculateResultingTimes.Enabled := true;
    self.actSaveCutlistAs.Enabled := true;
    self.actSaveCutlist.Enabled := true;
    self.actCutlistUpload.Enabled := true;
    self.actNextCut.Enabled := true;
    self.actPrevCut.Enabled := true;
    FOR icut := 0 TO cutlist.Count - 1 DO BEGIN
      cut := cutlist[icut];
      cut_view := self.lvCutlist.Items.Add;
      cut_view.Caption := inttostr(icut); //inttostr(cut.index);
      cut_view.SubItems.Add(MovieInfo.FormatPosition(cut.pos_from));
      cut_view.SubItems.Add(MovieInfo.FormatPosition(cut.pos_to));
      cut_view.SubItems.Add(MovieInfo.FormatPosition(cut.pos_to - cut.pos_from + MovieInfo.frame_duration));
    END;

    //Auto-Resize columns
    FOR i_column := 0 TO self.lvCutlist.Columns.Count - 1 DO BEGIN
      lvCutlist.Columns[i_column].Width := -2;
    END;

    IF lvCutlist.ItemIndex = -1 THEN
      self.enable_del_buttons(false)
    ELSE
      self.enable_del_buttons(true);
  END;

  IF cutlist.Mode = clmCutOut THEN BEGIN
    total_cutoff := cutlist.TotalDurationOfCuts;
    resulting_duration := MovieInfo.current_file_duration - total_cutoff;
  END ELSE BEGIN
    resulting_duration := cutlist.TotalDurationOfCuts;
    total_cutoff := MovieInfo.current_file_duration - resulting_duration;
  END;
  self.lblTotalCutoff_nl.Caption := Format(CAResources.RsCaptionTotalCutoff, [secondsToTimeString(total_cutoff)]);
  self.lblResultingDuration_nl.Caption := Format(CAResources.RsCaptionResultingDuration, [secondsToTimeString(resulting_duration)]);


  //Cuts in Trackbar are taken from global var "cutlist"!
  self.TBFilePos.Perform(CM_RECREATEWND, 0, 0); //Show Cuts in Trackbar

  CASE cutlist.Mode OF
    clmCutOut: self.rgCutMode.ItemIndex := 0;
    clmTrim: self.rgCutMode.ItemIndex := 1;
  END;

  IF (cutlist.RatingByAuthorPresent AND (cutlist.RatingByAuthor <= 2))
    OR cutlist.EPGError
    OR cutlist.MissingBeginning
    OR cutlist.MissingEnding
    OR cutlist.MissingVideo
    OR cutlist.MissingAudio
    OR cutlist.OtherError
    THEN BEGIN
    //self.ACutlistInfo.ImageIndex := 18;
    self.ICutlistWarning.Visible := true;
  END ELSE BEGIN
    //self.ACutlistInfo.ImageIndex := -1;
    self.ICutlistWarning.Visible := false;
  END;

  IF cutlist.Author <> '' THEN BEGIN
    self.lblCutlistAuthor_nl.Caption := cutlist.Author;
    self.pnlAuthor.Visible := true;
  END ELSE BEGIN
    self.pnlAuthor.Visible := false;
  END; ;
END;


FUNCTION TFMain.OpenFile(Filename: STRING): boolean;
//false if file not found
VAR
  SourceFilter, AviDecompressorFilter: IBaseFilter;
  SourceAdded                      : boolean;
  AvailableFilters                 : TSysDevEnum;
  PinList                          : TPinList;
  IPin                             : Integer;
  TempCursor                       : TCursor;
BEGIN
  result := false;
  IF fileexists(filename) THEN BEGIN
    IF MovieInfo.MovieLoaded THEN BEGIN
      IF NOT self.CloseMovieAndCutlist THEN exit;
    END;

    TempCursor := screen.Cursor;
    TRY
      screen.Cursor := crHourGlass;
      MovieInfo.target_filename := '';
      IF NOT MovieInfo.InitMovie(FileName) THEN
        exit;

      IF MovieInfo.MovieType IN [mtWMV] THEN BEGIN
        self.actRepairMovie.Enabled := true;
      END ELSE BEGIN
        self.actRepairMovie.Enabled := false;
      END;

      {if not batchmode then }BEGIN
        SourceAdded := false;

        IF MovieInfo.MovieType IN [mtWMV] THEN BEGIN
          SampleGrabber.FilterGraph := NIL;
        END ELSE IF AnsiEndsText('.avs', MovieInfo.current_filename) THEN BEGIN
          SampleGrabber.FilterGraph := NIL;
        END ELSE BEGIN
          SampleGrabber.FilterGraph := FilterGraph;
        END;
        IF Settings.Additional['ActivateKeyFrameGrabber'] = '1' THEN
          KeyFrameGrabber.FilterGraph := SampleGrabber.FilterGraph;

        FilterGraph.Active := true;

        AvailableFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); //DirectShow Filters
        TRY
          //If MP4 then Try to Add AviDecompressor
          IF (MovieInfo.MovieType IN [mtMP4]) THEN BEGIN
            AviDecompressorFilter := AvailableFilters.GetBaseFilter(CLSID_AVIDec); //Avi Decompressor
            IF assigned(AviDecompressorFilter) THEN BEGIN
              CheckDSError((FilterGraph AS IGraphBuilder).AddFilter(AviDecompressorFilter, 'Avi Decompressor'));
            END;
          END;

          IF NOT (IsEqualGUID(Settings.GetPreferredSourceFilterByMovieType(MovieInfo.MovieType), GUID_NULL)) THEN BEGIN
            SourceFilter := AvailableFilters.GetBaseFilter(Settings.GetPreferredSourceFilterByMovieType(MovieInfo.MovieType));
            IF assigned(SourceFilter) THEN BEGIN
              CheckDSError((SourceFilter AS IFileSourceFilter).Load(StringToOleStr(FileName), NIL));
              CheckDSError((FilterGraph AS IGraphBuilder).AddFilter(SourceFilter, StringToOleStr('Source Filter [' + extractFileName(FileName) + ']')));
              SourceAdded := true;
            END;
          END;
        FINALLY
          FreeAndNIL(AvailableFilters);
        END;

        IF NOT sourceAdded THEN BEGIN
          CheckDSError(FilterGraph.RenderFile(FileName));
        END ELSE BEGIN
          PinLIst := TPinLIst.Create(SourceFilter);
          TRY
            FOR iPin := 0 TO PinList.Count - 1 DO BEGIN
              CheckDSError((FilterGraph AS IGraphBuilder).Render(PinList.Items[iPin]));
            END;
          FINALLY
            FreeAndNIL(PinList);
          END;
        END;

        initVideo;

        IF SampleGrabber.FilterGraph = NIL THEN BEGIN
          InsertSampleGrabber;
          IF KeyFrameGrabber.FilterGraph = NIL THEN
            IF Settings.Additional['ActivateKeyFrameGrabber'] = '1' THEN
              InsertKeyFrameGrabber;
          IF NOT filtergraph.Active THEN BEGIN
            IF NOT batchmode THEN
              ShowMessage(CAResources.RsCouldNotInsertSampleGrabber);
            MovieInfo.current_filename := '';
            MovieInfo.MovieLoaded := false;
            MovieInfo.current_filesize := -1;
            UpdateMovieInfoControls;
            exit;
          END;
        END;
        FilterGraph.Volume := self.tbVolume.Position;

        GraphPause;

        self.pnlVideoWindowResize(self);

      END;

      self.Caption := Application_Friendly_Name + ' ' + extractfilename(MovieInfo.current_filename);
      application.Title := extractfilename(MovieInfo.current_filename);

      MovieInfo.MovieLoaded := true;
      result := true;
    EXCEPT
      ON E: Exception DO
        IF NOT batchmode THEN
          ShowMessageFmt(CAResources.RsErrorOpenMovie, [E.Message]);
    END;
    screen.Cursor := TempCursor;
  END ELSE BEGIN
    IF NOT batchmode THEN
      ShowMessageFmt(CAResources.RsErrorFileNotFound, [filename]);
    MovieInfo.current_filename := '';
    MovieInfo.MovieLoaded := false;
  END;
  self.UpdateMovieInfoControls;
END;

PROCEDURE TFMain.LoadCutList;
VAR
  filename, cutlist_path, cutlist_filename: STRING;
  CutlistMode_old                  : TCutlistMode;
  newCutlist                       : TCutlist;
BEGIN
  IF MovieInfo.current_filename = '' THEN BEGIN
    IF NOT batchmode THEN
      showmessage(CAResources.RsCannotLoadCutlist);
    exit;
  END;

  //Use same settings as for saving as default
  cutlist_filename := ChangeFileExt(extractfilename(MovieInfo.current_filename), cutlist_Extension);
  CASE Settings.SaveCutlistMode OF
    smWithSource: BEGIN //with source
        cutlist_path := extractFilePath(MovieInfo.current_filename);
      END;
    smGivenDir: BEGIN //in given Dir
        cutlist_path := IncludeTrailingPathDelimiter(Settings.CutlistSaveDir);
      END;
  ELSE BEGIN //with source
      cutlist_path := extractFilePath(MovieInfo.current_filename);
    END;
  END;

  odCutlist.InitialDir := cutlist_path;
  odCutlist.FileName := cutlist_filename;
  odCutlist.Options := odCutlist.Options + [ofNoChangeDir];
  IF self.odCutlist.Execute THEN BEGIN
    filename := self.odCutlist.FileName;
    CutlistMode_old := cutlist.Mode;
    cutlist.LoadFromFile(filename);
    IF CutlistMode_old <> cutlist.Mode THEN BEGIN
      newCutlist := cutlist.convert;
      newCutlist.RefreshCallBack := cutlist.RefreshCallBack;
      FreeAndNIL(cutlist);
      cutlist := newCutlist;
      cutlist.RefreshGUI;
    END;
  END;
END;

PROCEDURE TFMain.InitVideo;
VAR
  _ARw, _ARh                       : integer;
  frame_duration                   : double;
  _dur_time, _dur_frames           : int64;
  APin                             : IPin;
  MediaType                        : TAMMediaType;
  pVIH                             : ^VIDEOINFOHEADER;
  pVIH2                            : ^VIDEOINFOHEADER2;
  filter                           : IBaseFilter;
  BasicVIdeo2                      : IBasicVideo2;
  arx, ary                         : integer;
BEGIN
  IF FilterGraph.Active THEN BEGIN
    IF succeeded(filtergraph.QueryInterface(IMediaSeeking, Seeking)) THEN BEGIN
      {if succeeded(seeking.IsFormatSupported(TIME_FORMAT_FRAME)) then begin
        seeking.SetTimeFormat(TIME_FORMAT_FRAME);
      end; }//does not work ???
      seeking.GetTimeFormat(MovieInfo.TimeFormat);
      seeking.GetDuration(_dur_time);
      MovieInfo.current_file_duration := _dur_time;
      IF isEqualGUID(MovieInfo.TimeFormat, TIME_FORMAT_MEDIA_TIME) THEN
        MovieInfo.current_file_duration := MovieInfo.current_file_duration / 10000000;
    END ELSE seeking := NIL;

    IF succeeded(filtergraph.QueryInterface(IMediaEvent, MediaEvent)) THEN BEGIN
    END ELSE MediaEvent := NIL;

    //detect ratio

    MovieInfo.nat_w := 0;
    MovieInfo.nat_h := 0;
    MovieInfo.ratio := 4 / 3;

    IF succeeded(filtergraph.QueryInterface(IBasicVideo, BasicVideo)) THEN BEGIN
      BasicVideo.get_VideoWidth(MovieInfo.nat_w);
      BasicVideo.get_VideoHeight(MovieInfo.nat_h);
      IF (MovieInfo.nat_w > 0) AND (MovieInfo.nat_h > 0) THEN
        MovieInfo.ratio := MovieInfo.nat_w / MovieInfo.nat_h;
      IF MovieInfo.frame_duration = 0 THEN
        IF Succeeded(BasicVideo.get_AvgTimePerFrame(frame_duration)) THEN BEGIN
          MovieInfo.frame_duration := frame_duration;
          MovieInfo.frame_duration_source := 'B';
        END;
    END;

    IF succeeded(filtergraph.QueryInterface(IBasicVideo2, BasicVideo2)) THEN BEGIN
      BasicVideo2.GetPreferredAspectRatio(arx, ary);
      IF (arx > 0) AND (ary > 0) THEN
        MovieInfo.ratio := arx / ary;
    END;

    IF succeeded(videoWindow.QueryInterface(IVMRWindowlessControl9, VMRWindowlessControl9)) THEN BEGIN
      VMRWindowlessControl9.GetNativeVideoSize(MovieInfo.nat_w, MovieInfo.nat_h, _ARw, _ARh);
      IF (MovieInfo.nat_w > 0) AND (MovieInfo.nat_h > 0) THEN
        MovieInfo.ratio := MovieInfo.nat_W / MovieInfo.nat_h;
    END ELSE BEGIN
      IF succeeded(videoWindow.QueryInterface(IVMRWindowlessControl, VMRWindowlessControl)) THEN BEGIN
        VMRWindowlessControl.GetNativeVideoSize(MovieInfo.nat_w, MovieInfo.nat_h, _ARw, _ARh);
        IF (MovieInfo.nat_w > 0) AND (MovieInfo.nat_h > 0) THEN
          MovieInfo.ratio := MovieInfo.nat_W / MovieInfo.nat_h;
      END ELSE BEGIN
        VMRWindowlessControl := NIL;
      END;
    END;

    IF MovieInfo.frame_duration = 0 THEN BEGIN
      IF succeeded(videowindow.QueryInterface(IBaseFilter, filter)) THEN BEGIN
        APin := getInPin(filter, 0);
        APin.ConnectionMediaType(MediaType);
        IF isEqualGUID(MediaType.formattype, FORMAT_VideoInfo2) THEN BEGIN
          IF Mediatype.cbFormat >= sizeof(VIDEOINFOHEADER2) THEN BEGIN
            pVIH2 := mediatype.pbFormat;
            MovieInfo.frame_duration := pVIH2^.AvgTimePerFrame / 10000000;
            MovieInfo.frame_duration_source := 'V';
            //dwFourCC := pVIH2^.bmiHeader.biCompression;
          END;
        END ELSE BEGIN
          IF isEqualGUID(MediaType.formattype, FORMAT_VideoInfo) THEN BEGIN
            IF Mediatype.cbFormat >= sizeof(VIDEOINFOHEADER) THEN BEGIN
              pVIH := mediatype.pbFormat;
              MovieInfo.frame_duration := pVIH^.AvgTimePerFrame / 10000000;
              MovieInfo.frame_duration_source := 'v';
              //dwFourCC := pVIH^.bmiHeader.biCompression;
            END;
          END;
        END;
        // samplegrabber.SetBMPCompatible(@MediaType, 32);
        freeMediaType(@MediaType);
      END
      ELSE IF NOT batchmode THEN
        showmessage('Could not retrieve Renderer Filter.');
    END;

    IF MovieInfo.frame_duration = 0 THEN BEGIN
      //try calculating
      IF succeeded(seeking.IsFormatSupported(TIME_FORMAT_MEDIA_TIME))
        AND succeeded(seeking.IsFormatSupported(TIME_FORMAT_FRAME)) THEN BEGIN
        seeking.SetTimeFormat(TIME_FORMAT_MEDIA_TIME);
        seeking.GetDuration(_dur_time);
        seeking.SetTimeFormat(TIME_FORMAT_FRAME);
        seeking.GetDuration(_dur_frames);
        IF (_dur_frames > 0) AND (_dur_time <> _dur_frames) THEN BEGIN
          MovieInfo.frame_duration_source := 'D';
          MovieInfo.frame_duration := (_dur_time / 10000000) / _dur_frames
        END;
        seeking.SetTimeFormat(MovieInfo.TimeFormat)
      END;
    END;

    //default if nothing worked so far
    IF MovieInfo.frame_duration = 0 THEN BEGIN
      MovieInfo.frame_duration_source := 'F';
      MovieInfo.frame_duration := 0.04;
    END;

    self.actOpenCutlist.Enabled := true;
    self.actSearchCutlistByFileSize.Enabled := true;
    self.actSearchCutlistLocal.Enabled := true;

    self.lblDuration_nl.Caption := FormatMoviePosition(MovieInfo.FrameCount, MovieInfo.current_file_duration);

    MovieInfo.CanStepForward := false;
    IF succeeded(FilterGraph.QueryInterface(IVideoFrameStep, FrameStep)) THEN BEGIN
      IF FrameStep.CanStep(0, NIL) = S_OK THEN
        MovieInfo.CanStepForward := true;
    END ELSE FrameStep := NIL;

    self.EnableMovieControls(true);
  END;
END;

PROCEDURE TFMain.JumpTo(NewPosition: double);
BEGIN
  IF NewPosition < 0 THEN
    NewPosition := 0;
  JumpToEx(NewPosition, -1);
END;

PROCEDURE TFMain.JumpToEx(NewPosition: double; NewStop: double);
VAR
  _pos, _stop                      : int64;
  event                            : Integer;
BEGIN
  IF NOT MovieInfo.MovieLoaded THEN
    exit;
  IF NewPosition > MovieInfo.current_file_duration THEN
    NewPosition := MovieInfo.current_file_duration;

  IF isEqualGUID(MovieInfo.TimeFormat, TIME_FORMAT_MEDIA_TIME) THEN BEGIN
    _pos := round(NewPosition * 10000000);
    _stop := round(NewStop * 10000000);
  END ELSE BEGIN
    _pos := round(NewPosition);
    _stop := round(NewStop);
  END;
  seeking.SetPositions(
    _pos, IfThen(_pos >= 0, AM_SEEKING_AbsolutePositioning, AM_SEEKING_NoPositioning),
    _stop, IfThen(_stop >= 0, AM_SEEKING_AbsolutePositioning, AM_SEEKING_NoPositioning));
  //filtergraph.State
  MediaEvent.WaitForCompletion(500, event);
  TBFilePos.TriggerTimer;
END;

FUNCTION TFMain.CurrentPosition: double;
VAR
  _pos                             : int64;
BEGIN
  {  result := MovieInfo.current_position_seconds;}
  result := 0;
  IF NOT assigned(seeking) THEN
    exit;
  IF succeeded(seeking.GetCurrentPosition(_pos)) THEN BEGIN
    IF isEqualGUID(MovieInfo.TimeFormat, TIME_FORMAT_MEDIA_TIME) THEN
      result := _pos / 10000000
    ELSE
      result := _pos;
  END;
END;

PROCEDURE TFMain.tbFilePosTimer(sender: TObject; CurrentPos,
  StopPos: Cardinal);
VAR
  TrueRate                         : double;
BEGIN
  TrueRate := CalcTrueRate(self.TBFilePos.TimerInterval / 1000);
  IF TrueRate > 0 THEN
    self.lblTrueRate_nl.Caption := '[' + floattostrF(TrueRate, ffFixed, 15, 3) + 'x]'
  ELSE
    self.lblTrueRate_nl.Caption := '[ ? x]';
  self.lblPos_nl.Caption := FormatMoviePosition(currentPosition);
END;

PROCEDURE TFMain.tbFilePosChange(Sender: TObject);
BEGIN
  IF self.TBFilePos.IsMouseDown THEN BEGIN
    self.lblPos_nl.Caption := FormatMoviePosition(self.TBFilePos.position);
  END;
END;

PROCEDURE TFMain.FilterGraphGraphStepComplete(Sender: TObject);
BEGIN
  self.lblPos_nl.Caption := FormatMoviePosition(currentPosition);
  self.StepComplete := true;
END;

PROCEDURE TFMain.tbFilePosPositionChangedByMouse(Sender: TObject);
VAR
  event                            : integer;
BEGIN
  MEdiaEvent.WaitForCompletion(500, event);
  self.lblPos_nl.Caption := FormatMoviePosition(currentPosition);
END;

PROCEDURE TFMain.tbFinePosChange(Sender: TObject);
BEGIN
  self.lblFinePos_nl.Caption := inttostr(self.tbFinePos.Position);
  self.tbFilePos.PageSize := self.tbFinePos.Position;
END;

PROCEDURE TFMain.FormClose(Sender: TObject; VAR Action: TCloseAction);
BEGIN
  self.CloseMovie;

  DragAcceptFiles(self.Handle, false);
END;

PROCEDURE TFMain.SetStartPosition(Position: double);
BEGIN
  pos_from := Position;
  refresh_times;
END;

PROCEDURE TFMain.SetStopPosition(Position: double);
BEGIN
  pos_to := Position;
  refresh_times;
END;

FUNCTION GetFileSourceFilter(FilterGraph: TFilterGraph): IBaseFilter;
VAR
  FilterList                       : TFilterList;
  BaseFilter                       : IBaseFilter;
  idx                              : integer;
BEGIN
  Result := NIL;
  FilterList := TFilterList.Create;
  TRY
    FilterList.Assign(FilterGraph AS IFilterGraph);
    FOR idx := FilterList.Count - 1 DOWNTO 0 DO BEGIN
      BaseFilter := FilterList.Items[idx];
      IF Supports(BaseFilter, IFileSourceFilter) THEN BEGIN
        Result := BaseFilter;
        Break;
      END;
    END;
  FINALLY
    FreeAndNil(FilterList);
  END;
END;

PROCEDURE TFMain.InsertKeyFrameGrabber;
VAR
  KFInPin, KFOutPin, FileSourceOutPin, FileSourceConnectedPin: IPin;
  FileSourceFilter                 : IBaseFilter;
  GraphBuilder                     : IGraphBuilder;
  pins                             : IEnumPins;
  mt                               : _AMMediaType;
  pinDir                           : _PinDirection;
  pinInfo                          : _pinInfo;
BEGIN

  IF NOT FilterGraph.Active THEN exit;

  GraphBuilder := FilterGraph AS IGraphBuilder;
  TRY
    KeyFrameGrabber.FilterGraph := FilterGraph;
    // Insert keyframe samplegrabber directly before video decompressor.
    IF TeeFilter.FilterGraph <> NIL THEN BEGIN
      GetPin((TeeFilter AS IBaseFilter), PINDIR_INPUT, 0, FileSourceOutPin);
      FileSourceOutPin.ConnectedTo(FileSourceConnectedPin);
      FileSourceConnectedPin.QueryPinInfo(pinInfo);
      GetPin(pinInfo.pFilter, PINDIR_INPUT, 0, FileSourceConnectedPin);
      FileSourceConnectedPin.ConnectedTo(FileSourceOutPin);
    END ELSE BEGIN
      // Insert keyframe samplegrabber directly after file source.
      FileSourceFilter := GetFileSourceFilter(FilterGraph);
      IF Succeeded(FileSourceFilter.EnumPins(pins)) THEN BEGIN
        REPEAT
          IF NOT Succeeded(pins.Next(1, FileSourceOutPin, NIL)) THEN BEGIN
            FileSourceOutPin := NIL;
            Break;
          END ELSE IF NOT Succeeded(FileSourceOutPin.QueryDirection(pinDir)) THEN BEGIN
            FileSourceOutPin := NIL;
          END ELSE IF pinDir <> PINDIR_OUTPUT THEN BEGIN
            FileSourceOutPin := NIL;
          END ELSE IF NOT Succeeded(FileSourceOutPin.ConnectionMediaType(mt)) THEN BEGIN
            FileSourceOutPin := NIL;
          END ELSE IF NOT IsEqualGUID(mt.majortype, MEDIATYPE_Video) THEN BEGIN
            FileSourceOutPin := NIL;
          END;
        UNTIL (FileSourceOutPin <> NIL)
      END;
      //OleCheck(GetPin(FileSourceFilter, PINDIR_OUTPUT, 1, FileSourceOutPin));
      OleCheck(FileSourceOutPin.ConnectedTo(FileSourceConnectedPin));
    END;
    OleCheck(GetPin((KeyFrameGrabber AS IBaseFilter), PINDIR_INPUT, 0, KFInpin));
    OleCheck(GetPin((KeyFrameGrabber AS IBaseFilter), PINDIR_OUTPUT, 0, KFOutpin));
    OleCheck(GraphBuilder.Disconnect(FileSourceOutPin));
    OleCheck(GraphBuilder.Disconnect(FileSourceConnectedPin));
    OleCheck(GraphBuilder.Connect(FileSourceOutPin, KFInpin));
    OleCheck(GraphBuilder.Connect(KFoutpin, FileSourceConnectedPin));
  EXCEPT
    filtergraph.ClearGraph;
    filtergraph.active := false;
    RAISE;
  END;
END;

PROCEDURE TFMain.InsertSampleGrabber;
VAR
  Rpin, Spin, TInPin, TOutPin1, TOutPin2, NRInPin, SGInPin, SGOutPin: IPin;
  GraphBuilder                     : IGraphBuilder;
BEGIN
  IF NOT FilterGraph.Active THEN exit;

  GraphBuilder := FilterGraph AS IGraphBuilder;
  TRY
    TeeFilter.FilterGraph := Filtergraph;
    SampleGrabber.FilterGraph := filtergraph;
    NullRenderer.FilterGraph := filtergraph;

    //Disconnect Video Window
    OleCheck(GetPin((VideoWindow AS IBaseFilter), PINDIR_INPUT, 0, Rpin));
    OleCheck(Rpin.ConnectedTo(Spin));
    OleCheck(GraphBuilder.Disconnect(Rpin));
    OleCheck(GraphBuilder.Disconnect(Spin));

    //Get Pins
    OleCheck(GetPin((SampleGrabber AS IBaseFilter), PINDIR_INPUT, 0, SGInpin));
    OleCheck(GetPin((SampleGrabber AS IBaseFilter), PINDIR_OUTPUT, 0, SGOutpin));
    OleCheck(GetPin((NullRenderer AS IBaseFilter), PINDIR_INPUT, 0, NRInpin));
    OleCheck(GetPin((TeeFilter AS IBaseFilter), PINDIR_INPUT, 0, TInpin));
    OleCheck(GetPin((TeeFilter AS IBaseFilter), PINDIR_OUTPUT, 0, TOutpin1));

    //Establish Connections
    OleCheck(GraphBuilder.Connect(Spin, Tinpin)); // Decomp. to Tee
    OleCheck(GraphBuilder.Connect(Toutpin1, Rpin)); //Tee to VideoRenderer
    OleCheck(GetPin((TeeFilter AS IBaseFilter), PINDIR_OUTPUT, 1, TOutpin2)); //GEt new OutputPin of Tee
    OleCheck(GraphBuilder.Connect(Toutpin2, SGInpin)); //Tee to SampleGrabber
    OleCheck(GraphBuilder.Connect(SGoutpin, NRInpin)); //SampleGrabber to Null
  EXCEPT
    filtergraph.ClearGraph;
    filtergraph.active := false;
    RAISE;
  END;
END;

FUNCTION TFMain.WaitForStep(TimeOut: Integer; CONST WaitForSampleInfo: Boolean): boolean;
VAR
  interval                         : integer;
  startTick, nowTick, lastTick     : Cardinal;
  FUNCTION SampleInfoReady(CONST SampleInfo: RMediaSample): Boolean;
  BEGIN
    Result := NOT WaitForSampleInfo
      OR NOT SampleInfo.Active
      OR (SampleInfo.SampleTime >= 0);
  END;
  FUNCTION AllStepComplete: Boolean;
  BEGIN
    Result := self.StepComplete
      AND (NOT Assigned(SampleGrabber.FilterGraph) OR SampleInfoReady(SampleInfo))
      AND (NOT Assigned(KeyFrameGrabber.FilterGraph) OR SampleInfoReady(KeyFrameSampleInfo));
  END;
BEGIN
  lastTick := GetTickCount;
  startTick := lastTick;

  IF Settings.AutoMuteOnSeek THEN
    interval := 10
  ELSE
    interval := Max(10, Trunc(MovieInfo.frame_duration * 1000.0) DIV 2);

  WHILE NOT AllStepComplete DO BEGIN
    sleep(interval);
    nowTick := GetTickCount;
    IF AllStepComplete OR (Abs(startTick - nowTick) > TimeOut) THEN
      break;
    Application.ProcessMessages;
  END;
  result := AllStepComplete;
END;

PROCEDURE TFMain.pnlVideoWindowResize(Sender: TObject);
VAR
  movie_ar, my_ar                  : double;
BEGIN
  movie_ar := MovieInfo.ratio;
  my_ar := self.pnlVideoWindow.Width / self.pnlVideoWindow.Height;
  IF my_ar > movie_ar THEN BEGIN
    self.VideoWindow.Height := self.pnlVideoWindow.Height;
    self.VideoWindow.Width := round(self.videowindow.Height * movie_ar);
  END ELSE BEGIN
    self.VideoWindow.Width := self.pnlVideoWindow.Width;
    self.VideoWindow.Height := round(self.VideoWindow.Width / movie_ar);
  END;
END;

PROCEDURE TFMain.ShowFrames(startframe, endframe: Integer);
//startframe, endframe relative to current frame
VAR
  iImage, count                    : integer;
  pos, temp_pos, start_pos         : double;
  Target                           : TCutFrame;
BEGIN
  count := FFrames.Count;
  IF endframe < startframe THEN exit;
  WHILE endframe - startframe + 1 > count DO BEGIN
    IF - startframe > endframe THEN
      startframe := startframe + 1
    ELSE
      endframe := endframe - 1;
  END;

  pos := currentPosition;
  temp_pos := IntExt(pos, MovieInfo.frame_duration) + (startframe - 1) * MovieInfo.frame_duration;
  IF (temp_pos > MovieInfo.current_file_duration) THEN
    temp_pos := MovieInfo.current_file_duration;
  IF temp_pos < 0 THEN
    temp_pos := 0;
  start_pos := IntExt(temp_pos + MovieInfo.frame_duration, MovieInfo.frame_duration);

  FFrames.Show;

  JumpTo(temp_pos);
  // Mute sound ?
  IF Settings.AutoMuteOnSeek AND NOT CBMute.Checked THEN
    FilterGraph.Volume := 0;
  FFrames.CanClose := false;
  TRY
    iImage := -1;
    WHILE iImage < (endframe - startframe) DO BEGIN
      Inc(iImage);
      temp_pos := currentPosition;
      Target := FFrames.Frame[iImage];
      Target.DisableUpdate;
      TRY
        Target.ResetFrame;
        IF (temp_pos >= 0) AND (temp_pos <= MovieInfo.current_file_duration) THEN BEGIN
          self.StepComplete := false;
          SampleInfo.Active := Assigned(SampleGrabber.FilterGraph);
          KeyFrameSampleInfo.Active := Assigned(KeyFrameGrabber.FilterGraph);
          TRY
            Target.position := start_pos + iImage * MovieInfo.frame_duration;
            SampleInfo.SampleTime := -1;
            KeyFrameSampleInfo.SampleTime := -1;

            IF Assigned(Framestep) THEN BEGIN
              IF NOT Succeeded(FrameStep.Step(1, NIL)) THEN
                continue;
              IF NOT WaitForStep(1000, True) THEN
                continue;
              temp_pos := currentPosition;
              IF Abs(Target.position - temp_pos) >= MovieInfo.frame_duration THEN BEGIN
                // filtergraph is not at desired position after frame step
                // => fix position and start over
                JumpTo(Target.position - MovieInfo.frame_duration / 2);
                Dec(iImage);
                Continue;
              END;
            END ELSE BEGIN
              temp_pos := temp_pos + MovieInfo.frame_duration;
              JumpTo(temp_pos);
              WaitForFiltergraph;
            END;
            Target.AssignSampleInfo(SampleInfo, KeyFrameSampleInfo);
          FINALLY
            SampleInfo.Active := false;
            KeyFrameSampleInfo.Active := false;
          END;
        END;
      FINALLY
        Target.EnableUpdate;
      END;
    END;
  FINALLY
    FFrames.CanClose := true;
    // Restore sound
    IF Settings.AutoMuteOnSeek AND NOT CBMute.Checked THEN
      FilterGraph.Volume := tbVolume.Position;
    JumpTo(pos);
  END;
END;

PROCEDURE TFMain.ShowFramesAbs(startframe, endframe: double;
  numberOfFrames: Integer);
//starframe, endframe: absolute position.
VAR
  iImage                           : integer;
  //  counter: integer;
  pos, temp_pos, distance          : double;
  Target                           : TCutFrame;
BEGIN
  IF endframe <= startframe THEN exit;
  startframe := ensureRange(startframe, 0, MovieInfo.current_file_duration);
  endframe := ensureRange(endframe, 0, MovieInfo.current_file_duration - MovieInfo.frame_duration);

  numberOfFrames := FFrames.Count;
  distance := (endframe - startframe) / (numberofFrames - 1);

  FilterGraph.Pause;
  WaitForFiltergraph;

  pos := currentPosition;
  FFrames.Show;

  // Mute sound ?
  IF Settings.AutoMuteOnSeek AND NOT CBMute.Checked THEN
    FilterGraph.Volume := 0;
  FFrames.CanClose := false;

  TRY
    FOR iImage := 0 TO numberOfFrames - 1 DO BEGIN
      Target := FFrames.Frame[iImage];
      TRY
        Target.ResetFrame;
        temp_pos := startframe + (iImage * distance);
        IF (temp_pos >= 0) AND (temp_pos <= MovieInfo.current_file_duration) THEN BEGIN
          SampleInfo.Active := Assigned(SampleGrabber.FilterGraph);
          KeyFrameSampleInfo.Active := Assigned(KeyFrameGrabber.FilterGraph);
          TRY
            Target.position := temp_pos;
            SampleInfo.SampleTime := -1;
            KeyFrameSampleInfo.SampleTime := -1;

            JumpTo(temp_pos);
            WaitForFiltergraph;

            Target.AssignSampleInfo(SampleInfo, KeyFrameSampleInfo);
          FINALLY
            SampleInfo.Active := false;
            KeyFrameSampleInfo.Active := false;
          END;
        END;
      FINALLY
        Target.EnableUpdate;
      END;
    END;
  FINALLY
    FFrames.CanClose := true;
    // Restore sound
    IF Settings.AutoMuteOnSeek AND NOT CBMute.Checked THEN
      FilterGraph.Volume := tbVolume.Position;
    JumpTo(pos);
  END;
END;

PROCEDURE TFMain.WaitForFilterGraph;
VAR
  pfs                              : TFilterState;
  hr                               : hresult;
BEGIN
  REPEAT
    hr := (FilterGraph AS IMediaControl).GetState(50, pfs);
  UNTIL (hr = S_OK) OR (hr = E_FAIL);
END;

PROCEDURE TFMain.cmdConvertClick(Sender: TObject);
VAR
  newCutlist                       : TCutlist;
BEGIN
  IF cutlist.Count = 0 THEN exit;
  newCutlist := cutlist.convert;
  newCutlist.RefreshCallBack := cutlist.RefreshCallBack;
  FreeAndNIL(cutlist);
  cutlist := newCutlist;
  cutlist.RefreshGUI;
END;

PROCEDURE TFMain.ShowMetaData;
CONST
  stream                           = $0;
VAR
  HeaderInfo                       : IWMHeaderInfo;
  _text                            : STRING;
  value                            : PACKED ARRAY OF byte;
  _name                            : ARRAY OF WideChar;
  name_len, attr_len               : word;
  iFilter, iAttr, iByte            : integer;
  found                            : boolean;
  filterlist                       : TFilterlist;
  sourceFilter                     : IBaseFilter;
  attr_datatype                    : wmt_attr_datatype;
  CAttributes                      : word;
  _stream                          : word;
BEGIN
  IF (MovieInfo.current_filename = '') OR (NOT MovieInfo.MovieLoaded) THEN exit;

  frmMemoDialog.Caption := CAResources.RsTitleMovieMetaData;
  WITH frmMemoDialog.memInfo DO BEGIN
    Clear;
    Lines.Add(Format(CAResources.RsMovieMetaDataMovietype, [MovieInfo.MovieTypeString]));
    Lines.Add(Format(CAResources.RsMovieMetaDataCutApplication, [Settings.GetCutAppName(MovieInfo.MovieType)]));
    Lines.Add(Format(CAResources.RsMovieMetaDataFilename, [MovieInfo.current_filename]));
    Lines.Add(Format(CAResources.RsMovieMetaDataFrameRate, [FloatToStrF(1 / MovieInfo.frame_duration, ffFixed, 15, 4)]));

    IF MovieInfo.MovieType IN [mtAVI, mtHQAvi] THEN
      Lines.Add(Format(CAResources.RsMovieMetaDataVideoFourCC, [fcc2string(MovieInfo.FFourCC)]));

    IF MovieInfo.MovieType IN [mtWMV] THEN BEGIN
      filterlist := tfilterlist.Create;
      filterlist.Assign(filtergraph AS IFiltergraph);
      found := false;
      FOR iFilter := 0 TO filterlist.Count - 1 DO BEGIN
        IF STRING(filterlist.FilterInfo[iFilter].achName) = MovieInfo.current_filename THEN BEGIN
          sourcefilter := filterlist.Items[iFilter];
          found := true;
          break;
        END;
      END;
      IF found THEN BEGIN
        TRY
          //   wmcreateeditor
          //   (FIltergraph as IFiltergraph).FindFilterByName(pwidechar(current_filename), sourceFilter);
          //   (sourceFIlter as iammediacontent).get_AuthorName(pwidechar(author));
          IF succeeded(sourcefilter.QueryInterface(IwmHeaderInfo, HEaderINfo)) THEN BEGIN
            HeaderInfo := (sourceFilter AS IwmHeaderInfo);
            HeaderInfo.GetAttributeCount(stream, CAttributes);
            _stream := stream;
            FOR iAttr := 0 TO CAttributes - 1 DO BEGIN
              HeaderInfo.GetAttributeByIndex(iAttr, _stream, NIL, name_len, attr_datatype, NIL, attr_len);
              setlength(_name, name_len);
              setlength(value, attr_len);
              HeaderInfo.GetAttributeByIndex(iAttr, _stream, pwidechar(_name), name_len, attr_datatype, PByte(value), attr_len);
              CASE attr_datatype OF
                WMT_TYPE_STRING: _text := WideChartoString(PWideChar(value));
                WMT_TYPE_WORD: BEGIN
                    _text := inttostr(word(PWord(addr(value[0]))^));
                  END;
                WMT_TYPE_DWORD: BEGIN
                    _text := intTostr(dword(PDWord(addr(value[0]))^));
                  END;
                WMT_TYPE_QWORD: BEGIN
                    _text := intTostr(int64(PULargeInteger(addr(value[0]))^));
                  END;
                WMT_TYPE_BOOL: BEGIN
                    IF LongBool(PDword(addr(value[0]))^) THEN _text := 'true' ELSE _text := 'false';
                  END;
                WMT_TYPE_BINARY: BEGIN
                    _text := #13#10;
                    FOR iByte := 0 TO attr_len - 1 DO BEGIN
                      _text := _text + inttohex(value[iByte], 2) + ' ';
                      IF iByte MOD 8 = 7 THEN _text := _text + ' ';
                      IF iByte MOD 16 = 15 THEN _text := _text + #13#10;
                    END;
                  END;
                WMT_TYPE_GUID: BEGIN
                    _text := GuidToString(PGUID(value[0])^);
                  END;
              ELSE _text := CAResources.RsMovieMetaDataUnknownDataFormat;
              END;
              Lines.Add(Format('%s: %s', [WideCharToString(PWidechar(_name)), _text]));
            END;
          END;
        FINALLY
          FreeAndNIL(filterlist);
        END;
      END ELSE BEGIN
        Lines.Add(CAResources.RsMovieMetaDataNoInterface);
        FreeAndNIL(filterlist);
      END;
    END;
  END;
  frmMemoDialog.ShowModal;
END;

PROCEDURE TFMain.tbFilePosSelChanged(Sender: TObject);
BEGIN
  WITH FFrames DO BEGIN
    IF scan_1 <> -1 THEN BEGIN
      frame[scan_1].BorderVisible := false;
      scan_1 := -1;
    END;
    IF scan_2 <> -1 THEN BEGIN
      frame[scan_2].BorderVisible := false;
      scan_2 := -1;
    END;
  END;
  IF self.TBFilePos.SelEnd - self.TBFilePos.SelStart > 0 THEN
    actScanInterval.Enabled := true
  ELSE
    actScanInterval.Enabled := false;
END;

PROCEDURE TFMain.WMDropFiles(VAR message: TWMDropFiles);
VAR
  iFile, cFiles                    : uInt;
  FileName                         : ARRAY[0..255] OF Char;
  FileList                         : TStringList;
  FileString                       : STRING;
BEGIN
  FileList := TStringList.Create;
  TRY
    cFiles := DragQueryFile(message.Drop, $FFFFFFFF, NIL, 0);
    FOR iFile := 1 TO cFiles DO BEGIN
      DragQueryFile(message.Drop, iFile - 1, @FileName, uint(sizeof(FileName)));
      filestring := STRING(FileName);
      FileList.add(fileString);
    END;
    ProcessFileList(FileList, false);
  FINALLY
    FreeAndNIL(FileList);
  END;
  INHERITED;
END;

PROCEDURE TFMain.ProcessFileList(FileList: TStringList; IsMyOwnCommandLine: boolean);
VAR
  iString                          : INteger;
  Pstring, filename_movie, filename_cutlist, filename_upload_cutlist: STRING;
  upload_cutlist, found_movie, found_cutlist, get_empty_cutlist: boolean;
  try_cutlist_download             : boolean;
BEGIN
  found_movie := false;
  found_cutlist := false;
  upload_cutlist := false;
  try_cutlist_download := false;
  Batchmode := false;
  TryCutting := false;
  get_empty_cutlist := false;
  FOR iString := 0 TO FileList.Count - 1 DO BEGIN
    Pstring := FileList[iString];
    IF AnsiStartsStr('-uploadcutlist:', ansilowercase(PString)) THEN BEGIN
      filename_upload_cutlist := AnsiMidStr(PString, 16, length(Pstring) - 15);
      upload_cutlist := true;
    END;
    IF AnsiStartsStr('-getemptycutlist:', ansilowercase(PString)) AND (NOT found_cutlist) THEN BEGIN
      filename_cutlist := AnsiMidStr(PString, 18, length(Pstring) - 17);
      found_cutlist := true;
      get_empty_cutlist := true;
    END;
    IF AnsiStartsStr('-exit', ansilowercase(PString)) THEN BEGIN
      IF IsMyOwnCommandLine THEN exit_after_commandline := true;
    END;
    IF AnsiStartsStr('-open:', ansilowercase(PString)) AND (NOT found_movie) THEN BEGIN
      filename_movie := AnsiMidStr(PString, 7, length(Pstring) - 6);
      IF fileexists(filename_movie) THEN found_movie := true;
    END;
    IF AnsiStartsStr('-batchmode', ansilowercase(PString)) THEN BEGIN
      IF IsMyOwnCommandLine THEN Batchmode := true;
    END;
    IF AnsiStartsStr('-trycutting', ansilowercase(PString)) THEN BEGIN
      TryCutting := true;
    END;
    IF AnsiStartsStr('-trycutlistdownload', ansilowercase(PString)) AND (NOT found_cutlist) THEN BEGIN
      found_cutlist := true;
      try_cutlist_download := true;
    END;
    IF AnsiStartsStr('-cutlist:', ansilowercase(PString)) AND (NOT found_cutlist) THEN BEGIN
      filename_cutlist := AnsiMidStr(PString, 10, length(Pstring) - 9);
      IF fileexists(filename_cutlist) THEN found_cutlist := true;
    END;
    IF fileexists(Pstring) THEN BEGIN
      IF ansilowercase(extractfileext(Pstring)) = cutlist_Extension THEN BEGIN
        IF NOT found_cutlist THEN BEGIN
          filename_cutlist := pstring;
          found_cutlist := true;
        END;
      END ELSE BEGIN
        IF NOT found_movie THEN BEGIN
          filename_movie := pstring;
          found_movie := true;
        END;
      END;
    END;
  END;

  IF upload_cutlist THEN BEGIN
    IF NOT UploadCutlist(filename_upload_cutlist) THEN ExitCode := 64
  END;

  IF found_movie THEN BEGIN
    IF NOT openfile(filename_movie) THEN
      IF IsMyOwnCommandLine THEN ExitCode := 1;
  END;

  IF get_empty_cutlist THEN BEGIN
    IF IsMyOwnCommandLine THEN ExitCode := 32;
    IF cutlist.EditInfo THEN BEGIN
      IF cutlist.SaveAs(filename_cutlist) THEN BEGIN
        ExitCode := 0;
        exit;
      END;
    END;
  END;

  IF found_cutlist THEN BEGIN
    IF MovieInfo.MovieLoaded THEN BEGIN
      IF try_cutlist_download AND NOT Settings.AutoSearchCutlists THEN BEGIN
        IF NOT SearchCutlists(true, Settings.SearchLocalCutlists, Settings.SearchServerCutlists, [cstBySize]) THEN BEGIN
          IF IsMyOwnCommandLine THEN ExitCode := 2;
          exit;
        END;
      END ELSE BEGIN
        cutlist.LoadFromFile(filename_cutlist);
      END;
    END ELSE BEGIN
      IF NOT batchmode THEN
        showmessage(CAResources.RsCannotLoadCutlist);
    END;
  END;

  IF TryCutting THEN BEGIN
    IF MovieInfo.current_filename <> '' THEN BEGIN
      IF NOT StartCutting THEN
        IF IsMyOwnCommandLine THEN ExitCode := 128;
    END;
  END;
END;

PROCEDURE TFMain.actSaveCutlistAsExecute(Sender: TObject);
BEGIN
  IF cutlist.Save(true) THEN
    IF NOT batchmode THEN
      ShowMessageFmt(CAResources.RsCutlistSavedAs, [cutlist.SavedToFilename]);
END;

PROCEDURE TFMain.actOpenMovieExecute(Sender: TObject);
VAR
  ExtList, ExtListAllSupported     : STRING;
  PROCEDURE AppendFilterString(CONST description: STRING; CONST extensions: STRING); OVERLOAD;
  VAR
    filter                         : STRING;
  BEGIN
    filter := MakeFilterString(description, extensions);
    IF odMovie.Filter <> '' THEN
      odMovie.Filter := odMovie.Filter + '|' + filter
    ELSE
      odMovie.Filter := filter
  END;
  PROCEDURE AppendFilterString(CONST description: STRING; CONST ExtArray: ARRAY OF STRING); OVERLOAD;
  BEGIN
    ExtList := FilterStringFromExtArray(ExtArray);
    AppendFilterString(description, ExtList);
    IF ExtListAllSupported <> '' THEN
      ExtListAllSupported := ExtListAllSupported + ';' + ExtList
    ELSE
      ExtListAllSupported := ExtList;
  END;
BEGIN
  //if not AskForUserRating(cutlist) then exit;
  //if not cutlist.clear_after_confirm then exit;

  ExtListAllSupported := '';
  odMovie.Filter := '';

  // Make Filter List
  AppendFilterString(CAResources.RsFilterDescriptionWmv, WMV_EXTENSIONS);
  AppendFilterString(CAResources.RsFilterDescriptionAvi, AVI_EXTENSIONS);
  AppendFilterString(CAResources.RsFilterDescriptionMp4, MP4_EXTENSIONS);
  AppendFilterString(CAResources.RsFilterDescriptionAll, '*.*');
  odMovie.Filter := MakeFilterString(CAResources.RsFilterDescriptionAllSupported, ExtListAllSupported) +
    '|' + odMovie.Filter;

  odMovie.InitialDir := settings.CurrentMovieDir;
  IF odMovie.Execute THEN BEGIN
    settings.CurrentMovieDir := ExtractFilePath(odMovie.FileName);
    IF OpenFile(odMovie.FileName) THEN BEGIN
      IF MovieInfo.MovieLoaded AND (Settings.AutoSearchCutlists XOR AltDown) THEN BEGIN
        SearchCutlists(true, ShiftDown XOR Settings.SearchLocalCutlists, CtrlDown XOR Settings.SearchServerCutlists, [cstBySize]);
      END;
    END;
  END;
END;

PROCEDURE TFMain.actOpenCutlistExecute(Sender: TObject);
BEGIN
  LoadCutlist;
END;

PROCEDURE TFMain.actFileExitExecute(Sender: TObject);
BEGIN
  self.Close;
END;

PROCEDURE TFMain.actAddCutExecute(Sender: TObject);
BEGIN
  IF cutlist.AddCut(pos_from, pos_to) THEN BEGIN
    pos_from := 0;
    pos_to := 0;
    refresh_times;
  END;
END;

PROCEDURE TFMain.actReplaceCutExecute(Sender: TObject);
VAR
  dcut                             : integer;
BEGIN
  IF Settings.Additional['AutoReplaceCuts'] = '1' THEN BEGIN
    dcut := cutlist.FindCutIndex(pos_from);
    IF dcut >= 0 THEN cutlist.DeleteCut(dcut);
    dcut := cutlist.FindCutIndex(pos_to);
    IF dcut >= 0 THEN cutlist.DeleteCut(dcut);
    cutlist.AddCut(pos_from, pos_to);
    Exit;
  END;

  IF self.lvCutlist.SelCount = 0 THEN BEGIN
    self.enable_del_buttons(false);
    exit;
  END;
  dcut := strtoint(self.lvCutlist.Selected.caption);
  cutlist.ReplaceCut(pos_from, pos_to, dCut);
END;

PROCEDURE TFMain.actEditCutExecute(Sender: TObject);
VAR
  dcut                             : integer;
BEGIN
  IF self.lvCutlist.SelCount = 0 THEN BEGIN
    self.enable_del_buttons(false);
    exit;
  END;
  dcut := strtoint(self.lvCutlist.Selected.caption);
  pos_from := cutlist[dcut].pos_from;
  pos_to := cutlist[dcut].pos_to;
  refresh_times;
END;

PROCEDURE TFMain.actDeleteCutExecute(Sender: TObject);
BEGIN
  IF self.lvCutlist.SelCount = 0 THEN BEGIN
    self.enable_del_buttons(false);
    exit;
  END;
  cutlist.DeleteCut(strtoint(self.lvCutlist.Selected.caption));
END;

PROCEDURE TFMain.actShowFramesFormExecute(Sender: TObject);
BEGIN
  FFrames.Show;
END;

PROCEDURE TFMain.actNextFramesExecute(Sender: TObject);
VAR
  c                                : TCursor;
BEGIN
  IF NOT MovieInfo.MovieLoaded THEN
    exit;
  c := self.Cursor;
  TRY
    EnableMovieControls(false);
    self.Cursor := crHourGlass;
    application.ProcessMessages;
    showframes(1, FFrames.Count);
  FINALLY
    EnableMovieControls(true);
    self.Cursor := c;
  END;
END;

PROCEDURE TFMain.actCurrentFramesExecute(Sender: TObject);
VAR
  c                                : TCursor;
  halfFrames                       : integer;
BEGIN
  IF NOT MovieInfo.MovieLoaded THEN
    exit;
  c := self.Cursor;
  TRY
    EnableMovieControls(false);
    self.Cursor := crHourGlass;
    application.ProcessMessages;
    halfFrames := 1 + FFrames.Count DIV 2;
    showframes(1 - halfFrames, FFrames.Count - halfFrames);
  FINALLY
    EnableMovieControls(true);
    self.Cursor := c;
  END;
END;

PROCEDURE TFMain.actPrevFramesExecute(Sender: TObject);
VAR
  c                                : TCursor;
BEGIN
  IF NOT MovieInfo.MovieLoaded THEN
    exit;
  c := self.Cursor;
  TRY
    EnableMovieControls(false);
    self.Cursor := crHourGlass;
    application.ProcessMessages;
    showframes(-1 * FFrames.Count, -1);
  FINALLY
    EnableMovieControls(true);
    self.Cursor := c;
  END;
END;

PROCEDURE TFMain.actScanIntervalExecute(Sender: TObject);
VAR
  i1, i2                           : integer;
  pos1, pos2                       : double;
  c                                : TCursor;
BEGIN
  IF NOT MovieInfo.MovieLoaded THEN
    exit;
  i1 := FFrames.scan_1;
  i2 := FFrames.scan_2;

  IF (i1 = -1) OR (i2 = -1) THEN BEGIN
    pos1 := self.TBFilePos.SelStart;
    pos2 := self.TBFilePos.SelEnd;
  END ELSE BEGIN
    IF i1 > i2 THEN BEGIN
      i1 := i2;
      i2 := FFrames.scan_1;
    END;
    pos1 := FFrames.Frame[i1].position;
    FFrames.Frame[i1].BorderVisible := false;
    pos2 := FFrames.Frame[i2].position;
    FFrames.Frame[i2].BorderVisible := false;
  END;

  c := self.Cursor;
  self.Cursor := crHourGlass;
  TRY
    EnableMovieControls(false);
    self.actScanInterval.Enabled := false;
    Application.ProcessMessages;

    showframesabs(pos1, pos2, FFrames.Count);
  FINALLY
    EnableMovieControls(true);
    self.actScanInterval.Enabled := true;
    self.Cursor := c;
  END;
END;

PROCEDURE TFMain.actEditSettingsExecute(Sender: TObject);
BEGIN
  settings.edit;
  SettingsChanged;
END;

PROCEDURE TFMain.SettingsChanged;
BEGIN
  UpdateStaticSettings;
  WITH self.WebRequest_nl DO BEGIN
    Request.UserAgent := 'CutAssistant ' + Utils.Application_version + ' (Indy Library)';
    WITH Request.CustomHeaders DO BEGIN
      Values['X-CA-Version'] := 'CutAssistant ' + Utils.Application_version;
      Values['X-CA-Protocol'] := '1';
    END;
    ConnectTimeout := 1000 * Settings.NetTimeout;
    ReadTimeout := 1000 * Settings.NetTimeout;
    WITH ProxyParams DO BEGIN
      ProxyServer := Settings.proxyServerName;
      ProxyPort := Settings.proxyPort;
      ProxyUsername := Settings.proxyUserName;
      ProxyPassword := Settings.proxyPassword;
    END;
  END;
END;

PROCEDURE TFMain.actStartCuttingExecute(Sender: TObject);
BEGIN
  StartCutting;
END;

PROCEDURE TFMain.actMovieMetaDataExecute(Sender: TObject);
BEGIN
  ShowMetaData;
END;

PROCEDURE TFMain.actUsedFiltersExecute(Sender: TObject);
BEGIN
  FManageFilters.SourceGraph := FilterGraph;
  FManageFilters.ShowModal;
END;

PROCEDURE TFMain.actAboutExecute(Sender: TObject);
BEGIN
  AboutBox.ShowModal();
END;

PROCEDURE ForceOpenRegKey(CONST reg: TRegistry; CONST key: STRING);
VAR
  path                             : STRING;
BEGIN
  IF NOT reg.OpenKey(key, true) THEN BEGIN
    IF AnsiStartsStr('\', key) THEN path := key
    ELSE path := reg.CurrentPath + '\' + key;

    RAISE ERegistryException.CreateResFmt(@CAResources.RsExUnableToOpenKey, [path]);
  END;
END;

PROCEDURE TFMain.actWriteToRegistyExecute(Sender: TObject);
VAR
  reg                              : TRegistry;
  myDir                            : STRING;
BEGIN
  myDir := application.ExeName;
  reg := Tregistry.Create;
  TRY
    TRY
      reg.RootKey := HKEY_CLASSES_ROOT;
      ForceOpenRegKey(reg, '\' + cutlist_Extension);
      reg.WriteString('', CutlistID);
      reg.WriteString('Content Type', CUTLIST_CONTENT_TYPE);
      reg.CloseKey;

      ForceOpenRegKey(reg, '\' + CutlistID);
      reg.WriteString('', CAResources.RsRegDescCutlist);
      ForceOpenRegKey(reg, 'DefaultIcon');
      reg.WriteString('', '"' + myDir + '",0');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\' + CutlistID + '\Shell\open');
      reg.WriteString('', CAResources.RsRegDescCutlistOpen);
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -cutlist:"%1"');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\WMVFile\Shell\' + ShellEditKey);
      reg.WriteString('', CAResources.RsRegDescMovieOpen);
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -open:"%1"');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\AVIFile\Shell\' + ShellEditKey);
      reg.WriteString('', CAResources.RsRegDescMovieOpen);
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -open:"%1"');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\QuickTime.mp4\Shell\' + ShellEditKey);
      reg.WriteString('', CAResources.RsRegDescMovieOpen);
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -open:"%1"');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\Applications\' + ProgID + '\shell\open');
      reg.WriteString('FriendlyAppName', 'Cut Assistant');
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -open:"%1"');
      reg.CloseKey;
    FINALLY
      FreeAndNIL(reg);
    END;
  EXCEPT
    ON ERegistryException DO
      ShowExpectedException(CAResources.RsErrorRegisteringApplication);
  END;
END;

PROCEDURE TFMain.actRemoveRegistryEntriesExecute(Sender: TObject);
VAR
  reg                              : TRegistry;
  myDir                            : STRING;
BEGIN
  myDir := application.ExeName;
  reg := Tregistry.Create;
  TRY
    TRY
      reg.RootKey := HKEY_CLASSES_ROOT;
      IF reg.OpenKey('\WMVFile\Shell', false) THEN BEGIN
        reg.DeleteKey(ShellEditKey);
        reg.CloseKey;
      END;

      IF reg.OpenKey('\AVIFile\Shell', false) THEN BEGIN
        reg.DeleteKey(ShellEditKey);
        reg.CloseKey;
      END;

      IF reg.OpenKey('\QuickTime.mp4\Shell', false) THEN BEGIN
        reg.DeleteKey(ShellEditKey);
        reg.CloseKey;
      END;

      IF reg.OpenKey('\Applications', false) THEN BEGIN
        reg.DeleteKey(ProgID);
        reg.CloseKey;
      END;

      reg.DeleteKey('\' + cutlist_Extension);
      reg.DeleteKey('\' + CutlistID);
    FINALLY
      FreeAndNIL(reg);
    END;
  EXCEPT
    ON ERegistryException DO
      ShowExpectedException(CAResources.RsErrorUnRegisteringApplication);
  END;
END;

PROCEDURE TFMain.rgCutModeClick(Sender: TObject);
BEGIN
  CASE self.rgCutMode.ItemIndex OF
    0: cutlist.Mode := clmCutOut;
    1: cutlist.Mode := clmTrim;
  END;
END;

PROCEDURE TFMain.actCutlistUploadExecute(Sender: TObject);
VAR
  message_String                   : STRING;
BEGIN
  IF cutlist.HasChanged THEN BEGIN
    IF NOT cutlist.Save(false) THEN //try to save it
      exit;
  END;

  IF NOT fileexists(cutlist.SavedToFilename) THEN exit;

  message_string := Format(CAResources.RsMsgUploadCutlist, [cutlist.SavedToFilename, settings.url_cutlists_upload]);
  IF NOT (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
    exit;
  END;

  UploadCutlist(cutlist.SavedToFilename);
END;

PROCEDURE TFMain.actStepForwardExecute(Sender: TObject);
VAR
  event                            : integer;
BEGIN
  IF FilterGraph.State <> gsPaused THEN GraphPause;
  IF assigned(FrameStep) THEN BEGIN
    IF Settings.AutoMuteOnSeek AND NOT CBMute.Checked THEN
      FilterGraph.Volume := 0;
    FrameStep.Step(1, NIL);
    MediaEvent.WaitForCompletion(500, event);
    TBFilePos.TriggerTimer;
    IF Settings.AutoMuteOnSeek AND NOT CBMute.Checked THEN
      FilterGraph.Volume := tbVolume.Position;
  END ELSE BEGIN
    self.actStepForward.Enabled := false;
  END;
END;

PROCEDURE TFMain.actStepBackwardExecute(Sender: TObject);
VAR
  timeToSkip                       : double;
BEGIN
  IF FilterGraph.State <> gsPaused THEN GraphPause;

  IF Sender = actLargeSkipBackward THEN
    timeToSkip := Settings.LargeSkipTime
  ELSE IF Sender = actSmallSkipBackward THEN
    timeToSkip := Settings.SmallSkipTime
  ELSE IF Sender = actLargeSkipForward THEN
    timeToSkip := -Settings.LargeSkipTime
  ELSE IF Sender = actSmallSkipForward THEN
    timeToSkip := -Settings.SmallSkipTime
  ELSE
    timeToSkip := MovieInfo.frame_duration;

  JumpTo(currentPosition - timeToSkip);
END;

PROCEDURE TFMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; VAR Handled: Boolean);
VAR
  timeToSkip                       : double;
BEGIN
  IF NOT MovieInfo.MovieLoaded THEN
    exit;
  Handled := true;
  IF FilterGraph.State <> gsPaused THEN
    GraphPause;
  IF shift = [ssShift] THEN
    timeToSkip := Settings.SmallSkipTime
  ELSE IF shift = [ssShift, ssCtrl] THEN
    timeToSkip := Settings.LargeSkipTime
  ELSE IF shift = [ssAlt] THEN
    timeToSkip := Settings.LargeSkipTime
  ELSE
    timeToSkip := tbFilePos.PageSize * MovieInfo.frame_duration;

  JumpTo(currentPosition - timeToSkip * Sign(WheelDelta));
END;

PROCEDURE TFMain.actBrowseWWWHelpExecute(Sender: TObject);
BEGIN
  ShellExecute(0, NIL, PChar(settings.url_help), '', '', SW_SHOWNORMAL);
END;

PROCEDURE TFMain.FormKeyDown(Sender: TObject; VAR Key: Word;
  Shift: TShiftState);
VAR
  done                             : boolean;
BEGIN
  done := false;
  IF Shift = [] THEN
    CASE key OF
      ord('K'), ord(' '), VK_MEDIA_PLAY_PAUSE:
        done := actPlayPause.Execute;
      VK_MEDIA_STOP:
        done := actStop.Execute;
      VK_MEDIA_NEXT_TRACK:
        done := actNextCut.Execute;
      VK_MEDIA_PREV_TRACK:
        done := actPrevCut.Execute;
      VK_BROWSER_BACK:
        done := actStepBackward.Execute;
      VK_BROWSER_FORWARD:
        done := actStepForward.Execute;
    END;
  IF done THEN
    Key := 0;
END;

PROCEDURE TFMain.AppCommandAppCommand(Handle: Cardinal; Cmd: Word;
  Device: TJvAppCommandDevice; KeyState: Word; VAR Handled: Boolean);
BEGIN
  CASE Cmd OF // Force Handled for specific commands ...
    APPCOMMAND_BROWSER_BACKWARD:
      Handled := actStepBackward.Execute OR true;
    APPCOMMAND_BROWSER_FORWARD:
      Handled := actStepForward.Execute OR true;
    APPCOMMAND_MEDIA_PLAY_PAUSE:
      Handled := actPlayPause.Execute OR true;
    APPCOMMAND_MEDIA_STOP:
      Handled := actStop.Execute OR true;
    APPCOMMAND_MEDIA_NEXTTRACK:
      Handled := actNextCut.Execute OR true;
    APPCOMMAND_MEDIA_PREVIOUSTRACK:
      Handled := actPrevCut.Execute OR true;
  END;
END;


PROCEDURE TFMain.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
VAR
  message_string                   : STRING;
BEGIN
  IF cutlist.HasChanged THEN BEGIN
    message_string := CAResources.RsMsgSaveChangedCutlist;
    CASE application.messagebox(PChar(message_string), PChar(CAResources.RsTitleSaveChangedCutlist), MB_YESNOCANCEL + MB_DEFBUTTON3 + MB_ICONQUESTION) OF
      IDYES: BEGIN
          CanClose := cutlist.Save(false); //Can Close if saved successfully
        END;
      IDNO: BEGIN
          CanClose := true;
        END;
    ELSE BEGIN
        CanClose := false;
      END;
    END;
  END;
END;

PROCEDURE TFMain.actOpenCutlistHomeExecute(Sender: TObject);
BEGIN
  ShellExecute(0, NIL, PChar(settings.url_cutlists_home), '', '', SW_SHOWNORMAL);
END;

PROCEDURE TFMain.CloseMovie;
BEGIN
  IF filtergraph.Active THEN BEGIN
    filtergraph.Stop;
    filtergraph.Active := false;
    filtergraph.ClearGraph;
    SampleGrabber.FilterGraph := NIL;
    KeyFrameGrabber.FilterGraph := NIL;
    TeeFilter.FilterGraph := NIL;
    NullRenderer.FilterGraph := NIL;
    //    AviDecompressor.FilterGraph := nil;
  END;
  MovieInfo.current_filename := '';
  MovieInfo.current_filesize := -1;
  MovieInfo.MovieLoaded := false;
  IF Assigned(FFrames) THEN BEGIN
    FFrames.HideFrames;
  END;

  tbFilePos.Position := 0;
  tbFilePos.TriggerTimer;

  ResetForm;
END;

FUNCTION TFMain.RepairMovie: boolean;
VAR
  filename_temp, file_ext, filename_damaged,
    command, AppPath, message_string: STRING;
  exitCode                         : DWord;
  selectFileDlg                    : TOpenDialog;
  CutApplication                   : TCutApplicationAsfbin;
BEGIN
  result := false;
  IF NOT (movieinfo.MovieType IN [mtWMV]) THEN exit;

  CutApplication := Settings.GetCutApplicationByName('Asfbin') AS TCutApplicationAsfbin;
  IF NOT assigned(CutApplication) THEN BEGIN
    IF NOT batchmode THEN
      ShowMessage(CAResources.RsCutAppAsfBinNotFound);
    exit;
  END;

  IF MovieInfo.current_filename = '' THEN BEGIN
    selectFileDlg := TOpenDialog.Create(self);
    selectFileDlg.Filter := CAResources.RsFilterDescriptionAsf + '|*.wmv;*.asf|' + CAResources.RsFilterDescriptionAll + '|*.*';
    selectFileDlg.Options := selectFileDlg.Options + [ofPathMustExist, ofFileMustExist, ofNoChangeDir];
    selectFileDlg.Title := CAResources.RsTitleRepairMovie;
    IF selectFileDlg.Execute THEN BEGIN
      filename_temp := selectFileDlg.FileName;
      FreeAndNIL(selectFileDlg);
    END ELSE BEGIN
      FreeAndNIL(selectFileDlg);
      exit;
    END;
  END ELSE BEGIN
    filename_temp := MovieInfo.current_filename;
  END;

  file_ext := extractfileExt(filename_temp);
  filename_damaged := changeFileExt(filename_temp, '.damaged' + file_ext);

  message_string := Format(CAResources.RsMsgRepairMovie, [extractFileName(CutApplication.Path), filename_damaged]);
  IF NOT (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
    exit;
  END;

  CloseMovie;

  IF NOT renameFile(filename_temp, filename_damaged) THEN BEGIN
    IF NOT batchmode THEN
      ShowMessage(CAResources.RsMsgRepairMovieRenameFailed);
    exit;
  END;

  command := '-i "' + filename_damaged + '" -o "' + filename_temp + '"';
  AppPath := '"' + CutApplication.Path + '"';
  TRY
    result := STO_ShellExecute(AppPath, Command, INFINITE, false, exitCode);
  FINALLY
    {    if ExitCode > 0 then begin
          showmessage('Could not repair file. ExitCode = ' + inttostr(ExitCode));
          result := false;
        end;      }
    IF NOT result THEN BEGIN
      renameFile(filename_damaged, filename_temp);
    END;

    IF result THEN BEGIN
      IF (application.messagebox(PChar(CAResources.RsMsgRepairMovieFinished), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
        self.OpenFile(filename_temp);
      END;
    END;
  END;
END;

PROCEDURE TFMain.actRepairMovieExecute(Sender: TObject);
BEGIN
  self.RepairMovie;
END;

PROCEDURE TFMain.actCutlistInfoExecute(Sender: TObject);
BEGIN
  cutlist.EditInfo;
END;

PROCEDURE TFMain.actSaveCutlistExecute(Sender: TObject);
BEGIN
  IF cutlist.Save(false) THEN
    IF NOT batchmode THEN
      ShowMessageFmt(CAResources.RsCutlistSavedAs, [cutlist.SavedToFilename]);
END;

PROCEDURE TFMain.actCalculateResultingTimesExecute(Sender: TObject);
VAR
  selectFileDlg                    : TOpenDialog;
  AskForPath                       : boolean;
BEGIN
  AskForPath := Settings.MovieNameAlwaysConfirm
    OR NOT FileExists(MovieInfo.target_filename)
    OR (MovieInfo.target_filename = '');
  IF NOT BatchMode AND AskForPath THEN BEGIN
    selectFileDlg := TOpenDialog.Create(self);
    TRY
      selectFileDlg.Filter := MakeFilterString(CAResources.RsFilterDescriptionAllSupported,
        FilterStringFromExtArray(WMV_EXTENSIONS) + ';' +
        FilterStringFromExtArray(AVI_EXTENSIONS) + ';' +
        FilterStringFromExtArray(MP4_EXTENSIONS))
        + '|' + MakeFilterString(CAResources.RsFilterDescriptionAll, '*.*');

      selectFileDlg.Options := selectFileDlg.Options + [ofPathMustExist, ofFileMustExist, ofNoChangeDir];
      selectFileDlg.Title := CAResources.RsTitleCheckCutMovie;
      IF MovieInfo.target_filename = '' THEN BEGIN
        selectFileDlg.InitialDir := settings.CutMovieSaveDir;
      END ELSE BEGIN
        selectFileDlg.InitialDir := ExtractFileDir(MovieInfo.target_filename);
        selectFileDlg.FileName := MovieInfo.target_filename;
      END;
      IF selectFileDlg.Execute THEN
        MovieInfo.target_filename := selectFileDlg.FileName
      ELSE
        Exit;
    FINALLY
      FreeAndNIL(selectFileDlg);
    END;
  END;

  IF NOT fileexists(MovieInfo.target_filename) THEN BEGIN
    IF NOT batchmode THEN
      showmessage(CAResources.RsErrorMovieNotFound);
    Exit;
  END;

  TRY
    IF NOT FResultingTimes.loadMovie(MovieInfo.target_filename) THEN BEGIN
      IF NOT batchmode THEN
        showmessage(CAResources.RsErrorCouldNotLoadMovie);
      exit;
    END;
    FResultingTimes.calculate(cutlist);
    FResultingTimes.Show;
  EXCEPT
    ON E: Exception DO
      IF NOT batchmode THEN
        ShowMessageFmt(CAResources.RsErrorCouldNotLoadCutMovie, [E.Message]);
  END;
END;

PROCEDURE TFMain.actAsfbinInfoExecute(Sender: TObject);
VAR
  info                             : STRING;
  CutApplication                   : TCutApplicationBase;
BEGIN
  info := '';

  CutApplication := Settings.GetCutApplicationByMovieType(mtWMV);
  IF assigned(CutApplication) THEN BEGIN
    info := info + CAResources.RsCutApplicationWmv + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  END;

  CutApplication := Settings.GetCutApplicationByMovieType(mtAVI);
  IF assigned(CutApplication) THEN BEGIN
    info := info + CAResources.RsCutApplicationAvi + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  END;

  CutApplication := Settings.GetCutApplicationByMovieType(mtHQAVI);
  IF assigned(CutApplication) THEN BEGIN
    info := info + CAResources.RsCutApplicationHqAvi + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  END;

  CutApplication := Settings.GetCutApplicationByMovieType(mtMP4);
  IF assigned(CutApplication) THEN BEGIN
    info := info + CAResources.RsCutApplicationMp4 + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  END;

  CutApplication := Settings.GetCutApplicationByMovieType(mtUnknown);
  IF assigned(CutApplication) THEN BEGIN
    info := info + CAResources.RsCutApplicationOther + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  END;

  frmMemoDialog.Caption := CAResources.RsTitleCutApplicationSettings;
  frmMemoDialog.memInfo.Clear;
  frmMemoDialog.memInfo.Text := info;
  frmMemoDialog.ShowModal;
END;

FUNCTION TFMain.SearchCutlistsByFileSize_Local(SearchType: TCutlistSearchType): integer;
VAR
  Error_message                    : STRING;
  searchDir                        : STRING;
  fileBase                         : STRING;
  sr                               : TSearchRec;
  ACutlist                         : TCutlist;
  lvLinks                          : TListView;
  dupItem                          : TListItem;
  idx                              : integer;
BEGIN
  Result := 0;
  Error_message := CAResources.RsErrorUnknown;
  CASE SearchType OF
    cstBySize: BEGIN
        IF (MovieInfo.current_filesize = 0) THEN
          exit;
      END;
    cstByName: BEGIN
        IF (MovieInfo.current_filename = '') THEN
          exit;
      END;
  ELSE
    exit;
  END;

  IF Settings.SaveCutlistMode = smGivenDir THEN
    searchDir := ExtractFileDir(MovieInfo.current_filename)
  ELSE BEGIN
    searchDir := Settings.CutlistSaveDir;
    IF NOT IsPathRooted(searchDir) THEN
      searchDir := PathCombine(ExtractFileDir(MovieInfo.current_filename), searchDir);
  END;

  lvLinks := FCutlistSearchResults.lvLinklist;
  fileBase := ChangeFileExt(ExtractFileName(MovieInfo.current_filename), '');

  IF FindFirst(PathCombine(searchDir, '*' + CUTLIST_EXTENSION), faArchive, sr) = 0 THEN BEGIN
    REPEAT
      ACutlist := TCutlist.create(Settings, MovieInfo);
      TRY
        IF NOT ACutlist.LoadFromFile(PathCombine(searchDir, sr.Name), true) THEN
          Continue;
        CASE SearchType OF
          cstBySize:
            IF (ACutlist.OriginalFileSize <> MovieInfo.current_filesize) THEN
              Continue;
          cstByName:
            IF NOT AnsiStartsText(fileBase, sr.Name) THEN
              Continue;
        END;
        idx := 0;
        WHILE idx < lvLinks.Items.Count DO BEGIN
          dupItem := lvLinks.Items.Item[idx];
          IF NOT Assigned(dupItem) THEN BEGIN
          END ELSE IF (ACutlist.IDOnServer <> '') AND (dupItem.Caption = ACutlist.IDOnServer) THEN BEGIN
            Break
          END ELSE IF (dupItem.SubItems.IndexOf(CAResources.RsLocalCutlist) > -1)
            AND (dupItem.SubItems.IndexOf(ExtractFileName(ACutlist.SavedToFilename)) > -1)
            AND (dupItem.SubItems.IndexOf(ExtractFileDir(ACutlist.SavedToFilename)) > -1) THEN BEGIN
            Break;
          END;
          Inc(idx);
        END;
        IF idx < lvLinks.Items.Count THEN
          continue;

        WITH lvLinks.Items.Add DO BEGIN
          Caption := ACutlist.IDOnServer;
          SubItems.Add(ExtractFileName(ACutlist.SavedToFilename));
          SubItems.Add(IfThen(ACutlist.IDOnServer = '', '', Format('%f', [ACutlist.RatingOnServer])));
          SubItems.Add(IfThen(ACutlist.IDOnServer = '', '', IntToStr(ACutlist.RatingCountOnServer)));
          SubItems.Add(IfThen(ACutlist.RatingByAuthorPresent, IntToStr(ACutlist.RatingByAuthor), ''));
          SubItems.Add(ACutlist.Author);
          SubItems.Add(ACutlist.UserComment);
          SubItems.Add(ACutlist.ActualContent);
          SubItems.Add(CAResources.RsLocalCutlist);
          SubItems.Add(IfThen(ACutlist.DownloadTime <= 0, '', FormatDateTime('', UnixToDateTime(ACutlist.DownloadTime))));
          SubItems.Add(ExtractFileDir(ACutlist.SavedToFilename));
        END;
        Inc(Result);
      FINALLY
        FreeAndNil(ACutlist);
      END;
    UNTIL FindNext(sr) <> 0;
    FindClose(sr);
  END;
END;

FUNCTION TFMain.SearchCutlistsByFileSize_XML(SearchType: TCutlistSearchType): integer;
CONST
  php_name                         = 'getxml.php';
VAR
  WebResult                        : boolean;
  url, Error_message               : STRING;
  Response                         : STRING;
  cutFilename                      : STRING;
  Node, CutNode                    : TJCLSimpleXMLElems;
  idx                              : integer;
  lvLinks                          : TListView;
BEGIN
  result := 0;
  Error_message := CAResources.RsErrorUnknown;
  CASE SearchType OF
    cstBySize: BEGIN
        IF (MovieInfo.current_filesize = 0) THEN
          exit;
        url := settings.url_cutlists_home
          + php_name
          + '?ofsb='
          + inttostr(MovieInfo.current_filesize)
      END;
    cstByName: BEGIN
        IF (MovieInfo.current_filename = '') THEN
          exit;
        url := settings.url_cutlists_home
          + php_name
          + '?name='
          + TIdURI.ParamsEncode(ChangeFileExt(ExtractFileName(MovieInfo.current_filename), ''));
      END;
  ELSE
    exit;
  END;

  url := url + '&' + Utils.GetVersionRequestParams;
  WebResult := DoHttpGet(url, false, error_message, Response);

  IF WebResult AND (Length(response) > 5) THEN BEGIN
    lvLinks := FCutlistSearchResults.lvLinklist;
    TRY
      XMLResponse.LoadFromString(Response);

      IF XMLResponse.Root.ChildsCount > 0 THEN BEGIN
        Node := XMLResponse.Root.Items;
        FOR idx := 0 TO node.Count - 1 DO BEGIN
          CutNode := node.Item[idx].Items;
          IF Assigned(lvLinks.FindCaption(0, CutNode.ItemNamed['id'].Value, false, true, false)) THEN
            continue;
          WITH lvLinks.Items.Add DO BEGIN
            Caption := CutNode.ItemNamed['id'].Value;
            cutFilename := CutNode.ItemNamed['name'].Value;
            IF NOT AnsiEndsText(CUTLIST_EXTENSION, cutFilename) THEN
              cutFilename := cutFilename + CUTLIST_EXTENSION;
            SubItems.Add(cutFilename);
            SubItems.Add(CutNode.ItemNamed['rating'].Value);
            SubItems.Add(CutNode.ItemNamed['ratingcount'].Value);
            SubItems.Add(CutNode.ItemNamed['ratingbyauthor'].Value);
            SubItems.Add(CutNode.ItemNamed['author'].Value);
            SubItems.Add(CutNode.ItemNamed['usercomment'].Value);
            SubItems.Add(CutNode.ItemNamed['actualcontent'].Value);
            SubItems.Add(CAResources.RsServerCutlist);
            SubItems.Add(''); // download timestamp
            SubItems.Add(''); // path information
          END;
          Inc(Result);
        END;
      END;
    EXCEPT
      ON E: EJclSimpleXMLError DO BEGIN
        IF NOT batchmode THEN
          ShowMessageFmt(CAresources.RsErrorSearchCutlistXml, [E.Message]);
      END;
    END;
  END;
END;

PROCEDURE TFMain.actSearchCutlistByFileSizeExecute(Sender: TObject);
VAR
  SearchTypes                      : TCutlistSearchTypes;
BEGIN
  SearchTypes := [cstBySize];
  IF Settings.SearchCutlistsByName THEN
    SearchTypes := SearchTypes + [cstByName];
  SearchCutlists(false, ShiftDown, true, SearchTypes);
END;

PROCEDURE TFMain.actSearchCutlistLocalExecute(Sender: TObject);
VAR
  SearchTypes                      : TCutlistSearchTypes;
BEGIN
  SearchTypes := [cstBySize];
  IF Settings.SearchCutlistsByName THEN
    SearchTypes := SearchTypes + [cstByName];
  SearchCutlists(false, true, ShiftDown, SearchTypes);
END;

FUNCTION TFMain.SearchCutlists(AutoOpen: boolean; SearchLocal, SearchWeb: boolean; SearchTypes: TCutlistSearchTypes): boolean;
VAR
  numFound                         : integer;
  WebResult                        : boolean;
  selectedItem                     : TListItem;
  cutFilename, cutFiledir          : STRING;
  SearchType                       : TCutlistSearchType;
BEGIN
  FCutlistSearchResults.lvLinklist.Clear;
  numFound := 0;
  Result := false;

  FOR SearchType := Low(SearchType) TO High(SearchType) DO BEGIN
    IF NOT (SearchType IN SearchTypes) THEN
      Continue;
    IF SearchWeb THEN
      numFound := numFound + self.SearchCutlistsByFileSize_XML(SearchType);
    IF SearchLocal THEN
      numFound := numFound + self.SearchCutlistsByFileSize_Local(SearchType);
  END;
  IF numFound < 0 THEN
    Exit;

  IF numFound = 0 THEN BEGIN
    IF NOT batchmode THEN
      showmessage(CAResources.RsMsgSearchCutlistNoneFound);
    Exit;
  END;

  IF AutoOpen AND (numFound = 1) THEN
    selectedItem := FCutlistSearchResults.lvLinklist.Items[0]
  ELSE IF BatchMode AND (numFound = 1) THEN
    selectedItem := FCutlistSearchResults.lvLinklist.Items[0]
  ELSE IF BatchMode AND (Settings.Additional['ShowSearchResultInBatch'] <> '1') THEN
    selectedItem := FCutlistSearchResults.lvLinklist.Items[0]
  ELSE IF FCutlistSearchResults.ShowModal = mrOK THEN
    selectedItem := FCutlistSearchResults.lvLinklist.Selected
  ELSE
    selectedItem := NIL;

  IF Assigned(selectedItem) THEN BEGIN
    cutFilename := selectedItem.SubItems[0];
    cutFiledir := selectedItem.SubItems[selectedItem.SubItems.Count - 1];
    IF cutFiledir <> '' THEN BEGIN
      IF NOT self.CloseCutlist THEN
        Exit;
      cutFilename := PathCombine(cutFiledir, cutFilename);
      CutList.LoadFromFile(cutFilename);
    END ELSE BEGIN
      WebResult := self.DownloadCutlistByID(selectedItem.Caption, cutFilename);
      IF WebResult THEN BEGIN
        cutlist.IDOnServer := selectedItem.Caption;
        cutlist.RatingOnServer := StrToFloatDefInv(selectedItem.SubItems[1], -1);
        cutlist.RatingCountOnServer := StrToIntDef(selectedItem.SubItems[2], -1);
        cutlist.DownloadTime := DateTimeToUnix(Now);
        IF Settings.AutoSaveDownloadedCutlists AND (cutlist.SavedToFilename <> '') THEN
          cutlist.AddServerInfos(cutlist.SavedToFilename);
      END;
    END;
    self.actSendRating.Enabled := Cutlist.IDOnServer <> '';
  END;
  Result := true;
END;

FUNCTION TFMain.SendRating(Cutlist: TCutlist): boolean;
CONST
  php_name                         = 'rate.php';
VAR
  Response, Error_message, url     : STRING;
BEGIN
  result := false;
  IF cutlist.IDOnServer = '' THEN BEGIN
    actSendRating.Enabled := false;
    IF NOT batchmode THEN
      Showmessage(CAResources.RsMsgSendRatingNotPossible);
    exit;
  END ELSE BEGIN
    IF (cutlist.RatingOnServer >= 0.0) AND cutlist.RatingByAuthorPresent THEN
      FCutlistRate.SelectedRating := Round(cutlist.RatingByAuthor + cutlist.RatingOnServer)
    ELSE IF cutlist.RatingOnServer >= 0.0 THEN
      FCutlistRate.SelectedRating := Round(cutlist.RatingOnServer)
    ELSE IF cutlist.RatingByAuthorPresent THEN
      FCutlistRate.SelectedRating := cutlist.RatingByAuthor
    ELSE
      FCutlistRate.SelectedRating := -1;
    IF FCutlistRate.ShowModal = mrOK THEN BEGIN
      Error_message := CAResources.RsErrorUnknown;
      url := settings.url_cutlists_home
        + php_name
        + '?rate=' + cutlist.IDOnServer
        + '&rating=' + inttostr(FCutlistRate.SelectedRating)
        + '&userid=' + settings.UserID
        + '&protocol=' + IntToStr(ServerProtocol)
        + '&' + Utils.GetVersionRequestParams;
      Result := DoHttpGet(url, true, Error_message, Response);

      IF result THEN BEGIN
        Error_Message := CheckResponse(Response, ServerProtocol, cscRate);
        IF Error_message = '' THEN BEGIN
          cutlist.RatingSent := FCutlistRate.SelectedRating;
          IF NOT batchmode THEN
            showmessage(CAResources.RsMsgSendRatingDone);
        END;
      END;
      IF NOT batchmode AND (Error_message <> '') THEN
        ShowMessageFmt(CAResources.RsMsgSendRatingNotDone + CAResources.RsMsgAnswerFromServer, [Error_message]);
    END;
  END;
END;

PROCEDURE TFMain.actSendRatingExecute(Sender: TObject);
BEGIN
  self.SendRating(cutlist);
END;

PROCEDURE TFMain.SampleGrabberSample(sender: TObject; SampleTime: Double;
  ASample: IMediaSample);
VAR
  pBuffer                          : PByte;
  BufferLen                        : Integer;
BEGIN
  IF NOT SampleInfo.Active THEN
    Exit;
  SampleInfo.SampleTime := SampleTime;
  SampleInfo.IsKeyFrame := ASample.IsSyncPoint() = S_OK;
  BufferLen := asample.GetActualDataLength();
  SampleInfo.HasBitmap := Succeeded(asample.GetPointer(pBuffer));
  IF SampleInfo.HasBitmap THEN BEGIN
    self.CustomGetSampleGrabberBitmap(SampleInfo.Bitmap, pBuffer, BufferLen);
  END;
END;

PROCEDURE TFMain.KeyFrameGrabberSample(sender: TObject; SampleTime: Double;
  ASample: IMediaSample);
VAR
  IsKeyFrame                       : Boolean;
BEGIN
  IF NOT KeyFrameSampleInfo.Active THEN
    Exit;
  IsKeyFrame := ASample.IsSyncPoint() = S_OK;
  KeyFrameSampleInfo.SampleTime := SampleTime;
  KeyFrameSampleInfo.IsKeyFrame := IsKeyFrame;
END;

PROCEDURE TFMain.lvCutlistDblClick(Sender: TObject);
BEGIN
  self.actEditCut.Execute;
END;

FUNCTION TFMain.UploadCutlist(filename: STRING): boolean;
VAR
  Request                          : THttpRequest;
  Response, Answer                 : STRING;
  Cutlist_id                       : Integer;
  lines                            : TStringList;
  begin_answer                     : integer;
BEGIN
  result := false;

  IF fileexists(filename) THEN BEGIN
    Request := THttpRequest.Create(
      settings.url_cutlists_upload,
      true,
      CAResources.RsErrorUploadCutlist);
    Request.IsPostRequest := true;
    TRY
      WITH Request.PostData DO BEGIN
        AddFormField('MAX_FILE_SIZE', '1587200');
        AddFormField('confirm', 'true');
        AddFormField('type', 'blank');
        AddFormField('userid', settings.UserID);
        AddFormField('app', 'CutAssistant');
        AddFormField('version', Application_version);
        AddFile('userfile[]', filename, 'multipart/form-data');
      END;
      Result := DoHttpRequest(Request);
      Response := Request.Response;

      lines := TStringList.Create;
      TRY
        lines.Delimiter := #10;
        lines.NameValueSeparator := '=';
        lines.DelimitedText := Response;
        IF TryStrToInt(lines.values['id'], Cutlist_id) THEN BEGIN
          AddUploadDataEntry(Now, extractFileName(filename), Cutlist_id);
          UploadDataEntries.SaveToFile(UploadData_Path(true));
        END;
        begin_answer := LastDelimiter(#10, response) + 1;
        Answer := midstr(response, begin_answer, length(response) - begin_answer + 1); //Last Line
      FINALLY
        FreeAndNIL(lines);
      END;
      IF NOT batchmode THEN
        ShowMessageFmt(CAResources.RsMsgAnswerFromServer, [answer]);
    FINALLY
      FreeAndNil(Request);
    END;
  END;
END;

PROCEDURE TFMain.actDeleteCutlistFromServerExecute(Sender: TObject);
VAR
  datestring                       : STRING;
  idx                              : integer;
  entry                            : STRING;
  FUNCTION NextField(VAR s: STRING; CONST d: Char): STRING;
  BEGIN
    Result := '';
    WHILE (s <> '') DO BEGIN
      IF s[1] = d THEN BEGIN
        Delete(s, 1, 1);
        Break;
      END;
      Result := Result + s[1];
      Delete(s, 1, 1);
    END;
  END;
BEGIN
  IF FUploadList.Visible THEN
    exit;
  //Fill ListView
  FUploadList.lvLinklist.Clear;
  FOR idx := 0 TO UploadDataEntries.Count - 1 DO BEGIN
    entry := Copy(UploadDataEntries.Strings[idx], 1, MaxInt);
    WITH FUploadList.lvLinklist.Items.Add DO BEGIN
      Caption := NextField(entry, '=');
      SubItems.Add(NextField(entry, ';'));
      dateTimeToString(DateString, 'ddddd tt', StrToFloat(NextField(entry, ';')));
      SubItems.Add(DateString);
    END;
  END;

  //Show Dialog and delete cutlist
  IF (FUploadList.ShowModal = mrOK) AND (FUploadList.lvLinklist.SelCount = 1) THEN BEGIN
    IF self.DeleteCutlistFromServer(FUploadList.lvLinklist.Selected.Caption) THEN BEGIN
      //Success, so delete Record in upload list
      UploadDataEntries.Delete(FUploadList.lvLinklist.ItemIndex);
      UploadDataEntries.SaveToFile(UploadData_Path(true));
    END;
  END;
END;

FUNCTION TFMain.DeleteCutlistFromServer(CONST cutlist_id: STRING): boolean;
CONST
  php_name                         = 'delete_cutlist.php';
VAR
  url, Response, Error_message     : STRING;
BEGIN
  result := false;
  IF cutlist_id = '' THEN exit;

  Error_message := CAResources.RsErrorUnknown;
  url := settings.url_cutlists_home + php_name + '?'
    + 'cutlistid=' + cutlist_id
    + '&userid=' + settings.UserID
    + '&protocol=' + IntToStr(ServerProtocol)
    + '&' + Utils.GetVersionRequestParams;

  Result := DoHttpGet(url, true, Error_message, Response);

  IF Result THEN BEGIN
    Error_Message := CheckResponse(Response, ServerProtocol, cscDelete);
    IF NOT batchmode AND (Error_message <> '') THEN
      ShowMessage(Error_message);
  END;
END;

PROCEDURE TFMain.tbFilePosChannelPostPaint(Sender: TDSTrackBarEx;
  CONST ARect: TRect);
VAR
  scale                            : double;
  iCut                             : INteger;
  CutRect                          : TRect;
BEGIN
  IF MovieInfo.current_file_duration = 0 THEN exit;
  IF cutlist.Mode = clmTrim THEN
    TBFilePos.ChannelCanvas.Brush.Color := clgreen
  ELSE
    TBFilePos.ChannelCanvas.Brush.Color := clred;
  scale := (ARect.Right - ARect.Left) / MovieInfo.current_file_duration; //pixel per second
  CutRect := ARect;
  FOR iCut := 0 TO cutlist.Count - 1 DO BEGIN
    CutRect.Left := ARect.Left + round(Cutlist[iCut].pos_from * scale);
    CutRect.Right := ARect.Left + round(Cutlist[iCut].pos_to * scale);
    IF CutRect.right >= CutRect.Left THEN
      TBFilePos.ChannelCanvas.FillRect(CutRect);
  END;
END;

FUNCTION TFMain.AskForUserRating(Cutlist: TCutlist): boolean;
//true = user rated or decided not to rate, or no rating necessary
//false = abort operation
VAR
  userIsAuthor                     : boolean;
BEGIN
  result := false;
  userIsAuthor := Cutlist.Author = settings.UserName;
  IF (Cutlist.UserShouldSendRating) AND NOT userIsAuthor THEN BEGIN
    CASE (application.MessageBox(PChar(CAResources.RsMsgAskUserForRating), NIL, MB_YESNOCANCEL + MB_ICONQUESTION)) OF
      IDYES: BEGIN
          result := self.SendRating(Cutlist);
        END;
      IDNO: result := true;
    END;
  END ELSE result := true;
END;

PROCEDURE TFMain.WMCopyData(VAR msg: TWMCopyData);
BEGIN
  HandleSendCommandline(msg.CopyDataStruct^, HandleParameter);
END;

PROCEDURE TFMain.AddUploadDataEntry(CutlistDate: TDateTime; CutlistName: STRING; CutlistID: Integer);
BEGIN
  UploadDataEntries.Add(Format('%d=%s;%f', [CutlistID, CutlistName, CutlistDate]));
END;

PROCEDURE TFMain.HandleParameter(CONST param: STRING);
VAR
  FileList                         : TStringLIst;
BEGIN
  FileList := TStringList.Create;
  TRY
    FileList.Text := param;
    self.ProcessFileList(FileList, false);
  FINALLY
    FreeAndNIL(FileList);
  END;
END;

FUNCTION TFMain.GraphPlayPause: boolean;
BEGIN
  IF filtergraph.State = gsPlaying THEN BEGIN
    result := GraphPause;
  END ELSE BEGIN
    result := GraphPlay;
  END;
END;

FUNCTION TFMain.GraphPause: boolean;
BEGIN
  IF FilterGraph.State = gsPaused THEN Result := true
  ELSE Result := FilterGraph.Pause;
  IF Result THEN BEGIN
    self.cmdFF.Enabled := false;
    TBFilePos.TriggerTimer;
  END;
END;

FUNCTION TFMain.GraphPlay: boolean;
VAR
  ACurrent                         : double;
  ACut                             : TCut;
BEGIN
  IF FilterGraph.State = gsPlaying THEN
    Result := true
  ELSE BEGIN
    IF cbCutPreview.Checked THEN BEGIN
      ACurrent := CurrentPosition;
      ACut := Cutlist.FindCut(ACurrent);
      IF NOT Assigned(ACut) THEN
        ACut := Cutlist.FindCut(Cutlist.NextCutPos(ACurrent))
      ELSE IF ACut.pos_to <= ACurrent THEN
        ACut := Cutlist.FindCut(Cutlist.NextCutPos(ACurrent + MovieInfo.frame_duration));
      IF Assigned(ACut) THEN BEGIN
        JumpToEx(IfThen(ACurrent < ACut.pos_from, ACut.pos_from, ACurrent), ACut.pos_to);
      END;
    END;
    Result := FilterGraph.Play
  END;
  IF result THEN BEGIN
    self.cmdFF.Enabled := true;
    TBFilePos.TriggerTimer;
  END;
END;

PROCEDURE TFMain.VideoWindowClick(Sender: TObject);
BEGIN
  IF self.actPlayPause.Enabled THEN
    self.actPlayPause.Execute;
END;

PROCEDURE TFMain.tbRateChange(Sender: TObject);
VAR
  NewRate                          : double;
BEGIN
  NewRate := Power(2, (TBRate.Position / 8));
  filtergraph.Rate := newRate;

  lblCurrentRate_nl.Caption := floattostrF(filtergraph.Rate, ffFixed, 15, 3) + 'x';
END;

FUNCTION TFMain.CalcTrueRate(Interval: double): double;
//Interval: Interval since last call to CalcTrue Rate (same unit as current_position)
VAR
  pos, diff                        : double;
BEGIN
  result := 0;
  IF interval <= 0 THEN exit;

  pos := self.CurrentPosition;
  diff := pos - last_pos;
  last_pos := pos;
  IF diff > 0 THEN
    result := diff / Interval;
END;

PROCEDURE TFMain.lblCurrentRate_nlDblClick(Sender: TObject);
BEGIN
  TBRate.Position := 0;
END;

PROCEDURE TFMain.actNextCutExecute(Sender: TObject);
VAR
  CurPos, NewPos                   : double;
BEGIN
  CurPos := CurrentPosition;
  NewPos := cutlist.NextCutPos(CurPos + MovieInfo.frame_duration);
  IF NewPos >= 0 THEN BEGIN
    jumpTo(NewPos);
    UpdateCutControls(CurPos, NewPos);
  END;
END;

PROCEDURE TFMain.actPrevCutExecute(Sender: TObject);
VAR
  CurPos, NewPos                   : double;
BEGIN
  CurPos := CurrentPosition;
  NewPos := cutlist.PreviousCutPos(CurPos - MovieInfo.frame_duration);
  IF NewPos >= 0 THEN BEGIN
    jumpTo(NewPos);
    UpdateCutControls(CurPos, NewPos);
  END;
END;

PROCEDURE TFMain.UpdateCutControls(APreviousPos, ANewPos: double);
VAR
  APrevCutIndex, ACutIndex         : integer;
  APrevCut                         : TCut;
BEGIN
  APrevCutIndex := cutlist.FindCutIndex(APreviousPos);
  ACutIndex := cutlist.FindCutIndex(ANewPos);
  IF ACutIndex >= 0 THEN BEGIN
    lvCutlist.ItemIndex := ACutIndex;
    IF (self.edtFrom.Text = '') AND (self.edtTo.Text = '') THEN
      self.actEditCut.Execute
    ELSE IF APrevCutIndex >= 0 THEN BEGIN
      APrevCut := cutlist.Cut[APrevCutIndex];
      IF (self.edtFrom.Text = MovieInfo.FormatPosition(APrevCut.pos_from)) AND
        (self.edtTo.Text = MovieInfo.FormatPosition(APrevCut.pos_to)) THEN
        self.actEditCut.Execute;
    END;
  END;
END;

PROCEDURE TFMain.cmdFFMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
BEGIN
  self.FF_Start;
END;

PROCEDURE TFMain.FF_Start;
BEGIN
  filtergraph.Rate := filtergraph.Rate * 2;
END;

PROCEDURE TFMain.FF_Stop;
BEGIN
  self.TBRateChange(self);
END;

PROCEDURE TFMain.cmdFFMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
BEGIN
  self.FF_Stop;
END;

PROCEDURE TFMain.VideoWindowDblClick(Sender: TObject);
BEGIN
  ToggleFullScreen;
END;

FUNCTION TFMain.ToggleFullScreen: boolean;
//returns true if mode is now fullscreen
BEGIN
  IF MovieInfo.MovieLoaded THEN self.VideoWindow.FullScreen := NOT self.VideoWindow.FullScreen;
  result := self.VideoWindow.FullScreen;
END;

PROCEDURE TFMain.actFullScreenExecute(Sender: TObject);
BEGIN
  self.actFullScreen.Checked := ToggleFullScreen;
END;

PROCEDURE TFMain.VideoWindowKeyDown(Sender: TObject; VAR Key: Word;
  Shift: TShiftState);
BEGIN
  IF (Key = VK_ESCAPE) AND self.VideoWindow.FullScreen THEN BEGIN
    self.actFullScreenExecute(Sender);
  END;
END;

PROCEDURE TFMain.actCloseMovieExecute(Sender: TObject);
BEGIN
  self.CloseMovieAndCutlist;
END;

FUNCTION TFMain.CloseCutlist: boolean;
BEGIN
  result := false;
  IF NOT AskForUserRating(cutlist) THEN exit;
  IF NOT CutList.clear_after_confirm THEN exit;
  result := true;
END;

FUNCTION TFMain.CloseMovieAndCutlist: boolean;
BEGIN
  result := false;
  IF NOT CloseCutlist THEN exit;
  IF movieInfo.MovieLoaded THEN CloseMovie;
  result := true;
END;

FUNCTION TFMain.DownloadCutlistByID(CONST cutlist_id, TargetFileName: STRING): boolean;
CONST
  php_name                         = 'getfile.php';
  Command                          = '?id=';
VAR
  url, message_string              : STRING;
  error_message, Response          : STRING;
  cutlistfile                      : TMemIniFileEx;
  target_file, cutlist_path        : STRING;
BEGIN
  result := false;
  CASE Settings.SaveCutlistMode OF
    smWithSource: BEGIN //with source
        cutlist_path := extractFilePath(MovieInfo.current_filename);
      END;
    smGivenDir: BEGIN //in given Dir
        cutlist_path := includeTrailingBackslash(Settings.CutlistSaveDir);
      END;
  ELSE BEGIN //with source
      cutlist_path := extractFilePath(MovieInfo.current_filename);
    END;
  END;
  target_file := cutlist_path + TargetFileName;

  IF cutlist.HasChanged AND (NOT batchmode) THEN BEGIN
    message_string := Format(CAResources.RsDownloadCutlistWarnChanged, [TargetFileName, cutlist_id]);
    IF NOT (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONINFORMATION) = IDYES) THEN BEGIN
      exit;
    END;
  END;

  Error_message := CAResources.RsErrorUnknown;
  url := settings.url_cutlists_home + php_name + command + cleanurl(cutlist_id)
    + '&' + Utils.GetVersionRequestParams;

  IF NOT DoHttpGet(url, false, error_message, Response) THEN BEGIN
    IF NOT batchmode THEN BEGIN
      message_string := Error_message + #13#10 + CAResources.RsMsgOpenHomepage;
      IF (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONQUESTION) = IDYES) THEN BEGIN
        ShellExecute(0, NIL, PChar(settings.url_cutlists_home), '', '', SW_SHOWNORMAL);
      END;
    END;
  END ELSE BEGIN
    IF (Length(Response) < 5) THEN BEGIN
      IF NOT batchmode THEN
        ShowMessageFmt(CAResources.RsDownloadCutlistInvalidData, [Length(Response)]);
      Exit;
    END;

    cutlistfile := TMemIniFileEx.Create('');
    TRY
      cutlistfile.LoadFromString(Response);
      cutlist.LoadFrom(cutlistfile, batchmode);

      IF Settings.AutoSaveDownloadedCutlists THEN BEGIN
        IF NOT ForceDirectories(cutlist_path) THEN BEGIN
          IF NOT batchmode THEN
            ShowMessageFmt(CAResources.RsErrorCreatePathFailedAbort, [cutlist_path]);
        END ELSE BEGIN
          IF fileexists(target_file) THEN BEGIN
            IF NOT batchmode THEN BEGIN
              message_string := Format(CAResources.RsWarnTargetExistsOverwrite, [target_file]);
              IF NOT (application.messagebox(PChar(message_string), NIL, MB_YESNO + MB_ICONQUESTION) = IDYES) THEN BEGIN
                exit;
              END;
            END;
            IF NOT DeleteFile(target_file) THEN BEGIN
              IF NOT batchmode THEN
                ShowMessageFmt(CAResources.RsErrorDeleteFileFailedAbort, [target_file]);
              exit;
            END;
          END;

          //cutlistfile.SaveToFile(target_file);
          //cutlist.SavedToFilename := target_file;
          cutlist.SaveAs(target_file);
        END;
      END;

      Result := true;
    FINALLY
      FreeAndNil(cutlistfile);
    END;
  END;
END;

FUNCTION TFMain.ConvertUploadData: boolean;
VAR
  RowDataNode, RowNode             : TJCLSimpleXMLElem;
  idx, cntNew                      : integer;
  CutlistID                        : integer;
  CutlistDate                      : TDateTime;
  CutlistIDStr, CutlistName, CutlistDateStr: STRING;
BEGIN
  Result := false;
  IF NOT FileExists(UploadData_Path(false)) THEN
    Exit;

  cntNew := 0;

  XMLResponse.LoadFromFile(UploadData_Path(false));
  TRY
    RowDataNode := XMLResponse.Root.Items.ItemNamed['ROWDATA'];
    IF RowDataNode <> NIL THEN BEGIN
      FOR idx := 0 TO RowDataNode.Items.Count - 1 DO BEGIN
        RowNode := RowDataNode.Items.Item[idx];
        IF RowNode <> NIL THEN BEGIN
          CutlistIDStr := RowNode.Properties.Value('id', '0');
          CutlistID := StrToIntDef(CutlistIDStr, 0);
          CutlistName := RowNode.Properties.Value('name', '');
          CutlistDateStr := RowNode.Properties.Value('DateTime', '');
          IF Length(CutlistDateStr) > 9 THEN BEGIN
            CutlistDate := DateTimeStrEval('YYYYMMDDTHH:NN:SSZZZ', CutlistDateStr);
          END
          ELSE BEGIN
            CutlistDate := DateTimeStrEval('YYYYMMDD', CutlistDateStr);
          END;
          IF (CutlistID > 0) AND (UploadDataEntries.IndexOfName(CutlistIDStr) < 0) THEN BEGIN
            AddUploadDataEntry(CutlistDate, CutlistName, CutlistID);
            Inc(cntNew);
          END;
        END;
      END;
    END;
    IF cntNew > 0 THEN BEGIN
      UploadDataEntries.SaveToFile(UploadData_Path(true));
    END;
    IF FileExists(UploadData_Path(false)) THEN BEGIN
      RenameFile(UploadData_Path(false), UploadData_Path(false) + '.BAK');
    END;
  EXCEPT
    ON E: EJclSimpleXMLError DO BEGIN
      IF NOT batchmode THEN
        ShowMessageFmt(CAResources.RsErrorConvertUploadData, [E.Message]);
    END;
  END;
END;

FUNCTION GetXMLMessage(CONST Node: TJCLSimpleXMLElem; CONST ItemName: STRING; CONST LastChecked: TDateTime): STRING;
VAR
  Msg                              : TJCLSimpleXMLElems;
  datum                            : TDateTime;
  FUNCTION ItemStr(CONST AName: STRING): STRING;
  VAR Item                         : TJCLSimpleXMLElem;
  BEGIN
    Item := Msg.ItemNamed[AName];
    IF Item = NIL THEN Result := ''
    ELSE Result := Item.Value;
  END;
  FUNCTION ItemInt(CONST AName: STRING): integer;
  BEGIN
    Result := StrToIntDef(ItemStr(AName), -1);
  END;
BEGIN
  Result := '';
  Msg := Node.Items;
  IF NOT TryEncodeDate(
    ItemInt('date_year'), ItemInt('date_month'), ItemInt('date_day'),
    Datum
    ) THEN exit;
  IF LastChecked <= Datum THEN BEGIN
    Result := '[' + DateToStr(Datum) + '] ' + ItemStr(ItemName);
  END;
END;

FUNCTION GetXMLMessages(CONST Node: TJCLSimpleXMLElem; CONST LastChecked: TDateTime; CONST name: STRING): STRING;
VAR
  MsgList                          : TJCLSimpleXMLElems;
  s                                : STRING;
  idx                              : integer;
BEGIN
  Result := '';
  MsgList := Node.Items.ItemNamed[name].Items;
  IF MsgList.Count > 0 THEN BEGIN
    FOR idx := 0 TO MsgList.Count - 1 DO BEGIN
      s := GetXMLMessage(MsgList.Item[idx], 'text', LastChecked);
      IF Length(s) > 0 THEN BEGIN
        Result := Result + #13#10#13#10 + s;
      END;
    END;
  END;
END;

FUNCTION TFMain.DownloadInfo(settings: TSettings; CONST UseDate, ShowAll: boolean): boolean;
VAR
  error_message, url, AText, ResponseText: STRING;
  lastChecked                      : TDateTime;
  //f: textFile;
BEGIN
  result := false;
  lastChecked := settings.InfoLastChecked;
  IF UseDate THEN
    IF NOT (daysBetween(lastChecked, SysUtils.Date) >= settings.InfoCheckInterval) THEN
      exit;
  IF ShowAll THEN
    lastChecked := 0;

  Error_message := CAResources.RsErrorUnknown;
  url := settings.url_info_file + '?' + Utils.GetVersionRequestParams;

  Error_message := CAResources.RsErrorDownloadInfo;
  Result := DoHttpGet(url, false, Error_message, ResponseText);

  IF Result THEN BEGIN
    TRY
      IF Length(ResponseText) > 5 THEN BEGIN
        XMLResponse.LoadFromString(ResponseText);

        IF XMLResponse.Root.ChildsCount > 0 THEN BEGIN
          IF settings.InfoShowMessages THEN BEGIN
            AText := GetXMLMessages(XMLResponse.Root, lastChecked, 'messages');
            IF Length(AText) > 0 THEN
              IF NOT batchmode THEN
                ShowMessageFmt(CAResources.RsMsgInfoMessage, [AText]);
          END;
          IF settings.InfoShowBeta THEN BEGIN
            AText := GetXMLMessage(XMLResponse.Root.Items.ItemNamed['beta'], 'version_text', lastChecked);
            IF Length(AText) > 0 THEN
              IF NOT batchmode THEN
                ShowMessageFmt(CAResources.RsMsgInfoDevelopment, [AText]);
          END;
          IF settings.InfoShowStable THEN BEGIN
            AText := GetXMLMessage(XMLResponse.Root.Items.ItemNamed['stable'], 'version_text', lastChecked);
            IF Length(AText) > 0 THEN
              IF NOT batchmode THEN
                ShowMessageFmt(CAResources.RsMsgInfoStable, [AText]);
          END;
          Result := true;
        END;
      END;
      settings.InfoLastChecked := sysutils.Date;
    EXCEPT
      ON E: EJclSimpleXMLError DO BEGIN
        IF NOT batchmode THEN
          ShowMessageFmt(CAResources.RsErrorDownloadInfoXml, [error_message, E.Message]);
      END;
    ELSE BEGIN
        RAISE;
      END;
    END;
  END;
END;

PROCEDURE TFMain.actSnapshotCopyExecute(Sender: TObject);
BEGIN
  IF mnuVideo.PopupComponent IS TImage THEN BEGIN
    clipboard.Assign((mnuVideo.PopupComponent AS TImage).Picture.Bitmap);
  END
  ELSE IF mnuVideo.PopupComponent = VideoWindow THEN BEGIN
    IF NOT assigned(seeking) THEN
      exit;
    SampleInfo.Active := true;
    SampleInfo.SampleTime := -1;
    TRY
      jumpto(currentPosition);
      WaitForFiltergraph;
      IF SampleInfo.SampleTime >= 0 THEN BEGIN
        IF SampleInfo.HasBitmap THEN
          Clipboard.Assign(SampleInfo.Bitmap);
      END;
    FINALLY
      SampleInfo.Active := false;
    END;
  END;
END;

PROCEDURE TFMain.actSnapshotSaveExecute(Sender: TObject);
CONST
  BMP_EXTENSION                    = '.bmp';
  JPG_EXTENSION                    = '.jpg';

  FUNCTION AskForFileName(VAR FileName: STRING; VAR FileType: Integer): boolean;
  VAR
    saveDlg                        : TSaveDialog;
    DefaultExt                     : STRING;
  BEGIN
    result := false;
    saveDlg := TSaveDialog.Create(Application.MainForm);
    TRY
      saveDlg.Filter := MakeFilterString(CAResources.RsFilterDescriptionBitmap, '*' + BMP_EXTENSION) + '|'
        + MakeFilterString(CAResources.RsFilterDescriptionJpeg, '*' + JPG_EXTENSION) + '|'
        + MakeFilterString(CAResources.RsFilterDescriptionAll, '*.*');
      saveDlg.FilterIndex := 2;
      saveDlg.Title := CAResources.RsTitleSaveSnapshot;
      //saveDlg.InitialDir := '';
      saveDlg.filename := fileName;
      saveDlg.options := saveDlg.Options + [ofOverwritePrompt, ofPathMustExist];
      IF saveDlg.Execute THEN BEGIN
        result := true;
        FileName := saveDlg.FileName;
        FileType := saveDlg.FilterIndex;
        CASE FileType OF
          1: BEGIN
              DefaultExt := BMP_EXTENSION;
            END;
        ELSE BEGIN
            FileType := 2;
            DefaultExt := JPG_EXTENSION;
          END;
        END;
        IF extractFileExt(FileName) <> DefaultExt THEN FileName := FileName + DefaultExt;
      END;
    FINALLY
      FreeAndNIL(saveDlg);
    END;
  END;

VAR
  tempBitmap                       : TBitmap;
  position                         : double;
  posString,
    fileName                       : STRING;
  FileType                         : Integer;
BEGIN
  IF filtergraph.State = gsPlaying THEN GraphPause;

  position := -1;
  tempBitmap := NIL;

  IF mnuVideo.PopupComponent IS TImage THEN BEGIN
    position := (mnuVideo.PopupComponent.Owner AS TCutFrame).position;
    tempBitmap := (mnuVideo.PopupComponent AS TImage).Picture.Bitmap;
  END
  ELSE IF mnuVideo.PopupComponent = VideoWindow THEN BEGIN
    IF NOT assigned(seeking) THEN
      exit;

    SampleInfo.Active := true;
    SampleInfo.SampleTime := -1;
    TRY
      jumpto(currentPosition);
      WaitForFiltergraph;
      IF SampleInfo.SampleTime >= 0 THEN BEGIN
        position := SampleInfo.SampleTime;
        IF SampleInfo.HasBitmap THEN
          tempBitmap := SampleInfo.Bitmap;
      END;
    FINALLY
      SampleInfo.Active := false;
    END;
  END;

  IF Assigned(tempBitmap) THEN BEGIN
    posString := movieInfo.FormatPosition(position);
    posString := ansireplacetext(posString, ':', '''');
    fileName := extractfilename(MovieInfo.current_filename);
    fileName := changeFileExt(fileName, '_' + cleanFileName(posString));

    IF NOT AskForFileName(FileName, FileType) THEN exit;

    IF FileType = 1 THEN BEGIN
      TempBitmap.SaveToFile(FileName);
    END ELSE BEGIN
      SaveBitmapAsJPEG(TempBitmap, FileName);
    END;
  END;
END;

FUNCTION TFMain.CreateMPlayerEDL(cutlist: TCutlist; Inputfile,
  Outputfile: STRING; VAR scriptfile: STRING): boolean;
CONST
  EDL_EXTENSION                    = '.edl';
VAR
  f                                : Textfile;
  i                                : integer;
  cutlist_tmp                      : TCutlist;
BEGIN
  IF scriptfile = '' THEN
    scriptfile := Inputfile + EDL_EXTENSION;
  assignfile(f, scriptfile);
  rewrite(f);
  TRY
    IF cutlist.Mode = clmCutOut THEN BEGIN
      cutlist.sort;
      FOR i := 0 TO cutlist.Count - 1 DO BEGIN
        writeln(f, FloatToStrInvariant(cutlist.Cut[i].pos_from) + ' ' + FloatToStrInvariant(cutlist.Cut[i].pos_to) + ' 0');
      END;
    END ELSE BEGIN
      cutlist_tmp := cutlist.convert;
      FOR i := 0 TO cutlist_tmp.Count - 1 DO BEGIN
        writeln(f, FloatToStrInvariant(cutlist_tmp.Cut[i].pos_from) + ' ' + FloatToStrInvariant(cutlist_tmp.Cut[i].pos_to) + ' 0');
      END;
      FreeAndNIL(cutlist_tmp);
    END;
  FINALLY
    closefile(f);
  END;
  result := true;
END;

PROCEDURE TFMain.actPlayInMPlayerAndSkipExecute(Sender: TObject);
VAR
  edlfile, AppPath, command, message_string: STRING;
BEGIN
  edlfile := '';
  IF NOT MovieInfo.MovieLoaded THEN exit;
  AppPath := settings.MplayerPath;
  IF NOT fileexists(AppPath) THEN exit;
  command := MovieInfo.current_filename;
  IF cutlist.count > 0 THEN BEGIN
    IF NOT self.CreateMPlayerEDL(cutlist, MovieInfo.current_filename, '', edlfile) THEN exit;
    command := command + ' -edl ' + edlfile;
  END;
  IF NOT CallApplication(AppPath, Command, message_string) THEN BEGIN
    IF NOT batchmode THEN
      ShowMessageFmt(CAResources.RsErrorExternalCall, [extractFilename(AppPath), message_string]);
  END;
END;

PROCEDURE TFMain.ResetForm;
BEGIN
  pos_from := 0;
  pos_to := 0;

  self.Caption := Application_Friendly_Name;
  application.Title := Application_Friendly_Name;

  self.actOpenCutlist.Enabled := false;
  self.actSearchCutlistByFileSize.Enabled := false;
  self.actSearchCutlistLocal.Enabled := false;
  self.EnableMovieControls(false);
  self.actStepForward.Enabled := false;

  self.tbFinePos.Position := 5; // ToDO: save standard in settings
  tbFinePos.Tag := tbFinePos.Position;
  self.tbFilePos.PageSize := self.tbFinePos.Position;

  self.lblDuration_nl.Caption := FormatMoviePosition(0);
  self.lblPos_nl.Caption := FormatMoviePosition(0);
  self.UpdateMovieInfoControls;
END;

PROCEDURE TFMain.EnableMovieControls(value: boolean);
BEGIN
  self.actNextFrames.Enabled := value;
  self.actCurrentFrames.Enabled := value;
  self.actPrevFrames.Enabled := value;
  self.TBFilePos.Enabled := value;
  self.tbFinePos.Enabled := value;
  self.actSmallSkipForward.Enabled := value;
  self.actLargeSkipForward.Enabled := value;
  self.actStepBackward.Enabled := value;
  self.actSmallSkipBackward.Enabled := value;
  self.actLargeSkipBackward.Enabled := value;
  self.actPlayPause.Enabled := value;
  self.actPlay.Enabled := value;
  self.actPause.Enabled := value;
  self.actStop.Enabled := value;
  IF value AND MovieInfo.CanStepForward THEN BEGIN
    self.actStepForward.Enabled := true;
  END ELSE BEGIN
    self.actStepForward.Enabled := false;
  END;
  self.actJumpCutStart.Enabled := value;
  self.actJumpCutEnd.Enabled := value;
  self.actSetCutStart.Enabled := value;
  self.actSetCutEnd.Enabled := value;
  self.cmdFromStart.Enabled := value;
  self.cmdToEnd.Enabled := value;
  //self.BPlayPause.Enabled := APlayPause.Enabled;
END;

FUNCTION TFMain.BuildFilterGraph(FileName: STRING;
  FileType: TMovieType): boolean;
BEGIN
  result := false;
END;

FUNCTION TFMain.GetSampleGrabberMediaType(VAR MediaType: TAMMediaType): HResult;
//Fix because SampleGrabber does not set right media type:
//SampleGrabber has wrong resolution in MediaType if videowindow
//is smaller than native resolution
VAR
  SourcePin                        : IPin;
  InPin                            : IPin;
BEGIN
  InPin := SampleGrabber.InPutPin;
  Result := InPin.ConnectedTo(SourcePin);
  IF Result <> S_OK THEN BEGIN
    exit;
  END;
  Result := SourcePin.ConnectionMediaType(MediaType)
END;

FUNCTION TFMain.CustomGetSampleGrabberBitmap(Bitmap: TBitmap; Buffer: Pointer; BufferLen: Integer): Boolean;
//Fix because SampleGrabber does not set right media type:
//SampleGrabber has wrong resolution in MediaType if videowindow
//is smaller than native resolution
//This function is copied from DSPack but uses MediaType from upstream filter
  FUNCTION GetDIBLineSize(BitCount, Width: Integer): Integer;
  BEGIN
    IF BitCount = 15 THEN
      BitCount := 16;
    Result := ((BitCount * Width + 31) DIV 32) * 4;
  END;
VAR
  hr                               : HRESULT;
  BIHeaderPtr                      : PBitmapInfoHeader;
  MediaType                        : TAMMediaType;
  BitmapHandle                     : HBitmap;
  DIBPtr                           : Pointer;
  DIBSize                          : LongInt;
BEGIN
  Result := False;
  IF NOT Assigned(Bitmap) THEN
    Exit;
  IF Assigned(Buffer) AND (BufferLen = 0) THEN
    Exit;
  hr := self.GetSampleGrabberMediaType(MediaType); // <-- Changed
  IF hr <> S_OK THEN
    Exit;
  TRY
    IF IsEqualGUID(MediaType.majortype, MEDIATYPE_Video) THEN BEGIN
      BIHeaderPtr := NIL;
      IF IsEqualGUID(MediaType.formattype, FORMAT_VideoInfo) THEN BEGIN
        IF MediaType.cbFormat = SizeOf(TVideoInfoHeader) THEN // check size
          BIHeaderPtr := @(PVideoInfoHeader(MediaType.pbFormat)^.bmiHeader);
      END
      ELSE IF IsEqualGUID(MediaType.formattype, FORMAT_VideoInfo2) THEN BEGIN
        IF MediaType.cbFormat = SizeOf(TVideoInfoHeader2) THEN // check size
          BIHeaderPtr := @(PVideoInfoHeader2(MediaType.pbFormat)^.bmiHeader);
      END;
      // check, whether format is supported by TSampleGrabber
      IF NOT Assigned(BIHeaderPtr) THEN
        Exit;
      BitmapHandle := CreateDIBSection(0, PBitmapInfo(BIHeaderPtr)^,
        DIB_RGB_COLORS, DIBPtr, 0, 0);
      IF BitmapHandle <> 0 THEN BEGIN
        TRY
          IF DIBPtr = NIL THEN
            Exit;
          // get DIB size
          DIBSize := BIHeaderPtr^.biSizeImage;
          IF DIBSize = 0 THEN BEGIN
            WITH BIHeaderPtr^ DO
              DIBSize := GetDIBLineSize(biBitCount, biWidth) * biHeight * biPlanes;
          END;
          // copy DIB
          IF NOT Assigned(Buffer) THEN BEGIN
            Exit; // <-- changed
          END
          ELSE BEGIN
            IF BufferLen > DIBSize THEN // copy Min(BufferLen, DIBSize)
              BufferLen := DIBSize;
            Move(Buffer^, DIBPtr^, BufferLen);
          END;
          Bitmap.Handle := BitmapHandle;
          Result := True;
        FINALLY
          IF Bitmap.Handle <> BitmapHandle THEN // preserve for any changes in Graphics.pas
            DeleteObject(BitmapHandle);
        END;
      END;
    END;
  FINALLY
    FreeMediaType(@MediaType);
  END;
END;

FUNCTION TFMain.FilterGraphSelectedFilter(Moniker: IMoniker;
  FilterName: WideString; ClassID: TGUID): Boolean;
BEGIN
  result := NOT settings.FilterIsInBlackList(ClassID);
END;

PROCEDURE TFMain.FramePopUpPrevious12FramesClick(Sender: TObject);
BEGIN
  IF mnuVideo.PopupComponent = VideoWindow THEN BEGIN
    self.actPrevFrames.Execute;
  END;
  IF mnuVideo.PopupComponent IS TImage THEN BEGIN
    ((mnuVideo.PopupComponent AS TImage).Owner AS TCutFrame).ImageDoubleClick(mnuVideo.PopupComponent);
    self.actPrevFrames.Execute;
  END;
END;

PROCEDURE TFMain.FramePopUpNext12FramesClick(Sender: TObject);
BEGIN
  IF mnuVideo.PopupComponent = VideoWindow THEN BEGIN
    self.actNextFrames.Execute;
  END;
  IF mnuVideo.PopupComponent IS TImage THEN BEGIN
    ((mnuVideo.PopupComponent AS TImage).Owner AS TCutFrame).ImageDoubleClick(mnuVideo.PopupComponent);
    self.actNextFrames.Execute;
  END;
END;

PROCEDURE TFMain.actShowLoggingExecute(Sender: TObject);
BEGIN
  IF NOT FLogging.Visible THEN BEGIN
    FLogging.Width := Self.Width;
    FLogging.Top := Self.Top + Self.Height + 1;
    FLogging.Left := Self.Left;
  END;
  FLogging.Visible := true;
END;

PROCEDURE TFMain.actTestExceptionHandlingExecute(Sender: TObject);
BEGIN
  RAISE Exception.Create('Exception handling test at ' + FormatDateTime('', Now));
END;

PROCEDURE TFMain.actCheckInfoOnServerExecute(Sender: TObject);
BEGIN
  self.DownloadInfo(Settings, false, Utils.ShiftDown);
END;

PROCEDURE TFMain.actOpenCutassistantHomeExecute(Sender: TObject);
BEGIN
  ShellExecute(0, NIL, 'http://sourceforge.net/projects/cutassistant/', '', '', SW_SHOWNORMAL);
END;

PROCEDURE TFMain.FormShow(Sender: TObject);
VAR
  message_string                   : STRING;
BEGIN
  IF settings.NewSettingsCreated THEN
    actEditSettings.Execute
  ELSE IF NOT BatchMode THEN BEGIN
    // Verify settings
    IF settings.url_info_file <> DEFAULT_UPDATE_XML THEN BEGIN
      IF settings.Additional['UseCustomInfoXml'] <> '1' THEN BEGIN
        message_string := Format(CAResources.RsUseCustomInfoXml, [Settings.url_info_file, DEFAULT_UPDATE_XML]);
        IF Application.MessageBox(PChar(message_string), NIL, MB_YESNO + MB_ICONQUESTION) <> IDYES THEN
          settings.Additional['UseCustomInfoXml'] := '1'
        ELSE
          settings.url_info_file := DEFAULT_UPDATE_XML;
      END;
    END;
  END;
  IF settings.CheckInfos THEN
    self.DownloadInfo(settings, true, false);
END;

FUNCTION TFMain.DoHttpGet(CONST url: STRING; CONST handleRedirects: boolean; CONST Error_message: STRING; VAR Response: STRING): boolean;
VAR
  data                             : THttpRequest;
BEGIN
  data := THttpRequest.Create(url, handleRedirects, Error_message);
  TRY
    Result := DoHttpRequest(data);
    Response := data.Response;
  FINALLY
    FreeAndNil(data);
  END;
END;

FUNCTION TFMain.DoHttpRequest(data: THttpRequest): boolean;
CONST
  SLEEP_TIME                       = 50;
  MAX_SLEEP                        = 10;
VAR
  idx                              : integer;
BEGIN
  RequestWorker.Start;
  RequestWorker.Data := data;

  idx := MAX_SLEEP;
  WHILE idx > 0 DO BEGIN
    Dec(idx);
    Sleep(SLEEP_TIME);
    IF RequestWorker.Stopped THEN
      Break;
  END;
  IF NOT RequestWorker.Stopped THEN
    dlgRequestProgress.Execute;

  Result := HandleWorkerException(data);
END;

FUNCTION TFMain.HandleWorkerException(data: THttpRequest): boolean;
VAR
  excClass                         : TClass;
  url, msg                         : STRING;
  idx                              : integer;
BEGIN
  IF RequestWorker.ReturnValue = 0 THEN BEGIN
    Result := true;
    Exit;
  END;

  Result := false;
  excClass := RequestWorker.TerminatingExceptionClass;
  IF excClass <> NIL THEN BEGIN
    msg := RequestWorker.TerminatingException;
    IF excClass.InheritsFrom(EIdProtocolReplyError) THEN BEGIN
      CASE RequestWorker.ReturnValue OF
        404, 302: BEGIN
            url := data.Url;
            idx := Pos('?', url);
            IF idx < 1 THEN idx := Length(url)
            ELSE Dec(idx);
            msg := Format(CAResources.RsErrorHttpFileNotFound, [StringReplace(Copy(url, 1, idx), '&', '&&', [rfReplaceAll])]);
          END;
      END;
    END;
    IF NOT batchmode THEN
      ShowMessage(data.ErrorMessage + msg);
  END;
END;

PROCEDURE TFMain.dlgRequestProgressShow(Sender: TObject);
VAR
  dlg                              : TJvProgressDialog;
BEGIN
  dlg := Sender AS TJvProgressDialog;
  Assert(Assigned(dlg));
  dlg.Position := 30;
END;

PROCEDURE TFMain.dlgRequestProgressCancel(Sender: TObject);
BEGIN
  WebRequest_nl.DisconnectSocket;
  RequestWorker.WaitFor;
END;

PROCEDURE TFMain.dlgRequestProgressProgress(Sender: TObject;
  VAR AContinue: Boolean);
VAR
  dlg                              : TJvProgressDialog;
BEGIN
  dlg := Sender AS TJvProgressDialog;
  IF dlg.Position = dlg.Max THEN dlg.Position := dlg.Min
  ELSE dlg.Position := dlg.Position + 2;
  IF RequestWorker.ReturnValue >= 0 THEN
    dlg.Interval := 0;
  IF RequestWorker.ReturnValue > 0 THEN
    AContinue := false;
END;

PROCEDURE TFMain.RequestWorkerRun(Sender: TIdCustomThreadComponent);
VAR
  data                             : THttpRequest;
  Response                         : STRING;
BEGIN
  Assert(Assigned(Sender));
  IF Assigned(Sender.Thread) THEN
    NameThread(Sender.Thread.ThreadID, 'RequestWorker');
  data := Sender.Data AS THttpRequest;
  IF NOT Assigned(data) THEN {// busy wait for data object ...} BEGIN
    Sleep(10);
    Exit;
  END;
  Sender.ReturnValue := -1;
  TRY
    WebRequest_nl.HandleRedirects := data.HandleRedirects;
    IF data.IsPostRequest THEN
      Response := WebRequest_nl.Post(data.Url, data.PostData)
    ELSE
      Response := WebRequest_nl.Get(data.Url);
    data.Response := Response;
  FINALLY
    // Only for testing purposes
    //Sleep(10000);
    IF NOT Sender.Terminated THEN
      Sender.Stop;
    IF Sender.ReturnValue < 0 THEN ;
    Sender.ReturnValue := 0;
  END;
END;

PROCEDURE TFMain.RequestWorkerException(Sender: TIdCustomThreadComponent;
  AException: Exception);
VAR
  data                             : THttpRequest;
BEGIN
  Assert(Assigned(Sender));
  IF NOT Assigned(Sender.Data) THEN BEGIN
    dlgRequestProgress.Text := CAResources.RsProgressTransferAborted;
  END
  ELSE BEGIN
    data := Sender.Data AS THttpRequest;
    dlgRequestProgress.Text := CAResources.RsErrorTransferAborting;
    data.Response := '';
  END;

  IF AException IS EIdProtocolReplyError THEN
    WITH AException AS EIdProtocolReplyError DO
      Sender.ReturnValue := ReplyErrorCode;
  IF Sender.ReturnValue <= 0 THEN
    Sender.ReturnValue := 1;

  Sender.Stop;
END;

PROCEDURE TFMain.WebRequest_nlStatus(ASender: TObject; CONST AStatus: TIdStatus;
  CONST AStatusText: STRING);
BEGIN
  dlgRequestProgress.Text := AStatusText;
END;

PROCEDURE TFMain.WebRequest_nlWork(Sender: TObject; AWorkMode: TWorkMode;
  CONST AWorkCount: Integer);
BEGIN
  CASE AWorkMode OF
    wmRead:
      dlgRequestProgress.Text := Format(CAResources.RsProgressReadData, [AWorkCount]);
    wmWrite:
      dlgRequestProgress.Text := Format(CAResources.RsProgressWroteData, [AWorkCount]);
  END;
END;


PROCEDURE TFMain.actSupportRequestExecute(Sender: TObject);
VAR
  AException                       : IMEException;
  AAssistant                       : INVAssistant;
  ABugReport                       : STRING;
  AScreenShot                      : INVBitmap;
  AMemo                            : INVEdit;
BEGIN
  AException := NewException(etHidden);
  AException.ListThreads := false;
  //AException.MailAddr := 'cutassistant-help@lists.sourceforge.net';
  AException.MailSubject := Format(CAResources.RsCutAssistantSupportRequest, [Application_Version]);

  AAssistant := AException.GetAssistant('SupportAssistant');
  AMemo := AAssistant.Form['SupportDetailsForm'].nvEdit('DetailsMemo');
  AScreenShot := AException.ScreenShot;
  IF AAssistant.ShowModal() = nvmOk THEN BEGIN
    ABugReport := AException.GetBugReport(true);
    AException.MailBody := AMemo.OutputName + #13#10 + StringOfChar('-', Length(AMemo.OutputName)) + #13#10 + AMemo.Text;
    SendBugReport(ABugReport, AScreenShot, self.Handle, AException);
  END;
END;

PROCEDURE TFMain.actStopExecute(Sender: TObject);
BEGIN
  GraphPause; //Set Play/Pause Button Caption
  jumpto(0);
  filtergraph.Stop;
END;

PROCEDURE TFMain.actPlayPauseExecute(Sender: TObject);
BEGIN
  GraphPlayPause;
END;

PROCEDURE TFMain.actPlayExecute(Sender: TObject);
BEGIN
  GraphPlay;
END;

PROCEDURE TFMain.actPauseExecute(Sender: TObject);
BEGIN
  GraphPause;
END;

PROCEDURE TFMain.FilterGraphGraphComplete(sender: TObject; Result: HRESULT;
  Renderer: IBaseFilter);
BEGIN
  IF cbCutPreview.Checked THEN BEGIN
    GraphPause;
    GraphPlay;
  END;
END;

PROCEDURE AppendToFile(CONST fileName: STRING; CONST text: STRING);
VAR
  f                                : TextFile;
BEGIN
  TRY
    OutputDebugString(PChar(text));
    AssignFile(f, fileName);
    FileMode := fmOpenWrite OR fmShareDenyWrite;
{$I-}
    Append(f);
    IF IOResult <> 0 THEN Rewrite(f);
    IF IOResult = 0 THEN WriteLn(f, text);
    Flush(f);
    CloseFile(f);
{$I+}
  EXCEPT
    // Ignore exception
  END;
END;

VAR
  DebugFile                        : STRING;
  InDebugHandler                   : boolean;

PROCEDURE DebugExceptionHandler(CONST exceptIntf: IMEException;
  VAR handled: boolean);
VAR
  bugReport                        : STRING;
BEGIN
  IF (DebugFile = '') OR InDebugHandler THEN
    Exit;
  IF exceptIntf.ExceptClass = 'EKdlSilentError' THEN
    Exit;
  InDebugHandler := true;
  TRY
    bugReport := exceptIntf.GetBugReport(true);
    AppendToFile(DebugFile, bugReport);
    //AutoSaveBugReport(bugReport);
  FINALLY
    InDebugHandler := false;
  END;
END;

PROCEDURE UpdateStaticSettings;
VAR
  ExceptionLogging                 : boolean;
BEGIN
  ExceptionLogging := true;
  IF Assigned(Settings) THEN BEGIN
    ExceptionLogging := Settings.ExceptionLogging;
  END;

  DebugFile := IfThen(ExceptionLogging, ChangeFileExt(Application.ExeName, '.debug.log'), '');
END;

PROCEDURE TFMain.actSetCutStartExecute(Sender: TObject);
BEGIN
  SetStartPosition(CurrentPosition);
END;

PROCEDURE TFMain.actSetCutEndExecute(Sender: TObject);
BEGIN
  SetStopPosition(CurrentPosition);
END;

PROCEDURE TFMain.actJumpCutStartExecute(Sender: TObject);
BEGIN
  JumpTo(pos_from);
END;

PROCEDURE TFMain.actJumpCutEndExecute(Sender: TObject);
BEGIN
  JumpTo(pos_to);
END;

PROCEDURE TFMain.actSelectNextCutExecute(Sender: TObject);
BEGIN
  WITH lvCutlist DO
    IF ItemIndex < Items.Count - 1 THEN
      ItemIndex := ItemIndex + 1;
END;

PROCEDURE TFMain.actSelectPrevCutExecute(Sender: TObject);
BEGIN
  WITH lvCutlist DO
    IF ItemIndex > 0 THEN
      ItemIndex := ItemIndex - 1;
END;

PROCEDURE TFMain.actShiftCutExecute(Sender: TObject);
VAR
  AParams                          : TJvParameterList;
  AShiftTime                       : TJvDoubleEditParameter;
  ACut                             : TCut;
  AShift                           : double;
BEGIN
  AParams := TJvParameterList.Create(self);
  TRY
    AShiftTime := TJvDoubleEditParameter.Create(AParams);
    AShiftTime.SearchName := 'Shift';
    AShiftTime.Caption := 'shift time';
    AShiftTime.AsDouble := StrToFloatDefInv(Settings.Additional['CutShiftTime'], Settings.SmallSkipTime);
    AShiftTime.Required := true;
    AParams.AddParameter(AShiftTime);
    AParams.ArrangeSettings.AutoArrange := true;

    IF AParams.ShowParameterDialog THEN BEGIN
      AShift := AShiftTime.AsDouble;
      Settings.Additional['CutShiftTime'] := FloatToStrInvariant(AShift);
      ACut := Cutlist.Cut[lvCutlist.ItemIndex];
      Cutlist.ReplaceCut(ACut.pos_from + AShift,
        ACut.pos_to + AShift,
        lvCutlist.ItemIndex);
    END;
  FINALLY
    AParams.Free;
  END;
END;

INITIALIZATION
  BEGIN
    Settings := NIL;
    UpdateStaticSettings;
    Randomize;

    InDebugHandler := false;
    RegisterHiddenExceptionHandler(DebugExceptionHandler, stDontSync);
    RegisterExceptionHandler(DebugExceptionHandler, stDontSync, epCompleteReport);

    FreeLocalizer.LanguageDir := Application_Dir;
    FreeLocalizer.ErrorProcessing := epErrors;

    Settings := TSettings.Create;
    Settings.load;

    UpdateStaticSettings;

    FreeLocalizer.AutoTranslate := Settings.LanguageFile <> '';
    IF FreeLocalizer.AutoTranslate THEN
      FreeLocalizer.LanguageFile := Settings.LanguageFile;

    //RegisterDSAMessage(1, 'CutlistRated', 'Cutlist rated');
    MovieInfo := TMovieInfo.Create;
    Cutlist := TCutList.Create(Settings, MovieInfo);
  END;

FINALIZATION
  BEGIN
    FreeAndNIL(Cutlist);
    FreeAndNIL(MovieInfo);
    Settings.save;
    FreeAndNIL(Settings);

    UnregisterExceptionHandler(DebugExceptionHandler);
    UnregisterHiddenExceptionHandler(DebugExceptionHandler);
  END;

END.

