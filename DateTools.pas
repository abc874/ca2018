unit DateTools;

{$I Information.inc}

// basic review and reformatting: done

interface

// =============================================================================
//This function will evaluate a DateTime string in accordance to the DateTime specifier format string supplied. The following specifiers are supported ...
//
//  dd          the day as a number with a leading zero or space (01-31).
//  ddd         the day as an abbreviation (Sun-Sat)
//  dddd        the day as a full name (Sunday-Saturday)
//  mm          the month as a number with a leading zero or space (01-12).
//  mmm         the month as an abbreviation (Jan-Dec)
//  mmmm        the month as a full name (January-December)
//  yy          the year as a two-digit number (00-99).
//  yyyy        the year as a four-digit number (0000-9999).
//  hh          the hour with a leading zero or space (00-23)
//  nn          the minute with a leading zero or space (00-59).
//  ss          the second with a leading zero or space (00-59).
//  zzz         the millisecond with a leading zero (000-999).
//  ampm        Specifies am or pm flag hours (0..12)
//  ap          Specifies a or p flag hours (0..12)
//  (Any other character corresponds to a literal or delimiter.)
//
//
//Using function
//DateTimeStrEval(const DateTimeFormat : string; const DateTimeStr : string) : TDateTime;
//
//The above Examples (1..4) can be evaluated as ... (Assume DT1 to DT4 equals example strings 1..4)
//
//        1)MyDate := DateTimeStrEval('dddd dd mmmm yyyy hh:nnampm (ss xxxx)', DT1);
//        2)MyDate := DateTimeStrEval('yyyymmdd', DT2);
//        3)MyDate := DateTimeStrEval('dd-mmm-yy', DT3);
//        4)MyDate := DateTimeStrEval('hh xxxx nn xxxxxx ss xxxxxx zzz xxxxx', DT4);
// Evaluate a date time string into a TDateTime obeying the
// rules of the specified DateTimeFormat string
// eg. DateTimeStrEval('dd-MMM-yyyy hh:nn','23-May-2002 12:34)
//
// Delphi 6 Specific in DateUtils can be translated to ....
//
// YearOf()
//
// function YearOf(const AValue: TDateTime): Word;
// var LMonth, LDay : Word;
// begin
//   DecodeDate(AValue,Result,LMonth,LDay);
// end;
//
// TryEncodeDateTime()
//
// function TryEncodeDateTime(const AYear,AMonth,ADay,AHour,AMinute,ASecond,
//                            AMilliSecond : Word;
//                            out AValue : TDateTime): Boolean;
// var LTime : TDateTime;
// begin
//   Result := TryEncodeDate(AYear, AMonth, ADay, AValue);
//   if Result then begin
//     Result := TryEncodeTime(AHour, AMinute, ASecond, AMilliSecond, LTime);
//     if Result then
//        AValue := AValue + LTime;
//   end;
// end;
//
// (TryEncodeDate() and TryEncodeTime() is the same as EncodeDate() and
//  EncodeTime() with error checking and Boolean return value)
//
// =============================================================================

function DateTimeStrEval(const DateTimeFormat: string; const DateTimeStr: string): TDateTime;

{: Returns current UTC date and time. }
function NowUTC: TDateTime;

{: Returns current UTC time. }
function TimeUTC: TDateTime;

{: Returns current UTC date. }
function DateUTC: TDateTime;

implementation

uses
  // Delphi
  Winapi.Windows, System.SysUtils, System.DateUtils;

function DateTimeStrEval(const DateTimeFormat: string; const DateTimeStr: string): TDateTime;
  function GetChar(s: string; i: Integer): Char;
  begin
    if (i > 0) and (i <= Length(s)) then
      Result := s[i]
    else
      Result := #0;
  end;
  function IsDigit(c: Char): Boolean;
  begin
    Result := CharInSet(c, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']);
  end;
var
  i, ii, iii: Integer;
  Retvar: TDateTime;
  Tmp, Fmt, Data, Mask, CaseMask, Spec: string;
  Year, Month, Day, Hour, Minute, Second, MSec: Word;
  AmPm: Integer;
begin
  Year := 1;
  Month := 1;
  Day := 1;
  Hour := 0;
  Minute := 0;
  Second := 0;
  MSec := 0;
  Fmt := UpperCase(DateTimeFormat);
  Data := UpperCase(DateTimeStr);
  i := 1;
  Mask := '';
  AmPm := 0;

  while i < Length(Fmt) do
  begin
    if CharInSet(Fmt[i], ['A', 'P', 'D', 'M', 'Y', 'H', 'N', 'S', 'Z']) then
    begin
      // Start of a date specifier
      Mask := Fmt[i];
      ii := i + 1;

      // Keep going till not valid specifier
      while True do
      begin
        if ii > Length(Fmt) then
          Break; // end of specifier string
        Spec := Mask + Fmt[ii];

        if (Spec = 'DD') or (Spec = 'DDD') or (Spec = 'DDDD') or (Spec = 'MM') or (Spec = 'MMM') or (Spec = 'MMMM') or
          (Spec = 'YY') or (Spec = 'YYY') or (Spec = 'YYYY') or (Spec = 'HH') or (Spec = 'NN') or (Spec = 'SS') or
          (Spec = 'ZZ') or (Spec = 'ZZZ') or (Spec = 'AP') or (Spec = 'AM') or (Spec = 'AMP') or
          (Spec = 'AMPM') then
        begin
          Mask := Spec;
          Inc(ii);
        end else
        begin
          // end of or Invalid specifier
          Break;
        end;
      end;

      // Got a valid specifier ? - evaluate it from data string
      if (Mask <> '') then
      begin
        CaseMask := Copy(DateTimeFormat, i, Length(Mask));
        if Length(Data) > 0 then
        begin
          // Day 1..31
          if (Mask = 'D') or (Mask = 'DD') then
          begin
            if (Length(Mask) > 1) or IsDigit(GetChar(Data, 2)) then
            begin
              Day := StrToIntDef(Trim(Copy(Data, 1, 2)), 0);
              Delete(Data, 1, 2);
            end else
            begin
              Day := StrToIntDef(Trim(Copy(Data, 1, 1)), 0);
              Delete(Data, 1, 1);
            end;
          end;

          // Day Sun..Sat (Just remove from data string)
          if (Mask = 'DDD') then
            Delete(Data, 1, 3);

          // Day Sunday..Saturday (Just remove from data string LEN)
          if (Mask = 'DDDD') then
          begin
            Tmp := Copy(Data, 1, 3);
            for iii := 1 to 7 do
            begin
              if Tmp = Uppercase(Copy(FormatSettings.LongDayNames[iii], 1, 3)) then
              begin
                Delete(Data, 1, Length(FormatSettings.LongDayNames[iii]));
                Break;
              end;
            end;
          end;

          // Month 1..12
          if (CaseMask = 'M') or (CaseMask = 'MM') then
          begin
            if (Length(Mask) > 1) or IsDigit(GetChar(Data, 2)) then
            begin
              Month := StrToIntDef(Trim(Copy(Data, 1, 2)), 0);
              Delete(Data, 1, 2);
            end else
            begin
              Month := StrToIntDef(Trim(Copy(Data, 1, 1)), 0);
              Delete(Data, 1, 1);
            end;
          end;

          // Month Jan..Dec
          if (Mask = 'MMM') then
          begin
            Tmp := Copy(Data, 1, 3);
            for iii := 1 to 12 do
            begin
              if Tmp = Uppercase(Copy(FormatSettings.LongMonthNames[iii], 1, 3)) then
              begin
                Month := iii;
                Delete(Data, 1, 3);
                Break;
              end;
            end;
          end;

          // Month January..December
          if (Mask = 'MMMM') then
          begin
            Tmp := Copy(Data, 1, 3);
            for iii := 1 to 12 do
            begin
              if Tmp = Uppercase(Copy(FormatSettings.LongMonthNames[iii], 1, 3)) then
              begin
                Month := iii;
                Delete(Data, 1, Length(FormatSettings.LongMonthNames[iii]));
                Break;
              end;
            end;
          end;

          // Year 2 Digit
          if (Mask = 'YY') then
          begin
            Year := StrToIntDef(Copy(Data, 1, 2), 0);
            Delete(Data, 1, 2);
            if Year < FormatSettings.TwoDigitYearCenturyWindow then
              Year := (YearOf(Date) div 100) * 100 + Year
            else
              Year := (YearOf(Date) div 100 - 1) * 100 + Year;
          end;

          // Year 4 Digit
          if (Mask = 'YYYY') then
          begin
            Year := StrToIntDef(Copy(Data, 1, 4), 0);
            Delete(Data, 1, 4);
          end;

          // Hours
          if (Mask = 'H') or (Mask = 'HH') then begin
            if (Length(Mask) > 1) or IsDigit(GetChar(Data, 2)) then
            begin
              Hour := StrToIntDef(Trim(Copy(Data, 1, 2)), 0);
              Delete(Data, 1, 2);
            end else
            begin
              Hour := StrToIntDef(Trim(Copy(Data, 1, 1)), 0);
              Delete(Data, 1, 1);
            end;
          end;

          // Minutes
          if (Mask = 'N') or (CaseMask = 'm') or (Mask = 'NN') or (CaseMask = 'mm') then
          begin
            if (Length(Mask) > 1) or IsDigit(GetChar(Data, 2)) then
            begin
              Minute := StrToIntDef(Trim(Copy(Data, 1, 2)), 0);
              Delete(Data, 1, 2);
            end else
            begin
              Minute := StrToIntDef(Trim(Copy(Data, 1, 1)), 0);
              Delete(Data, 1, 1);
            end;
          end;

          // Seconds
          if (Mask = 'S') or (Mask = 'SS') then
          begin
            if (Length(Mask) > 1) or IsDigit(GetChar(Data, 2)) then
            begin
              Second := StrToIntDef(Trim(Copy(Data, 1, 2)), 0);
              Delete(Data, 1, 2);
            end else
            begin
              Second := StrToIntDef(Trim(Copy(Data, 1, 1)), 0);
              Delete(Data, 1, 1);
            end;
          end;

          // Milliseconds
          if (Mask = 'Z') or (Mask = 'ZZ') or (Mask = 'ZZZ') then
          begin
            if (Length(Mask) > 1) or IsDigit(GetChar(Data, 2)) then
            begin
              if (Length(Mask) > 2) or IsDigit(GetChar(Data, 3)) then
              begin
                MSec := StrToIntDef(Trim(Copy(Data, 1, 3)), 0);
                Delete(Data, 1, 3);
              end else
              begin
                MSec := StrToIntDef(Trim(Copy(Data, 1, 2)), 0);
                Delete(Data, 1, 2);
              end;
            end else
            begin
              MSec := StrToIntDef(Trim(Copy(Data, 1, 1)), 0);
              Delete(Data, 1, 1);
            end;
          end;

          // AmPm A or P flag
          if (Mask = 'AP') then
          begin
            if GetChar(Data, 1) = 'A' then
              AmPm := -1
            else
              AmPm := 1;
            Delete(Data, 1, 1);
          end;

          // AmPm AM or PM flag
          if (Mask = 'AM') or (Mask = 'AMP') or (Mask = 'AMPM') then
          begin
            if Copy(Data, 1, 2) = 'AM' then
              AmPm := -1
            else
              AmPm := 1;
            Delete(Data, 1, 2);
          end;
        end;

        Mask := '';
        i := ii;
      end;
    end else
    begin
      // Remove delimiter from data string
      if Length(Data) > 1 then
        Delete(Data, 1, 1);
      Inc(i);
    end;
  end;

  if AmPm = 1 then
    Hour := Hour + 12;
  if not TryEncodeDateTime(Year, Month, Day, Hour, Minute, Second, MSec, Retvar) then
    Retvar := 0.0;
  Result := Retvar;
end;

function NowUTC: TDateTime;
var
  sysnow: TSystemTime;
begin
  GetSystemTime(sysnow);
  Result := SystemTimeToDateTime(sysnow);
end;

function TimeUTC: TDateTime;
begin
  Result := Frac(NowUTC);
end;

function DateUTC: TDateTime;
begin
  Result := Int(NowUTC);
end;

end.

