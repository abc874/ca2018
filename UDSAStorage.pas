unit UDSAStorage;

{$I Information.inc}

// basic review and reformatting: done

interface

uses
  // Delphi
  System.Classes, System.UITypes, Vcl.Dialogs, Vcl.Graphics;

//--------------------------------------------------------------------------------------------------
// Custom "Don't Show Again" (DSA) dialog registration
//--------------------------------------------------------------------------------------------------

function RegisterDSAMessage(const Name: string; const Description: string): Integer; overload;
function RegisterDSAQuestion(const Name: string; const Description: string): Integer; overload;
function RegisterDSAWarning(const Name: string; const Description: string): Integer; overload;

function RegisterDSAMessage(const DlgID: Integer; const Name: string; const Description: string): Integer; overload;
function RegisterDSAQuestion(const DlgID: Integer; const Name: string; const Description: string): Integer; overload;
function RegisterDSAWarning(const DlgID: Integer; const Name: string; const Description: string): Integer; overload;

// Additional values for DefaultButton, CancelButton and HelpButton parameters

const
  mbNone    = TMsgDlgBtn(-1);
  mbDefault = TMsgDlgBtn(-2);

  //--------------------------------------------------------------------------------------------------
  // "Don't Show Again" (DSA) dialogs
  //--------------------------------------------------------------------------------------------------

procedure DSAShowMessage(const DlgID: Integer; const Msg: string; const Timeout: Integer = 0);

procedure DSAShowMessageFmt(const DlgID: Integer; const Msg: string; const Params: array of const; const Timeout: Integer = 0);

function DSAMessageDlg(const DlgID: Integer; const Msg: string; const DlgType: TMsgDlgType;
  const Buttons: TMsgDlgButtons; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: TMsgDlgBtn = mbDefault;
  const CancelButton: TMsgDlgBtn = mbDefault; const HelpButton: TMsgDlgBtn = mbHelp): TModalResult; overload;
function DSAMessageDlg(const DlgID: Integer; const Caption, Msg: string; const DlgType: TMsgDlgType;
  const Buttons: TMsgDlgButtons; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: TMsgDlgBtn = mbDefault;
  const CancelButton: TMsgDlgBtn = mbDefault; const HelpButton: TMsgDlgBtn = mbHelp): TModalResult; overload;
function DSAMessageDlg(const DlgID: Integer; const Caption, Msg: string; const Picture: TGraphic;
  const Buttons: TMsgDlgButtons; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: TMsgDlgBtn = mbDefault;
  const CancelButton: TMsgDlgBtn = mbDefault; const HelpButton: TMsgDlgBtn = mbHelp): TModalResult; overload;

function DSAMessageDlgEx(const DlgID: Integer; const Msg: string; const DlgType: TMsgDlgType;
  const Buttons: array of string; const Results: array of Integer; const HelpCtx: Longint;
  const Timeout: Integer = 0;
  const DefaultButton: Integer = 0; const CancelButton: Integer = 1; const HelpButton: Integer = -1): Integer; overload;
function DSAMessageDlgEx(const DlgID: Integer; const Caption, Msg: string; const DlgType: TMsgDlgType;
  const Buttons: array of string; const Results: array of Integer; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: Integer = 0;
  const CancelButton: Integer = 1; const HelpButton: Integer = -1): TModalResult; overload;
function DSAMessageDlgEx(const DlgID: Integer; const Caption, Msg: string; const Picture: TGraphic;
  const Buttons: array of string; const Results: array of Integer; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: Integer = 0;
  const CancelButton: Integer = 1; const HelpButton: Integer = -1): Integer; overload;

//----------------------------------------------------------------------------
// DSA state setting/retrieving
//----------------------------------------------------------------------------

function GetDSAState(const DlgID: Integer): Boolean; overload;
function GetDSAState(const DlgID: Integer; OUT LastResult: Integer): Boolean; overload;
procedure SetDSAState(const DlgID: Integer; const DontShowAgain: Boolean;
  const LastResult: Integer = mrNone);

//----------------------------------------------------------------------------
// DSA state loading/saving
//----------------------------------------------------------------------------
procedure LoadDSAStates(const DSAData: TStrings);
procedure SaveDSAStates(const DSAData: TStrings);

implementation

uses JvDSADialogs,
  SysUtils,
  StrUtils;

var
  DSAStorage                       : TDSAStorage;
  DlgID                            : Integer;

function RegisterDSADialog(
  const DlgID: Integer;
  const Name: string;
  const Description: string;
  const CheckTextKind: TDSACheckTextKind): Integer; overload;
begin
  JvDSADialogs.RegisterDSA(DlgID, Name, Description, DSAStorage, CheckTextKind);
  if DlgID > UDSAStorage.DlgID then
    UDSAStorage.DlgID := DlgID;
  Result := DlgID;
end;

function RegisterDSADialog(
  const Name: string;
  const Description: string;
  const CheckTextKind: TDSACheckTextKind): Integer; overload;
begin
  JvDSADialogs.RegisterDSA(DlgID + 1, Name, Description, DSAStorage, CheckTextKind);
  DlgID := DlgID + 1;
  Result := DlgID;
end;

function RegisterDSAMessage(const Name: string; const Description: string): Integer;
begin
  Result := RegisterDSADialog(Name, Description, ctkShow);
end;

function RegisterDSAQuestion(const Name: string; const Description: string): Integer;
begin
  Result := RegisterDSADialog(Name, Description, ctkAsk);
end;

function RegisterDSAWarning(const Name: string; const Description: string): Integer;
begin
  Result := RegisterDSADialog(Name, Description, ctkWarn);
end;


function RegisterDSAMessage(const DlgID: Integer; const Name: string; const Description: string): Integer;
begin
  Result := RegisterDSADialog(DlgID, Name, Description, ctkShow);
end;

function RegisterDSAQuestion(const DlgID: Integer; const Name: string; const Description: string): Integer;
begin
  Result := RegisterDSADialog(DlgID, Name, Description, ctkAsk);
end;

function RegisterDSAWarning(const DlgID: Integer; const Name: string; const Description: string): Integer;
begin
  Result := RegisterDSADialog(DlgID, Name, Description, ctkWarn);
end;

procedure DSAShowMessage(const DlgID: Integer; const Msg: string;
  const Timeout: Integer = 0);
begin
  JvDSADialogs.DSAShowMessage(DlgID, Msg, dckActiveForm, Timeout);
end;

procedure DSAShowMessageFmt(const DlgID: Integer; const Msg: string; const Params: array of const;
  const Timeout: Integer = 0);
begin
  JvDSADialogs.DSAShowMessageFmt(DlgID, Msg, Params, dckActiveForm, Timeout);
end;

function DSAMessageDlg(const DlgID: Integer; const Msg: string; const DlgType: TMsgDlgType;
  const Buttons: TMsgDlgButtons; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: TMsgDlgBtn = mbDefault;
  const CancelButton: TMsgDlgBtn = mbDefault; const HelpButton: TMsgDlgBtn = mbHelp): TModalResult;
begin
  Result := JvDSADialogs.DSAMessageDlg(DlgID, Msg, DlgType, Buttons, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
end;

function DSAMessageDlg(const DlgID: Integer; const Caption, Msg: string; const DlgType: TMsgDlgType;
  const Buttons: TMsgDlgButtons; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: TMsgDlgBtn = mbDefault;
  const CancelButton: TMsgDlgBtn = mbDefault; const HelpButton: TMsgDlgBtn = mbHelp): TModalResult;
begin
  Result := JvDSADialogs.DSAMessageDlg(DlgID, Msg, DlgType, Buttons, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
end;

function DSAMessageDlg(const DlgID: Integer; const Caption, Msg: string; const Picture: TGraphic;
  const Buttons: TMsgDlgButtons; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: TMsgDlgBtn = mbDefault;
  const CancelButton: TMsgDlgBtn = mbDefault; const HelpButton: TMsgDlgBtn = mbHelp): TModalResult;
begin
  Result := JvDSADialogs.DSAMessageDlg(DlgID, Caption, Msg, Picture, Buttons, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
end;

function DSAMessageDlgEx(const DlgID: Integer; const Msg: string; const DlgType: TMsgDlgType;
  const Buttons: array of string; const Results: array of Integer; const HelpCtx: Longint;
  const Timeout: Integer = 0;
  const DefaultButton: Integer = 0; const CancelButton: Integer = 1; const HelpButton: Integer = -1): Integer; overload;
begin
  Result := JvDSADialogs.DSAMessageDlgEx(DlgID, Msg, DlgType, Buttons, Results, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
end;

function DSAMessageDlgEx(const DlgID: Integer; const Caption, Msg: string; const DlgType: TMsgDlgType;
  const Buttons: array of string; const Results: array of Integer; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: Integer = 0;
  const CancelButton: Integer = 1; const HelpButton: Integer = -1): TModalResult; overload;
begin
  Result := JvDSADialogs.DSAMessageDlgEx(DlgID, Caption, Msg, DlgType, Buttons, Results, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
end;

function DSAMessageDlgEx(const DlgID: Integer; const Caption, Msg: string; const Picture: TGraphic;
  const Buttons: array of string; const Results: array of Integer; const HelpCtx: Longint;
  const Timeout: Integer = 0; const DefaultButton: Integer = 0;
  const CancelButton: Integer = 1; const HelpButton: Integer = -1): Integer; overload;
begin
  Result := JvDSADialogs.DSAMessageDlgEx(DlgID, Caption, Msg, Picture, Buttons, Results, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
end;

//----------------------------------------------------------------------------
// DSA state setting/retrieving
//----------------------------------------------------------------------------

function GetDSAState(const DlgID: Integer): Boolean;
begin
  Result := JvDSADialogs.GetDSAState(DlgID);
end;

function GetDSAState(const DlgID: Integer; OUT LastResult: Integer): Boolean;
begin
  Result := JvDSADialogs.GetDSAState(DlgID, LastResult);
end;

procedure SetDSAState(const DlgID: Integer; const DontShowAgain: Boolean; const LastResult: Integer = mrNone);
begin
  JvDSADialogs.SetDSAState(DlgID, DontShowAgain, LastResult);
end;

//----------------------------------------------------------------------------
// DSA state loading/saving
//----------------------------------------------------------------------------

procedure LoadDSAStates(const DSAData: TStrings);
  function NextWord(var s: string): Integer;
  var
    delimPos: Integer;
  begin
    delimPos := Pos(';', s);
    if delimPos > 0 then
    begin
      Result := StrToIntDef(Copy(s, 1, delimPos - 1), -1);
      Delete(s, 1, delimPos);
    end else
      Result := -1;
  end;
var
  item: string;
  idx, dlgID, DontShowAgain, LastResult, Check: Integer;
begin
  if Assigned(DSAData) then
  begin
    for idx := 0 to Pred(DSAData.Count) do
    begin
      item := DSAData.Strings[idx];
      dlgID := NextWord(item);
      LastResult := NextWord(item);
      DontShowAgain := NextWord(item);
      Check := NextWord(item);

      if (Check > 0) and (Check = dlgID + LastResult + DontShowAgain) then
        if (dlgId <> -1) and (LastResult <> -1) and (DontShowAgain <> -1) then
          JvDSADialogs.SetDSAState(dlgId, DontShowAgain = 0, LastResult);
    end;
  end;
end;

procedure SaveDSAStates(const DSAData: TStrings);
var
  item: TDSARegItem;
  idx, LastResult, DontShowAgain: Integer;
begin
  if Assigned(DSAData) then
  begin
    for idx := 0 to Pred(JvDSADialogs.DSACount) do
    begin
      item := JvDSADialogs.DSAItem(idx);
      if DSAStorage.GetState(item, LastResult) then
        DontShowAgain := 0
      else
        DontShowAgain := 1;
      DSAData.Append(Format('%d;%d;%d;%d', [item.ID, LastResult, DontShowAgain, item.ID + LastResult + DontShowAgain]));
    end;
  end;
end;

initialization
  DlgID := -1;
  DSAStorage := TDSAQueueStorage.Create;
finalization
  FreeAndNil(DSAStorage);
end.

