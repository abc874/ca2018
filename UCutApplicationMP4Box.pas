UNIT UCutApplicationMP4Box;

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
  MP4BOX_DEFAULT_EXENAME           = 'MP4Box.exe';

TYPE
  TCutApplicationMP4Box = CLASS;

  TfrmCutApplicationMP4Box = CLASS(TfrmCutApplicationBase)
    edtCommandLineOptions: TEdit;
    lblCommandLineOptions: TLabel;
  PRIVATE
    { Private declarations }
    PROCEDURE SetCutApplication(CONST Value: TCutApplicationMP4Box);
    FUNCTION GetCutApplication: TCutApplicationMP4Box;
  PUBLIC
    { Public declarations }
    PROPERTY CutApplication: TCutApplicationMP4Box READ GetCutApplication WRITE SetCutApplication;
    PROCEDURE Init; OVERRIDE;
    PROCEDURE Apply; OVERRIDE;
  END;

  TCutApplicationMP4Box = CLASS(TCutApplicationBase)
  PROTECTED
    FSourceFile, FDestFile: STRING;
    FFilePath: STRING;
    FOriginalFileList, FTempFileList: TStringList;
    FAddLastCommandTriggerIndex: Integer;
    PROCEDURE CommandLineTerminate(Sender: TObject; CONST CommandLineIndex: Integer; CONST CommandLine: STRING);
  PUBLIC
    CommandLineOptions: STRING;
    CONSTRUCTOR create; OVERRIDE;
    DESTRUCTOR destroy; OVERRIDE;
    FUNCTION LoadSettings(IniFile: TCustomIniFile): boolean; OVERRIDE;
    FUNCTION SaveSettings(IniFile: TCustomIniFile): boolean; OVERRIDE;
    FUNCTION InfoString: STRING; OVERRIDE;
    FUNCTION WriteCutlistInfo(CutlistFile: TCustomIniFile; section: STRING): boolean; OVERRIDE;
    FUNCTION PrepareCutting(SourceFileName: STRING; VAR DestFileName: STRING; Cutlist: TObjectList): boolean; OVERRIDE;
    FUNCTION CleanUpAfterCutting: boolean; OVERRIDE;
  END;

VAR
  frmCutApplicationMP4Box          : TfrmCutApplicationMP4Box;

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


{ TCutApplicationMP4Box }

CONSTRUCTOR TCutApplicationMP4Box.create;
BEGIN
  INHERITED;
  RawRead := false;
  self.OnCommandLineTerminate := self.CommandLineTerminate;
  FrameClass := TfrmCutApplicationMP4Box;
  Name := 'MP4Box';
  DefaultExeNames.Add(MP4BOX_DEFAULT_EXENAME);
  RedirectOutput := true;
  ShowAppWindow := false;

  FOriginalFileList := TStringList.Create;
  FTempFileList := TStringList.Create;
END;

FUNCTION TCutApplicationMP4Box.LoadSettings(IniFile: TCustomIniFile): boolean;
VAR
  section                          : STRING;
  success                          : boolean;
BEGIN
  success := INHERITED LoadSettings(IniFile);
  section := GetIniSectionName;
  CommandLineOptions := IniFile.ReadString(section, 'CommandLineOptions', '');
  result := success;
END;

FUNCTION TCutApplicationMP4Box.SaveSettings(IniFile: TCustomIniFile): boolean;
VAR
  section                          : STRING;
  success                          : boolean;
BEGIN
  success := INHERITED SaveSettings(IniFile);

  section := GetIniSectionName;
  IniFile.WriteString(section, 'CommandLineOptions', CommandLineOptions);
  result := success;
END;

FUNCTION TCutApplicationMP4Box.PrepareCutting(SourceFileName: STRING;
  VAR DestFileName: STRING; Cutlist: TObjectList): boolean;
CONST
  ForcedFileExt                    = '.mp4';
VAR
  TempCutlist                      : TCutlist;
  iCut                             : Integer;
  MustFreeTempCutlist              : boolean;
  CommandLine                      : STRING;
  SearchRec                        : TSearchRec;
BEGIN
  result := INHERITED PrepareCutting(SourceFileName, DestFileName, Cutlist);
  IF NOT Result THEN
    Exit;

  // Rename Files to MP4
  // TempFileExt := ExtractFileExt(SourceFileName);
  // ChangeFileExt(SourceFileName, ForcedFileExt);
  // ChangeFileExt(DestFileName, ForcedFileExt);

  self.FCommandLines.Clear;
  MustFreeTempCutlist := false;
  TempCutlist := (Cutlist AS TCutlist);

  self.FSourceFile := SourceFileName;
  self.FDestFile := DestFileName;

  IF TempCutlist.Mode <> clmTrim THEN BEGIN
    TempCutlist := TempCutlist.convert;
    MustFreeTempCutlist := True;
  END;

  TRY
    TempCutlist.sort;
    FOR iCut := 0 TO tempCutlist.Count - 1 DO BEGIN
      CommandLine := '"' + SourceFileName + '"';
      CommandLine := CommandLine + ' -splitx ' + FloatToStrInvariant(TempCutlist[iCut].pos_from) + ':' + FloatToStrInvariant(TempCutlist[iCut].pos_to);
      self.FCommandLines.Add(CommandLine);
    END;

    //Workaround for not working -out parameter
    //Add final Command after last Command of list is executed
    FAddLastCommandTriggerIndex := FCommandLines.Count - 1;
    //
    FFilePath := extractFilePath(SourceFileName);
    //Make List of existing files
    self.FOriginalFileList.Clear;
    IF findFirst(FFilePath + '*.*', faAnyFile, SearchRec) = 0 THEN BEGIN
      REPEAT
        FOriginalFileList.Add(SearchRec.Name);
      UNTIL FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    END;

    result := true;
  FINALLY
    IF MustFreeTempCutlist THEN
      FreeAndNIL(TempCutlist);
  END;

END;


FUNCTION TCutApplicationMP4Box.InfoString: STRING;
BEGIN
  Result := Format(CAResources.RsCutAppInfoMP4Box, [
    INHERITED InfoString,
      self.CommandLineOptions
      ]);
END;

FUNCTION TCutApplicationMP4Box.WriteCutlistInfo(CutlistFile: TCustomIniFile;
  section: STRING): boolean;
BEGIN
  result := INHERITED WriteCutlistInfo(CutlistFile, section);
  IF result THEN BEGIN
    cutlistfile.WriteString(section, 'IntendedCutApplicationOptions', self.CommandLineOptions);
    result := true;
  END;
END;

DESTRUCTOR TCutApplicationMP4Box.destroy;
BEGIN
  FreeAndNIL(FTempFileList);
  FreeAndNIL(FOriginalFileList);
  INHERITED;
END;


FUNCTION FileNameCompare(List: TStringList; Index1, Index2: Integer): Integer;
{The callback returns
   a value less than 0 if the string identified by Index1 comes before the string identified by Index2
   0 if the two strings are equivalent
   a value greater than 0 if the string with Index1 comes after the string identified by Index2.}
VAR
  int1, int2                       : Integer;
BEGIN
  int1 := Integer(List.Objects[Index1]);
  int2 := Integer(List.Objects[Index2]);
  IF int1 > int2 THEN result := 1
  ELSE IF int1 < int2 THEN result := -1
  ELSE { if int1=int2 then } result := 0;
END;

PROCEDURE TCutApplicationMP4Box.CommandLineTerminate(Sender: TObject;
  CONST CommandLineIndex: Integer; CONST CommandLine: STRING);
VAR
  SearchRec                        : TSearchRec;
  i                                : Integer;
  NewCommandLine                   : STRING;
  EndsSeconds                      : Integer;
  posUnderscore, posDot            : Integer;
BEGIN
  IF CommandLineIndex = FAddLastCommandTriggerIndex THEN BEGIN
    //Last Command Line Executed, now determine new files and add -cat command
    //Make List of new files
    FTempFileList.Clear;
    IF findFirst(FFilePath + '*.*', faAnyFile, SearchRec) = 0 THEN BEGIN
      REPEAT
        IF FOriginalFileList.IndexOf(SearchRec.Name) < 0 THEN BEGIN
          //get End Time in seconds from file Name
          EndsSeconds := 0;
          posUnderscore := LastDelimiter('_', SearchRec.Name);
          IF PosUnderscore > 0 THEN BEGIN
            posDot := LastDelimiter('.', SearchRec.Name);
            IF posDot < posUnderScore THEN posDot := length(SearchRec.Name) + 1;
            EndsSeconds := StrToIntDef(midstr(SearchRec.Name, PosUnderScore + 1, PosDot - (PosUnderScore + 1)), 0);
          END;
          FTempFileList.AddObject(SearchRec.Name, TObject(EndsSeconds));
        END;
      UNTIL FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
      //sort List
      FTempFileList.CustomSort(FileNameCompare);
      //Make CommandLine
      FOR i := 0 TO FTempFileList.Count - 1 DO BEGIN
        NewCommandLine := NewCommandLine + ' -cat "' + FFilePath + FTempFileList.Strings[i] + '"';
      END;
      NewCommandLine := NewCommandLine + ' "' + FDestFile + '"';
      FCommandLines.Add(NewCommandLine);
    END;
  END;
END;

FUNCTION TCutApplicationMP4Box.CleanUpAfterCutting: boolean;
VAR
  i                                : Integer;
  success                          : boolean;
BEGIN
  result := false;
  IF self.CleanUp THEN BEGIN
    result := INHERITED CleanUpAfterCutting;
    FOR i := 0 TO FTempFileList.Count - 1 DO BEGIN
      IF FileExists(FFilePath + FTempFileList.Strings[i]) THEN BEGIN
        success := DeleteFile(FFilePath + FTempFileList.Strings[i]);
        result := result AND success;
      END;
    END;
  END;
END;

{ TfrmCutApplicationMP4Box }

PROCEDURE TfrmCutApplicationMP4Box.Init;
BEGIN
  INHERITED;
  self.edtCommandLineOptions.Text := CutApplication.CommandLineOptions;
END;

PROCEDURE TfrmCutApplicationMP4Box.Apply;
BEGIN
  INHERITED;
  CutApplication.CommandLineOptions := edtCommandLIneOptions.Text;
END;

PROCEDURE TfrmCutApplicationMP4Box.SetCutApplication(
  CONST Value: TCutApplicationMP4Box);
BEGIN
  FCutApplication := Value;
END;

FUNCTION TfrmCutApplicationMP4Box.GetCutApplication: TCutApplicationMP4Box;
BEGIN
  result := (self.FCutApplication AS TCutApplicationMP4Box);
END;


END.
