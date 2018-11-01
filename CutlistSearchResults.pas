UNIT CutlistSearchResults;

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
  ComCtrls,
  ExtCtrls;

TYPE
  TFCutlistSearchResults = CLASS(TForm)
    pnlButtons: TPanel;
    lvLinklist: TListView;
    cmdCancel: TButton;
    cmdOk: TButton;
    PROCEDURE lvLinklistClick(Sender: TObject);
    PROCEDURE cmdOkClick(Sender: TObject);
  PRIVATE
    { Private declarations }
  PUBLIC
    { Public declarations }
    LinkList: ARRAY OF ARRAY[0..1] OF STRING;
    PROCEDURE GenerateLinks;
  END;

VAR
  FCutlistSearchResults            : TFCutlistSearchResults;

IMPLEMENTATION

{$R *.dfm}

{ TFCutlistSearchResults }

PROCEDURE TFCutlistSearchResults.GenerateLinks;
VAR
  iLink                            : Integer;
  ALink                            : TListItem;
BEGIN
  self.lvLinklist.Clear;
  FOR iLInk := 0 TO length(self.LinkList) - 1 DO BEGIN
    ALink := self.lvLinklist.Items.Add;
    ALink.Caption := inttostr(iLink);
    ALink.SubItems.Add(self.LinkList[iLInk, 0]);
  END;
END;


PROCEDURE TFCutlistSearchResults.lvLinklistClick(Sender: TObject);
BEGIN
  IF self.lvLinklist.ItemIndex < 0 THEN exit;
  self.ModalResult := mrOK;
END;

PROCEDURE TFCutlistSearchResults.cmdOkClick(Sender: TObject);
BEGIN
  IF lvLinklist.ItemIndex >= 0 THEN
    ModalResult := mrOk;
END;

END.
