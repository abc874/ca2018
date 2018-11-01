UNIT Unit_DSTrackBarEx;

INTERFACE

USES
  SysUtils,
  Classes,
  Controls,
  ComCtrls,
  DSPack,
  Forms,
  Graphics,
  Messages,
  Windows;

TYPE
  TDSTrackBarEx = CLASS;

  TTBCustomDrawEvent = PROCEDURE(Sender: TDSTrackBarEx; CONST ARect: TRect) OF OBJECT;

  TDSTrackBarEx = CLASS(TDSTrackBar)
  PRIVATE
    { Private declarations }
    FOnPositionChangedByMouse: TNotifyEvent;
    FOnSelChanged: TNotifyEvent;
    FMouseDown: boolean;
    FUserIsMarking: boolean;
    FMarkingStart, FMarkingEnd: Integer;
    FChannelCanvas: TCanvas;
    FOnChannelPostPaint: TTBCustomDrawEvent;
    PROCEDURE SetOnChannelPostPaint(CONST Value: TTBCUstomDrawEvent);
  PROTECTED
    { Protected declarations }
    PROCEDURE MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); OVERRIDE;
    PROCEDURE MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); OVERRIDE;
    PROCEDURE MouseMove(Shift: TShiftState; X, Y: Integer); OVERRIDE;
    PROPERTY OnMouseUp;
    PROCEDURE CNNotify(VAR Message: TWMNotify); MESSAGE CN_NOTIFY;
  PUBLIC
    { Public declarations }
    CONSTRUCTOR Create(AOwner: TComponent); OVERRIDE;
    DESTRUCTOR Destroy; OVERRIDE;

    PROCEDURE TriggerTimer;
    PROPERTY IsMouseDown: boolean READ FMouseDown;
    PROPERTY UserIsMarking: boolean READ FUserIsMarking;
  PUBLISHED
    { Published declarations }
    PROPERTY OnPositionChangedByMouse: TNotifyEvent READ FOnPositionChangedByMouse WRITE FOnPositionChangedByMouse;
    PROPERTY OnSelChanged: TNotifyEvent READ FOnSelChanged WRITE FOnSelChanged;
    PROPERTY ChannelCanvas: TCanvas READ FChannelCanvas;
    PROPERTY OnChannelPostPaint: TTBCUstomDrawEvent READ FOnChannelPostPaint WRITE SetOnChannelPostPaint;
  END;

PROCEDURE Register;

IMPLEMENTATION

USES CommCtrl;

PROCEDURE Register;
BEGIN
  RegisterComponents('DSPack', [TDSTrackBarEx]);
END;

{ TDSTrackBarEx }

CONSTRUCTOR TDSTrackBarEx.Create(AOwner: TComponent);
BEGIN
  INHERITED Create(AOwner);
  FMouseDown := false;
  FUserIsMarking := false;
  FChannelCanvas := TCanvas.create;
END;

PROCEDURE TDSTrackBarEx.CNNotify(VAR Message: TWMNotify);
VAR
  Info                             : PNMCustomDraw;
  //  R: TRect;
  //  Rgn: HRGN;
  //  Details: TThemedElementDetails;
  //  Offset: Integer;
BEGIN
  WITH Message DO BEGIN
    IF NMHdr.code = NM_CUSTOMDRAW THEN BEGIN
      Info := Pointer(NMHdr);
      CASE Info.dwDrawStage OF
        CDDS_PREPAINT:
          // return CDRF_NOTIFYITEMDRAW so that we will get subsequent
          // CDDS_ITEMPREPAINT notifications
          Result := CDRF_NOTIFYITEMDRAW;
        CDDS_ITEMPREPAINT: BEGIN
            CASE Info.dwItemSpec OF
              TBCD_CHANNEL:
                Result := CDRF_DODEFAULT OR CDRF_NOTIFYPOSTPAINT;
            ELSE Result := CDRF_DODEFAULT;
            END;
          END;
        CDDS_ITEMPOSTPAINT: BEGIN
            CASE Info.dwItemSpec OF
              TBCD_CHANNEL: BEGIN
                  //info.hdc  = DC Handle
                  //info.rc   = Rect
                  inflateRect(info.rc, -4, -2);
                  FChannelCanvas.Handle := info.hdc;
                  IF Assigned(FOnChannelPostPaint) THEN FOnChannelPostPaint(self, info.rc);

                  {FChannelCanvas.Brush.Color := clred;
                  FChannelCanvas.Brush.Style := bsSolid;
                  FChannelCanvas.FillRect(info.rc);  }
                  FChannelCanvas.Handle := 0;

                  //fillrect(info.hdc, info.rc, hbrush(COLOR_ACTIVECAPTION +1));

                {
                  SendMessage(Handle, TBM_GETTHUMBRECT, 0, Integer(@R));
                  Offset := 0;
                  if Focused then
                    Inc(Offset);
                  if Orientation = trHorizontal then
                  begin
                    R.Left := ClientRect.Left + Offset;
                    R.Right := ClientRect.Right - Offset;
                  end
                  else
                  begin
                    R.Top := ClientRect.Top + Offset;
                    R.Bottom := ClientRect.Bottom - Offset;
                  end;
                  with R do
                    Rgn := CreateRectRgn(Left, Top, Right, Bottom);
                  SelectClipRgn(Info.hDC, Rgn);
                  Details := ThemeServices.GetElementDetails(ttbThumbTics);
                  ThemeServices.DrawParentBackground(Handle, Info.hDC, @Details, False);
                  DeleteObject(Rgn);
                  SelectClipRgn(Info.hDC, 0);
                 }
                  Result := CDRF_SKIPDEFAULT
                END;
            ELSE Result := CDRF_DODEFAULT;
            END;
          END;
      ELSE
        Result := CDRF_DODEFAULT;
      END;
    END ELSE
      INHERITED;
  END;
END;

PROCEDURE TDSTrackBarEx.TriggerTimer;
BEGIN
  self.Timer;
END;

PROCEDURE TDSTrackBarEx.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
BEGIN
  INHERITED MouseUp(Button, Shift, X, Y);
  IF Button = mbLeft THEN FMouseDown := False;
  IF FUserIsMarking THEN BEGIN
    FUserIsMarking := false;
    FOnSelChanged(self);
  END;
  FOnPositionChangedByMouse(self);
END;


PROCEDURE TDSTrackBarEx.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
BEGIN
  INHERITED MouseDown(Button, Shift, X, Y);
  IF Button = mbLeft THEN FMouseDown := true;
  IF ssShift IN Shift THEN BEGIN
    FMarkingStart := self.Position;
    FMarkingEnd := self.Position;
    FUserIsMarking := true;
  END;
END;

PROCEDURE TDSTrackBarEx.MouseMove(Shift: TShiftState; X, Y: Integer);
BEGIN
  INHERITED MouseMove(Shift, X, Y);
  IF (ssShift IN Shift) AND FUserIsMarking THEN BEGIN
    FMarkingEnd := Position;
    IF FMarkingStart <= FMarkingEnd THEN BEGIN
      SelStart := FMarkingStart;
      SelEnd := FMarkingEnd;
    END ELSE BEGIN
      SelStart := FMarkingEnd;
      SelEnd := FMarkingStart;
    END;
  END;
END;

DESTRUCTOR TDSTrackBarEx.Destroy;
BEGIN
  FreeAndNIL(FChannelCanvas);
  INHERITED Destroy;
END;

PROCEDURE TDSTrackBarEx.SetOnChannelPostPaint(CONST Value: TTBCUstomDrawEvent);
BEGIN
  FOnChannelPostPaint := Value;
END;


END.
