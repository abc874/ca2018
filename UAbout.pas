UNIT UAbout;

INTERFACE

USES Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
  JvGIF,
  JvPoweredBy,
  JvExControls,
  JvLinkLabel;

TYPE
  TAboutBox = CLASS(TForm)
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
    PROCEDURE FormCreate(Sender: TObject);
  PRIVATE
    { Private-Deklarationen }
  PUBLIC
    { Public-Deklarationen }
  END;

VAR
  AboutBox                         : TAboutBox;

IMPLEMENTATION

USES Utils;

{$R *.dfm}

PROCEDURE TAboutBox.FormCreate(Sender: TObject);
BEGIN
  lblVersion_nl.Caption := 'Version ' + Get_File_Version(Application.ExeName);
END;

END.
