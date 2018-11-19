unit UCutApplicationAsfBin;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, System.IniFiles, System.Contnrs, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Controls,

  // Jedi
  JvExStdCtrls, JvCheckBox,

  // CA
  UCutApplicationBase;

type
  TCutApplicationAsfbin = class;

  TfrmCutApplicationAsfbin = class(TfrmCutApplicationBase)
    edtCommandLineOptions: TEdit;
    lblCommandLineOptions: TLabel;
    cbRkf: TJvCheckBox;
    procedure cbRkfClick(Sender: TObject);
    procedure edtCommandLineOptionsChange(Sender: TObject);
  private
    { private declarations }
    procedure SetCutApplication(const Value: TCutApplicationAsfbin);
    function GetCutApplication: TCutApplicationAsfbin;
  public
    { public declarations }
    property CutApplication: TCutApplicationAsfbin read GetCutApplication write SetCutApplication;
    procedure Init; override;
    procedure Apply; override;
  end;

  TCutApplicationAsfbin = class(TCutApplicationBase)
  protected
  public
    CommandLineOptions: string;
    constructor Create; override;
    function LoadSettings(IniFile: TCustomIniFile): Boolean; override;
    function SaveSettings(IniFile: TCustomIniFile): Boolean; override;
    function InfoString: string; override;
    function WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean; override;
    function PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean; override;
  end;

var
  frmCutApplicationAsfbin          : TfrmCutApplicationAsfbin;

implementation

{$R *.dfm}

{.....$WARN UNIT_PLATFORM OFF}

uses
  // Delphi
  System.SysUtils, System.StrUtils,

  // CA
  UCutlist, CAResources, Utils;

const
  ASFBIN_DEFAULT_EXENAME_1 = 'asfbin.exe';
  ASFBIN_DEFAULT_EXENAME_2 = 'asfcut.exe';

  // rkf Options Syntax
  RKF_1 = '-rkf';
  RKF_2 = '-recreatekf';

{ TCutApplicationAsfbin }

constructor TCutApplicationAsfbin.Create;
begin
  inherited;
  FrameClass := TfrmCutApplicationAsfbin;
  Name := 'Asfbin';
  DefaultExeNames.Add(ASFBIN_DEFAULT_EXENAME_1);
  DefaultExeNames.Add(ASFBIN_DEFAULT_EXENAME_2);
  RedirectOutput := True;
  ShowAppWindow := False;
end;

function TCutApplicationAsfbin.LoadSettings(IniFile: TCustomIniFile): Boolean;
var
  section: string;
  success: Boolean;
begin
  //This part only for compatibility issues for versions below 0.9.9
  //These Settings may be overwritten below
  Path := IniFile.ReadString('External Cut Application', 'Path', '');
  CommandLineOptions := IniFile.ReadString('External Cut Application', 'CommandLineOptions', '');

  success := inherited LoadSettings(IniFile);
  section := GetIniSectionName;
  CommandLineOptions := IniFile.ReadString(section, 'CommandLineOptions', CommandLineOptions);
  Result := success;
end;

function TCutApplicationAsfbin.SaveSettings(IniFile: TCustomIniFile): Boolean;
var
  section: string;
  success: Boolean;
begin
  success := inherited SaveSettings(IniFile);

  section := GetIniSectionName;
  IniFile.WriteString(section, 'CommandLineOptions', CommandLineOptions);
  Result := success;
end;

function TCutApplicationAsfbin.PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean;
var
  TempCutlist: TCutlist;
  iCut: Integer;
  MustFreeTempCutlist: Boolean;
  CommandLine: string;
begin
  Result := inherited PrepareCutting(SourceFileName, DestFileName, Cutlist);
  if Result then
  begin
    FCommandLines.Clear;
    MustFreeTempCutlist := False;
    TempCutlist := (Cutlist as TCutlist);

    if TempCutlist.Mode <> clmTrim then
    begin
      TempCutlist := TempCutlist.Convert;
      MustFreeTempCutlist := True;
    end;

    CommandLine := '-i "' + SourceFileName + '" -o "' + DestFileName + '" ';

    try
      TempCutlist.Sort;
      for iCut := 0 to Pred(TempCutlist.Count) do
      begin
        CommandLine := CommandLine + ' -start ' + FloatToStrInvariant(TempCutlist[iCut].pos_from);
        CommandLine := CommandLine + ' -duration ' + FloatToStrInvariant(TempCutlist[iCut].pos_to - TempCutlist[iCut].pos_from);
      end;

      CommandLine := CommandLine + ' ' + CommandLineOptions;
      FCommandLines.Add(CommandLine);
      Result := True;
    finally
      if MustFreeTempCutlist then
        FreeAndNil(TempCutlist);
    end;
  end;
end;

function TCutApplicationAsfbin.InfoString: string;
begin
  Result := Format(CAResources.RsCutAppInfoAsfBin, [inherited InfoString, CommandLineOptions]);
end;

function TCutApplicationAsfbin.WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean;
begin
  Result := inherited WriteCutlistInfo(CutlistFile, section);
  if Result then
  begin
    cutlistfile.WriteString(section, 'IntendedCutApplicationOptions', CommandLineOptions);
    Result := True;
  end;
end;

{ TfrmCutApplicationAsfbin }

procedure TfrmCutApplicationAsfbin.Init;
begin
  inherited;
  edtCommandLineOptions.Text := CutApplication.CommandLineOptions;
  edtCommandLineOptionsChange(nil);
end;

procedure TfrmCutApplicationAsfbin.Apply;
begin
  inherited;
  CutApplication.CommandLineOptions := edtCommandLIneOptions.Text;
end;

procedure TfrmCutApplicationAsfbin.SetCutApplication(const Value: TCutApplicationAsfbin);
begin
  FCutApplication := Value;
end;

function TfrmCutApplicationAsfbin.GetCutApplication: TCutApplicationAsfbin;
begin
  Result := (FCutApplication as TCutApplicationAsfbin);
end;

procedure TfrmCutApplicationAsfbin.cbRkfClick(Sender: TObject);
var
  s: string;
begin
  s := edtCommandLineOptions.Text;
  if cbRkf.Checked then
  begin
    if not (AnsiContainsText(s, RKF_1) or AnsiContainsText(s, RKF_2)) then
      s := RKF_1 + ' ' + s;
  end else
  begin
    s := AnsiReplaceText(s, RKF_1, '');
    s := AnsiReplaceText(s, RKF_2, '');
    //remove Double spaces
    while AnsiPos('  ', s) > 0 do
      s := AnsiReplaceText(s, '  ', ' ');
  end;
  edtCommandLineOptions.Text := Trim(s);
end;

procedure TfrmCutApplicationAsfbin.edtCommandLineOptionsChange(Sender: TObject);
var
  s: string;
begin
  s := edtCommandLineOptions.Text;
  cbRkf.Checked := (AnsiContainsText(s, RKF_1) or AnsiContainsText(s, RKF_2));
end;

end.

