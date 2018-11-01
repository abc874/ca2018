UNIT Utils;

INTERFACE

USES
  Classes,
  Forms,
  StdCtrls,
  Windows,
  Graphics,
  SysUtils,
  IniFiles,
  MMSystem,
  DSUtil,
  madExcept,
  IdMultipartFormData;

CONST
  Application_name                 = 'Cut_assistant.exe'; //for use in cutlist files etc.

CONST // Multimedia key codes
  VK_BROWSER_BACK                  = $A6;
{$EXTERNALSYM VK_BROWSER_BACK}
  VK_BROWSER_FORWARD               = $A7;
{$EXTERNALSYM VK_BROWSER_FORWARD}
  VK_BROWSER_REFRESH               = $A8;
{$EXTERNALSYM VK_BROWSER_REFRESH}
  VK_BROWSER_STOP                  = $A9;
{$EXTERNALSYM VK_BROWSER_STOP}
  VK_BROWSER_SEARCH                = $AA;
{$EXTERNALSYM VK_BROWSER_SEARCH}
  VK_BROWSER_FAVORITES             = $AB;
{$EXTERNALSYM VK_BROWSER_FAVORITES}
  VK_BROWSER_HOME                  = $AC;
{$EXTERNALSYM VK_BROWSER_HOME}

  VK_VOLUME_MUTE                   = $AD;
{$EXTERNALSYM VK_VOLUME_MUTE}
  VK_VOLUME_DOWN                   = $AE;
{$EXTERNALSYM VK_VOLUME_DOWN}
  VK_VOLUME_UP                     = $AF;
{$EXTERNALSYM VK_VOLUME_UP}
  VK_MEDIA_NEXT_TRACK              = $B0;
{$EXTERNALSYM VK_MEDIA_NEXT_TRACK}
  VK_MEDIA_PREV_TRACK              = $B1;
{$EXTERNALSYM VK_MEDIA_PREV_TRACK}
  VK_MEDIA_STOP                    = $B2;
{$EXTERNALSYM VK_MEDIA_STOP}
  VK_MEDIA_PLAY_PAUSE              = $B3;
{$EXTERNALSYM VK_MEDIA_PLAY_PAUSE}
  VK_LAUNCH_MAIL                   = $B4;
{$EXTERNALSYM VK_LAUNCH_MAIL}
  VK_LAUNCH_MEDIA_SELECT           = $B5;
{$EXTERNALSYM VK_LAUNCH_MEDIA_SELECT}
  VK_LAUNCH_APP1                   = $B6;
{$EXTERNALSYM VK_LAUNCH_APP1}
  VK_LAUNCH_APP2                   = $B7;
{$EXTERNALSYM VK_LAUNCH_APP2}


  //global Vars
VAR
  batchmode                        : boolean;

TYPE
  ARFileVersion = ARRAY[0..3] OF WORD;

  RCutAppSettings = RECORD
    CutAppName: STRING;
    PreferredSourceFilter: TGUID;
    CodecName: STRING;
    CodecFourCC: FOURCC;
    CodecVersion: DWORD;
    CodecSettingsSize: integer;
    CodecSettings: STRING;
  END;

  THttpRequest = CLASS(TObject)
  PRIVATE
    FUrl: STRING;
    FHandleRedirects: boolean;
    FResponse: STRING;
    FErrorMessage: STRING;
    FPostData: TIdMultiPartFormDataStream;
    FIsPost: boolean;
  PUBLIC
    CONSTRUCTOR Create(CONST Url: STRING; CONST handleRedirects: boolean; CONST Error_message: STRING); OVERLOAD;
    DESTRUCTOR Destroy; OVERRIDE;
  PROTECTED
    PROCEDURE SetIsPost(CONST value: boolean);
  PUBLISHED
    PROPERTY IsPostRequest: boolean READ FIsPost WRITE SetIsPost;
    PROPERTY Url: STRING READ FUrl WRITE FUrl;
    PROPERTY HandleRedirects: boolean READ FHandleRedirects WRITE FHandleRedirects;
    PROPERTY Response: STRING READ FResponse WRITE FResponse;
    PROPERTY ErrorMessage: STRING READ FErrorMessage WRITE FErrorMessage;
    PROPERTY PostData: TIdMultiPartFormDataStream READ FPostData;
  END;

  { TGUIDList - A strong typed list for TGUID }

  TGUIDList = CLASS
  PRIVATE
    FGUIDList: ARRAY OF TGUID;
    FCount: Integer;
    FUNCTION GetItem(Index: Integer): TGUID;
    PROCEDURE SetItem(Index: Integer; CONST Value: TGUID);
    FUNCTION GetItemString(Index: Integer): STRING;
    PROCEDURE SetItemString(Index: Integer; CONST Value: STRING);
  PUBLIC
    CONSTRUCTOR Create; VIRTUAL;
    DESTRUCTOR Destroy; OVERRIDE;
    PROPERTY Item[Index: Integer]: TGUID READ GetItem WRITE SetItem; DEFAULT;
    PROPERTY ItemString[Index: Integer]: STRING READ GetItemString WRITE SetItemString;
    PROCEDURE Clear;
    FUNCTION Add(aGUID: TGUID): Integer;
    FUNCTION AddFromString(aGUIDString: STRING): Integer;
    PROCEDURE Delete(Index: Integer); OVERLOAD;
    PROCEDURE Delete(Item: TGUID); OVERLOAD;
    FUNCTION IndexOf(aGUID: TGUID): Integer; OVERLOAD;
    FUNCTION IndexOf(aGUIDString: STRING): Integer; OVERLOAD;
    FUNCTION IsInList(aGUID: TGUID): boolean; OVERLOAD;
    FUNCTION IsInList(aGUIDString: STRING): boolean; OVERLOAD;
    PROPERTY Count: Integer READ FCount;
  END;

  { TMemIniFileEx - An enhanced version of TMemIniFile that has more
    strong typed read and write methods. If FileName is empty, the file
    will not get saved to disk. }

  TMemIniFileEx = CLASS(TMemIniFile)
  PRIVATE
    FFormatSettings: TFormatSettings;
    FVolatile: boolean;
    FUNCTION GetIsVolatile: boolean;
  PUBLISHED
    PROPERTY Volatile: boolean READ FVolatile WRITE FVolatile DEFAULT false;
    PROPERTY IsVolatile: boolean READ GetIsVolatile;
  PUBLIC
    CONSTRUCTOR Create(CONST FileName: STRING); OVERLOAD;
    CONSTRUCTOR Create(CONST FileName: STRING; CONST formatSettings: TFormatSettings); OVERLOAD;

    FUNCTION ReadFloat(CONST Section, Name: STRING; Default: Double): Double; OVERRIDE;
    PROCEDURE WriteFloat(CONST Section, Name: STRING; Value: Double); OVERRIDE;

    FUNCTION ReadDate(CONST Section, Name: STRING; Default: TDateTime): TDateTime; OVERRIDE;
    PROCEDURE WriteDate(CONST Section, Name: STRING; Value: TDateTime); OVERRIDE;
    FUNCTION ReadTime(CONST Section, Name: STRING; Default: TDateTime): TDateTime; OVERRIDE;
    PROCEDURE WriteTime(CONST Section, Name: STRING; Value: TDateTime); OVERRIDE;
    FUNCTION ReadDateTime(CONST Section, Name: STRING; Default: TDateTime): TDateTime; OVERRIDE;
    PROCEDURE WriteDateTime(CONST Section, Name: STRING; Value: TDateTime); OVERRIDE;

    FUNCTION ReadRect(CONST Section, Prefix: STRING; CONST Default: TRect): TRect; VIRTUAL;
    PROCEDURE WriteRect(CONST Section, Prefix: STRING; CONST Value: TRect); VIRTUAL;

    FUNCTION ReadGuid(CONST Section, Name: STRING; CONST Default: TGUID): TGUID; VIRTUAL;
    PROCEDURE WriteGuid(CONST Section, Name: STRING; CONST Value: TGUID); VIRTUAL;

    PROCEDURE ReadCutAppSettings(CONST Section: STRING; VAR CutAppSettings: RCutAppSettings);
    PROCEDURE WriteCutAppSettings(CONST Section: STRING; VAR CutAppSettings: RCutAppSettings);

    PROCEDURE WriteStrings(CONST section, name: STRING; CONST writeCount: boolean; CONST value: STRING); OVERLOAD;
    PROCEDURE WriteStrings(CONST section, name: STRING; CONST writeCount: boolean; CONST value: TStrings); OVERLOAD;

    PROCEDURE UpdateFile; OVERRIDE;

    FUNCTION GetDataString: STRING;

    PROCEDURE LoadFromStream(CONST Stream: TStream);
    PROCEDURE LoadFromString(CONST data: STRING);
    PROCEDURE SaveToStream(CONST Stream: TStream);
    PROCEDURE SaveToFile(CONST FileName: STRING);
  END;

PROCEDURE PatchINT3;

FUNCTION rand_string: STRING;
FUNCTION Get_File_Version(CONST FileName: STRING): STRING; overload;
FUNCTION Get_File_Version(CONST FileName: STRING; VAR FileVersionMS, FileVersionLS: DWORD): boolean; overload;
FUNCTION Application_version: STRING;
FUNCTION Application_Dir: STRING;
FUNCTION Application_File: STRING;
FUNCTION Application_Friendly_Name: STRING;
FUNCTION UploadData_Path(useCSV: boolean): STRING;
FUNCTION cleanURL(aURL: STRING): STRING;
FUNCTION cleanFileName(CONST filename: STRING): STRING;
PROCEDURE ListBoxToClipboard(ListBox: TListBox; BufferSizePerLine: Integer; CopyAll: Boolean);
FUNCTION STO_ShellExecute(CONST AppName, AppArgs: STRING; CONST Wait: Cardinal;
  CONST Hide: Boolean; VAR ExitCode: DWORD): Boolean;
FUNCTION STO_ShellExecute_Capture(CONST AppName, AppArgs: STRING; CONST Wait: Cardinal;
  CONST Hide: Boolean; VAR ExitCode: DWORD; AMemo: TMemo): Boolean;
FUNCTION CallApplication(AppPath, Command: STRING; VAR ErrorString: STRING): boolean;
FUNCTION secondsToTimeString(t: double): STRING;
FUNCTION fcc2String(fcc: DWord): STRING;
FUNCTION SaveBitmapAsJPEG(ABitmap: TBitmap; FileName: STRING): boolean;

FUNCTION IsPathRooted(CONST Path: STRING): boolean;

FUNCTION PathCombine(CONST aPath, otherPath: STRING): STRING;

FUNCTION CtrlDown: Boolean;
FUNCTION ShiftDown: Boolean;
FUNCTION AltDown: Boolean;

FUNCTION ValidRect(CONST ARect: TRect): boolean;

// Use in Create event of form to fix scaling when screen resolution changes.
PROCEDURE ScaleForm(CONST F: TForm); overload;
PROCEDURE ScaleForm(CONST F: TForm; CONST ScreenWidthDev, ScreenHeightDev: Integer); overload;

// Fix Borland QC Report 13832: Constraints don't obey form Scaled property
PROCEDURE AdjustFormConstraints(form: TForm);

//ini.ReadString does work only up to 2047 characters due to restrictions in iniFiles.pas
FUNCTION iniReadLargeString(
  CONST ini: TCustomIniFile;
  CONST BufferSize: integer;
  CONST section, name, default: STRING): STRING;

PROCEDURE ReadCutAppSettings(
  CONST ini: TCustomIniFile;
  CONST section: STRING;
  VAR CutAppSettings: RCutAppSettings);
PROCEDURE WriteCutAppSettings(
  CONST ini: TCustomIniFile;
  CONST section: STRING;
  VAR CutAppSettings: RCutAppSettings);

FUNCTION FilterInfoToString(CONST filterInfo: TFilCatNode): STRING;
FUNCTION StringToFilterGUID(CONST s: STRING): TGUID;

PROCEDURE ShowExpectedException(CONST Header: STRING);

FUNCTION iniReadRect(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST default: TRect): TRect;
PROCEDURE iniWriteRect(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST value: TRect);

PROCEDURE iniWriteStrings(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST writeCount: boolean; CONST value: STRING); overload;
PROCEDURE iniReadStrings(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST readCount: boolean; value: TStrings); overload;
PROCEDURE iniWriteStrings(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST writeCount: boolean; CONST value: TStrings); overload;

FUNCTION MakeFourCC(CONST a, b, c, d: char): DWord;

FUNCTION Parse_File_Version(CONST VersionStr: STRING): ARFileVersion;

FUNCTION FloatToStrInvariant(Value: Extended): STRING;

FUNCTION FilterStringFromExtArray(ExtArray: ARRAY OF STRING): STRING;
FUNCTION MakeFilterString(CONST description: STRING; CONST extensions: STRING): STRING;
FUNCTION AppendFilterString(CONST filter: STRING; CONST description: STRING; CONST extensions: STRING): STRING;

FUNCTION StrToFloatDefInv(CONST s: STRING; CONST d: extended; CONST sep: char = '.'): extended;

PROCEDURE GetInvariantFormatSettings(VAR FormatSettings: TFormatSettings);

TYPE
  RMediaSample = RECORD
    Active: Boolean;
    SampleTime: Double;
    IsKeyFrame: Boolean;
    HasBitmap: Boolean;
    Bitmap: TBitmap;
  END;

FUNCTION IntExt(CONST d: double; CONST fraction: double): double;

function GetVersionRequestParams: string;

IMPLEMENTATION

{$I jedi.inc}

USES
  Messages,
  Dialogs,
  ShellAPI,
  Variants,
  Clipbrd,
  StrUtils,
  jpeg,
  Types,
  DirectShow9,
  Math,
  IdUri,
  CAResources;


CONST ScreenWidthDev               = 1280;
  ScreenHeightDev                  = 1024;

VAR
  invariantFormat                  : TFormatSettings;

function GetVersionRequestParams: string;
begin
  Result := 'app=CutAssistant'
          + '&version=' + TIdURI.ParamsEncode(Application_Version);
end;

FUNCTION IntExt(CONST d: double; CONST fraction: double): double;
BEGIN
  Result := Trunc(d / fraction) * fraction;
END;

PROCEDURE GetInvariantFormatSettings(VAR FormatSettings: TFormatSettings);
BEGIN
  // init with zero, since GetLocaleFormatSettings does not fill all fields (QC 5880).
  FillChar(FormatSettings, SizeOf(FormatSettings), 0);
  // Initialize with english, since invariant culture does not work?
  //GetLocaleFormatSettings($007F, FormatSettings);
  GetLocaleFormatSettings(1033, FormatSettings);
END;

FUNCTION StrToFloatDefInv(CONST s: STRING; CONST d: extended; CONST sep: char): extended;
VAR
  Temp_DecimalSeparator            : char;
BEGIN
  Temp_DecimalSeparator := DecimalSeparator;
  DecimalSeparator := sep;
  TRY
    Result := StrToFloatDef(s, d);
  FINALLY
    DecimalSeparator := Temp_DecimalSeparator;
  END;
END;

FUNCTION AppendFilterString(CONST filter: STRING; CONST description: STRING; CONST extensions: STRING): STRING;
BEGIN
  Result := filter;
  IF filter <> '' THEN
    Result := Result + '|';
  Result := Result + MakeFilterString(description, extensions);
END;

FUNCTION MakeFilterString(CONST description: STRING; CONST extensions: STRING): STRING;
BEGIN
  Result := Format('%s (%s)|%s', [description, extensions, extensions]);
END;

FUNCTION FilterStringFromExtArray(ExtArray: ARRAY OF STRING): STRING;
VAR
  i                                : Integer;
BEGIN
  result := '';
  FOR i := 0 TO length(ExtArray) - 1 DO BEGIN
    IF i > 0 THEN result := result + ';';
    result := result + '*' + ExtArray[i];
  END;
END;

CONSTRUCTOR TMemIniFileEx.Create(CONST FileName: STRING);
BEGIN
  INHERITED Create(FileName);
  FVolatile := false;
  GetInvariantFormatSettings(self.FFormatSettings);
END;

CONSTRUCTOR TMemIniFileEx.Create(CONST FileName: STRING; CONST formatSettings: TFormatSettings);
BEGIN
  INHERITED Create(FileName);
  FVolatile := false;
  FFormatSettings := formatSettings;
END;

FUNCTION TMemIniFileEx.GetIsVolatile: boolean;
BEGIN
  Result := FVolatile OR (FileName = '');
END;

PROCEDURE TMemIniFileEx.UpdateFile;
BEGIN
  IF (NOT Volatile) AND (FileName <> '') THEN
    INHERITED UpdateFile;
END;

FUNCTION TMemIniFileEx.ReadFloat(CONST Section, Name: STRING; Default: Double): Double;
VAR
  FloatStr                         : STRING;
BEGIN
  FloatStr := ReadString(Section, Name, '');
  Result := Default;
  IF FloatStr <> '' THEN TRY
    Result := StrToFloat(FloatStr, FFormatSettings);
  EXCEPT
    ON EConvertError DO
      // Ignore EConvertError exceptions
  ELSE
    RAISE;
  END;
END;

FUNCTION TMemIniFileEx.ReadDate(CONST Section, Name: STRING; Default: TDateTime): TDateTime;
VAR
  DateStr                          : STRING;
BEGIN
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  IF DateStr <> '' THEN TRY
    Result := StrToDate(DateStr, FFormatSettings);
  EXCEPT
    ON EConvertError DO
      // Ignore EConvertError exceptions
  ELSE
    RAISE;
  END;
END;

FUNCTION TMemIniFileEx.ReadDateTime(CONST Section, Name: STRING; Default: TDateTime): TDateTime;
VAR
  DateStr                          : STRING;
BEGIN
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  IF DateStr <> '' THEN TRY
    Result := StrToDateTime(DateStr, FFormatSettings);
  EXCEPT
    ON EConvertError DO
      // Ignore EConvertError exceptions
  ELSE
    RAISE;
  END;
END;

FUNCTION TMemIniFileEx.ReadTime(CONST Section, Name: STRING; Default: TDateTime): TDateTime;
VAR
  TimeStr                          : STRING;
BEGIN
  TimeStr := ReadString(Section, Name, '');
  Result := Default;
  IF TimeStr <> '' THEN TRY
    Result := StrToTime(TimeStr, FFormatSettings);
  EXCEPT
    ON EConvertError DO
      // Ignore EConvertError exceptions
  ELSE
    RAISE;
  END;
END;

PROCEDURE TMemIniFileEx.WriteDate(CONST Section, Name: STRING; Value: TDateTime);
BEGIN
  WriteString(Section, Name, DateToStr(Value, FFormatSettings));
END;

PROCEDURE TMemIniFileEx.WriteDateTime(CONST Section, Name: STRING; Value: TDateTime);
BEGIN
  WriteString(Section, Name, DateTimeToStr(Value, FFormatSettings));
END;

PROCEDURE TMemIniFileEx.WriteFloat(CONST Section, Name: STRING; Value: Double);
BEGIN
  WriteString(Section, Name, FloatToStr(Value, FFormatSettings));
END;

PROCEDURE TMemIniFileEx.WriteTime(CONST Section, Name: STRING; Value: TDateTime);
BEGIN
  WriteString(Section, Name, TimeToStr(Value, FFormatSettings));
END;

FUNCTION TMemIniFileEx.ReadRect(CONST Section, Prefix: STRING; CONST Default: TRect): TRect;
BEGIN
  Result.Left := ReadInteger(Section, Prefix + '_Left', Default.Left);
  Result.Top := ReadInteger(Section, Prefix + '_Top', Default.Top);
  Result.Right := Result.Left + ReadInteger(Section, Prefix + '_Width', Default.Right - Default.Left);
  Result.Bottom := Result.Top + ReadInteger(Section, Prefix + '_Height', Default.Bottom - Default.Top);
END;

PROCEDURE TMemIniFileEx.WriteRect(CONST Section, Prefix: STRING; CONST Value: TRect);
BEGIN
  WriteInteger(Section, Prefix + '_Left', Value.Left);
  WriteInteger(Section, Prefix + '_Top', Value.Top);
  WriteInteger(Section, Prefix + '_Width', Value.Right - Value.Left);
  WriteInteger(Section, Prefix + '_Height', Value.Bottom - Value.Top);
END;

FUNCTION TMemIniFileEx.ReadGuid(CONST Section, Name: STRING; CONST Default: TGUID): TGUID;
VAR
  GuidStr                          : STRING;
BEGIN
  GuidStr := ReadString(Section, Name, '');
  Result := Default;
  IF GuidStr <> '' THEN TRY
    Result := StringToGUID(GuidStr);
  EXCEPT
    ON EConvertError DO
      // ignore EConvertError exceptions
  ELSE
    RAISE
  END;
END;

PROCEDURE TMemIniFileEx.WriteGuid(CONST Section, Name: STRING; CONST Value: TGUID);
BEGIN
  WriteString(Section, Name, GUIDToString(Value));
END;

PROCEDURE TMemIniFileEx.ReadCutAppSettings(CONST Section: STRING; VAR CutAppSettings: RCutAppSettings);
VAR
  BufferSize                       : integer;
BEGIN
  CutAppSettings.CutAppName := ReadString(Section, 'AppName', '');
  CutAppSettings.PreferredSourceFilter := ReadGuid(Section, 'PreferredSourceFilter', GUID_NULL);
  CutAppSettings.CodecName := ReadString(Section, 'CodecName', '');
  CutAppSettings.CodecFourCC := ReadInteger(Section, 'CodecFourCC', 0);
  CutAppSettings.CodecVersion := ReadInteger(Section, 'CodecVersion', 0);
  CutAppSettings.CodecSettingsSize := ReadInteger(Section, 'CodecSettingsSize', 0);
  CutAppSettings.CodecSettings := ReadString(Section, 'CodecSettings', '');

  BufferSize := CutAppSettings.CodecSettingsSize DIV 3;
  IF (CutAppSettings.CodecSettingsSize MOD 3) > 0 THEN
    Inc(BufferSize);
  BufferSize := BufferSize * 4 + 1; //+1 for terminating #0
  IF Length(CutAppSettings.CodecSettings) <> BufferSize - 1 THEN BEGIN
    CutAppSettings.CodecSettings := '';
    CutAppSettings.CodecSettingsSize := 0;
  END;
END;

PROCEDURE TMemIniFileEx.WriteCutAppSettings(CONST Section: STRING; VAR CutAppSettings: RCutAppSettings);
BEGIN
  EraseSection(Section);
  WriteString(Section, 'AppName', CutAppSettings.CutAppName);
  WriteGuid(Section, 'PreferredSourceFilter', CutAppSettings.PreferredSourceFilter);
  WriteString(Section, 'CodecName', CutAppSettings.CodecName);
  WriteInteger(Section, 'CodecFourCC', CutAppSettings.CodecFourCC);
  WriteInteger(Section, 'CodecVersion', CutAppSettings.CodecVersion);
  WriteInteger(Section, 'CodecSettingsSize', CutAppSettings.CodecSettingsSize);
  WriteString(Section, 'CodecSettings', CutAppSettings.CodecSettings);
END;

PROCEDURE TMemIniFileEx.WriteStrings(CONST section, name: STRING; CONST writeCount: boolean; CONST value: STRING);
VAR
  sl                               : TStringList;
BEGIN
  sl := TStringList.Create;
  TRY
    sl.Text := value;
    WriteStrings(section, name, writeCount, sl);
  FINALLY
    FreeAndNil(sl);
  END;
END;

PROCEDURE TMemIniFileEx.WriteStrings(CONST section, name: STRING; CONST writeCount: boolean; CONST value: TStrings);
VAR
  idx, cnt                         : integer;
BEGIN
  IF NOT Assigned(value) THEN cnt := 0
  ELSE cnt := value.Count;
  IF writeCount THEN
    WriteInteger(section, name + 'Count', cnt);
  FOR idx := 0 TO cnt - 1 DO BEGIN
    WriteString(section, name + IntToStr(idx + 1), value.Strings[idx]);
  END;
END;


FUNCTION TMemIniFileEx.GetDataString: STRING;
VAR
  List                             : TStringList;
BEGIN
  List := TStringList.Create;
  TRY
    GetStrings(List);
    Result := List.Text;
  FINALLY
    FreeAndNil(List);
  END;
END;

PROCEDURE TMemIniFileEx.LoadFromString(CONST data: STRING);
VAR
  List                             : TStringList;
BEGIN
  List := TStringList.Create;
  TRY
    List.Text := data;
    SetStrings(List);
  FINALLY
    FreeAndNil(List);
  END;
END;

PROCEDURE TMemIniFileEx.LoadFromStream(CONST Stream: TStream);
VAR
  List                             : TStringList;
BEGIN
  List := TStringList.Create;
  TRY
    List.LoadFromStream(Stream);
    SetStrings(List);
  FINALLY
    FreeAndNil(List);
  END;
END;

PROCEDURE TMemIniFileEx.SaveToStream(CONST Stream: TStream);
VAR
  List                             : TStringList;
BEGIN
  List := TStringList.Create;
  TRY
    GetStrings(List);
    List.SaveToStream(Stream);
  FINALLY
    FreeAndNil(List);
  END;
END;

PROCEDURE TMemIniFileEx.SaveToFile(CONST FileName: STRING);
VAR
  fs                               : TFileStream;
BEGIN
  fs := TFileStream.Create(FileName, fmCreate, fmShareDenyWrite);
  TRY
    SaveToStream(fs);
  FINALLY
    FreeAndNil(fs);
  END;
END;

FUNCTION FloatToStrInvariant(Value: Extended): STRING;
BEGIN
  Result := FloatToStr(Value, invariantFormat);
END;

FUNCTION Parse_File_Version(CONST VersionStr: STRING): ARFileVersion;
VAR
  s                                : STRING;
  FUNCTION NextWord(VAR s: STRING): integer;
  VAR
    delimPos                       : integer;
  BEGIN
    delimPos := Pos('.', s);
    IF delimPos > 0 THEN BEGIN
      Result := StrToIntDef(Copy(s, 1, delimPos - 1), -1);
      Delete(s, 1, delimPos);
    END
    ELSE BEGIN
      Result := 0;
    END;
  END;
BEGIN
  s := Copy(VersionStr, 1, MaxInt);
  Result[0] := NextWord(s);
  Result[1] := NextWord(s);
  Result[2] := NextWord(s);
  Result[3] := NextWord(s);
END;


PROCEDURE ShowExpectedException(CONST Header: STRING);
VAR
  msg                              : STRING;
BEGIN
  msg := '';
  WITH NewException(etNormal) DO BEGIN
    //    SuspendThreads := true;
    //    ShowCpuRegisters := false;
    //    ShowStackDump := false;
    //    CreateScreenShot := false;
    //    ShowSetting := ssDetailBox;
    //    SendBtnVisible := false;
    //    CloseBtnVisible := false;
    //    FocusedButton := bContinueApplication;

    IF Header <> '' THEN
      msg := Format(CAResources.RsExpectedErrorHeader, [Header]);

    ShowMessageFmt(CAResources.RsExpectedErrorFormat, [msg, ExceptClass, ExceptMessage]);
  END;
END;

FUNCTION iniReadRect(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST default: TRect): TRect;
BEGIN
  Result.Left := ini.ReadInteger(section, name + '_Left', default.Left);
  Result.Top := ini.ReadInteger(section, name + '_Top', default.Top);
  Result.Right := Result.Left + ini.ReadInteger(section, name + '_Width', default.Right - default.Left);
  Result.Bottom := Result.Top + ini.ReadInteger(section, name + '_Height', default.Bottom - default.Top);
END;

PROCEDURE iniWriteRect(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST value: TRect);
BEGIN
  ini.WriteInteger(section, name + '_Left', value.Left);
  ini.WriteInteger(section, name + '_Top', value.Top);
  ini.WriteInteger(section, name + '_Width', value.Right - value.Left);
  ini.WriteInteger(section, name + '_Height', value.Bottom - value.Top);
END;

PROCEDURE iniWriteStrings(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST writeCount: boolean; CONST value: STRING);
VAR
  sl                               : TStringList;
BEGIN
  sl := TStringList.Create;
  TRY
    sl.Text := value;
    iniWriteStrings(ini, section, name, writeCount, sl);
  FINALLY
    FreeAndNil(sl);
  END;
END;

PROCEDURE iniWriteStrings(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST writeCount: boolean; CONST value: TStrings);
VAR
  idx, cnt                         : integer;
BEGIN
  IF NOT Assigned(value) THEN cnt := 0
  ELSE cnt := value.Count;
  IF writeCount THEN
    ini.WriteInteger(section, name + 'Count', cnt);
  FOR idx := 0 TO cnt - 1 DO BEGIN
    ini.WriteString(section, name + IntToStr(idx + 1), value.Strings[idx]);
  END;
END;

PROCEDURE iniReadStrings(CONST ini: TCustomIniFile; CONST section, name: STRING; CONST readCount: boolean; value: TStrings); OVERLOAD;
VAR
  idx, cnt                         : integer;
BEGIN
  IF NOT Assigned(value) THEN exit;
  value.Clear;

  IF readCount THEN BEGIN
    cnt := ini.ReadInteger(section, name + 'Count', 0);
    FOR idx := 1 TO cnt - 1 DO
      value.Add(ini.ReadString(section, name + IntToStr(idx), ''));
  END ELSE BEGIN
    idx := 1;
    WHILE ini.ValueExists(section, name + IntToStr(idx)) DO BEGIN
      value.Add(ini.ReadString(section, name + IntToStr(idx), ''));
      Inc(idx);
    END;
  END;
END;

FUNCTION FilterInfoToString(CONST filterInfo: TFilCatNode): STRING;
BEGIN
  Result := filterInfo.FriendlyName + '  (' + GUIDToString(filterInfo.CLSID) + ')';
END;

FUNCTION StringToFilterGUID(CONST s: STRING): TGUID;
VAR
  idx, len                         : integer;
BEGIN
  idx := LastDelimiter('(', s) + 1;
  len := LastDelimiter(')', s);
  IF idx < 0 THEN Result := GUID_NULL
  ELSE BEGIN
    IF len <= idx THEN len := MaxInt;
    Result := StringToGUID(Copy(s, idx, len - idx))
  END;
END;

PROCEDURE WriteCutAppSettings(
  CONST ini: TCustomIniFile;
  CONST section: STRING;
  VAR CutAppSettings: RCutAppSettings);
BEGIN
  ini.WriteString(section, 'AppName', CutAppSettings.CutAppName);
  ini.WriteString(section, 'PreferredSourceFilter', GUIDToString(CutAppSettings.PreferredSourceFilter));
  ini.WriteString(section, 'CodecName', CutAppSettings.CodecName);
  ini.WriteInteger(section, 'CodecFourCC', CutAppSettings.CodecFourCC);
  ini.WriteInteger(section, 'CodecVersion', CutAppSettings.CodecVersion);
  ini.WriteInteger(section, 'CodecSettingsSize', CutAppSettings.CodecSettingsSize);
  ini.WriteString(section, 'CodecSettings', CutAppSettings.CodecSettings);
END;

PROCEDURE ReadCutAppSettings(
  CONST ini: TCustomIniFile;
  CONST section: STRING;
  VAR CutAppSettings: RCutAppSettings);
VAR
  StrValue                         : STRING;
  BufferSize                       : integer;
BEGIN
  IF NOT Assigned(ini) THEN exit;

  CutAppSettings.CutAppName := ini.ReadString(section, 'AppName', '');
  StrValue := ini.ReadString(section, 'PreferredSourceFilter', GUIDToString(GUID_NULL));
  TRY
    CutAppSettings.PreferredSourceFilter := StringToGUID(StrValue);
  EXCEPT
    ON EConvertError DO
      CutAppSettings.PreferredSourceFilter := GUID_NULL;
  END;
  CutAppSettings.CodecName := ini.ReadString(section, 'CodecName', '');
  CutAppSettings.CodecFourCC := ini.ReadInteger(section, 'CodecFourCC', 0);
  CutAppSettings.CodecVersion := ini.ReadInteger(section, 'CodecVersion', 0);
  CutAppSettings.CodecSettingsSize := ini.ReadInteger(section, 'CodecSettingsSize', 0);
  BufferSize := CutAppSettings.CodecSettingsSize DIV 3;
  IF (CutAppSettings.CodecSettingsSize MOD 3) > 0 THEN
    Inc(BufferSize);
  BufferSize := BufferSize * 4 + 1; //+1 for terminating #0
  CutAppSettings.CodecSettings := iniReadLargeString(ini, BufferSize, section, 'CodecSettings', '');
  IF Length(CutAppSettings.CodecSettings) <> BufferSize - 1 THEN BEGIN
    CutAppSettings.CodecSettings := '';
    CutAppSettings.CodecSettingsSize := 0;
  END;
END;

//ini.ReadString does work only up to 2047 characters due to restrictions in iniFiles.pas

FUNCTION iniReadLargeString(
  CONST ini: TCustomIniFile;
  CONST BufferSize: integer;
  CONST section, name, default: STRING): STRING;
VAR
  SizeRead                         : Integer;
  Buffer                           : PChar;
BEGIN
  GetMem(Buffer, BufferSize * SizeOf(Char));
  TRY
    SizeRead := GetPrivateProfileString(PChar(Section), PChar(name), PChar(default), Buffer, BufferSize, PChar(ini.FileName));
    IF (SizeRead >= 0) AND (SizeRead <= BufferSize - 1) THEN
      SetString(Result, Buffer, SizeRead)
    ELSE Result := default;
  FINALLY
    freemem(Buffer, BufferSize * SizeOf(Char));
  END;
END;

PROCEDURE ScaleForm(CONST F: TForm); OVERLOAD;
BEGIN
  ScaleForm(F, ScreenWidthDev, ScreenHeightDev);
END;

PROCEDURE AdjustFormConstraints(form: TForm);
{IFNDEF RTL180_UP}
VAR
  FormDPI, ScreenDPI               : integer;
  {IFEND}
BEGIN
  IF NOT Assigned(form) THEN
    exit;
  {IFNDEF RTL180_UP}
  IF NOT form.Scaled THEN
    exit;
  FormDPI := form.PixelsPerInch;
  ScreenDPI := Screen.PixelsPerInch;
  IF FormDPI <> ScreenDPI THEN
    WITH form.Constraints DO BEGIN
      MinHeight := (MinHeight * ScreenDPI) DIV FormDPI;
      MinWidth := (MinWidth * ScreenDPI) DIV FormDPI;
      MaxHeight := (MinHeight * ScreenDPI) DIV FormDPI;
      MaxWidth := (MinWidth * ScreenDPI) DIV FormDPI;
    END;
  {IFEND}
END;

PROCEDURE ScaleForm(CONST F: TForm; CONST ScreenWidthDev, ScreenHeightDev: Integer);
VAR
  x, y                             : Integer;
BEGIN
  IF NOT Assigned(F) THEN
    exit;
  F.Scaled := true;
  x := Screen.Width;
  y := Screen.Height;
  IF (x <> ScreenWidthDev) OR (y <> ScreenHeightDev) THEN BEGIN
    F.Height := (F.ClientHeight * y DIV ScreenHeightDev) + F.Height - F.ClientHeight;
    F.Width := (F.ClientWidth * y DIV ScreenWidthDev) + F.Width - F.ClientWidth;
    F.ScaleBy(x, ScreenWidthDev);
  END;
END;

CONSTRUCTOR THttpRequest.Create(CONST Url: STRING; CONST handleRedirects: boolean; CONST Error_message: STRING);
BEGIN
  self.FUrl := Url;
  self.FHandleRedirects := handleRedirects;
  self.FErrorMessage := Error_message;
  self.FPostData := PostData;
  self.FResponse := '';
  self.IsPostRequest := false;
END;

DESTRUCTOR THttpRequest.Destroy;
BEGIN
  IsPostRequest := false;
END;

PROCEDURE THttpRequest.SetIsPost(CONST value: boolean);
BEGIN
  self.FIsPost := value;
  IF NOT value AND Assigned(FPostData) THEN
    FreeAndNil(FPostData);
  IF value AND NOT Assigned(FPostData) THEN
    FPostData := TIdMultiPartFormDataStream.Create;
END;

FUNCTION ValidRect(CONST ARect: TRect): boolean;
BEGIN
  Result := (ARect.Left > -1)
    AND (ARect.Right > -1) AND (ARect.Right > ARect.Left)
    AND (ARect.Top > -1)
    AND (ARect.Bottom > -1) AND (ARect.Bottom > ARect.Top);
END;

FUNCTION PathCombine(CONST aPath, otherPath: STRING): STRING;
BEGIN
  Result := otherPath;
  IF IsPathDelimiter(Result, 1) THEN
    Delete(Result, 1, 1);
  Result := IncludeTrailingPathDelimiter(aPath) + Result;
END;

FUNCTION CtrlDown: Boolean;
VAR
  State                            : TKeyboardState;
BEGIN
  GetKeyboardState(State);
  Result := ((State[vk_Control] AND 128) <> 0);
END;

FUNCTION ShiftDown: Boolean;
VAR
  State                            : TKeyboardState;
BEGIN
  GetKeyboardState(State);
  Result := ((State[vk_Shift] AND 128) <> 0);
END;

FUNCTION AltDown: Boolean;
VAR
  State                            : TKeyboardState;
BEGIN
  GetKeyboardState(State);
  Result := ((State[vk_Menu] AND 128) <> 0);
END;

PROCEDURE PatchINT3;
{http://www.delphipraxis.net/topic24054.html
Es kann vorkommen, dass sich ein Programm einwandfrei kompillieren lässt,
jedoch beim Start aus Delphi nach einiger Zeit das CPU-Fenster geöffnet wird.
Dort steht dann häufig:

ntdll.DbgBreakPoint

Dies liegt daran, da Microsoft in manchen Dlls die Funktion ntdll.DbgBreakPoint
vergessen hat. Microsoft hat ein paar Dlls versehentlich mit Debug-Informationen
ausgeliefert, die noch Breakpoints enthalten, was der Debugger natürlich meldet.
Man muss in so einem Falle zur Laufzeit den Code patchen.

Aufruf in der initialization-section.
}
VAR
  NOP                              : Byte;
  NTDLL                            : THandle;
  BytesWritten                     : DWORD;
  Address                          : Pointer;
BEGIN
  IF Win32Platform <> VER_PLATFORM_WIN32_NT THEN Exit;
  NTDLL := GetModuleHandle('NTDLL.DLL');
  IF NTDLL = 0 THEN Exit;
  Address := GetProcAddress(NTDLL, 'DbgBreakPoint');
  IF Address = NIL THEN Exit;
  TRY
    IF Char(Address^) <> #$CC THEN Exit;

    NOP := $90;
    IF WriteProcessMemory(GetCurrentProcess, Address, @NOP, 1, BytesWritten) AND
      (BytesWritten = 1) THEN
      FlushInstructionCache(GetCurrentProcess, Address, 1);
  EXCEPT
    //Do not panic if you see an EAccessViolation here, it is perfectly harmless!
    ON EAccessViolation DO ;
  ELSE RAISE;
  END;
END;


FUNCTION rand_string: STRING;
VAR
  i                                : integer;
BEGIN
  result := '';
  FOR i := 0 TO 19 DO BEGIN
    result := result + inttohex(round(random(16)), 1);
  END;
END;

FUNCTION Get_File_Version(CONST FileName: STRING): STRING;
VAR
  dwFileVersionMS, dwFileVersionLS : DWORD;
BEGIN
  { If filename is not valid, return a string saying so and exit}
  IF NOT FileExists(FileName) THEN BEGIN
    result := Format(CAResources.RsErrorFileVersionFileNotFound, [FileName]);
    exit;
  END;

  Result := '';
  IF Get_File_Version(FileName, dwFileVersionMS, dwFileVersionLS) THEN BEGIN
    Result := IntToStr(HiWord(dwFileVersionMS));
    Result := Result + '.' + IntToStr(LoWord(dwFileVersionMS));
    Result := Result + '.' + IntToStr(HiWord(dwFileVersionLS));
    Result := Result + '.' + IntToStr(LoWord(dwFileVersionLS));
  END ELSE BEGIN
    Result := Format(CAResources.RsErrorFileVersionGetFileVersion, [FileName]);
  END;
END;

FUNCTION Get_File_Version(CONST FileName: STRING; VAR FileVersionMS, FileVersionLS: DWORD): boolean;
//True if successful
VAR
  VersionInfoSize, VersionInfoValueSize, Zero: DWord;
  VersionInfo, VersionInfoValue    : Pointer;
BEGIN
  result := false;
  IF NOT fileExists(filename) THEN BEGIN
    exit;
  END;
  {otherwise, let's go!}
   { Obtain size of version info structure }
  VersionInfoSize := GetFileVersionInfoSize(PChar(FileName), Zero);
  IF VersionInfoSize = 0 THEN exit;
  { Allocate memory for the version info structure }
  { This could raise an EOutOfMemory exception }
  GetMem(VersionInfo, VersionInfoSize);
  TRY
    IF GetFileVersionInfo(PChar(FileName), 0, VersionInfoSize, VersionInfo) AND VerQueryValue(VersionInfo, '\' { root block }, VersionInfoValue,
      VersionInfoValueSize) AND (0 <> LongInt(VersionInfoValueSize)) THEN BEGIN
      FileVersionMS := TVSFixedFileInfo(VersionInfoValue^).dwFileVersionMS;
      FileVersionLS := TVSFixedFileInfo(VersionInfoValue^).dwFileVersionLS;
      result := true;
    END; { then }
  FINALLY
    FreeMem(VersionInfo);
  END; { try }
END;

FUNCTION Application_version: STRING;
BEGIN
  Result := Get_File_Version(Application.ExeName);
END;

FUNCTION Application_Dir: STRING;
BEGIN
  result := includeTrailingPathDelimiter(extractFileDir(Application.ExeName));
END;

FUNCTION Application_File: STRING;
BEGIN
  result := ExtractFileName(Application.ExeName);
END;

FUNCTION Application_Friendly_Name: STRING;
BEGIN
  result := 'Cut Assistant V.' + Application_version;
END;

FUNCTION UploadData_Path(useCSV: boolean): STRING;
BEGIN
  result := Application_Dir + 'Upload' + IfThen(useCSV, '.CSV', '.XML');
END;

FUNCTION cleanURL(aURL: STRING): STRING;
VAR
  iChar                            : Integer;
  aChar                            : Char;
BEGIN
  result := '';
  FOR iChar := 1 TO length(aURL) DO BEGIN
    aChar := aURL[iChar];
    CASE aChar OF
      '0'..'9', 'A'..'Z', 'a'..'z', '$', '-', '+', '.': result := result + aChar;
    ELSE
      result := result + '%' + inttohex(ord(aChar), 2);
    END;
  END;
END;

FUNCTION cleanFileName(CONST filename: STRING): STRING;
CONST
  InvalidChars                     = '\/:*?<>|';
VAR
  i                                : integer;
  f, ch                            : STRING;
BEGIN
  f := filename;
  FOR i := 1 TO length(InvalidChars) DO BEGIN
    ch := midstr(InvalidChars, i, 1);
    f := AnsiReplaceText(f, ch, '_');
  END;
  result := f;
END;

FUNCTION IsPathRooted(CONST Path: STRING): boolean;
BEGIN
  IF ExtractFileDrive(Path) <> '' THEN
    Result := true
  ELSE
    Result := IsPathDelimiter(Path, 1);
END;


PROCEDURE ListBoxToClipboard(ListBox: TListBox;
  BufferSizePerLine: Integer;
  CopyAll: Boolean);
VAR
  Buffer                           : PChar;
  BufferSize                       : Integer;
  Ptr                              : PChar;
  I                                : Integer;
  Line                             : STRING[255];
  Count                            : Integer;
BEGIN
  IF NOT Assigned(ListBox) THEN
    Exit;
  BufferSize := BufferSizePerLine * ListBox.Items.Count;
  GetMem(Buffer, BufferSize);
  Ptr := Buffer;
  Count := 0;
  FOR I := 0 TO ListBox.Items.Count - 1 DO BEGIN
    Line := ListBox.Items.strings[I];
    IF NOT CopyAll AND ListBox.MultiSelect AND (NOT ListBox.Selected[I]) THEN
      Continue;
    { Check buffer overflow }
    Count := Count + Length(Line) + 3;
    IF Count >= BufferSize THEN
      Break;
    { Append to buffer }
    Move(Line[1], Ptr^, Length(Line));
    Ptr := Ptr + Length(Line);
    Ptr[0] := #13;
    Ptr[1] := #10;
    Ptr := Ptr + 2;
  END;
  Ptr[0] := #0;
  ClipBoard.SetTextBuf(Buffer);
  FreeMem(Buffer, BufferSize);
END;

////////////////////////////////////////////////////////////////
// AppName:  name (including path) of the application
// AppArgs:  command line arguments
// Wait:     0 = don't wait on application
//           >0 = wait until application has finished (maximum in milliseconds)
//           <0 = wait until application has started (maximum in milliseconds)
// Hide:     True = application runs invisible in the background
// ExitCode: exitcode of the application (only avaiable if Wait <> 0)
//

FUNCTION STO_ShellExecute(CONST AppName, AppArgs: STRING; CONST Wait: Cardinal;
  CONST Hide: Boolean; VAR ExitCode: DWORD): Boolean;
BEGIN
  result := STO_ShellExecute_Capture(AppName, AppArgs, Wait, Hide, ExitCode, NIL)
END;

FUNCTION STO_ShellExecute_Capture(CONST AppName, AppArgs: STRING; CONST Wait: Cardinal;
  CONST Hide: Boolean; VAR ExitCode: DWORD; AMemo: TMemo): Boolean;
CONST
  ReadBuffer                       = 2400;
VAR
  myStartupInfo                    : TStartupInfo;
  myProcessInfo                    : TProcessInformation;
  sAppName, sCommandline           : STRING;
  iWaitRes                         : Integer;

  Security                         : TSecurityAttributes;
  ReadPipe, WritePipe              : THandle;
  Buffer                           : Pchar;
  BytesRead                        : DWord;
BEGIN
  result := false;
  Buffer := NIL;
  IF Assigned(AMemo) THEN BEGIN
    WITH Security DO BEGIN
      nlength := SizeOf(TSecurityAttributes);
      binherithandle := true;
      lpsecuritydescriptor := NIL;
    END;
    IF NOT Createpipe(ReadPipe, WritePipe, @Security, 0) THEN exit;
    Buffer := AllocMem(ReadBuffer + 1);
  END;
  TRY
    // initialize the startupinfo
    FillChar(myStartupInfo, SizeOf(TStartupInfo), 0);
    myStartupInfo.cb := Sizeof(TStartupInfo);
    myStartupInfo.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    IF Hide THEN // hide application
      myStartupInfo.wShowWindow := SW_HIDE
    ELSE // show application
      myStartupInfo.wShowWindow := SW_SHOWNORMAL;

    // prepare applicationname
    sAppName := AppName;
    IF (Length(sAppName) > 0) AND (sAppName[1] <> '"') THEN
      sAppName := '"' + sAppName + '"';

    // start process
    ExitCode := 0;
    sCommandline := sAppName + ' ' + AppArgs;

    Result := CreateProcess(NIL, PAnsiChar(sCommandline), NIL, NIL, False,
      CREATE_NEW_CONSOLE OR NORMAL_PRIORITY_CLASS, NIL, NIL,
      myStartupInfo, myProcessInfo);

    // could process be started ?
    IF Result THEN BEGIN
      // wait on process ?
      IF (Wait <> 0) THEN BEGIN
        IF (Wait > 0) THEN // wait until process terminates
          iWaitRes := WaitForSingleObject(myProcessInfo.hProcess, Wait)
        ELSE // wait until process has been started
          iWaitRes := WaitForInputIdle(myProcessInfo.hProcess, Abs(Wait));
        // timeout reached ?
        IF iWaitRes = WAIT_TIMEOUT THEN BEGIN
          Result := False;
          TerminateProcess(myProcessInfo.hProcess, 1);
        END;
        // getexitcode
        GetExitCodeProcess(myProcessInfo.hProcess, ExitCode);
      END;
      IF Assigned(AMemo) THEN BEGIN
        REPEAT
          BytesRead := 0;
          ReadFile(ReadPipe, Buffer[0], ReadBuffer, BytesRead, NIL);
          Buffer[BytesRead] := #0;
          OemToAnsi(Buffer, Buffer);
          AMemo.Text := AMemo.text + STRING(Buffer);
        UNTIL (BytesRead < ReadBuffer);
        CloseHandle(ReadPipe);
        CloseHandle(WritePipe);
      END;
      CloseHandle(myProcessInfo.hProcess);
    END ELSE BEGIN
      RaiseLastOSError;
    END;
  FINALLY
    IF Assigned(AMemo) THEN FreeMem(Buffer);
  END;
END;

FUNCTION CallApplication(AppPath, Command: STRING; VAR ErrorString: STRING): boolean;
VAR
  return_value                     : cardinal;
  //m: string;
BEGIN
  return_value := shellexecute(Application.MainForm.Handle, 'open', pointer(AppPath), pointer(command), '', sw_shownormal);

  IF return_value <= 32 THEN BEGIN
    result := false;
    return_value := GetLastError;
    ErrorString := SysErrorMessage(return_value);
    {
        case return_value of
          0: m := 'The operating system is out of memory or resources.';
          //ERROR_FILE_NOT_FOUND: m := 'The specified file was not found.';    //not necessary, is the same as SE_ERR_FNF
          //ERROR_PATH_NOT_FOUND: m := 'The specified path was not found.';
          ERROR_BAD_FORMAT: m := 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
          SE_ERR_ACCESSDENIED: m := 'The operating system denied access to the specified file.';
          SE_ERR_ASSOCINCOMPLETE: m := 'The filename association is incomplete or invalid.';
          SE_ERR_DDEBUSY: m := 'The DDE transaction could not be completed because other DDE transactions were being processed.';
          SE_ERR_DDEFAIL: m := 'The DDE transaction failed.';
          SE_ERR_DDETIMEOUT: m := 'The DDE transaction could not be completed because the request timed out.';
          SE_ERR_DLLNOTFOUND: m := 'The specified dynamic-link library was not found.';
          SE_ERR_FNF: m := 'The specified file was not found.';
          SE_ERR_NOASSOC: m := 'There is no application associated with the given filename extension.';
          SE_ERR_OOM: m := 'There was not enough memory to complete the operation.';
          SE_ERR_PNF: m := 'The specified path was not found.';
          SE_ERR_SHARE: m := 'A sharing violation occurred.';
          else m:= 'Unknown Error.';
        end;
        ErrorString := m;
    }
  END ELSE BEGIN
    ErrorString := '';
    result := true;
  END;
END;

FUNCTION secondsToTimeString(t: double): STRING;
VAR
  h, m, s, ms                      : integer;
  sh, sm, ss, sms                  : STRING;
BEGIN
  t := RoundTo(t, -3);
  ms := Trunc(1000 * frac(t));
  s := trunc(t);
  m := trunc(s / 60);
  s := s MOD 60;
  h := trunc(m / 60);
  m := m MOD 60;

  sh := inttostr(h);
  sm := inttostr(m);
  ss := inttostr(s);
  sms := inttostr(ms);

  IF m < 10 THEN sm := '0' + sm;
  IF s < 10 THEN ss := '0' + ss;
  IF ms < 10 THEN
    sms := '00' + sms
  ELSE
    IF ms < 100 THEN sms := '0' + sms;

  result := sh + ':' + sm + ':' + ss + '.' + sms;
END;

FUNCTION fcc2String(fcc: DWord): STRING;
VAR
  Buffer                           : ARRAY[0..3] OF Char;
BEGIN
  Move(fcc, Buffer, SizeOf(Buffer));
  Result := Buffer;
END;

FUNCTION MakeFourCC(CONST a, b, c, d: char): DWord;
BEGIN
  Result := Cardinal(a)
    OR (Cardinal(b) SHL 8)
    OR (Cardinal(c) SHL 16)
    OR (Cardinal(d) SHL 24);
END;

FUNCTION SaveBitmapAsJPEG(ABitmap: TBitmap; FileName: STRING): boolean;
VAR
  tempJPEG                         : TJPEGImage;
BEGIN
  TempJPEG := TJPEGImage.Create;
  TRY
    TempJPEG.Assign(ABitmap);
    TempJPEG.SaveToFile(FileName);
    Result := true;
  FINALLY
    FreeAndNIL(TempJPEG);
  END;
END;

{ TGUIDList }

FUNCTION TGUIDList.Add(aGUID: TGUID): Integer;
BEGIN
  inc(FCount);
  setlength(FGUIDList, FCount);
  FGUIDList[FCount - 1] := aGUID;
  result := FCount - 1;
END;

FUNCTION TGUIDList.AddFromString(aGUIDString: STRING): Integer;
BEGIN
  result := Add(StringToGUID(aGUIDString));
END;

PROCEDURE TGUIDList.Clear;
BEGIN
  FCount := 0;
  setlength(FGUIDList, FCount);
END;

CONSTRUCTOR TGUIDList.Create;
BEGIN
  INHERITED;
  Clear;
END;

PROCEDURE TGUIDList.Delete(Item: TGUID);
VAR
  idx                              : integer;
BEGIN
  idx := IndexOf(Item);
  IF idx > -1 THEN
    Delete(idx);
END;

PROCEDURE TGUIDList.Delete(Index: Integer);
VAR
  i                                : Integer;
BEGIN
  FOR i := Index TO FCount - 2 DO BEGIN
    FGUIDList[i] := FGUIDList[i + 1];
  END;
  dec(FCount);
  setlength(FGUIDList, FCount);
END;

DESTRUCTOR TGUIDList.Destroy;
BEGIN
  Clear;
  INHERITED;
END;

FUNCTION TGUIDList.GetItem(Index: Integer): TGUID;
BEGIN
  result := FGUIDList[Index];
END;

FUNCTION TGUIDList.GetItemString(Index: Integer): STRING;
BEGIN
  result := GUIDToString(FGuidList[Index]);
END;

FUNCTION TGUIDList.IndexOf(aGUID: TGUID): Integer;
VAR
  i                                : integer;
BEGIN
  result := -1;
  FOR i := 0 TO FCount - 1 DO BEGIN
    IF IsEqualGUID(aGUID, FGUIDList[i]) THEN BEGIN
      result := i;
      break;
    END;
  END;
END;

FUNCTION TGUIDList.IndexOf(aGUIDString: STRING): Integer;
BEGIN
  result := IndexOf(StringToGUID(aGUIDString));
END;

FUNCTION TGUIDList.IsInList(aGUID: TGUID): boolean;
BEGIN
  result := IndexOf(aGUID) >= 0;
END;

FUNCTION TGUIDList.IsInList(aGUIDString: STRING): boolean;
BEGIN
  result := IsInList(StringToGUID(aGUIDString));
END;

PROCEDURE TGUIDList.SetItem(Index: Integer; CONST Value: TGUID);
BEGIN
  FGUIDList[Index] := Value;
END;

PROCEDURE TGUIDList.SetItemString(Index: Integer; CONST Value: STRING);
BEGIN
  FGUIDList[Index] := StringToGUID(Value);
END;

INITIALIZATION
  GetInvariantFormatSettings(invariantFormat);

  // nur wenn ein Debugger vorhanden, den Patch ausführen
  //if DebugHook<>0 then PatchINT3;

END.

