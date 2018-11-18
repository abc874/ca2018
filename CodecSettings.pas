unit CodecSettings;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.MMSystem, System.Classes, Vcl.ExtCtrls,

  // Jedi
  Vfw,

  // DSPack
  DXSUtils,

  // CA
  Utils;

type
  TICInfoArray = array of TICInfo;
  PICInfoArray = ^TICInfoArray;

  TICInfoObject = class
  private
    FIsDummy: Boolean;
    FICInfo: TICInfo;
    FHasAboutBox: Boolean;
    FHasConfigureBox: Boolean;
    function GetInfos: Boolean;
  protected
    constructor Create(dummy: Integer = 0);
    function ConfigCodec(ParentWindow: THandle; ICInfo: TICInfo; var State: string; var SizeDecoded: Integer): Boolean;
  public
    constructor CreateDummy;
    constructor CreateFromICInfo(FromICInfo: TICInfo);
    function HandlerFourCCString: string;
    function Name: string;
    function Description: string;
    function Driver: string;
    function Config(ParentWindow: THandle; var State: string; var SizeDecoded: Integer): Boolean;
    function About(ParentWindow: THandle): Boolean;
    property IsDummy: Boolean read FIsDummy;
    property ICInfo: TICInfo read FICInfo;
    property HasAboutBox: Boolean read FHasAboutBox;
    property HasConfigureBox: Boolean read FHasConfigureBox;
  end;

  TCodecList = class(TStringList)
  private
    function EnumCodecs(fccType: FOURCC; var ICInfoArray: TICInfoArray): Boolean;
    function GetCodecInfo(i: Integer): TICInfo;
    function GetCodecInfoObject(i: Integer): TICInfoObject;
  public
    constructor Create;
    procedure InsertDummy;
    function Fill: Integer;
    function IndexOfCodec(fccHandler: FOURCC): Integer;
    property CodecInfo[i: Integer]: TICInfo read GetCodecInfo;
    property CodecInfoObject[i: Integer]: TICInfoObject read GetCodecInfoObject;
  end;

  TSourceFilterList = class
  private
    FFilters: TList;
    procedure ClearFilterList;
    function Add: PFilCatNode;
    function GetFilter(Index: Integer): TFilCatNode;
    function CheckFilter(EnumFilters: TSysDevEnum; index: Integer; FilterBlackList: TGUIDList): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Fill(progressLabel: TPanel; FilterBlackList: TGUIDList): Integer;
    function Count: Integer;
    property GetFilterInfo[Index: Integer]: TFilCatNode read GetFilter;
    function GetFilterIndexByCLSID(CLSID: TGUID): Integer;
  end;

implementation

uses
  // Delphi
  Winapi.Windows, Winapi.DirectShow9, System.SysUtils, Vcl.Controls, Vcl.StdCtrls, Vcl.Forms,

  // Indy
  IdCoderMime,

  // CA
  CAResources;

{ TSourceFilterList }

procedure TSourceFilterList.ClearFilterList;
var
  I: Integer;
begin
  for I := 0 to Pred(FFilters.Count) do
    if Assigned(FFilters.Items[I]) then
      Dispose(FFilters.Items[I]);

  FFilters.Clear;
end;

function TSourceFilterList.GetFilter(Index: Integer): TFilCatNode;
var
  FilterInfo: PFilCatNode;
begin
  FilterINfo := FFilters.Items[Index];
  Result     := FilterInfo^;
end;

function TSourceFilterList.Add: PFilCatNode;
var
  newFilterINfo: PFilCatNode;
begin
  New(newFilterINfo);
  FFilters.Add(newFilterINfo);
  Result := newFilterInfo;
end;

function TSourceFilterList.GetFilterIndexByCLSID(CLSID: TGUID): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(Count) do
  begin
    if isEqualGUID(CLSID, GetFilterInfo[I].CLSID) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

procedure UpdateControlCaption(cntrl: TControl; s: string);
begin
  if cntrl is TPanel then with cntrl as TPanel do
  begin
    Caption := s;
    Refresh;
  end else
    if cntrl is TLabel then with cntrl as TLabel do
    begin
      Caption := s;
      Refresh;
    end;
end;

function TSourceFilterList.Count: Integer;
begin
  Result := FFilters.Count;
end;

constructor TSourceFilterList.Create;
begin
  FFilters := TList.Create;
end;

destructor TSourceFilterList.Destroy;
begin
  ClearFilterList;
  FreeAndNil(FFilters);
  inherited;
end;

function TSourceFilterList.CheckFilter(EnumFilters: TSysDevEnum; index: Integer; FilterBlackList: TGUIDList): Boolean;
const
  CLS_ID_WMT_LOG_FILTER: TGUID = '{92883667-E95C-443D-AC96-4CACA27BEB6E}';
var
  Filter: IBaseFilter;
  newFilterInfo: PFilCatNode;
  filterInfo: TFilCatNode;
begin
  Result := False;
  filterInfo := EnumFilters.Filters[index];
  //Skip Wmt Log Filter -> causing strange exception
  if not (IsEqualGUID(filterInfo.CLSID, CLS_ID_WMT_LOG_FILTER) or FilterBlackList.IsInList(filterInfo.CLSID)) then
  begin
    Filter := EnumFilters.GetBaseFilter(index);
    if supports(Filter, IFileSourceFilter) then
    begin
      newFilterInfo  := Add;
      newFilterInfo^ := filterInfo;
      Result         := True;
    end;
    Filter := nil;
  end;
end;

function TSourceFilterList.Fill(progressLabel: TPanel; FilterBlackList: TGUIDList): Integer;
var
  EnumFilters: TSysDevEnum;
  i, filterCount: Integer;
  newFilterInfo: PFilCatNode;
  ParentForm: TWinControl;
begin
  ClearFilterList;
  newFilterInfo := Add;
  newFilterINfo^.FriendlyName := '(' + RsSourceFilterNone + ')';
  newFilterInfo^.CLSID := GUID_NULL;
  Result := 1;

  EnumFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); //DirectShow Filters
  if Assigned(EnumFilters) then
  begin
    ParentForm := progressLabel;
    while (ParentForm <> nil) and not (ParentForm is TCustomForm) do
      ParentForm := ParentForm.Parent;

    UpdateControlCaption(progressLabel, RsCheckingSourceFilterStart);
    filterCount := EnumFilters.CountFilters;
    try
      for i := 0 to Pred(filterCount) do
      begin
        try
          UpdateControlCaption(progressLabel, Format(RsCheckingSourceFilter, [i + 1, filterCount]));
          CheckFilter(EnumFilters, i, FilterBlackList);
        except
          on E: exception do
          begin
            ErrMsgFmt(RsErrorCheckingSourceFilter, [EnumFilters.Filters[i].FriendlyName, GUIDTOString(EnumFilters.Filters[i].CLSID), E.Message]);
            if ParentForm <> nil then
              ParentForm.Refresh;
            // raise;
          end;
        end;
      end;
    finally
      UpdateControlCaption(progressLabel, RsCheckingSourceFilterEnd);
      FreeAndNil(EnumFilters);
      Result := FFilters.Count;
    end;
  end;
end;

{ TCodecList }

constructor TCodecList.Create;
begin
  inherited Create(True);
  InsertDummy;
end;

function CompareByInfoName(List: TStringList; Index1, Index2: Integer): Integer;
var
  CodecList: TCodecList;
  InfoObject1, InfoObject2: TICInfoObject;
begin
  if List is TCodecList then
  begin
    CodecList   := List as TCodecList;
    InfoObject1 := CodecList.CodecInfoObject[Index1];
    InfoObject2 := CodecList.CodecInfoObject[Index2];

    if Assigned(InfoObject1) and Assigned(InfoObject2) then
    begin
      if InfoObject1.IsDummy then
      begin
        if InfoObject2.IsDummy then
          Result := 0
        else
          Result := -1;
      end else
        if InfoObject2.IsDummy then
          Result := 1
        else
          Result := AnsiCompareText(InfoObject1.Name, InfoObject2.Name);
    end else
    begin
      if List.CaseSensitive then
        Result := AnsiCompareStr(List[Index1], List[Index2])
      else
        Result := AnsiCompareText(List[Index1], List[Index2]);
    end;
  end else
    Result := 0;
end;

function TCodecList.EnumCodecs(fccType: FOURCC; var ICInfoArray: TICInfoArray): Boolean;
var
  I: Integer;
begin
  I := 0;
  while True do
  begin
    SetLength(ICInfoArray, I + 1);
    if not ICInfo(fccType, DWORD(I), @ICInfoArray[I]) then
      Break;
    Inc(I)
  end;
  SetLength(ICInfoArray, I);

  Result := I > 0;
end;

function TCodecList.Fill: Integer;
var
  Infos: TICInfoArray;
  InfoObject: TICInfoObject;
  I: Integer;
begin
  Result := 0;
  Clear;
  InsertDummy;

  if EnumCodecs(ICTYPE_VIDEO, Infos) then
  begin
    for I := 0 to Pred(Length(Infos)) do
    begin
      InfoObject := TICInfoObject.createFromICInfo(Infos[I]);
      AddObject(Format('[%s] %s', [InfoObject.HandlerFourCCString, InfoObject.Name]), InfoObject);
    end;
    CustomSort(CompareByInfoName);
  end;
end;

procedure TCodecList.InsertDummy;
var
  InfoObject: TICInfoObject;
begin
  InfoObject := TICInfoObject.CreateDummy;
  AddObject(Format('(%s) %s', [InfoObject.Name, RsCodecUseDefault]), InfoObject);
end;

function TCodecList.GetCodecInfo(i: Integer): TICInfo;
begin
  Result := GetCodecInfoObject(i).ICInfo
end;

function TCodecList.GetCodecInfoObject(i: Integer): TICInfoObject;
begin
  Result := TICInfoObject(Objects[i]);
end;

function TCodecList.IndexOfCodec(fccHandler: FOURCC): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(Count) do
    if CodecInfo[I].fccHandler = fccHandler then
    begin
      Result := I;
      Break;
    end;
end;

{ TICInfoObject }

constructor TICInfoObject.Create;
begin
  inherited Create;
  FHasAboutBox     := False;
  FHasConfigureBox := False;
  FIsDummy         := True;
end;

constructor TICInfoObject.CreateDummy;
begin
  Create;
  FICInfo.fccType    := ICTYPE_VIDEO;
  FICInfo.fccHandler := 0;
  FICInfo.dwVersion  := 0;
  StringToWideChar(RsCodecDummyName, FICInfo.szName, 16);
  StringToWideChar(RsCodecDummyDesc, FICInfo.szDescription, 128);
end;

constructor TICInfoObject.createFromICInfo(FromICInfo: TICInfo);
begin
  Create;
  FIsDummy := False;
  FICInfo  := FromICInfo;
  GetInfos;
end;

function TICInfoObject.GetInfos: Boolean;
var
  Codec: HIC;
  returnedInfoSize: Cardinal;
begin
  Codec := ICOpen(FICInfo.fccType, FICInfo.fccHandler, ICMODE_QUERY);

  if codec <> 0 then
  begin
    try
      FHasAboutBox := ICQueryAbout(Codec);
      FHasConfigureBox := ICQueryConfigure(Codec);
      returnedInfoSize := ICGetInfo(Codec, @FICInfo, SizeOf(FICInfo));
      Result := (returnedInfoSize = SizeOf(FICInfo));
    finally
      Assert(ICClose(Codec) = ICERR_OK, RsErrorCloseCodec);
    end;
  end else
    Result := False;
end;

function TICInfoObject.Name: string;
begin
  Result := WideCharToString(FICInfo.szName)
end;

function TICInfoObject.Description: string;
begin
  Result := WideCharToString(FICInfo.szDescription)
end;

function TICInfoObject.Driver: string;
begin
  Result := WideCharToString(FICInfo.szDriver)
end;

function TICInfoObject.HandlerFourCCString: string;
begin
  Result := fcc2String(FICInfo.fccHandler)
end;

function TICInfoObject.Config(ParentWindow: THandle; var State: string; var SizeDecoded: Integer): Boolean;
begin
  if HasConfigureBox then
    Result := ConfigCodec(ParentWindow, FICInfo, State, SizeDecoded)
  else
    Result := False;
end;

function TICInfoObject.ConfigCodec(ParentWindow: THandle; ICInfo: TICInfo; var State: string; var SizeDecoded: Integer): Boolean;
var
  Codec: HIC;
  BufferSize: DWORD;
  StateData: string;
begin
  Codec := ICOpen(ICInfo.fccType, ICInfo.fccHandler, ICMODE_COMPRESS);

  if Codec <> 0 then
  begin
    try
      if Length(State) > 0 then
      begin
        StateData := TIdDecoderMime.DecodeString(State);
        // set old state
        ICSetState(Codec, @StateData[1], Length(StateData));
      end;
    except
      // Swallow exception in this case
    end;

    if (ICConfigure(Codec, ParentWindow) = ICERR_OK) then
    begin
      BufferSize := ICGetStateSize(Codec);
      SetLength(StateData, BufferSize);

      if (ICGetState(Codec, @StateData[1], BufferSize) = ICERR_OK) then
      begin
        State       := TIdEncoderMime.EncodeString(StateData);
        SizeDecoded := Length(StateData);
      end else
      begin
        State       := '';
        SizeDecoded := 0;
      end;
    end;
    if ICClose(Codec) <> ICERR_OK then
      Assert(False, RsErrorCloseCodec);

    Result := True;
  end else
    Result := False;
end;

function TICInfoObject.About(ParentWindow: THandle): Boolean;
var
  Codec: HIC;
begin
  Result := False;

  if HasAboutBox then
  begin
    Codec := ICOpen(FICInfo.fccType, FICInfo.fccHandler, ICMODE_QUERY);
    if codec <> 0 then
    begin
      try
        Result := ICAbout(Codec, ParentWindow) = ICERR_OK;
      finally
        Assert(ICClose(Codec) = ICERR_OK, RsErrorCloseCodec);
      end;
    end;
  end;
end;

end.

