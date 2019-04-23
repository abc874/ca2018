unit ReplaceFrame;

{$I Information.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TReplaceFrame = class(TFrame)
    edSearch: TEdit;
    edReplace: TEdit;
    cbRegEx: TCheckBox;
    cbActive: TCheckBox;
    sbTest: TSpeedButton;
    sbAdd: TSpeedButton;
    sbDel: TSpeedButton;
    lbSearch: TLabel;
    lbReplace: TLabel;
    procedure FrameResize(Sender: TObject);
    procedure sbTestClick(Sender: TObject);
    procedure sbAddClick(Sender: TObject);
    procedure sbDelClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    class var FrameCount: Integer;
  end;

implementation

uses
  // Delphi
  System.StrUtils, System.RegularExpressions,

  // CA
  CAResources, Utils;

{$R *.dfm}

{ TReplaceFrame }

procedure TReplaceFrame.FrameResize(Sender: TObject);
var
  D,I: Integer;
begin
  D := lbSearch.Left;
  I := (cbRegEx.Left - lbSearch.Width - lbReplace.Width - 5 * D) div 2;

  edSearch.Left   := 2 * D + lbSearch.Width;
  edSearch.Width  := I;
  lbReplace.Left  := edSearch.Left + edSearch.Width + D;
  edReplace.Left  := lbReplace.Left + lbReplace.Width + D;
  edReplace.Width := I;
end;

procedure TReplaceFrame.sbAddClick(Sender: TObject);
begin
  with TReplaceFrame.Create(Owner) do
  begin
    Inc(FrameCount);
    Name   := 'ReplaceFrame' + IntToStr(FrameCount);
    Top    := 10000;
    Parent := Self.Parent;
  end;
end;

procedure TReplaceFrame.sbDelClick(Sender: TObject);
begin
  if Parent.ControlCount > 1 then
    Free;
end;

procedure TReplaceFrame.sbTestClick(Sender: TObject);
var
  S: string;
  R: TRegEx;
begin
  S := '';
  if InputQuery(RsInput, RsFileName, S) then
  begin
    if cbRegEx.Checked then
    begin
      R.Create(edSearch.Text);
      InfMsg(R.Replace(S, edReplace.Text));
    end else
      InfMsg(StringReplace(S, edSearch.Text, edReplace.Text, [rfReplaceAll]));
  end;
end;

end.

