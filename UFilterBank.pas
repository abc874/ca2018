(*
From progdigy.com Forum posted by XXX on Mon 2004-11-08 07.50 pm

I created object 'TFilterBank' providing connecting/disconnecting desired filters.
What is this good for? For situations like this:
- I would like to add 'Dedynamic' filter to filtergraph every time I watch video.
- I would like to remove 'DC-DSP filter' from filtergraph (but not from system to get rid of it).

I tested 'TFilterBank' only on filters with one input pin and one output pin.



Example
We want to insert 'DeDynamic' filter and remove 'DC-DSP Filter'.

Create new aplication, rename 'Form1' to 'MainForm' and place DSVideoWindowEx2, 3 buttons, OpenDialog, FilterGraph on it with following names 'DSVideoWindowEx2', 'btnOpen', 'btnStop', 'btnPlay', 'OpenDialog'.
Here is the entire code:
CODE


unit Unit1;

interface

uses
 Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls, DSPack, FilterBank, DirectShow9;

type
 TMainForm = class(TForm)
   DSVideoWindowEx2: TDSVideoWindowEx2;
   btnOpen: TButton;
   btnStop: TButton;
   btnPlay: TButton;
   OpenDialog: TOpenDialog;
   FilterGraph: TFilterGraph;
   procedure FormCreate(Sender: TObject);
   procedure FormDestroy(Sender: TObject);
   procedure btnOpenClick(Sender: TObject);
   procedure btnPlayClick(Sender: TObject);
   procedure btnStopClick(Sender: TObject);
 private
   { Private declarations }
   FilterBank : TFilterBank;
   procedure LoadAVI(const aviname : TFileName);
 public
   { Public declarations }
 end;

var
 MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
begin
  FilterBank := TFilterBank.Create;
  FilterBank.Enabled := true;
  // 'DeDynamic' will be inserted
  FilterBank.Insert('DirectShow Filters', 'DeDynamic', NilGUID, faInsert);
  // 'DC-DSP Filter' will be removed
  FilterBank.Insert('DirectShow Filters', 'DC-DSP Filter', NilGUID, faRemove);
end;

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
     FilterGraph.Stop;
     FilterGraph.ClearGraph;
     FilterGraph.Active := false;
     FreeAndNIL(FilterBank);
end;

procedure TMainForm.LoadAVI(const aviname : TFileName);
 procedure WaitForFilterGraph;
 var
   pfs : TFilterState;
   hr : hresult;
 begin
      repeat
        hr := (FilterGraph as IMediaControl).GetState(50, pfs);
      until (hr = S_OK) or (hr = E_FAIL);
 end;
begin
       // usual init sequence
       if not FilterGraph.Active then FilterGraph.Active := true;
       FilterGraph.Stop;
       FilterGraph.ClearGraph;

       FilterBank.FiltersDestroy; // destroy old filters
       FilterBank.FiltersInit;    // init new filters
       FilterBank.FiltersConnectToGraph(FilterGraph); // connect to graph

       FilterGraph.RenderFile(WideString(aviname)); // render file
       WaitForFilterGraph; // little delay

       FilterGraph.Play;   // show first frame
       WaitForFilterGraph; // wait for first frame
       FilterGraph.Stop;   // stop graph for filter manipulation

       WaitForFilterGraph; // little delay
       FilterBank.FiltersDisconnectFromGraph(FilterGraph); // remove unwanted filters
       FilterGraph.Pause;
end;

procedure TMainForm.btnOpenClick(Sender: TObject);
begin
  if OpenDialog.Execute then LoadAVI(OpenDialog.FileName);
end;

procedure TMainForm.btnPlayClick(Sender: TObject);
begin
  if FilterGraph.Active then FilterGraph.Play;
end;

procedure TMainForm.btnStopClick(Sender: TObject);
begin
  if FilterGraph.Active then FilterGraph.Pause;
end;

*)


UNIT UFilterBank;

INTERFACE

USES SysUtils,
  DirectShow9,
  DSUtil,
  DSPack,
  ActiveX,
  INIFiles;

CONST
  NilGUID                          : TGUID = '{00000000-0000-0000-0000-000000000000}';

TYPE
  TFilterAction = (faNone, faInsert, faRemove);

  TFilterItem = RECORD
    FilterAction: TFilterAction;
    Category, Name: STRING;
    CLSID: TGUID;
  END;

  TFilterBank = CLASS
  PRIVATE
    FEnabled: boolean;
    FTemp: boolean; // temporary flag (rewrite 'TempFilters' to 'Filters' during next 'Init')
    FFilters: ARRAY OF TFilterItem; // main filter list
    FTempFilters: ARRAY OF TFilterItem; // temporary filter list
    FBaseFilters: ARRAY OF IBaseFilter; // pointers to filters
    FUNCTION GetCount: integer;
    FUNCTION GetItem(CONST index: integer): TFilterItem;
    FUNCTION CreateFilter(CONST CategoryName, FilterName: STRING; CONST aFilterCLSID: TGUID): IBaseFilter;
  PUBLIC
    { Constructor method. }
    CONSTRUCTOR Create;
    { Destructor method. }
    DESTRUCTOR Destroy; OVERRIDE;
    { Insert filter (category, name or CLSID) to filter list (temporary). }
    PROCEDURE Insert(CONST aCategory, aName: STRING; CONST aCLSID: TGUID; CONST aFilterAction: TFilterAction);
    { Remove filter from filter list (temporary). }
    PROCEDURE Remove(CONST index: integer);
    { Remove all filters from filter list (temporary). }
    PROCEDURE RemoveAll;
    { Initialize/create filters in filter list. Method rewrites all changes in <br>
      temporary filter list to main filter list first.}
    PROCEDURE FiltersInit;
    { Free all filters from filter list. }
    PROCEDURE FiltersDestroy;
    { Connect filters to filtergraph. }
    PROCEDURE FiltersConnectToGraph(VAR FilterGraph: TFilterGraph);
    { Disconnect filters from filtergraph. }
    PROCEDURE FiltersDisconnectFromGraph(VAR FilterGraph: TFilterGraph);
    { Save filter list to INI.}
    PROCEDURE SaveToINI(VAR IniFile: TMemIniFile; CONST INISection, INIEnabled,
      ININame, INICategory, INICLSID, INIState: STRING);
    { Load filter list from INI. }
    PROCEDURE LoadFromINI(VAR IniFile: TMemIniFile; CONST INISection, INIEnabled,
      ININame, INICategory, INICLSID, INIState: STRING);
  PUBLIC
    { Get filters count. }
    PROPERTY Count: integer READ GetCount;
    { Enable property. }
    PROPERTY Enabled: boolean READ FEnabled WRITE FEnabled;
    { Filter list. }
    PROPERTY Filters[CONST index: integer]: TFilterItem READ GetItem;
  END;

IMPLEMENTATION

CONSTRUCTOR TFilterBank.Create;
// Constructor.
BEGIN
  FEnabled := true;
  FTemp := false; // temporary flag
  SetLength(FFilters, 0);
  SetLength(FTempFilters, 0);
  SetLength(FBaseFilters, 0);
END;

DESTRUCTOR TFilterBank.Destroy;
// Destructor.
BEGIN
  FiltersDestroy;
  SetLength(FTempFilters, 0);
  SetLength(FFilters, 0);
  SetLength(FBaseFilters, 0);
  INHERITED Destroy;
END;

FUNCTION TFilterBank.GetCount: integer;
BEGIN
  IF FTemp THEN // are there changes in temporary list? => read from it
    result := Length(FTempFilters)
  ELSE
    result := Length(FFilters);
END;

FUNCTION TFilterBank.GetItem(CONST index: integer): TFilterItem;
// Get filter information.
BEGIN
  result.FilterAction := faNone;
  result.Category := '';
  result.Name := '';
  result.CLSID := NilGUID;

  IF FTemp THEN {// are there changes in temporary list? => read from it} BEGIN
    IF (index >= 0) AND (index < Length(FTempFilters)) THEN
      result := FTempFilters[index];
  END
  ELSE BEGIN // there are no changes in temporary list => read from main list
    IF (index >= 0) AND (index < Length(FFilters)) THEN
      result := FFilters[index];
  END;
END;

FUNCTION TFilterBank.CreateFilter(CONST CategoryName, FilterName: STRING; CONST aFilterCLSID: TGUID): IBaseFilter;
// Create filter by category and name or by its CLSID.
VAR
  SysDev                           : TSysdevEnum;
  i                                : integer;
BEGIN
  // non nil CLSID? => create filter by its CLSID
  IF NOT IsEqualGUID(aFilterCLSID, NilGUID) THEN
    IF CoCreateInstance(aFilterCLSID, NIL, CLSCTX_INPROC_SERVER, IID_IBaseFilter, result) = S_OK THEN exit;

  result := NIL;

  SysDev := TSysDevEnum.Create;

  TRY
    i := sysdev.CountCategories - 1; // searching in categories
    WHILE i >= 0 DO BEGIN
      IF AnsiCompareText(SysDev.Categories[i].FriendlyName, CategoryName) = 0 THEN break;
      Dec(i);
    END;

    IF i < 0 THEN exit; // find anything?

    SysDev.SelectIndexCategory(i);
    i := SysDev.CountFilters - 1; // searching in filter names
    WHILE i >= 0 DO BEGIN
      IF AnsiCompareText(SysDev.Filters[i].FriendlyName, FilterName) = 0 THEN break;
      Dec(i);
    END;

    IF i < 0 THEN exit; // find anything?

    result := sysdev.GetBaseFilter(i); // return 'IBaseFilter' interface
  FINALLY
    FreeAndNIL(sysdev);
  END; //try finally
END;

PROCEDURE TFilterBank.Insert(CONST aCategory, aName: STRING; CONST aCLSID: TGUID; CONST aFilterAction: TFilterAction);
// Insert filter to temporary list, sets temporary flag.
BEGIN
  SetLength(FTempFilters, Length(FTempFilters) + 1); // add item

  WITH FTempFilters[Length(FTempFilters) - 1] DO BEGIN
    FilterAction := aFilterAction;
    Category := aCategory;
    Name := aName;
    CLSID := aCLSID;
  END;

  FTemp := true; // set temporary flag
END;

PROCEDURE TFilterBank.Remove(CONST index: integer);
// Remove filter from temporary list.
VAR
  i                                : integer;
BEGIN
  IF (index >= 0) AND (index < Length(FTempFilters)) THEN BEGIN

    IF index < (Length(FFilters) - 1) THEN
      FOR i := index TO Length(FFilters) - 1 DO
        FTempFilters[i] := FTempFilters[i + 1];

    SetLength(FFilters, Length(FTempFilters) - 1);
  END;

  FTemp := true;
END;

PROCEDURE TFilterBank.RemoveAll;
// Remove all items from temporary list.
BEGIN
  SetLength(FTempFilters, 0);
  FTemp := true;
END;

PROCEDURE TFilterBank.FiltersInit;
// Create filters.
VAR
  i                                : integer;
BEGIN
  IF NOT FEnabled THEN exit;

  IF FTemp THEN {// changes in temporary list? => rewrite them to main list} BEGIN
    FiltersDestroy;
    SetLength(FFilters, Length(FTempFilters)); // allocate space for list
    SetLength(FBaseFilters, Length(FTempFilters)); // allocate space for interfaces

    FOR i := 0 TO Length(FTempFilters) - 1 DO {// zkopiruju} BEGIN
      FFilters[i] := FTempFilters[i];
      FBaseFilters[i] := NIL;
    END;

    SetLength(FTempFilters, 0); // clear temporary list
    FTemp := false;
  END;

  FOR i := 0 TO Length(FFilters) - 1 DO BEGIN
    // insert this filter? => then must be created first
    IF FFilters[i].FilterAction = faInsert THEN
      FBaseFilters[i] := CreateFilter(FFilters[i].Category, FFilters[i].Name, FFilters[i].CLSID);
  END;
END;

PROCEDURE TFilterBank.FiltersDestroy;
// Destroy filters.
VAR
  i                                : integer;
BEGIN
  FOR i := 0 TO Length(FBaseFilters) - 1 DO
    FBaseFilters[i] := NIL;
END;

PROCEDURE TFilterBank.FiltersConnectToGraph(VAR FilterGraph: TFilterGraph);
// Connect filters to 'FilterGraph'.
VAR
  i                                : integer;
  BaseFilter                       : IBaseFilter;
  s                                : WideString;
  FilterGraph2                     : IFilterGraph2;
BEGIN
  IF NOT FEnabled THEN exit;

  TRY
    IF FilterGraph.QueryInterface(IID_IFilterGraph2, FilterGraph2) <> S_OK THEN exit;

    FOR i := 0 TO Length(FFilters) - 1 DO BEGIN
      // insert this filter?
      IF (FFilters[i].FilterAction = faInsert) AND assigned(FBaseFilters[i]) THEN BEGIN
        s := FFilters[i].Name; // widestring conversion
        // isn't filter in filtergraph? => insert it
        IF FilterGraph2.FindFilterByName(PWideChar(s), BaseFilter) <> S_OK THEN BEGIN
          FilterGraph2.AddFilter(FBaseFilters[i], PWideChar(s));
          BaseFilter := NIL;
        END;
      END;
    END;
  FINALLY
    FilterGraph2 := NIL;
  END;

END;

PROCEDURE TFilterBank.FiltersDisconnectFromGraph(VAR FilterGraph: TFilterGraph);
// Remove filter from 'FilterGraph'.
(*
  Picture describing variable names.

 previous filter     removed filter      following filter
             ---      ------------       ---
      OutPrevPin|----|InPin       |     |
                |    |            |     |
                |    |      OutPin|-----|InNextPin
             ---      ------------       ---
*)
VAR
  BaseFilter                       : IBaseFilter;
  OutPin, InPin, tmp               : IPin;
  OutPrevPin, InNextPin            : IPin;
  PinList, OutPinList, InPinList   : TPinList;
  i, j                             : integer;
  FilterGraph2                     : IFilterGraph2;
  GraphBuilder                     : IGraphBuilder;
BEGIN
  IF NOT FEnabled THEN exit;

  TRY
    IF FilterGraph.QueryInterface(IID_IFilterGraph2, FilterGraph2) <> S_OK THEN exit;
    IF FilterGraph.QueryInterface(IID_IGraphBuilder, GraphBuilder) <> S_OK THEN exit;

    FOR j := 0 TO Length(FFilters) - 1 DO BEGIN
      IF FFilters[j].FilterAction = faRemove THEN {// remove this filter?} BEGIN
        // is filter in filtergraph? => exit if not
        IF FilterGraph2.FindFilterByName(StringToOleStr(FFilters[j].Name), BaseFilter) <> S_OK THEN Exit;

        PinList := TPinList.Create(BaseFilter); // get all pins
        InPinList := TPinList.Create; // create list for input pins
        OutPinList := TPinList.Create; // create list for output pins

        TRY
          FOR i := 0 TO PinList.Count - 1 DO {// pass through all pins} BEGIN
            // is pin connected? => save it to the list
            IF PinList.Items[i].ConnectedTo(tmp) = S_OK THEN BEGIN
              tmp := NIL;
              CASE PinList.PinInfo[i].dir OF
                PINDIR_INPUT: InPinList.Add(PinList.Items[i]);
                PINDIR_OUTPUT: OutPinList.Add(PinList.Items[i]);
              END;
            END;
          END;

          // check - input and output pins count must agree
          IF OutPinList.Count = InPinList.Count THEN BEGIN
            FOR i := 0 TO InPinList.Count - 1 DO {// reconnect all pins} BEGIN
              InPin := InPinList.First; // get next pin
              OutPin := OutPinList.First; // get next pin
              InPinList.Delete(0);
              OutPinList.Delete(0);

              // get previous and following filter pin
              InPin.ConnectedTo(OutPrevPin);
              OutPin.ConnectedTo(InNextPin);

              // disconnect pins
              GraphBuilder.Disconnect(OutPrevPin);
              GraphBuilder.Disconnect(InPin);
              GraphBuilder.Disconnect(OutPin);
              GraphBuilder.Disconnect(InNextPin);

              // connect previous filter pin to following filter pin
              GraphBuilder.Connect(OutPrevPin, InNextPin);
            END;

            // remove filter
            (FilterGraph AS IGraphBuilder).RemoveFilter(BaseFilter);

            InPin := NIL;
            OutPin := NIL;
            InNextPin := NIL;
            OutPrevPin := NIL;
            BaseFilter := NIL;
          END;

        FINALLY
          FreeAndNIL(PinList);
          FreeAndNIL(OutPinList);
          FreeAndNIL(InPinList);
        END;

      END; // if FFilters[j].FilterAction = faRemove
    END; // for j := 0 ...

  FINALLY
    FilterGraph2 := NIL;
    GraphBuilder := NIL;
  END;

END;

PROCEDURE TFilterBank.SaveToINI(VAR IniFile: TMemIniFile; CONST INISection,
  INIEnabled, ININame, INICategory, INICLSID, INIState: STRING);
// Save filter info to INI.
VAR
  i                                : integer;
BEGIN
  IniFile.WriteBool(INISection, INIEnabled, FEnabled);

  FOR i := 0 TO Count - 1 DO BEGIN
    IniFile.WriteString(INISection, IntToStr(i + 1) + ININame, Filters[i].Name);
    IniFile.WriteString(INISection, IntToStr(i + 1) + INICategory, Filters[i].Category);
    IniFile.WriteString(INISection, IntToStr(i + 1) + INICLSID, GUIDToString(Filters[i].CLSID));
    IniFile.WriteInteger(INISection, IntToStr(i + 1) + INIState, integer(Filters[i].FilterAction));
  END;
END;

PROCEDURE TFilterBank.LoadFromINI(VAR IniFile: TMemIniFile; CONST INISection,
  INIEnabled, ININame, INICategory, INICLSID, INIState: STRING);
// Load filter information from INI.
VAR
  i, filtact                       : integer;
  filtname, filtcat, filtclsid     : STRING;
  filtguid                         : TGUID;
BEGIN
  RemoveAll;
  FEnabled := IniFile.ReadBool(INISection, INIEnabled, false);

  i := 1;
  REPEAT
    filtname := IniFile.ReadString(INISection, IntToStr(i) + ININame, '??');
    filtcat := IniFile.ReadString(INISection, IntToStr(i) + INICategory, '??');
    filtclsid := IniFile.ReadString(INISection, IntToStr(i) + INICLSID, '??');
    filtact := IniFile.ReadInteger(INISection, IntToStr(i) + INIState, ord(faNone));

    IF (filtname <> '??') AND (filtcat <> '??') THEN BEGIN
      TRY
        filtguid := StringToGUID(filtclsid); // trying to convert
      EXCEPT
        filtguid := NilGUID; // use nil if conversion failed
      END;
      Insert(filtcat, filtname, filtguid, TFilterAction(filtact));
    END;
    Inc(i);
  UNTIL (filtname = '??') OR (filtcat = '??');
END;

END.
