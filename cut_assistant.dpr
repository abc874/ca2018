PROGRAM cut_assistant;

{%File 'readme.txt'}
{%File 'news.txt'}
{%File 'license.txt'}
{%File 'cut_assistant_info.xml'}
{%File 'cut_assistant.en.lng'}
{%File 'cut_assistant.lng'}
{%File 'cut_assistant.de.lng'}

uses
  madExcept,
  uFreeLocalizer,
  SysUtils,
  PBOnceOnly in 'lib\PBOnceOnly.pas',
  Forms,
  Classes,
  Main in 'Main.pas' {FMain},
  Settings_dialog in 'Settings_dialog.pas' {FSettings},
  UMemoDialog in 'UMemoDialog.pas' {frmMemoDialog},
  ManageFilters in 'ManageFilters.pas' {FManageFilters},
  Frames in 'Frames.pas' {FFrames},
  CutlistRate_dialog in 'CutlistRate_dialog.pas' {FCutlistRate},
  ResultingTimes in 'ResultingTimes.pas' {FResultingTimes},
  CutlistSearchResults in 'CutlistSearchResults.pas' {FCutlistSearchResults},
  CutlistInfo_dialog in 'CutlistInfo_dialog.pas' {FCutlistInfo},
  UploadList in 'UploadList.pas' {Form1},
  Utils in 'Utils.pas',
  Movie in 'Movie.pas',
  CodecSettings in 'CodecSettings.pas',
  VfW in 'lib\VfW.pas',
  UCutlist in 'UCutlist.pas',
  UCutApplicationBase in 'UCutApplicationBase.pas' {frmCutApplicationBase: TFrame},
  UCutApplicationMP4Box in 'UCutApplicationMP4Box.pas' {frmCutApplicationMP4Box: TFrame},
  UfrmCutting in 'UfrmCutting.pas' {frmCutting},
  UCutApplicationAsfbin in 'UCutApplicationAsfbin.pas' {frmCutApplicationAsfbin: TFrame},
  UCutApplicationAviDemux in 'UCutApplicationAviDemux.pas' {frmCutApplicationAviDemux: TFrame},
  UFilterBank in 'UFilterBank.pas',
  UCutApplicationVirtualDub in 'UCutApplicationVirtualDub.pas' {frmCutApplicationVirtualDub: TFrame},
  trackBarEx in 'VCL\TrackBarEx\trackBarEx.pas',
  Unit_DSTrackBarEx in 'VCL\DSTrackBarEx\Unit_DSTrackBarEx.pas',
  DateTools in 'DateTools.pas',
  ULogging in 'ULogging.pas' {FLogging},
  UDSAStorage in 'UDSAStorage.pas',
  UAbout in 'UAbout.pas' {AboutBox},
  CAResources in 'CAResources.pas';

{$R *.res}
CONST
  ProcessName                      = '{B3FD8E3A-7C76-404D-81D3-201CC4A4522B}';

VAR
  iParam                           : integer;
  FileList                         : TStringList;
  MessageList                      : TStringList;
  MessageListStream                : TFileStream;

BEGIN
  MessageListStream := NIL;
  MessageList := TStringList.Create;
  TRY
    IF AlreadyRunning(ProcessName, TApplication, TFMain) THEN
      Exit;

    Application.Initialize;
    Application.Title := 'Cut Assistant';

    IF FreeLocalizer.Errors <> '' THEN BEGIN
      Application.MessageBox(pChar(FreeLocalizer.Errors), 'Localizer Errors');
      FreeLocalizer.ClearErrors;
    END;

    Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFSettings, FSettings);
  Application.CreateForm(TfrmMemoDialog, frmMemoDialog);
  Application.CreateForm(TFManageFilters, FManageFilters);
  Application.CreateForm(TFFrames, FFrames);
  Application.CreateForm(TFCutlistRate, FCutlistRate);
  Application.CreateForm(TFResultingTimes, FResultingTimes);
  Application.CreateForm(TFCutlistSearchResults, FCutlistSearchResults);
  Application.CreateForm(TFCutlistInfo, FCutlistInfo);
  Application.CreateForm(TFUploadList, FUploadList);
  Application.CreateForm(TfrmCutting, frmCutting);
  Application.CreateForm(TFLogging, FLogging);
  Application.CreateForm(TAboutBox, AboutBox);
  FFrames.MainForm := FMain;

    IF FreeLocalizer.Errors <> '' THEN BEGIN
      Application.MessageBox(pChar(FreeLocalizer.Errors), 'Localizer Errors');
      FreeLocalizer.ClearErrors;
    END;

    FileList := TStringList.Create;
    FOR iParam := 1 TO ParamCount DO BEGIN
      FileList.Add(ParamStr(iParam));
    END;
    TRY
      FMain.ProcessFileList(FileList, true);
    FINALLY
      FreeAndNIL(FileList);
      IF BatchMode OR exit_after_commandline THEN
        application.Terminate
      ELSE
        Application.Run;
    END;
  FINALLY
    IF MessageList.Count > 0 THEN BEGIN
      MessageListStream := TFileStream.Create(ChangeFileExt(Application.ExeName, '.log'), fmCreate OR fmOpenReadWrite, fmShareDenyWrite);
      TRY
        MessageListStream.Seek(0, soFromEnd);
        MessageList.SaveToStream(MessageListStream);
      FINALLY
        FreeAndNil(MessageListStream);
      END;
    END;
    FreeAndNIL(MessageList);
  END;
END.

