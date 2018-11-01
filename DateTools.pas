UNIT DateTools;

INTERFACE

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
// var LMonth, LDay : word;
// begin
//   DecodeDate(AValue,Result,LMonth,LDay);
// end;
//
// TryEncodeDateTime()
//
// function TryEncodeDateTime(const AYear,AMonth,ADay,AHour,AMinute,ASecond,
//                            AMilliSecond : word;
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
//  EncodeTime() with error checking and boolean return value)
//
// =============================================================================

FUNCTION DateTimeStrEval(CONST DateTimeFormat: STRING;
  CONST DateTimeStr: STRING): TDateTime;

{: Returns current UTC date and time. }
FUNCTION NowUTC: TDateTime;

{: Returns current UTC time. }
FUNCTION TimeUTC: TDateTime;

{: Returns current UTC date. }
FUNCTION DateUTC: TDateTime;

IMPLEMENTATION

USES SysUtils,
  DateUtils,
  Windows;

FUNCTION DateTimeStrEval(CONST DateTimeFormat: STRING;
  CONST DateTimeStr: STRING): TDateTime;
VAR
  i, ii, iii                       : integer;
  Retvar                           : TDateTime;
  Tmp,
    Fmt, Data, Mask, CaseMask, Spec: STRING;
  Year, Month, Day, Hour,
    Minute, Second, MSec           : word;
  AmPm                             : integer;
  FUNCTION GetChar(s: STRING; i: integer): Char;
  BEGIN
    IF (i < 1) OR (i > Length(s)) THEN BEGIN
      Result := #0;
    END
    ELSE BEGIN
      Result := s[i];
    END;
  END;
  FUNCTION IsDigit(c: Char): Boolean;
  BEGIN
    Result := c IN ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  END;
BEGIN
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

  WHILE i < length(Fmt) DO BEGIN
    IF Fmt[i] IN ['A', 'P', 'D', 'M', 'Y', 'H', 'N', 'S', 'Z'] THEN BEGIN
      // Start of a date specifier
      Mask := Fmt[i];
      ii := i + 1;

      // Keep going till not valid specifier
      WHILE true DO BEGIN
        IF ii > length(Fmt) THEN
          Break; // End of specifier string
        Spec := Mask + Fmt[ii];

        IF (Spec = 'DD') OR (Spec = 'DDD') OR (Spec = 'DDDD') OR
          (Spec = 'MM') OR (Spec = 'MMM') OR (Spec = 'MMMM') OR
          (Spec = 'YY') OR (Spec = 'YYY') OR (Spec = 'YYYY') OR
          (Spec = 'HH') OR (Spec = 'NN') OR (Spec = 'SS') OR
          (Spec = 'ZZ') OR (Spec = 'ZZZ') OR
          (Spec = 'AP') OR (Spec = 'AM') OR (Spec = 'AMP') OR
          (Spec = 'AMPM') THEN BEGIN
          Mask := Spec;
          inc(ii);
        END
        ELSE BEGIN
          // End of or Invalid specifier
          Break;
        END;
      END;

      // Got a valid specifier ? - evaluate it from data string
      IF (Mask <> '') THEN BEGIN
        CaseMask := Copy(DateTimeFormat, i, Length(Mask));
        IF length(Data) > 0 THEN BEGIN
          // Day 1..31
          IF (Mask = 'D') OR (Mask = 'DD') THEN BEGIN
            IF (Length(Mask) > 1) OR IsDigit(GetChar(Data, 2)) THEN BEGIN
              Day := StrToIntDef(trim(copy(Data, 1, 2)), 0);
              delete(Data, 1, 2);
            END
            ELSE BEGIN
              Day := StrToIntDef(trim(copy(Data, 1, 1)), 0);
              delete(Data, 1, 1);
            END;
          END;

          // Day Sun..Sat (Just remove from data string)
          IF (Mask = 'DDD') THEN
            delete(Data, 1, 3);

          // Day Sunday..Saturday (Just remove from data string LEN)
          IF (Mask = 'DDDD') THEN BEGIN
            Tmp := copy(Data, 1, 3);
            FOR iii := 1 TO 7 DO BEGIN
              IF Tmp = Uppercase(copy(LongDayNames[iii], 1, 3)) THEN BEGIN
                delete(Data, 1, length(LongDayNames[iii]));
                Break;
              END;
            END;
          END;

          // Month 1..12
          IF (CaseMask = 'M') OR (CaseMask = 'MM') THEN BEGIN
            IF (Length(Mask) > 1) OR IsDigit(GetChar(Data, 2)) THEN BEGIN
              Month := StrToIntDef(trim(copy(Data, 1, 2)), 0);
              delete(Data, 1, 2);
            END
            ELSE BEGIN
              Month := StrToIntDef(trim(copy(Data, 1, 1)), 0);
              delete(Data, 1, 1);
            END;
          END;

          // Month Jan..Dec
          IF (Mask = 'MMM') THEN BEGIN
            Tmp := copy(Data, 1, 3);
            FOR iii := 1 TO 12 DO BEGIN
              IF Tmp = Uppercase(copy(LongMonthNames[iii], 1, 3)) THEN BEGIN
                Month := iii;
                delete(Data, 1, 3);
                Break;
              END;
            END;
          END;

          // Month January..December
          IF (Mask = 'MMMM') THEN BEGIN
            Tmp := copy(Data, 1, 3);
            FOR iii := 1 TO 12 DO BEGIN
              IF Tmp = Uppercase(copy(LongMonthNames[iii], 1, 3)) THEN BEGIN
                Month := iii;
                delete(Data, 1, length(LongMonthNames[iii]));
                Break;
              END;
            END;
          END;

          // Year 2 Digit
          IF (Mask = 'YY') THEN BEGIN
            Year := StrToIntDef(copy(Data, 1, 2), 0);
            delete(Data, 1, 2);
            IF Year < TwoDigitYearCenturyWindow THEN
              Year := (YearOf(Date) DIV 100) * 100 + Year
            ELSE
              Year := (YearOf(Date) DIV 100 - 1) * 100 + Year;
          END;

          // Year 4 Digit
          IF (Mask = 'YYYY') THEN BEGIN
            Year := StrToIntDef(copy(Data, 1, 4), 0);
            delete(Data, 1, 4);
          END;

          // Hours
          IF (Mask = 'H') OR (Mask = 'HH') THEN BEGIN
            IF (Length(Mask) > 1) OR IsDigit(GetChar(Data, 2)) THEN BEGIN
              Hour := StrToIntDef(trim(copy(Data, 1, 2)), 0);
              delete(Data, 1, 2);
            END
            ELSE BEGIN
              Hour := StrToIntDef(trim(copy(Data, 1, 1)), 0);
              delete(Data, 1, 1);
            END;
          END;

          // Minutes
          IF (Mask = 'N') OR (CaseMask = 'm') OR (Mask = 'NN') OR (CaseMask = 'mm') THEN BEGIN
            IF (Length(Mask) > 1) OR IsDigit(GetChar(Data, 2)) THEN BEGIN
              Minute := StrToIntDef(trim(copy(Data, 1, 2)), 0);
              delete(Data, 1, 2);
            END
            ELSE BEGIN
              Minute := StrToIntDef(trim(copy(Data, 1, 1)), 0);
              delete(Data, 1, 1);
            END;
          END;

          // Seconds
          IF (Mask = 'S') OR (Mask = 'SS') THEN BEGIN
            IF (Length(Mask) > 1) OR IsDigit(GetChar(Data, 2)) THEN BEGIN
              Second := StrToIntDef(trim(copy(Data, 1, 2)), 0);
              delete(Data, 1, 2);
            END
            ELSE BEGIN
              Second := StrToIntDef(trim(copy(Data, 1, 1)), 0);
              delete(Data, 1, 1);
            END;
          END;

          // Milliseconds
          IF (Mask = 'Z') OR (Mask = 'ZZ') OR (Mask = 'ZZZ') THEN BEGIN
            IF (Length(Mask) > 1) OR IsDigit(GetChar(Data, 2)) THEN BEGIN
              IF (Length(Mask) > 2) OR IsDigit(GetChar(Data, 3)) THEN BEGIN
                MSec := StrToIntDef(trim(copy(Data, 1, 3)), 0);
                delete(Data, 1, 3);
              END
              ELSE BEGIN
                MSec := StrToIntDef(trim(copy(Data, 1, 2)), 0);
                delete(Data, 1, 2);
              END;
            END
            ELSE BEGIN
              MSec := StrToIntDef(trim(copy(Data, 1, 1)), 0);
              delete(Data, 1, 1);
            END;
          END;

          // AmPm A or P flag
          IF (Mask = 'AP') THEN BEGIN
            IF GetChar(Data, 1) = 'A' THEN
              AmPm := -1
            ELSE
              AmPm := 1;
            delete(Data, 1, 1);
          END;

          // AmPm AM or PM flag
          IF (Mask = 'AM') OR (Mask = 'AMP') OR (Mask = 'AMPM') THEN BEGIN
            IF copy(Data, 1, 2) = 'AM' THEN
              AmPm := -1
            ELSE
              AmPm := 1;
            delete(Data, 1, 2);
          END;
        END;

        Mask := '';
        i := ii;
      END;
    END
    ELSE BEGIN
      // Remove delimiter from data string
      IF length(Data) > 1 THEN
        delete(Data, 1, 1);
      inc(i);
    END;
  END;

  IF AmPm = 1 THEN
    Hour := Hour + 12;
  IF NOT TryEncodeDateTime(Year, Month, Day, Hour, Minute, Second, MSec, Retvar) THEN
    Retvar := 0.0;
  Result := Retvar;
END;

FUNCTION NowUTC: TDateTime;
VAR
  sysnow                           : TSystemTime;
BEGIN
  GetSystemTime(sysnow);
  Result := SystemTimeToDateTime(sysnow);
END; { NowUTC }

FUNCTION TimeUTC: TDateTime;
BEGIN
  Result := Frac(NowUTC);
END; { TimeUTC }

FUNCTION DateUTC: TDateTime;
BEGIN
  Result := Int(NowUTC);
END; { DateUTC }

END.
