unit UMemoDialog;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, Vcl.Forms, Vcl.StdCtrls, Vcl.Controls;

type
  TfrmMemoDialog = class(TForm)
    cmdClose: TButton;
    memInfo: TMemo;
    procedure cmdCloseClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMemoDialog: TfrmMemoDialog;

implementation

{$R *.dfm}

procedure TfrmMemoDialog.cmdCloseClick(Sender: TObject);
begin
  Hide;
end;

end.

