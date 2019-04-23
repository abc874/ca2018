unit ReplaceList;

{$I Information.inc}

interface

uses
  // Delphi
  System.Classes, System.IniFiles, System.SysUtils, Vcl.Controls;

type
  TReplaceList = class(TStringList) // QnD list, no generics
  public
    procedure LoadFromDialogFrames(AParent: TWinControl);
    procedure LoadFromIni(AIni: TCustomIniFile);
    procedure SaveToDialogFrames(AParent: TWinControl);
    procedure SaveToIni(AIni: TCustomIniFile);
    function SearchAndReplace(const AString: string): string;
  end;

implementation

uses
  // Delphi
  System.RegularExpressions,

  // CA
  ReplaceFrame;

const
  cIniSection      = 'SearchAndReplace'; // don't localize !!!
  cIniIdentCount   = 'Count';
  cIniIdentSearch  = 'Search';
  cIniIdentReplace = 'Replace';
  cIniIdentRegEx   = 'RegEx';
  cIniIdentActive  = 'Active';

type
  TReplaceItem = class(TObject)
  public
    Search, Replace: string;
    RegEx, Active: Boolean;
    constructor Create(const ASearch, AReplace: string; ARegEx, AActive: Boolean);
  end;

function IniWrap(const AString: string): string;
begin
  Result := '"' + AString + '"';
end;

function IniUnWrap(const AString: string): string;
begin
  Result := AString;

  if (Result <> '') and (Result[1] = '"') then
    Delete(Result, 1, 1);

  if (Result <> '') and (Result[Length(Result)] = '"') then
    Delete(Result, Length(Result), 1);
end;

{ TReplaceItem }

constructor TReplaceItem.Create(const ASearch, AReplace: string; ARegEx, AActive: Boolean);
begin
  Search  := ASearch;
  Replace := AReplace;
  RegEx   := ARegEx;
  Active  := AActive;
end;

{ TReplaceList }

procedure TReplaceList.LoadFromDialogFrames(AParent: TWinControl);
var
  I: Integer;
begin
  Clear;
  OwnsObjects := True;

  if Assigned(AParent) then
    for I := 0 to Pred(AParent.ControlCount) do
      if AParent.Controls[I] is TReplaceFrame then with TReplaceFrame(AParent.Controls[I]) do
        AddObject(IntToHex(Top, 8), TReplaceItem.Create(edSearch.Text, edReplace.Text, cbRegEx.Checked, cbActive.Checked));

  Sort; // Top frame first
end;

procedure TReplaceList.LoadFromIni(AIni: TCustomIniFile);
var
  I,J: Integer;
  S: string;
begin
  Clear;
  OwnsObjects := True;

  if Assigned(AIni) then
  begin
    J := AIni.ReadInteger(cIniSection, cIniIdentCount, 0);

    if J = 0 then
      J := 1; // Create at least one frame

    for I := 0 to Pred(J) do
    begin
      S := IntToStr(I);

      AddObject(IntToHex(I, 8), TReplaceItem.Create(
        IniUnWrap(AIni.ReadString(cIniSection, cIniIdentSearch + S, '')),
        IniUnWrap(AIni.ReadString(cIniSection, cIniIdentReplace + S, '')),
        AIni.ReadBool(cIniSection, cIniIdentRegEx + S, False),
        AIni.ReadBool(cIniSection, cIniIdentActive + S, False)));
    end;
  end;
end;

procedure TReplaceList.SaveToDialogFrames(AParent: TWinControl);
var
  I: Integer;
begin
  if Assigned(AParent) then
  begin
    for I := Pred(AParent.ControlCount) downto 0 do
      if AParent.Controls[I] is TReplaceFrame then
        AParent.Controls[I].Free;

    TReplaceFrame.FrameCount := 0;

    for I := 0 to Pred(Count) do
      with TReplaceFrame.Create(AParent.Owner) do
      begin
        Inc(TReplaceFrame.FrameCount);

        Name := 'ReplaceFrame' + IntToStr(TReplaceFrame.FrameCount);
        Top  := 111 * I;

        with TReplaceItem(Objects[I]) do
        begin
          edSearch.Text    := Search;
          edReplace.Text   := Replace;
          cbRegEx.Checked  := RegEx;
          cbActive.Checked := Active;
        end;

        Parent := AParent;
      end;
  end;
end;

procedure TReplaceList.SaveToIni(AIni: TCustomIniFile);
var
  I: Integer;
  S: string;
begin
  if Assigned(AIni) then
  begin
    AIni.WriteInteger(cIniSection, cIniIdentCount, Count);

    for I := 0 to Pred(Count) do with TReplaceItem(Objects[I]) do
    begin
      S := IntToStr(I);

      AIni.WriteString(cIniSection, cIniIdentSearch + S, IniWrap(Search));
      AIni.WriteString(cIniSection, cIniIdentReplace + S, IniWrap(Replace));
      AIni.WriteBool(cIniSection, cIniIdentRegEx + S, RegEx);
      AIni.WriteBool(cIniSection, cIniIdentActive + S, Active);
    end;
  end;
end;

function TReplaceList.SearchAndReplace(const AString: string): string;
var
  I: Integer;
  R: TRegEx;
begin
  Result := AString;

  for I := 0 to Pred(Count) do with TReplaceItem(Objects[I]) do if Search <> '' then
  begin
    if RegEx then
    begin
      R.Create(Search);
      Result := R.Replace(Result, Replace);
    end else
      Result := StringReplace(Result, Search, Replace, [rfReplaceAll]);
  end;
end;

end.

