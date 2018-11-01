UNIT UfrmCutting;

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
  JvComponentBase,
  JvCreateProcess,
  StdCtrls,
  UCutApplicationBase,
  ExtCtrls;

TYPE
  TfrmCutting = CLASS(TForm)
    memOutput: TMemo;
    cmdClose_nl: TButton;
    cmdAbort: TButton;
    cmdCopyClipbrd: TButton;
    cmdEmergencyExit: TButton;
    timAutoClose: TTimer;
    PROCEDURE CutAppTerminate(Sender: TObject; ExitCode: Cardinal);
    PROCEDURE cmdAbortClick(Sender: TObject);
    PROCEDURE cmdCopyClipbrdClick(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE cmdEmergencyExitClick(Sender: TObject);
    PROCEDURE timAutoCloseTimer(Sender: TObject);
    PROCEDURE memOutputClick(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
  PRIVATE
    { Private declarations }
    FAborted: boolean;
    FTerminateTime: TDateTime;
    //FCommandLineCounter: Integer;
    FCutApplication: TCutApplicationBase;
    PROCEDURE SetCutApplication(CONST Value: TCutApplicationBase);
  PUBLIC
    { Public declarations }
    CommandLines: TStringList;
    ExitCode: Cardinal;
    FUNCTION GetCutAppOutput: STRING;
    FUNCTION ExecuteCutApp: Integer;
    PROPERTY CutApplication: TCutApplicationBase READ FCutApplication WRITE SetCutApplication;
  END;

VAR
  frmCutting                       : TfrmCutting;

IMPLEMENTATION

USES Clipbrd,
  DateTools,
  DateUtils,
  Utils,
  Main,
  CAResources;

{$R *.dfm}

FUNCTION TfrmCutting.GetCutAppOutput: STRING;
BEGIN
  Result := memOutput.Text;
END;

FUNCTION TfrmCutting.ExecuteCutApp: Integer;
BEGIN
  result := mrNone;
  FAborted := false;
  ExitCode := 0;
  IF NOT assigned(CutApplication) THEN exit;

  cmdAbort.Enabled := true;
  cmdEmergencyExit.Enabled := true;
  cmdClose_nl.Enabled := false;
  timAutoClose.Enabled := false;
  cmdClose_nl.Caption := CAResources.RsCaptionCuttingClose;

  CutApplication.StartCutting;
  Result := self.ShowModal;
  IF CutApplication.CleanUp THEN BEGIN
    IF NOT CutApplication.CleanUpAfterCutting THEN
      IF NOT batchmode THEN
        ShowMessage(CAResources.RsErrorCleanUpCutting);
  END;
END;

PROCEDURE TfrmCutting.CutAppTerminate(Sender: TObject;
  ExitCode: Cardinal);
BEGIN
  self.ExitCode := ExitCode;
  IF ExitCode = 0 THEN BEGIN
    cmdClose_nl.ModalResult := mrOK;
  END ELSE BEGIN
    cmdClose_nl.ModalResult := mrCancel;
  END;
  cmdAbort.Enabled := false;
  cmdEmergencyExit.Enabled := false;
  cmdClose_nl.Enabled := true;
  FTerminateTime := NowUTC;
  IF Settings.CuttingWaitTimeout > 0 THEN
    timAutoClose.Enabled := true;
  Beep;
END;

PROCEDURE TfrmCutting.cmdAbortClick(Sender: TObject);
BEGIN
  self.FAborted := true;
  IF assigned(self.FCutApplication) THEN
    FCutApplication.AbortCutProcess;
END;

PROCEDURE TfrmCutting.cmdCopyClipbrdClick(Sender: TObject);
BEGIN
  Clipboard.AsText := memOutput.Text;
END;

PROCEDURE TfrmCutting.FormCreate(Sender: TObject);
BEGIN
  self.CommandLines := TStringList.Create;
END;

PROCEDURE TfrmCutting.FormDestroy(Sender: TObject);
BEGIN
  FreeAndNIL(self.CommandLines);
END;

PROCEDURE TfrmCutting.SetCutApplication(CONST Value: TCutApplicationBase);
BEGIN
  FCutApplication := Value;
  IF assigned(FCutApplication) THEN BEGIN
    FCutApplication.OnCuttingTerminate := self.CutAppTerminate;
    FCutApplication.OutputMemo := self.memOutput;
  END ELSE BEGIN
    FCutApplication.OnCuttingTerminate := NIL;
    FCutApplication.OutputMemo := NIL;
  END;
END;

PROCEDURE TfrmCutting.cmdEmergencyExitClick(Sender: TObject);
BEGIN
  IF (application.messagebox(PChar(CAResources.RsMsgWarnOnTerminateCutApplication), PChar(CAResources.RsTitleWarning), MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES) THEN BEGIN
    CutApplication.EmergencyTerminateProcess;
    self.CutAppTerminate(self, Cardinal(-1));
  END;
END;

PROCEDURE TfrmCutting.timAutoCloseTimer(Sender: TObject);
VAR
  secsToWait                       : integer;
BEGIN
  secsToWait := Settings.CuttingWaitTimeout - SecondsBetween(FTerminateTime, NowUTC);
  IF secsToWait <= 0 THEN BEGIN
    timAutoClose.Enabled := false;
    cmdClose_nl.Click;
  END
  ELSE BEGIN
    cmdClose_nl.Caption := Format(CAResources.RsCaptionCuttingAutoClose, [secsToWait]);
  END;
END;

PROCEDURE TfrmCutting.memOutputClick(Sender: TObject);
BEGIN
  IF timAutoClose.Enabled THEN BEGIN
    timAutoClose.Enabled := false;
    cmdClose_nl.Caption := CAResources.RsCaptionCuttingClose;
  END;
END;

PROCEDURE TfrmCutting.FormClose(Sender: TObject; VAR Action: TCloseAction);
BEGIN
  IF self.ModalResult = mrNone THEN
    self.ModalResult := mrCancel
  ELSE IF self.FAborted AND (self.ModalResult <> mrOk) THEN
    self.ModalResult := mrAbort;
END;

END.

