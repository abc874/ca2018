UNIT ManageFilters;

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
  StdCtrls,
  ComCtrls,
  DSPack,
  DSUtil,
  DirectShow9,
  Utils,
  JvExStdCtrls,
  JvCheckBox;

TYPE
  TFManageFilters = CLASS(TForm)
    cmdRemove: TButton;
    cmdClose: TButton;
    lvFilters: TListBox;
    cmdCopy: TButton;
    lblClickOnFilter: TLabel;
    chkShowPinInfo: TJvCheckBox;
    PROCEDURE cmdCloseClick(Sender: TObject);
    PROCEDURE FormShow(Sender: TObject);
    PROCEDURE lvFiltersClick(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE cmdRemoveClick(Sender: TObject);
    PROCEDURE FormDestroy(Sender: TObject);
    PROCEDURE cmdCopyClick(Sender: TObject);
    PROCEDURE lvFiltersDblClick(Sender: TObject);
    PROCEDURE FormClose(Sender: TObject; VAR Action: TCloseAction);
    procedure chkShowPinInfoClick(Sender: TObject);
  PRIVATE
    FilterList: TFIlterList;
    PinList: TPinList;
    { Private declarations }
    PROCEDURE refresh_FilterList(Graph: TFilterGraph);
  PUBLIC
    { Public declarations }
    SourceGraph: TFilterGraph;
  END;

VAR
  FManageFilters                   : TFManageFilters;

IMPLEMENTATION

{$R *.dfm}

USES Main,
  ComObj;

PROCEDURE TFManageFilters.cmdCloseClick(Sender: TObject);
BEGIN
  self.Hide;
END;

PROCEDURE TFManageFilters.FormShow(Sender: TObject);
BEGIN
  // Show taskbar button for this form ...
  // SetWindowLong(Handle, GWL_ExStyle, WS_Ex_AppWindow);
  Refresh_Filterlist(self.SourceGraph);
END;

PROCEDURE TFManageFilters.refresh_FilterList(Graph: TFilterGraph);
VAR
  BaseFilter, cFilter              : IBaseFilter;
  cPin                             : IPin;
  iFilter, iPin                    : Integer;
  pinInfo                          : _PinInfo;
  FUNCTION FormatBaseFilter(CONST bf: IBaseFilter): STRING;
  VAR
    guid                           : TGUID;
    fi                             : _FilterInfo;
  BEGIN
    Result := '';
    IF NOT Assigned(bf) THEN Exit;
    bf.GetClassID(guid);
    bf.QueryFilterInfo(fi);
    Result := fi.achName + ' (' + GUIDToString(guid) + ')';
  END;
BEGIN
  IF NOT graph.Active THEN exit;
  graph.Stop;
  FilterList.Assign(Graph AS IFIlterGRaph);

  lvFilters.Clear;
  FOR iFilter := 0 TO FilterList.Count - 1 DO BEGIN
    BaseFilter := FilterLIst.Items[iFilter];
    lvFilters.Items.Add('|-' + FormatBaseFilter(BaseFilter));
    IF chkShowPinInfo.Checked THEN BEGIN
      PinList.Assign(BaseFilter);
      FOR iPin := 0 TO PinList.Count - 1 DO BEGIN
        cFilter := NIL;
        IF Succeeded(PinList.Items[iPin].ConnectedTo(cPin)) THEN
          IF Succeeded(cpin.QueryPinInfo(pinInfo)) THEN
            cFilter := pinInfo.pFilter;
        lvFilters.Items.Add('|--- ' + PinList.PinInfo[iPin].achName + ' => ' + FormatBaseFilter(cFilter));
      END;
    END;
  END;
END;

PROCEDURE TFManageFilters.lvFiltersClick(Sender: TObject);
VAR
  iItem                            : Integer;
  sel                              : boolean;
BEGIN
  sel := false;
  FOR iItem := 0 TO lvFilters.Items.count - 1 DO BEGIN
    IF lvFilters.Selected[iItem] THEN sel := true;
  END;
  self.cmdRemove.Enabled := sel;
END;


PROCEDURE TFManageFilters.cmdRemoveClick(Sender: TObject);
VAR
  iItem, iFIlter                   : Integer;
BEGIN
  exit; //*********************** funktioniert noch nicht richtig

  lvFiltersClick(self);
  IF cmdRemove.Enabled = false THEN exit;

  FOR iItem := 0 TO lvFilters.Items.count - 1 DO BEGIN
    IF lvFilters.Selected[iItem] THEN break;
  END;

  CASE (SourceGraph AS IFIlterGRaph).RemoveFilter(filterlist.Items[iItem]) OF
    S_OK: showmessage('Removed.');
  ELSE showmessage('Failed.');
  END;
  FilterList.Update;

  lvFilters.Clear;
  FOR iFilter := 0 TO FilterList.Count - 1 DO BEGIN
    lvFilters.Items.Add(FilterList.FilterInfo[iFIlter].achName);
  END;

END;

PROCEDURE TFManageFilters.FormCreate(Sender: TObject);
BEGIN
  FIlterLIst := TFilterLIst.Create;
  PinList := TPinList.Create;
END;

PROCEDURE TFManageFilters.FormDestroy(Sender: TObject);
BEGIN
  FreeAndNIL(FilterList);
  FreeAndNil(PinList);
END;

PROCEDURE TFManageFilters.cmdCopyClick(Sender: TObject);
BEGIN
  ListBoxToClipboard(self.lvFilters, 255, true);
END;

PROCEDURE TFManageFilters.lvFiltersDblClick(Sender: TObject);
VAR
  Index                            : INteger;
BEGIN
  //Index := self.lvFilters.ItemAtPos(Mouse.CursorPos, true);
  Index := self.lvFilters.ItemIndex;
  IF Index >= 0 THEN BEGIN
    ShowFilterPropertyPage(self.Handle, FilterList.Items[Index]);
  END;
END;

PROCEDURE TFManageFilters.FormClose(Sender: TObject;
  VAR Action: TCloseAction);
BEGIN
  Action := caHide;
  ModalResult := mrOk;
END;

procedure TFManageFilters.chkShowPinInfoClick(Sender: TObject);
begin
  self.refresh_FilterList(self.SourceGraph);
end;

END.

