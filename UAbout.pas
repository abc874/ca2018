unit UAbout;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, Vcl.Forms, Vcl.StdCtrls, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls,

  // Jedi
  JvGIF, JvPoweredBy, JvExControls;

type
  TAboutBox = class(TForm)
    pnlAbout: TPanel;
    iProgram_nl: TImage;
    lblProductName_nl: TLabel;
    lblVersion_nl: TLabel;
    lblAuthors: TLabel;
    cmdOk: TButton;
    JvPoweredByJCL_nl: TJvPoweredByJCL;
    JvPoweredByJVCL_nl: TJvPoweredByJVCL;
    iIndy_nl: TImage;
    lblDSPack_nl: TLabel;
    lblCopyright_nl: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private-Deklarationen }
  public
    { public-Deklarationen }
  end;

var
  AboutBox: TAboutBox;

implementation

uses
  // CA
  Utils;

{$R *.dfm}

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  lblVersion_nl.Caption := 'Version ' + Get_File_Version(Application.ExeName);
end;

end.

