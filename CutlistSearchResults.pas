unit CutlistSearchResults;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  Winapi.Windows, System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFCutlistSearchResults = class(TForm)
    pnlButtons: TPanel;
    lvLinklist: TListView;
    cmdCancel: TButton;
    cmdOk: TButton;
    procedure lvLinklistClick(Sender: TObject);
    procedure cmdOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lvLinklistCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvLinklistColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvLinklistCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
  private
    { private declarations }
    SortColNr: Integer; // first col = 1
  public
    { public declarations }
    MovieTypeName: string;
  end;

var
  FCutlistSearchResults: TFCutlistSearchResults;

implementation

{$R *.dfm}

uses
  // Delphi
  Winapi.CommCtrl, System.Math, Vcl.Graphics,

  // CA
  Main, Utils;

{ TFCutlistSearchResults }

procedure TFCutlistSearchResults.FormClose(Sender: TObject; var Action: TCloseAction);
var
  S: string;
  I: Integer;
begin
  // Save window size and column widths

  S := Format('%d,%d', [Width, Height]);

  for I := 0 to Pred(lvLinklist.Columns.Count) do
    S := S + Format(',%d', [lvLinklist.Columns[I].Width]);

  Settings.Additional[ClassName] := S;
end;

procedure TFCutlistSearchResults.FormCreate(Sender: TObject);
var
  S: string;
  function GetOneInt: Integer;
  begin
    Result := StrToIntDef(StringToken(S, ','), 0);
  end;
var
  W,H,I: Integer;
begin
  // Restore window size and column widths

  S := Settings.Additional[ClassName];

  if S <> '' then
  begin
    W := GetOneInt;
    H := GetOneInt;

    if (W > 0) and (H > 0) then
    begin
      Width  := W;
      Height := H;

      for I := 0 to Pred(lvLinklist.Columns.Count) do
        lvLinklist.Columns[I].Width := GetOneInt;
    end;
  end;
end;

procedure TFCutlistSearchResults.lvLinklistClick(Sender: TObject);
begin
  if lvLinklist.ItemIndex >= 0 then
    ModalResult := mrOK;
end;

procedure TFCutlistSearchResults.lvLinklistColumnClick(Sender: TObject; Column: TListColumn);
var
  Header: HWND;
  Item: THDItem;
  I: Integer;
begin
  Header := ListView_GetHeader(lvLinklist.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;

  I := Succ(Column.Index);

  if Abs(SortColNr) <> I then  // other col
  begin
    if SortColNr <> 0 then
    begin
      Header_GetItem(Header, Pred(Abs(SortColNr)), Item);
      Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN);
      Header_SetItem(Header, Pred(Abs(SortColNr)), Item);
    end;
    SortColNr := I;
  end else
    SortColNr := - SortColNr;  // switch asc/desc

  lvLinklist.AlphaSort;

  Header_GetItem(Header, Column.Index, Item);

  Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN);
  if SortColNr < 0 then
    Item.fmt := Item.fmt or HDF_SORTDOWN
  else
    Item.fmt := Item.fmt or HDF_SORTUP;

  Header_SetItem(Header, Column.Index, Item);
end;

procedure TFCutlistSearchResults.lvLinklistCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  I:Integer;
begin
  if Abs(SortColNr) > 1 then // 1 = first col
  begin
    I := Abs(SortColNr) - 2;
    Compare := Sign(SortColNr) * CompareText(Item1.SubItems[I], Item2.SubItems[I]);
  end else
    Compare := Sign(SortColNr) * CompareText(Item1.Caption, Item2.Caption)
end;

procedure TFCutlistSearchResults.lvLinklistCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if SubItem = 2 then
  begin
    if MovieTypeName = Item.SubItems[1] then
      lvLinklist.Canvas.Brush.Color := clMoneyGreen
    else
      lvLinklist.Canvas.Brush.Color := clWebLightYellow;
  end else
    lvLinklist.Canvas.Brush.Color := ColorToRGB(lvLinklist.Color);
end;

procedure TFCutlistSearchResults.cmdOkClick(Sender: TObject);
begin
  if lvLinklist.ItemIndex >= 0 then
    ModalResult := mrOk;
end;

end.

