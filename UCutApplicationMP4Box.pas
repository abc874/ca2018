unit UCutApplicationMP4Box;

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
  TCutApplicationMP4Box = class;

  TfrmCutApplicationMP4Box = class(TfrmCutApplicationBase)
    edtCommandLineOptions: TEdit;
    lblCommandLineOptions: TLabel;
  private
    { private declarations }
    procedure SetCutApplication(const Value: TCutApplicationMP4Box);
    function GetCutApplication: TCutApplicationMP4Box;
  public
    { public declarations }
    property CutApplication: TCutApplicationMP4Box read GetCutApplication write SetCutApplication;
    procedure Init; override;
    procedure Apply; override;
  end;

  TCutApplicationMP4Box = class(TCutApplicationBase)
  protected
    FSourceFile, FDestFile: string;
    FFilePath: string;
    FOriginalFileList, FTempFileList: TStringList;
    FAddLastCommandTriggerIndex: Integer;
    procedure CommandLineTerminate(Sender: TObject; const CommandLineIndex: Integer; const CommandLine: string); override;
  public
    CommandLineOptions: string;
    constructor Create; override;
    destructor Destroy; override;
    function LoadSettings(IniFile: TCustomIniFile): Boolean; override;
    function SaveSettings(IniFile: TCustomIniFile): Boolean; override;
    function InfoString: string; override;
    function WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean; override;
    function PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean; override;
    function CleanUpAfterCutting: Boolean; override;
  end;

var
  frmCutApplicationMP4Box: TfrmCutApplicationMP4Box;

implementation

{$R *.dfm}

uses
  // Delphi
  System.SysUtils, System.StrUtils, System.Math,

  // CA
  UCutlist, CAResources, Utils;

const
  MP4BOX_DEFAULT_EXENAME = 'MP4Box.exe';

{ TCutApplicationMP4Box }

constructor TCutApplicationMP4Box.Create;
begin
  inherited;
  RawRead := False;
  FrameClass := TfrmCutApplicationMP4Box;
  Name := 'MP4Box';
  DefaultExeNames.Add(MP4BOX_DEFAULT_EXENAME);
  RedirectOutput := True;
  ShowAppWindow := False;

  FOriginalFileList := TStringList.Create;
  FTempFileList := TStringList.Create;
end;

function TCutApplicationMP4Box.LoadSettings(IniFile: TCustomIniFile): Boolean;
var
  section: string;
  success: Boolean;
begin
  success := inherited LoadSettings(IniFile);
  section := GetIniSectionName;
  CommandLineOptions := IniFile.ReadString(section, 'CommandLineOptions', '');
  Result := success;
end;

function TCutApplicationMP4Box.SaveSettings(IniFile: TCustomIniFile): Boolean;
var
  section: string;
  success: Boolean;
begin
  success := inherited SaveSettings(IniFile);
  section := GetIniSectionName;
  IniFile.WriteString(section, 'CommandLineOptions', CommandLineOptions);
  Result := success;
end;

function TCutApplicationMP4Box.PrepareCutting(SourceFileName: string; var DestFileName: string; Cutlist: TObjectList): Boolean;
const
  ForcedFileExt = '.mp4';
var
  TempCutlist: TCutlist;
  iCut: Integer;
  MustFreeTempCutlist: Boolean;
  CommandLine: string;
  SearchRec: TSearchRec;
begin
  Result := inherited PrepareCutting(SourceFileName, DestFileName, Cutlist);
  if Result then
  begin
    // Rename Files to MP4
    // TempFileExt := ExtractFileExt(SourceFileName);
    // ChangeFileExt(SourceFileName, ForcedFileExt);
    // ChangeFileExt(DestFileName, ForcedFileExt);

    FCommandLines.Clear;
    MustFreeTempCutlist := False;
    TempCutlist := TCutlist(Cutlist);
    FSourceFile := SourceFileName;
    FDestFile   := DestFileName;

    if TempCutlist.Mode <> clmTrim then
    begin
      TempCutlist := TempCutlist.Convert;
      MustFreeTempCutlist := True;
    end;

    try
      TempCutlist.Sort;
      for iCut := 0 to Pred(tempCutlist.Count) do
      begin
        CommandLine := '"' + SourceFileName + '"';
        CommandLine := CommandLine + ' -splitx ' + FloatToStrInvariant(TempCutlist[iCut].pos_from) + ':' + FloatToStrInvariant(TempCutlist[iCut].pos_to);
        FCommandLines.Add(CommandLine);
      end;

      //Workaround for not working -out parameter
      //Add final Command after last Command of list is executed
      FAddLastCommandTriggerIndex := Pred(FCommandLines.Count);
      //
      FFilePath := ExtractFilePath(SourceFileName);
      //Make List of existing files
      FOriginalFileList.Clear;
      if FindFirst(FFilePath + '*.*', faAnyFile, SearchRec) = 0 then
      begin
        repeat
          FOriginalFileList.Add(SearchRec.Name);
        until FindNext(SearchRec) <> 0;
        FindClose(SearchRec);
      end;

      Result := True;
    finally
      if MustFreeTempCutlist then
        FreeAndNil(TempCutlist);
    end;
  end;
end;

function TCutApplicationMP4Box.InfoString: string;
begin
  Result := Format(CAResources.RsCutAppInfoMP4Box, [inherited InfoString, CommandLineOptions]);
end;

function TCutApplicationMP4Box.WriteCutlistInfo(CutlistFile: TCustomIniFile; section: string): Boolean;
begin
  Result := inherited WriteCutlistInfo(CutlistFile, section);
  if Result then
  begin
    cutlistfile.WriteString(section, 'IntendedCutApplicationOptions', CommandLineOptions);
    Result := True;
  end;
end;

destructor TCutApplicationMP4Box.Destroy;
begin
  FreeAndNil(FTempFileList);
  FreeAndNil(FOriginalFileList);
  inherited;
end;

function FileNameCompare(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := Sign(Integer(List.Objects[Index1]) - Integer(List.Objects[Index2]));
end;

procedure TCutApplicationMP4Box.CommandLineTerminate(Sender: TObject; const CommandLineIndex: Integer; const CommandLine: string);
var
  SearchRec: TSearchRec;
  i: Integer;
  NewCommandLine: string;
  EndsSeconds: Integer;
  posUnderscore, posDot: Integer;
begin
  if CommandLineIndex = FAddLastCommandTriggerIndex then
  begin
    //Last Command Line Executed, now determine new files and add -cat command
    //Make List of new files
    FTempFileList.Clear;
    if findFirst(FFilePath + '*.*', faAnyFile, SearchRec) = 0 then
    begin
      repeat
        if FOriginalFileList.IndexOf(SearchRec.Name) < 0 then
        begin
          //get end Time in seconds from file Name
          EndsSeconds := 0;
          posUnderscore := LastDelimiter('_', SearchRec.Name);
          if PosUnderscore > 0 then
          begin
            posDot := LastDelimiter('.', SearchRec.Name);
            if posDot < posUnderScore then posDot := Length(SearchRec.Name) + 1;
            EndsSeconds := StrToIntDef(midstr(SearchRec.Name, PosUnderScore + 1, PosDot - (PosUnderScore + 1)), 0);
          end;
          FTempFileList.AddObject(SearchRec.Name, TObject(EndsSeconds));
        end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
      //sort List
      FTempFileList.CustomSort(FileNameCompare);
      //Make CommandLine
      for i := 0 to Pred(FTempFileList.Count) do
        NewCommandLine := NewCommandLine + ' -cat "' + FFilePath + FTempFileList.Strings[i] + '"';

      NewCommandLine := NewCommandLine + ' "' + FDestFile + '"';
      FCommandLines.Add(NewCommandLine);
    end;
  end;
end;

function TCutApplicationMP4Box.CleanUpAfterCutting: Boolean;
var
  i: Integer;
  success: Boolean;
begin
  if CleanUp then
  begin
    Result := inherited CleanUpAfterCutting;
    for i := 0 to Pred(FTempFileList.Count) do
    begin
      if FileExists(FFilePath + FTempFileList.Strings[i]) then
      begin
        success := DeleteFile(FFilePath + FTempFileList.Strings[i]);
        Result  := Result and success;
      end;
    end;
  end else
    Result := False;
end;

{ TfrmCutApplicationMP4Box }

procedure TfrmCutApplicationMP4Box.Init;
begin
  inherited;
  edtCommandLineOptions.Text := CutApplication.CommandLineOptions;
end;

procedure TfrmCutApplicationMP4Box.Apply;
begin
  inherited;
  CutApplication.CommandLineOptions := edtCommandLIneOptions.Text;
end;

procedure TfrmCutApplicationMP4Box.SetCutApplication(const Value: TCutApplicationMP4Box);
begin
  FCutApplication := Value;
end;

function TfrmCutApplicationMP4Box.GetCutApplication: TCutApplicationMP4Box;
begin
  Result := FCutApplication as TCutApplicationMP4Box;
end;

end.

