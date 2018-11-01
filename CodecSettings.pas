UNIT CodecSettings;

INTERFACE

USES
  Classes,
  ExtCtrls,
  DSUtil,
  MMSystem,
  vfw,
  Utils;

TYPE
  TICInfoArray = ARRAY OF TICInfo;
  PICInfoArray = ^TICInfoArray;

  TICInfoObject = CLASS
  PRIVATE
    FIsDummy: boolean;
    FICInfo: TICInfo;
    FHasAboutBox,
      FHasConfigureBox: boolean;
    FUNCTION GetInfos: boolean;
  PROTECTED
    CONSTRUCTOR Create;
    FUNCTION ConfigCodec(ParentWindow: THandle; ICInfo: TICInfo; VAR State: STRING; VAR SizeDecoded: Integer): boolean;
  PUBLIC
    CONSTRUCTOR CreateDummy;
    CONSTRUCTOR CreateFromICInfo(FromICInfo: TICInfo);
    FUNCTION HandlerFourCCString: STRING;
    FUNCTION Name: STRING;
    FUNCTION Description: STRING;
    FUNCTION Driver: STRING;
    FUNCTION Config(ParentWindow: THandle; VAR State: STRING; VAR SizeDecoded: Integer): boolean;
    FUNCTION About(ParentWindow: THandle): boolean;
    PROPERTY IsDummy: boolean READ FIsDummy;
    PROPERTY ICInfo: TICInfo READ FICInfo;
    PROPERTY HasAboutBox: boolean READ FHasAboutBox;
    PROPERTY HasConfigureBox: boolean READ FHasConfigureBox;
  END;

  TCodecList = CLASS(TStringList)
  PRIVATE
    FUNCTION EnumCodecs(fccType: FOURCC; VAR ICInfoArray: TICInfoArray): boolean;
    FUNCTION GetCodecInfo(i: Integer): TICInfo;
    FUNCTION GetCodecInfoObject(i: Integer): TICInfoObject;
  PUBLIC
    CONSTRUCTOR create;
    DESTRUCTOR Destroy; OVERRIDE;
    PROCEDURE ClearAndFreeObjects;
    PROCEDURE InsertDummy;
    FUNCTION Fill: Integer;
    FUNCTION IndexOfCodec(fccHandler: FOURCC): Integer;
    PROPERTY CodecInfo[i: Integer]: TICInfo READ GetCodecInfo;
    PROPERTY CodecInfoObject[i: Integer]: TICInfoObject READ GetCodecInfoObject;
  END;

  TSourceFilterList = CLASS
  PRIVATE
    FFilters: TList;
    PROCEDURE ClearFilterList;
    FUNCTION Add: PFilCatNode;
    FUNCTION GetFilter(Index: Integer): TFilCatNode;
    FUNCTION CheckFilter(EnumFilters: TSysDevEnum; index: integer; FilterBlackList: TGUIDList): Boolean;
  PUBLIC
    CONSTRUCTOR Create;
    DESTRUCTOR Destroy; OVERRIDE;
    FUNCTION Fill(progressLabel: TPanel; FilterBlackList: TGUIDList): Integer;
    FUNCTION count: Integer;
    PROPERTY GetFilterInfo[Index: Integer]: TFilCatNode READ GetFilter;
    FUNCTION GetFilterIndexByCLSID(CLSID: TGUID): Integer;
  END;


IMPLEMENTATION

USES
  Forms,
  Controls,
  StdCtrls,
  Dialogs,
  Windows,
  Types,
  SysUtils,
  IdException,
  IdCoderMime,
  DirectShow9,
  CAResources;

{ TSourceFilterList }

PROCEDURE TSourceFilterList.ClearFilterList;
VAR
  i                                : Integer;
BEGIN
  FOR i := 0 TO (FFilters.Count - 1) DO
    IF assigned(FFilters.Items[i]) THEN Dispose(FFilters.Items[i]);
  FFilters.Clear;
END;

FUNCTION TSourceFilterList.GetFilter(Index: Integer): TFilCatNode;
VAR
  FilterInfo                       : PFilCatNode;
BEGIN
  FilterINfo := FFilters.Items[Index];
  result := FilterInfo^;
END;

FUNCTION TSourceFilterList.Add: PFilCatNode;
VAR
  newFilterINfo                    : PFilCatNode;
BEGIN
  new(newFilterINfo);
  self.FFilters.Add(newFilterINfo);
  result := newFilterInfo;
END;

FUNCTION TSourceFilterList.GetFilterIndexByCLSID(CLSID: TGUID): Integer;
VAR
  i                                : integer;
BEGIN
  result := -1;
  FOR i := 0 TO self.count - 1 DO BEGIN
    IF isEqualGUID(CLSID, self.GetFilterInfo[i].CLSID) THEN BEGIN
      result := i;
      break;
    END;
  END;
END;

PROCEDURE UpdateControlCaption(cntrl: TControl; s: STRING);
BEGIN
  IF cntrl = NIL THEN exit;

  IF cntrl IS TPanel THEN BEGIN
    WITH cntrl AS TPanel DO BEGIN
      Caption := s;
      Refresh;
    END;
  END
  ELSE IF cntrl IS TLabel THEN BEGIN
    WITH cntrl AS TLabel DO BEGIN
      Caption := s;
      Refresh;
    END;
  END
END;

FUNCTION TSourceFilterList.count: Integer;
BEGIN
  result := FFilters.Count;
END;

CONSTRUCTOR TSourceFilterList.create;
BEGIN
  FFilters := TList.Create;
END;

DESTRUCTOR TSourceFilterList.destroy;
BEGIN
  ClearFilterList;
  FreeAndNil(FFilters);
  INHERITED;
END;

FUNCTION TSourceFilterList.CheckFilter(EnumFilters: TSysDevEnum; index: integer; FilterBlackList: TGUIDList): Boolean;
CONST
  CLS_ID_WMT_LOG_FILTER            : TGUID = '{92883667-E95C-443D-AC96-4CACA27BEB6E}';
VAR
  Filter                           : IBaseFilter;
  newFilterInfo                    : PFilCatNode;
  filterInfo                       : TFilCatNode;
BEGIN
  Result := false;
  filterInfo := EnumFilters.Filters[index];
  //Skip Wmt Log Filter -> causing strange exception
  IF NOT (IsEqualGUID(filterInfo.CLSID, CLS_ID_WMT_LOG_FILTER)
    OR FilterBlackList.IsInList(filterInfo.CLSID)) THEN BEGIN
    Filter := EnumFilters.GetBaseFilter(index);
    IF supports(Filter, IFileSourceFilter) THEN BEGIN
      newFilterInfo := self.Add;
      newFilterINfo^ := filterInfo;
      Result := true;
    END;
    Filter := NIL;
  END;
END;

FUNCTION TSourceFilterList.Fill(progressLabel: TPanel; FilterBlackList: TGUIDList): Integer;
VAR
  EnumFilters                      : TSysDevEnum;
  i, filterCount                   : Integer;
  newFilterInfo                    : PFilCatNode;
  ParentForm                       : TWinControl;
BEGIN
  self.ClearFilterList;
  newFilterInfo := self.Add;
  newFilterINfo^.FriendlyName := '(' + CAResources.RsSourceFilterNone + ')';
  newFilterInfo^.CLSID := GUID_NULL;
  result := 1;

  EnumFilters := TSysDevEnum.Create(CLSID_LegacyAmFilterCategory); //DirectShow Filters
  IF NOT assigned(EnumFilters) THEN exit;

  ParentForm := progressLabel;
  WHILE (ParentForm <> NIL) AND NOT (ParentForm IS TCustomForm) DO
    ParentForm := ParentForm.Parent;

  UpdateControlCaption(progressLabel, CAResources.RsCheckingSourceFilterStart);
  filterCount := EnumFilters.CountFilters;
  TRY
    FOR i := 0 TO filterCount - 1 DO BEGIN
      TRY
        UpdateControlCaption(progressLabel, SysUtils.Format(CAResources.RsCheckingSourceFilter, [i + 1, filterCount]));
        CheckFilter(EnumFilters, i, FilterBlackList);
      EXCEPT
        ON E: exception DO BEGIN
          ShowMessageFmt(CAResources.RsErrorCheckingSourceFilter, [
            EnumFilters.Filters[i].FriendlyName,
              GUIDTOString(EnumFilters.Filters[i].CLSID),
              E.Message]);
          IF ParentForm <> NIL THEN
            ParentForm.Refresh;
          //raise;
        END;
      END;
    END;
  FINALLY
    UpdateControlCaption(progressLabel, CAResources.RsCheckingSourceFilterEnd);
    FreeAndNIL(EnumFilters);
    result := self.FFilters.Count;
  END;
END;

{ TCodecList }

PROCEDURE TCodecList.ClearAndFreeObjects;
VAR
  i                                : Integer;
BEGIN
  FOR i := 0 TO self.Count - 1 DO BEGIN
    IF assigned(self.Objects[i]) THEN BEGIN
      self.Objects[i].Free;
      self.Objects[i] := NIL;
    END;
  END;
  self.Clear;
END;

CONSTRUCTOR TCodecList.create;
BEGIN
  self.InsertDummy;
END;

DESTRUCTOR TCodecList.destroy;
BEGIN
  self.ClearAndFreeObjects;
  INHERITED;
END;

FUNCTION CompareByInfoName(List: TStringList; Index1, Index2: Integer): Integer;
VAR
  CodecList                        : TCodecList;
  InfoObject1                      : TICInfoObject;
  InfoObject2                      : TICInfoObject;
BEGIN
  IF List IS TCodecList THEN BEGIN
    CodecList := List AS TCodecList;
    InfoObject1 := CodecList.CodecInfoObject[Index1];
    InfoObject2 := CodecList.CodecInfoObject[Index2];
    IF Assigned(InfoObject1) AND Assigned(InfoObject2) THEN BEGIN
      IF InfoObject1.IsDummy THEN BEGIN
        IF InfoObject2.IsDummy THEN Result := 0
        ELSE Result := -1;
      END
      ELSE IF InfoObject2.IsDummy THEN Result := 1
      ELSE Result := AnsiCompareText(InfoObject1.Name, InfoObject2.Name);
      Exit;
    END;
  END;
  IF List.CaseSensitive THEN
    Result := AnsiCompareStr(List[Index1], List[Index2])
  ELSE
    Result := AnsiCompareText(List[Index1], List[Index2]);
END;

FUNCTION TCodecList.EnumCodecs(fccType: FOURCC; VAR ICInfoArray: TICInfoArray): boolean;
VAR
  i                                : integer;
BEGIN
  result := false;
  i := 0;
  WHILE true DO BEGIN
    setlength(ICInfoArray, i + 1);
    IF NOT ICInfo(fccType, DWord(i), @ICInfoArray[i]) THEN break;
    inc(i)
  END;
  setlength(ICInfoArray, i);
  IF i > 0 THEN result := true;
END;

FUNCTION TCodecList.Fill: Integer;
VAR
  Infos                            : TICInfoArray;
  InfoObject                       : TICInfoObject;
  i                                : integer;
BEGIN
  result := 0;
  self.ClearAndFreeObjects;
  self.InsertDummy;

  IF NOT EnumCodecs(ICTYPE_VIDEO, Infos) THEN
    exit;
  FOR i := 0 TO length(Infos) - 1 DO BEGIN
    InfoObject := TICInfoObject.createFromICInfo(Infos[i]);
    self.AddObject(Format('[%s] %s', [InfoObject.HandlerFourCCString, InfoObject.Name]), InfoObject);
  END;
  self.CustomSort(CompareByInfoName);
END;

PROCEDURE TCodecList.InsertDummy;
VAR
  InfoObject                       : TICInfoObject;
BEGIN
  InfoObject := TICInfoObject.CreateDummy;
  self.AddObject(Format('(%s) %s', [InfoObject.Name, CAResources.RsCodecUseDefault]), InfoObject);
END;

FUNCTION TCodecList.GetCodecInfo(i: Integer): TICInfo;
BEGIN
  result := (self.Objects[i] AS TICInfoObject).ICInfo
END;

FUNCTION TCodecList.GetCodecInfoObject(i: Integer): TICInfoObject;
BEGIN
  result := (self.Objects[i] AS TICInfoObject);
END;

FUNCTION TCodecList.IndexOfCodec(fccHandler: FOURCC): Integer;
VAR
  i                                : integer;
BEGIN
  result := -1;
  FOR i := 0 TO self.Count - 1 DO BEGIN
    IF self.CodecInfo[i].fccHandler = fccHandler THEN BEGIN
      result := i;
      break;
    END;
  END;
END;

{ TICInfoObject }

CONSTRUCTOR TICInfoObject.create;
BEGIN
  INHERITED create;
  FHasAboutBox := false;
  FHasConfigureBox := false;
  FIsDummy := true;
END;

CONSTRUCTOR TICInfoObject.CreateDummy;
BEGIN
  Create;
  self.FICInfo.fccType := ICTYPE_VIDEO;
  self.FICInfo.fccHandler := 0;
  self.FICInfo.dwVersion := 0;
  StringToWideChar(CAResources.RsCodecDummyName, self.FICInfo.szName, 16);
  StringToWideChar(CAResources.RsCodecDummyDesc, self.FICInfo.szDescription, 128);
END;

CONSTRUCTOR TICInfoObject.createFromICInfo(FromICInfo: TICInfo);
BEGIN
  create;
  FIsDummy := false;
  self.FICInfo := FromICInfo;
  self.GetInfos;
END;

FUNCTION TICInfoObject.GetInfos: boolean;
VAR
  Codec                            : HIC;
  returnedInfoSize                 : Cardinal;
BEGIN
  result := false;
  Codec := ICOpen(FICInfo.fccType, FICInfo.fccHandler, ICMODE_QUERY);
  IF codec = 0 THEN exit;
  TRY
    FHasAboutBox := ICQueryAbout(Codec);
    FHasConfigureBox := ICQueryConfigure(Codec);
    returnedInfoSize := ICGetInfo(Codec, @FICInfo, sizeof(FICInfo));
    result := (returnedInfoSize = sizeof(FICInfo));
  FINALLY
    assert(ICClose(Codec) = ICERR_OK, CAResources.RsErrorCloseCodec);
  END;
END;

FUNCTION TICInfoObject.Name: STRING;
BEGIN
  result := WideCharToString(FICInfo.szName)
END;

FUNCTION TICInfoObject.Description: STRING;
BEGIN
  result := WideCharToString(FICInfo.szDescription)
END;

FUNCTION TICInfoObject.Driver: STRING;
BEGIN
  result := WideCharToString(FICInfo.szDriver)
END;

FUNCTION TICInfoObject.HandlerFourCCString: STRING;
BEGIN
  result := fcc2String(FICInfo.fccHandler)
END;

FUNCTION TICInfoObject.Config(ParentWindow: THandle; VAR State: STRING;
  VAR SizeDecoded: Integer): boolean;
BEGIN
  result := false;
  IF NOT self.HasConfigureBox THEN exit;
  result := ConfigCodec(ParentWindow, FICInfo, State, SizeDecoded);
END;

FUNCTION TICInfoObject.ConfigCodec(ParentWindow: THandle; ICInfo: TICInfo; VAR State: STRING; VAR SizeDecoded: Integer): boolean;
VAR
  Codec                            : HIC;
  BufferSize                       : DWORD;
  StateData                        : STRING;
BEGIN
  result := false;
  Codec := ICOpen(ICInfo.fccType, ICInfo.fccHandler, ICMODE_COMPRESS);
  IF Codec = 0 THEN
    exit;

  TRY
    IF (Length(State) > 0) THEN BEGIN
      StateData := TIdDecoderMime.DecodeString(State);
      // set old state
      ICSetState(Codec, @StateData[1], Length(StateData));
    END;
  EXCEPT
    ON E: EIdException DO BEGIN
      // Swallow exception in this case
    END;
  END;

  IF (ICConfigure(Codec, ParentWindow) = ICERR_OK) THEN BEGIN
    BufferSize := ICGetStateSize(Codec);
    SetLength(StateData, BufferSize);

    IF (ICGetState(Codec, @StateData[1], BufferSize) = ICERR_OK) THEN BEGIN
      State := TIdEncoderMime.EncodeString(StateData);
      SizeDecoded := Length(StateData);
    END ELSE BEGIN
      State := '';
      SizeDecoded := 0;
    END;
  END;
  IF ICClose(Codec) <> ICERR_OK THEN
    Assert(false, CAResources.RsErrorCloseCodec);
  result := true;
END;

FUNCTION TICInfoObject.About(ParentWindow: THandle): boolean;
VAR
  Codec                            : HIC;
BEGIN
  result := false;
  IF NOT self.HasAboutBox THEN exit;
  Codec := ICOpen(FICInfo.fccType, FICInfo.fccHandler, ICMODE_QUERY);
  IF codec = 0 THEN exit;
  TRY
    IF (ICAbout(Codec, ParentWindow) = ICERR_OK) THEN result := true;
  FINALLY
    assert(ICClose(Codec) = ICERR_OK, CAResources.RsErrorCloseCodec);
  END;
END;

END.

