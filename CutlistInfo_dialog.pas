UNIT CutlistInfo_dialog;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  StrUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,

  UCutlist,
  Utils,
  JvExStdCtrls,
  JvCheckBox;

CONST
  movie_file_extensions            : ARRAY[0..7] OF STRING
                                   = ('.avi', '.mpg', '.mpeg', '.wmv', '.asf', '.mp2', '.mp4', '.mg4');

TYPE
  TFCutlistInfo = CLASS(TForm)
    lblInfoCaption: TLabel;
    rgRatingByAuthor: TRadioGroup;
    grpDetails: TGroupBox;
    edtOtherErrorDescription: TEdit;
    edtActualContent: TEdit;
    cmdCancel: TButton;
    cmdOk: TButton;
    edtUserComment: TEdit;
    lblComment: TLabel;
    lblAuthor: TLabel;
    pnlAuthor: TPanel;
    lblSuggestedFilename: TLabel;
    edtMovieName: TEdit;
    cmdMovieNameCopy: TButton;
    lblFrameRate: TLabel;
    cbEPGError: TJvCheckBox;
    cbMissingBeginning: TJvCheckBox;
    cbMissingEnding: TJvCheckBox;
    cbMissingVideo: TJvCheckBox;
    cbMissingAudio: TJvCheckBox;
    cbOtherError: TJvCheckBox;
    cbFramesPresent: TJvCheckBox;
    grpServerRating: TGroupBox;
    lblRatingOnServer: TLabel;
    lblRatingCountOnServer: TLabel;
    lblDownloadTime: TLabel;
    edtRatingOnServer: TEdit;
    edtRatingCountOnServer: TEdit;
    edtDownloadTime: TEdit;
    lblRatingSent: TLabel;
    edtRatingSent: TEdit;
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE cbEPGErrorClick(Sender: TObject);
    PROCEDURE cbOtherErrorClick(Sender: TObject);
    PROCEDURE EnableOK(Sender: TObject);
    PROCEDURE cmdMovieNameCopyClick(Sender: TObject);
  PRIVATE
    { Private declarations }
  PUBLIC
    { Public declarations }
    original_movie_filename: STRING;
  END;


VAR
  FCutlistInfo                     : TFCutlistInfo;

IMPLEMENTATION



{$R *.dfm}

PROCEDURE TFCutlistInfo.FormShow(Sender: TObject);
BEGIN
  cbFramesPresent.Left := rgRatingByAuthor.BoundsRect.Right - cbFramesPresent.Width;
  CBEPGErrorClick(sender);
  CBOtherErrorClick(sender);
  self.cmdOk.Enabled := false;
END;

PROCEDURE TFCutlistInfo.cbEPGErrorClick(Sender: TObject);
BEGIN
  self.edtActualContent.Enabled := self.CBEPGError.Checked;
  self.EnableOK(sender);
END;

PROCEDURE TFCutlistInfo.cbOtherErrorClick(Sender: TObject);
BEGIN
  self.edtOtherErrorDescription.Enabled := self.CBOtherError.Checked;
  self.EnableOK(sender);
END;

PROCEDURE TFCutlistInfo.EnableOK(Sender: TObject);
BEGIN
  IF self.RGRatingByAuthor.ItemIndex < 0 THEN exit;
  self.cmdOk.Enabled := true;
END;

PROCEDURE TFCutlistInfo.cmdMovieNameCopyClick(Sender: TObject);
VAR
  s, e                             : STRING;
BEGIN
  s := extractfilename(original_movie_filename);
  e := extractFileExt(s);
  WHILE AnsiMatchText(e, movie_file_extensions) DO BEGIN
    s := changefileExt(s, '');
    e := extractFileExt(s);
  END;
  s := AnsiReplaceText(s, '_', ' ');
  self.edtMovieName.Text := s;
END;

END.
