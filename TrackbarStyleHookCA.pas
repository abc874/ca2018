unit TrackbarStyleHookCA;

interface

uses
  // Delphi
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl,
  System.Types, System.SysUtils, Vcl.Controls, Vcl.Themes, Vcl.ComCtrls, Vcl.Graphics,

  // DSPack
  Unit_DSTrackBarEx;

type
  // Draw multiple selections on styled TrackBar
  TTrackBarStyleHookCA = class(TTrackBarStyleHook)
  protected
    procedure Paint(Canvas: TCanvas); override;
  public
    constructor Create(AControl: TWinControl); override;
  end;

implementation

{...$UNDEF USE_HOOK_WITH_SOURCE_CODE}

// Define USE_HOOK_WITH_SOURCE_CODE, if Vcl.ComCtrls.pas is available.

{$DEFINE USE_HOOK_WITH_SOURCE_CODE}

{ TTrackBarStyleHookCA }

constructor TTrackBarStyleHookCA.Create(AControl: TWinControl);
begin
  inherited;

  if not (AControl is TDSTrackBarEx) then
    raise EProgrammerNotFound.Create('Hook needs TDSTrackBarEx!');
end;

{$IFNDEF USE_HOOK_WITH_SOURCE_CODE}

// Simple solution
procedure TTrackBarStyleHookCA.Paint(Canvas: TCanvas);
var
  R: TRect;
begin
  with TDSTrackBarEx(Control) do
    if Assigned(OnChannelPostPaint) then
    begin
      SendMessage(Handle, TBM_GETCHANNELRECT, 0, IntPtr(@R));

      InflateRect(R, -4, -2);

      ChannelCanvas.Handle := Canvas.Handle;

      OnChannelPostPaint(TDSTrackBarEx(Control), R);
    end;

  inherited;
end;

{$ELSE}

// Better solution

type
  // Access private variables FThumbPressed and FMouseOnThumb
  TTrackBarStyleHookHelper = class helper for TTrackBarStyleHook
  public
    function MouseOnThumb: Boolean;
    function ThumbPressed: Boolean;
  end;

{ TTrackBarStyleHookHelper }

function TTrackBarStyleHookHelper.MouseOnThumb: Boolean;
begin
  with Self do
    Result := FMouseOnThumb;
end;

function TTrackBarStyleHookHelper.ThumbPressed: Boolean;
begin
  with Self do
    Result := FThumbPressed;
end;

const
  huhu = 'huhu';

procedure TTrackBarStyleHookCA.Paint(Canvas: TCanvas);

// Insert here (from Vcl.ComCtrls.pas)
// line 33088 (after "procedure TTrackBarStyleHook.Paint(Canvas: TCanvas);")
// to line 33224 (before "// Thumb")

{$I abc874\TrackbarStyleHookCA1.inc}

  with TDSTrackBarEx(Control) do
    if Assigned(OnChannelPostPaint) then
    begin
      InflateRect(R, -4, -2);

      ChannelCanvas.Handle := Canvas.Handle;

      OnChannelPostPaint(TDSTrackBarEx(Control), R);
    end;

// Insert here (from Vcl.ComCtrls.pas) line 33225 (after "// Thumb") to line 33323 (before "end;")

{$I abc874\TrackbarStyleHookCA2.inc}

end;

{$ENDIF}

end.

