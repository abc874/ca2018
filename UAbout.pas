unit UAbout;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, System.SysUtils, Vcl.Forms, Vcl.StdCtrls, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls,

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
    procedure iProgram_nlDblClick(Sender: TObject);
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

procedure TAboutBox.iProgram_nlDblClick(Sender: TObject);
var
  I: Integer;
begin
  if NoYesMsg('raise exception?') then
  begin
    I := Random(256);
    I := I div (I - I);
    InfMsg(IntToStr(I));
  end;
end;

end.

