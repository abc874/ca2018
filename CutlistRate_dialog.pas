UNIT CutlistRate_dialog;

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
  StdCtrls,
  ExtCtrls;

TYPE
  TFCutlistRate = CLASS(TForm)
    lblSendRating: TLabel;
    RGRatingByAuthor: TRadioGroup;
    cmdCancel: TButton;
    cmdOk: TButton;
    PROCEDURE RGRatingByAuthorClick(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
  PRIVATE
    { Private declarations }
    FRatingSelectedByUser: boolean;
    FUNCTION GetSelectedRating: integer;
    PROCEDURE SetSelectedRating(rating: integer);
    FUNCTION GetSelectedRatingText: STRING;
  PUBLIC
    { Public declarations }
    PROPERTY SelectedRating: integer READ GetSelectedRating WRITE SetSelectedRating;
    PROPERTY SelectedRatingText: STRING READ GetSelectedRatingText;
  END;

VAR
  FCutlistRate                     : TFCutlistRate;

IMPLEMENTATION

USES CAResources;

{$R *.dfm}

PROCEDURE TFCutlistRate.RGRatingByAuthorClick(Sender: TObject);
BEGIN
  IF RGRatingByAuthor.ItemIndex >= 0 THEN BEGIN
    cmdOk.Enabled := true;
    FRatingSelectedByUser := (Sender = RGRatingByAuthor);
  END;
END;

FUNCTION TFCutlistRate.GetSelectedRatingText: STRING;
BEGIN
  IF SelectedRating < 0 THEN
    Result := ''
  ELSE
    Result := RGRatingByAuthor.Items.Strings[SelectedRating];
END;

FUNCTION TFCutlistRate.GetSelectedRating: integer;
BEGIN
  Result := RGRatingByAuthor.ItemIndex;
END;

PROCEDURE TFCutlistRate.SetSelectedRating(rating: integer);
BEGIN
  IF rating >= RGRatingByAuthor.Items.Count THEN
    rating := -1;
  RGRatingByAuthor.ItemIndex := rating;
  FRatingSelectedByUser := false;
END;

PROCEDURE TFCutlistRate.FormCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
VAR
  title, msg                       : STRING;
BEGIN
  IF ModalResult <> mrOk THEN
    Exit;
  IF SelectedRating < 0 THEN CanClose := false
  ELSE IF NOT FRatingSelectedByUser THEN BEGIN
    title := CAResources.RsTitleConfirmRating;
    msg := StringReplace(Format(CAResources.RsMsgConfirmRating, [SelectedRatingText]), '&', '', [rfReplaceAll]);

    FRatingSelectedByUser := IDOK = Application.MessageBox(PChar(msg), PChar(title), MB_ICONQUESTION OR MB_OKCANCEL OR MB_DEFBUTTON2);
    CanClose := FRatingSelectedByUser;
  END;
  IF NOT CanClose THEN
    RGRatingByAuthor.SetFocus;
END;

END.
