unit ResultingTimes;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.ActiveX, Winapi.DirectShow9, System.Classes, Vcl.Forms, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.ExtCtrls,

  // DSPack
  DSPack, DXSUtils,

  // CA
  UCutlist, Movie;

type
  TFResultingTimes = class(TForm)
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
    procedure cmdCloseClick(Sender: TObject);
    procedure lvTimeListDblClick(Sender: TObject);
    procedure pnlVideoWindowResize(Sender: TObject);
    procedure tbVolumeChange(Sender: TObject);
    procedure cmdPlayClick(Sender: TObject);
    procedure cmdPauseClick(Sender: TObject);
    procedure JumpTo(NewPosition: Double);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure udDurationChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FormDestroy(Sender: TObject);
    function FilterGraphSelectedFilter(Moniker: IMoniker; FilterName: WideString; ClassID: TGUID): Boolean;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    To_Array: array of Double;
    seeking: IMediaSeeking;
    FOffset: Integer;
    current_filename: string;
    FMovieInfo: TMovieInfo;
  public
    { public declarations }
    procedure calculate(Cutlist: TCutlist);
    function loadMovie(FileName: string): Boolean;
  end;

var
  FResultingTimes: TFResultingTimes;

implementation

uses
  // Delphi
  Winapi.Windows, System.SysUtils, System.Math,

  // CA
  Main, Utils;

{$R *.dfm}

{ TFResultingTimes }

procedure TFResultingTimes.calculate(Cutlist: TCutlist);
var
  icut: Integer;
  cut: tcut;
  cut_view: tlistitem;
  i_column: Integer;
  converted_cutlist: TCutlist;
  time: Double;
begin
  if cutlist.Count > 0 then
  begin
    if cutlist.Mode = clmTrim then
    begin
      lvTimeList.Clear;
      time := 0;
      SetLength(To_Array, cutlist.Count);
      for icut := 0 to Pred(cutlist.Count) do
      begin
        cut := cutlist[icut];
        cut_view := lvTimeList.Items.Add;
        cut_view.Caption := IntToStr(icut);
        cut_view.SubItems.Add(MovieInfo.FormatPosition(time));
        time := time + cut.pos_to - cut.pos_from;
        cut_view.SubItems.Add(MovieInfo.FormatPosition(time));
        To_Array[iCut] := time;
        cut_view.SubItems.Add(MovieInfo.FormatPosition(cut.pos_to - cut.pos_from));
        time := time + MovieInfo.frame_Duration;
      end;

      // Auto-Resize columns
      for i_column := 0 to Pred(lvTimeList.Columns.Count) do
        lvTimeList.Columns[i_column].Width := -2;
    end else
    begin
      Converted_Cutlist := cutlist.convert;
      calculate(COnverted_cutlist);
      FreeAndNil(Converted_Cutlist);
    end;
  end else
    lvTimeList.Clear;
end;

procedure TFResultingTimes.cmdCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFResultingTimes.lvTimeListDblClick(Sender: TObject);
var
  target_Time: Double;
begin
  if filtergraph.Active and (lvTimeList.ItemIndex >= 0) then
  begin
    target_Time := To_array[lvTimeList.ItemIndex] - FOffset;

    if target_time <= MovieInfo.current_file_duration then
    begin
      if target_time < 0 then
        target_time := 0;

      JumpTo(Target_time);
      FilterGraph.Play;
    end;
  end;
end;

procedure TFResultingTimes.JumpTo(NewPosition: Double);
var
  _pos: Int64;
  event: Integer;
begin
  if Assigned(seeking) then
  begin
    NewPosition := EnsureRange(NewPosition, 0, MovieInfo.current_file_duration);

    if isEqualGUID(MovieInfo.TimeFormat, TIME_FORMAT_MEDIA_TIME) then
      _pos := Round(NewPosition * 10000000)
    else
      _pos := Round(NewPosition);

    seeking.SetPositions(_pos, AM_SEEKING_AbsolutePositioning, _pos, AM_SEEKING_NoPositioning);
    //filtergraph.State
    MediaEvent.WaitForCompletion(500, event);
  end;
end;

procedure TFResultingTimes.pnlVideoWindowResize(Sender: TObject);
var
  movie_ar, my_ar: Double;
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

function TFResultingTimes.loadMovie(FileName: string): Boolean;
var
  AvailableFilters: TSysDevEnum;
  SourceFilter, AviDecompressorFilter: IBAseFilter;
  SourceAdded: Boolean;
  PinList: TPinList;
  IPin: Integer;
begin
  Result := False;

  FMovieInfo.target_filename := '';
  if FMovieInfo.InitMovie(FileName) then
  begin
    filtergraph.Active := True;

    AvailableFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); // DirectShow Filters
    try
      // if MP4 then try to Add AviDecompressor
      if (MovieInfo.MovieType in [mtMP4]) then
      begin
        AviDecompressorFilter := AvailableFilters.GetBaseFilter(CLSID_AVIDec); // Avi Decompressor
        if Assigned(AviDecompressorFilter) then
          CheckDSError((FilterGraph as IGraphBuilder).AddFilter(AviDecompressorFilter, 'Avi Decompressor'));
      end;

      SourceAdded := False;
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

    if not sourceAdded then
    begin
      CheckDSError(FilterGraph.RenderFile(FileName));
    end else
    begin
      PinList := TPinList.Create(SourceFilter);
      try
        for iPin := 0 to Pred(PinList.Count) do
          CheckDSError((FilterGraph as IGraphBuilder).Render(PinList.Items[iPin]));
      finally
        FreeAndNil(PinList);
      end;
    end;

    if FilterGraph.Active then begin
      if not Succeeded(FilterGraph.QueryInterface(IMediaSeeking, Seeking)) then begin
        seeking := nil;
        filtergraph.Active := False;
        Result := False;
        Exit;
      end;
      filtergraph.Pause;
      filtergraph.Volume  := tbVolume.Position;
      current_filename    := FileName;
      tbPosition.Position := 0;
      pnlVideoWindowResize(Self);
      Result := True;
    end;
  end;
end;

procedure TFResultingTimes.tbVolumeChange(Sender: TObject);
begin
  FilterGraph.Volume := tbVolume.Position;
end;

procedure TFResultingTimes.cmdPlayClick(Sender: TObject);
begin
  if FilterGraph.Active then
    FilterGraph.Play;
end;

procedure TFResultingTimes.cmdPauseClick(Sender: TObject);
begin
  if FilterGraph.Active then
    FilterGraph.Pause
end;

procedure TFResultingTimes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FilterGraph.Stop;
  FilterGraph.ClearGraph;
  FilterGraph.Active := False;
end;

procedure TFResultingTimes.FormCreate(Sender: TObject);
begin
  AdjustFormConstraints(Self);
  if ValidRect(Settings.PreviewFormBounds) then
  begin
    BoundsRect := Settings.PreviewFormBounds
  end else
  begin
    Left := Max(0, FMain.Left + (FMain.Width - Width) div 2);
    Top  := Max(0, FMain.Top + (FMain.Height - Height) div 2);
  end;
  WindowState := Settings.PreviewFormWindowState;

  udDuration.Position := settings.OffsetSecondsCutChecking;
  FOffset := settings.OffsetSecondsCutChecking;
  FMovieInfo := TMovieInfo.Create;
end;

procedure TFResultingTimes.udDurationChanging(Sender: TObject; var AllowChange: Boolean);
begin
  FOffset := udDuration.Position;
end;

procedure TFResultingTimes.FormDestroy(Sender: TObject);
begin
  Settings.OffsetSecondsCutChecking := FOffset;
  Settings.PreviewFormBounds        := BoundsRect;
  Settings.PreviewFormWindowState   := WindowState;
  FreeAndNil(FMovieInfo);
end;

function TFResultingTimes.FilterGraphSelectedFilter(Moniker: IMoniker; FilterName: WideString; ClassID: TGUID): Boolean;
begin
  Result := not settings.FilterIsInBlackList(ClassID);
end;

procedure TFResultingTimes.FormShow(Sender: TObject);
begin
  // Show taskbar button for this form ...
  SetWindowLong(Handle, GWL_ExStyle, WS_Ex_AppWindow);
end;

end.

