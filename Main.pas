unit Main;

{$I Information.inc}

// basic review and reformatting: up to line 2969

interface

uses
  // Delphi
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, Winapi.ActiveX, Winapi.DirectShow9, Winapi.WMF9,

  System.SysUtils, System.DateUtils, System.Variants, System.Classes, System.IniFiles, System.Math, System.Actions,
  System.StrUtils, System.ImageList, System.Win.Registry, System.Win.ComObj,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.OleCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Menus, Vcl.ToolWin, Vcl.ActnList, Vcl.ImgList, Vcl.Clipbrd,

  // Indy
  IdComponent, IdThreadComponent, IdBaseComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdReplyRFC,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,

  // DSPack
  DSPack, DXSUtils, Unit_DSTrackBarEx,

  // Jedi
  JclSimpleXml, JvDialogs, JvComponentBase, JvAppCommand, JvBaseDlg, JvProgressDialog, JvExStdCtrls, JvCheckBox,
  JvSpeedbar, JvExExtCtrls, JvExtComponent, JvGIF, JvSimpleXml, JclDebug, JvDesktopAlert,

  // CA
  CodecSettings, CutlistInfo_dialog, ManageFilters, Movie, Settings_dialog, TrackBarEx, UCutlist, UploadList, Utils;

const
  // Registry Keys
  CutlistID            = 'CutAssistant.Cutlist';
  CUTLIST_CONTENT_TYPE = 'text/plain';
  ProgID               = 'Cut_Assistant.exe';
  ShellEditKey         = 'CutAssistant.edit';

type
  TFMain = class(TForm)
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
    actSplitCut: TAction;
    actMergeCut: TAction;
    cmdMergeCut: TButton;
    cmdSplitCut: TButton;
    actChangeStyle: TAction;
    JvSpeedItem18: TJvSpeedItem;
    mnuStyles: TPopupMenu;
    JvDesktopAlertStack: TJvDesktopAlertStack;
    IdSSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cmdFromStartClick(Sender: TObject);
    procedure cmdToEndClick(Sender: TObject);
    procedure actStepForwardExecute(Sender: TObject);
    procedure actStepBackwardExecute(Sender: TObject);
    procedure lvCutlistSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvCutlistDblClick(Sender: TObject);
    procedure rgCutModeClick(Sender: TObject);
    procedure tbVolumeChange(Sender: TObject);
    procedure cbMuteClick(Sender: TObject);
    procedure tbFilePosTimer(sender: TObject; CurrentPos, StopPos: Cardinal);
    procedure tbFilePosPositionChangedByMouse(Sender: TObject);
    procedure tbFilePosChange(Sender: TObject);
    procedure tbFilePosSelChanged(Sender: TObject);
    procedure tbFilePosChannelPostPaint(Sender: TDSTrackBarEx; const ARect: TRect);
    procedure tbFinePosChange(Sender: TObject);
    procedure FilterGraphGraphStepComplete(Sender: TObject);
    procedure pnlVideoWindowResize(Sender: TObject);
    procedure actOpenMovieExecute(Sender: TObject);
    procedure actOpenCutlistExecute(Sender: TObject);
    procedure actSaveCutlistExecute(Sender: TObject);
    procedure actSaveCutlistAsExecute(Sender: TObject);
    procedure actFileExitExecute(Sender: TObject);
    procedure actAddCutExecute(Sender: TObject);
    procedure actReplaceCutExecute(Sender: TObject);
    procedure actEditCutExecute(Sender: TObject);
    procedure actDeleteCutExecute(Sender: TObject);
    procedure cmdConvertClick(Sender: TObject);
    procedure actCutlistInfoExecute(Sender: TObject);
    procedure actSearchCutlistByFileSizeExecute(Sender: TObject);
    procedure actCutlistUploadExecute(Sender: TObject);
    procedure actSendRatingExecute(Sender: TObject);
    procedure actDeleteCutlistFromServerExecute(Sender: TObject);
    procedure actShowFramesFormExecute(Sender: TObject);
    procedure actNextFramesExecute(Sender: TObject);
    procedure actPrevFramesExecute(Sender: TObject);
    procedure actScanIntervalExecute(Sender: TObject);
    procedure actRepairMovieExecute(Sender: TObject);
    procedure actStartCuttingExecute(Sender: TObject);
    procedure actAsfbinInfoExecute(Sender: TObject);
    procedure actMovieMetaDataExecute(Sender: TObject);
    procedure actEditSettingsExecute(Sender: TObject);
    procedure actUsedFiltersExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actBrowseWWWHelpExecute(Sender: TObject);
    procedure actOpenCutlistHomeExecute(Sender: TObject);
    procedure actWriteToRegistyExecute(Sender: TObject);
    procedure actRemoveRegistryEntriesExecute(Sender: TObject);
    procedure actCalculateResultingTimesExecute(Sender: TObject);
    procedure VideoWindowClick(Sender: TObject);
    procedure tbRateChange(Sender: TObject);
    procedure lblCurrentRate_nlDblClick(Sender: TObject);
    procedure actNextCutExecute(Sender: TObject);
    procedure actPrevCutExecute(Sender: TObject);
    procedure cmdFFMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cmdFFMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VideoWindowDblClick(Sender: TObject);
    procedure actFullScreenExecute(Sender: TObject);
    procedure VideoWindowKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actCloseMovieExecute(Sender: TObject);
    procedure actSnapshotCopyExecute(Sender: TObject);
    procedure actSnapshotSaveExecute(Sender: TObject);
    procedure actPlayInMPlayerAndSkipExecute(Sender: TObject);
    function FilterGraphSelectedFilter(Moniker: IMoniker; FilterName: WideString; ClassID: TGUID): Boolean;
    procedure FramePopUpNext12FramesClick(Sender: TObject);
    procedure FramePopUpPrevious12FramesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actShowLoggingExecute(Sender: TObject);
    procedure actTestExceptionHandlingExecute(Sender: TObject);
    procedure actCheckInfoOnServerExecute(Sender: TObject);
    procedure actOpenCutassistantHomeExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dlgRequestProgressShow(Sender: TObject);
    procedure dlgRequestProgressProgress(Sender: TObject; var AContinue: Boolean);
    procedure RequestWorkerRun(Sender: TIdThreadComponent);
    procedure RequestWorkerException(Sender: TIdThreadComponent; AException: Exception);
    procedure WebRequest_nlStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure dlgRequestProgressCancel(Sender: TObject);
    procedure WebRequest_nlWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Int64);
    procedure actStopExecute(Sender: TObject);
    procedure actPlayPauseExecute(Sender: TObject);
    procedure actPlayExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure actCurrentFramesExecute(Sender: TObject);
    procedure FilterGraphGraphComplete(sender: TObject; Result: HRESULT; Renderer: IBaseFilter);
    procedure actSearchCutlistLocalExecute(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SampleGrabberSample(sender: TObject; SampleTime: Double; ASample: IMediaSample);
    procedure KeyFrameGrabberSample(sender: TObject; SampleTime: Double; ASample: IMediaSample);
    procedure actSetCutStartExecute(Sender: TObject);
    procedure actSetCutEndExecute(Sender: TObject);
    procedure actJumpCutStartExecute(Sender: TObject);
    procedure actJumpCutEndExecute(Sender: TObject);
    procedure actSelectNextCutExecute(Sender: TObject);
    procedure actSelectPrevCutExecute(Sender: TObject);
    procedure actShiftCutExecute(Sender: TObject);
    procedure AppCommandAppCommand(Handle: NativeUInt; Cmd: Word; Device: TJvAppCommandDevice; KeyState: Word; var Handled: Boolean);
    procedure actSplitCutExecute(Sender: TObject);
    procedure actMergeCutExecute(Sender: TObject);
    procedure actChangeStyleExecute(Sender: TObject);
  private
    { private declarations }
    UploadDataEntries: TStringList;
    StepComplete: Boolean;
    SampleInfo: RMediaSample;
    KeyFrameSampleInfo: RMediaSample;
    procedure ResetForm;
    procedure EnableMovieControls(Value: Boolean);
    procedure InitVideo;
    procedure InsertKeyFrameGrabber;
    procedure InsertSampleGrabber;
    function GetSampleGrabberMediaType(var MediaType: TAMMediaType): HResult;
    function CustomGetSampleGrabberBitmap(Bitmap: TBitmap; Buffer: Pointer; BufferLen: Integer): Boolean;
    {
    function SampleCB(SampleTime: Double; MediaSample: IMediaSample): HRESULT; stdcall;
    function  BufferCB(SampleTime: Double; pBuffer: PByte; BufferLen: longint): HResult; stdcall;
    }
    procedure refresh_lvCutlist(cutlist: TCutlist);
    function WaitForStep(TimeOut: Integer; const WaitForSampleInfo: Boolean): Boolean;
    procedure WaitForFilterGraph;
    procedure HandleParameter(const param: string);
    function CalcTrueRate(Interval: Double): Double;
    procedure FF_Start;
    procedure FF_Stop;
    function ConvertUploadData: Boolean;
    procedure AddUploadDataEntry(CutlistDate: TDateTime; CutlistName: string; CutlistID: Integer);
    procedure UpdateMovieInfoControls;
    procedure UpdatePlayPauseButton;
    procedure UpdateTrackBarPageSize;
    procedure UpdateVolume;
    procedure SelectStyleClick(Sender: TObject);
  public
    { public declarations }
    procedure ProcessFileList(FileList: TStringList; IsMyOwnCommandLine: Boolean);
    procedure refresh_times;
    procedure enable_del_buttons(Value: Boolean);
    function CurrentPosition: Double;
    procedure JumpTo(NewPosition: Double);
    procedure JumpToEx(NewPosition: Double; NewStop: Double);
    procedure SetStartPosition(Position: Double);
    procedure SetStopPosition(Position: Double);
    procedure ShowFrames(startframe, endframe: Integer);
    procedure ShowFramesAbs(startframe, endframe: Double; numberOfFrames: Integer);
    function OpenFile(FileName: string): Boolean;
    function BuildFilterGraph(FileName: string; FileType: TMovieType): Boolean;
    function CloseCutlist: Boolean;
    function CloseMovieAndCutlist: Boolean;
    procedure CloseMovie;
    function GraphPlayPause: Boolean;
    function GraphPlay: Boolean;
    function GraphPause: Boolean;
    function ToggleFullScreen: Boolean;
    procedure ShowMetaData;
    function RepairMovie: Boolean;
    function StartCutting: Boolean;
    //    function CreateVDubScript(cutlist: TCutlist; Inputfile, Outputfile: string; var scriptfile: string): Boolean;
    function CreateMPlayerEDL(cutlist: TCutlist; Inputfile, Outputfile: string; var scriptfile: string): Boolean;
    function DownloadInfo(settings: TSettings; const UseDate, ShowAll: Boolean): Boolean;
    procedure LoadCutList;
    //    function search_cutlist: Boolean;
    function SearchCutlists(AutoOpen: Boolean; SearchLocal, SearchWeb: Boolean; SearchTypes: TCutlistSearchTypes): Boolean;
    function SearchCutlistsByFileSize_Local(SearchType: TCutlistSearchType): Integer;
    function SearchCutlistsByFileSize_XML(SearchType: TCutlistSearchType; IgnorePrefix: Boolean = False): Integer;
    //    function DownloadCutlist(cutlist_name: string): Boolean;
    function DownloadCutlistByID(const cutlist_id, TargetFileName: string): Boolean; overload;
    function UploadCutlist(FileName: string): Boolean;
    function DeleteCutlistFromServer(const cutlist_id: string): Boolean;
    function AskForUserRating(Cutlist: TCutlist): Boolean;
    function SendRating(Cutlist: TCutlist): Boolean;
    procedure ShowNotifyMsg(const ACaption, AMessage: string);
  protected
    procedure WMDropFiles(var message: TWMDropFiles); message WM_DROPFILES;
    procedure WMCopyData(var msg: TWMCopyData); message WM_COPYDATA;
    function DoHttpGet(const url: string; const handleRedirects: Boolean; const Error_message: string; var Response: string): Boolean;
    function DoHttpRequest(data: THttpRequest): Boolean;
    function CheckResponse(const Response: string; const Protocol: Integer; const Command: TCutlistServerCommand): string;
    function CheckResponseProto1(const Response: string; const Command: TCutlistServerCommand): string;
    procedure SettingsChanged;
    function HandleWorkerException(data: THttpRequest): Boolean;
    function FormatMoviePosition(const position: Double): string; overload;
    function FormatMoviePosition(const frame: longint; const duration: Double): string; overload;
    procedure UpdateCutControls(APreviousPos, ANewPos: Double);
  end;

var
  FMain: TFMain;
  CutList: TCutList;
  Settings: TSettings = nil;
  pos_to, pos_from: Double;
  vol_temp: Integer;
  last_pos: Double;

  // Batch flags
  exit_after_commandline, TryCutting: Boolean;

  // movie params
  MovieInfo: TMovieInfo;

  // Interfaces
  BasicVideo: IBasicVideo;
  Seeking: IMediaSeeking;
  MediaEvent: IMediaEvent;
  Framestep: IVideoFrameStep;
  VMRWindowlessControl: IVMRWindowlessControl;
  VMRWindowlessControl9: IVMRWindowlessControl9;

implementation

{$WARN SYMBOL_PLATFORM OFF}

uses
  // Delphi
  System.TypInfo, System.UITypes, Vcl.Consts, Vcl.Themes,

  // Indy
  IdResourceStrings, IdURI,

  // Jedi
  JvParameterList, JvParameterListParameter, JvParameterListTools, JvDynControlEngineVCL, ExceptDlg, JvDesktopAlertForm,

  // CA
  DateTools, Frames, CutlistRate_Dialog, ResultingTimes, CutlistSearchResults, UfrmCutting, UCutApplicationBase,
  UCutApplicationAsfbin, UCutApplicationMP4Box, UMemoDialog, UAbout, ULogging, UDSAStorage, CAResources,
  TrackbarStyleHookCA,

  // Other
  uFreeLocalizer, PBOnceOnly;

{$R *.dfm}

const
  ServerProtocol = 1;

function TFMain.CheckResponse(const Response: string; const Protocol: Integer; const Command: TCutlistServerCommand): string;
begin
  case protocol of
    1 :  Result := CheckResponseProto1(Response, Command);
    else Result := Format(RsMsgServerCommandErrorProtocol, [Protocol]);
  end;
end;

function TFMain.CheckResponseProto1(const Response: string; const Command: TCutlistServerCommand): string;
var
  ErrorCodeText: string;
  ErrorCode: Integer;
  ResponseFields: TStringList;
begin
  ResponseFields := TStringList.Create;
  try
    with ResponseFields do
    begin
      CaseSensitive      := False;
      Duplicates         := dupAccept;
      Delimiter          := #10;
      NameValueSeparator := '=';
      DelimitedText      := Response;
      ErrorCodeText      := Values['error'];
    end;

    if (Command = cscRate) and (ErrorCodeText = '') then
      ErrorCode := 0
    else
      ErrorCode := StrToIntDef(ErrorCodeText, -3);

    case ErrorCode of
      -3 : Result := RsMsgServerCommandErrorResponse;
      -2 : Result := RsMsgServerCommandErrorUnspecified;
      -1 : Result := Format(RsMsgServerCommandErrorMySql, [ResponseFields.Values['mysql_errno']]);
       0 : Result := '';
      else begin
             case Command of
               cscDelete : begin // Delete cutlist from server
                             case ErrorCode of
                               1 :  Result := RsMsgCutlistDeleteEntryNotRemoved;
                               2 :  Result := RsMsgServerCommandErrorArgMissing;
                               else Result := RsMsgCutlistDeleteUnexpected;
                             end;
                           end;
               cscRate    : begin // Rate cutlist on server
                             case ErrorCode of
                               1 :  Result := RsMsgCutlistRateAlreadyRated;
                               2 :  Result := RsMsgServerCommandErrorArgMissing;
                               else Result := RsMsgServerCommandErrorUnspecified
                             end;
                           end;
               else        Result := Format(RsMsgServerCommandErrorCommand, [GetEnumName(TypeInfo(TCutlistServerCommand), Ord(Command))]);
             end;
           end;
    end;
  finally
    ResponseFields.Free;
  end;
end;

function TFMain.FormatMoviePosition(const position: Double): string;
begin
  if MovieInfo.frame_duration = 0 then
    Result := FormatMoviePosition(0, 0)
  else
    Result := FormatMoviePosition(Round(position / MovieInfo.frame_duration), position)
end;

function TFMain.FormatMoviePosition(const frame: longint; const duration: Double): string;
begin
  Result := IntToStr(frame) + ' / ' + MovieInfo.FormatPosition(duration);
end;

procedure TFMain.UpdateMovieInfoControls;
begin
  if Assigned(MovieInfo) then
    lblMovieFPS_nl.Caption := MovieInfo.FormatFrameRate
  else
    lblMovieFPS_nl.Caption := FrameRateToStr(0, #0);

  if Assigned(MovieInfo) and MovieInfo.MovieLoaded then
  begin
    lblMovieType_nl.Caption      := MovieInfo.MovieTypeString;
    lblCutApplication_nl.Caption := Format(RsCaptionCutApplication, [Settings.GetCutAppName(MovieInfo.MovieType)]);
  end else
  begin
    lblMovieType_nl.Caption      := MovieInfo.GetStringFromMovieType(mtNone);
    lblCutApplication_nl.Caption := Format(RsCaptionCutApplication, [RsNotAvailable]);
  end;
end;

procedure TFMain.UpdatePlayPauseButton;
begin
  actPlayPause.Caption := IfThen(FilterGraph.State = gsPlaying, '||', '>');
end;

procedure TFMain.UpdateTrackBarPageSize;
begin
  if MovieInfo.MovieLoaded then
    tbFilePos.PageSize := Round(MovieInfo.frame_duration * tbFinePos.Position * 1000 / tbFilePos.TimerInterval);
end;

procedure TFMain.refresh_times;
begin
  edtFrom.Text := MovieInfo.FormatPosition(pos_from);
  edtTo.Text   := MovieInfo.FormatPosition(pos_to);

  if pos_to >= pos_from then
  begin
    edtDuration.Text  := MovieInfo.FormatPosition(pos_to - pos_from);
    actAddCut.Enabled := True;
  end else
  begin
    edtDuration.Text  := '';
    actAddCut.Enabled := False;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
  procedure InitFramesProperties(const AAction: TAction; const s: string);
  begin
    if Assigned(AAction) then
    begin
      AAction.Caption := StringReplace(AAction.Caption, '$$', s, []);
      AAction.Hint    := StringReplace(AAction.Hint, '$$', s, []);
    end;
  end;
var
  S,numFrames: string;
  M: TMenuItem;
  I,J: Integer;
  icon: TIcon;
begin
  TStyleManager.Engine.RegisterStyleHook(TDSTrackBarEx, TTrackBarStyleHookCA);

  icon := TIcon.Create;
  try
    icon.Handle := LoadIcon(0, PChar(IDI_EXCLAMATION)) ;
    ICutlistWarning.Picture.Icon := Icon;
  finally
    icon.Free;
  end;

  AdjustFormConstraints(Self);

  if Screen.WorkAreaWidth < Constraints.MinWidth then
    Constraints.MinWidth := Screen.Width;

  if Screen.WorkAreaHeight < Constraints.MinHeight then
    Constraints.MinHeight := Screen.Height;

  if ValidRect(Settings.MainFormBounds) then
  begin
    BoundsRect := Settings.MainFormBounds;
  end else
  begin
    Top  := Screen.WorkAreaTop  + Max(0, (Screen.WorkAreaHeight - Height) div 2);
    Left := Screen.WorkAreaLeft + Max(0, (Screen.WorkAreaWidth  - Width)  div 2);
  end;

  numFrames := IntToStr(Settings.FramesCount);
  InitFramesProperties(actNextFrames, numFrames);
  InitFramesProperties(actCurrentFrames, numFrames);
  InitFramesProperties(actPrevFrames, numFrames);
  InitFramesProperties(actScanInterval, numFrames);

  ResetForm;

  // clear BtnCaption (autoloaded at runtime from ActionList) to prevent drawing of text below buttons
  for I := 0 to Pred(SpeedBar_nl.SectionCount) do
    for J := 0 to Pred(SpeedBar_nl.ItemsCount(I)) do
      SpeedBar_nl.Items(I, J).BtnCaption := '';

  DragAcceptFiles(Handle, True);
  ExitCode := 0;

  UploadDataEntries := TStringList.Create;
  if FileExists(UploadData_Path(True)) then
    UploadDataEntries.LoadFromFile(UploadData_Path(True));

  if FileExists(UploadData_Path(False)) then
    ConvertUploadData;

  SettingsChanged;

  rgCutMode.ItemIndex := settings.DefaultCutMode;

  Cutlist.RefreshCallBack := refresh_lvCutlist;
  cutlist.RefreshGUI;

  filtergraph.Volume := 5000;
  tbVolume.PageSize  := tbVolume.Frequency;
  tbVolume.LineSize  := Round(tbVolume.PageSize / 10);
  tbVolume.Position  := filtergraph.Volume;

  KeyFrameSampleInfo.Active := False;
  SampleInfo.Active := False;
  SampleInfo.Bitmap := TBitmap.Create;

  cbCutPreview.Checked  := Settings.CutPreview;
  tbFinePos.Position    := Settings.FinePosFrameCount;
  lblFinePos_nl.Caption := Format(RsFrames, [tbFinePos.Position, tbFinePos.Position / 25]);
  tbFilePos.Frequency   := Round(60000 / tbFilePos.TimerInterval); // one tick every minute

  with TStringList.Create do
  try
    for S in TStyleManager.StyleNames do
      Add(S);

    Sort;

    for I := 0 to Pred(Count) do
    begin
      M := TMenuItem.Create(mnuStyles);
      M.Caption    := Strings[I];
      M.OnClick    := SelectStyleClick;
      M.AutoCheck  := True;
      M.RadioItem  := True;
      M.GroupIndex := 1;

      if Strings[I] = TStyleManager.ActiveStyle.Name then
        M.Checked := True;

      mnuStyles.Items.Add(M);
    end;
  finally
    Free;
  end;

  WindowState := Settings.MainFormWindowState;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  Settings.FinePosFrameCount := tbFinePos.Position;
  Settings.MainFormBounds := BoundsRect;
  Settings.MainFormWindowState := WindowState;
  Settings.CutPreview := cbCutPreview.Checked;
  FreeAndNil(SampleInfo.Bitmap);
  FreeAndNil(UploadDataEntries);
end;

procedure TFMain.cmdFromStartClick(Sender: TObject);
begin
  pos_from := 0;
  refresh_times;
end;

procedure TFMain.cmdToEndClick(Sender: TObject);
begin
  pos_to := MovieInfo.current_file_duration;
  refresh_times;
end;

procedure TFMain.lvCutlistSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  enable_del_buttons(True);
end;

procedure TFMain.enable_del_buttons(Value: Boolean);
begin
  actDeleteCut.enabled  := Value;
  actEditCut.Enabled    := Value;
  actReplaceCut.Enabled := Value;
  actShiftCut.Enabled   := Value;
  actSplitCut.Enabled   := lvCutlist.Items.Count > 0;
  actMergeCut.Enabled   := Value and (lvCutlist.Items.Count > 1);
end;

function TFMain.StartCutting: Boolean;
var
  sourcefile, sourceExtension, targetfile, targetpath: string;
  AskForPath: Boolean;
  saveDlg: TSaveDialog;
  CutApplication: TCutApplicationBase;
begin
  Result := False;

  if cutlist.Count > 0 then
  begin
    if settings.CutlistAutoSaveBeforeCutting and cutlist.HasChanged then
      cutlist.Save(False);

    sourcefile := ExtractFileName(MovieInfo.current_filename);
    sourceExtension := ExtractFileExt(sourcefile);

    if settings.UseMovieNameSuggestion and (Trim(cutlist.SuggestedMovieName) <> '') then
      targetfile := Trim(cutlist.SuggestedMovieName) + SourceExtension
    else
      targetfile := ChangeFileExt(sourcefile, Settings.CutMovieExtension + SourceExtension);

    case Settings.SaveCutMovieMode of
      smWithSource: targetpath := ExtractFilePath(MovieInfo.current_filename);            // with source
      smGivenDir:   targetpath := IncludeTrailingPathDelimiter(Settings.CutMovieSaveDir); // in given Dir
      else          targetpath := ExtractFilePath(MovieInfo.current_filename);            // with source
    end;

    targetfile := CleanFileName(targetfile);

    if not ForceDirectories(targetpath) then
    begin
      if not batchmode then
        ErrMsgFmt(RsCouldNotCreateTargetPath, [targetpath]);
      Exit;
    end;

    MovieInfo.target_filename := targetpath + targetfile;

    //Display Save Dialog?
    AskForPath := Settings.MovieNameAlwaysConfirm;

    if FileExists(MovieInfo.target_FileName) and (not AskForPath) and (not batchmode) then
    begin
      if not NoYesMsgFmt(RsTargetMovieAlreadyExists, [MovieInfo.target_filename]) then
        AskForPath := True;
    end;
    if AskForPath and (not batchmode) then
    begin
      saveDlg := TSaveDialog.Create(Self);
      saveDlg.Filter     := '*' + SourceExtension + '|*' + SourceExtension;
      saveDlg.Title      := RsSaveCutMovieAs;
      saveDlg.InitialDir := targetpath;
      saveDlg.FileName   := Settings.ReplaceList.SearchAndReplace(targetfile);
      saveDlg.Options    := saveDlg.Options + [ofOverwritePrompt, ofPathMustExist];
      if saveDlg.Execute then
      begin
        MovieInfo.target_filename := Trim(saveDlg.FileName);
        if not SameText(ExtractFileExt(MovieInfo.target_filename), SourceExtension) then
          MovieInfo.target_filename := MovieInfo.target_filename + sourceExtension;
      end else
        Exit;
    end;

    if FileExists(MovieInfo.target_FileName) then
    begin
      if not deletefile(MovieInfo.target_filename) then
      begin
        if not batchmode then
          ErrMsgFmt(RsCouldNotDeleteFile, [MovieInfo.target_filename]);
        Exit;
      end;
    end;

    CutApplication := Settings.GetCutApplicationByMovieType(MovieInfo.MovieType);
    if Assigned(CutApplication) then
    begin
      CutApplication.CutAppSettings := Settings.GetCutAppSettingsByMovieType(MovieInfo.MovieType);
      frmCutting.CutApplication := CutApplication;
      Result := CutApplication.PrepareCutting(MovieInfo.current_filename, MovieInfo.target_filename, cutlist);
      if Result then
        Result := frmCutting.ExecuteCutApp = mrOK;
    end;
  end else
  begin
    if not batchmode then
      ErrMsg(RsNoCutsDefined);
  end;
end;

procedure TFMain.UpdateVolume;
begin
  if CBMUte.Checked then
    FilterGraph.Volume := 0
  else
    FilterGraph.Volume := tbVolume.Position;
end;

procedure TFMain.cbMuteClick(Sender: TObject);
begin
  UpdateVolume;
end;

procedure TFMain.tbVolumeChange(Sender: TObject);
begin
  UpdateVolume;
end;

procedure TFMain.refresh_lvCutlist(cutlist: TCutlist);
var
  icut: Integer;
  cut: tcut;
  cut_view: tlistitem;
  i_column: Integer;
  total_cutoff, resulting_duration: Double;
  hascuts: Boolean;
begin
  lvCutlist.Clear;
  actSendRating.Enabled := cutlist.IDOnServer <> '';

  hascuts := cutlist.Count > 0;

  actStartCutting.Enabled            := hascuts;
  actCalculateResultingTimes.Enabled := hascuts;
  actSaveCutlistAs.Enabled           := hascuts;
  actSaveCutlist.Enabled             := hascuts;
  actCutlistUpload.Enabled           := hascuts;
  actNextCut.Enabled                 := hascuts;
  actPrevCut.Enabled                 := hascuts;

  if hascuts then
  begin
    for icut := 0 to Pred(cutlist.Count) do
    begin
      cut              := cutlist[icut];
      cut_view         := lvCutlist.Items.Add;
      cut_view.Caption := IntToStr(icut); //IntToStr(cut.index);

      cut_view.SubItems.Add(MovieInfo.FormatPosition(cut.pos_from));
      cut_view.SubItems.Add(MovieInfo.FormatPosition(cut.pos_to));
      cut_view.SubItems.Add(MovieInfo.FormatPosition(cut.pos_to - cut.pos_from + MovieInfo.frame_duration));
    end;

    //Auto-Resize columns
    for i_column := 0 to Pred(lvCutlist.Columns.Count) do
      lvCutlist.Columns[i_column].Width := -1;
  end;

  enable_del_buttons(hascuts and (lvCutlist.ItemIndex >= 0));

  if cutlist.Mode = clmCutOut then
  begin
    total_cutoff := cutlist.TotalDurationOfCuts;
    resulting_duration := MovieInfo.current_file_duration - total_cutoff;
  end else
  begin
    resulting_duration := cutlist.TotalDurationOfCuts;
    total_cutoff := MovieInfo.current_file_duration - resulting_duration;
  end;

  lblTotalCutoff_nl.Caption := Format(RsCaptionTotalCutoff, [secondsToTimeString(total_cutoff)]);
  lblResultingDuration_nl.Caption := Format(RsCaptionResultingDuration, [secondsToTimeString(resulting_duration)]);

  //Cuts in Trackbar are taken from global var "cutlist"!
  tbFilePos.Perform(CM_RECREATEWND, 0, 0); // Show Cuts in Trackbar

  case cutlist.Mode of
    clmCutOut : rgCutMode.ItemIndex := 0;
    clmTrim   : rgCutMode.ItemIndex := 1;
  end;

  ICutlistWarning.Visible := (cutlist.RatingByAuthorPresent and (cutlist.RatingByAuthor <= 2)) or
    cutlist.EPGError or cutlist.MissingBeginning or cutlist.MissingEnding or cutlist.MissingVideo or
    cutlist.MissingAudio or cutlist.OtherError;

  if ICutlistWarning.Visible then
    cmdCutlistInfo.Width := ICutlistWarning.Left - cmdSplitCut.Left - 4
  else
    cmdCutlistInfo.Width := cmdSplitCut.Width;

  if cutlist.Author <> '' then
  begin
    lblCutlistAuthor_nl.Caption := cutlist.Author;
    pnlAuthor.Visible := True;
  end else
    pnlAuthor.Visible := False;
end;

function TFMain.OpenFile(FileName: string): Boolean; // False if file not found
var
  SourceFilter, AviDecompressorFilter: IBaseFilter;
  SourceAdded: Boolean;
  AvailableFilters: TSysDevEnum;
  PinList: TPinList;
  IPin: Integer;
  TempCursor: TCursor;
begin
  Result := False;

  if FileExists(FileName) then
  begin
    if MovieInfo.MovieLoaded then
    begin
      if not CloseMovieAndCutlist then
        Exit;
    end;

    TempCursor := Screen.Cursor;
    try
      Screen.Cursor := crHourGlass;
      MovieInfo.target_filename := '';
      if not MovieInfo.InitMovie(FileName) then
        Exit;

      actRepairMovie.Enabled := MovieInfo.MovieType = mtWMV;

      {if not batchmode then }
      begin
        SourceAdded := False;

        if MovieInfo.MovieType in [mtWMV] then
          SampleGrabber.FilterGraph := nil
        else
          if AnsiEndsText('.avs', MovieInfo.current_filename) then
            SampleGrabber.FilterGraph := nil
          else
            SampleGrabber.FilterGraph := FilterGraph;

        if Settings.Additional['ActivateKeyFrameGrabber'] = '1' then
          KeyFrameGrabber.FilterGraph := SampleGrabber.FilterGraph;

        FilterGraph.Active := True;

        AvailableFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); // DirectShow Filters
        try
          //if MP4 then try to Add AviDecompressor
          if MovieInfo.MovieType = mtMP4 then
          begin
            AviDecompressorFilter := AvailableFilters.GetBaseFilter(CLSID_AVIDec); // Avi Decompressor
            if Assigned(AviDecompressorFilter) then
              CheckDSError((FilterGraph as IGraphBuilder).AddFilter(AviDecompressorFilter, 'Avi Decompressor'));
          end;

          if not (IsEqualGUID(Settings.GetPreferredSourceFilterByMovieType(MovieInfo.MovieType), GUID_NULL)) then
          begin
            SourceFilter := AvailableFilters.GetBaseFilter(Settings.GetPreferredSourceFilterByMovieType(MovieInfo.MovieType));
            if Assigned(SourceFilter) then
            begin
              CheckDSError((SourceFilter as IFileSourceFilter).Load(StringToOleStr(FileName), nil));
              CheckDSError((FilterGraph as IGraphBuilder).AddFilter(SourceFilter, StringToOleStr('Source Filter [' + ExtractFileName(FileName) + ']')));
              SourceAdded := True;
            end;
          end;
        finally
          FreeAndNil(AvailableFilters);
        end;

        if sourceAdded then
        begin
          PinLIst := TPinLIst.Create(SourceFilter);
          try
            for iPin := 0 to Pred(PinList.Count) do
              CheckDSError((FilterGraph as IGraphBuilder).Render(PinList.Items[iPin]));
          finally
            FreeAndNil(PinList);
          end;
        end else
          CheckDSError(FilterGraph.RenderFile(FileName));

        initVideo;

        if SampleGrabber.FilterGraph = nil then
        begin
          InsertSampleGrabber;
          if (KeyFrameGrabber.FilterGraph = nil) and (Settings.Additional['ActivateKeyFrameGrabber'] = '1') then
            InsertKeyFrameGrabber;

          if not filtergraph.Active then
          begin
            if not batchmode then
              ErrMsg(RsCouldNotInsertSampleGrabber);
            MovieInfo.current_filename := '';
            MovieInfo.MovieLoaded      := False;
            MovieInfo.current_filesize := -1;
            UpdateMovieInfoControls;
            Exit;
          end;
        end;
        UpdateVolume;

        GraphPause;

        pnlVideoWindowResize(pnlVideoWindow);
      end;

      Caption := Application_Friendly_Name + ' ' + ExtractFileName(MovieInfo.current_filename);
      Application.Title := ExtractFileName(MovieInfo.current_filename);

      MovieInfo.MovieLoaded := True;

      tbFilePos.Max := Round(MovieInfo.current_file_duration * 1000 / tbFilePos.TimerInterval);
      UpdateTrackBarPageSize;

      Result := True;
    except
      on E: Exception do
        if not batchmode then
          ErrMsgFmt(RsErrorOpenMovie, [E.Message]);
    end;
    Screen.Cursor := TempCursor;
  end else
  begin
    if not batchmode then
      ErrMsgFmt(RsErrorFileNotFound, [FileName]);
    MovieInfo.current_filename := '';
    MovieInfo.MovieLoaded := False;
  end;
  UpdateMovieInfoControls;
end;

procedure TFMain.LoadCutList;
var
  FileName, cutlist_path, cutlist_filename: string;
  CutlistMode_old: TCutlistMode;
  newCutlist: TCutlist;
begin
  if MovieInfo.current_filename = '' then
  begin
    if not batchmode then
      ErrMsg(RsCannotLoadCutlist);
    Exit;
  end;

  //Use same settings as for saving as default
  cutlist_filename := ChangeFileExt(ExtractFileName(MovieInfo.current_filename), CUTLIST_EXTENSION);
  case Settings.SaveCutlistMode of
    smWithSource : cutlist_path := ExtractFilePath(MovieInfo.current_filename);            // with source
    smGivenDir   : cutlist_path := IncludeTrailingPathDelimiter(Settings.CutlistSaveDir);  // in given Dir
    else           cutlist_path := ExtractFilePath(MovieInfo.current_filename);            // with source
  end;

  odCutlist.InitialDir := cutlist_path;
  odCutlist.FileName   := cutlist_filename;
  odCutlist.Options    := odCutlist.Options + [ofNoChangeDir];

  if odCutlist.Execute then
  begin
    FileName := odCutlist.FileName;
    CutlistMode_old := cutlist.Mode;
    cutlist.LoadFromFile(FileName);
    if CutlistMode_old <> cutlist.Mode then
    begin
      newCutlist := cutlist.Convert;
      newCutlist.RefreshCallBack := cutlist.RefreshCallBack;
      FreeAndNil(cutlist);
      cutlist := newCutlist;
      cutlist.RefreshGUI;
    end;
  end;
end;

procedure TFMain.InitVideo;
var
  _ARw, _ARh: Integer;
  frame_duration: Double;
  _dur_time, _dur_frames: Int64;
  APin: IPin;
  MediaType: TAMMediaType;
  pVIH: ^VIDEOINFOHEADER;
  pVIH2: ^VIDEOINFOHEADER2;
  filter: IBaseFilter;
  BasicVIdeo2: IBasicVideo2;
  arx, ary: Integer;
begin
  if FilterGraph.Active then
  begin
    if Succeeded(filtergraph.QueryInterface(IMediaSeeking, Seeking)) then
    begin
      { //does not work ???
      if Succeeded(seeking.IsFormatSupported(TIME_FORMAT_FRAME)) then
        seeking.SetTimeFormat(TIME_FORMAT_FRAME);
      }
      seeking.GetTimeFormat(MovieInfo.TimeFormat);
      seeking.GetDuration(_dur_time);
      MovieInfo.current_file_duration := _dur_time;
      if isEqualGUID(MovieInfo.TimeFormat, TIME_FORMAT_MEDIA_TIME) then
        MovieInfo.current_file_duration := MovieInfo.current_file_duration / 10000000;
    end else
      seeking := nil;

    if not Succeeded(filtergraph.QueryInterface(IMediaEvent, MediaEvent)) then
      MediaEvent := nil;

    //detect ratio
    MovieInfo.nat_w := 0;
    MovieInfo.nat_h := 0;
    MovieInfo.ratio := 4 / 3;

    if Succeeded(filtergraph.QueryInterface(IBasicVideo, BasicVideo)) then
    begin
      BasicVideo.get_VideoWidth(MovieInfo.nat_w);
      BasicVideo.get_VideoHeight(MovieInfo.nat_h);

      if (MovieInfo.nat_w > 0) and (MovieInfo.nat_h > 0) then
        MovieInfo.ratio := MovieInfo.nat_w / MovieInfo.nat_h;

      if (MovieInfo.frame_duration = 0) and Succeeded(BasicVideo.get_AvgTimePerFrame(frame_duration)) then
      begin
        MovieInfo.frame_duration := frame_duration;
        MovieInfo.frame_duration_source := 'B';
      end;
    end;

    if Succeeded(filtergraph.QueryInterface(IBasicVideo2, BasicVideo2)) then
    begin
      BasicVideo2.GetPreferredAspectRatio(arx, ary);
      if (arx > 0) and (ary > 0) then
        MovieInfo.ratio := arx / ary;
    end;

    if Succeeded(videoWindow.QueryInterface(IVMRWindowlessControl9, VMRWindowlessControl9)) then
    begin
      VMRWindowlessControl9.GetNativeVideoSize(MovieInfo.nat_w, MovieInfo.nat_h, _ARw, _ARh);
      if (MovieInfo.nat_w > 0) and (MovieInfo.nat_h > 0) then
        MovieInfo.ratio := MovieInfo.nat_W / MovieInfo.nat_h;
    end else
    begin
      if Succeeded(videoWindow.QueryInterface(IVMRWindowlessControl, VMRWindowlessControl)) then
      begin
        VMRWindowlessControl.GetNativeVideoSize(MovieInfo.nat_w, MovieInfo.nat_h, _ARw, _ARh);
        if (MovieInfo.nat_w > 0) and (MovieInfo.nat_h > 0) then
          MovieInfo.ratio := MovieInfo.nat_W / MovieInfo.nat_h;
      end else
        VMRWindowlessControl := nil;
    end;

    if MovieInfo.frame_duration = 0 then
    begin
      if Succeeded(videowindow.QueryInterface(IBaseFilter, filter)) then
      begin
        APin := getInPin(filter, 0);
        APin.ConnectionMediaType(MediaType);
        if isEqualGUID(MediaType.formattype, FORMAT_VideoInfo2) then
        begin
          if Mediatype.cbFormat >= SizeOf(VIDEOINFOHEADER2) then
          begin
            pVIH2 := mediatype.pbFormat;
            MovieInfo.frame_duration := pVIH2^.AvgTimePerFrame / 10000000;
            MovieInfo.frame_duration_source := 'V';
            //dwFourCC := pVIH2^.bmiHeader.biCompression;
          end;
        end else
        begin
          if isEqualGUID(MediaType.formattype, FORMAT_VideoInfo) then
          begin
            if Mediatype.cbFormat >= SizeOf(VIDEOINFOHEADER) then
            begin
              pVIH := mediatype.pbFormat;
              MovieInfo.frame_duration := pVIH^.AvgTimePerFrame / 10000000;
              MovieInfo.frame_duration_source := 'v';
              //dwFourCC := pVIH^.bmiHeader.biCompression;
            end;
          end;
        end;
        // samplegrabber.SetBMPCompatible(@MediaType, 32);
        freeMediaType(@MediaType);
      end else
        if not batchmode then
          ErrMsg('Could not retrieve Renderer Filter.');
    end;

    if MovieInfo.frame_duration = 0 then
    begin
      //try calculating
      if Succeeded(seeking.IsFormatSupported(TIME_FORMAT_MEDIA_TIME)) and Succeeded(seeking.IsFormatSupported(TIME_FORMAT_FRAME)) then
      begin
        seeking.SetTimeFormat(TIME_FORMAT_MEDIA_TIME);
        seeking.GetDuration(_dur_time);
        seeking.SetTimeFormat(TIME_FORMAT_FRAME);
        seeking.GetDuration(_dur_frames);
        if (_dur_frames > 0) and (_dur_time <> _dur_frames) then
        begin
          MovieInfo.frame_duration_source := 'D';
          MovieInfo.frame_duration := (_dur_time / 10000000) / _dur_frames
        end;
        seeking.SetTimeFormat(MovieInfo.TimeFormat)
      end;
    end;

    //default if nothing worked so far
    if MovieInfo.frame_duration = 0 then
    begin
      MovieInfo.frame_duration_source := 'F';
      MovieInfo.frame_duration        := 0.04;
    end;

    actOpenCutlist.Enabled             := True;
    actSearchCutlistByFileSize.Enabled := True;
    actSearchCutlistLocal.Enabled      := True;

    lblDuration_nl.Caption := FormatMoviePosition(MovieInfo.FrameCount, MovieInfo.current_file_duration);

    MovieInfo.CanStepForward := False;
    if Succeeded(FilterGraph.QueryInterface(IVideoFrameStep, FrameStep)) then
    begin
      if FrameStep.CanStep(0, nil) = S_OK then
        MovieInfo.CanStepForward := True;
    end else
      FrameStep := nil;

    EnableMovieControls(True);
  end;
end;

procedure TFMain.JumpTo(NewPosition: Double);
begin
  if NewPosition < 0 then
    NewPosition := 0;
  JumpToEx(NewPosition, -1);
end;

procedure TFMain.JumpToEx(NewPosition: Double; NewStop: Double);
var
  _pos, _stop: Int64;
  event: Integer;
begin
  if MovieInfo.MovieLoaded then
  begin
    if NewPosition > MovieInfo.current_file_duration then
      NewPosition := MovieInfo.current_file_duration;

    if isEqualGUID(MovieInfo.TimeFormat, TIME_FORMAT_MEDIA_TIME) then
    begin
      _pos  := Round(NewPosition * 10000000);
      _stop := Round(NewStop * 10000000);
    end else
    begin
      _pos  := Round(NewPosition);
      _stop := Round(NewStop);
    end;
    seeking.SetPositions(
      _pos, IfThen(_pos >= 0, AM_SEEKING_AbsolutePositioning, AM_SEEKING_NoPositioning),
      _stop, IfThen(_stop >= 0, AM_SEEKING_AbsolutePositioning, AM_SEEKING_NoPositioning));

    //filtergraph.State
    MediaEvent.WaitForCompletion(500, event);
    tbFilePos.TriggerTimer;
  end;
end;

function TFMain.CurrentPosition: Double;
var
  _pos: Int64;
begin
  if Assigned(seeking) and Succeeded(seeking.GetCurrentPosition(_pos)) then
  begin
    if isEqualGUID(MovieInfo.TimeFormat, TIME_FORMAT_MEDIA_TIME) then
      Result := _pos / 10000000
    else
      Result := _pos;
  end else
    Result := 0;
end;

procedure TFMain.tbFilePosTimer(sender: TObject; CurrentPos, StopPos: Cardinal);
var
  TrueRate: Double;
begin
  TrueRate := CalcTrueRate(tbFilePos.TimerInterval / 1000);
  if TrueRate > 0 then
    lblTrueRate_nl.Caption := '[' + floattostrF(TrueRate, ffFixed, 15, 3) + 'x]'
  else
    lblTrueRate_nl.Caption := '[ ? x]';

  lblPos_nl.Caption := FormatMoviePosition(currentPosition);
end;

procedure TFMain.tbFilePosChange(Sender: TObject);
begin
  if tbFilePos.IsMouseDown then
    lblPos_nl.Caption := FormatMoviePosition(tbFilePos.TimerInterval / 1000 * tbFilePos.Position);
end;

procedure TFMain.FilterGraphGraphStepComplete(Sender: TObject);
begin
  lblPos_nl.Caption := FormatMoviePosition(currentPosition);
  StepComplete := True;
end;

procedure TFMain.tbFilePosPositionChangedByMouse(Sender: TObject);
var
  event: Integer;
begin
  MEdiaEvent.WaitForCompletion(500, event);
  lblPos_nl.Caption := FormatMoviePosition(currentPosition);
end;

procedure TFMain.tbFinePosChange(Sender: TObject);
var
  x: Double;
begin
  if MovieInfo.MovieLoaded then
    x := MovieInfo.frame_duration
  else
    x := 1 / 25;

  lblFinePos_nl.Caption := Format(RsFrames, [tbFinePos.Position, tbFinePos.Position * x]);
  Settings.FinePosFrameCount := tbFinePos.Position;

  UpdateTrackBarPageSize;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseMovie;
  DragAcceptFiles(Handle, False);
end;

procedure TFMain.SetStartPosition(Position: Double);
begin
  pos_from := Position;
  refresh_times;
end;

procedure TFMain.SetStopPosition(Position: Double);
begin
  pos_to := Position;
  refresh_times;
end;

function GetFileSourceFilter(FilterGraph: TFilterGraph): IBaseFilter;
var
  FilterList: TFilterList;
  BaseFilter: IBaseFilter;
  idx: Integer;
begin
  Result := nil;
  FilterList := TFilterList.Create;
  try
    FilterList.Assign(FilterGraph as IFilterGraph);
    for idx := Pred(FilterList.Count) downto 0 do
    begin
      BaseFilter := FilterList.Items[idx];
      if Supports(BaseFilter, IFileSourceFilter) then
      begin
        Result := BaseFilter;
        Break;
      end;
    end;
  finally
    FilterList.Free;
  end;
end;

procedure TFMain.InsertKeyFrameGrabber;
var
  KFInPin, KFOutPin, FileSourceOutPin, FileSourceConnectedPin: IPin;
  FileSourceFilter: IBaseFilter;
  GraphBuilder: IGraphBuilder;
  pins: IEnumPins;
  mt: _AMMediaType;
  pinDir: _PinDirection;
  pinInfo: _pinInfo;
begin
  if FilterGraph.Active then
  begin
    GraphBuilder := FilterGraph as IGraphBuilder;
    try
      KeyFrameGrabber.FilterGraph := FilterGraph;
      // Insert keyframe samplegrabber directly before video decompressor.
      if TeeFilter.FilterGraph <> nil then
      begin
        GetPin((TeeFilter as IBaseFilter), PINDIR_INPUT, 0, FileSourceOutPin);
        FileSourceOutPin.ConnectedTo(FileSourceConnectedPin);
        FileSourceConnectedPin.QueryPinInfo(pinInfo);
        GetPin(pinInfo.pFilter, PINDIR_INPUT, 0, FileSourceConnectedPin);
        FileSourceConnectedPin.ConnectedTo(FileSourceOutPin);
      end else
      begin
        // Insert keyframe samplegrabber directly after file source.
        FileSourceFilter := GetFileSourceFilter(FilterGraph);
        if Succeeded(FileSourceFilter.EnumPins(pins)) then
        begin
          repeat
            if Succeeded(pins.Next(1, FileSourceOutPin, nil)) then
            begin
              if not (Succeeded(FileSourceOutPin.QueryDirection(pinDir)) and (pinDir = PINDIR_OUTPUT) and
                 Succeeded(FileSourceOutPin.ConnectionMediaType(mt)) and IsEqualGUID(mt.majortype, MEDIATYPE_Video)) then
                FileSourceOutPin := nil;
            end else
            begin
              FileSourceOutPin := nil;
              Break;
            end;
          until (FileSourceOutPin <> nil)
        end;
        //OleCheck(GetPin(FileSourceFilter, PINDIR_OUTPUT, 1, FileSourceOutPin));
        OleCheck(FileSourceOutPin.ConnectedTo(FileSourceConnectedPin));
      end;
      OleCheck(GetPin((KeyFrameGrabber as IBaseFilter), PINDIR_INPUT, 0, KFInpin));
      OleCheck(GetPin((KeyFrameGrabber as IBaseFilter), PINDIR_OUTPUT, 0, KFOutpin));
      OleCheck(GraphBuilder.Disconnect(FileSourceOutPin));
      OleCheck(GraphBuilder.Disconnect(FileSourceConnectedPin));
      OleCheck(GraphBuilder.Connect(FileSourceOutPin, KFInpin));
      OleCheck(GraphBuilder.Connect(KFoutpin, FileSourceConnectedPin));
    except
      filtergraph.ClearGraph;
      filtergraph.Active := False;
      raise;
    end;
  end;
end;

procedure TFMain.InsertSampleGrabber;
var
  Rpin, Spin, TInPin, TOutPin1, TOutPin2, NRInPin, SGInPin, SGOutPin: IPin;
  GraphBuilder: IGraphBuilder;
begin
  if FilterGraph.Active then
  begin
    GraphBuilder := FilterGraph as IGraphBuilder;
    try
      TeeFilter.FilterGraph := Filtergraph;
      SampleGrabber.FilterGraph := filtergraph;
      NullRenderer.FilterGraph := filtergraph;

      //Disconnect Video Window
      OleCheck(GetPin((VideoWindow as IBaseFilter), PINDIR_INPUT, 0, Rpin));
      OleCheck(Rpin.ConnectedTo(Spin));
      OleCheck(GraphBuilder.Disconnect(Rpin));
      OleCheck(GraphBuilder.Disconnect(Spin));

      //Get Pins
      OleCheck(GetPin((SampleGrabber as IBaseFilter), PINDIR_INPUT, 0, SGInpin));
      OleCheck(GetPin((SampleGrabber as IBaseFilter), PINDIR_OUTPUT, 0, SGOutpin));
      OleCheck(GetPin((NullRenderer as IBaseFilter), PINDIR_INPUT, 0, NRInpin));
      OleCheck(GetPin((TeeFilter as IBaseFilter), PINDIR_INPUT, 0, TInpin));
      OleCheck(GetPin((TeeFilter as IBaseFilter), PINDIR_OUTPUT, 0, TOutpin1));

      //Establish Connections
      OleCheck(GraphBuilder.Connect(Spin, Tinpin)); // Decomp. to Tee
      OleCheck(GraphBuilder.Connect(Toutpin1, Rpin)); //Tee to VideoRenderer
      OleCheck(GetPin((TeeFilter as IBaseFilter), PINDIR_OUTPUT, 1, TOutpin2)); //GEt new OutputPin of Tee
      OleCheck(GraphBuilder.Connect(Toutpin2, SGInpin)); //Tee to SampleGrabber
      OleCheck(GraphBuilder.Connect(SGoutpin, NRInpin)); //SampleGrabber to Null
    except
      filtergraph.ClearGraph;
      filtergraph.active := False;
      raise;
    end;
  end;
end;

function TFMain.WaitForStep(TimeOut: Integer; const WaitForSampleInfo: Boolean): Boolean;
var
  interval: Integer;
  startTick, nowTick, lastTick: Cardinal;
  function SampleInfoReady(const SampleInfo: RMediaSample): Boolean;
  begin
    Result := not WaitForSampleInfo or not SampleInfo.Active or (SampleInfo.SampleTime >= 0);
  end;
  function AllStepComplete: Boolean;
  begin
    Result := StepComplete and (not Assigned(SampleGrabber.FilterGraph) or SampleInfoReady(SampleInfo)) and
              (not Assigned(KeyFrameGrabber.FilterGraph) or SampleInfoReady(KeyFrameSampleInfo));
  end;
begin
  lastTick  := GetTickCount;
  startTick := lastTick;

  if Settings.AutoMuteOnSeek then
    interval := 10
  else
    interval := Max(10, Round(MovieInfo.frame_duration * 1000.0) div 2);

  while not AllStepComplete do
  begin
    sleep(interval);
    nowTick := GetTickCount;
    if AllStepComplete or (Abs(startTick - nowTick) > TimeOut) then
      Break;
    Application.ProcessMessages;
  end;
  Result := AllStepComplete;
end;

procedure TFMain.pnlVideoWindowResize(Sender: TObject);
var
  movie_ar,my_ar: Double;
begin
  movie_ar := MovieInfo.ratio;
  my_ar := pnlVideoWindow.Width / pnlVideoWindow.Height;
  if my_ar > movie_ar then
  begin
    VideoWindow.Height := pnlVideoWindow.Height;
    VideoWindow.Width  := Round(videowindow.Height * movie_ar);
  end else
  begin
    VideoWindow.Width  := pnlVideoWindow.Width;
    VideoWindow.Height := Round(VideoWindow.Width / movie_ar);
  end;
end;

procedure TFMain.ShowFrames(startframe, endframe: Integer); // startframe, endframe relative to current frame
var
  iImage, count: Integer;
  pos, temp_pos, start_pos: Double;
  Target: TCutFrame;
begin
  count := FFrames.Count;
  if endframe >= startframe then
  begin
    while endframe - startframe + 1 > count do
    begin
      if - startframe > endframe then
        startframe := startframe + 1
      else
        endframe := endframe - 1;
    end;

    pos := currentPosition;
    temp_pos := IntExt(pos, MovieInfo.frame_duration) + (startframe - 1) * MovieInfo.frame_duration;

    if (temp_pos > MovieInfo.current_file_duration) then
      temp_pos := MovieInfo.current_file_duration;

    if temp_pos < 0 then
      temp_pos := 0;

    start_pos := IntExt(temp_pos + MovieInfo.frame_duration, MovieInfo.frame_duration);

    FFrames.Show;

    JumpTo(temp_pos);

    // Mute sound ?
    if Settings.AutoMuteOnSeek and not CBMute.Checked then
      FilterGraph.Volume := 0;

    FFrames.FramesCanClose := False;
    try
      iImage := -1;
      while iImage < (endframe - startframe) do
      begin
        Inc(iImage);
        temp_pos := currentPosition;
        Target := FFrames.Frame[iImage];
        Target.DisableUpdate;
        try
          Target.ResetFrame;
          if (temp_pos >= 0) and (temp_pos <= MovieInfo.current_file_duration) then
          begin
            StepComplete := False;
            SampleInfo.Active := Assigned(SampleGrabber.FilterGraph);
            KeyFrameSampleInfo.Active := Assigned(KeyFrameGrabber.FilterGraph);
            try
              Target.position := start_pos + iImage * MovieInfo.frame_duration;
              SampleInfo.SampleTime := -1;
              KeyFrameSampleInfo.SampleTime := -1;

              if Assigned(Framestep) then
              begin
                if not Succeeded(FrameStep.Step(1, nil)) then
                  Continue;
                if not WaitForStep(1000, True) then
                  Continue;
                temp_pos := currentPosition;
                if Abs(Target.position - temp_pos) >= MovieInfo.frame_duration then
                begin
                  // filtergraph is not at desired position after frame step
                  // => fix position and start over
                  JumpTo(Target.position - MovieInfo.frame_duration / 2);
                  Dec(iImage);
                  Continue;
                end;
              end else
              begin
                temp_pos := temp_pos + MovieInfo.frame_duration;
                JumpTo(temp_pos);
                WaitForFiltergraph;
              end;
              Target.AssignSampleInfo(SampleInfo, KeyFrameSampleInfo);
            finally
              SampleInfo.Active := False;
              KeyFrameSampleInfo.Active := False;
            end;
          end;
        finally
          Target.EnableUpdate;
        end;
      end;
    finally
      FFrames.FramesCanClose := True;
      // Restore sound
      if Settings.AutoMuteOnSeek and not CBMute.Checked then
        FilterGraph.Volume := tbVolume.Position;
      JumpTo(pos);
    end;
  end;
end;

procedure TFMain.ShowFramesAbs(startframe, endframe: Double; numberOfFrames: Integer); // starframe, endframe: absolute position.
var
  iImage: Integer;
  pos, temp_pos, distance: Double;
  Target: TCutFrame;
begin
  if endframe > startframe then
  begin
    startframe := ensureRange(startframe, 0, MovieInfo.current_file_duration);
    endframe   := ensureRange(endframe, 0, MovieInfo.current_file_duration - MovieInfo.frame_duration);

    numberOfFrames := FFrames.Count;
    distance := (endframe - startframe) / (numberofFrames - 1);

    FilterGraph.Pause;
    WaitForFiltergraph;

    pos := currentPosition;
    FFrames.Show;

    // Mute sound ?
    if Settings.AutoMuteOnSeek and not CBMute.Checked then
      FilterGraph.Volume := 0;

    FFrames.FramesCanClose := False;

    try
      for iImage := 0 to Pred(numberOfFrames) do
      begin
        Target := FFrames.Frame[iImage];
        try
          Target.ResetFrame;
          temp_pos := startframe + (iImage * distance);
          if (temp_pos >= 0) and (temp_pos <= MovieInfo.current_file_duration) then
          begin
            SampleInfo.Active := Assigned(SampleGrabber.FilterGraph);
            KeyFrameSampleInfo.Active := Assigned(KeyFrameGrabber.FilterGraph);
            try
              Target.position := temp_pos;
              SampleInfo.SampleTime := -1;
              KeyFrameSampleInfo.SampleTime := -1;

              JumpTo(temp_pos);
              WaitForFiltergraph;

              Target.AssignSampleInfo(SampleInfo, KeyFrameSampleInfo);
            finally
              SampleInfo.Active := False;
              KeyFrameSampleInfo.Active := False;
            end;
          end;
        finally
          Target.EnableUpdate;
        end;
      end;
    finally
      FFrames.FramesCanClose := True;
      // Restore sound
      if Settings.AutoMuteOnSeek and not CBMute.Checked then
        FilterGraph.Volume := tbVolume.Position;
      JumpTo(pos);
    end;
  end;
end;

procedure TFMain.WaitForFilterGraph;
var
  pfs: TFilterState;
  hr: hresult;
begin
  repeat
    hr := (FilterGraph as IMediaControl).GetState(50, pfs);
  until (hr = S_OK) or (hr = E_FAIL);
end;

procedure TFMain.cmdConvertClick(Sender: TObject);
var
  newCutlist: TCutlist;
begin
  if cutlist.Count > 0 then
  begin
    newCutlist := cutlist.Convert;
    newCutlist.RefreshCallBack := cutlist.RefreshCallBack;
    FreeAndNil(cutlist);
    cutlist := newCutlist;
    cutlist.RefreshGUI;
  end;
end;

procedure TFMain.ShowMetaData;
const
  stream = $0;
var
  HeaderInfo: IWMHeaderInfo;
  _text: string;
  value: packed array of Byte;
  _name: array of WideChar;
  name_len, attr_len: Word;
  iFilter, iAttr, iByte: Integer;
  found: Boolean;
  filterlist: TFilterlist;
  sourceFilter: IBaseFilter;
  attr_datatype: wmt_attr_datatype;
  CAttributes: Word;
  _stream: Word;
begin
  if (MovieInfo.current_filename <> '') and MovieInfo.MovieLoaded then
  begin
    frmMemoDialog.Caption := RsTitleMovieMetaData;
    with frmMemoDialog.memInfo do
    begin
      Clear;
      Lines.Add(Format(RsMovieMetaDataMovietype, [MovieInfo.MovieTypeString]));
      Lines.Add(Format(RsMovieMetaDataCutApplication, [Settings.GetCutAppName(MovieInfo.MovieType)]));
      Lines.Add(Format(RsMovieMetaDataFilename, [MovieInfo.current_filename]));
      Lines.Add(Format(RsMovieMetaDataFrameRate, [FloatToStrF(1 / MovieInfo.frame_duration, ffFixed, 15, 4)]));

      if MovieInfo.MovieType in [mtAVI, mtHQAvi, mtHDAvi] then
        Lines.Add(Format(RsMovieMetaDataVideoFourCC, [fcc2string(MovieInfo.FFourCC)]));

      if MovieInfo.MovieType in [mtWMV] then
      begin
        filterlist := tfilterlist.Create;
        filterlist.Assign(filtergraph as IFiltergraph);
        found := False;
        for iFilter := 0 to Pred(filterlist.Count) do
        begin
          if string(filterlist.FilterInfo[iFilter].achName) = MovieInfo.current_filename then
          begin
            sourcefilter := filterlist.Items[iFilter];
            found := True;
            Break;
          end;
        end;
        if found then
        begin
          try
            //   wmcreateeditor
            //   (FIltergraph as IFiltergraph).FindFilterByName(pwidechar(current_filename), sourceFilter);
            //   (sourceFIlter as iammediacontent).get_AuthorName(pwidechar(author));
            if Succeeded(sourcefilter.QueryInterface(IwmHeaderInfo, HEaderINfo)) then
            begin
              HeaderInfo := (sourceFilter as IwmHeaderInfo);
              HeaderInfo.GetAttributeCount(stream, CAttributes);
              _stream := stream;
              for iAttr := 0 to Pred(CAttributes) do
              begin
                HeaderInfo.GetAttributeByIndex(iAttr, _stream, nil, name_len, attr_datatype, nil, attr_len);
                SetLength(_name, name_len);
                SetLength(value, attr_len);
                HeaderInfo.GetAttributeByIndex(iAttr, _stream, pwidechar(_name), name_len, attr_datatype, PByte(value), attr_len);
                case attr_datatype of
                  WMT_TYPE_STRING : _text := WideChartoString(PWideChar(value));
                  WMT_TYPE_WORD   : _text := IntToStr(Word(PWord(addr(value[0]))^));
                  WMT_TYPE_DWORD  : _text := IntToStr(DWORD(PDWord(addr(value[0]))^));
                  WMT_TYPE_QWORD  : _text := IntToStr(Int64(PULargeInteger(addr(value[0]))^));
                  WMT_TYPE_BOOL   : if LongBool(PDword(addr(value[0]))^) then
                                      _text := 'True'
                                    else
                                      _text := 'False';
                  WMT_TYPE_BINARY : begin
                                      _text := #13#10;
                                      for iByte := 0 to Pred(attr_len) do
                                      begin
                                        _text := _text + IntToHex(value[iByte], 2) + ' ';
                                        if iByte mod 8 = 7 then
                                          _text := _text + ' ';
                                        if iByte mod 16 = 15 then
                                          _text := _text + #13#10;
                                      end;
                                    end;
                  WMT_TYPE_GUID   : _text := GuidToString(PGUID(value[0])^);
                  else              _text := RsMovieMetaDataUnknownDataFormat;
                end;
                Lines.Add(Format('%s: %s', [WideCharToString(PWidechar(_name)), _text]));
              end;
            end;
          finally
            FreeAndNil(filterlist);
          end;
        end else
        begin
          Lines.Add(RsMovieMetaDataNoInterface);
          FreeAndNil(filterlist);
        end;
      end;
    end;
    frmMemoDialog.ShowModal;
  end;
end;

procedure TFMain.ShowNotifyMsg(const ACaption, AMessage: string);
var
  A: TJvDesktopAlert;
begin
  if Settings.SuppressedMsgAsNotify then
  begin
    A := TJvDesktopAlert.Create(Self);

    A.AlertStack  := JvDesktopAlertStack;
    A.AutoFocus   := True;
    A.AutoFree    := True;
    A.Options     := [daoCanClose];
    A.HeaderText  := ACaption;
    A.MessageText := AMessage;
    A.ShowHint    := False;
    A.ParentFont  := False;

    A.Colors.Frame       := clWindowFrame;
    A.Colors.WindowFrom  := clWindow;
    A.Colors.WindowTo    := clWindow;
    A.Colors.CaptionFrom := clActiveCaption;
    A.Colors.CaptionTo   := clActiveCaption;

    A.StyleOptions.DisplayDuration := 2345;

    A.HeaderFont := Font;
    A.HeaderFont.Style := [fsBold];

    A.Font := Font;

    TJvFormDesktopAlert(A.Form).lblText.AutoSize := True;

    A.Location.Height := cDefaultAlertFormHeight + (CountLines(AMessage) - 3) * lblVolume.Height;

    A.Execute;
  end;
end;

procedure TFMain.tbFilePosSelChanged(Sender: TObject);
begin
  with FFrames do
  begin
    if scan_1 <> -1 then
    begin
      frame[scan_1].BorderVisible := False;
      scan_1 := -1;
    end;
    if scan_2 <> -1 then
    begin
      frame[scan_2].BorderVisible := False;
      scan_2 := -1;
    end;
  end;
  if tbFilePos.SelEnd - tbFilePos.SelStart > 0 then
    actScanInterval.Enabled := True
  else
    actScanInterval.Enabled := False;
end;

procedure TFMain.WMDropFiles(var message: TWMDropFiles);
var
  iFile, cFiles: uInt;
  FileName: array[0 .. 255] of Char;
  FileList: TStringList;
  FileString: string;
begin
  FileList := TStringList.Create;
  try
    cFiles := DragQueryFile(message.Drop, $FFFFFFFF, nil, 0);
    for iFile := 1 to cFiles do
    begin
      DragQueryFile(message.Drop, iFile - 1, @FileName, uint(SizeOf(FileName)));
      filestring := string(FileName);
      FileList.add(fileString);
    end;
    ProcessFileList(FileList, False);
  finally
    FreeAndNil(FileList);
  end;
  inherited;
end;

procedure TFMain.ProcessFileList(FileList: TStringList; IsMyOwnCommandLine: Boolean);
var
  iString: Integer;
  Pstring, filename_movie, filename_cutlist, filename_upload_cutlist: string;
  upload_cutlist, found_movie, found_cutlist, get_empty_cutlist: Boolean;
  try_cutlist_download: Boolean;
begin
  found_movie          := False;
  found_cutlist        := False;
  upload_cutlist       := False;
  try_cutlist_download := False;
  Batchmode            := False;
  TryCutting           := False;
  get_empty_cutlist    := False;

  for iString := 0 to Pred(FileList.Count) do
  begin
    Pstring := FileList[iString];

    if AnsiStartsStr('-uploadcutlist:', AnsiLowerCase(PString)) then
    begin
      filename_upload_cutlist := AnsiMidStr(PString, 16, Length(Pstring) - 15);
      upload_cutlist := True;
    end;

    if AnsiStartsStr('-getemptycutlist:', AnsiLowerCase(PString)) and (not found_cutlist) then
    begin
      filename_cutlist := AnsiMidStr(PString, 18, Length(Pstring) - 17);
      found_cutlist := True;
      get_empty_cutlist := True;
    end;

    if AnsiStartsStr('-Exit', AnsiLowerCase(PString)) then
    begin
      if IsMyOwnCommandLine then exit_after_commandline := True;
    end;

    if AnsiStartsStr('-open:', AnsiLowerCase(PString)) and (not found_movie) then
    begin
      filename_movie := AnsiMidStr(PString, 7, Length(Pstring) - 6);
      if FileExists(filename_movie) then found_movie := True;
    end;

    if AnsiStartsStr('-batchmode', AnsiLowerCase(PString)) then
    begin
      if IsMyOwnCommandLine then Batchmode := True;
    end;

    if AnsiStartsStr('-trycutting', AnsiLowerCase(PString)) then
    begin
      TryCutting := True;
    end;

    if AnsiStartsStr('-trycutlistdownload', AnsiLowerCase(PString)) and (not found_cutlist) then
    begin
      found_cutlist := True;
      try_cutlist_download := True;
    end;

    if AnsiStartsStr('-cutlist:', AnsiLowerCase(PString)) and (not found_cutlist) then
    begin
      filename_cutlist := AnsiMidStr(PString, 10, Length(Pstring) - 9);
      if FileExists(filename_cutlist) then found_cutlist := True;
    end;

    if FileExists(Pstring) then
    begin
      if AnsiLowerCase(ExtractFileExt(Pstring)) = CUTLIST_EXTENSION then
      begin
        if not found_cutlist then
        begin
          filename_cutlist := pstring;
          found_cutlist    := True;
        end;
      end else
      begin
        if not found_movie then
        begin
          filename_movie := pstring;
          found_movie    := True;
        end;
      end;
    end;
  end;

  if upload_cutlist then
    if not UploadCutlist(filename_upload_cutlist) then
      ExitCode := 64;

  if found_movie then
    if not openfile(filename_movie) then
      if IsMyOwnCommandLine then ExitCode := 1;

  if get_empty_cutlist then
  begin
    if IsMyOwnCommandLine then
      ExitCode := 32;

    if cutlist.EditInfo then
    begin
      if cutlist.SaveAs(filename_cutlist) then
      begin
        ExitCode := 0;
        Exit;
      end;
    end;
  end;

  if found_cutlist then
  begin
    if MovieInfo.MovieLoaded then
    begin
      if try_cutlist_download and not Settings.AutoSearchCutlists then
      begin
        if not SearchCutlists(True, Settings.SearchLocalCutlists, Settings.SearchServerCutlists, [cstBySize]) then
        begin
          if IsMyOwnCommandLine then ExitCode := 2;
          Exit;
        end;
      end else
      begin
        cutlist.LoadFromFile(filename_cutlist);
      end;
    end else
    begin
      if not batchmode then
        ErrMsg(RsCannotLoadCutlist);
    end;
  end;

  if TryCutting then
  begin
    if MovieInfo.current_filename <> '' then
    begin
      if not StartCutting then
        if IsMyOwnCommandLine then ExitCode := 128;
    end;
  end;
end;

procedure TFMain.actSaveCutlistAsExecute(Sender: TObject);
begin
  if cutlist.Save(True) then
    if not batchmode then
      InfMsgFmt(RsCutlistSavedAs, [cutlist.SavedToFilename]);
end;

procedure TFMain.actOpenMovieExecute(Sender: TObject);
var
  ExtList, ExtListAllSupported: string;

  procedure AppendFilterString(const description: string; const extensions: string); overload;
  var
    filter: string;
  begin
    filter := MakeFilterString(description, extensions);
    if odMovie.Filter <> '' then
      odMovie.Filter := odMovie.Filter + '|' + filter
    else
      odMovie.Filter := filter
  end;

  procedure AppendFilterString(const description: string; const ExtArray: array of string); overload;
  begin
    ExtList := FilterStringFromExtArray(ExtArray);
    AppendFilterString(description, ExtList);
    if ExtListAllSupported <> '' then
      ExtListAllSupported := ExtListAllSupported + ';' + ExtList
    else
      ExtListAllSupported := ExtList;
  end;

begin
  ExtListAllSupported := '';
  odMovie.Filter      := '';

  // Make Filter List
  AppendFilterString(RsFilterDescriptionWmv, WMV_EXTENSIONS);
  AppendFilterString(RsFilterDescriptionAvi, AVI_EXTENSIONS);
  AppendFilterString(RsFilterDescriptionMp4, MP4_EXTENSIONS);
  AppendFilterString(RsFilterDescriptionAll, '*.*');
  odMovie.Filter := MakeFilterString(RsFilterDescriptionAllSupported, ExtListAllSupported) + '|' + odMovie.Filter;

  odMovie.InitialDir := settings.CurrentMovieDir;
  if odMovie.Execute then
  begin
    settings.CurrentMovieDir := ExtractFilePath(odMovie.FileName);
    if OpenFile(odMovie.FileName) and MovieInfo.MovieLoaded then
      if Settings.AutoSearchCutlists xor AltDown then
        SearchCutlists(True, ShiftDown xor Settings.SearchLocalCutlists, CtrlDown xor Settings.SearchServerCutlists, [cstBySize]);
  end;
end;

procedure TFMain.actOpenCutlistExecute(Sender: TObject);
begin
  LoadCutlist;
end;

procedure TFMain.actFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TFMain.actAddCutExecute(Sender: TObject);
begin
  if cutlist.AddCut(pos_from, pos_to) then
  begin
    pos_from := 0;
    pos_to := 0;
    refresh_times;
  end;
end;

procedure TFMain.actReplaceCutExecute(Sender: TObject);
var
  dcut: Integer;
begin
  if Settings.Additional['AutoReplaceCuts'] = '1' then
  begin
    dcut := cutlist.FindCutIndex(pos_from);
    if dcut >= 0 then cutlist.DeleteCut(dcut);
    dcut := cutlist.FindCutIndex(pos_to);
    if dcut >= 0 then cutlist.DeleteCut(dcut);
    cutlist.AddCut(pos_from, pos_to);
  end else
  begin
    if lvCutlist.SelCount > 0 then
    begin
      dcut := StrToInt(lvCutlist.Selected.Caption);
      cutlist.ReplaceCut(pos_from, pos_to, dCut);
    end else
      enable_del_buttons(False);
  end;
end;

procedure TFMain.actEditCutExecute(Sender: TObject);
var
  dcut: Integer;
begin
  if lvCutlist.SelCount > 0 then
  begin
    dcut := StrToInt(lvCutlist.Selected.Caption);
    pos_from := cutlist[dcut].pos_from;
    pos_to := cutlist[dcut].pos_to;
    refresh_times;
  end else
    enable_del_buttons(False);
end;

procedure TFMain.actDeleteCutExecute(Sender: TObject);
begin
  if lvCutlist.SelCount > 0 then
    cutlist.DeleteCut(StrToInt(lvCutlist.Selected.Caption))
  else
    enable_del_buttons(False);
end;

procedure TFMain.actShowFramesFormExecute(Sender: TObject);
begin
  FFrames.Show;
end;

procedure TFMain.actNextFramesExecute(Sender: TObject);
var
  c: TCursor;
begin
  if MovieInfo.MovieLoaded then
  begin
    c := Cursor;
    try
      EnableMovieControls(False);
      Cursor := crHourGlass;
      Application.ProcessMessages;
      ShowFrames(1, FFrames.Count);
    finally
      EnableMovieControls(True);
      Cursor := c;
    end;
  end;
end;

procedure TFMain.actCurrentFramesExecute(Sender: TObject);
var
  c: TCursor;
  halfFrames: Integer;
begin
  if MovieInfo.MovieLoaded then
  begin
    c := Cursor;
    try
      EnableMovieControls(False);
      Cursor := crHourGlass;
      Application.ProcessMessages;
      halfFrames := 1 + FFrames.Count div 2;
      ShowFrames(1 - halfFrames, FFrames.Count - halfFrames);
    finally
      EnableMovieControls(True);
      Cursor := c;
    end;
  end;
end;

procedure TFMain.actPrevFramesExecute(Sender: TObject);
var
  c: TCursor;
begin
  if MovieInfo.MovieLoaded then
  begin
    c := Cursor;
    try
      EnableMovieControls(False);
      Cursor := crHourGlass;
      Application.ProcessMessages;
      ShowFrames(-1 * FFrames.Count, -1);
    finally
      EnableMovieControls(True);
      Cursor := c;
    end;
  end;
end;

procedure TFMain.actScanIntervalExecute(Sender: TObject);
var
  i1, i2: Integer;
  pos1, pos2: Double;
  c: TCursor;
begin
  if MovieInfo.MovieLoaded then
  begin
    i1 := FFrames.scan_1;
    i2 := FFrames.scan_2;

    if (i1 = -1) or (i2 = -1) then
    begin
      pos1 := tbFilePos.SelStart;
      pos2 := tbFilePos.SelEnd;
    end else
    begin
      if i1 > i2 then
      begin
        i1 := i2;
        i2 := FFrames.scan_1;
      end;
      pos1 := FFrames.Frame[i1].position;
      FFrames.Frame[i1].BorderVisible := False;
      pos2 := FFrames.Frame[i2].position;
      FFrames.Frame[i2].BorderVisible := False;
    end;

    c := Cursor;
    Cursor := crHourGlass;
    try
      EnableMovieControls(False);
      actScanInterval.Enabled := False;
      Application.ProcessMessages;

      ShowFramesAbs(pos1, pos2, FFrames.Count);
    finally
      EnableMovieControls(True);
      actScanInterval.Enabled := True;
      Cursor := c;
    end;
  end;
end;

procedure TFMain.actEditSettingsExecute(Sender: TObject);
begin
  settings.Edit;
  SettingsChanged;
end;

procedure TFMain.SettingsChanged;
begin
  with WebRequest_nl do
  begin
    Request.UserAgent := 'CutAssistant ' + Utils.Application_version + ' (Indy Library)';
    with Request.CustomHeaders do
    begin
      Values['X-CA-Version']  := 'CutAssistant ' + Utils.Application_version;
      Values['X-CA-Protocol'] := '1';
    end;
    ConnectTimeout := 1000 * Settings.NetTimeout;
    ReadTimeout    := 1000 * Settings.NetTimeout;
    with ProxyParams do
    begin
      ProxyServer   := Settings.proxyServerName;
      ProxyPort     := Settings.proxyPort;
      ProxyUsername := Settings.proxyUserName;
      ProxyPassword := Settings.proxyPassword;
    end;
  end;
end;

procedure TFMain.actStartCuttingExecute(Sender: TObject);
begin
  StartCutting;
end;

procedure TFMain.actMergeCutExecute(Sender: TObject);
var
  I,J: Integer;
  F,T: Double;
begin
  if lvCutlist.SelCount = 1 then
  begin
    I := StrToInt(lvCutlist.Selected.Caption);
    J := -1;

    if I = 0 then
    begin
      if YesNoMsgFmt(RsMergeCutAsk1, [0, 1]) then
        J := 1;
    end else
      if I = Pred(lvCutlist.Items.Count) then
      begin
        if YesNoMsgFmt(RsMergeCutAsk1, [I, Pred(I)]) then
          J := Pred(I);
      end else
      begin
        case YesNoCancelNamed(Format(RsMergeCutAsk2, [I, Pred(I), Succ(I)]), RsMergeCutPrev, RsMergeCutNext) of
          mrYes : J := Pred(I);
          mrNo  : J := Succ(I);
        end;
      end;

    if J >= 0 then
    begin
      if J < I then // swap I and J
      begin
        I := I + J;
        J := I - J;
        I := I - J;
      end;

      F := cutlist[I].pos_from;
      T := cutlist[J].pos_to;

      cutlist.DeleteCut(J);
      cutlist.DeleteCut(I);

      cutlist.AddCut(F, T);
    end;
  end;
end;

procedure TFMain.actMovieMetaDataExecute(Sender: TObject);
begin
  ShowMetaData;
end;

procedure TFMain.actUsedFiltersExecute(Sender: TObject);
begin
  FManageFilters.SourceGraph := FilterGraph;
  FManageFilters.ShowModal;
end;

procedure TFMain.actAboutExecute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure ForceOpenRegKey(const reg: TRegistry; const key: string);
var
  path: string;
begin
  if not reg.OpenKey(key, True) then
  begin
    if AnsiStartsStr('\', key) then
      path := key
    else
      path := reg.CurrentPath + '\' + key;

    raise ERegistryException.CreateResFmt(@RsExUnableToOpenKey, [path]);
  end;
end;

procedure TFMain.actWriteToRegistyExecute(Sender: TObject);
var
  reg: TRegistry;
  myDir: string;
begin
  myDir := Application.ExeName;
  reg   := TRegistry.Create;
  try
    try
      reg.RootKey := HKEY_CLASSES_ROOT;
      ForceOpenRegKey(reg, '\' + CUTLIST_EXTENSION);
      reg.WriteString('', CutlistID);
      reg.WriteString('Content type', CUTLIST_CONTENT_TYPE);
      reg.CloseKey;

      ForceOpenRegKey(reg, '\' + CutlistID);
      reg.WriteString('', RsRegDescCutlist);
      ForceOpenRegKey(reg, 'DefaultIcon');
      reg.WriteString('', '"' + myDir + '",0');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\' + CutlistID + '\Shell\open');
      reg.WriteString('', RsRegDescCutlistOpen);
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -cutlist:"%1"');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\WMVFile\Shell\' + ShellEditKey);
      reg.WriteString('', RsRegDescMovieOpen);
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -open:"%1"');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\AVIFile\Shell\' + ShellEditKey);
      reg.WriteString('', RsRegDescMovieOpen);
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -open:"%1"');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\QuickTime.mp4\Shell\' + ShellEditKey);
      reg.WriteString('', RsRegDescMovieOpen);
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -open:"%1"');
      reg.CloseKey;

      ForceOpenRegKey(reg, '\Applications\' + ProgID + '\shell\open');
      reg.WriteString('FriendlyAppName', 'Cut Assistant');
      ForceOpenRegKey(reg, 'command');
      reg.WriteString('', '"' + myDir + '" -open:"%1"');
      reg.CloseKey;
    finally
      FreeAndNil(reg);
    end;
  except
    on E: ERegistryException do
      ShowExpectedException(E, RsErrorRegisteringApplication);
  end;
end;

procedure TFMain.actRemoveRegistryEntriesExecute(Sender: TObject);
var
  reg: TRegistry;
  myDir: string;
begin
  myDir := Application.ExeName;
  reg   := TRegistry.Create;
  try
    try
      reg.RootKey := HKEY_CLASSES_ROOT;
      if reg.OpenKey('\WMVFile\Shell', False) then
      begin
        reg.DeleteKey(ShellEditKey);
        reg.CloseKey;
      end;

      if reg.OpenKey('\AVIFile\Shell', False) then
      begin
        reg.DeleteKey(ShellEditKey);
        reg.CloseKey;
      end;

      if reg.OpenKey('\QuickTime.mp4\Shell', False) then
      begin
        reg.DeleteKey(ShellEditKey);
        reg.CloseKey;
      end;

      if reg.OpenKey('\Applications', False) then
      begin
        reg.DeleteKey(ProgID);
        reg.CloseKey;
      end;

      reg.DeleteKey('\' + CUTLIST_EXTENSION);
      reg.DeleteKey('\' + CutlistID);
    finally
      FreeAndNil(reg);
    end;
  except
    on E: ERegistryException do
      ShowExpectedException(E, RsErrorUnRegisteringApplication);
  end;
end;

procedure TFMain.rgCutModeClick(Sender: TObject);
begin
  case rgCutMode.ItemIndex of
    0: cutlist.Mode := clmCutOut;
    1: cutlist.Mode := clmTrim;
  end;
end;

procedure TFMain.actCutlistUploadExecute(Sender: TObject);
begin
  if cutlist.HasChanged then
  begin
    if not cutlist.Save(False) then //try to save it
      Exit;
  end;

  if not FileExists(cutlist.SavedToFilename) then
    Exit;

  if YesNoMsgFmt(RsMsgUploadCutlist, [cutlist.SavedToFilename, settings.url_cutlists_upload]) then
    UploadCutlist(cutlist.SavedToFilename);
end;

procedure TFMain.actStepForwardExecute(Sender: TObject);
var
  event: Integer;
begin
  if FilterGraph.State <> gsPaused then
    GraphPause;

  if Settings.NewNextFrameMethod then
  begin
    JumpTo(currentPosition + MovieInfo.frame_duration);
  end else
  begin
    //	inaccurate?
    if Assigned(FrameStep) then
    begin
      if Settings.AutoMuteOnSeek and not CBMute.Checked then
        FilterGraph.Volume := 0;
      FrameStep.Step(1, nil);
      MediaEvent.WaitForCompletion(500, event);
      tbFilePos.TriggerTimer;
      if Settings.AutoMuteOnSeek and not CBMute.Checked then
        FilterGraph.Volume := tbVolume.Position;
    end else
      actStepForward.Enabled := False;
  end;
end;

procedure TFMain.actStepBackwardExecute(Sender: TObject);
var
  timeToSkip: Double;
begin
  if FilterGraph.State <> gsPaused then
    GraphPause;

  if Sender = actLargeSkipBackward then
    timeToSkip := Settings.LargeSkipTime
  else if Sender = actSmallSkipBackward then
    timeToSkip := Settings.SmallSkipTime
  else if Sender = actLargeSkipForward then
    timeToSkip := -Settings.LargeSkipTime
  else if Sender = actSmallSkipForward then
    timeToSkip := -Settings.SmallSkipTime
  else
    timeToSkip := MovieInfo.frame_duration;

  JumpTo(currentPosition - timeToSkip);
end;

procedure TFMain.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  timeToSkip: Double;
begin
  if MovieInfo.MovieLoaded then
  begin
    Handled := True;
    if FilterGraph.State <> gsPaused then
      GraphPause;
    if shift = [ssShift] then
      timeToSkip := Settings.SmallSkipTime
    else if shift = [ssShift, ssCtrl] then
      timeToSkip := Settings.LargeSkipTime
    else if shift = [ssAlt] then
      timeToSkip := Settings.LargeSkipTime
    else
      timeToSkip := tbFilePos.PageSize * MovieInfo.frame_duration; ////////************

    JumpTo(currentPosition - timeToSkip * Sign(WheelDelta));
  end;
end;

procedure TFMain.actBrowseWWWHelpExecute(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(settings.url_help), '', '', SW_SHOWNORMAL);
end;

procedure TFMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  done: Boolean;
begin
  done := False;
  if Shift = [] then
    case key of
      Ord('K'), Ord(' '),
      VK_MEDIA_PLAY_PAUSE : done := actPlayPause.Execute;
      VK_MEDIA_STOP       : done := actStop.Execute;
      VK_MEDIA_NEXT_TRACK : done := actNextCut.Execute;
      VK_MEDIA_PREV_TRACK : done := actPrevCut.Execute;
      VK_BROWSER_BACK     : done := actStepBackward.Execute;
      VK_BROWSER_FORWARD  : done := actStepForward.Execute;
    end;

  if done then
    Key := 0;
end;

procedure TFMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if cutlist.HasChanged then
    case MessageDlg(RsTitleSaveChangedCutlist + #13#13 + RsMsgSaveChangedCutlist, mtConfirmation, mbYesNoCancel, 0, mbCancel) of
      mrYes : CanClose := cutlist.Save(False); //Can Close if saved successfully
      mrNo  : CanClose := True;
      else    CanClose := False;
    end;
end;

procedure TFMain.actOpenCutlistHomeExecute(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(settings.url_cutlists_home), '', '', SW_SHOWNORMAL);
end;

procedure TFMain.CloseMovie;
begin
  if filtergraph.Active then
  begin
    filtergraph.Stop;
    filtergraph.Active := False;
    filtergraph.ClearGraph;
    SampleGrabber.FilterGraph   := nil;
    KeyFrameGrabber.FilterGraph := nil;
    TeeFilter.FilterGraph       := nil;
    NullRenderer.FilterGraph    := nil;
    // AviDecompressor.FilterGraph := nil;

    UpdatePlayPauseButton;
  end;
  MovieInfo.current_filename := '';
  MovieInfo.current_filesize := -1;
  MovieInfo.MovieLoaded      := False;
  if Assigned(FFrames) then
    FFrames.HideFrames;

  tbFilePos.Position := 0;
  tbFilePos.TriggerTimer;

  ResetForm;
end;

function TFMain.RepairMovie: Boolean;
var
  filename_temp, file_ext, filename_damaged, command, AppPath: string;
  exitCode: DWORD;
  selectFileDlg: TOpenDialog;
  CutApplication: TCutApplicationAsfbin;
begin
  Result := False;
  if not (movieinfo.MovieType in [mtWMV]) then
    Exit;

  CutApplication := Settings.GetCutApplicationByName('Asfbin') as TCutApplicationAsfbin;
  if not Assigned(CutApplication) then
  begin
    if not batchmode then
      ErrMsg(RsCutAppAsfBinNotFound);
    Exit;
  end;

  if MovieInfo.current_filename = '' then
  begin
    selectFileDlg := TOpenDialog.Create(Self);
    selectFileDlg.Filter  := RsFilterDescriptionAsf + '|*.wmv;*.asf|' + RsFilterDescriptionAll + '|*.*';
    selectFileDlg.Options := selectFileDlg.Options + [ofPathMustExist, ofFileMustExist, ofNoChangeDir];
    selectFileDlg.Title   := RsTitleRepairMovie;
    if selectFileDlg.Execute then
    begin
      filename_temp := selectFileDlg.FileName;
      FreeAndNil(selectFileDlg);
    end else
    begin
      FreeAndNil(selectFileDlg);
      Exit;
    end;
  end else
  begin
    filename_temp := MovieInfo.current_filename;
  end;

  file_ext := ExtractFileExt(filename_temp);
  filename_damaged := ChangeFileExt(filename_temp, '.damaged' + file_ext);

  if not MessageDlg(Format(RsMsgRepairMovie, [ExtractFileName(CutApplication.Path), filename_damaged]), mtConfirmation, mbYesNo, 0) = mrYes then
    Exit;

  CloseMovie;

  if not renameFile(filename_temp, filename_damaged) then
  begin
    if not batchmode then
      ErrMsg(RsMsgRepairMovieRenameFailed);
    Exit;
  end;

  command := '-i "' + filename_damaged + '" -o "' + filename_temp + '"';
  AppPath := '"' + CutApplication.Path + '"';
  try
    Result := STO_ShellExecute(AppPath, Command, INFINITE, False, exitCode);
  finally
    {
    if ExitCode > 0 then
    begin
      MessageD ('Could not repair file. ExitCode = ' + IntToStr(ExitCode));
      Result := False;
    end;
    }
    if Result then
    begin
      if YesNoMsg(RsMsgRepairMovieFinished) then
        OpenFile(filename_temp);
    end else
      renameFile(filename_damaged, filename_temp);
  end;
end;

procedure TFMain.actRepairMovieExecute(Sender: TObject);
begin
  RepairMovie;
end;

procedure TFMain.actCutlistInfoExecute(Sender: TObject);
begin
  cutlist.EditInfo;
end;

procedure TFMain.actSaveCutlistExecute(Sender: TObject);
begin
  if cutlist.Save(False) then
    if not batchmode then
      InfMsgFmt(RsCutlistSavedAs, [cutlist.SavedToFilename]);
end;

procedure TFMain.actCalculateResultingTimesExecute(Sender: TObject);
var
  selectFileDlg: TOpenDialog;
  AskForPath: Boolean;
begin
  AskForPath := Settings.MovieNameAlwaysConfirm or not FileExists(MovieInfo.target_filename) or (MovieInfo.target_filename = '');
  if not BatchMode and AskForPath then
  begin
    selectFileDlg := TOpenDialog.Create(Self);
    try
      selectFileDlg.Filter := MakeFilterString(RsFilterDescriptionAllSupported,
        FilterStringFromExtArray(WMV_EXTENSIONS)  + ';' +
        FilterStringFromExtArray(AVI_EXTENSIONS)  + ';' +
        FilterStringFromExtArray(MP4_EXTENSIONS)) + '|' +
        MakeFilterString(RsFilterDescriptionAll, '*.*');

      selectFileDlg.Options := selectFileDlg.Options + [ofPathMustExist, ofFileMustExist, ofNoChangeDir];
      selectFileDlg.Title := RsTitleCheckCutMovie;
      if MovieInfo.target_filename = '' then
      begin
        selectFileDlg.InitialDir := settings.CutMovieSaveDir;
      end else
      begin
        selectFileDlg.InitialDir := ExtractFileDir(MovieInfo.target_filename);
        selectFileDlg.FileName   := MovieInfo.target_filename;
      end;
      if selectFileDlg.Execute then
        MovieInfo.target_filename := selectFileDlg.FileName
      else
        Exit;
    finally
      FreeAndNil(selectFileDlg);
    end;
  end;

  if not FileExists(MovieInfo.target_filename) then
  begin
    if not batchmode then
      ErrMsg(RsErrorMovieNotFound);
    Exit;
  end;

  try
    if not FResultingTimes.loadMovie(MovieInfo.target_filename) then
    begin
      if not batchmode then
        ErrMsg(RsErrorCouldNotLoadMovie);
      Exit;
    end;
    FResultingTimes.calculate(cutlist);
    FResultingTimes.Show;
  except
    on E: Exception do
      if not batchmode then
        ErrMsgFmt(RsErrorCouldNotLoadCutMovie, [E.Message]);
  end;
end;

procedure TFMain.actAsfbinInfoExecute(Sender: TObject);
var
  info: string;
  CutApplication: TCutApplicationBase;
begin
  info := '';

  CutApplication := Settings.GetCutApplicationByMovieType(mtWMV);
  if Assigned(CutApplication) then
  begin
    info := info + RsCutApplicationWmv + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  end;

  CutApplication := Settings.GetCutApplicationByMovieType(mtAVI);
  if Assigned(CutApplication) then
  begin
    info := info + RsCutApplicationAvi + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  end;

  CutApplication := Settings.GetCutApplicationByMovieType(mtHQAVI);
  if Assigned(CutApplication) then
  begin
    info := info + RsCutApplicationHqAvi + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  end;

  CutApplication := Settings.GetCutApplicationByMovieType(mtHDAVI);
  if Assigned(CutApplication) then
  begin
    info := info + RsCutApplicationHdAvi + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  end;

  CutApplication := Settings.GetCutApplicationByMovieType(mtMP4);
  if Assigned(CutApplication) then
  begin
    info := info + RsCutApplicationMp4 + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  end;

  CutApplication := Settings.GetCutApplicationByMovieType(mtUnknown);
  if Assigned(CutApplication) then
  begin
    info := info + RsCutApplicationOther + #13#10;
    info := info + CutApplication.InfoString + #13#10;
  end;

  frmMemoDialog.Caption := RsTitleCutApplicationSettings;
  frmMemoDialog.memInfo.Clear;
  frmMemoDialog.memInfo.Text := info;
  frmMemoDialog.ShowModal;
end;

function TFMain.SearchCutlistsByFileSize_Local(SearchType: TCutlistSearchType): Integer;
var
  Error_message,searchDir,fileBase,fileName: string;
  sr: TSearchRec;
  ACutlist: TCutlist;
  lvLinks: TListView;
  dupItem: TListItem;
  idx: Integer;
begin
  Result := 0;
  Error_message := RsErrorUnknown;

  if (SearchType = cstBySize) and (MovieInfo.current_filesize > 0) or
     (SearchType = cstByName) and (MovieInfo.current_filename <> '') then
  begin
    if Settings.SaveCutlistMode = smGivenDir then
      searchDir := ExtractFileDir(MovieInfo.current_filename)
    else
    begin
      searchDir := Settings.CutlistSaveDir;
      if not IsPathRooted(searchDir) then
        searchDir := PathCombine(ExtractFileDir(MovieInfo.current_filename), searchDir);
    end;

    FCutlistSearchResults.MovieTypeName := FileNameToFormatName(MovieInfo.current_filename);

    fileBase := ChangeFileExt(ExtractFileName(MovieInfo.current_filename), '');
    lvLinks  := FCutlistSearchResults.lvLinklist;

    lvLinks.Items.BeginUpdate;
    try
      if FindFirst(PathCombine(searchDir, '*' + CUTLIST_EXTENSION), faArchive, sr) = 0 then
      begin
        repeat
          ACutlist := TCutlist.Create(Settings, MovieInfo);
          try
            if not ACutlist.LoadFromFile(PathCombine(searchDir, sr.Name), True) then
              Continue;
            case SearchType of
              cstBySize:
                if (ACutlist.OriginalFileSize <> MovieInfo.current_filesize) then
                  Continue;
              cstByName:
                if not AnsiStartsText(fileBase, sr.Name) then
                  Continue;
            end;
            idx := 0;
            while idx < lvLinks.Items.Count do
            begin
              dupItem := lvLinks.Items.Item[idx];
              if not Assigned(dupItem) then
              begin
              end else if (ACutlist.IDOnServer <> '') and (dupItem.Caption = ACutlist.IDOnServer) then
              begin
                Break
              end else if (dupItem.SubItems.IndexOf(RsLocalCutlist) > -1)
                and (dupItem.SubItems.IndexOf(ExtractFileName(ACutlist.SavedToFilename)) > -1)
                and (dupItem.SubItems.IndexOf(ExtractFileDir(ACutlist.SavedToFilename)) > -1) then
                begin
                Break;
              end;
              Inc(idx);
            end;
            if idx < lvLinks.Items.Count then
              Continue;

            with lvLinks.Items.Add do
            begin
              Caption := ACutlist.IDOnServer;
              fileName := ExtractFileName(ACutlist.SavedToFilename);
              SubItems.Add(fileName);
              SubItems.Add(FileNameToFormatName(fileName));
              SubItems.Add(IfThen(ACutlist.IDOnServer = '', '', Format('%f', [ACutlist.RatingOnServer])));
              SubItems.Add(IfThen(ACutlist.IDOnServer = '', '', IntToStr(ACutlist.RatingCountOnServer)));
              SubItems.Add(IfThen(ACutlist.RatingByAuthorPresent, IntToStr(ACutlist.RatingByAuthor), ''));
              SubItems.Add(ACutlist.Author);
              SubItems.Add(ACutlist.SuggestedMovieName);
              SubItems.Add(ACutlist.UserComment);
              SubItems.Add(ACutlist.ActualContent);
              SubItems.Add(RsLocalCutlist);
              SubItems.Add(IfThen(ACutlist.DownloadTime <= 0, '', FormatDateTime('', UnixToDateTime(ACutlist.DownloadTime))));
              SubItems.Add(ExtractFileDir(ACutlist.SavedToFilename));
            end;
            Inc(Result);
          finally
            FreeAndNil(ACutlist);
          end;
        until FindNext(sr) <> 0;
        FindClose(sr);
      end;
    finally
      lvLinks.Items.EndUpdate;
    end;
  end;
end;

function TFMain.SearchCutlistsByFileSize_XML(SearchType: TCutlistSearchType; IgnorePrefix: Boolean = False): Integer;
const
  php_name                         = 'getxml.php';
var
  WebResult                        : Boolean;
  url, Error_message               : string;
  Response                         : string;
  cutFilename                      : string;
  Node, CutNode                    : TJCLSimpleXMLElems;
  idx                              : Integer;
  lvLinks                          : TListView;
begin
  Result := 0;
  Error_message := RsErrorUnknown;
  case SearchType of
    cstBySize: begin
        if (MovieInfo.current_filesize = 0) then
          Exit;
        url := settings.url_cutlists_home
          + php_name
          + '?ofsb='
          + IntToStr(MovieInfo.current_filesize)
      end;
    cstByName: begin
        if (MovieInfo.current_filename = '') then
          Exit;

        // From idURI.pas
        // RLebeau 6/9/2017: if LChar is '%', check if it belongs to a pre-encoded
        // '%HH' octet, and if so then preserve the whole sequence as-is...

        // So first encode
        url := TIdURI.ParamsEncode(ExtractBaseFileNameOTR(MovieInfo.current_filename));

        // Then add % as prefix
        if IgnorePrefix then
          url := '%25' + url;

        url := settings.url_cutlists_home
          + php_name
          + '?name='
          + url;
      end;
  else
    Exit;
  end;

  url := url + '&' + Utils.GetVersionRequestParams;
  WebResult := DoHttpGet(url, False, error_message, Response);

  if WebResult and (Length(response) > 5) then
  begin
    FCutlistSearchResults.MovieTypeName := FileNameToFormatName(MovieInfo.current_filename);

    lvLinks := FCutlistSearchResults.lvLinklist;
    lvLinks.Items.BeginUpdate;
    try
      try
        XMLResponse.LoadFromString(Response);

        if XMLResponse.Root.ChildsCount > 0 then
        begin
          Node := XMLResponse.Root.Items;
          for idx := 0 to Pred(node.Count) do
          begin
            CutNode := node.Item[idx].Items;
            if Assigned(lvLinks.FindCaption(0, CutNode.ItemNamed['id'].Value, False, True, False)) then
              Continue;
            with lvLinks.Items.Add do
            begin
              Caption := CutNode.ItemNamed['id'].Value;
              cutFilename := CutNode.ItemNamed['name'].Value;
              if not AnsiEndsText(CUTLIST_EXTENSION, cutFilename) then
                cutFilename := cutFilename + CUTLIST_EXTENSION;
              SubItems.Add(cutFilename);
              SubItems.Add(FileNameToFormatName(cutFilename));
              SubItems.Add(CutNode.ItemNamed['rating'].Value);
              SubItems.Add(CutNode.ItemNamed['ratingcount'].Value);
              SubItems.Add(CutNode.ItemNamed['ratingbyauthor'].Value);
              SubItems.Add(CutNode.ItemNamed['author'].Value);
              SubItems.Add(CutNode.ItemNamed['filename'].Value);
              SubItems.Add(CutNode.ItemNamed['usercomment'].Value);
              SubItems.Add(CutNode.ItemNamed['actualcontent'].Value);
              SubItems.Add(RsServerCutlist);
              SubItems.Add(''); // download timestamp
              SubItems.Add(''); // path information
            end;
            Inc(Result);
          end;
        end;
      except
        on E: EJclSimpleXMLError do
          if not batchmode then
            ErrMsgFmt(RsErrorSearchCutlistXml, [E.Message]);
      end;
    finally
      lvLinks.Items.EndUpdate;
    end;
  end;
end;

procedure TFMain.SelectStyleClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    TStyleManager.TrySetStyle(StripHotkey(TMenuItem(Sender).Caption));
end;

procedure TFMain.actSearchCutlistByFileSizeExecute(Sender: TObject);
var
  SearchTypes                      : TCutlistSearchTypes;
begin
  SearchTypes := [cstBySize];
  if Settings.SearchCutlistsByName then
    SearchTypes := SearchTypes + [cstByName];
  SearchCutlists(False, ShiftDown, True, SearchTypes);
end;

procedure TFMain.actSearchCutlistLocalExecute(Sender: TObject);
var
  SearchTypes                      : TCutlistSearchTypes;
begin
  SearchTypes := [cstBySize];
  if Settings.SearchCutlistsByName then
    SearchTypes := SearchTypes + [cstByName];
  SearchCutlists(False, True, ShiftDown, SearchTypes);
end;

function TFMain.SearchCutlists(AutoOpen: Boolean; SearchLocal, SearchWeb: Boolean; SearchTypes: TCutlistSearchTypes): Boolean;
var
  numFound: Integer;
  WebResult: Boolean;
  selectedItem: TListItem;
  cutFilename, cutFiledir: string;
  SearchType: TCutlistSearchType;
begin
  FCutlistSearchResults.lvLinklist.Clear;
  numFound := 0;
  Result := False;

  for SearchType := Low(SearchType) to High(SearchType) do
  begin
    if SearchType in SearchTypes then
    begin
      if SearchWeb then
      begin
        if Settings.ExtendedSearchMode = esmAlways then
        begin
          numFound := numFound + SearchCutlistsByFileSize_XML(SearchType, True);
        end else
        begin
          numFound := numFound + SearchCutlistsByFileSize_XML(SearchType);

          if (numFound = 0) and (SearchType = cstByName) and (Settings.ExtendedSearchMode = esmOnDemand) and (MessageDlg(RSIgnorePrefix, mtConfirmation, mbYesNo, 0) = mrYes) then
            numFound := numFound + SearchCutlistsByFileSize_XML(SearchType, True);
        end;
      end;

      if SearchLocal then
        numFound := numFound + SearchCutlistsByFileSize_Local(SearchType);
    end;
  end;

  if numFound < 0 then
    Exit;

  if numFound = 0 then
  begin
    if not batchmode then
      ErrMsg(RsMsgSearchCutlistNoneFound, Settings.NoNotFoundMsg);
    Exit;
  end;

  if AutoOpen and (numFound = 1) then
    selectedItem := FCutlistSearchResults.lvLinklist.Items[0]
  else if BatchMode and (numFound = 1) then
    selectedItem := FCutlistSearchResults.lvLinklist.Items[0]
  else if BatchMode and (Settings.Additional['ShowSearchResultInBatch'] <> '1') then
    selectedItem := FCutlistSearchResults.lvLinklist.Items[0]
  else if FCutlistSearchResults.ShowModal = mrOK then
    selectedItem := FCutlistSearchResults.lvLinklist.Selected
  else
    selectedItem := nil;

  if Assigned(selectedItem) then
  begin
    cutFilename := selectedItem.SubItems[0];
    cutFiledir  := selectedItem.SubItems[Pred(selectedItem.SubItems.Count)];
    if cutFiledir <> '' then
    begin
      if not CloseCutlist then
        Exit;
      cutFilename := PathCombine(cutFiledir, cutFilename);
      CutList.LoadFromFile(cutFilename);
    end else
    begin
      WebResult := DownloadCutlistByID(selectedItem.Caption, cutFilename);
      if WebResult then
      begin
        cutlist.IDOnServer := selectedItem.Caption;
        cutlist.RatingOnServer := StrToFloatDefInv(selectedItem.SubItems[1], -1);
        cutlist.RatingCountOnServer := StrToIntDef(selectedItem.SubItems[2], -1);
        cutlist.DownloadTime := DateTimeToUnix(Now);
        if Settings.AutoSaveDownloadedCutlists and (cutlist.SavedToFilename <> '') then
          cutlist.AddServerInfos(cutlist.SavedToFilename);
      end;
    end;
    actSendRating.Enabled := Cutlist.IDOnServer <> '';
  end;
  Result := True;
end;

function TFMain.SendRating(Cutlist: TCutlist): Boolean;
const
  php_name                         = 'rate.php';
var
  Response, Error_message, url     : string;
begin
  Result := False;
  if cutlist.IDOnServer = '' then
  begin
    actSendRating.Enabled := False;
    if not batchmode then
      WarnMsg(RsMsgSendRatingNotPossible);
    Exit;
  end else
  begin
    if (cutlist.RatingOnServer >= 0.0) and cutlist.RatingByAuthorPresent then
      FCutlistRate.SelectedRating := Round(cutlist.RatingByAuthor + cutlist.RatingOnServer)
    else if cutlist.RatingOnServer >= 0.0 then
      FCutlistRate.SelectedRating := Round(cutlist.RatingOnServer)
    else if cutlist.RatingByAuthorPresent then
      FCutlistRate.SelectedRating := cutlist.RatingByAuthor
    else
      FCutlistRate.SelectedRating := -1;
    if FCutlistRate.ShowModal = mrOK then
    begin
      Error_message := RsErrorUnknown;
      url := settings.url_cutlists_home
        + php_name
        + '?rate=' + cutlist.IDOnServer
        + '&rating=' + IntToStr(FCutlistRate.SelectedRating)
        + '&userid=' + settings.UserID
        + '&protocol=' + IntToStr(ServerProtocol)
        + '&' + Utils.GetVersionRequestParams;
      Result := DoHttpGet(url, True, Error_message, Response);

      if Result then
      begin
        Error_Message := CheckResponse(Response, ServerProtocol, cscRate);
        if Error_message = '' then
        begin
          cutlist.RatingSent := FCutlistRate.SelectedRating;
          if not batchmode then
            InfMsg(RsMsgSendRatingDone, Settings.NoRateSuccMsg);
        end;
      end;
      if not batchmode and (Error_message <> '') then
        ErrMsgFmt(RsMsgSendRatingNotDone + RsMsgAnswerFromServer, [Error_message]);
    end;
  end;
end;

procedure TFMain.actSendRatingExecute(Sender: TObject);
begin
  SendRating(cutlist);
end;

procedure TFMain.SampleGrabberSample(sender: TObject; SampleTime: Double;
  ASample: IMediaSample);
var
  pBuffer                          : PByte;
  BufferLen                        : Integer;
begin
  if not SampleInfo.Active then
    Exit;
  SampleInfo.SampleTime := SampleTime;
  SampleInfo.IsKeyFrame := ASample.IsSyncPoint() = S_OK;
  BufferLen := asample.GetActualDataLength();
  SampleInfo.HasBitmap := Succeeded(asample.GetPointer(pBuffer));
  if SampleInfo.HasBitmap then
  begin
    CustomGetSampleGrabberBitmap(SampleInfo.Bitmap, pBuffer, BufferLen);
  end;
end;

procedure TFMain.KeyFrameGrabberSample(sender: TObject; SampleTime: Double; ASample: IMediaSample);
var
  IsKeyFrame                       : Boolean;
begin
  if not KeyFrameSampleInfo.Active then
    Exit;
  IsKeyFrame := ASample.IsSyncPoint() = S_OK;
  KeyFrameSampleInfo.SampleTime := SampleTime;
  KeyFrameSampleInfo.IsKeyFrame := IsKeyFrame;
end;

procedure TFMain.lvCutlistDblClick(Sender: TObject);
begin
  actEditCut.Execute;
end;

function TFMain.UploadCutlist(FileName: string): Boolean;
var
  Request                          : THttpRequest;
  Response, Answer                 : string;
  Cutlist_id                       : Integer;
  lines                            : TStringList;
  begin_answer                     : Integer;
begin
  Result := False;

  if FileExists(FileName) then
  begin
    Request := THttpRequest.Create(
      settings.url_cutlists_upload,
      True,
      RsErrorUploadCutlist);
    Request.IsPostRequest := True;
    try
      with Request.PostData do
      begin
        AddFormField('MAX_FILE_SIZE', '1587200');
        AddFormField('confirm', 'True');
        AddFormField('type', 'blank');
        AddFormField('userid', settings.UserID);
        AddFormField('app', 'CutAssistant');
        AddFormField('version', Application_version);
        AddFile('userfile[]', FileName, 'multipart/form-data');
      end;
      Result   := DoHttpRequest(Request);
      Response := Request.Response;

      lines := TStringList.Create;
      try
        lines.Delimiter := #10;
        lines.NameValueSeparator := '=';
        lines.DelimitedText := Response;
        if TryStrToInt(lines.values['id'], Cutlist_id) then
        begin
          AddUploadDataEntry(Now, ExtractFileName(FileName), Cutlist_id);
          UploadDataEntries.SaveToFile(UploadData_Path(True));
        end;
        begin_answer := LastDelimiter(#10, response) + 1;
        Answer := midstr(response, begin_answer, Length(response) - begin_answer + 1); //Last Line
      finally
        FreeAndNil(lines);
      end;
      if not batchmode then
        InfMsgFmt(RsMsgAnswerFromServer, [answer]);
    finally
      FreeAndNil(Request);
    end;
  end;
end;

procedure TFMain.actDeleteCutlistFromServerExecute(Sender: TObject);
var
  datestring                       : string;
  idx                              : Integer;
  entry                            : string;
  function NextField(var s: string; const d: Char): string;
  begin
    Result := '';
    while (s <> '') do
    begin
      if s[1] = d then
      begin
        Delete(s, 1, 1);
        Break;
      end;
      Result := Result + s[1];
      Delete(s, 1, 1);
    end;
  end;
begin
  if FUploadList.Visible then
    Exit;
  //Fill ListView
  FUploadList.lvLinklist.Clear;
  for idx := 0 to Pred(UploadDataEntries.Count) do
  begin
    entry := Copy(UploadDataEntries.Strings[idx], 1, MaxInt);
    with FUploadList.lvLinklist.Items.Add do
    begin
      Caption := NextField(entry, '=');
      SubItems.Add(NextField(entry, ';'));
      dateTimeToString(DateString, 'ddddd tt', StrToFloat(NextField(entry, ';')));
      SubItems.Add(DateString);
    end;
  end;

  //Show Dialog and delete cutlist
  if (FUploadList.ShowModal = mrOK) and (FUploadList.lvLinklist.SelCount = 1) then
  begin
    if DeleteCutlistFromServer(FUploadList.lvLinklist.Selected.Caption) then
    begin
      //Success, so delete record in upload list
      UploadDataEntries.Delete(FUploadList.lvLinklist.ItemIndex);
      UploadDataEntries.SaveToFile(UploadData_Path(True));
    end;
  end;
end;

function TFMain.DeleteCutlistFromServer(const cutlist_id: string): Boolean;
const
  php_name                         = 'delete_cutlist.php';
var
  url, Response, Error_message     : string;
begin
  Result := False;
  if cutlist_id = '' then Exit;

  Error_message := RsErrorUnknown;
  url := settings.url_cutlists_home + php_name + '?'
    + 'cutlistid=' + cutlist_id
    + '&userid=' + settings.UserID
    + '&protocol=' + IntToStr(ServerProtocol)
    + '&' + Utils.GetVersionRequestParams;

  Result := DoHttpGet(url, True, Error_message, Response);

  if Result then
  begin
    Error_Message := CheckResponse(Response, ServerProtocol, cscDelete);
    if not batchmode and (Error_message <> '') then
      ErrMsg(Error_message);
  end;
end;

procedure TFMain.tbFilePosChannelPostPaint(Sender: TDSTrackBarEx;
  const ARect: TRect);
var
  scale                            : Double;
  iCut                             : Integer;
  CutRect                          : TRect;
begin
  if MovieInfo.current_file_duration = 0 then Exit;
  if cutlist.Mode = clmTrim then
    tbFilePos.ChannelCanvas.Brush.Color := clgreen
  else
    tbFilePos.ChannelCanvas.Brush.Color := clred;
  scale := (ARect.Right - ARect.Left) / MovieInfo.current_file_duration; //pixel per second
  CutRect := ARect;
  for iCut := 0 to Pred(cutlist.Count) do
  begin
    CutRect.Left := ARect.Left + Round(Cutlist[iCut].pos_from * scale);
    CutRect.Right := ARect.Left + Round(Cutlist[iCut].pos_to * scale);
    if CutRect.right >= CutRect.Left then
      tbFilePos.ChannelCanvas.FillRect(CutRect);
  end;
end;

function TFMain.AskForUserRating(Cutlist: TCutlist): Boolean;
//True = user rated or decided not to rate, or no rating necessary
//False = abort operation
var
  userIsAuthor: Boolean;
begin
  Result := False;
  userIsAuthor := Cutlist.Author = settings.UserName;
  if (Cutlist.UserShouldSendRating) and not userIsAuthor then
  begin
    case MessageDlg(RsMsgAskUserForRating, mtConfirmation, mbYesNoCancel, 0) of
      mrYes : Result := SendRating(Cutlist);
      mrNo  : Result := True;
    end;
  end else
    Result := True;
end;

procedure TFMain.WMCopyData(var msg: TWMCopyData);
begin
  HandleSendCommandline(msg.CopyDataStruct^, HandleParameter);
end;

procedure TFMain.AddUploadDataEntry(CutlistDate: TDateTime; CutlistName: string; CutlistID: Integer);
begin
  UploadDataEntries.Add(Format('%d=%s;%f', [CutlistID, CutlistName, CutlistDate]));
end;

procedure TFMain.AppCommandAppCommand(Handle: NativeUInt; Cmd: Word; Device: TJvAppCommandDevice; KeyState: Word;
  var Handled: Boolean);
begin
  case Cmd of // Force Handled for specific commands ...
    APPCOMMAND_BROWSER_BACKWARD:
      Handled := actStepBackward.Execute or True;
    APPCOMMAND_BROWSER_FORWARD:
      Handled := actStepForward.Execute or True;
    APPCOMMAND_MEDIA_PLAY_PAUSE:
      Handled := actPlayPause.Execute or True;
    APPCOMMAND_MEDIA_STOP:
      Handled := actStop.Execute or True;
    APPCOMMAND_MEDIA_NEXTTRACK:
      Handled := actNextCut.Execute or True;
    APPCOMMAND_MEDIA_PREVIOUSTRACK:
      Handled := actPrevCut.Execute or True;
  end;
end;

procedure TFMain.HandleParameter(const param: string);
var
  FileList                         : TStringLIst;
begin
  FileList := TStringList.Create;
  try
    FileList.Text := param;
    ProcessFileList(FileList, False);
  finally
    FreeAndNil(FileList);
  end;
end;

function TFMain.GraphPlayPause: Boolean;
begin
  if filtergraph.State = gsPlaying then
    Result := GraphPause
  else
    Result := GraphPlay;

  UpdatePlayPauseButton;
end;

function TFMain.GraphPause: Boolean;
begin
  if FilterGraph.State = gsPaused then
    Result := True
  else
    Result := FilterGraph.Pause;

  if Result then
  begin
    cmdFF.Enabled := False;
    tbFilePos.TriggerTimer;

    UpdatePlayPauseButton;
  end;
end;

function TFMain.GraphPlay: Boolean;
var
  ACurrent: Double;
  ACut: TCut;
begin
  if FilterGraph.State = gsPlaying then
    Result := True
  else begin
    if cbCutPreview.Checked then
    begin
      ACurrent := CurrentPosition;
      ACut := Cutlist.FindCut(ACurrent);
      if not Assigned(ACut) then
        ACut := Cutlist.FindCut(Cutlist.NextCutPos(ACurrent))
      else if ACut.pos_to <= ACurrent then
        ACut := Cutlist.FindCut(Cutlist.NextCutPos(ACurrent + MovieInfo.frame_duration));

      if Assigned(ACut) then
        JumpToEx(IfThen(ACurrent < ACut.pos_from, ACut.pos_from, ACurrent), ACut.pos_to);
    end;
    Result := FilterGraph.Play
  end;

  if Result then
  begin
    cmdFF.Enabled := True;
    tbFilePos.TriggerTimer;

    UpdatePlayPauseButton;
  end;
end;

procedure TFMain.VideoWindowClick(Sender: TObject);
begin
  if actPlayPause.Enabled then
    actPlayPause.Execute;
end;

procedure TFMain.tbRateChange(Sender: TObject);
var
  NewRate: Double;
begin
  NewRate := Power(2, (TBRate.Position / 8));
  filtergraph.Rate := newRate;

  lblCurrentRate_nl.Caption := floattostrF(filtergraph.Rate, ffFixed, 15, 3) + 'x';
end;

function TFMain.CalcTrueRate(Interval: Double): Double;
//Interval: Interval since last call to CalcTrue Rate (same unit as current_position)
var
  pos, diff                        : Double;
begin
  Result := 0;
  if interval <= 0 then Exit;

  pos := CurrentPosition;
  diff := pos - last_pos;
  last_pos := pos;
  if diff > 0 then
    Result := diff / Interval;
end;

procedure TFMain.lblCurrentRate_nlDblClick(Sender: TObject);
begin
  TBRate.Position := 0;
end;

procedure TFMain.actNextCutExecute(Sender: TObject);
var
  CurPos, NewPos                   : Double;
begin
  CurPos := CurrentPosition;
  NewPos := cutlist.NextCutPos(CurPos + MovieInfo.frame_duration);
  if NewPos >= 0 then
  begin
    jumpTo(NewPos);
    UpdateCutControls(CurPos, NewPos);
  end;
end;

procedure TFMain.actPrevCutExecute(Sender: TObject);
var
  CurPos, NewPos                   : Double;
begin
  CurPos := CurrentPosition;
  NewPos := cutlist.PreviousCutPos(CurPos - MovieInfo.frame_duration);
  if NewPos >= 0 then
  begin
    jumpTo(NewPos);
    UpdateCutControls(CurPos, NewPos);
  end;
end;

procedure TFMain.UpdateCutControls(APreviousPos, ANewPos: Double);
var
  APrevCutIndex, ACutIndex         : Integer;
  APrevCut                         : TCut;
begin
  APrevCutIndex := cutlist.FindCutIndex(APreviousPos);
  ACutIndex := cutlist.FindCutIndex(ANewPos);
  if ACutIndex >= 0 then
  begin
    lvCutlist.ItemIndex := ACutIndex;
    if (edtFrom.Text = '') and (edtTo.Text = '') then
      actEditCut.Execute
    else if APrevCutIndex >= 0 then
    begin
      APrevCut := cutlist.Cut[APrevCutIndex];
      if (edtFrom.Text = MovieInfo.FormatPosition(APrevCut.pos_from)) and
        (edtTo.Text = MovieInfo.FormatPosition(APrevCut.pos_to)) then
        actEditCut.Execute;
    end;
  end;
end;

procedure TFMain.cmdFFMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FF_Start;
end;

procedure TFMain.FF_Start;
begin
  filtergraph.Rate := filtergraph.Rate * 2;
end;

procedure TFMain.FF_Stop;
begin
  TBRateChange(TBRate);
end;

procedure TFMain.cmdFFMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FF_Stop;
end;

procedure TFMain.VideoWindowDblClick(Sender: TObject);
begin
  ToggleFullScreen;
end;

function TFMain.ToggleFullScreen: Boolean;
//returns True if mode is now fullscreen
begin
  if MovieInfo.MovieLoaded then VideoWindow.FullScreen := not VideoWindow.FullScreen;
  Result := VideoWindow.FullScreen;
end;

procedure TFMain.actFullScreenExecute(Sender: TObject);
begin
  actFullScreen.Checked := ToggleFullScreen;
end;

procedure TFMain.VideoWindowKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and VideoWindow.FullScreen then
  begin
    actFullScreenExecute(Sender);
  end;
end;

procedure TFMain.actCloseMovieExecute(Sender: TObject);
begin
  CloseMovieAndCutlist;
end;

function TFMain.CloseCutlist: Boolean;
begin
  Result := False;
  if not AskForUserRating(cutlist) then Exit;
  if not CutList.clear_after_confirm then Exit;
  Result := True;
end;

function TFMain.CloseMovieAndCutlist: Boolean;
begin
  Result := False;
  if not CloseCutlist then Exit;
  if movieInfo.MovieLoaded then CloseMovie;
  Result := True;
end;

function TFMain.DownloadCutlistByID(const cutlist_id, TargetFileName: string): Boolean;
const
  php_name = 'getfile.php';
  Command  = '?id=';
var
  url: string;
  error_message, Response: string;
  cutlistfile: TMemIniFileEx;
  target_file, cutlist_path: string;
begin
  Result := False;
  case Settings.SaveCutlistMode of
    smWithSource : cutlist_path := ExtractFilePath(MovieInfo.current_filename);            // with source
    smGivenDir   : cutlist_path := IncludeTrailingPathDelimiter(Settings.CutlistSaveDir);  // in given Dir
    else           cutlist_path := ExtractFilePath(MovieInfo.current_filename);            // with source
  end;
  target_file := cutlist_path + TargetFileName;

  if cutlist.HasChanged and (not batchmode) then
  begin
    if not YesNoMsgFmt(RsDownloadCutlistWarnChanged, [TargetFileName, cutlist_id]) then
      Exit;
  end;

  Error_message := RsErrorUnknown;
  url := settings.url_cutlists_home + php_name + command + cleanurl(cutlist_id)
    + '&' + Utils.GetVersionRequestParams;

  if not DoHttpGet(url, False, error_message, Response) then
  begin
    if not batchmode then
      if YesNoMsg(Error_message + #13#10 + RsMsgOpenHomepage) then
        ShellExecute(0, nil, PChar(settings.url_cutlists_home), '', '', SW_SHOWNORMAL);
  end else
  begin
    if (Length(Response) < 5) then
    begin
      if not batchmode then
        ErrMsgFmt(RsDownloadCutlistInvalidData, [Length(Response)]);
      Exit;
    end;

    cutlistfile := TMemIniFileEx.Create('');
    try
      cutlistfile.LoadFromString(Response);              // UTF-8?

      if cutlist.LoadFrom(cutlistfile, batchmode) then
      begin
        if Settings.AutoSaveDownloadedCutlists then
        begin
          if not ForceDirectories(cutlist_path) then
          begin
            if not batchmode then
              ErrMsgFmt(RsErrorCreatePathFailedAbort, [cutlist_path]);
          end else
          begin
            if FileExists(target_file) then
            begin
              if not batchmode then
              begin
                if not YesNoMsgFmt(RsWarnTargetExistsOverwrite, [target_file]) then
                  Exit;
              end;
              if not DeleteFile(target_file) then
              begin
                if not batchmode then
                  ErrMsgFmt(RsErrorDeleteFileFailedAbort, [target_file]);
                Exit;
              end;
            end;

            //cutlistfile.SaveToFile(target_file);
            //cutlist.SavedToFilename := target_file;
            cutlist.SaveAs(target_file);
          end;
        end;

        Result := True;
      end;
    finally
      FreeAndNil(cutlistfile);
    end;
  end;
end;

function TFMain.ConvertUploadData: Boolean;
var
  RowDataNode, RowNode             : TJCLSimpleXMLElem;
  idx, cntNew                      : Integer;
  CutlistID                        : Integer;
  CutlistDate                      : TDateTime;
  CutlistIDStr, CutlistName, CutlistDateStr: string;
begin
  Result := False;
  if not FileExists(UploadData_Path(False)) then
    Exit;

  cntNew := 0;

  XMLResponse.LoadFromFile(UploadData_Path(False));
  try
    RowDataNode := XMLResponse.Root.Items.ItemNamed['ROWDATA'];
    if RowDataNode <> nil then
    begin
      for idx := 0 to Pred(RowDataNode.Items.Count) do
      begin
        RowNode := RowDataNode.Items.Item[idx];
        if RowNode <> nil then
        begin
          CutlistIDStr := RowNode.Properties.Value('id', '0');
          CutlistID := StrToIntDef(CutlistIDStr, 0);
          CutlistName := RowNode.Properties.Value('name', '');
          CutlistDateStr := RowNode.Properties.Value('DateTime', '');

          if Length(CutlistDateStr) > 9 then
            CutlistDate := DateTimeStrEval('YYYYMMDDTHH:NN:SSZZZ', CutlistDateStr)
          else
            CutlistDate := DateTimeStrEval('YYYYMMDD', CutlistDateStr);

          if (CutlistID > 0) and (UploadDataEntries.IndexOfName(CutlistIDStr) < 0) then
          begin
            AddUploadDataEntry(CutlistDate, CutlistName, CutlistID);
            Inc(cntNew);
          end;
        end;
      end;
    end;
    if cntNew > 0 then
    begin
      UploadDataEntries.SaveToFile(UploadData_Path(True));
    end;
    if FileExists(UploadData_Path(False)) then
    begin
      RenameFile(UploadData_Path(False), UploadData_Path(False) + '.BAK');
    end;
  except
    on E: EJclSimpleXMLError do
    begin
      if not batchmode then
        ErrMsgFmt(RsErrorConvertUploadData, [E.Message]);
    end;
  end;
end;

function GetXMLMessage(const Node: TJCLSimpleXMLElem; const ItemName: string; const LastChecked: TDateTime): string;
var
  Msg                              : TJCLSimpleXMLElems;
  datum                            : TDateTime;
  function ItemStr(const AName: string): string;
  var Item                         : TJCLSimpleXMLElem;
  begin
    Item := Msg.ItemNamed[AName];
    if Item = nil then Result := ''
    else Result := Item.Value;
  end;
  function ItemInt(const AName: string): Integer;
  begin
    Result := StrToIntDef(ItemStr(AName), -1);
  end;
begin
  Result := '';
  Msg := Node.Items;
  if not TryEncodeDate(
    ItemInt('date_year'), ItemInt('date_month'), ItemInt('date_day'),
    Datum
    ) then Exit;
  if LastChecked <= Datum then
  begin
    Result := '[' + DateToStr(Datum) + '] ' + ItemStr(ItemName);
  end;
end;

function GetXMLMessages(const Node: TJCLSimpleXMLElem; const LastChecked: TDateTime; const name: string): string;
var
  MsgList                          : TJCLSimpleXMLElems;
  s                                : string;
  idx                              : Integer;
begin
  Result := '';
  MsgList := Node.Items.ItemNamed[name].Items;
  if MsgList.Count > 0 then
  begin
    for idx := 0 to Pred(MsgList.Count) do
    begin
      s := GetXMLMessage(MsgList.Item[idx], 'text', LastChecked);
      if Length(s) > 0 then
      begin
        Result := Result + #13#10#13#10 + s;
      end;
    end;
  end;
end;

function TFMain.DownloadInfo(settings: TSettings; const UseDate, ShowAll: Boolean): Boolean;
var
  error_message, url, AText, ResponseText: string;
  lastChecked                      : TDateTime;
  //f: textFile;
begin
  Result := False;
  lastChecked := settings.InfoLastChecked;

  if UseDate and not (daysBetween(lastChecked, Date) >= settings.InfoCheckInterval) then
    Exit;

  if ShowAll then
    lastChecked := 0;

  Error_message := RsErrorUnknown;
  url := settings.url_info_file + '?' + Utils.GetVersionRequestParams;

  Error_message := RsErrorDownloadInfo;
  Result := DoHttpGet(url, False, Error_message, ResponseText);

  if Result then
  begin
    try
      if Length(ResponseText) > 5 then
      begin
        XMLResponse.LoadFromString(ResponseText);

        if XMLResponse.Root.ChildsCount > 0 then
        begin
          if settings.InfoShowMessages then
          begin
            AText := GetXMLMessages(XMLResponse.Root, lastChecked, 'messages');
            if Length(AText) > 0 then
              if not batchmode then
                InfMsgFmt(RsMsgInfoMessage, [AText]);
          end;
          if settings.InfoShowBeta then
          begin
            AText := GetXMLMessage(XMLResponse.Root.Items.ItemNamed['beta'], 'version_text', lastChecked);
            if Length(AText) > 0 then
              if not batchmode then
                InfMsgFmt(RsMsgInfoDevelopment, [AText]);
          end;
          if settings.InfoShowStable then
          begin
            AText := GetXMLMessage(XMLResponse.Root.Items.ItemNamed['stable'], 'version_text', lastChecked);
            if Length(AText) > 0 then
              if not batchmode then
                InfMsgFmt(RsMsgInfoStable, [AText]);
          end;
          Result := True;
        end;
      end;
      settings.InfoLastChecked := Date;
    except
      on E: EJclSimpleXMLError do
      begin
        if not batchmode then
          ErrMsgFmt(RsErrorDownloadInfoXml, [error_message, E.Message]);
      end else
        raise;
    end;
  end;
end;

procedure TFMain.actSnapshotCopyExecute(Sender: TObject);
begin
  if mnuVideo.PopupComponent is TImage then
  begin
    clipboard.Assign((mnuVideo.PopupComponent as TImage).Picture.Bitmap);
  end
  else if mnuVideo.PopupComponent = VideoWindow then
  begin
    if not Assigned(seeking) then
      Exit;
    SampleInfo.Active := True;
    SampleInfo.SampleTime := -1;
    try
      jumpto(currentPosition);
      WaitForFiltergraph;
      if SampleInfo.SampleTime >= 0 then
      begin
        if SampleInfo.HasBitmap then
          Clipboard.Assign(SampleInfo.Bitmap);
      end;
    finally
      SampleInfo.Active := False;
    end;
  end;
end;

procedure TFMain.actSnapshotSaveExecute(Sender: TObject);
const
  BMP_EXTENSION = '.bmp';
  JPG_EXTENSION = '.jpg';

  function AskForFileName(var FileName: string; var FileType: Integer): Boolean;
  var
    saveDlg                        : TSaveDialog;
    DefaultExt                     : string;
  begin
    Result := False;
    saveDlg := TSaveDialog.Create(Application.MainForm);
    try
      saveDlg.Filter := MakeFilterString(RsFilterDescriptionBitmap, '*' + BMP_EXTENSION) + '|' +
                        MakeFilterString(RsFilterDescriptionJpeg, '*' + JPG_EXTENSION) + '|' +
                        MakeFilterString(RsFilterDescriptionAll, '*.*');
      saveDlg.FilterIndex := 2;
      saveDlg.Title := RsTitleSaveSnapshot;
      //saveDlg.InitialDir := '';
      saveDlg.FileName := FileName;
      saveDlg.Options := saveDlg.Options + [ofOverwritePrompt, ofPathMustExist];
      if saveDlg.Execute then
      begin
        Result   := True;
        FileName := saveDlg.FileName;
        FileType := saveDlg.FilterIndex;

        if FileType = 1 then
        begin
          DefaultExt := BMP_EXTENSION;
        end else
        begin
          FileType := 2;
          DefaultExt := JPG_EXTENSION;
        end;
        if ExtractFileExt(FileName) <> DefaultExt then
          FileName := FileName + DefaultExt;
      end;
    finally
      saveDlg.Free;
    end;
  end;

var
  tempBitmap: TBitmap;
  position: Double;
  posString, fileName: string;
  FileType: Integer;
begin
  if filtergraph.State = gsPlaying then
    GraphPause;

  position   := -1;
  tempBitmap := nil;

  if mnuVideo.PopupComponent is TImage then
  begin
    position   := (mnuVideo.PopupComponent.Owner as TCutFrame).position;
    tempBitmap := (mnuVideo.PopupComponent as TImage).Picture.Bitmap;
  end else
    if mnuVideo.PopupComponent = VideoWindow then
    begin
      if not Assigned(seeking) then
        Exit;

      SampleInfo.Active     := True;
      SampleInfo.SampleTime := -1;
      try
        jumpto(currentPosition);
        WaitForFiltergraph;
        if SampleInfo.SampleTime >= 0 then
        begin
          position := SampleInfo.SampleTime;
          if SampleInfo.HasBitmap then
            tempBitmap := SampleInfo.Bitmap;
        end;
      finally
        SampleInfo.Active := False;
      end;
    end;

  if Assigned(tempBitmap) then
  begin
    posString := movieInfo.FormatPosition(position);
    posString := ansireplacetext(posString, ':', '''');
    fileName  := ExtractFileName(MovieInfo.current_filename);
    fileName  := ChangeFileExt(fileName, '_' + cleanFileName(posString));

    if not AskForFileName(FileName, FileType) then
      Exit;

    if FileType = 1 then
      TempBitmap.SaveToFile(FileName)
    else
      SaveBitmapAsJPEG(TempBitmap, FileName);
  end;
end;

procedure TFMain.actSplitCutExecute(Sender: TObject);
var
  I: Integer;
  F,T: Double;
begin
  I := cutlist.FindCutIndex(CurrentPosition);
  if I >= 0 then
  begin
    if YesNoMsg(RsSplitCutAsk) then
    begin
      F := cutlist[I].pos_from;
      T := cutlist[I].pos_to;

      cutlist.DeleteCut(I);

      cutlist.AddCut(F, CurrentPosition);
      cutlist.AddCut(CurrentPosition, T);
    end;
  end else
    WarnMsg(RsSplitCutWarn);
end;

function TFMain.CreateMPlayerEDL(cutlist: TCutlist; Inputfile,
  Outputfile: string; var scriptfile: string): Boolean;
const
  EDL_EXTENSION                    = '.edl';
var
  f                                : Textfile;
  i                                : Integer;
  cutlist_tmp                      : TCutlist;
begin
  if scriptfile = '' then
    scriptfile := Inputfile + EDL_EXTENSION;
  AssignFile(f, scriptfile);
  Rewrite(f);
  try
    if cutlist.Mode = clmCutOut then
    begin
      cutlist.sort;
      for i := 0 to Pred(cutlist.Count) do
        Writeln(f, FloatToStrInvariant(cutlist.Cut[i].pos_from) + ' ' + FloatToStrInvariant(cutlist.Cut[i].pos_to) + ' 0');
    end else
    begin
      cutlist_tmp := cutlist.Convert;
      for i := 0 to Pred(cutlist_tmp.Count) do
        Writeln(f, FloatToStrInvariant(cutlist_tmp.Cut[i].pos_from) + ' ' + FloatToStrInvariant(cutlist_tmp.Cut[i].pos_to) + ' 0');
      FreeAndNil(cutlist_tmp);
    end;
  finally
    CloseFile(f);
  end;
  Result := True;
end;

procedure TFMain.actPlayInMPlayerAndSkipExecute(Sender: TObject);
var
  edlfile, AppPath, command, message_string: string;
begin
  edlfile := '';
  if not MovieInfo.MovieLoaded then Exit;
  AppPath := settings.MplayerPath;
  if not FileExists(AppPath) then Exit;
  command := MovieInfo.current_filename;
  if cutlist.Count > 0 then
  begin
    if not CreateMPlayerEDL(cutlist, MovieInfo.current_filename, '', edlfile) then Exit;
    command := command + ' -edl ' + edlfile;
  end;
  if not CallApplication(AppPath, Command, message_string) then
  begin
    if not batchmode then
      ErrMsgFmt(RsErrorExternalCall, [ExtractFileName(AppPath), message_string]);
  end;
end;

procedure TFMain.ResetForm;
begin
  pos_from := 0;
  pos_to := 0;

  Caption := Application_Friendly_Name;
  Application.Title := Application_Friendly_Name;

  actOpenCutlist.Enabled := False;
  actSearchCutlistByFileSize.Enabled := False;
  actSearchCutlistLocal.Enabled := False;
  EnableMovieControls(False);
  actStepForward.Enabled := False;

  tbFinePos.Position := Settings.FinePosFrameCount;
  tbFinePos.Tag := tbFinePos.Position;
  tbFilePos.PageSize := Round(0.04 * tbFinePos.Position * 1000 / tbFilePos.TimerInterval); // Def. 25 fps

  lblDuration_nl.Caption := FormatMoviePosition(0);
  lblPos_nl.Caption := FormatMoviePosition(0);
  UpdateMovieInfoControls;
end;

procedure TFMain.EnableMovieControls(Value: Boolean);
begin
  actNextFrames.Enabled := Value;
  actCurrentFrames.Enabled := Value;
  actPrevFrames.Enabled := Value;
  tbFilePos.Enabled := Value;
  tbFinePos.Enabled := Value;
  actSmallSkipForward.Enabled := Value;
  actLargeSkipForward.Enabled := Value;
  actStepBackward.Enabled := Value;
  actSmallSkipBackward.Enabled := Value;
  actLargeSkipBackward.Enabled := Value;
  actPlayPause.Enabled := Value;
  actPlay.Enabled := Value;
  actPause.Enabled := Value;
  actStop.Enabled := Value;

  if Value and MovieInfo.CanStepForward then
    actStepForward.Enabled := True
  else
    actStepForward.Enabled := False;

  actJumpCutStart.Enabled := Value;
  actJumpCutEnd.Enabled   := Value;
  actSetCutStart.Enabled  := Value;
  actSetCutEnd.Enabled    := Value;
  cmdFromStart.Enabled    := Value;
  cmdToEnd.Enabled        := Value;
end;

function TFMain.BuildFilterGraph(FileName: string; FileType: TMovieType): Boolean;
begin
  Result := False;
end;

function TFMain.GetSampleGrabberMediaType(var MediaType: TAMMediaType): HResult;
//Fix because SampleGrabber does not set right media type:
//SampleGrabber has wrong resolution in MediaType if videowindow
//is smaller than native resolution
var
  SourcePin                        : IPin;
  InPin                            : IPin;
begin
  InPin := SampleGrabber.InPutPin;
  Result := InPin.ConnectedTo(SourcePin);
  if Result <> S_OK then
  begin
    Exit;
  end;
  Result := SourcePin.ConnectionMediaType(MediaType)
end;

function TFMain.CustomGetSampleGrabberBitmap(Bitmap: TBitmap; Buffer: Pointer; BufferLen: Integer): Boolean;
//Fix because SampleGrabber does not set right media type:
//SampleGrabber has wrong resolution in MediaType if videowindow
//is smaller than native resolution
//This function is copied from DSPack but uses MediaType from upstream filter
  function GetDIBLineSize(BitCount, Width: Integer): Integer;
  begin
    if BitCount = 15 then
      BitCount := 16;
    Result := ((BitCount * Width + 31) div 32) * 4;
  end;
var
  hr                               : HRESULT;
  BIHeaderPtr                      : PBitmapInfoHeader;
  MediaType                        : TAMMediaType;
  BitmapHandle                     : HBitmap;
  DIBPtr                           : Pointer;
  DIBSize                          : LongInt;
begin
  Result := False;
  if not Assigned(Bitmap) then
    Exit;
  if Assigned(Buffer) and (BufferLen = 0) then
    Exit;
  hr := GetSampleGrabberMediaType(MediaType); // <-- Changed
  if hr <> S_OK then
    Exit;
  try
    if IsEqualGUID(MediaType.majortype, MEDIATYPE_Video) then
    begin
      BIHeaderPtr := nil;
      if IsEqualGUID(MediaType.formattype, FORMAT_VideoInfo) then
      begin
        if MediaType.cbFormat = SizeOf(TVideoInfoHeader) then // check size
          BIHeaderPtr := @(PVideoInfoHeader(MediaType.pbFormat)^.bmiHeader);
      end
      else if IsEqualGUID(MediaType.formattype, FORMAT_VideoInfo2) then
      begin
        if MediaType.cbFormat = SizeOf(TVideoInfoHeader2) then // check size
          BIHeaderPtr := @(PVideoInfoHeader2(MediaType.pbFormat)^.bmiHeader);
      end;
      // check, whether format is supported by TSampleGrabber
      if not Assigned(BIHeaderPtr) then
        Exit;
      BitmapHandle := CreateDIBSection(0, PBitmapInfo(BIHeaderPtr)^,
        DIB_RGB_COLORS, DIBPtr, 0, 0);
      if BitmapHandle <> 0 then
      begin
        try
          if DIBPtr = nil then
            Exit;
          // get DIB size
          DIBSize := BIHeaderPtr^.biSizeImage;
          if DIBSize = 0 then
          begin
            with BIHeaderPtr^ do
              DIBSize := GetDIBLineSize(biBitCount, biWidth) * biHeight * biPlanes;
          end;
          // Copy DIB
          if not Assigned(Buffer) then
          begin
            Exit; // <-- changed
          end
          else begin
            if BufferLen > DIBSize then // Copy Min(BufferLen, DIBSize)
              BufferLen := DIBSize;
            Move(Buffer^, DIBPtr^, BufferLen);
          end;
          Bitmap.Handle := BitmapHandle;
          Result := True;
        finally
          if Bitmap.Handle <> BitmapHandle then // preserve for any changes in Graphics.pas
            DeleteObject(BitmapHandle);
        end;
      end;
    end;
  finally
    FreeMediaType(@MediaType);
  end;
end;

function TFMain.FilterGraphSelectedFilter(Moniker: IMoniker;
  FilterName: WideString; ClassID: TGUID): Boolean;
begin
  Result := not settings.FilterIsInBlackList(ClassID);
end;

procedure TFMain.FramePopUpPrevious12FramesClick(Sender: TObject);
begin
  if mnuVideo.PopupComponent = VideoWindow then
  begin
    actPrevFrames.Execute;
  end;
  if mnuVideo.PopupComponent is TImage then
  begin
    ((mnuVideo.PopupComponent as TImage).Owner as TCutFrame).ImageDoubleClick(mnuVideo.PopupComponent);
    actPrevFrames.Execute;
  end;
end;

procedure TFMain.FramePopUpNext12FramesClick(Sender: TObject);
begin
  if mnuVideo.PopupComponent = VideoWindow then
  begin
    actNextFrames.Execute;
  end;
  if mnuVideo.PopupComponent is TImage then
  begin
    ((mnuVideo.PopupComponent as TImage).Owner as TCutFrame).ImageDoubleClick(mnuVideo.PopupComponent);
    actNextFrames.Execute;
  end;
end;

procedure TFMain.actShowLoggingExecute(Sender: TObject);
begin
  if not FLogging.Visible then
  begin
    FLogging.Width := Width;
    FLogging.Top   := Top + Height + 1;
    FLogging.Left  := Left;
  end;
  FLogging.Visible := True;
end;

procedure TFMain.actTestExceptionHandlingExecute(Sender: TObject);
begin
  raise Exception.Create('Exception handling test at ' + FormatDateTime('', Now));
end;

procedure TFMain.actChangeStyleExecute(Sender: TObject);
var
  P: TPoint;
begin
  GetCursorPos(P);
  mnuStyles.Popup(P.X, P.Y);
end;

procedure TFMain.actCheckInfoOnServerExecute(Sender: TObject);
begin
  DownloadInfo(Settings, False, Utils.ShiftDown);
end;

procedure TFMain.actOpenCutassistantHomeExecute(Sender: TObject);
begin
  ShellExecute(0, nil, 'https://github.com/abc874/ca2018', '', '', SW_SHOWNORMAL);
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  if settings.NewSettingsCreated then
    actEditSettings.Execute
  else if not BatchMode then
  begin
    // Verify settings
    if settings.url_info_file <> DEFAULT_UPDATE_XML then
    begin
      if settings.Additional['UseCustomInfoXml'] <> '1' then
      begin
        if YesNoMsgFmt(RsUseCustomInfoXml, [Settings.url_info_file, DEFAULT_UPDATE_XML]) then
          settings.Additional['UseCustomInfoXml'] := '1'
        else
          settings.url_info_file := DEFAULT_UPDATE_XML;
      end;
    end;
  end;
  if settings.CheckInfos then
    DownloadInfo(settings, True, False);
end;

function TFMain.DoHttpGet(const url: string; const handleRedirects: Boolean; const Error_message: string; var Response: string): Boolean;
var
  data                             : THttpRequest;
begin
  data := THttpRequest.Create(url, handleRedirects, Error_message);
  try
    Result := DoHttpRequest(data);
    Response := data.Response;
  finally
    FreeAndNil(data);
  end;
end;

function TFMain.DoHttpRequest(data: THttpRequest): Boolean;
const
  SLEEP_TIME = 50;
  MAX_SLEEP  = 10;
var
  idx: Integer;
begin
  RequestWorker.Start;
  RequestWorker.Data := data;

  idx := MAX_SLEEP;
  while idx > 0 do
  begin
    Dec(idx);
    Sleep(SLEEP_TIME);
    if RequestWorker.Stopped then
      Break;
  end;
  if not RequestWorker.Stopped then
    dlgRequestProgress.Execute;

  Result := HandleWorkerException(data);
end;

function TFMain.HandleWorkerException(data: THttpRequest): Boolean;
var
  excClass                         : TClass;
  url, msg                         : string;
  idx                              : Integer;
begin
  if RequestWorker.ReturnValue = 0 then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  excClass := RequestWorker.TerminatingExceptionClass;
  if excClass <> nil then
  begin
    msg := RequestWorker.TerminatingException;
    if excClass.InheritsFrom(EIdReplyRFCError) then
    begin
      case RequestWorker.ReturnValue of
        404, 302: begin
            url := data.Url;
            idx := Pos('?', url);
            if idx < 1 then
              idx := Length(url)
            else
              Dec(idx);
            msg := Format(RsErrorHttpFileNotFound, [StringReplace(Copy(url, 1, idx), '&', '&&', [rfReplaceAll])]);
          end;
      end;
    end;
    if not batchmode then
      ErrMsg(data.ErrorMessage + msg);
  end;
end;

procedure TFMain.dlgRequestProgressShow(Sender: TObject);
var
  dlg                              : TJvProgressDialog;
begin
  dlg := Sender as TJvProgressDialog;
  Assert(Assigned(dlg));
  dlg.Position := 30;
end;

procedure TFMain.dlgRequestProgressCancel(Sender: TObject);
begin
  WebRequest_nl.Disconnect;
  RequestWorker.WaitFor;
end;

procedure TFMain.dlgRequestProgressProgress(Sender: TObject;
  var AContinue: Boolean);
var
  dlg                              : TJvProgressDialog;
begin
  dlg := Sender as TJvProgressDialog;
  if dlg.Position = dlg.Max then dlg.Position := dlg.Min
  else dlg.Position := dlg.Position + 2;
  if RequestWorker.ReturnValue >= 0 then
    dlg.Interval := 0;
  if RequestWorker.ReturnValue > 0 then
    AContinue := False;
end;

procedure TFMain.RequestWorkerRun(Sender: TIdThreadComponent);
var
  data: THttpRequest;
  MS: TMemoryStream;
  raw: RawByteString;
begin
  Assert(Assigned(Sender));

  // if Assigned(Sender.Thread) then NameThread(Sender.Thread.ThreadID, 'RequestWorker');  /////////**********

  data := Sender.Data as THttpRequest;
  if not Assigned(data) then {// busy wait for data object ...}
  begin
    Sleep(10);
    Exit;
  end;
  Sender.ReturnValue := -1;

  try
    WebRequest_nl.HandleRedirects := data.HandleRedirects;

    MS := TMemoryStream.Create;
    try
      if data.IsPostRequest then
        WebRequest_nl.Post(data.Url, data.PostData, MS)
      else
        WebRequest_nl.Get(data.Url, MS);

      // Binary data is UTF-8
      SetLength(raw, MS.Size);
      MS.Position := 0;
      MS.ReadData(@raw[1], MS.Size);
      data.Response := UTF8ToString(raw);
    finally
      MS.Free;
    end;
  finally
    // Only for testing purposes
    //Sleep(10000);
    if not Sender.Terminated then
      Sender.Stop;
    if Sender.ReturnValue < 0 then ;
    Sender.ReturnValue := 0;
  end;
end;

procedure TFMain.RequestWorkerException(Sender: TIdThreadComponent; AException: Exception);
var
  data: THttpRequest;
begin
  Assert(Assigned(Sender));
  if not Assigned(Sender.Data) then
  begin
    dlgRequestProgress.Text := RsProgressTransferAborted;
  end else
  begin
    data := Sender.Data as THttpRequest;
    dlgRequestProgress.Text := RsErrorTransferAborting;
    data.Response := '';
  end;

  if AException is EIdReplyRFCError then
    with AException as EIdReplyRFCError do
      Sender.ReturnValue := ErrorCode;

  if Sender.ReturnValue <= 0 then
    Sender.ReturnValue := 1;

  Sender.Stop;
end;

procedure TFMain.WebRequest_nlStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  dlgRequestProgress.Text := AStatusText;
end;

procedure TFMain.WebRequest_nlWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Int64);
begin
  case AWorkMode of
    wmRead:
      dlgRequestProgress.Text := Format(RsProgressReadData, [AWorkCount]);
    wmWrite:
      dlgRequestProgress.Text := Format(RsProgressWroteData, [AWorkCount]);
  end;
end;

procedure TFMain.actStopExecute(Sender: TObject);
begin
  GraphPause; //set Play/Pause Button Caption
  jumpto(0);
  filtergraph.Stop;
end;

procedure TFMain.actPlayPauseExecute(Sender: TObject);
begin
  GraphPlayPause;
end;

procedure TFMain.actPlayExecute(Sender: TObject);
begin
  GraphPlay;
end;

procedure TFMain.actPauseExecute(Sender: TObject);
begin
  GraphPause;
end;

procedure TFMain.FilterGraphGraphComplete(sender: TObject; Result: HRESULT; Renderer: IBaseFilter);
begin
  if cbCutPreview.Checked then
  begin
    GraphPause;
    GraphPlay;
  end else
    actPlayPause.Caption := '>';
end;

procedure TFMain.actSetCutStartExecute(Sender: TObject);
begin
  SetStartPosition(CurrentPosition);
end;

procedure TFMain.actSetCutEndExecute(Sender: TObject);
begin
  SetStopPosition(CurrentPosition);
end;

procedure TFMain.actJumpCutStartExecute(Sender: TObject);
begin
  JumpTo(pos_from);
end;

procedure TFMain.actJumpCutEndExecute(Sender: TObject);
begin
  JumpTo(pos_to);
end;

procedure TFMain.actSelectNextCutExecute(Sender: TObject);
begin
  with lvCutlist do
    if ItemIndex < Pred(Items.Count) then
      ItemIndex := ItemIndex + 1;
end;

procedure TFMain.actSelectPrevCutExecute(Sender: TObject);
begin
  with lvCutlist do
    if ItemIndex > 0 then
      ItemIndex := ItemIndex - 1;
end;

  procedure TFMain.actShiftCutExecute(Sender: TObject);
  var
    AParams: TJvParameterList;
    AShiftTime: TJvDoubleEditParameter;
    ACut: tcut;
    AShift: Double;
  begin
    AParams := TJvParameterList.Create(nil);
    try
      AShiftTime := TJvDoubleEditParameter.Create(AParams);
      AShiftTime.SearchName := 'Shift';
      AShiftTime.Caption := RsShiftCutTime;
      AShiftTime.AsDouble := StrToFloatDefInv(settings.Additional['CutShiftTime'], settings.SmallSkipTime);
      AShiftTime.Required := True;
      AParams.AddParameter(AShiftTime);
      AParams.ArrangeSettings.AutoArrange := True;

      AParams.Messages.Caption := SMsgDlgConfirm;
      AParams.Messages.OkButton := SOKButton;
      AParams.Messages.CancelButton := SCancelButton;

      if AParams.ShowParameterDialog then
      begin
        AShift := AShiftTime.AsDouble;
        settings.Additional['CutShiftTime'] := FloatToStrInvariant(AShift);
        ACut := cutlist.cut[lvCutlist.ItemIndex];
        cutlist.ReplaceCut(ACut.pos_from + AShift, ACut.pos_to + AShift, lvCutlist.ItemIndex);
      end;
    finally
      AParams.Free;
    end;
  end;

initialization
  Randomize;

  FreeLocalizer.LanguageDir := Application_Dir;
  FreeLocalizer.ErrorProcessing := epErrors;

  Settings := TSettings.Create;
  Settings.Load;

  FreeLocalizer.AutoTranslate := Settings.LanguageFile <> '';
  if FreeLocalizer.AutoTranslate then
    FreeLocalizer.LanguageFile := Settings.LanguageFile;

  //RegisterDSAMessage(1, 'CutlistRated', 'Cutlist rated');
  MovieInfo := TMovieInfo.Create;
  Cutlist   := TCutList.Create(Settings, MovieInfo);
finalization
  FreeAndNil(Cutlist);
  FreeAndNil(MovieInfo);
  Settings.Save;
  FreeAndNil(Settings);
end.
