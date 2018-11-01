UNIT UMemoDialog;

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
  StdCtrls;

TYPE
  TfrmMemoDialog = CLASS(TForm)
    cmdClose: TButton;
    memInfo: TMemo;
    PROCEDURE cmdCloseClick(Sender: TObject);
  PRIVATE
    { Private declarations }
  PUBLIC
    { Public declarations }
  END;

VAR
  frmMemoDialog                    : TfrmMemoDialog;

IMPLEMENTATION

{$R *.dfm}


PROCEDURE TfrmMemoDialog.cmdCloseClick(Sender: TObject);
BEGIN
  self.Hide;
END;

END.
