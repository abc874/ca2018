{The work of dissecting the passed commandline is left to the PBOnceOnly unit,
since it "knows" how it packaged the parameters in the other instance. The
technique used by the unit is rather simple: the first instance creates a
memory mapped file and stores its main threads thread ID into this file. It
cannot store the main forms handle since the form has not been created yet
when AlreadyRunning is called. It would be a bad idea anyway since a forms
handle can change over the form objects lifetime. The second instance gets
this handle, uses EnumThreadWindows to find the first instances main form
handle (doing this way avoids problems with the IDE designers form instance
during development), packages the command line and sends it over to the found
window. The second instance will then terminate since AlreadyRunning returns
true in it. It never creates any of the autocreated forms or datamodules and
never enters its message loop.}

{== PBOnceOnly ========================================================}
{: Implements a function to detect a running instance of the program and
  (optionally) pass over any command line to the first instances main
  window.
@author Dr. Peter Below
@desc   Version 1.0 created 2003-02-23<BR>
        Last modified       2003-02-23<P>
@modified by 1248
        Last modified       2006-10-18

If a command line has to be passed over we need the window handle of the
first instances main window, to send a WM_COPYDATA message to it. Since
the first instance may not have gotten around to creating its main
form window handle yet we retry a couple of times and wait a bit in
between. This process can be configured by setting the MAX_RETRIES and
RETRIES_INTERVAL variables before calling AlreadyRunning.   }
{======================================================================}
{$BOOLEVAL OFF} {Unit depends on shortcut boolean evaluation}
UNIT PBOnceOnly;

INTERFACE

USES Windows;

VAR
  {: Specifies how often we retry to find the first instances main
     window. }
  MAX_RETRIES                      : Integer = 10;

  {: Specifies how long, in milliseconds, we sleep between retries. }
  RETRIES_INTERVAL                 : Integer = 1000;

  {-- AlreadyRunning ----------------------------------------------------}
  {: Checks for another instance of the program and optionally passes over
    this instances command line.
  @Param aProcessName is a unique name to be used to identify this program.
  @Param aMainformClass is the programs main form class, can be nil.
  @Param passCommandline indicates whether to pass the command line, true
    by default.
  @Param allowMultiuserInstances indicates whether to allow other
    instances of the program to run in another user context. Only applies
    to Windows terminal server or XP. True by default.
  @Returns true if there is another instance running, false if not.
  @Precondition The function has not been called already. It must only
    be called once per program run.
  @Desc Creates a memory mapped file with the passed process name,
    optionally with an added 'Global' prefix. If the MMF already existed
    we know that this is a second instance. The first instance stores its
    main thread ID into the MMF, the second one uses that with
    EnumThreadWindows to find the first instances main window and sends
    the command line via WM_COPYDATA to this window, if requested.
  @Raises Exception if creation of the MMF fails for some reason.
  }{ Created 2003-02-23 by P. Below
  -----------------------------------------------------------------------}
FUNCTION AlreadyRunning(CONST aProcessName: STRING;
  aMainformClass: TClass = NIL;
  aPassCommandLineToClass: TClass = NIL;
  passCommandline: Boolean = true;
  allowMultiuserInstances: Boolean = true): Boolean;

TYPE
  {: Callback type used by HandleSendCommandline. The callback will
     be handed one parameter at a time. }
  TParameterEvent = PROCEDURE(CONST aParam: STRING) OF OBJECT;

  {-- HandleSendCommandline ---------------------------------------------}
  {: Dissect a command line passed via WM_COPYDATA from another instance
  @Param data contains the data received via WM_COPYDATA.
  @Param onParameter is a callback that will be called with every passed
    parameter in turn.
  @Precondition  onParameter <> nil
  }{ Created 2003-02-23 by P. Below
  -----------------------------------------------------------------------}
PROCEDURE HandleSendCommandline(CONST data: TCopyDataStruct;
  onParameter: TParameterEvent);

{-- HandleCommandline -------------------------------------------------}
{: This is a convenience procedure that allows handling of this
  instances command line parameters to be done the same way as
  a command line send over from another instance.
@Param onParameter will be called for every command line parameter in turn.
@Precondition  onParameter <> nil
}{ Created 2003-02-23 by P. Below
-----------------------------------------------------------------------}
PROCEDURE HandleCommandline(onParameter: TParameterEvent);

IMPLEMENTATION

USES Messages,
  Classes,
  Sysutils;

{ The THandledObject and TShareMem classes come from the D6 IPCDemos
  demo project. }

TYPE
  THandledObject = CLASS(TObject)
  PROTECTED
    FHandle: THandle;
  PUBLIC
    DESTRUCTOR Destroy; OVERRIDE;
    PROPERTY Handle: THandle READ FHandle;
  END;

  { This class simplifies the process of creating a region of shared memory.
    In Win32, this is accomplished by using the CreateFileMapping and
    MapViewOfFile functions. }

  TSharedMem = CLASS(THandledObject)
  PRIVATE
    FName: STRING;
    FSize: Integer;
    FCreated: Boolean;
    FFileView: Pointer;
  PUBLIC
    CONSTRUCTOR Create(CONST Name: STRING; Size: Integer);
    DESTRUCTOR Destroy; OVERRIDE;
    PROPERTY Name: STRING READ FName;
    PROPERTY Size: Integer READ FSize;
    PROPERTY Buffer: Pointer READ FFileView;
    PROPERTY Created: Boolean READ FCreated;
  END;

PROCEDURE Error(CONST Msg: STRING);
BEGIN
  RAISE Exception.Create(Msg);
END;

{ THandledObject }

DESTRUCTOR THandledObject.Destroy;
BEGIN
  IF FHandle <> 0 THEN
    CloseHandle(FHandle);
END;

{ TSharedMem }

CONSTRUCTOR TSharedMem.Create(CONST Name: STRING; Size: Integer);
BEGIN
  TRY
    FName := Name;
    FSize := Size;
    { CreateFileMapping, when called with $FFFFFFFF for the handle value,
      creates a region of shared memory }
    FHandle := CreateFileMapping($FFFFFFFF, NIL, PAGE_READWRITE, 0,
      Size, PChar(Name));
    IF FHandle = 0 THEN abort;
    FCreated := GetLastError = 0;
    { We still need to map a pointer to the handle of the shared memory region
}
    FFileView := MapViewOfFile(FHandle, FILE_MAP_WRITE, 0, 0, Size);
    IF FFileView = NIL THEN abort;
  EXCEPT
    Error(Format('Error creating shared memory %s (%d)', [Name,
      GetLastError]));
  END;
END;

DESTRUCTOR TSharedMem.Destroy;
BEGIN
  IF FFileView <> NIL THEN
    UnmapViewOfFile(FFileView);
  INHERITED Destroy;
END;


VAR
  { This object is destroyed by the unit finalization }
  ProcessInfo                      : TSharedMem = NIL;

  { Check if we are running in a terminal client session }

FUNCTION IsRemoteSession: Boolean;
CONST
  sm_RemoteSession                 = $1000; { from WinUser.h }
BEGIN
  Result := GetSystemMetrics(sm_RemoteSession) <> 0;
END;

{ Check if we are running on XP or a newer version. XP is Windows NT 5.1 }

FUNCTION IsXP: Boolean;
BEGIN
  Result :=
    (Sysutils.Win32Platform = VER_PLATFORM_WIN32_NT)
    AND
    ((Sysutils.Win32MajorVersion > 5)
    OR
    ((Sysutils.Win32MajorVersion = 5)
    AND
    (Sysutils.Win32MinorVersion > 0)
    )
    );
END;

{ Check if we are running in a Windows terminal client session or on
  Windows XP.  }

FUNCTION IsWTSOrXP: Boolean;
BEGIN
  Result := IsRemoteSession OR IsXP
END;

TYPE
  { Helper class to hold classname and found window handle for
    EnumThreadWindows }
  TEnumhelper = CLASS
  PUBLIC
    FClassname: STRING;
    FWnd: HWND;
    CONSTRUCTOR Create(CONST aClassname: STRING);
    FUNCTION Matches(wnd: HWND): Boolean;
  END;

CONSTRUCTOR TEnumhelper.Create(CONST aClassname: STRING);
BEGIN
  INHERITED Create;
  FClassname := aClassname;
END;

FUNCTION TEnumhelper.Matches(wnd: HWND): Boolean;
VAR
  classname                        : ARRAY[0..127] OF Char;
BEGIN
  classname[0] := #0;
  Windows.GetClassname(wnd, classname, sizeof(classname));
  Result := AnsiSametext(Fclassname, classname);
  IF result THEN
    FWnd := wnd;
END;

FUNCTION EnumProc(wnd: HWND; helper: TEnumHelper): BOOL; STDCALL;
BEGIN
  Result := NOT helper.Matches(wnd);
END;

FUNCTION FindFirstInstanceMainform(CONST aClassname: STRING): HWND;
VAR
  threadID                         : DWORD;
  helper                           : TEnumHelper;
BEGIN
  threadID := PDWORD(Processinfo.FFileView)^;
  helper := TEnumHelper.Create(aclassname);
  TRY
    EnumThreadWindows(threadID, @EnumProc, Integer(helper));
    Result := helper.FWnd;
  FINALLY
    FreeAndNIL(helper);
  END;
END;

FUNCTION AlreadyRunning(CONST aProcessName: STRING;
  aMainformClass: TClass = NIL; aPassCommandLineToClass: TClass = NIL;
  passCommandline: Boolean = true;
  allowMultiuserInstances: Boolean = true): Boolean;
  FUNCTION Processname: STRING;
  BEGIN
    IF NOT allowMultiuserInstances AND IsWTSorXP THEN
      Result := 'Global\' + aProcessName
    ELSE
      Result := aProcessName;
  END;

  PROCEDURE StoreThreadID;
  BEGIN
    PDWORD(ProcessInfo.FFileView)^ := GetCurrentThreadID;
  END;

  FUNCTION GetCommandline: STRING;
  VAR
    sl                             : TStringlist;
    i                              : Integer;
  BEGIN
    IF ParamCount = 1 THEN
      Result := ParamStr(1)
    ELSE BEGIN
      sl := TStringlist.Create;
      TRY
        FOR i := 1 TO ParamCount DO
          sl.Add(ParamStr(i));
        Result := sl.Text;
      FINALLY
        FreeAndNIL(sl);
      END; { Finally }
    END;
  END;

  PROCEDURE DoPassCommandline(ToClass: TClass);
  VAR
    wnd                            : HWND;
    S                              : STRING;
    copydata                       : TCopyDataStruct;
    retries                        : Integer;
  BEGIN
    retries := 0;
    REPEAT
      wnd := FindFirstInstanceMainform(ToClass.Classname);
      IF wnd <> 0 THEN BEGIN
        S := GetCommandline;
        copydata.dwData := Paramcount;
        copydata.cbData := Length(S) + 1;
        copydata.lpData := PChar(S);
        SendMessage(wnd, WM_COPYDATA, 0, integer(@copydata));
      END
      ELSE BEGIN
        Inc(retries);
        Sleep(RETRIES_INTERVAL);
      END;
    UNTIL (wnd <> 0) OR (retries > MAX_RETRIES);
  END;

VAR
  AppMainWnd                       : HWND;
  ActivePopUpWnd                   : HWND;

BEGIN
  Assert(NOT Assigned(ProcessInfo),
    'Do not call AlreadyRunning more than once!');
  ProcessInfo := TSharedMem.Create(Processname, Sizeof(DWORD));
  Result := NOT ProcessInfo.Created;
  IF Result THEN BEGIN
    //Added by 1248
    AppMainWnd := FindFirstInstanceMainform(aMainformclass.Classname);
    ActivePopUpWnd := GetLastActivePopup(AppMainWnd);
    SetForegroundWindow(ActivePopUpWnd);
    //End 1248

    IF passCommandline AND Assigned(aPassCommandLineToClass) AND (ParamCount > 0) THEN
      DoPassCommandline(aPassCommandLineToClass);
  END
  ELSE
    StoreThreadID;
END;

PROCEDURE HandleSendCommandline(CONST data: TCopyDataStruct;
  onParameter: TParameterEvent);
VAR
  i                                : Integer;
  sl                               : TStringlist;
BEGIN
  Assert(Assigned(onParameter), 'OnParameter cannot be nil');
  IF data.dwData = 1 THEN
    onParameter(PChar(data.lpData))
  ELSE BEGIN
    sl := TStringlist.Create;
    TRY
      sl.Text := PChar(data.lpData);
      FOR i := 0 TO sl.Count - 1 DO
        onParameter(sl[i]);
    FINALLY
      FreeAndNIL(sl);
    END; { Finally }
  END;
END;

PROCEDURE HandleCommandline(onParameter: TParameterEvent);
VAR
  i                                : Integer;
BEGIN
  Assert(Assigned(onParameter), 'OnParameter cannot be nil');
  FOR i := 1 TO ParamCount DO
    onParameter(ParamStr(i));
END;

INITIALIZATION
FINALIZATION
  FreeAndNIL(ProcessInfo);
END.
