UNIT UDSAStorage;

INTERFACE

USES Classes,
  Controls,
  Dialogs,
  Graphics;

//--------------------------------------------------------------------------------------------------
// Custom "Don't Show Again" (DSA) dialog registration
//--------------------------------------------------------------------------------------------------

FUNCTION RegisterDSAMessage(CONST Name: STRING; CONST Description: STRING): Integer; overload;
FUNCTION RegisterDSAQuestion(CONST Name: STRING; CONST Description: STRING): Integer; overload;
FUNCTION RegisterDSAWarning(CONST Name: STRING; CONST Description: STRING): Integer; overload;

FUNCTION RegisterDSAMessage(CONST DlgID: integer; CONST Name: STRING; CONST Description: STRING): Integer; overload;
FUNCTION RegisterDSAQuestion(CONST DlgID: integer; CONST Name: STRING; CONST Description: STRING): Integer; overload;
FUNCTION RegisterDSAWarning(CONST DlgID: integer; CONST Name: STRING; CONST Description: STRING): Integer; overload;

// Additional values for DefaultButton, CancelButton and HelpButton parameters

CONST
  mbNone                           = TMsgDlgBtn(-1);
  mbDefault                        = TMsgDlgBtn(-2);

  //--------------------------------------------------------------------------------------------------
  // "Don't Show Again" (DSA) dialogs
  //--------------------------------------------------------------------------------------------------

PROCEDURE DSAShowMessage(CONST DlgID: Integer; CONST Msg: STRING;
  CONST Timeout: Integer = 0);

PROCEDURE DSAShowMessageFmt(CONST DlgID: Integer; CONST Msg: STRING; CONST Params: ARRAY OF CONST;
  CONST Timeout: Integer = 0);

FUNCTION DSAMessageDlg(CONST DlgID: Integer; CONST Msg: STRING; CONST DlgType: TMsgDlgType;
  CONST Buttons: TMsgDlgButtons; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: TMsgDlgBtn = mbDefault;
  CONST CancelButton: TMsgDlgBtn = mbDefault; CONST HelpButton: TMsgDlgBtn = mbHelp): TModalResult; overload;
FUNCTION DSAMessageDlg(CONST DlgID: Integer; CONST Caption, Msg: STRING; CONST DlgType: TMsgDlgType;
  CONST Buttons: TMsgDlgButtons; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: TMsgDlgBtn = mbDefault;
  CONST CancelButton: TMsgDlgBtn = mbDefault; CONST HelpButton: TMsgDlgBtn = mbHelp): TModalResult; overload;
FUNCTION DSAMessageDlg(CONST DlgID: Integer; CONST Caption, Msg: STRING; CONST Picture: TGraphic;
  CONST Buttons: TMsgDlgButtons; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: TMsgDlgBtn = mbDefault;
  CONST CancelButton: TMsgDlgBtn = mbDefault; CONST HelpButton: TMsgDlgBtn = mbHelp): TModalResult; overload;

FUNCTION DSAMessageDlgEx(CONST DlgID: Integer; CONST Msg: STRING; CONST DlgType: TMsgDlgType;
  CONST Buttons: ARRAY OF STRING; CONST Results: ARRAY OF Integer; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0;
  CONST DefaultButton: Integer = 0; CONST CancelButton: Integer = 1; CONST HelpButton: Integer = -1): Integer; overload;
FUNCTION DSAMessageDlgEx(CONST DlgID: Integer; CONST Caption, Msg: STRING; CONST DlgType: TMsgDlgType;
  CONST Buttons: ARRAY OF STRING; CONST Results: ARRAY OF Integer; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: Integer = 0;
  CONST CancelButton: Integer = 1; CONST HelpButton: Integer = -1): TModalResult; overload;
FUNCTION DSAMessageDlgEx(CONST DlgID: Integer; CONST Caption, Msg: STRING; CONST Picture: TGraphic;
  CONST Buttons: ARRAY OF STRING; CONST Results: ARRAY OF Integer; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: Integer = 0;
  CONST CancelButton: Integer = 1; CONST HelpButton: Integer = -1): Integer; overload;

//----------------------------------------------------------------------------
// DSA state setting/retrieving
//----------------------------------------------------------------------------

FUNCTION GetDSAState(CONST DlgID: Integer): Boolean; overload;
FUNCTION GetDSAState(CONST DlgID: Integer; OUT LastResult: Integer): Boolean; overload;
PROCEDURE SetDSAState(CONST DlgID: Integer; CONST DontShowAgain: Boolean;
  CONST LastResult: Integer = mrNone);

//----------------------------------------------------------------------------
// DSA state loading/saving
//----------------------------------------------------------------------------
PROCEDURE LoadDSAStates(CONST DSAData: TStrings);
PROCEDURE SaveDSAStates(CONST DSAData: TStrings);

IMPLEMENTATION

USES JvDSADialogs,
  SysUtils,
  StrUtils;

VAR
  DSAStorage                       : TDSAStorage;
  DlgID                            : integer;

FUNCTION RegisterDSADialog(
  CONST DlgID: integer;
  CONST Name: STRING;
  CONST Description: STRING;
  CONST CheckTextKind: TDSACheckTextKind): Integer; OVERLOAD;
BEGIN
  JvDSADialogs.RegisterDSA(DlgID, Name, Description, DSAStorage, CheckTextKind);
  IF DlgID > UDSAStorage.DlgID THEN
    UDSAStorage.DlgID := DlgID;
  Result := DlgID;
END;

FUNCTION RegisterDSADialog(
  CONST Name: STRING;
  CONST Description: STRING;
  CONST CheckTextKind: TDSACheckTextKind): Integer; OVERLOAD;
BEGIN
  JvDSADialogs.RegisterDSA(DlgID + 1, Name, Description, DSAStorage, CheckTextKind);
  DlgID := DlgID + 1;
  Result := DlgID;
END;

FUNCTION RegisterDSAMessage(CONST Name: STRING; CONST Description: STRING): Integer;
BEGIN
  Result := RegisterDSADialog(Name, Description, ctkShow);
END;

FUNCTION RegisterDSAQuestion(CONST Name: STRING; CONST Description: STRING): Integer;
BEGIN
  Result := RegisterDSADialog(Name, Description, ctkAsk);
END;

FUNCTION RegisterDSAWarning(CONST Name: STRING; CONST Description: STRING): Integer;
BEGIN
  Result := RegisterDSADialog(Name, Description, ctkWarn);
END;


FUNCTION RegisterDSAMessage(CONST DlgID: integer; CONST Name: STRING; CONST Description: STRING): Integer;
BEGIN
  Result := RegisterDSADialog(DlgID, Name, Description, ctkShow);
END;

FUNCTION RegisterDSAQuestion(CONST DlgID: integer; CONST Name: STRING; CONST Description: STRING): Integer;
BEGIN
  Result := RegisterDSADialog(DlgID, Name, Description, ctkAsk);
END;

FUNCTION RegisterDSAWarning(CONST DlgID: integer; CONST Name: STRING; CONST Description: STRING): Integer;
BEGIN
  Result := RegisterDSADialog(DlgID, Name, Description, ctkWarn);
END;

PROCEDURE DSAShowMessage(CONST DlgID: Integer; CONST Msg: STRING;
  CONST Timeout: Integer = 0);
BEGIN
  JvDSADialogs.DSAShowMessage(DlgID, Msg, dckActiveForm, Timeout);
END;

PROCEDURE DSAShowMessageFmt(CONST DlgID: Integer; CONST Msg: STRING; CONST Params: ARRAY OF CONST;
  CONST Timeout: Integer = 0);
BEGIN
  JvDSADialogs.DSAShowMessageFmt(DlgID, Msg, Params, dckActiveForm, Timeout);
END;

FUNCTION DSAMessageDlg(CONST DlgID: Integer; CONST Msg: STRING; CONST DlgType: TMsgDlgType;
  CONST Buttons: TMsgDlgButtons; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: TMsgDlgBtn = mbDefault;
  CONST CancelButton: TMsgDlgBtn = mbDefault; CONST HelpButton: TMsgDlgBtn = mbHelp): TModalResult;
BEGIN
  Result := JvDSADialogs.DSAMessageDlg(DlgID, Msg, DlgType, Buttons, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
END;

FUNCTION DSAMessageDlg(CONST DlgID: Integer; CONST Caption, Msg: STRING; CONST DlgType: TMsgDlgType;
  CONST Buttons: TMsgDlgButtons; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: TMsgDlgBtn = mbDefault;
  CONST CancelButton: TMsgDlgBtn = mbDefault; CONST HelpButton: TMsgDlgBtn = mbHelp): TModalResult;
BEGIN
  Result := JvDSADialogs.DSAMessageDlg(DlgID, Msg, DlgType, Buttons, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
END;

FUNCTION DSAMessageDlg(CONST DlgID: Integer; CONST Caption, Msg: STRING; CONST Picture: TGraphic;
  CONST Buttons: TMsgDlgButtons; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: TMsgDlgBtn = mbDefault;
  CONST CancelButton: TMsgDlgBtn = mbDefault; CONST HelpButton: TMsgDlgBtn = mbHelp): TModalResult;
BEGIN
  Result := JvDSADialogs.DSAMessageDlg(DlgID, Caption, Msg, Picture, Buttons, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
END;

FUNCTION DSAMessageDlgEx(CONST DlgID: Integer; CONST Msg: STRING; CONST DlgType: TMsgDlgType;
  CONST Buttons: ARRAY OF STRING; CONST Results: ARRAY OF Integer; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0;
  CONST DefaultButton: Integer = 0; CONST CancelButton: Integer = 1; CONST HelpButton: Integer = -1): Integer; OVERLOAD;
BEGIN
  Result := JvDSADialogs.DSAMessageDlgEx(DlgID, Msg, DlgType, Buttons, Results, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
END;

FUNCTION DSAMessageDlgEx(CONST DlgID: Integer; CONST Caption, Msg: STRING; CONST DlgType: TMsgDlgType;
  CONST Buttons: ARRAY OF STRING; CONST Results: ARRAY OF Integer; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: Integer = 0;
  CONST CancelButton: Integer = 1; CONST HelpButton: Integer = -1): TModalResult; OVERLOAD;
BEGIN
  Result := JvDSADialogs.DSAMessageDlgEx(DlgID, Caption, Msg, DlgType, Buttons, Results, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
END;

FUNCTION DSAMessageDlgEx(CONST DlgID: Integer; CONST Caption, Msg: STRING; CONST Picture: TGraphic;
  CONST Buttons: ARRAY OF STRING; CONST Results: ARRAY OF Integer; CONST HelpCtx: Longint;
  CONST Timeout: Integer = 0; CONST DefaultButton: Integer = 0;
  CONST CancelButton: Integer = 1; CONST HelpButton: Integer = -1): Integer; OVERLOAD;
BEGIN
  Result := JvDSADialogs.DSAMessageDlgEx(DlgID, Caption, Msg, Picture, Buttons, Results, HelpCtx, dckActiveForm, Timeout, DefaultButton, CancelButton, HelpButton);
END;

//----------------------------------------------------------------------------
// DSA state setting/retrieving
//----------------------------------------------------------------------------

FUNCTION GetDSAState(CONST DlgID: Integer): Boolean;
BEGIN
  Result := JvDSADialogs.GetDSAState(DlgID);
END;

FUNCTION GetDSAState(CONST DlgID: Integer; OUT LastResult: Integer): Boolean;
BEGIN
  Result := JvDSADialogs.GetDSAState(DlgID, LastResult);
END;

PROCEDURE SetDSAState(CONST DlgID: Integer; CONST DontShowAgain: Boolean;
  CONST LastResult: Integer = mrNone);
BEGIN
  JvDSADialogs.SetDSAState(DlgID, DontShowAgain, LastResult);
END;

//----------------------------------------------------------------------------
// DSA state loading/saving
//----------------------------------------------------------------------------

PROCEDURE LoadDSAStates(CONST DSAData: TStrings);
VAR
  idx                              : integer;
  item                             : STRING;
  dlgID                            : integer;
  DontShowAgain                    : integer;
  LastResult                       : integer;
  Check                            : integer;
  FUNCTION NextWord(VAR s: STRING): integer;
  VAR
    delimPos                       : integer;
  BEGIN
    delimPos := Pos(';', s);
    IF delimPos > 0 THEN BEGIN
      Result := StrToIntDef(Copy(s, 1, delimPos - 1), -1);
      Delete(s, 1, delimPos);
    END
    ELSE BEGIN
      Result := -1;
    END;
  END;
BEGIN
  IF NOT Assigned(DSAData) THEN
    Exit;
  FOR idx := 0 TO DSAData.Count - 1 DO BEGIN
    item := DSAData.Strings[idx];
    dlgID := NextWord(item);
    LastResult := NextWord(item);
    DontShowAgain := NextWord(item);
    Check := NextWord(item);

    IF (Check > 0) AND (Check = dlgID + LastResult + DontShowAgain) THEN BEGIN
      IF (dlgId <> -1) AND (LastResult <> -1) AND (DontShowAgain <> -1) THEN
        JvDSADialogs.SetDSAState(dlgId, DontShowAgain = 0, LastResult);
    END;
  END;
END;

PROCEDURE SaveDSAStates(CONST DSAData: TStrings);
VAR
  idx                              : integer;
  item                             : TDSARegItem;
  LastResult                       : integer;
  DontShowAgain                    : integer;
BEGIN
  IF NOT Assigned(DSAData) THEN
    Exit;
  FOR idx := 0 TO JvDSADialogs.DSACount - 1 DO BEGIN
    item := JvDSADialogs.DSAItem(idx);
    IF DSAStorage.GetState(item, LastResult) THEN
      DontShowAgain := 0
    ELSE
      DontShowAgain := 1;
    DSAData.Append(Format('%d;%d;%d;%d', [item.ID, LastResult, DontShowAgain, item.ID + LastResult + DontShowAgain]));
  END;
END;

INITIALIZATION
  BEGIN
    DlgID := -1;
    DSAStorage := TDSAQueueStorage.Create;
  END;

FINALIZATION
  BEGIN
    FreeAndNil(DSAStorage);
  END;
END.
