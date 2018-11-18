UNIT trackBarEx;

INTERFACE

USES
  SysUtils,
  Classes,
  Controls,
  ComCtrls;

TYPE
  TtrackBarEx = CLASS(TTrackBar)
  PRIVATE
    { Private declarations }
  PROTECTED
    { Protected declarations }
  PUBLIC
    { Public declarations }
  PUBLISHED
    PROPERTY OnMOuseUp;
  END;

PROCEDURE Register;

IMPLEMENTATION

PROCEDURE Register;
BEGIN
  RegisterComponents('Win32', [TtrackBarEx]);
END;

END.
