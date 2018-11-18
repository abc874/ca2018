unit CutlistRate_dialog;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFCutlistRate = class(TForm)
    lblSendRating: TLabel;
    RGRatingByAuthor: TRadioGroup;
    cmdCancel: TButton;
    cmdOk: TButton;
    procedure RGRatingByAuthorClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { private declarations }
    FRatingSelectedByUser: Boolean;
    function GetSelectedRating: Integer;
    procedure SetSelectedRating(rating: Integer);
    function GetSelectedRatingText: string;
  public
    { public declarations }
    property SelectedRating: Integer read GetSelectedRating write SetSelectedRating;
    property SelectedRatingText: string read GetSelectedRatingText;
  end;

var
  FCutlistRate: TFCutlistRate;

implementation

uses
  // CA
  CAResources, Utils, Main;

{$R *.dfm}

procedure TFCutlistRate.RGRatingByAuthorClick(Sender: TObject);
begin
  if RGRatingByAuthor.ItemIndex >= 0 then
  begin
    cmdOk.Enabled := True;
    FRatingSelectedByUser := (Sender = RGRatingByAuthor);
  end;
end;

function TFCutlistRate.GetSelectedRatingText: string;
begin
  if SelectedRating < 0 then
    Result := ''
  else
    Result := RGRatingByAuthor.Items.Strings[SelectedRating];
end;

function TFCutlistRate.GetSelectedRating: Integer;
begin
  Result := RGRatingByAuthor.ItemIndex;
end;

procedure TFCutlistRate.SetSelectedRating(rating: Integer);
begin
  if rating >= RGRatingByAuthor.Items.Count then
    rating := -1;
  RGRatingByAuthor.ItemIndex := rating;
  FRatingSelectedByUser := False;
end;

procedure TFCutlistRate.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  msg: string;
begin
  if ModalResult = mrOk then
  begin
    if SelectedRating < 0 then
      CanClose := False
    else
      if not FRatingSelectedByUser then
      begin
        msg := StringReplace(Format(RsMsgConfirmRating, [SelectedRatingText]), '&', '', [rfReplaceAll]);

        FRatingSelectedByUser := settings.NoWarnUseRate or NoYesMsg(RsTitleConfirmRating + #13#13 + msg);

        CanClose := FRatingSelectedByUser;
      end;

    if not CanClose then
      RGRatingByAuthor.SetFocus;
  end;
end;

end.

