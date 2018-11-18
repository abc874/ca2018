unit CutlistInfo_dialog;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, Vcl.ExtCtrls, Vcl.Forms, Vcl.StdCtrls, Vcl.Controls,

  // Jedi
  JvExStdCtrls, JvCheckBox;

const
  movie_file_extensions: array[0..7] of string = ('.avi', '.mpg', '.mpeg', '.wmv', '.asf', '.mp2', '.mp4', '.mg4');

type
  TFCutlistInfo = class(TForm)
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
    procedure FormShow(Sender: TObject);
    procedure cbEPGErrorClick(Sender: TObject);
    procedure cbOtherErrorClick(Sender: TObject);
    procedure EnableOK(Sender: TObject);
    procedure cmdMovieNameCopyClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    original_movie_filename: string;
  end;

var
  FCutlistInfo: TFCutlistInfo;

implementation

{$R *.dfm}

uses
  // Delphi
  System.SysUtils, System.StrUtils;

procedure TFCutlistInfo.FormShow(Sender: TObject);
begin
  cbFramesPresent.Left := rgRatingByAuthor.BoundsRect.Right - cbFramesPresent.Width;
  CBEPGErrorClick(Sender);
  CBOtherErrorClick(Sender);
  cmdOk.Enabled := False;
end;

procedure TFCutlistInfo.cbEPGErrorClick(Sender: TObject);
begin
  edtActualContent.Enabled := CBEPGError.Checked;
  EnableOK(Sender);
end;

procedure TFCutlistInfo.cbOtherErrorClick(Sender: TObject);
begin
  edtOtherErrorDescription.Enabled := CBOtherError.Checked;
  EnableOK(Sender);
end;

procedure TFCutlistInfo.EnableOK(Sender: TObject);
begin
  cmdOk.Enabled := RGRatingByAuthor.ItemIndex >= 0;
end;

procedure TFCutlistInfo.cmdMovieNameCopyClick(Sender: TObject);
var
  s, e: string;
begin
  s := ExtractFileName(original_movie_filename);
  e := ExtractFileExt(s);
  while AnsiMatchText(e, movie_file_extensions) do
  begin
    s := ChangeFileExt(s, '');
    e := ExtractFileExt(s);
  end;
  s := AnsiReplaceText(s, '_', ' ');
  edtMovieName.Text := s;
end;

end.

