UNIT UCutApplicationAsfBin;

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
  UCutApplicationBase,
  StdCtrls,
  IniFiles,
  Contnrs,
  JvExStdCtrls,
  JvCheckBox;

CONST
  ASFBIN_DEFAULT_EXENAME_1         = 'asfbin.exe';
  ASFBIN_DEFAULT_EXENAME_2         = 'asfcut.exe';

  //rkf Options Syntax
  RKF_1                            = '-rkf';
  RKF_2                            = '-recreatekf';


TYPE
  TCutApplicationAsfbin = CLASS;

  TfrmCutApplicationAsfbin = CLASS(TfrmCutApplicationBase)
    edtCommandLineOptions: TEdit;
    lblCommandLineOptions: TLabel;
    cbRkf: TJvCheckBox;
    PROCEDURE cbRkfClick(Sender: TObject);
    PROCEDURE edtCommandLineOptionsChange(Sender: TObject);
  PRIVATE
    { Private declarations }
    PROCEDURE SetCutApplication(CONST Value: TCutApplicationAsfbin);
    FUNCTION GetCutApplication: TCutApplicationAsfbin;
  PUBLIC
    { Public declarations }
    PROPERTY CutApplication: TCutApplicationAsfbin READ GetCutApplication WRITE SetCutApplication;
    PROCEDURE Init; OVERRIDE;
    PROCEDURE Apply; OVERRIDE;
  END;

  TCutApplicationAsfbin = CLASS(TCutApplicationBase)
  PROTECTED
  PUBLIC
    CommandLineOptions: STRING;
    CONSTRUCTOR create; OVERRIDE;
    FUNCTION LoadSettings(IniFile: TCustomIniFile): boolean; OVERRIDE;
    FUNCTION SaveSettings(IniFile: TCustomIniFile): boolean; OVERRIDE;
    FUNCTION InfoString: STRING; OVERRIDE;
    FUNCTION WriteCutlistInfo(CutlistFile: TCustomIniFile; section: STRING): boolean; OVERRIDE;
    FUNCTION PrepareCutting(SourceFileName: STRING; VAR DestFileName: STRING; Cutlist: TObjectList): boolean; OVERRIDE;
  END;

VAR
  frmCutApplicationAsfbin          : TfrmCutApplicationAsfbin;

IMPLEMENTATION

{$R *.dfm}

{$WARN UNIT_PLATFORM OFF}

USES
  CAResources,
  FileCtrl,
  StrUtils,
  UCutlist,
  UfrmCutting,
  Utils;


{ TCutApplicationAsfbin }

CONSTRUCTOR TCutApplicationAsfbin.create;
BEGIN
  INHERITED;
  FrameClass := TfrmCutApplicationAsfbin;
  Name := 'Asfbin';
  DefaultExeNames.Add(ASFBIN_DEFAULT_EXENAME_1);
  DefaultExeNames.Add(ASFBIN_DEFAULT_EXENAME_2);
  RedirectOutput := true;
  ShowAppWindow := false;
END;

FUNCTION TCutApplicationAsfbin.LoadSettings(IniFile: TCustomIniFile): boolean;
VAR
  section                          : STRING;
  success                          : boolean;
BEGIN
  //This part only for compatibility issues for versions below 0.9.9
  //These Settings may be overwritten below
  self.Path := IniFile.ReadString('External Cut Application', 'Path', '');
  self.CommandLineOptions := IniFile.ReadString('External Cut Application', 'CommandLineOptions', '');

  success := INHERITED LoadSettings(IniFile);
  section := GetIniSectionName;
  CommandLineOptions := IniFile.ReadString(section, 'CommandLineOptions', CommandLineOptions);
  result := success;
END;

FUNCTION TCutApplicationAsfbin.SaveSettings(IniFile: TCustomIniFile): boolean;
VAR
  section                          : STRING;
  success                          : boolean;
BEGIN
  success := INHERITED SaveSettings(IniFile);

  section := GetIniSectionName;
  IniFile.WriteString(section, 'CommandLineOptions', CommandLineOptions);
  result := success;
END;

FUNCTION TCutApplicationAsfbin.PrepareCutting(SourceFileName: STRING;
  VAR DestFileName: STRING; Cutlist: TObjectList): boolean;
VAR
  TempCutlist                      : TCutlist;
  iCut                             : Integer;
  MustFreeTempCutlist              : boolean;
  CommandLine                      : STRING;
BEGIN
  result := INHERITED PrepareCutting(SourceFileName, DestFileName, Cutlist);
  IF NOT Result THEN
    Exit;

  self.FCommandLines.Clear;
  MustFreeTempCutlist := false;
  TempCutlist := (Cutlist AS TCutlist);

  IF TempCutlist.Mode <> clmTrim THEN BEGIN
    TempCutlist := TempCutlist.convert;
    MustFreeTempCutlist := True;
  END;

  CommandLine := '-i "' + SourceFileName + '" -o "' + DestFileName + '" ';

  TRY
    TempCutlist.sort;
    FOR iCut := 0 TO TempCutlist.Count - 1 DO BEGIN
      CommandLine := CommandLine + ' -start ' + FloatToStrInvariant(TempCutlist[iCut].pos_from);
      CommandLine := CommandLine + ' -duration ' + FloatToStrInvariant(TempCutlist[iCut].pos_to - TempCutlist[iCut].pos_from);
    END;

    CommandLine := CommandLine + ' ' + self.CommandLineOptions;
    self.FCommandLines.Add(CommandLine);
    result := true;
  FINALLY
    IF MustFreeTempCutlist THEN
      FreeAndNIL(TempCutlist);
  END;
END;


FUNCTION TCutApplicationAsfbin.InfoString: STRING;
BEGIN
  Result := Format(CAResources.RsCutAppInfoAsfBin, [
    INHERITED InfoString,
      self.CommandLineOptions
      ]);
END;

FUNCTION TCutApplicationAsfbin.WriteCutlistInfo(CutlistFile: TCustomIniFile;
  section: STRING): boolean;
BEGIN
  result := INHERITED WriteCutlistInfo(CutlistFile, section);
  IF result THEN BEGIN
    cutlistfile.WriteString(section, 'IntendedCutApplicationOptions', self.CommandLineOptions);
    result := true;
  END;
END;

{ TfrmCutApplicationAsfbin }

PROCEDURE TfrmCutApplicationAsfbin.Init;
BEGIN
  INHERITED;
  self.edtCommandLineOptions.Text := CutApplication.CommandLineOptions;
  self.edtCommandLineOptionsChange(NIL);
END;

PROCEDURE TfrmCutApplicationAsfbin.Apply;
BEGIN
  INHERITED;
  CutApplication.CommandLineOptions := edtCommandLIneOptions.Text;
END;

PROCEDURE TfrmCutApplicationAsfbin.SetCutApplication(
  CONST Value: TCutApplicationAsfbin);
BEGIN
  FCutApplication := Value;
END;

FUNCTION TfrmCutApplicationAsfbin.GetCutApplication: TCutApplicationAsfbin;
BEGIN
  result := (self.FCutApplication AS TCutApplicationAsfbin);
END;

PROCEDURE TfrmCutApplicationAsfbin.cbRkfClick(Sender: TObject);
VAR
  s                                : STRING;
BEGIN
  s := edtCommandLineOptions.Text;
  IF cbRkf.Checked THEN BEGIN
    IF NOT (AnsiContainsText(s, RKF_1) OR AnsiContainsText(s, RKF_2)) THEN BEGIN
      s := RKF_1 + ' ' + s;
    END;
  END ELSE BEGIN
    s := AnsiReplaceText(s, RKF_1, '');
    s := AnsiReplaceText(s, RKF_2, '');
    //remove double spaces
    WHILE AnsiPos('  ', s) > 0 DO BEGIN
      s := AnsiReplaceText(s, '  ', ' ');
    END;
  END;
  edtCommandLineOptions.Text := trim(s);
END;

PROCEDURE TfrmCutApplicationAsfbin.edtCommandLineOptionsChange(
  Sender: TObject);
VAR
  s                                : STRING;
BEGIN
  s := edtCommandLineOptions.Text;
  self.cbRkf.Checked := (AnsiContainsText(s, RKF_1) OR AnsiContainsText(s, RKF_2));
END;

END.
