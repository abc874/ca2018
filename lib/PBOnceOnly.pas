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
unit PBOnceOnly;

interface

uses 
  // Delphi
  Winapi.Windows;

var
  {: Specifies how often we retry to find the first instances main
     window. }
  MAX_RETRIES: Integer = 10;

  {: Specifies how long, in milliseconds, we sleep between retries. }
  RETRIES_INTERVAL: Integer = 1000;

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
function AlreadyRunning(const aProcessName: string;
  aMainformClass: TClass = nil;
  aPassCommandLineToClass: TClass = nil;
  passCommandline: Boolean = True;
  allowMultiuserInstances: Boolean = True): Boolean;

type
  {: Callback type used by HandleSendCommandline. The callback will
     be handed one parameter at a time. }
  TParameterEvent = procedure(const aParam: string) of object;

{-- HandleSendCommandline ---------------------------------------------}
{: Dissect a command line passed via WM_COPYDATA from another instance
@Param data contains the data received via WM_COPYDATA.
@Param onParameter is a callback that will be called with every passed
  parameter in turn.
@Precondition  onParameter <> nil
}{ Created 2003-02-23 by P. Below
-----------------------------------------------------------------------}
procedure HandleSendCommandline(const data: TCopyDataStruct;
  onParameter: TParameterEvent);

{-- HandleCommandline -------------------------------------------------}
{: This is a convenience procedure that allows handling of this
  instances command line parameters to be done the same way as
  a command line send over from another instance.
@Param onParameter will be called for every command line parameter in turn.
@Precondition  onParameter <> nil
}{ Created 2003-02-23 by P. Below
-----------------------------------------------------------------------}
procedure HandleCommandline(onParameter: TParameterEvent);

implementation

uses
  // Delphi
  Winapi.Messages, System.Classes, System.Sysutils;

{ The THandledObject and TShareMem classes come from the D6 IPCDemos
  demo project. }

type
  THandledObject = class(TObject)
  protected
    FHandle: THandle;
  public
    destructor Destroy; override;
    property Handle: THandle read FHandle;
  end;

{ This class simplifies the process of creating a region of shared memory.
  In Win32, this is accomplished by using the CreateFileMapping and
  MapViewOfFile functions. }

  TSharedMem = class(THandledObject)
  private
    FName: string;
    FSize: Integer;
    FCreated: Boolean;
    FFileView: Pointer;
  public
    constructor Create(const Name: string; Size: Integer);
    destructor Destroy; override;
    property Name: string read FName;
    property Size: Integer read FSize;
    property Buffer: Pointer read FFileView;
    property Created: Boolean read FCreated;
  end;

procedure Error(const Msg: string);
begin
  raise Exception.Create(Msg);
end;

{ THandledObject }

destructor THandledObject.Destroy;
begin
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

{ TSharedMem }

constructor TSharedMem.Create(const Name: string; Size: Integer);
begin
  try
    FName := Name;
    FSize := Size;
    { CreateFileMapping, when called with $FFFFFFFF for the handle value,
      creates a region of shared memory }
    FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
      Size, PChar(Name));
    if FHandle = 0 then abort;
    FCreated := GetLastError = 0;
    { We still need to map a pointer to the handle of the shared memory region
}
    FFileView := MapViewOfFile(FHandle, FILE_MAP_WRITE, 0, 0, Size);
    if FFileView = nil then abort;
  except
    Error(Format('Error creating shared memory %s (%d)', [Name,
      GetLastError]));
  end;
end;

destructor TSharedMem.Destroy;
begin
  if FFileView <> nil then
    UnmapViewOfFile(FFileView);
  inherited Destroy;
end;


var
  { This object is destroyed by the unit finalization }
  ProcessInfo: TSharedMem = nil;

{ Check if we are running in a terminal client session }

function IsRemoteSession: Boolean;
const
  sm_RemoteSession = $1000; { from WinUser.h }
begin
  Result := GetSystemMetrics(sm_RemoteSession) <> 0;
end;

{ Check if we are running on XP or a newer version. XP is Windows NT 5.1 }

function IsXP: Boolean;
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT) and
            (
             (Win32MajorVersion > 5) or
             ((Win32MajorVersion = 5) and (Win32MinorVersion > 0))
            );
end;

{ Check if we are running in a Windows terminal client session or on
  Windows XP.  }

function IsWTSOrXP: Boolean;
begin
  Result := IsRemoteSession or IsXP
end;

type
  { Helper class to hold classname and found window handle for
    EnumThreadWindows }
  TEnumhelper = class
  public
    FClassname: string;
    FWnd: HWND;
    constructor Create(const aClassname: string);
    function Matches(wnd: HWND): Boolean;
  end;

constructor TEnumhelper.Create(const aClassname: string);
begin
  inherited Create;
  FClassname := aClassname;
end;

function TEnumhelper.Matches(wnd: HWND): Boolean;
var
  classname: array[0..127] of Char;
begin
  classname[0] := #0;
  GetClassname(wnd, classname, SizeOf(classname));
  Result := AnsiSameText(Fclassname, classname);
  if Result then
    FWnd := wnd;
end;

function EnumProc(wnd: HWND; helper: TEnumHelper): BOOL; stdcall;
begin
  Result := not helper.Matches(wnd);
end;

function FindFirstInstanceMainform(const aClassname: string): HWND;
var
  threadID: DWORD;
  helper: TEnumHelper;
begin
  threadID := PDWORD(Processinfo.FFileView)^;
  helper := TEnumHelper.Create(aclassname);
  try
    EnumThreadWindows(threadID, @EnumProc, Integer(helper));
    Result := helper.FWnd;
  finally
    helper.Free;
  end;
end;

function AlreadyRunning(const aProcessName: string;
  aMainformClass: TClass = nil;
  aPassCommandLineToClass: TClass = nil;
  passCommandline: Boolean = True;
  allowMultiuserInstances: Boolean = True): Boolean;
  function Processname: string;
  begin
    if not allowMultiuserInstances and IsWTSorXP then
      Result := 'Global\' + aProcessName
    else
      Result := aProcessName;
  end;

  procedure StoreThreadID;
  begin
    PDWORD(ProcessInfo.FFileView)^ := GetCurrentThreadID;
  end;

  function GetCommandline: string;
  var
    sl: TStringlist;
    i: Integer;
  begin
    if ParamCount = 1 then
      Result := ParamStr(1)
    else begin
      sl := TStringlist.Create;
      try
        for i := 1 to ParamCount do
          sl.Add(ParamStr(i));
        Result := sl.Text;
      finally
        sl.free;
      end; { finally }
    end;
  end;

  procedure DoPassCommandline(ToClass: TClass);
  var
    wnd: HWND;
    S: string;
    copydata: TCopyDataStruct;
    retries: Integer;
  begin
    retries := 0;
    repeat
      wnd := FindFirstInstanceMainform(ToClass.Classname);
      if wnd <> 0 then
      begin
        S := GetCommandline;
        copydata.dwData := Paramcount;
        copydata.cbData := Length(S) + 1;
        copydata.lpData := PChar(S);
        SendMessage(wnd, WM_COPYDATA, 0, Integer(@copydata));
      end
      else begin
        Inc(retries);
        Sleep(RETRIES_INTERVAL);
      end;
    until (wnd <> 0) or (retries > MAX_RETRIES);
  end;

var
  AppMainWnd, ActivePopUpWnd: HWND;

begin
  Assert(not Assigned(ProcessInfo),
    'Do not call AlreadyRunning more than once!');
  ProcessInfo := TSharedMem.Create(Processname, Sizeof(DWORD));
  Result := not ProcessInfo.Created;
  if Result then
  begin
    //Added by 1248
    AppMainWnd := FindFirstInstanceMainform(aMainformclass.Classname);
    ActivePopUpWnd := GetLastActivePopup(AppMainWnd);
    SetForegroundWindow(ActivePopUpWnd);
    //End 1248
  
    if passCommandline and Assigned(aPassCommandLineToClass) and (ParamCount > 0) then
        DoPassCommandline(aPassCommandLineToClass);
  end
  else
    StoreThreadID;
end;

procedure HandleSendCommandline(const data: TCopyDataStruct;
  onParameter: TParameterEvent);
var
  i: Integer;
  sl: TStringlist;
begin
  Assert(Assigned(onParameter), 'OnParameter cannot be nil');
  if data.dwData = 1 then
    onParameter(PChar(data.lpData))
  else
  begin
    sl := TStringlist.Create;
    try
      sl.Text := PChar(data.lpData);
      for i := 0 to sl.Count - 1 do
        onParameter(sl[i]);
    finally
      sl.Free;
    end; { finally }
  end;
end;

procedure HandleCommandline(onParameter: TParameterEvent);
var
  i: Integer;
begin
  Assert(Assigned(onParameter), 'OnParameter cannot be nil');
  for i := 1 to ParamCount do
    onParameter(ParamStr(i));
end;

initialization
finalization
  ProcessInfo.Free;
end.
