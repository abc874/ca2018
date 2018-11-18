unit UfrmCutting;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Controls,

  // CA
  UCutApplicationBase;

type
  TfrmCutting = class(TForm)
    memOutput: TMemo;
    cmdClose_nl: TButton;
    cmdAbort: TButton;
    cmdCopyClipbrd: TButton;
    cmdEmergencyExit: TButton;
    timAutoClose: TTimer;
    procedure CutAppTerminate(Sender: TObject; AExitCode: Cardinal);
    procedure cmdAbortClick(Sender: TObject);
    procedure cmdCopyClipbrdClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdEmergencyExitClick(Sender: TObject);
    procedure timAutoCloseTimer(Sender: TObject);
    procedure memOutputClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { private declarations }
    FAborted: Boolean;
    FTerminateTime: TDateTime;
    //FCommandLineCounter: Integer;
    FCutApplication: TCutApplicationBase;
    procedure SetCutApplication(const Value: TCutApplicationBase);
  public
    { public declarations }
    CommandLines: TStringList;
    ExitCode: Cardinal;
    function GetCutAppOutput: string;
    function ExecuteCutApp: Integer;
    property CutApplication: TCutApplicationBase read FCutApplication write SetCutApplication;
  end;

var
  frmCutting: TfrmCutting;

implementation

uses
  // Delphi
  Winapi.Windows, System.SysUtils, System.DateUtils, Vcl.Clipbrd,

  // CA
  CAResources, DateTools, Main, Utils;

{$R *.dfm}

function TfrmCutting.GetCutAppOutput: string;
begin
  Result := memOutput.Text;
end;

function TfrmCutting.ExecuteCutApp: Integer;
begin
  Result   := mrNone;
  FAborted := False;
  ExitCode := 0;

  if Assigned(CutApplication) then
  begin
    cmdAbort.Enabled         := True;
    cmdEmergencyExit.Enabled := True;
    cmdClose_nl.Enabled      := False;
    timAutoClose.Enabled     := False;
    cmdClose_nl.Caption      := RsCaptionCuttingClose;

    CutApplication.StartCutting;
    Result := ShowModal;
    if CutApplication.CleanUp then
      if not CutApplication.CleanUpAfterCutting then
        if not batchmode then
          ErrMsg(RsErrorCleanUpCutting);
  end;
end;

procedure TfrmCutting.CutAppTerminate(Sender: TObject; AExitCode: Cardinal);
begin
  ExitCode := AExitCode;

  if ExitCode = 0 then
    cmdClose_nl.ModalResult := mrOK
  else
    cmdClose_nl.ModalResult := mrCancel;

  cmdAbort.Enabled := False;
  cmdEmergencyExit.Enabled := False;
  cmdClose_nl.Enabled := True;
  FTerminateTime := NowUTC;
  if Settings.CuttingWaitTimeout > 0 then
    timAutoClose.Enabled := True;
  Beep;
end;

procedure TfrmCutting.cmdAbortClick(Sender: TObject);
begin
  FAborted := True;
  if Assigned(FCutApplication) then
    FCutApplication.AbortCutProcess;
end;

procedure TfrmCutting.cmdCopyClipbrdClick(Sender: TObject);
begin
  Clipboard.AsText := memOutput.Text;
end;

procedure TfrmCutting.FormCreate(Sender: TObject);
begin
  CommandLines := TStringList.Create;
end;

procedure TfrmCutting.FormDestroy(Sender: TObject);
begin
  FreeAndNil(CommandLines);
end;

procedure TfrmCutting.SetCutApplication(const Value: TCutApplicationBase);
begin
  FCutApplication := Value;
  if Assigned(FCutApplication) then
  begin
    FCutApplication.OnCuttingTerminate := CutAppTerminate;
    FCutApplication.OutputMemo := memOutput;
  end else
  begin
    FCutApplication.OnCuttingTerminate := nil;
    FCutApplication.OutputMemo := nil;
  end;
end;

procedure TfrmCutting.cmdEmergencyExitClick(Sender: TObject);
begin
  if YesNoWarnMsg(RsMsgWarnOnTerminateCutApplication) then
  begin
    CutApplication.EmergencyTerminateProcess;
    CutAppTerminate(Self, Cardinal(-1));
  end;
end;

procedure TfrmCutting.timAutoCloseTimer(Sender: TObject);
var
  secsToWait: Integer;
begin
  secsToWait := Settings.CuttingWaitTimeout - SecondsBetween(FTerminateTime, NowUTC);
  if secsToWait <= 0 then
  begin
    timAutoClose.Enabled := False;
    cmdClose_nl.Click;
  end else
    cmdClose_nl.Caption := Format(RsCaptionCuttingAutoClose, [secsToWait]);
end;

procedure TfrmCutting.memOutputClick(Sender: TObject);
begin
  if timAutoClose.Enabled then
  begin
    timAutoClose.Enabled := False;
    cmdClose_nl.Caption  := RsCaptionCuttingClose;
  end;
end;

procedure TfrmCutting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrNone then
    ModalResult := mrCancel
  else
    if FAborted and (ModalResult <> mrOk) then
      ModalResult := mrAbort;
end;

end.

