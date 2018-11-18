(*

Based on original Cut Assistant (Brought to you by: a_s_z, ph1248)

see https://sourceforge.net/projects/cutassistant/


Unicode Delphi


Source format
- blocks, upper and lower case like Delphi sources
- use space instead of tab
- default indentation two characters
- max line length approx 120 characters
- minimize use of Exit

- variables and component names unchanged (for now)


*)


{$IFDEF conditionalexpressions}
  {$IF CompilerVersion < 30}
  possible unsupported delphi version - change at own risk
  {$ELSE}
  // use XE10 or higher
  {$IFEND}
{$ELSE}
  unsupported delphi version
{$ENDIF}



