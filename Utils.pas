unit Utils;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.Windows, Winapi.MMSystem, System.Classes, System.SysUtils, System.IniFiles, Vcl.Forms, Vcl.StdCtrls,
  Vcl.Graphics, Vcl.Dialogs, Vcl.Controls,

  // DSPack
  DXSUtils,

  // Indy
  IdMultipartFormData;

const
  Application_name                 = 'Cut_assistant.exe'; //for use in cutlist files etc.

const // Multimedia key codes
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

// global Vars
var
  batchmode: Boolean;

type
  ARFileVersion = array[0 .. 3] of Word;

  RCutAppSettings = record
    CutAppName: string;
    PreferredSourceFilter: TGUID;
    CodecName: string;
    CodecFourCC: FOURCC;
    CodecVersion: DWORD;
    CodecSettingsSize: Integer;
    CodecSettings: string;
  end;

  THttpRequest = class(TObject)
  private
    FUrl: string;
    FHandleRedirects: Boolean;
    FResponse: string;
    FErrorMessage: string;
    FPostData: TIdMultiPartFormDataStream;
    FIsPost: Boolean;
  protected
    procedure SetIsPost(const Value: Boolean);
  public
    constructor Create(const Url: string; const handleRedirects: Boolean; const Error_message: string); overload;
    destructor Destroy; override;
    property IsPostRequest: Boolean read FIsPost write SetIsPost;
    property Url: string read FUrl write FUrl;
    property HandleRedirects: Boolean read FHandleRedirects write FHandleRedirects;
    property Response: string read FResponse write FResponse;
    property ErrorMessage: string read FErrorMessage write FErrorMessage;
    property PostData: TIdMultiPartFormDataStream read FPostData;
  end;

  { TGUIDList - A strong typed list for TGUID }

  TGUIDList = class
  private
    FGUIDList: array of TGUID;
    FCount: Integer;
    function GetItem(Index: Integer): TGUID;
    procedure SetItem(Index: Integer; const Value: TGUID);
    function GetItemString(Index: Integer): string;
    procedure SetItemString(Index: Integer; const Value: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property Item[Index: Integer]: TGUID read GetItem write SetItem; DEFAULT;
    property ItemString[Index: Integer]: string read GetItemString write SetItemString;
    procedure Clear;
    function Add(aGUID: TGUID): Integer;
    function AddFromString(aGUIDString: string): Integer;
    procedure Delete(Index: Integer); overload;
    procedure Delete(Item: TGUID); overload;
    function IndexOf(aGUID: TGUID): Integer; overload;
    function IndexOf(aGUIDString: string): Integer; overload;
    function IsInList(aGUID: TGUID): Boolean; overload;
    function IsInList(aGUIDString: string): Boolean; overload;
    property Count: Integer read FCount;
  end;

  { TMemIniFileEx - An enhanced version of TMemIniFile that has more
    strong typed read and write methods. if FileName is empty, the file
    will not get saved to disk. }

  TMemIniFileEx = class(TMemIniFile)
  private
    FFormatSettings: TFormatSettings;
    FVolatile: Boolean;
    function GetIsVolatile: Boolean;
  public
    constructor Create(const FileName: string); overload;
    constructor Create(const FileName: string; const formatSettings: TFormatSettings); overload;

    function ReadFloat(const Section, Name: string; Default: Double): Double; override;
    procedure WriteFloat(const Section, Name: string; Value: Double); override;

    function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime; override;
    procedure WriteDate(const Section, Name: string; Value: TDateTime); override;
    function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime; override;
    procedure WriteTime(const Section, Name: string; Value: TDateTime); override;
    function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime; override;
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime); override;

    function ReadRect(const Section, Prefix: string; const Default: TRect): TRect; virtual;
    procedure WriteRect(const Section, Prefix: string; const Value: TRect); virtual;

    function ReadGuid(const Section, Name: string; const Default: TGUID): TGUID; virtual;
    procedure WriteGuid(const Section, Name: string; const Value: TGUID); virtual;

    procedure ReadCutAppSettings(const Section: string; var CutAppSettings: RCutAppSettings);
    procedure WriteCutAppSettings(const Section: string; var CutAppSettings: RCutAppSettings);

    procedure WriteStrings(const section, name: string; const writeCount: Boolean; const value: string); overload;
    procedure WriteStrings(const section, name: string; const writeCount: Boolean; const value: TStrings); overload;

    procedure UpdateFile; override;

    function GetDataString: string;

    procedure LoadFromStream(const Stream: TStream);
    procedure LoadFromString(const data: string);
    procedure SaveToStream(const Stream: TStream);
    procedure SaveToFile(const FileName: string);

    property Volatile: Boolean read FVolatile write FVolatile DEFAULT False;
    property IsVolatile: Boolean read GetIsVolatile;
  end;

function rand_string: string;
function Get_File_Version(const FileName: string): string; overload;
function Get_File_Version(const FileName: string; var FileVersionMS, FileVersionLS: DWORD): Boolean; overload;
function Application_version: string;
function Application_Dir: string;
function Application_File: string;
function Application_Friendly_Name: string;
function UploadData_Path(useCSV: Boolean): string;
function cleanURL(aURL: string): string;
function cleanFileName(const FileName: string): string;
procedure ListBoxToClipboard(ListBox: TListBox; CopyAll: Boolean);
function STO_ShellExecute(const AppName, AppArgs: string; const Wait: Cardinal;
  const Hide: Boolean; var ExitCode: DWORD): Boolean;
function STO_ShellExecute_Capture(const AppName, AppArgs: string; const Wait: Cardinal;
  const Hide: Boolean; var ExitCode: DWORD; AMemo: TMemo): Boolean;
function CallApplication(AppPath, Command: string; var ErrorString: string): Boolean;
function secondsToTimeString(t: Double): string;
function fcc2String(fcc: DWORD): string;
function SaveBitmapAsJPEG(ABitmap: TBitmap; FileName: string): Boolean;

function IsPathRooted(const Path: string): Boolean;

function PathCombine(const aPath, otherPath: string): string;

function CtrlDown: Boolean;
function ShiftDown: Boolean;
function AltDown: Boolean;

function ValidRect(const ARect: TRect): Boolean;

// Use in Create event of form to fix scaling when screen resolution changes.
procedure ScaleForm(const F: TForm); overload;
procedure ScaleForm(const F: TForm; const ScreenWidthDev, ScreenHeightDev: Integer); overload;

// Fix Borland QC Report 13832: Constraints don't obey form Scaled property
procedure AdjustFormConstraints(form: TForm);

//ini.ReadString does work only up to 2047 characters due to restrictions in iniFiles.pas
function iniReadLargeString(
  const ini: TCustomIniFile;
  const BufferSize: Integer;
  const section, name, default: string): string;

procedure ReadCutAppSettings(
  const ini: TCustomIniFile;
  const section: string;
  var CutAppSettings: RCutAppSettings);
procedure WriteCutAppSettings(
  const ini: TCustomIniFile;
  const section: string;
  var CutAppSettings: RCutAppSettings);

function FilterInfoToString(const filterInfo: TFilCatNode; FillToLen: Integer = 0): string;
function StringToFilterGUID(const s: string): TGUID;

procedure ShowExpectedException(E: Exception; const Header: string);

function iniReadRect(const ini: TCustomIniFile; const section, name: string; const default: TRect): TRect;
procedure iniWriteRect(const ini: TCustomIniFile; const section, name: string; const value: TRect);

procedure iniWriteStrings(const ini: TCustomIniFile; const section, name: string; const writeCount: Boolean; const value: string); overload;
procedure iniReadStrings(const ini: TCustomIniFile; const section, name: string; const readCount: Boolean; value: TStrings); overload;
procedure iniWriteStrings(const ini: TCustomIniFile; const section, name: string; const writeCount: Boolean; const value: TStrings); overload;

function MakeFourCC(const a, b, c, d: Char): DWORD;

function Parse_File_Version(const VersionStr: string): ARFileVersion;

function FloatToStrInvariant(Value: Extended): string;

function FilterStringFromExtArray(ExtArray: array of string): string;
function MakeFilterString(const description: string; const extensions: string): string;
function AppendFilterString(const filter: string; const description: string; const extensions: string): string;

function StrToFloatDefInv(const s: string; const d: extended; const sep: Char = '.'): extended;

type
  RMediaSample = record
    Active: Boolean;
    SampleTime: Double;
    IsKeyFrame: Boolean;
    HasBitmap: Boolean;
    Bitmap: TBitmap;
  end;

function IntExt(const d: Double; const fraction: Double): Double;

function GetVersionRequestParams: string;

// func/proc from abc874

function ExtractBaseFileNameOTR(const S: string): string;
function FileNameToFormatName(const S: string): string;

function StringToken(var S: string; C: Char): string;

procedure ErrMsg(const S: string; ASuppress: Boolean = False);
procedure ErrMsgFmt(const S: string; const Args: array of const);

procedure InfMsg(const S: string; ASuppress: Boolean = False);
procedure InfMsgFmt(const S: string; const Args: array of const; ASuppress: Boolean = False);

procedure WarnMsg(const S: string);
procedure WarnMsgFmt(const S: string; const Args: array of const);

function YesNoMsg(const S: string): Boolean;
function YesNoMsgFmt(const S: string; const Args: array of const; ASuppress: Boolean = False): Boolean;

function YesNoWarnMsg(const S: string): Boolean;
function YesNoWarnMsgFmt(const S: string; const Args: array of const): Boolean;

function NoYesMsg(const S: string; ASuppress: Boolean = False): Boolean;
function NoYesMsgFmt(const S: string; const Args: array of const): Boolean;

function NoYesWarnMsg(const S: string): Boolean;
function NoYesWarnMsgFmt(const S: string; const Args: array of const): Boolean;

function YesNoCancelNamed(const Msg: string; const YesCaption: string = ''; const NoCaption: string = '';
  const CancelCaption: string = ''; DefaultButton: TMsgDlgBtn = mbCancel): TModalResult;

function CountLines(const Msg: string): Integer;

procedure CopyX264RegistrySettings(const ASrc, ADst: string);

implementation

uses
  // Delphi
  Winapi.Messages, Winapi.ShellAPI, Winapi.DirectShow9, System.Variants, System.StrUtils, System.Types, System.Math,
  System.UITypes, System.IOUtils, Vcl.Clipbrd, Vcl.Imaging.jpeg, Vcl.Consts, System.Win.Registry,

  // Indy
  IdUri,

  // CA
  CAResources, Settings_dialog, Main;

type
  TRegistryAcc = class(TRegistry);

const
  ScreenWidthDev  = 1280;
  ScreenHeightDev = 1024;

var
  invariantFormat: TFormatSettings;

function GetVersionRequestParams: string;
begin
  Result := 'app=CutAssistant&version=' + TIdURI.ParamsEncode(Application_Version);
end;

function IntExt(const d: Double; const fraction: Double): Double;
begin
  Result := Trunc(d / fraction) * fraction;
end;

function StrToFloatDefInv(const s: string; const d: extended; const sep: Char): extended;
var
  Temp_DecimalSeparator: Char;
begin
  Temp_DecimalSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := sep;
  try
    Result := StrToFloatDef(s, d);
  finally
    FormatSettings.DecimalSeparator := Temp_DecimalSeparator;
  end;
end;

function AppendFilterString(const filter: string; const description: string; const extensions: string): string;
begin
  Result := filter;
  if filter <> '' then
    Result := Result + '|';
  Result := Result + MakeFilterString(description, extensions);
end;

function MakeFilterString(const description: string; const extensions: string): string;
begin
  Result := Format('%s (%s)|%s', [description, extensions, extensions]);
end;

function FilterStringFromExtArray(ExtArray: array of string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Pred(Length(ExtArray)) do
  begin
    if I > 0 then
      Result := Result + ';';
    Result := Result + '*' + ExtArray[I];
  end;
end;

constructor TMemIniFileEx.Create(const FileName: string);
begin
  inherited Create(FileName, TEncoding.UTF8);
  FVolatile := False;
  FFormatSettings := invariantFormat;
end;

constructor TMemIniFileEx.Create(const FileName: string; const formatSettings: TFormatSettings);
begin
  inherited Create(FileName);
  FVolatile := False;
  FFormatSettings := formatSettings;
end;

function TMemIniFileEx.GetIsVolatile: Boolean;
begin
  Result := FVolatile or (FileName = '');
end;

procedure TMemIniFileEx.UpdateFile;
var
  List: TStringList;
begin
  if (not Volatile) and (FileName <> '') then
  begin
    // inherited UpdateFile;      writes BOM

    List := TStringList.Create;
    try
      GetStrings(List);
      List.WriteBOM := False;
      List.SaveToFile(FileName, Encoding);
    finally
      List.Free;
    end;
    Modified := False;
  end;
end;

function TMemIniFileEx.ReadFloat(const Section, Name: string; Default: Double): Double;
var
  FloatStr: string;
begin
  FloatStr := ReadString(Section, Name, '');
  Result := Default;
  if FloatStr <> '' then try
    Result := StrToFloat(FloatStr, FFormatSettings);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TMemIniFileEx.ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDate(DateStr, FFormatSettings);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TMemIniFileEx.ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDateTime(DateStr, FFormatSettings);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TMemIniFileEx.ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  TimeStr: string;
begin
  TimeStr := ReadString(Section, Name, '');
  Result := Default;
  if TimeStr <> '' then
  try
    Result := StrToTime(TimeStr, FFormatSettings);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

procedure TMemIniFileEx.WriteDate(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, DateToStr(Value, FFormatSettings));
end;

procedure TMemIniFileEx.WriteDateTime(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, DateTimeToStr(Value, FFormatSettings));
end;

procedure TMemIniFileEx.WriteFloat(const Section, Name: string; Value: Double);
begin
  WriteString(Section, Name, FloatToStr(Value, FFormatSettings));
end;

procedure TMemIniFileEx.WriteTime(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, TimeToStr(Value, FFormatSettings));
end;

function TMemIniFileEx.ReadRect(const Section, Prefix: string; const Default: TRect): TRect;
begin
  Result.Left   := ReadInteger(Section, Prefix + '_Left', Default.Left);
  Result.Top    := ReadInteger(Section, Prefix + '_Top', Default.Top);
  Result.Right  := Result.Left + ReadInteger(Section, Prefix + '_Width', Default.Right - Default.Left);
  Result.Bottom := Result.Top + ReadInteger(Section, Prefix + '_Height', Default.Bottom - Default.Top);
end;

procedure TMemIniFileEx.WriteRect(const Section, Prefix: string; const Value: TRect);
begin
  WriteInteger(Section, Prefix + '_Left', Value.Left);
  WriteInteger(Section, Prefix + '_Top', Value.Top);
  WriteInteger(Section, Prefix + '_Width', Value.Right - Value.Left);
  WriteInteger(Section, Prefix + '_Height', Value.Bottom - Value.Top);
end;

function TMemIniFileEx.ReadGuid(const Section, Name: string; const Default: TGUID): TGUID;
var
  GuidStr: string;
begin
  GuidStr := ReadString(Section, Name, '');
  Result := Default;
  if GuidStr <> '' then
  try
    Result := StringToGUID(GuidStr);
  except
    on EConvertError do
      // ignore EConvertError exceptions
    else
      raise
  end;
end;

procedure TMemIniFileEx.WriteGuid(const Section, Name: string; const Value: TGUID);
begin
  WriteString(Section, Name, GUIDToString(Value));
end;

procedure TMemIniFileEx.ReadCutAppSettings(const Section: string; var CutAppSettings: RCutAppSettings);
var
  BufferSize: Integer;
begin
  CutAppSettings.CutAppName := ReadString(Section, 'AppName', '');
  CutAppSettings.PreferredSourceFilter := ReadGuid(Section, 'PreferredSourceFilter', GUID_NULL);
  CutAppSettings.CodecName := ReadString(Section, 'CodecName', '');
  CutAppSettings.CodecFourCC := ReadInteger(Section, 'CodecFourCC', 0);
  CutAppSettings.CodecVersion := ReadInteger(Section, 'CodecVersion', 0);
  CutAppSettings.CodecSettingsSize := ReadInteger(Section, 'CodecSettingsSize', 0);
  CutAppSettings.CodecSettings := ReadString(Section, 'CodecSettings', '');

  BufferSize := CutAppSettings.CodecSettingsSize div 3;
  if (CutAppSettings.CodecSettingsSize mod 3) > 0 then
    Inc(BufferSize);
  BufferSize := BufferSize * 4 + 1; //+1 for terminating #0
  if Length(CutAppSettings.CodecSettings) <> BufferSize - 1 then
  begin
    CutAppSettings.CodecSettings := '';
    CutAppSettings.CodecSettingsSize := 0;
  end;
end;

procedure TMemIniFileEx.WriteCutAppSettings(const Section: string; var CutAppSettings: RCutAppSettings);
begin
  EraseSection(Section);
  WriteString(Section, 'AppName', CutAppSettings.CutAppName);
  WriteGuid(Section, 'PreferredSourceFilter', CutAppSettings.PreferredSourceFilter);
  WriteString(Section, 'CodecName', CutAppSettings.CodecName);
  WriteInteger(Section, 'CodecFourCC', CutAppSettings.CodecFourCC);
  WriteInteger(Section, 'CodecVersion', CutAppSettings.CodecVersion);
  WriteInteger(Section, 'CodecSettingsSize', CutAppSettings.CodecSettingsSize);
  WriteString(Section, 'CodecSettings', CutAppSettings.CodecSettings);
end;

procedure TMemIniFileEx.WriteStrings(const section, name: string; const writeCount: Boolean; const value: string);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := value;
    WriteStrings(section, name, writeCount, L);
  finally
    FreeAndNil(L);
  end;
end;

procedure TMemIniFileEx.WriteStrings(const section, name: string; const writeCount: Boolean; const value: TStrings);
var
  idx, cnt: Integer;
begin
  if Assigned(value) then
    cnt := value.Count
  else
    cnt := 0;

  if writeCount then
    WriteInteger(section, name + 'Count', cnt);

  for idx := 0 to Pred(cnt) do
    WriteString(section, name + IntToStr(idx + 1), value.Strings[idx]);
end;

function TMemIniFileEx.GetDataString: string;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetStrings(List);
    Result := List.Text;
  finally
    FreeAndNil(List);
  end;
end;

procedure TMemIniFileEx.LoadFromString(const data: string);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.Text := data;
    SetStrings(List);
  finally
    FreeAndNil(List);
  end;
end;

procedure TMemIniFileEx.LoadFromStream(const Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromStream(Stream, TEncoding.UTF8);
    SetStrings(List);
  finally
    FreeAndNil(List);
  end;
end;

procedure TMemIniFileEx.SaveToStream(const Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetStrings(List);
    List.WriteBOM := False;
    List.SaveToStream(Stream, TEncoding.UTF8);
  finally
    List.Free;
  end;
end;

procedure TMemIniFileEx.SaveToFile(const FileName: string);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(FileName, fmCreate, fmShareDenyWrite);
  try
    SaveToStream(fs);
  finally
    FreeAndNil(fs);
  end;
end;

function FloatToStrInvariant(Value: Extended): string;
begin
  Result := FloatToStr(Value, invariantFormat);
end;

function Parse_File_Version(const VersionStr: string): ARFileVersion;
var
  S : string;
  function NextWord(var S: string): Integer;
  var
    delimPos: Integer;
  begin
    delimPos := Pos('.', S);
    if delimPos > 0 then
    begin
      Result := StrToIntDef(Copy(S, 1, delimPos - 1), -1);
      Delete(S, 1, delimPos);
    end else
      Result := 0;
  end;
begin
  S := Copy(VersionStr, 1, MaxInt);
  Result[0] := NextWord(S);
  Result[1] := NextWord(S);
  Result[2] := NextWord(S);
  Result[3] := NextWord(S);
end;

procedure ShowExpectedException(E: Exception; const Header: string);
var
  msg: string;
begin
  msg := '';
  with E do
  begin
    //    SuspendThreads   := True;
    //    ShowCpuRegisters := False;
    //    ShowStackDump    := False;
    //    CreateScreenShot := False;
    //    ShowSetting      := ssDetailBox;
    //    SendBtnVisible   := False;
    //    CloseBtnVisible  := False;
    //    FocusedButton    := bContinueApplication;

    if Header <> '' then
      msg := Format(RsExpectedErrorHeader, [Header]);

    ErrMsg(Format(RsExpectedErrorFormat, [msg, E.ClassName, E.Message]));
  end;
end;

function iniReadRect(const ini: TCustomIniFile; const section, name: string; const default: TRect): TRect;
begin
  Result.Left   := ini.ReadInteger(section, name + '_Left', default.Left);
  Result.Top    := ini.ReadInteger(section, name + '_Top', default.Top);
  Result.Right  := Result.Left + ini.ReadInteger(section, name + '_Width', default.Right - default.Left);
  Result.Bottom := Result.Top + ini.ReadInteger(section, name + '_Height', default.Bottom - default.Top);
end;

procedure iniWriteRect(const ini: TCustomIniFile; const section, name: string; const value: TRect);
begin
  ini.WriteInteger(section, name + '_Left', value.Left);
  ini.WriteInteger(section, name + '_Top', value.Top);
  ini.WriteInteger(section, name + '_Width', value.Right - value.Left);
  ini.WriteInteger(section, name + '_Height', value.Bottom - value.Top);
end;

procedure iniWriteStrings(const ini: TCustomIniFile; const section, name: string; const writeCount: Boolean; const value: string);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := value;
    iniWriteStrings(ini, section, name, writeCount, L);
  finally
    FreeAndNil(L);
  end;
end;

procedure iniWriteStrings(const ini: TCustomIniFile; const section, name: string; const writeCount: Boolean; const value: TStrings);
var
  idx, cnt: Integer;
begin
  if Assigned(value) then
    cnt := value.Count
  else
    cnt := 0;

  if writeCount then
    ini.WriteInteger(section, name + 'Count', cnt);

  for idx := 0 to Pred(cnt) do
    ini.WriteString(section, name + IntToStr(idx + 1), value.Strings[idx]);
end;

procedure iniReadStrings(const ini: TCustomIniFile; const section, name: string; const readCount: Boolean; value: TStrings); overload;
var
  idx, cnt: Integer;
begin
  if Assigned(value) then
  begin
    value.Clear;

    if readCount then
    begin
      cnt := ini.ReadInteger(section, name + 'Count', 0);
      for idx := 1 to cnt - 1 do
        value.Add(ini.ReadString(section, name + IntToStr(idx), ''));
    end else
    begin
      idx := 1;
      while ini.ValueExists(section, name + IntToStr(idx)) do
      begin
        value.Add(ini.ReadString(section, name + IntToStr(idx), ''));
        Inc(idx);
      end;
    end;
  end;
end;

function FilterInfoToString(const filterInfo: TFilCatNode; FillToLen: Integer = 0): string;
var
  S: string;
begin
  if FillToLen > 0 then
    S := StringOfChar(' ', FillToLen - Length(filterInfo.FriendlyName))
  else
    S := '';

  Result := filterInfo.FriendlyName + S + '  (' + GUIDToString(filterInfo.CLSID) + ')';
end;

function StringToFilterGUID(const s: string): TGUID;
var
  L,R: Integer;
begin
  L := LastDelimiter('(', s);
  R := LastDelimiter(')', s);
  if L > 0 then
    Result := StringToGUID(Copy(s, Succ(L), IfThen(R > L, Pred(R - L), Length(s) - L)))
  else
    Result := GUID_NULL
end;

procedure WriteCutAppSettings(const ini: TCustomIniFile; const section: string; var CutAppSettings: RCutAppSettings);
begin
  ini.WriteString(section, 'AppName', CutAppSettings.CutAppName);
  ini.WriteString(section, 'PreferredSourceFilter', GUIDToString(CutAppSettings.PreferredSourceFilter));
  ini.WriteString(section, 'CodecName', CutAppSettings.CodecName);
  ini.WriteInteger(section, 'CodecFourCC', CutAppSettings.CodecFourCC);
  ini.WriteInteger(section, 'CodecVersion', CutAppSettings.CodecVersion);
  ini.WriteInteger(section, 'CodecSettingsSize', CutAppSettings.CodecSettingsSize);
  ini.WriteString(section, 'CodecSettings', CutAppSettings.CodecSettings);
end;

procedure ReadCutAppSettings(const ini: TCustomIniFile; const section: string; var CutAppSettings: RCutAppSettings);
var
  StrValue: string;
  BufferSize: Integer;
begin
  if Assigned(ini) then
  begin
    CutAppSettings.CutAppName := ini.ReadString(section, 'AppName', '');
    StrValue := ini.ReadString(section, 'PreferredSourceFilter', GUIDToString(GUID_NULL));
    try
      CutAppSettings.PreferredSourceFilter := StringToGUID(StrValue);
    except
      on EConvertError do
        CutAppSettings.PreferredSourceFilter := GUID_NULL;
    end;
    CutAppSettings.CodecName := ini.ReadString(section, 'CodecName', '');
    CutAppSettings.CodecFourCC := ini.ReadInteger(section, 'CodecFourCC', 0);
    CutAppSettings.CodecVersion := ini.ReadInteger(section, 'CodecVersion', 0);
    CutAppSettings.CodecSettingsSize := ini.ReadInteger(section, 'CodecSettingsSize', 0);
    BufferSize := CutAppSettings.CodecSettingsSize div 3;
    if (CutAppSettings.CodecSettingsSize mod 3) > 0 then
      Inc(BufferSize);
    BufferSize := BufferSize * 4 + 1; //+1 for terminating #0
    CutAppSettings.CodecSettings := iniReadLargeString(ini, BufferSize, section, 'CodecSettings', '');
    if Length(CutAppSettings.CodecSettings) <> BufferSize - 1 then
    begin
      CutAppSettings.CodecSettings := '';
      CutAppSettings.CodecSettingsSize := 0;
    end;
  end;
end;

//ini.ReadString does work only up to 2047 characters due to restrictions in iniFiles.pas

function iniReadLargeString(const ini: TCustomIniFile; const BufferSize: Integer; const section, name, default: string): string;
var
  SizeRead: Integer;
  Buffer: PChar;
begin
  GetMem(Buffer, BufferSize * SizeOf(Char));
  try
    SizeRead := GetPrivateProfileString(PChar(Section), PChar(name), PChar(default), Buffer, BufferSize, PChar(ini.FileName));
    if (SizeRead >= 0) and (SizeRead <= BufferSize - 1) then
      SetString(Result, Buffer, SizeRead)
    else
      Result := default;
  finally
    freemem(Buffer, BufferSize * SizeOf(Char));
  end;
end;

procedure ScaleForm(const F: TForm); overload;
begin
  ScaleForm(F, ScreenWidthDev, ScreenHeightDev);
end;

procedure AdjustFormConstraints(form: TForm);
{$if compilerversion < 18}
var
  FormDPI, ScreenDPI: Integer;
{$IFEND}
begin
  if Assigned(form) then
  begin
    {$if compilerversion < 18}
    if form.Scaled then
    begin
      FormDPI := form.PixelsPerInch;
      ScreenDPI := Screen.PixelsPerInch;
      if FormDPI <> ScreenDPI then
        with form.Constraints do
        begin
          MinHeight := (MinHeight * ScreenDPI) div FormDPI;
          MinWidth := (MinWidth * ScreenDPI) div FormDPI;
          MaxHeight := (MinHeight * ScreenDPI) div FormDPI;
          MaxWidth := (MinWidth * ScreenDPI) div FormDPI;
        end;
    end;
    {$IFEND}
  end;
end;

procedure ScaleForm(const F: TForm; const ScreenWidthDev, ScreenHeightDev: Integer);
var
  x, y: Integer;
begin
  if Assigned(F) then
  begin
    F.Scaled := True;
    x := Screen.Width;
    y := Screen.Height;
    if (x <> ScreenWidthDev) or (y <> ScreenHeightDev) then
    begin
      F.Height := (F.ClientHeight * y div ScreenHeightDev) + F.Height - F.ClientHeight;
      F.Width  := (F.ClientWidth * y div ScreenWidthDev) + F.Width - F.ClientWidth;
      F.ScaleBy(x, ScreenWidthDev);
    end;
  end;
end;

constructor THttpRequest.Create(const Url: string; const handleRedirects: Boolean; const Error_message: string);
begin
  FUrl             := Url;
  FHandleRedirects := handleRedirects;
  FErrorMessage    := Error_message;
  FPostData        := PostData;
  FResponse        := '';
  IsPostRequest    := False;
end;

destructor THttpRequest.Destroy;
begin
  IsPostRequest := False;
end;

procedure THttpRequest.SetIsPost(const Value: Boolean);
begin
  FIsPost := Value;
  if not Value and Assigned(FPostData) then
    FreeAndNil(FPostData);
  if Value and not Assigned(FPostData) then
    FPostData := TIdMultiPartFormDataStream.Create;
end;

function ValidRect(const ARect: TRect): Boolean;
begin
  Result := (ARect.Left > -1) and (ARect.Right > ARect.Left) and (ARect.Top > -1) and (ARect.Bottom > ARect.Top);
end;

function PathCombine(const aPath, otherPath: string): string;
begin
  Result := otherPath;
  if IsPathDelimiter(Result, 1) then
    Delete(Result, 1, 1);
  Result := IncludeTrailingPathDelimiter(aPath) + Result;
end;

function CtrlDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Control] and 128) <> 0);
end;

function ShiftDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Shift] and 128) <> 0);
end;

function AltDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[vk_Menu] and 128) <> 0);
end;

function rand_string: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to 19 do begin
    Result := Result + IntToHex(Round(random(16)), 1);
  end;
end;

function Get_File_Version(const FileName: string): string;
var
  dwFileVersionMS, dwFileVersionLS : DWORD;
begin
  { if FileName is not valid, return a string saying so and Exit}
  if FileExists(FileName) then
  begin
    Result := '';
    if Get_File_Version(FileName, dwFileVersionMS, dwFileVersionLS) then
      Result := Format('%d.%d.%d.%d', [HiWord(dwFileVersionMS), LoWord(dwFileVersionMS), HiWord(dwFileVersionLS), LoWord(dwFileVersionLS)])
    else
      Result := Format(RsErrorFileVersionGetFileVersion, [FileName]);
  end else
    Result := Format(RsErrorFileVersionFileNotFound, [FileName]);
end;

function Get_File_Version(const FileName: string; var FileVersionMS, FileVersionLS: DWORD): Boolean; //True if successful
var
  VersionInfoSize, VersionInfoValueSize, Zero: DWORD;
  VersionInfo, VersionInfoValue: Pointer;
begin
  Result := False;
  if FileExists(FileName) then
  begin
    { Obtain size of version info structure }
    VersionInfoSize := GetFileVersionInfoSize(PChar(FileName), Zero);
    if VersionInfoSize > 0 then
    begin
      { Allocate memory for the version info structure }
      { This could raise an EOutOfMemory exception }
      GetMem(VersionInfo, VersionInfoSize);
      try
        if GetFileVersionInfo(PChar(FileName), 0, VersionInfoSize, VersionInfo) and VerQueryValue(VersionInfo, '\' { root block }, VersionInfoValue,
          VersionInfoValueSize) and (0 <> LongInt(VersionInfoValueSize)) then begin
          FileVersionMS := TVSFixedFileInfo(VersionInfoValue^).dwFileVersionMS;
          FileVersionLS := TVSFixedFileInfo(VersionInfoValue^).dwFileVersionLS;
          Result := True;
        end; { then }
      finally
        FreeMem(VersionInfo);
      end; { try }
    end;
  end;
end;

function Application_version: string;
begin
  Result := Get_File_Version(Application.ExeName);
end;

function Application_Dir: string;
begin
  Result := includeTrailingPathDelimiter(extractFileDir(Application.ExeName));
end;

function Application_File: string;
begin
  Result := ExtractFileName(Application.ExeName);
end;

function Application_Friendly_Name: string;
begin
  Result := 'Cut Assistant V.' + Application_version;
end;

function UploadData_Path(useCSV: Boolean): string;
begin
  Result := Application_Dir + 'Upload' + IfThen(useCSV, '.CSV', '.XML');
end;

function cleanURL(aURL: string): string;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 1 to Length(aURL) do
  begin
    C := aURL[I];
    if CharInSet(C, ['0'..'9', 'A'..'Z', 'a'..'z', '$', '-', '+', '.']) then
      Result := Result + C
    else
      Result := Result + '%' + IntToHex(Ord(C), 2);
  end;
end;

function cleanFileName(const FileName: string): string;
var
  I: Integer;
begin
  Result := FileName;

  for I := 1 to Length(Result) do
    if not TPath.IsValidFileNameChar(Result[I]) then
      Result[I] := '_';
end;

function IsPathRooted(const Path: string): Boolean;
begin
  if ExtractFileDrive(Path) <> '' then
    Result := True
  else
    Result := IsPathDelimiter(Path, 1);
end;

procedure ListBoxToClipboard(ListBox: TListBox; CopyAll: Boolean);
var
  S: string;
  I: Integer;
begin
  if Assigned(ListBox) then
  begin
    for I := 0 to Pred(ListBox.Items.Count) do
      if CopyAll or ListBox.Selected[I] then
        S := S + ListBox.Items[I] + sLineBreak;

    ClipBoard.AsText := S;
  end;
end;

////////////////////////////////////////////////////////////////
// AppName:  name (including path) of the application
// AppArgs:  command line arguments
// Wait:     0 = don't wait on application
//           >0 = wait until application has finished (maximum in milliseconds)
//           <0 = wait until application has started (maximum in milliseconds)
// Hide:     True = application runs invisible in the background
// ExitCode: exitcode of the application (only avaiable if Wait <> 0)
//

function STO_ShellExecute(const AppName, AppArgs: string; const Wait: Cardinal; const Hide: Boolean; var ExitCode: DWORD): Boolean;
begin
  Result := STO_ShellExecute_Capture(AppName, AppArgs, Wait, Hide, ExitCode, nil);
end;

function STO_ShellExecute_Capture(const AppName, AppArgs: string; const Wait: Cardinal; const Hide: Boolean; var ExitCode: DWORD; AMemo: TMemo): Boolean;
const
  ReadBuffer = 2400;
var
  myStartupInfo: TStartupInfo;
  myProcessInfo: TProcessInformation;
  sAppName, sCommandline: string;
  iWaitRes: Integer;
  Security: TSecurityAttributes;
  ReadPipe, WritePipe: THandle;
  Buffer: PChar;
  BytesRead: DWORD;
begin
  Result := False;
  Buffer := nil;
  if Assigned(AMemo) then
  begin
    with Security do
    begin
      nlength := SizeOf(TSecurityAttributes);
      binherithandle := True;
      lpsecuritydescriptor := nil;
    end;
    if not Createpipe(ReadPipe, WritePipe, @Security, 0) then Exit;
    Buffer := AllocMem(ReadBuffer + 1);
  end;
  try
    // initialize the startupinfo
    FillChar(myStartupInfo, SizeOf(TStartupInfo), 0);
    myStartupInfo.cb := SizeOf(TStartupInfo);
    myStartupInfo.dwFlags := STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    if Hide then // hide application
      myStartupInfo.wShowWindow := SW_HIDE
    else // show application
      myStartupInfo.wShowWindow := SW_SHOWNORMAL;

    // prepare applicationname
    sAppName := AppName;
    if (Length(sAppName) > 0) and (sAppName[1] <> '"') then
      sAppName := '"' + sAppName + '"';

    // start process
    ExitCode := 0;
    sCommandline := sAppName + ' ' + AppArgs;

    Result := CreateProcess(nil, PChar(sCommandline), nil, nil, False,
      CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, myStartupInfo, myProcessInfo);

    // could process be started ?
    if Result then
    begin
      // wait on process ?
      if (Wait <> 0) then
      begin
        if (Wait > 0) then // wait until process terminates
          iWaitRes := WaitForSingleObject(myProcessInfo.hProcess, Wait)
        else // wait until process has been started
          iWaitRes := WaitForInputIdle(myProcessInfo.hProcess, Abs(Wait));
        // timeout reached ?
        if iWaitRes = WAIT_TIMEOUT then begin
          Result := False;
          TerminateProcess(myProcessInfo.hProcess, 1);
        end;
        // getexitcode
        GetExitCodeProcess(myProcessInfo.hProcess, ExitCode);
      end;
      if Assigned(AMemo) then
      begin
        repeat
          BytesRead := 0;
          ReadFile(ReadPipe, Buffer[0], ReadBuffer, BytesRead, nil);
          Buffer[BytesRead] := #0;
          // OemToAnsi(Buffer, Buffer);    no more needed?

          AMemo.Text := AMemo.text + string(Buffer);
        until (BytesRead < ReadBuffer);
        CloseHandle(ReadPipe);
        CloseHandle(WritePipe);
      end;
      CloseHandle(myProcessInfo.hProcess);
    end else begin
      RaiseLastOSError;
    end;
  finally
    if Assigned(AMemo) then FreeMem(Buffer);
  end;
end;

function CallApplication(AppPath, Command: string; var ErrorString: string): Boolean;
var
  return_value: Cardinal;
begin
  return_value := shellexecute(Application.MainForm.Handle, 'open', Pointer(AppPath), Pointer(command), '', sw_shownormal);

  if return_value <= 32 then
  begin
    Result := False;
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
  end else
  begin
    ErrorString := '';
    Result := True;
  end;
end;

function secondsToTimeString(t: Double): string;
begin
  Result := FormatDateTime('hh:nn:ss,zzz', (t * 1000) / MSecsPerDay);
end;

function fcc2String(fcc: DWORD): string;
var
  Buffer: array[0 .. 3] of Byte;
begin
  Move(fcc, Buffer, SizeOf(Buffer));
  Result := Chr(Buffer[0]) + Chr(Buffer[1]) + Chr(Buffer[2]) + Chr(Buffer[3]);
end;

function MakeFourCC(const a, b, c, d: Char): DWORD;
begin
  Result := Cardinal(a) or (Cardinal(b) shl 8) or (Cardinal(c) shl 16) or (Cardinal(d) shl 24);
end;

function SaveBitmapAsJPEG(ABitmap: TBitmap; FileName: string): Boolean;
var
  tempJPEG: TJPEGImage;
begin
  TempJPEG := TJPEGImage.Create;
  try
    TempJPEG.Assign(ABitmap);
    TempJPEG.SaveToFile(FileName);
    Result := True;
  finally
    FreeAndNil(TempJPEG);
  end;
end;

{ TGUIDList }

function TGUIDList.Add(aGUID: TGUID): Integer;
begin
  Inc(FCount);
  SetLength(FGUIDList, FCount);
  FGUIDList[Pred(FCount)] := aGUID;
  Result := Pred(FCount);
end;

function TGUIDList.AddFromString(aGUIDString: string): Integer;
begin
  Result := Add(StringToGUID(aGUIDString));
end;

procedure TGUIDList.Clear;
begin
  FCount := 0;
  SetLength(FGUIDList, FCount);
end;

constructor TGUIDList.Create;
begin
  inherited;
  Clear;
end;

procedure TGUIDList.Delete(Item: TGUID);
var
  I: Integer;
begin
  I := IndexOf(Item);
  if I > -1 then
    Delete(I);
end;

procedure TGUIDList.Delete(Index: Integer);
var
  I: Integer;
begin
  for I := Index to FCount - 2 do
    FGUIDList[I] := FGUIDList[I + 1];

  Dec(FCount);
  SetLength(FGUIDList, FCount);
end;

destructor TGUIDList.Destroy;
begin
  Clear;
  inherited;
end;

function TGUIDList.GetItem(Index: Integer): TGUID;
begin
  Result := FGUIDList[Index];
end;

function TGUIDList.GetItemString(Index: Integer): string;
begin
  Result := GUIDToString(FGuidList[Index]);
end;

function TGUIDList.IndexOf(aGUID: TGUID): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FCount) do
  begin
    if IsEqualGUID(aGUID, FGUIDList[I]) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TGUIDList.IndexOf(aGUIDString: string): Integer;
begin
  Result := IndexOf(StringToGUID(aGUIDString));
end;

function TGUIDList.IsInList(aGUID: TGUID): Boolean;
begin
  Result := IndexOf(aGUID) >= 0;
end;

function TGUIDList.IsInList(aGUIDString: string): Boolean;
begin
  Result := IsInList(StringToGUID(aGUIDString));
end;

procedure TGUIDList.SetItem(Index: Integer; const Value: TGUID);
begin
  FGUIDList[Index] := Value;
end;

procedure TGUIDList.SetItemString(Index: Integer; const Value: string);
begin
  FGUIDList[Index] := StringToGUID(Value);
end;

// func/proc from abc874

function ExtractBaseFileNameOTR(const S: string): string;
var
  I: Integer;
begin
  Result := ExtractFileName(S);

  I := Pos('.MPG.', AnsiUpperCase(Result));

  if I > 0 then
    SetLength(Result, Pred(I));
end;

function FileNameToFormatName(const S: string): string;
const
  C = '.cutlist';
var
  I: Integer;
  E: string;
begin
  Result := '?';

  I := Pos('.MPG.', AnsiUpperCase(S));

  if I > 0 then
  begin
    E := S;
    Delete(E, 1, I);

    if E.EndsWith(C, True) then
      SetLength(E, Length(E) - Length(C));

    case IndexText(E, ['mpg.avi', 'mpg.HD.avi', 'mpg.HQ.avi', 'mpg.mp4']) of
      0 : Result := 'DivX';
      1 : Result := 'HD';
      2 : Result := 'HQ';
      3 : Result := 'MP4';
    end;
  end;
end;

function StringToken(var S: string; C: Char): string;
var
  I: Integer;
begin
  I := Pos(C, S);
  if I > 0 then
  begin
    Result := Copy(S, 1, Pred(I));
    Delete(S, 1, I);
  end else
  begin
    Result := S;
    S := '';
  end;
end;

procedure ErrMsg(const S: string; ASuppress: Boolean = False);
begin
  if ASuppress then
    FMain.ShowNotifyMsg(SMsgDlgError, S)
  else
    MessageDlg(S, mtError, [mbOK], 0)
end;

procedure ErrMsgFmt(const S: string; const Args: array of const);
begin
  ErrMsg(Format(S, Args));
end;

procedure InfMsg(const S: string; ASuppress: Boolean = False);
begin
  if ASuppress then
    FMain.ShowNotifyMsg(SMsgDlgInformation, S)
  else
    MessageDlg(S, mtInformation, [mbOK], 0);
end;

procedure InfMsgFmt(const S: string; const Args: array of const; ASuppress: Boolean = False);
begin
  InfMsg(Format(S, Args), ASuppress);
end;

procedure WarnMsg(const S: string);
begin
  MessageDlg(S, mtWarning, [mbOK], 0);
end;

procedure WarnMsgFmt(const S: string; const Args: array of const);
begin
  WarnMsg(Format(S, Args));
end;

function YesNoMsg(const S: string): Boolean;
begin
  Result := MessageDlg(S, mtConfirmation, mbYesNo, 0) = mrYes;
end;

function YesNoMsgFmt(const S: string; const Args: array of const; ASuppress: Boolean = False): Boolean;
begin
  if ASuppress then
  begin
    FMain.ShowNotifyMsg(SMsgDlgConfirm, Format(S, Args));
    Result := True;
  end else
    Result := YesNoMsg(Format(S, Args));
end;

function NoYesMsg(const S: string; ASuppress: Boolean = False): Boolean;
begin
  if ASuppress then
  begin
    FMain.ShowNotifyMsg(SMsgDlgConfirm, S);
    Result := True;
  end else
    Result := MessageDlg(S, mtConfirmation, mbYesNo, 0, mbNo) = mrYes;
end;

function NoYesMsgFmt(const S: string; const Args: array of const): Boolean;
begin
  Result := NoYesMsg(Format(S, Args));
end;

function YesNoWarnMsg(const S: string): Boolean;
begin
  Result := MessageDlg(S, mtWarning, mbYesNo, 0) = mrYes;
end;

function YesNoWarnMsgFmt(const S: string; const Args: array of const): Boolean;
begin
  Result := YesNoWarnMsg(Format(S, Args));
end;

function NoYesWarnMsg(const S: string): Boolean;
begin
  Result := MessageDlg(S, mtWarning, mbYesNo, 0, mbNo) = mrYes;
end;

function NoYesWarnMsgFmt(const S: string; const Args: array of const): Boolean;
begin
  Result := NoYesWarnMsg(Format(S, Args));
end;

function YesNoCancelNamed(const Msg: string; const YesCaption: string = ''; const NoCaption: string = '';
  const CancelCaption: string = ''; DefaultButton: TMsgDlgBtn = mbCancel): TModalResult;
var
  F: TForm;
begin
  F := CreateMessageDialog(Msg, mtConfirmation, mbYesNoCancel, DefaultButton);
  try
    if YesCaption <> '' then
      TButton(F.FindComponent('Yes')).Caption := YesCaption;

    if NoCaption <> '' then
      TButton(F.FindComponent('No')).Caption := NoCaption;

    if CancelCaption <> '' then
      TButton(F.FindComponent('Cancel')).Caption := CancelCaption;

    Result := F.ShowModal;
  finally
    F.Free;
  end;
end;

function CountLines(const Msg: string): Integer;
var
  C: Char;
begin
  Result := 1;
  for C in AdjustLineBreaks(Msg, tlbsLF) do
    if C = #10 then
      Inc(Result);
end;

procedure CopyX264RegistrySettings(const ASrc, ADst: string);
var
  RSrc,RDst: TRegistryAcc;
  Lst: TStringList;
  R: TRegDataType;
  Buffer: Pointer;
  I,L: Integer;
  N: string;
begin
  Lst  := TStringList.Create;
  RSrc := TRegistryAcc.Create;
  RDst := TRegistryAcc.Create;
  try
    RSrc.RootKey := HKEY_CURRENT_USER;
    RDst.RootKey := HKEY_CURRENT_USER;

    if RSrc.OpenKey('SOFTWARE\GNU\' + ASrc, True) and RDst.OpenKey('SOFTWARE\GNU\' + ADst, True) then
    begin
      // Don't use MoveKey!

      RSrc.GetValueNames(Lst);

      for I := 0 to Pred(Lst.Count) do
      begin
        N := Lst[I];
        L := RSrc.GetDataSize(N);
        if L >= 0 then
        begin
          Buffer := AllocMem(L);
          try
            L := RSrc.GetData(N, Buffer, L, R);

            RDst.PutData(N, Buffer, L, R);
          finally
            FreeMem(Buffer);
          end;
        end;
      end;
    end;
  finally
    Lst.Free;
    RDst.Free;
    RSrc.Free;
  end;
end;

initialization
  invariantFormat := TFormatSettings.Create('en-US');
  UseLatestCommonDialogs := False; // TTaskDialog (Vista and later cuts long lines (ellipses will be injected).
end.

