unit ManageFilters;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, Vcl.StdCtrls, Vcl.Controls, Vcl.Forms,

  // Jedi
  JvExStdCtrls, JvCheckBox,

  // DSPack
  DSPack, DXSUtils;

type
  TFManageFilters = class(TForm)
    cmdRemove: TButton;
    cmdClose: TButton;
    lvFilters: TListBox;
    cmdCopy: TButton;
    lblClickOnFilter: TLabel;
    chkShowPinInfo: TJvCheckBox;
    procedure cmdCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvFiltersClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmdRemoveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmdCopyClick(Sender: TObject);
    procedure lvFiltersDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkShowPinInfoClick(Sender: TObject);
  private
    { private declarations }
    FilterList: TFIlterList;
    PinList: TPinList;
    procedure refresh_FilterList(Graph: TFilterGraph);
  public
    { public declarations }
    SourceGraph: TFilterGraph;
  end;

var
  FManageFilters: TFManageFilters;

implementation

{$R *.dfm}

uses
  // Delphi
  Winapi.DirectShow9, Winapi.ActiveX, System.SysUtils,

  // CA
  Main, Utils;

procedure TFManageFilters.cmdCloseClick(Sender: TObject);
begin
  Hide;
end;

procedure TFManageFilters.FormShow(Sender: TObject);
begin
  Refresh_Filterlist(SourceGraph);
end;

procedure TFManageFilters.refresh_FilterList(Graph: TFilterGraph);
  function FormatBaseFilter(const bf: IBaseFilter): string;
  var
    guid: TGUID;
    fi: _FilterInfo;
  begin
    if Assigned(bf) then
    begin
      bf.GetClassID(guid);
      bf.QueryFilterInfo(fi);
      Result := fi.achName + ' (' + GUIDToString(guid) + ')';
    end else
      Result := '';
  end;
var
  BaseFilter, cFilter: IBaseFilter;
  cPin: IPin;
  iFilter, iPin: Integer;
  pinInfo: _PinInfo;
begin
  if not graph.Active then Exit;
  graph.Stop;
  FilterList.Assign(Graph as IFIlterGRaph);

  lvFilters.Clear;
  for iFilter := 0 to Pred(FilterList.Count) do
  begin
    BaseFilter := FilterLIst.Items[iFilter];
    lvFilters.Items.AddObject('|-' + FormatBaseFilter(BaseFilter), Pointer(100 + iFilter));
    if chkShowPinInfo.Checked then
    begin
      PinList.Assign(BaseFilter);
      for iPin := 0 to Pred(PinList.Count) do
      begin
        cFilter := nil;
        if Succeeded(PinList.Items[iPin].ConnectedTo(cPin)) and Succeeded(cpin.QueryPinInfo(pinInfo)) then
          cFilter := pinInfo.pFilter;

        lvFilters.Items.Add('|--- ' + PinList.PinInfo[iPin].achName + ' => ' + FormatBaseFilter(cFilter));
      end;
    end;
  end;
end;

procedure TFManageFilters.lvFiltersClick(Sender: TObject);
var
  iItem: Integer;
  sel: Boolean;
begin
  sel := False;
  for iItem := 0 to Pred(lvFilters.Items.Count) do
    if lvFilters.Selected[iItem] then
    begin
      sel := True;
      Break;
    end;

  cmdRemove.Enabled := sel;
end;

procedure TFManageFilters.cmdRemoveClick(Sender: TObject);
var
  iItem, iFIlter: Integer;
begin
  Exit; // *********************** funktioniert noch nicht richtig

  lvFiltersClick(lvFilters);

  if cmdRemove.Enabled then
  begin
    for iItem := 0 to Pred(lvFilters.Items.Count) do
      if lvFilters.Selected[iItem] then
        Break;

    if (SourceGraph as IFIlterGRaph).RemoveFilter(filterlist.Items[iItem]) = S_OK then
      InfMsg('Removed.')
    else
      InfMsg('Failed.');

    FilterList.Update;

    lvFilters.Clear;
    for iFilter := 0 to Pred(FilterList.Count) do
      lvFilters.Items.Add(FilterList.FilterInfo[iFIlter].achName);
  end;
end;

procedure TFManageFilters.FormCreate(Sender: TObject);
begin
  FIlterLIst := TFilterLIst.Create;
  PinList    := TPinList.Create;

  if not cmdRemove.Visible then
    lblClickOnFilter.Left := cmdRemove.Left;
end;

procedure TFManageFilters.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FilterList);
  FreeAndNil(PinList);
end;

procedure TFManageFilters.cmdCopyClick(Sender: TObject);
begin
  ListBoxToClipboard(lvFilters, True);
end;

procedure TFManageFilters.lvFiltersDblClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := lvFilters.ItemIndex;
  if Index >= 0 then
  begin
    if chkShowPinInfo.Checked then  // find real index
    begin
      while (Index >= 0) and lvFilters.Items[Index].StartsWith('|---') do
        Dec(Index);

      Index := Integer(lvFilters.Items.Objects[Index]) - 100;
    end;

    ShowFilterPropertyPage(Handle, FilterList.Items[Index]);
  end;
end;

procedure TFManageFilters.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
  ModalResult := mrOk;
end;

procedure TFManageFilters.chkShowPinInfoClick(Sender: TObject);
begin
  refresh_FilterList(SourceGraph);
end;

end.

