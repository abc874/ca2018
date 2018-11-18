unit UploadList;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFUploadList = class(TForm)
    pnlButtons: TPanel;
    lvLinklist: TListView;
    cmdCancel: TButton;
    cmdDelete: TButton;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FUploadLIst: TFUploadLIst;

implementation

{$R *.dfm}

{ TFUploadList }

end.

