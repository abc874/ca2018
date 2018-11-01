UNIT UploadList;

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
  TFUploadList = CLASS(TForm)
    pnlButtons: TPanel;
    lvLinklist: TListView;
    cmdCancel: TButton;
    cmdDelete: TButton;
  PRIVATE
    { Private declarations }
  PUBLIC
    { Public declarations }
  END;

VAR
  FUploadLIst                      : TFUploadLIst;

IMPLEMENTATION

{$R *.dfm}

{ TFCutlistSearchResults }

END.
