UNIT Frames;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Forms,
  Dialogs,
  ExtCtrls,
  StdCtrls,
  Controls,
  contnrs,
  utils,
  main;

TYPE

  TCutFrame = CLASS(TComponent)
  PRIVATE
    BStart, BStop: TButton;
    LTime: TLabel;
    LIndex: TLabel;
    FImage: TImage;
    FPosition: double;
    FIndex: Integer;
    FKeyFrame: boolean;
    FBorderVisible: boolean;
    FBorder: TShape;
    FUpdateLocked: integer;
    FImageVisible: boolean;
    PROCEDURE setPosition(APosition: Double);
    PROCEDURE setKeyFrame(Value: boolean);
    PROCEDURE setBorderVisible(Value: boolean);
    PROCEDURE setImageVisible(Value: boolean);
  PUBLIC
    PROPERTY ImageVisible: boolean READ FImageVisible WRITE SetImageVisible;
    PROPERTY IsKeyFrame: boolean READ FKeyFrame WRITE SetKeyFrame;
    PROPERTY BorderVisible: boolean READ FBorderVisible WRITE SetBorderVisible;
    PROPERTY index: integer READ FIndex;
    PROPERTY position: double READ FPosition WRITE setPosition;
    CONSTRUCTOR Create(AParent: TWinControl); REINTRODUCE;
    DESTRUCTOR Destroy; OVERRIDE;
    PROCEDURE DisableUpdate;
    PROCEDURE EnableUpdate;
    PROCEDURE UpdateFrame;
    PROCEDURE ResetFrame;
    PROCEDURE AssignSampleInfo(CONST SampleInfo, KeyFrameSampleInfo: RMediaSample);
    PROCEDURE init(image_height, image_width: INteger);
    PROCEDURE Adjust_position(pos_top, pos_left: Integer);
    PROCEDURE BStartClick(Sender: TObject);
    PROCEDURE BStopClick(Sender: TObject);
    PROCEDURE ImageClick(Sender: TObject);
    PROCEDURE ImageDoubleClick(Sender: TObject);
    PROPERTY Image: TImage READ FImage;
  END;

  TFFrames = CLASS(TForm)
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormResize(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    PROCEDURE FormKeyUp(Sender: TObject; VAR Key: Word;
      Shift: TShiftState);
    PROCEDURE FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; VAR Handled: Boolean);
  PRIVATE
    { Private declarations }
    FrameList: TObjectList;
    FUNCTION getCutFrame(Index: integer): TCUtFrame;
    FUNCTION getCount: integer;
    PROCEDURE adjust_frame_position;
  PUBLIC
    { Public declarations }
    MainForm: TFMain;
    scan_1, scan_2: integer; //index of CutFrame
    CanClose: boolean;
    PROCEDURE Init(IFrames: Integer; FrameHeight, FrameWidth: Integer);
    PROCEDURE HideFrames;
    PROPERTY Frame[Index: Integer]: TCutFrame READ getCutFrame;
    PROPERTY Count: Integer READ getCount;
  END;

CONST bdistance                    = 0.03; //distance between buttons as % of image_width
CONST distance                     = 0.05; //distance between frames as % of framewidth


VAR
  FFrames                          : TFFrames;

IMPLEMENTATION

USES
  StrUtils,
  Math,
  DirectShow9;

{$R *.dfm}

{ TFFrames }

PROCEDURE TFFrames.HideFrames;
VAR
  iFrame                           : integer;
BEGIN
  FOR iFrame := 0 TO Framelist.Count - 1 DO
    WITH Frame[iFrame] DO BEGIN
      ImageVisible := false;
      IsKeyFrame := false;
      Position := 0;
    END;
END;

FUNCTION TFFrames.getCount: integer;
BEGIN
  Result := FrameList.Count;
END;

PROCEDURE TFFrames.init(IFrames: Integer; FrameHeight, FrameWidth: Integer);
VAR
  iFrame, Line, F_per_line         : integer;
  buttonheight, top_dist, hor_dist, LineHeight: integer;
  AFrame                           : TCutFrame;
BEGIN
  scan_1 := -1;
  scan_2 := -1;
  buttonheight := round(Screen.PixelsPerInch / 4);
  top_dist := round(distance * FrameHeight);
  hor_dist := round(distance * FrameWidth);
  LineHeight := 2 * top_dist + buttonHeight + FrameHeight;
  F_per_line := trunc(self.ClientWidth / ((1 + distance) * FrameWidth));
  //self.ClientHeight := (trunc(IFrames-1 / F_per_Line) + 1) * LineHeight + top_dist;

  self.Constraints.MinWidth := Framewidth + 5 * hor_dist + self.VertScrollBar.Size;

  FOR iFrame := 0 TO IFrames - 1 DO BEGIN
    Line := trunc(iFrame / F_per_line);
    AFrame := TCutFrame.Create(self);
    AFrame.Findex := Framelist.Add(AFrame);
    AFrame.Init(FrameHeight, FrameWidth);
    AFrame.Adjust_position(Line * LineHeight + top_dist,
      (iFrame MOD F_per_Line) * (Framewidth + hor_dist) + hor_dist);
  END;

END;

PROCEDURE TFFrames.adjust_frame_position;
VAR
  iFrame, Line, F_per_line         : integer;
  framewidth, frameheight, buttonheight, top_dist, hor_dist, LineHeight: integer;
  AFrame                           : TCutFrame;
BEGIN
  IF framelist.Count = 0 THEN
    Exit;
  buttonheight := round(Screen.PixelsPerInch / 4);
  framewidth := (framelist[0] AS TCutFrame).Image.Width;
  frameheight := (framelist[0] AS TCutFrame).Image.Height;
  top_dist := round(distance * FrameHeight);
  hor_dist := round(distance * FrameWidth);
  LineHeight := 2 * top_dist + buttonHeight + FrameHeight;
  F_per_line := trunc(self.ClientWidth / ((1 + distance) * FrameWidth));

  self.VertScrollBar.Position := 0;
  FOR iFrame := 0 TO Framelist.Count - 1 DO BEGIN
    Line := trunc(iFrame / F_per_line);
    AFrame := (framelist[iFrame] AS TCutFrame);
    AFrame.Adjust_position(Line * LineHeight + top_dist,
      (iFrame MOD F_per_Line) * (Framewidth + hor_dist) + hor_dist);
  END;
END;

FUNCTION TFFrames.getCutFrame(Index: integer): TCUtFrame;
BEGIN
  result := (self.FrameList[Index] AS TCutFrame)
END;

{ TCutFrame }

CONSTRUCTOR TCutFrame.Create(AParent: TWinControl);
BEGIN
  INHERITED create(AParent);
  BStart := TButton.Create(self);
  BStop := TButton.Create(self);
  LTime := TLabel.Create(self);
  LIndex := TLabel.Create(self);
  FBorder := TShape.Create(self);
  FImage := TIMage.Create(self);
  BStart.Parent := AParent;
  BStop.Parent := AParent;
  LTime.Parent := AParent;
  LIndex.Parent := AParent;
  FBorder.Parent := AParent;
  Image.Parent := Aparent;
  Image.PopupMenu := FMain.mnuVideo;
  IsKeyFrame := false;
END;

DESTRUCTOR TCutFrame.Destroy;
BEGIN
  //FreeAndNIL(Bstart);
  //FreeAndNIL(Bstop);
  //FreeAndNIL(LTime);
  //FreeAndNIL(LIndex);
  //FreeAndNIL(FImage);
  //FreeAndNIL(FBorder);
  INHERITED;
END;

PROCEDURE TCutFrame.Adjust_position(pos_top, pos_left: integer);
CONST
  Index_width                      = 2.0 / 3.0; //in width_units
  Time_width                       = 3;
  Button_width                     = 2;
  border_distance                  = 2;
  Border_Width                     = 2;
VAR
  top2                             : integer;
  width_unit, button_distance, image_height, image_width: integer;
BEGIN

  image_height := image.Height;
  image_width := image.Width;
  button_distance := round(image_Width * bdistance);

  Image.Top := pos_top;
  image.Left := pos_left;

  FBorder.Top := pos_top - border_distance - border_width;
  FBorder.left := pos_left - border_distance - border_width;

  top2 := pos_top + image_height + button_distance;
  width_unit := round((image_width - 3 * button_distance) / (Index_width + Time_width + Button_width + Button_width));
  LIndex.Top := top2;
  LIndex.Left := pos_Left;

  BStart.Top := top2;
  BStart.Left := pos_left + round((Index_width + TIme_width) * width_unit) + 2 * button_distance;

  BStop.Top := top2;
  BStop.Left := pos_left + round((Index_width + TIme_width + Button_width) * width_unit) + 3 * button_distance;

  LTime.Top := top2;
  LTime.Left := BStart.Left - LTime.Width - button_distance;
END;

PROCEDURE TFFrames.FormCreate(Sender: TObject);
VAR
  MainBounds                       : TRect;
BEGIN
  FrameList := TObjectlist.Create;
  Init(Settings.FramesCount, Settings.FramesHeight, Settings.FramesWidth);

  IF ValidRect(Settings.FramesFormBounds) THEN
    self.BoundsRect := Settings.FramesFormBounds
  ELSE BEGIN
    MainBounds := Settings.MainFormBounds;
    IF ValidRect(MainBounds) THEN BEGIN
      // Use top of main form if possible
      IF MainBounds.Top + self.Height <= Screen.DesktopHeight THEN
        self.Top := MainBounds.Top
      ELSE // Center around main form if possible
        self.Top := Math.Max(0, MainBounds.Top + (MainBounds.Bottom - MainBounds.Top - self.Height) DIV 2);
      // force at least visible width of 100 pixels
      self.Left := Math.Min(MainBounds.Left + MainBounds.Right - MainBounds.Left, Screen.DesktopWidth - 100);
    END
    ELSE BEGIN
      self.Top := Screen.WorkAreaTop + Max(0, (Screen.WorkAreaHeight - self.Height) DIV 2);
      self.Left := Screen.WorkAreaLeft + Max(0, Screen.WorkAreaWidth - self.Width);
    END;
  END;
  self.WindowState := Settings.FramesFormWindowState;
  adjust_frame_position;
END;

PROCEDURE TFFrames.FormDestroy(Sender: TObject);
BEGIN
  Settings.FramesFormBounds := self.BoundsRect;
  Settings.FramesFormWindowState := self.WindowState;
END;

PROCEDURE TCutFrame.init(image_height, image_width: INteger);
CONST
  Index_width                      = 1; //in width_units
  Time_width                       = 3;
  Button_width                     = 2;
  Border_Distance                  = 2;
  Border_Style                     = psSolid;
  Border_Width                     = 2;
  Border_Color                     = clYellow;
VAR
  width_unit, button_height, button_distance: integer;
BEGIN
  button_height := round(Screen.PixelsPerInch / 4);
  button_distance := round(image_Width * bdistance);
  position := 0;
  Image.Height := image_height;
  Image.Width := Image_width;
  Image.Proportional := true;
  Image.Stretch := true;
  image.Picture.Bitmap.Canvas.Brush.Color := clBlack;
  image.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
  image.Picture.Bitmap.Canvas.FillRect(image.ClientRect);
  image.OnClick := ImageClick;
  image.OnDblClick := ImageDoubleClick;
  {  FFrames.Canvas.Brush.Color := clBlack;
    FFrames.Canvas.Brush.Style := bsSolid;
    FFrames.Canvas.FillRect(Rect(0,0,100,100)); }

  width_unit := round((image_width - 3 * button_distance) / (Index_width + Time_width + Button_width + Button_width));
  Lindex.Caption := inttostr(self.index);
  LIndex.Height := Button_height;

  //LTime.ParentFont := false;
  //LTime.Font.Assign(FFrames.Font);
  //LTime.Font.Size := Round(image_width / 40);
  LTIme.Caption := secondsToTimeString(0);
  LTime.Height := Button_height;
  LTime.Alignment := taRightJustify;

  BStart.Caption := '[<-';
  BStart.Height := button_height;
  BStart.Width := button_width * width_Unit;
  BStart.OnClick := BStartClick;

  BStop.Caption := '->]';
  BStop.Height := button_height;
  BStop.Width := button_width * width_Unit;
  BStop.OnClick := BStopClick;

  FBorder.Visible := false;
  FBorder.Height := Image.Height + 2 * Border_Distance + 2 * Border_width;
  FBorder.Width := Image.Width + 2 * Border_Distance + 2 * Border_width;
  FBorder.Brush.Style := bsClear;
  FBorder.Pen.Style := Border_Style;
  FBorder.Pen.Width := Border_width;
  FBorder.Pen.Color := Border_Color;
  self.BorderVisible := false;
END;

PROCEDURE TFFrames.FormResize(Sender: TObject);
BEGIN

  self.adjust_frame_position;
END;

PROCEDURE TCutFrame.BStartClick(Sender: TObject);
VAR
  _pos                             : double;
BEGIN
  _pos := ((sender AS TButton).Owner AS TCutFrame).position;
  (self.Owner AS TFFrames).MainForm.SetStartPosition(_pos);
END;

PROCEDURE TCutFrame.BStopClick(Sender: TObject);
VAR
  _pos                             : double;
BEGIN
  _pos := ((sender AS TButton).Owner AS TCutFrame).position;
  (self.Owner AS TFFrames).MainForm.SetStopPosition(_pos);
END;

PROCEDURE TCutFrame.DisableUpdate;
BEGIN
  Inc(FUpdateLocked);
END;

PROCEDURE TCutFrame.EnableUpdate;
BEGIN
  Dec(FUpdateLocked);
  IF FUpdateLocked > 0 THEN
    exit;
  FUpdateLocked := 0;
  UpdateFrame;
END;

PROCEDURE TCutFrame.UpdateFrame;
VAR
  _pos                             : double;
BEGIN
  IF MovieInfo.frame_duration = 0 THEN
    _pos := index
  ELSE
    _pos := FPosition / MovieInfo.frame_duration;
  LIndex.Caption := MovieInfo.FormatPosition(_pos, TIME_FORMAT_FRAME);
  LTime.Caption := MovieInfo.FormatPosition(FPosition);
  IF IsKeyFrame THEN BEGIN
    //self.LTime.Font.Style := self.LTime.Font.Style + [ fsBold ];
    self.LTime.Color := clYellow;
    //    self.LTime.Transparent := false;
  END ELSE
    //self.LTime.ParentFont := true;
    self.LTime.ParentColor := true;
  //    self.LTime.Transparent := true;
  Image.Visible := ImageVisible;
END;

PROCEDURE TCutFrame.ResetFrame;
BEGIN
  position := 0;
  IsKeyFrame := false;
  ImageVisible := false;
  IF FUpdateLocked > 0 THEN
    exit;
  UpdateFrame;
END;

PROCEDURE TCutFrame.AssignSampleInfo(CONST SampleInfo, KeyFrameSampleInfo: RMediaSample);
BEGIN
  IF SampleInfo.SampleTime >= 0 THEN BEGIN
    position := SampleInfo.SampleTime;
    ImageVisible := SampleInfo.HasBitmap;
    IF ImageVisible THEN
      Image.Picture.Bitmap.Assign(SampleInfo.Bitmap);
  END;
  IF KeyFrameSampleInfo.SampleTime >= 0 THEN
    IF Abs(KeyFrameSampleInfo.SampleTime - SampleInfo.SampleTime) < MovieInfo.frame_duration THEN
      IsKeyFrame := KeyFrameSampleInfo.IsKeyFrame;
END;

PROCEDURE TCutFrame.setPosition(APosition: Double);
BEGIN
  FPosition := APosition;
  IF FUpdateLocked > 0 THEN
    exit;
  UpdateFrame;
END;

PROCEDURE TCutFrame.setKeyFrame(Value: boolean);
BEGIN
  FKeyFrame := Value;
  IF FUpdateLocked > 0 THEN
    exit;
  UpdateFrame;
END;

PROCEDURE TCutFrame.ImageDoubleClick(Sender: TObject);
VAR
  _pos                             : double;
BEGIN
  _pos := ((sender AS TImage).Owner AS TCutFrame).position;
  (self.Owner AS TFFrames).MainForm.JumpTo(_pos);
END;

PROCEDURE TCutFrame.setBorderVisible(Value: boolean);
BEGIN
  self.FBorderVisible := Value;
END;

PROCEDURE TCutFrame.setImageVisible(Value: boolean);
BEGIN
  self.FImageVisible := Value;
  IF FUpdateLocked > 0 THEN
    exit;
  UpdateFrame;
END;

PROCEDURE TCutFrame.ImageClick(Sender: TObject);
BEGIN
  IF self.BorderVisible THEN BEGIN
    WITH (self.Owner AS TFFrames) DO BEGIN
      IF scan_1 = self.index THEN BEGIN
        scan_1 := scan_2;
        scan_2 := -1;
      END;
      IF scan_2 = self.index THEN scan_2 := -1;
    END;
    self.BorderVisible := false;
  END ELSE BEGIN
    WITH (self.Owner AS TFFrames) DO BEGIN
      IF scan_1 = -1 THEN BEGIN
        scan_1 := self.index;
      END ELSE BEGIN
        IF scan_2 = -1 THEN BEGIN
          scan_2 := self.index;
        END ELSE BEGIN
          Frame[scan_1].BorderVisible := false;
          scan_1 := scan_2;
          scan_2 := self.index;
        END;
        IF frame[scan_1].position < frame[scan_2].position THEN BEGIN
          (self.Owner AS TFFrames).MainForm.TBFilePos.SelStart := round(frame[scan_1].position);
          (self.Owner AS TFFrames).MainForm.TBFilePos.SelEnd := round(frame[scan_2].position);
        END ELSE BEGIN
          (self.Owner AS TFFrames).MainForm.TBFilePos.SelStart := round(frame[scan_2].position);
          (self.Owner AS TFFrames).MainForm.TBFilePos.SelEnd := round(frame[scan_1].position);
        END;
        (self.Owner AS TFFrames).MainForm.actScanInterval.Enabled := true;
      END;
    END;
    self.BorderVisible := true;
  END;
END;

PROCEDURE TFFrames.FormShow(Sender: TObject);
BEGIN
  // Show taskbar button for this form ...
  SetWindowLong(Handle, GWL_ExStyle, WS_Ex_AppWindow);
  CanClose := true;
END;

PROCEDURE TFFrames.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
BEGIN
  CanClose := self.CanClose;
END;

PROCEDURE TFFrames.FormKeyUp(Sender: TObject; VAR Key: Word;
  Shift: TShiftState);
BEGIN
  CASE Key OF
    VK_PRIOR: BEGIN
        self.MainForm.JumpTo(self.Frame[0].position);
        self.MainForm.actCurrentFrames.Execute;
      END;
    VK_NEXT: BEGIN
        self.MainForm.JumpTo(self.Frame[self.Count - 1].position);
        self.MainForm.actCurrentFrames.Execute;
      END;
    VK_ESCAPE: BEGIN
        Hide;
      END;
    VK_RETURN: BEGIN
        self.MainForm.BringToFront;
      END;
  END;
END;

PROCEDURE TFFrames.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; VAR Handled: Boolean);
BEGIN
  CASE Sign(WheelDelta) OF
    1: BEGIN
        self.MainForm.JumpTo(self.Frame[0].position);
        self.MainForm.actCurrentFrames.Execute;
        Handled := true;
      END;
    -1: BEGIN
        self.MainForm.JumpTo(self.Frame[self.Count - 1].position);
        self.MainForm.actCurrentFrames.Execute;
        Handled := true;
      END;
  END;
END;

END.

