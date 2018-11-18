unit ULogging;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, Vcl.Forms, Vcl.ExtCtrls, Vcl.Controls, Vcl.StdCtrls, Vcl.ComCtrls,

  // Jedi
  JvComponentBase, JvFormMagnet;

type
  TFLogging = class(TForm)
    JvFormMagnet1: TJvFormMagnet;
    reMessages: TRichEdit;
    timScroll: TTimer;
    procedure timScrollTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private-Deklarationen }
  protected
    procedure AddMessage(const ANow: TDateTime; const AMessage: string); overload;
    procedure TimedScroll;
    procedure AppendToFile(const AFilename: string); overload;
  public
    { public-Deklarationen }
    procedure AddMessage(const AMessage: string); overload;
    procedure AppendToFile(const AFileBasename: string; const ADate: TDate); overload;
    procedure AppendToFile(const ADate: TDate); overload;
  end;

var
  FLogging: TFLogging;

implementation

uses
  // Delphi
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Math,

  // CA
  Utils, Main;

{$R *.dfm}

procedure TFLogging.timScrollTimer(Sender: TObject);
begin
  if reMessages.HandleAllocated then
  begin
    timScroll.Enabled := False;
    PostMessage(reMessages.Handle, WM_VSCROLL, SB_BOTTOM, 0); //Scroll down
  end;
end;

procedure TFLogging.AddMessage(const AMessage: string);
begin
  AddMessage(Now, AMessage);
  if Screen.ActiveForm <> Self then
    TimedScroll;
end;

procedure TFLogging.AddMessage(const ANow: TDateTime; const AMessage: string);
begin
  reMessages.Lines.Add(FormatDateTime('ddddd tt.zzz', ANow) + ': ' + AMessage);
end;

procedure TFLogging.AppendToFile(const ADate: TDate);
var
  fName: string;
begin
  fName := ExpandUNCFileName(Application.ExeName);
  //Delete(fName, Length(fName) - Length(ExtractFileExt(fName)) + 1, MaxInt);
  AppendToFile(ChangeFileExt(fName, ''), ADate);
end;

procedure TFLogging.AppendToFile(const AFileBasename: string; const ADate: TDate);
var
  fName: string;
begin
  fName := AFileBasename + FormatDateTime('-yyyy-mm-dd', ADate) + '.log';
  AppendToFile(fName);
end;

procedure TFLogging.AppendToFile(const AFilename: string);
var
  stream: TFileStream;
begin
  stream := TFileStream.Create(AFilename, fmCreate or fmOpenReadWrite, fmShareDenyWrite);
  try
    stream.Seek(0, soFromEnd);
    reMessages.Lines.SaveToStream(stream);
  finally
    FreeAndNil(stream);
  end;
end;

procedure TFLogging.TimedScroll;
begin
  timScroll.Enabled := True;
end;

procedure TFLogging.FormCreate(Sender: TObject);
begin
  if ValidRect(Settings.LoggingFormBounds) then
  begin
    BoundsRect := Settings.LoggingFormBounds
  end else
  begin
    Top  := Screen.WorkAreaTop + Max(0, (Screen.WorkAreaHeight - Height) div 2);
    Left := Screen.WorkAreaLeft + Max(0, (Screen.WorkAreaWidth - Width) div 2);
  end;

  Visible := Settings.LoggingFormVisible;
end;

procedure TFLogging.FormDestroy(Sender: TObject);
begin
  Settings.LoggingFormBounds  := BoundsRect;
  Settings.LoggingFormVisible := Visible;
end;

end.

