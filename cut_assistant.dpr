program cut_assistant;

{$I Information.inc}

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF}
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  Vcl.Forms,
  PBOnceOnly in 'lib\PBOnceOnly.pas',
  ExceptDlg in 'ExceptDlg.pas' {ExceptionDialog},
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
  CAResources in 'CAResources.pas',
  uFreeLocalizer in 'KDL\uFreeLocalizer.pas',
  uStringUtils in 'KDL\uStringUtils.pas',
  ReplaceFrame in 'ReplaceFrame.pas' {ReplaceFrame: TFrame},
  ReplaceList in 'ReplaceList.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

{$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}

procedure CheckLocalizer;
begin
  {$IFDEF DEBUG}
  if FreeLocalizer.Errors <> '' then
  begin
    ErrMsg(FreeLocalizer.Errors);
    FreeLocalizer.ClearErrors;
  end;
  {$ENDIF}
end;

const
  ProcessName = '{B3FD8E3A-7C76-404D-81D3-201CC4A4522B}';

var
  iParam: Integer;
  FileList: TStringList;
  MessageList: TStringList;
  MessageListStream: TFileStream;

begin
  MessageList := TStringList.Create;
  try
    if AlreadyRunning(ProcessName, TApplication, TFMain) then
      Exit;

    Application.Initialize;

    if (Settings.UsedStyle = '') or not Settings.RememberLastStyle then
      Settings.UsedStyle := TStyleManager.ActiveStyle.Name
    else
      if Settings.UsedStyle <> TStyleManager.ActiveStyle.Name then
          if not TStyleManager.TrySetStyle(Settings.UsedStyle) then
            Settings.UsedStyle := TStyleManager.ActiveStyle.Name;

    Application.Title := 'Cut Assistant';

    CheckLocalizer;

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

    CheckLocalizer;

    FileList := TStringList.Create;
    try
      for iParam := 1 to ParamCount do
        FileList.Add(ParamStr(iParam));
      FMain.ProcessFileList(FileList, true);
    finally
      FileList.Free;
      if BatchMode or exit_after_commandline then
        Application.Terminate
      else
        Application.Run;
    end;
  finally
    CheckLocalizer;

    if MessageList.Count > 0 then
    begin
      MessageListStream := TFileStream.Create(ChangeFileExt(Application.ExeName, '.log'), fmCreate OR fmOpenReadWrite, fmShareDenyWrite);
      try
        MessageListStream.Seek(0, soFromEnd);
        MessageList.SaveToStream(MessageListStream);
      finally
        MessageListStream.Free;
      end;
    end;
    MessageList.Free;
  end;
end.

