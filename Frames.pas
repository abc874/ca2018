unit Frames;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.Windows, System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,

  // CA
  Main, Utils;

type
  TCutFrame = class(TComponent)
  private
    BStart, BStop: TButton;
    LTime: TLabel;
    LIndex: TLabel;
    FImage: TImage;
    FPosition: Double;
    FIndex: Integer;
    FKeyFrame: Boolean;
    FBorderVisible: Boolean;
    FBorder: TShape;
    FUpdateLocked: Integer;
    FImageVisible: Boolean;
    procedure setPosition(APosition: Double);
    procedure setKeyFrame(Value: Boolean);
    procedure setBorderVisible(Value: Boolean);
    procedure setImageVisible(Value: Boolean);
  public
    property ImageVisible: Boolean read FImageVisible write SetImageVisible;
    property IsKeyFrame: Boolean read FKeyFrame write SetKeyFrame;
    property BorderVisible: Boolean read FBorderVisible write SetBorderVisible;
    property index: Integer read FIndex;
    property position: Double read FPosition write setPosition;
    constructor Create(AParent: TWinControl); REINTRODUCE;
    procedure DisableUpdate;
    procedure EnableUpdate;
    procedure UpdateFrame;
    procedure ResetFrame;
    procedure AssignSampleInfo(const SampleInfo, KeyFrameSampleInfo: RMediaSample);
    procedure init(image_height, image_width: Integer);
    procedure Adjust_position(pos_top, pos_left: Integer);
    procedure BStartClick(Sender: TObject);
    procedure BStopClick(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure ImageDoubleClick(Sender: TObject);
    property Image: TImage read FImage;
  end;

  TFFrames = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { private declarations }
    FrameList: TList;
    function getCutFrame(Index: Integer): TCUtFrame;
    function getCount: Integer;
    procedure adjust_frame_position;
  public
    { public declarations }
    MainForm: TFMain;
    scan_1, scan_2: Integer; //index of CutFrame
    FramesCanClose: Boolean;
    procedure Init(IFrames: Integer; FrameHeight, FrameWidth: Integer);
    procedure HideFrames;
    property Frame[Index: Integer]: TCutFrame read getCutFrame;
    property Count: Integer read getCount;
  end;

var
  FFrames: TFFrames;

implementation

uses
  // Delphi
  Winapi.DirectShow9, System.SysUtils, System.Math, Vcl.Graphics;

{$R *.dfm}

const
  bdistance = 0.03; //distance between buttons as % of image_width
  distance  = 0.05; //distance between frames as % of framewidth

{ TFFrames }

procedure TFFrames.HideFrames;
var
  iFrame: Integer;
begin
  for iFrame := 0 to Pred(Framelist.Count) do
    with Frame[iFrame] do
    begin
      ImageVisible := False;
      IsKeyFrame   := False;
      Position     := 0;
    end;
end;

function TFFrames.getCount: Integer;
begin
  Result := FrameList.Count;
end;

procedure TFFrames.init(IFrames: Integer; FrameHeight, FrameWidth: Integer);
var
  iFrame, Line, F_per_line, buttonheight, top_dist, hor_dist, LineHeight: Integer;
  AFrame: TCutFrame;
begin
  scan_1       := -1;
  scan_2       := -1;
  buttonheight := Round(Screen.PixelsPerInch / 4);
  top_dist     := Round(distance * FrameHeight);
  hor_dist     := Round(distance * FrameWidth);
  LineHeight   := 2 * top_dist + buttonHeight + FrameHeight;
  F_per_line   := Trunc(ClientWidth / ((1 + distance) * FrameWidth));

  Constraints.MinWidth := Framewidth + 5 * hor_dist + VertScrollBar.Size;

  for iFrame := 0 to Pred(IFrames) do
  begin
    Line := Trunc(iFrame / F_per_line);
    AFrame := TCutFrame.Create(Self);
    AFrame.Findex := Framelist.Add(AFrame);
    AFrame.Init(FrameHeight, FrameWidth);
    AFrame.Adjust_position(Line * LineHeight + top_dist, (iFrame mod F_per_Line) * (Framewidth + hor_dist) + hor_dist);
  end;
end;

procedure TFFrames.adjust_frame_position;
var
  iFrame, Line, F_per_line, framewidth, frameheight, buttonheight, top_dist, hor_dist, LineHeight: Integer;
  AFrame: TCutFrame;
begin
  if framelist.Count > 0 then
  begin
    buttonheight := Round(Screen.PixelsPerInch / 4);
    framewidth   := Frame[0].Image.Width;
    frameheight  := Frame[0].Image.Height;
    top_dist     := Round(distance * FrameHeight);
    hor_dist     := Round(distance * FrameWidth);
    LineHeight   := 2 * top_dist + buttonHeight + FrameHeight;
    F_per_line   := Trunc(ClientWidth / ((1 + distance) * FrameWidth));

    VertScrollBar.Position := 0;
    for iFrame := 0 to Pred(Framelist.Count) do
    begin
      Line   := Trunc(iFrame / F_per_line);
      AFrame := Frame[iFrame];
      AFrame.Adjust_position(Line * LineHeight + top_dist, (iFrame mod F_per_Line) * (Framewidth + hor_dist) + hor_dist);
    end;
  end;
end;

function TFFrames.getCutFrame(Index: Integer): TCUtFrame;
begin
  Result := TCutFrame(FrameList[Index]);
end;

{ TCutFrame }

constructor TCutFrame.Create(AParent: TWinControl);
begin
  inherited Create(AParent);
  BStart          := TButton.Create(Self);
  BStop           := TButton.Create(Self);
  LTime           := TLabel.Create(Self);
  LIndex          := TLabel.Create(Self);
  FBorder         := TShape.Create(Self);
  FImage          := TIMage.Create(Self);
  BStart.Parent   := AParent;
  BStop.Parent    := AParent;
  LTime.Parent    := AParent;
  LIndex.Parent   := AParent;
  FBorder.Parent  := AParent;
  Image.Parent    := Aparent;
  Image.PopupMenu := FMain.mnuVideo;
  IsKeyFrame      := False;
end;

procedure TCutFrame.Adjust_position(pos_top, pos_left: Integer);
const
  Index_width     = 2.0 / 3.0; //in width_units
  Time_width      = 3;
  Button_width    = 2;
  border_distance = 2;
  Border_Width    = 2;
var
  top2, width_unit, button_distance, image_height, image_width: Integer;
begin
  image_height    := image.Height;
  image_width     := image.Width;
  button_distance := Round(image_Width * bdistance);

  Image.Top  := pos_top;
  image.Left := pos_left;

  FBorder.Top  := pos_top - border_distance - border_width;
  FBorder.left := pos_left - border_distance - border_width;

  top2        := pos_top + image_height + button_distance;
  width_unit  := Round((image_width - 3 * button_distance) / (Index_width + Time_width + Button_width + Button_width));
  LIndex.Top  := top2;
  LIndex.Left := pos_Left;

  BStart.Top  := top2;
  BStart.Left := pos_left + Round((Index_width + TIme_width) * width_unit) + 2 * button_distance;

  BStop.Top  := top2;
  BStop.Left := pos_left + Round((Index_width + TIme_width + Button_width) * width_unit) + 3 * button_distance;

  LTime.Top  := top2;
  LTime.Left := BStart.Left - LTime.Width - button_distance;
end;

procedure TFFrames.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FramesCanClose;
end;

procedure TFFrames.FormCreate(Sender: TObject);
var
  MainBounds: TRect;
begin
  FrameList := TList.Create;
  Init(Settings.FramesCount, Settings.FramesHeight, Settings.FramesWidth);

  if ValidRect(Settings.FramesFormBounds) then
  begin
    BoundsRect := Settings.FramesFormBounds
  end else
  begin
    MainBounds := Settings.MainFormBounds;
    if ValidRect(MainBounds) then
    begin
      if MainBounds.Top + Height <= Screen.DesktopHeight then   // Use top of main form if possible
        Top := MainBounds.Top
      else                                                      // Center around main form if possible
        Top := Max(0, MainBounds.Top + (MainBounds.Bottom - MainBounds.Top - Height) div 2);

      // force at least visible width of 100 pixels
      Left := Min(MainBounds.Left + MainBounds.Right - MainBounds.Left, Screen.DesktopWidth - 100);
    end else
    begin
      Top := Screen.WorkAreaTop + Max(0, (Screen.WorkAreaHeight - Height) div 2);
      Left := Screen.WorkAreaLeft + Max(0, Screen.WorkAreaWidth - Width);
    end;
  end;
  WindowState := Settings.FramesFormWindowState;
  adjust_frame_position;
end;

procedure TFFrames.FormDestroy(Sender: TObject);
begin
  Settings.FramesFormBounds      := BoundsRect;
  Settings.FramesFormWindowState := WindowState;

  FrameList.Free;
end;

procedure TCutFrame.init(image_height, image_width: Integer);
const
  Index_width     = 1; //in width_units
  Time_width      = 3;
  Button_width    = 2;
  Border_Distance = 2;
  Border_Style    = psSolid;
  Border_Width    = 2;
  Border_Color    = clYellow;
var
  width_unit, button_height, button_distance: Integer;
begin
  button_height := Round(Screen.PixelsPerInch / 4);
  button_distance := Round(image_Width * bdistance);
  position := 0;
  Image.Height := image_height;
  Image.Width := Image_width;
  Image.Proportional := True;
  Image.Stretch := True;
  image.Picture.Bitmap.Canvas.Brush.Color := clBlack;
  image.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
  image.Picture.Bitmap.Canvas.FillRect(image.ClientRect);
  image.OnClick := ImageClick;
  image.OnDblClick := ImageDoubleClick;
  {  FFrames.Canvas.Brush.Color := clBlack;
    FFrames.Canvas.Brush.Style := bsSolid;
    FFrames.Canvas.FillRect(Rect(0,0,100,100)); }

  width_unit := Round((image_width - 3 * button_distance) / (Index_width + Time_width + Button_width + Button_width));
  Lindex.Caption := IntToStr(index);
  LIndex.Height  := Button_height;

  //LTime.ParentFont := False;
  //LTime.Font.Assign(FFrames.Font);
  //LTime.Font.Size := Round(image_width / 40);

  LTIme.Caption   := secondsToTimeString(0);
  LTime.Height    := Button_height;
  LTime.Alignment := taRightJustify;

  BStart.Caption := '[<-';
  BStart.Height  := button_height;
  BStart.Width   := button_width * width_Unit;
  BStart.OnClick := BStartClick;

  BStop.Caption := '->]';
  BStop.Height  := button_height;
  BStop.Width   := button_width * width_Unit;
  BStop.OnClick := BStopClick;

  FBorder.Visible      := False;
  FBorder.Height       := Image.Height + 2 * Border_Distance + 2 * Border_width;
  FBorder.Width        := Image.Width + 2 * Border_Distance + 2 * Border_width;
  FBorder.Brush.Style  := bsClear;
  FBorder.Pen.Style    := Border_Style;
  FBorder.Pen.Width    := Border_width;
  FBorder.Pen.Color    := Border_Color;

  BorderVisible := False;
end;

procedure TFFrames.FormResize(Sender: TObject);
begin
  adjust_frame_position;
end;

procedure TCutFrame.BStartClick(Sender: TObject);
var
  _pos: Double;
begin
  _pos := TCutFrame(TButton(Sender).Owner).position;
  TFFrames(Owner).MainForm.SetStartPosition(_pos);
end;

procedure TCutFrame.BStopClick(Sender: TObject);
var
  _pos: Double;
begin
  _pos := TCutFrame(TButton(Sender).Owner).position;
  TFFrames(Owner).MainForm.SetStopPosition(_pos);
end;

procedure TCutFrame.DisableUpdate;
begin
  Inc(FUpdateLocked);
end;

procedure TCutFrame.EnableUpdate;
begin
  Dec(FUpdateLocked);

  if FUpdateLocked <= 0 then
  begin
    FUpdateLocked := 0;
    UpdateFrame;
  end;
end;

procedure TCutFrame.UpdateFrame;
var
  _pos: Double;
begin
  if MovieInfo.frame_duration = 0 then
    _pos := index
  else
    _pos := FPosition / MovieInfo.frame_duration;

  LIndex.Caption := MovieInfo.FormatPosition(_pos, TIME_FORMAT_FRAME);
  LTime.Caption  := MovieInfo.FormatPosition(FPosition);

  if IsKeyFrame then
    LTime.Color := clYellow
  else
    LTime.ParentColor := True;

  Image.Visible := ImageVisible;
end;

procedure TCutFrame.ResetFrame;
begin
  position     := 0;
  IsKeyFrame   := False;
  ImageVisible := False;
  if FUpdateLocked <= 0 then
    UpdateFrame;
end;

procedure TCutFrame.AssignSampleInfo(const SampleInfo, KeyFrameSampleInfo: RMediaSample);
begin
  if SampleInfo.SampleTime >= 0 then
  begin
    position     := SampleInfo.SampleTime;
    ImageVisible := SampleInfo.HasBitmap;
    if ImageVisible then
      Image.Picture.Bitmap.Assign(SampleInfo.Bitmap);
  end;
  if KeyFrameSampleInfo.SampleTime >= 0 then
    if Abs(KeyFrameSampleInfo.SampleTime - SampleInfo.SampleTime) < MovieInfo.frame_duration then
      IsKeyFrame := KeyFrameSampleInfo.IsKeyFrame;
end;

procedure TCutFrame.setPosition(APosition: Double);
begin
  FPosition := APosition;
  if FUpdateLocked <= 0 then
    UpdateFrame;
end;

procedure TCutFrame.setKeyFrame(Value: Boolean);
begin
  FKeyFrame := Value;
  if FUpdateLocked <= 0 then
    UpdateFrame;
end;

procedure TCutFrame.ImageDoubleClick(Sender: TObject);
var
  _pos: Double;
begin
  _pos := TCutFrame(TImage(Sender).Owner).position;
  TFFrames(Owner).MainForm.JumpTo(_pos);
end;

procedure TCutFrame.setBorderVisible(Value: Boolean);
begin
  FBorderVisible := Value;
end;

procedure TCutFrame.setImageVisible(Value: Boolean);
begin
  FImageVisible := Value;
  if FUpdateLocked <= 0 then
    UpdateFrame;
end;

procedure TCutFrame.ImageClick(Sender: TObject);
begin
  if BorderVisible then
  begin
    with TFFrames(Owner) do
    begin
      if scan_1 = index then
      begin
        scan_1 := scan_2;
        scan_2 := -1;
      end;
      if scan_2 = index then
        scan_2 := -1;
    end;
    BorderVisible := False;
  end else
  begin
    with TFFrames(Owner) do
    begin
      if scan_1 = -1 then
      begin
        scan_1 := index;
      end else
      begin
        if scan_2 = -1 then
        begin
          scan_2 := index;
        end else
        begin
          Frame[scan_1].BorderVisible := False;
          scan_1 := scan_2;
          scan_2 := index;
        end;
        if frame[scan_1].position < frame[scan_2].position then
        begin
          TFFrames(Owner).MainForm.TBFilePos.SelStart := Round(frame[scan_1].position);
          TFFrames(Owner).MainForm.TBFilePos.SelEnd   := Round(frame[scan_2].position);
        end else
        begin
          TFFrames(Owner).MainForm.TBFilePos.SelStart := Round(frame[scan_2].position);
          TFFrames(Owner).MainForm.TBFilePos.SelEnd   := Round(frame[scan_1].position);
        end;
        TFFrames(Owner).MainForm.actScanInterval.Enabled := True;
      end;
    end;
    BorderVisible := True;
  end;
end;

procedure TFFrames.FormShow(Sender: TObject);
begin
  // Show taskbar button for this form ...
  SetWindowLong(Handle, GWL_ExStyle, WS_Ex_AppWindow);
  FramesCanClose := True;
end;

procedure TFFrames.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_PRIOR  : begin
                  MainForm.JumpTo(Frame[0].position);
                  MainForm.actCurrentFrames.Execute;
                end;
    VK_NEXT   : begin
                  MainForm.JumpTo(Frame[Pred(Count)].position);
                  MainForm.actCurrentFrames.Execute;
                end;
    VK_ESCAPE : Hide;
    VK_RETURN : MainForm.BringToFront;
  end;
end;

procedure TFFrames.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  case Sign(WheelDelta) of
    1  : begin
           MainForm.JumpTo(Frame[0].position);
           MainForm.actCurrentFrames.Execute;
           Handled := True;
         end;
    -1 : begin
           MainForm.JumpTo(Frame[Pred(Count)].position);
           MainForm.actCurrentFrames.Execute;
           Handled := True;
         end;
  end;
end;

end.

