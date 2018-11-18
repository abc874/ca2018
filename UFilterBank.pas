(*
From progdigy.com Forum posted by XXX on Mon 2004-11-08 07.50 pm

I created object 'TFilterBank' providing connecting/disconnecting desired filters.
What is this good for? for situations like this:
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
   { private declarations }
   FilterBank : TFilterBank;
   procedure LoadAVI(const aviname : TFileName);
 public
   { public declarations }
 end;

var
 MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
begin
  FilterBank := TFilterBank.Create;
  FilterBank.Enabled := True;
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
     FilterGraph.Active := False;
     FreeAndNil(FilterBank);
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
       if not FilterGraph.Active then FilterGraph.Active := True;
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


unit UFilterBank;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.DirectShow9, System.SysUtils, System.IniFiles,

  // DSPack
  DSPack, DXSUtils;

type
  TFilterAction = (faNone, faInsert, faRemove);

  TFilterItem = record
    FilterAction: TFilterAction;
    Category, Name: string;
    CLSID: TGUID;
  end;

  TFilterBank = class
  private
    FEnabled: Boolean;
    FTemp: Boolean; // temporary flag (rewrite 'TempFilters' to 'Filters' during next 'Init')
    FFilters: array of TFilterItem; // main filter list
    FTempFilters: array of TFilterItem; // temporary filter list
    FBaseFilters: array of IBaseFilter; // pointers to filters
    function GetCount: Integer;
    function GetItem(const index: Integer): TFilterItem;
    function CreateFilter(const CategoryName, FilterName: string; const aFilterCLSID: TGUID): IBaseFilter;
  public
    { constructor method. }
    constructor Create;
    { destructor method. }
    destructor Destroy; override;
    { Insert filter (category, name or CLSID) to filter list (temporary). }
    procedure Insert(const aCategory, aName: string; const aCLSID: TGUID; const aFilterAction: TFilterAction);
    { Remove filter from filter list (temporary). }
    procedure Remove(const index: Integer);
    { Remove all filters from filter list (temporary). }
    procedure RemoveAll;
    { Initialize/create filters in filter list. Method rewrites all changes in <br>
      temporary filter list to main filter list first.}
    procedure FiltersInit;
    { Free all filters from filter list. }
    procedure FiltersDestroy;
    { Connect filters to filtergraph. }
    procedure FiltersConnectToGraph(var FilterGraph: TFilterGraph);
    { Disconnect filters from filtergraph. }
    procedure FiltersDisconnectFromGraph(var FilterGraph: TFilterGraph);
    { Save filter list to Ini.}
    procedure SaveToIni(var IniFile: TMemIniFile; const IniSection, IniEnabled, IniName, IniCategory, IniCLSID, IniState: string);
    { Load filter list from Ini. }
    procedure LoadFromIni(var IniFile: TMemIniFile; const IniSection, IniEnabled, IniName, IniCategory, IniCLSID, IniState: string);
  public
    { Get filters count. }
    property Count: Integer read GetCount;
    { Enable property. }
    property Enabled: Boolean read FEnabled write FEnabled;
    { Filter list. }
    property Filters[const index: Integer]: TFilterItem read GetItem;
  end;

implementation

uses
  // Delphi
  Winapi.ActiveX;

const
  NilGUID : TGUID = '{00000000-0000-0000-0000-000000000000}';

constructor TFilterBank.Create;
begin
  FEnabled := True;
  FTemp := False; // temporary flag
  SetLength(FFilters, 0);
  SetLength(FTempFilters, 0);
  SetLength(FBaseFilters, 0);
end;

destructor TFilterBank.Destroy;
begin
  FiltersDestroy;
  SetLength(FTempFilters, 0);
  SetLength(FFilters, 0);
  SetLength(FBaseFilters, 0);
  inherited Destroy;
end;

function TFilterBank.GetCount: Integer;
begin
  if FTemp then // are there changes in temporary list? => read from it
    Result := Length(FTempFilters)
  else
    Result := Length(FFilters);
end;

function TFilterBank.GetItem(const index: Integer): TFilterItem; // Get filter information.
begin
  Result.FilterAction := faNone;
  Result.Category     := '';
  Result.Name         := '';
  Result.CLSID        := NilGUID;

  if FTemp then // are there changes in temporary list? => read from it
  begin
    if (index >= 0) and (index < Length(FTempFilters)) then
      Result := FTempFilters[index];
  end else
  begin // there are no changes in temporary list => read from main list
    if (index >= 0) and (index < Length(FFilters)) then
      Result := FFilters[index];
  end;
end;

function TFilterBank.CreateFilter(const CategoryName, FilterName: string; const aFilterCLSID: TGUID): IBaseFilter;
// Create filter by category and name or by its CLSID.
var
  SysDev: TSysdevEnum;
  i: Integer;
begin
  // non nil CLSID? => create filter by its CLSID
  if not IsEqualGUID(aFilterCLSID, NilGUID) then
    if CoCreateInstance(aFilterCLSID, nil, CLSCTX_INPROC_SERVER, IID_IBaseFilter, Result) = S_OK then
      Exit;

  Result := nil;

  SysDev := TSysDevEnum.Create;

  try
    i := sysdev.CountCategories - 1; // searching in categories
    while i >= 0 do
    begin
      if AnsiCompareText(SysDev.Categories[i].FriendlyName, CategoryName) = 0 then
        Break;
      Dec(i);
    end;

    if i < 0 then
      Exit; // find anything?

    SysDev.SelectIndexCategory(i);
    i := SysDev.CountFilters - 1; // searching in filter names
    while i >= 0 do begin
      if AnsiCompareText(SysDev.Filters[i].FriendlyName, FilterName) = 0 then
        Break;
      Dec(i);
    end;

    if i < 0 then
      Exit; // find anything?

    Result := sysdev.GetBaseFilter(i); // return 'IBaseFilter' interface
  finally
    FreeAndNil(sysdev);
  end; // try finally
end;

procedure TFilterBank.Insert(const aCategory, aName: string; const aCLSID: TGUID; const aFilterAction: TFilterAction);
// Insert filter to temporary list, sets temporary flag.
begin
  SetLength(FTempFilters, Length(FTempFilters) + 1); // add item

  with FTempFilters[Length(FTempFilters) - 1] do
  begin
    FilterAction := aFilterAction;
    Category     := aCategory;
    Name         := aName;
    CLSID        := aCLSID;
  end;

  FTemp := True; // set temporary flag
end;

procedure TFilterBank.Remove(const index: Integer); // Remove filter from temporary list.
var
  i: Integer;
begin
  if (index >= 0) and (index < Length(FTempFilters)) then
  begin
    if index < (Length(FFilters) - 1) then
      for i := index to Length(FFilters) - 1 do
        FTempFilters[i] := FTempFilters[i + 1];

    SetLength(FFilters, Length(FTempFilters) - 1);
  end;
  FTemp := True;
end;

procedure TFilterBank.RemoveAll; // Remove all items from temporary list.
begin
  SetLength(FTempFilters, 0);
  FTemp := True;
end;

procedure TFilterBank.FiltersInit; // Create filters.
var
  i: Integer;
begin
  if FEnabled then
  begin
    if FTemp then // changes in temporary list? => rewrite them to main list
    begin
      FiltersDestroy;
      SetLength(FFilters, Length(FTempFilters));     // allocate space for list
      SetLength(FBaseFilters, Length(FTempFilters)); // allocate space for interfaces

      for i := 0 to Pred(Length(FTempFilters)) do    // zkopiruju}
      begin
        FFilters[i] := FTempFilters[i];
        FBaseFilters[i] := nil;
      end;

      SetLength(FTempFilters, 0); // clear temporary list
      FTemp := False;
    end;

    for i := 0 to Pred(Length(FFilters)) do
    begin
      // insert this filter? => then must be created first
      if FFilters[i].FilterAction = faInsert then
        FBaseFilters[i] := CreateFilter(FFilters[i].Category, FFilters[i].Name, FFilters[i].CLSID);
    end;
  end;
end;

procedure TFilterBank.FiltersDestroy; // Destroy filters.
var
  i: Integer;
begin
  for i := 0 to Pred(Length(FBaseFilters)) do
    FBaseFilters[i] := nil;
end;

procedure TFilterBank.FiltersConnectToGraph(var FilterGraph: TFilterGraph); // Connect filters to 'FilterGraph'.
var
  i: Integer;
  BaseFilter: IBaseFilter;
  s: WideString;
  FilterGraph2: IFilterGraph2;
begin
  if FEnabled then
  begin
    try
      if FilterGraph.QueryInterface(IID_IFilterGraph2, FilterGraph2) = S_OK then
      begin
        for i := 0 to Pred(Length(FFilters)) do
        begin
          // insert this filter?
          if (FFilters[i].FilterAction = faInsert) and Assigned(FBaseFilters[i]) then
          begin
            s := FFilters[i].Name; // widestring conversion
            // isn't filter in filtergraph? => insert it
            if FilterGraph2.FindFilterByName(PWideChar(s), BaseFilter) <> S_OK then
            begin
              FilterGraph2.AddFilter(FBaseFilters[i], PWideChar(s));
              BaseFilter := nil;
            end;
          end;
        end;
      end;
    finally
      FilterGraph2 := nil;
    end;
  end;
end;

procedure TFilterBank.FiltersDisconnectFromGraph(var FilterGraph: TFilterGraph); // Remove filter from 'FilterGraph'.
(*
  Picture describing variable names.

 previous filter     removed filter      following filter
             ---      ------------       ---
      OutPrevPin|----|InPin       |     |
                |    |            |     |
                |    |      OutPin|-----|InNextPin
             ---      ------------       ---
*)
var
  BaseFilter: IBaseFilter;
  OutPin, InPin, tmp: IPin;
  OutPrevPin, InNextPin: IPin;
  PinList, OutPinList, InPinList: TPinList;
  i, j: Integer;
  FilterGraph2: IFilterGraph2;
  GraphBuilder: IGraphBuilder;
begin
  if FEnabled then
  begin
    try
      if (FilterGraph.QueryInterface(IID_IFilterGraph2, FilterGraph2) = S_OK) and
         (FilterGraph.QueryInterface(IID_IGraphBuilder, GraphBuilder) = S_OK) then
      begin
        for j := 0 to Pred(Length(FFilters)) do
        begin
          if FFilters[j].FilterAction = faRemove then // remove this filter?
          begin
            // is filter in filtergraph? => Exit if not
            if FilterGraph2.FindFilterByName(StringToOleStr(FFilters[j].Name), BaseFilter) = S_OK then
            begin
              PinList    := TPinList.Create(BaseFilter); // get all pins
              InPinList  := TPinList.Create; // create list for input pins
              OutPinList := TPinList.Create; // create list for output pins

              try
                for i := 0 to Pred(PinList.Count) do // pass through all pins
                begin
                  // is pin connected? => save it to the list
                  if PinList.Items[i].ConnectedTo(tmp) = S_OK then
                  begin
                    tmp := nil;
                    case PinList.PinInfo[i].dir of
                      PINDIR_INPUT  : InPinList.Add(PinList.Items[i]);
                      PINDIR_OUTPUT : OutPinList.Add(PinList.Items[i]);
                    end;
                  end;
                end;

                // check - input and output pins count must agree
                if OutPinList.Count = InPinList.Count then
                begin
                  for i := 0 to Pred(InPinList.Count) do // reconnect all pins
                  begin
                    InPin  := InPinList.First;  // get next pin
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
                  end;

                  // remove filter
                  (FilterGraph as IGraphBuilder).RemoveFilter(BaseFilter);

                  InPin      := nil;
                  OutPin     := nil;
                  InNextPin  := nil;
                  OutPrevPin := nil;
                  BaseFilter := nil;
                end;
              finally
                FreeAndNil(PinList);
                FreeAndNil(OutPinList);
                FreeAndNil(InPinList);
              end;
            end;
          end; // if FFilters[j].FilterAction = faRemove
        end;   // for j := 0 ...
      end;
    finally
      FilterGraph2 := nil;
      GraphBuilder := nil;
    end;
  end;
end;

procedure TFilterBank.SaveToIni(var IniFile: TMemIniFile; const IniSection, IniEnabled, IniName, IniCategory, IniCLSID, IniState: string);
// Save filter info to Ini.
var
  i: Integer;
begin
  IniFile.WriteBool(IniSection, IniEnabled, FEnabled);

  for i := 0 to Pred(Count) do
  begin
    IniFile.WriteString(IniSection, IntToStr(i + 1) + IniName, Filters[i].Name);
    IniFile.WriteString(IniSection, IntToStr(i + 1) + IniCategory, Filters[i].Category);
    IniFile.WriteString(IniSection, IntToStr(i + 1) + IniCLSID, GUIDToString(Filters[i].CLSID));
    IniFile.WriteInteger(IniSection, IntToStr(i + 1) + IniState, Integer(Filters[i].FilterAction));
  end;
end;

procedure TFilterBank.LoadFromIni(var IniFile: TMemIniFile; const IniSection,
  IniEnabled, IniName, IniCategory, IniCLSID, IniState: string);
// Load filter information from Ini.
var
  i, filtact                       : Integer;
  filtname, filtcat, filtclsid     : string;
  filtguid                         : TGUID;
begin
  RemoveAll;
  FEnabled := IniFile.ReadBool(IniSection, IniEnabled, False);

  i := 1;
  repeat
    filtname := IniFile.ReadString(IniSection, IntToStr(i) + IniName, '??');
    filtcat := IniFile.ReadString(IniSection, IntToStr(i) + IniCategory, '??');
    filtclsid := IniFile.ReadString(IniSection, IntToStr(i) + IniCLSID, '??');
    filtact := IniFile.ReadInteger(IniSection, IntToStr(i) + IniState, Ord(faNone));

    if (filtname <> '??') and (filtcat <> '??') then
    begin
      try
        filtguid := StringToGUID(filtclsid); // trying to convert
      except
        filtguid := NilGUID; // use nil if conversion failed
      end;
      Insert(filtcat, filtname, filtguid, TFilterAction(filtact));
    end;
    Inc(i);
  until (filtname = '??') or (filtcat = '??');
end;

end.

