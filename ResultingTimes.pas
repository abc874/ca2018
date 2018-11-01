UNIT ResultingTimes;

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
  ExtCtrls,
  StdCtrls,
  ComCtrls,
  ActiveX,
  main,
  CutlistINfo_dialog,
  UCutlist,
  DSPack,
  DirectShow9,
  DSUtil,
  Movie;

TYPE
  TFResultingTimes = CLASS(TForm)
    lvTimeList: TListView;
    cmdClose: TButton;
    pnlMovieControl: TPanel;
    lblDuration: TLabel;
    pnlVideoWindow: TPanel;
    VideoWindow: TVideoWindow;
    FilterGraph: TFilterGraph;
    tbVolume: TTrackBar;
    Label8: TLabel;
    cmdPause: TButton;
    cmdPlay: TButton;
    tbPosition: TDSTrackBar;
    lblPosition: TLabel;
    edtDuration: TEdit;
    lblSeconds: TLabel;
    udDuration: TUpDown;
    PROCEDURE cmdCloseClick(Sender: TObject);
    PROCEDURE lvTimeListDblClick(Sender: TObject);
    PROCEDURE pnlVideoWindowResize(Sender: TObject);
    PROCEDURE tbVolumeChange(Sender: TObject);
    PROCEDURE cmdPlayClick(Sender: TObject);
    PROCEDURE cmdPauseClick(Sender: TObject);
    PROCEDURE JumpTo(NewPosition: double);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE udDurationChanging(Sender: TObject; VAR AllowChange: Boolean);
    PROCEDURE FormDestroy(Sender: TObject);
    FUNCTION FilterGraphSelectedFilter(Moniker: IMoniker;
      FilterName: WideString; ClassID: TGUID): Boolean;
    PROCEDURE FormShow(Sender: TObject);
  PRIVATE
    { Private declarations }
    To_Array: ARRAY OF double;
    seeking: IMediaSeeking;
    FOffset: INteger;
    current_filename: STRING;
    FMovieInfo: TMovieInfo;
  PUBLIC
    { Public declarations }
    PROCEDURE calculate(Cutlist: TCutlist);
    FUNCTION loadMovie(filename: STRING): boolean;
  END;

VAR
  FResultingTimes                  : TFResultingTimes;

IMPLEMENTATION

USES Utils,
  Math,
  Settings_dialog;

{$R *.dfm}

{ TFResultingTimes }

PROCEDURE TFResultingTimes.calculate(Cutlist: TCutlist);
VAR
  icut                             : integer;
  cut                              : tcut;
  cut_view                         : tlistitem;
  i_column                         : integer;
  converted_cutlist                : TCutlist;
  time                             : double;
BEGIN
  IF cutlist.Count = 0 THEN BEGIN
    self.lvTimeList.Clear;
    exit;
  END;
  IF cutlist.Mode = clmTrim THEN BEGIN
    self.lvTimeList.Clear;
    time := 0;
    setlength(To_Array, cutlist.Count);
    FOR icut := 0 TO cutlist.Count - 1 DO BEGIN
      cut := cutlist[icut];
      cut_view := self.lvTimeList.Items.Add;
      cut_view.Caption := inttostr(icut); //inttostr(cut.index);
      cut_view.SubItems.Add(MovieInfo.FormatPosition(time));
      time := time + cut.pos_to - cut.pos_from;
      cut_view.SubItems.Add(MovieInfo.FormatPosition(time));
      To_Array[iCut] := time;
      cut_view.SubItems.Add(MovieInfo.FormatPosition(cut.pos_to - cut.pos_from));
      time := time + MovieInfo.frame_Duration;
    END;

    //Auto-Resize columns
    FOR i_column := 0 TO self.lvTimeList.Columns.Count - 1 DO BEGIN
      lvTimeList.Columns[i_column].Width := -2;
    END;
  END ELSE BEGIN
    Converted_Cutlist := cutlist.convert;
    self.calculate(COnverted_cutlist);
    FreeAndNIL(Converted_Cutlist);
  END;
END;

PROCEDURE TFResultingTimes.cmdCloseClick(Sender: TObject);
BEGIN
  self.Close;
END;

PROCEDURE TFResultingTimes.lvTimeListDblClick(Sender: TObject);
VAR
  target_Time                      : double;
BEGIN
  IF filtergraph.Active THEN BEGIN
    IF self.lvTimeList.ItemIndex < 0 THEN exit;
    target_Time := self.To_array[self.lvTimeList.ItemIndex] - FOffset;
    IF target_time > MovieInfo.current_file_duration THEN exit;
    IF target_time < 0 THEN target_time := 0;
    JumpTo(Target_time);
    FilterGraph.Play;
  END;
END;

PROCEDURE TFResultingTimes.JumpTo(NewPosition: double);
VAR
  _pos                             : int64;
  event                            : Integer;
BEGIN
  IF assigned(seeking) THEN BEGIN
    IF NewPosition < 0 THEN
      NewPosition := 0;
    IF NewPosition > MovieInfo.current_file_duration THEN
      NewPosition := MovieInfo.current_file_duration;

    IF isEqualGUID(MovieInfo.TimeFormat, TIME_FORMAT_MEDIA_TIME) THEN
      _pos := round(NewPosition * 10000000)
    ELSE
      _pos := round(NewPosition);
    seeking.SetPositions(_pos, AM_SEEKING_AbsolutePositioning,
      _pos, AM_SEEKING_NoPositioning);
    //filtergraph.State
    MediaEvent.WaitForCompletion(500, event);
  END;
END;


PROCEDURE TFResultingTimes.pnlVideoWindowResize(Sender: TObject);
VAR
  movie_ar                         : double;
  my_ar                            : double;
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

FUNCTION TFResultingTimes.loadMovie(filename: STRING): boolean;
VAR
  AvailableFilters                 : TSysDevEnum;
  SourceFilter, AviDecompressorFilter: IBAseFilter;
  SourceAdded                      : boolean;
  PinList                          : TPinList;
  IPin                             : Integer;
BEGIN
  result := false;

  FMovieInfo.target_filename := '';
  IF NOT FMovieInfo.InitMovie(filename) THEN
    Exit;

  filtergraph.Active := true;

  AvailableFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); //DirectShow Filters
  TRY
    //If MP4 then Try to Add AviDecompressor
    IF (MovieInfo.MovieType IN [mtMP4]) THEN BEGIN
      AviDecompressorFilter := AvailableFilters.GetBaseFilter(CLSID_AVIDec); //Avi Decompressor
      IF assigned(AviDecompressorFilter) THEN BEGIN
        CheckDSError((FilterGraph AS IGraphBuilder).AddFilter(AviDecompressorFilter, 'Avi Decompressor'));
      END;
    END;

    SourceAdded := false;
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

  IF FilterGraph.Active THEN BEGIN
    IF NOT succeeded(FilterGraph.QueryInterface(IMediaSeeking, Seeking)) THEN BEGIN
      seeking := NIL;
      filtergraph.Active := false;
      result := false;
      exit;
    END;
    filtergraph.Pause;
    filtergraph.Volume := self.tbVolume.Position;
    current_filename := filename;
    self.tbPosition.Position := 0;
    self.pnlVideoWindowResize(self);
    result := true;
  END;
END;

PROCEDURE TFResultingTimes.tbVolumeChange(Sender: TObject);
BEGIN
  FilterGraph.Volume := self.tbVolume.Position;
END;

PROCEDURE TFResultingTimes.cmdPlayClick(Sender: TObject);
BEGIN
  IF FilterGraph.Active THEN
    FilterGraph.Play;
END;

PROCEDURE TFResultingTimes.cmdPauseClick(Sender: TObject);
BEGIN
  IF FilterGraph.Active THEN
    FilterGraph.Pause
END;

PROCEDURE TFResultingTimes.FormClose(Sender: TObject;
  VAR Action: TCloseAction);
BEGIN
  FilterGraph.Stop;
  FilterGraph.ClearGraph;
  FilterGraph.Active := false;
END;

PROCEDURE TFResultingTimes.FormCreate(Sender: TObject);
BEGIN
  AdjustFormConstraints(Self);
  IF ValidRect(Settings.PreviewFormBounds) THEN
    self.BoundsRect := Settings.PreviewFormBounds
  ELSE BEGIN
    self.Left := Max(0, FMain.Left + (FMain.Width - self.Width) DIV 2);
    self.Top := Max(0, FMain.Top + (FMain.Height - self.Height) DIV 2);
  END;
  self.WindowState := Settings.PreviewFormWindowState;

  self.udDuration.Position := settings.OffsetSecondsCutChecking;
  FOffset := settings.OffsetSecondsCutChecking;
  FMovieInfo := TMovieInfo.Create;
END;


PROCEDURE TFResultingTimes.udDurationChanging(Sender: TObject;
  VAR AllowChange: Boolean);
BEGIN
  FOffset := self.udDuration.Position;
END;

PROCEDURE TFResultingTimes.FormDestroy(Sender: TObject);
BEGIN
  Settings.OffsetSecondsCutChecking := FOffset;
  Settings.PreviewFormBounds := self.BoundsRect;
  Settings.PreviewFormWindowState := self.WindowState;
  FreeAndNIL(FMovieInfo);
END;

FUNCTION TFResultingTimes.FilterGraphSelectedFilter(Moniker: IMoniker;
  FilterName: WideString; ClassID: TGUID): Boolean;
BEGIN
  result := NOT settings.FilterIsInBlackList(ClassID);
END;

PROCEDURE TFResultingTimes.FormShow(Sender: TObject);
BEGIN
  // Show taskbar button for this form ...
  SetWindowLong(Handle, GWL_ExStyle, WS_Ex_AppWindow);
END;

END.

