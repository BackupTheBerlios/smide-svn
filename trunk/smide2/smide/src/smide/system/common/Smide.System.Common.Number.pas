unit Smide.System.Common.Number;

interface

uses
  Smide.System.Common,
  Smide.System.Globalization;

type
  TNumber = class(TStaticBase)
  public
    class function FormatInteger(const Value: Integer; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatCardinal(const Value: Cardinal; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatShortInt(const Value: ShortInt; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatSmallInt(const Value: SmallInt; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatLongInt(const Value: Longint; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatByte(const Value: Byte; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatWord(const Value: Word; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatLongWord(const Value: LongWord; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatInt64(const Value: Int64; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatUInt64(const Value: UInt64; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatSingle(const Value: Single; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatDouble(const Value: Double; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatExtended(const Value: Extended; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatComp(const Value: Comp; Format: WideString; Info: TNumberFormatInfo): WideString;
    class function FormatCurrency(const Value: Currency; Format: WideString; Info: TNumberFormatInfo): WideString;
  end;

implementation

{ TNumber }

class function TNumber.FormatByte(const Value: Byte; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

class function TNumber.FormatCardinal(const Value: Cardinal; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

class function TNumber.FormatComp(const Value: Comp; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
  if Result[1] = ' ' then
    Delete(Result, 1, 1);
end;

class function TNumber.FormatCurrency(const Value: Currency; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
  if Result[1] = ' ' then
    Delete(Result, 1, 1);
end;

class function TNumber.FormatDouble(const Value: Double; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
  if Result[1] = ' ' then
    Delete(Result, 1, 1);
end;

class function TNumber.FormatExtended(const Value: Extended; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
  if Result[1] = ' ' then
    Delete(Result, 1, 1);
end;

class function TNumber.FormatInt64(const Value: Int64; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

class function TNumber.FormatInteger(const Value: Integer; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

class function TNumber.FormatLongInt(const Value: Integer; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

class function TNumber.FormatLongWord(const Value: LongWord; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

class function TNumber.FormatShortInt(const Value: ShortInt; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

class function TNumber.FormatSingle(const Value: Single; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
  if Result[1] = ' ' then
    Delete(Result, 1, 1);
end;

class function TNumber.FormatSmallInt(const Value: SmallInt; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

// TODO: Formating routines

function _StrUInt64(val: UInt64): ShortString;
var
  d: array[0..31] of Char; { need 19 digits and a sign }
  i, k: Integer;
begin
  { Produce an ASCII representation of the number in reverse order }
  i := 0;
  repeat
    d[i] := Chr(Abs(val mod 10) + Ord('0'));
    Inc(i);
    val := val div 10;
  until val = 0;

  k := 1;

  { Fill the Result with the number }
  while i > 0 do
  begin
    Dec(i);
    Result[k] := d[i];
    Inc(k);
  end;

  { Result is k-1 characters long }
  SetLength(Result, k - 1);
end;

class function TNumber.FormatUInt64(const Value: UInt64; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Result := _StrUInt64(Value);
end;

class function TNumber.FormatWord(const Value: Word; Format: WideString; Info: TNumberFormatInfo): WideString;
begin
  Str(Value, Result);
end;

end.
