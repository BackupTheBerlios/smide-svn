unit Tests.Smide.System.Types.TypeHandler;

interface

uses
  Smide.System,
  Smide.System.Types,
  Smunit.Framework;

type
  TTypeHandlerTest = class(TTestCase)
  private
  protected
    procedure TestTypeValues(TypeHandler: ITypeHandler; TypeSize: Integer;
      var Value1, Value2; Value1String: WideString = ''; Value2String: WideString = '');
  public
    procedure TestInteger;
    procedure TestCardinal;
    procedure TestByte;
    procedure TestChar;
    procedure TestInt64;
    procedure TestLongInt;
    procedure TestLongWord;
    procedure TestShortInt;
    procedure TestSmallInt;
    procedure TestWideChar;
    procedure TestWord;
    procedure TestSingle;
    procedure TestComp;
    procedure TestCurrency;
    procedure TestDouble;
    procedure TestExtended;
    procedure TestString;
    procedure TestWideString;
    procedure TestShortString;
    procedure TestObject;
    procedure TestInterface;
    procedure TestEnumeration;
    procedure TestBoolean;
    procedure TestLongBool;
    procedure TestByteBool;
    procedure TestWordBool;
    procedure TestSetConstants;
    procedure TestSetChar;
    procedure TestSetCustomType1Byte;
    procedure TestSetCustomType2Byte;
    procedure TestSetCustomType3Byte;
    procedure TestSetCustomType4Byte;
    procedure TestSetCustomType5Byte;
    procedure TestSetCustomType16Byte;
    procedure TestSetCustomType32Byte;
    procedure TestUserShortString;
    procedure TestUserTypeInteger;
  end;

implementation

{ TTypeHandlerTest }

procedure TTypeHandlerTest.TestTypeValues(TypeHandler: ITypeHandler; TypeSize: Integer; var Value1, Value2; Value1String, Value2String: WideString);
var
  P: TTypeData;
begin
  AssertEquals('TypeSize', TypeSize, TypeHandler.TypeSize);

  AssertEquals('Value1String', Value1String, TypeHandler.ValueToString(Value1));
  AssertEquals('Value2String', Value2String, TypeHandler.ValueToString(Value2));

  AssertTrue('CompareValues <> 0', TypeHandler.CompareValues(Value1, Value2) <> 0);
  AssertFalse('EqualsValues = False', TypeHandler.EqualsValues(Value1, Value2));
  AssertFalse('SameValues = False', TypeHandler.SameValues(Value1, Value2));

  TypeHandler.ValueToData(Value1, P);
  TypeHandler.DataToValue(P, Value2);

  AssertTrue('CompareValues = 0', TypeHandler.CompareValues(Value1, Value2) = 0);
  AssertTrue('EqualsValues = True', TypeHandler.EqualsValues(Value1, Value2));
  AssertTrue('SameValues = True', TypeHandler.SameValues(Value1, Value2));

  TypeHandler.ClearValue(Value1);

  AssertNotNil('Not Nil', P);
  TypeHandler.FreeData(P);
  AssertNil('Assert Nil', P);
end;

procedure TTypeHandlerTest.TestInteger;
var
  Value1, Value2: Integer;
begin
  Value1 := -2147483647;
  Value2 := 2147483647;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Integer)), SizeOf(Value1), Value1, Value2, '-2147483647', '2147483647');
  AssertEquals(0, Value1);
  AssertEquals(-2147483647, Value2);
end;

procedure TTypeHandlerTest.TestCardinal;
var
  Value1, Value2: Cardinal;
begin
  Value1 := 1;
  Value2 := 4294967295;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Cardinal)), SizeOf(Value1), Value1, Value2, '1', '4294967295');
  AssertEquals(0, Value1);
  AssertEquals(1, Value2);
end;

procedure TTypeHandlerTest.TestShortInt;
var
  Value1, Value2: ShortInt;
begin
  Value1 := -128;
  Value2 := 127;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(ShortInt)), SizeOf(Value1), Value1, Value2, '-128', '127');
  AssertEquals(0, Value1);
  AssertEquals(-128, Value2);
end;

procedure TTypeHandlerTest.TestSmallInt;
var
  Value1, Value2: SmallInt;
begin
  Value1 := -32768;
  Value2 := 32767;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(SmallInt)), SizeOf(Value1), Value1, Value2, '-32768', '32767');
  AssertEquals(0, Value1);
  AssertEquals(-32768, Value2);
end;

procedure TTypeHandlerTest.TestLongInt;
var
  Value1, Value2: Longint;
begin
  Value1 := -2147483647;
  Value2 := 2147483647;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Longint)), SizeOf(Value1), Value1, Value2, '-2147483647', '2147483647');
  AssertEquals(0, Value1);
  AssertEquals(-2147483647, Value2);
end;

procedure TTypeHandlerTest.TestInt64;
var
  Value1, Value2: Int64;
begin
  Value1 := -9223372036854775807;
  Value2 := 9223372036854775807;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Int64)), SizeOf(Value1), Value1, Value2, '-9223372036854775807', '9223372036854775807');
  AssertEquals(0, Value1);
  AssertEquals(-9223372036854775807, Value2);
end;

procedure TTypeHandlerTest.TestByte;
var
  Value1, Value2: Byte;
begin
  Value1 := 1;
  Value2 := 255;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Byte)), SizeOf(Value1), Value1, Value2, '1', '255');
  AssertEquals(0, Value1);
  AssertEquals(1, Value2);
end;

procedure TTypeHandlerTest.TestWord;
var
  Value1, Value2: Word;
begin
  Value1 := 1;
  Value2 := 65535;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Word)), SizeOf(Value1), Value1, Value2, '1', '65535');
  AssertEquals(0, Value1);
  AssertEquals(1, Value2);
end;

procedure TTypeHandlerTest.TestLongWord;
var
  Value1, Value2: LongWord;
begin
  Value1 := 1;
  Value2 := 4294967295;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(LongWord)), SizeOf(Value1), Value1, Value2, '1', '4294967295');
  AssertEquals(0, Value1);
  AssertEquals(1, Value2);
end;

procedure TTypeHandlerTest.TestChar;
var
  Value1, Value2: Char;
begin
  Value1 := #1;
  Value2 := #255;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Char)), SizeOf(Value1), Value1, Value2, #1, #255);
  AssertEquals(#0, Value1);
  AssertEquals(#1, Value2);
end;

procedure TTypeHandlerTest.TestWideChar;
var
  Value1, Value2: WideChar;
begin
  Value1 := #1;
  Value2 := #65535;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(WideChar)), SizeOf(Value1), Value1, Value2, #1, #65535);
  AssertEquals(#0, Value1);
  AssertEquals(#1, Value2);
end;

procedure TTypeHandlerTest.TestSingle;
var
  Value1, Value2: Single;
begin
  Value1 := -2.0;
  Value2 := 2.0;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Single)), SizeOf(Value1), Value1, Value2, '-2.00000000000000E+0000', '2.00000000000000E+0000');
  AssertEquals(0.0, Value1, 0);
  AssertEquals(-2.0, Value2, 0);
end;

procedure TTypeHandlerTest.TestDouble;
var
  Value1, Value2: Double;
begin
  Value1 := -2.0;
  Value2 := 2.0;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Double)), SizeOf(Value1), Value1, Value2, '-2.00000000000000E+0000', '2.00000000000000E+0000');
  AssertEquals(0.0, Value1, 0);
  AssertEquals(-2.0, Value2, 0);
end;

procedure TTypeHandlerTest.TestExtended;
var
  Value1, Value2: Extended;
begin
  Value1 := -2.0;
  Value2 := 2.0;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Extended)), SizeOf(Value1), Value1, Value2, '-2.00000000000000E+0000', '2.00000000000000E+0000');
  AssertEquals(0.0, Value1, 0);
  AssertEquals(-2.0, Value2, 0);
end;

procedure TTypeHandlerTest.TestComp;
var
  Value1, Value2: Comp;
begin
  Value1 := -2.0;
  Value2 := 2.0;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Comp)), SizeOf(Value1), Value1, Value2, '-2.00000000000000E+0000', '2.00000000000000E+0000');
  AssertEquals(0.0, Value1, 0);
  AssertEquals(-2.0, Value2, 0);
end;

procedure TTypeHandlerTest.TestCurrency;
var
  Value1, Value2: Currency;
begin
  Value1 := -2.0;
  Value2 := 2.0;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Currency)), SizeOf(Value1), Value1, Value2, '-2.00000000000000E+0000', '2.00000000000000E+0000');
  AssertEquals(0.0, Value1, 0);
  AssertEquals(-2.0, Value2, 0);
end;

procedure TTypeHandlerTest.TestString;
var
  Value1, Value2: string;
begin
  Value1 := 'ABC';
  Value2 := 'DEF';
  TestTypeValues(TType.GetTypeHandler(TypeInfo(string)), SizeOf(Value1), Value1, Value2, 'ABC', 'DEF');
  AssertEquals('', Value1);
  AssertEquals('ABC', Value2);
end;

procedure TTypeHandlerTest.TestWideString;
var
  Value1, Value2: WideString;
begin
  Value1 := 'ABC';
  Value2 := 'DEF';
  TestTypeValues(TType.GetTypeHandler(TypeInfo(WideString)), SizeOf(Value1), Value1, Value2, 'ABC', 'DEF');
  AssertEquals('', Value1);
  AssertEquals('ABC', Value2);
end;

procedure TTypeHandlerTest.TestObject;
var
  Value1, Value2: TSmideObject;
  Value1Tmp, Value2Tmp: TSmideObject;
begin
  Value1 := TSmideObject.Create;
  Value2 := TSmideObject.Create;
  Value1Tmp := Value1;
  Value2Tmp := Value2;
  try
    TestTypeValues(TType.GetTypeHandler(TypeInfo(TSmideObject)), SizeOf(Value1), Value1, Value2,
      'Smide.System.Runtime.TSmideObject', 'Smide.System.Runtime.TSmideObject');
    AssertNil(Value1);
    AssertSame(Value1Tmp, Value2);
  finally
    TSmideObject(Value2Tmp).Free;
  end;
end;

procedure TTypeHandlerTest.TestInterface;
var
  Value1, Value2: IInterface;
  Value1Tmp, Value2Tmp: IInterface;
begin
  Value1 := TSmideObject.Create;
  Value2 := TSmideObject.Create;
  Value1Tmp := Value1;
  Value2Tmp := Value2;
  try
    TestTypeValues(TType.GetTypeHandler(TypeInfo(IInterface)), SizeOf(Value1), Value1, Value2,
      'Smide.System.Runtime.TSmideObject', 'Smide.System.Runtime.TSmideObject');
    AssertNil(Value1);
    AssertSame(Value1Tmp, Value2);
  finally
    Value2Tmp := nil;
  end;
end;

type
  Enumeration = (E0, E1, E2);

procedure TTypeHandlerTest.TestEnumeration;
var
  Value1, Value2: Enumeration;
  Expected1, Expected2: Enumeration;
begin
  Value1 := E2;
  Value2 := E1;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Enumeration)), SizeOf(Value1), Value1, Value2, 'E2', 'E1');
  Expected1 := E0;
  Expected2 := E2;
  AssertEquals(TType.GetTypeHandler(TypeInfo(Enumeration)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(Enumeration)), Expected2, Value2);
end;

type
  TTestSetConstants = set of (S0, S1, S2);

procedure TTypeHandlerTest.TestSetConstants;
var
  Value1, Value2: TTestSetConstants;
  Expected1, Expected2: TTestSetConstants;
begin
  Value1 := [S1, S2];
  Value2 := [S1];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetConstants)), SizeOf(Value1), Value1, Value2, 'S1..S2', 'S1');
  Expected1 := [];
  Expected2 := [S1, S2];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetConstants)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetConstants)), Expected2, Value2);
end;

type
  TTestSetChar = set of Char;

procedure TTypeHandlerTest.TestSetChar;
var
  Value1, Value2: TTestSetChar;
  Expected1, Expected2: TTestSetChar;
begin
  Value1 := ['a'..'f', 'A'..'Z'];
  Value2 := ['2', '5'];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetChar)), SizeOf(Value1), Value1, Value2, 'A..Z, a..f', '2, 5');
  Expected1 := [];
  Expected2 := ['a'..'f', 'A'..'Z'];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetChar)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetChar)), Expected2, Value2);
end;

type
  TTestCustomType1Byte = 1..7;
  TTestSetCustomType1Byte = set of TTestCustomType1Byte;

procedure TTypeHandlerTest.TestSetCustomType1Byte;
var
  Value1, Value2: TTestSetCustomType1Byte;
  Expected1, Expected2: TTestSetCustomType1Byte;
begin
  Value1 := [1..7];
  Value2 := [1, 3, 5];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetCustomType1Byte)), SizeOf(Value1), Value1, Value2, '1..7', '1, 3, 5');
  Expected1 := [];
  Expected2 := [1..7];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType1Byte)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType1Byte)), Expected2, Value2);
end;

type
  TTestCustomType2Byte = 1..15;
  TTestSetCustomType2Byte = set of TTestCustomType2Byte;

procedure TTypeHandlerTest.TestSetCustomType2Byte;
var
  Value1, Value2: TTestSetCustomType2Byte;
  Expected1, Expected2: TTestSetCustomType2Byte;
begin
  Value1 := [1..15];
  Value2 := [1, 3, 5];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetCustomType2Byte)), SizeOf(Value1), Value1, Value2, '1..15', '1, 3, 5');
  Expected1 := [];
  Expected2 := [1..15];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType2Byte)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType2Byte)), Expected2, Value2);
end;

type
  TTestCustomType3Byte = 1..23;
  TTestSetCustomType3Byte = set of TTestCustomType3Byte;

procedure TTypeHandlerTest.TestSetCustomType3Byte;
var
  Value1, Value2: TTestSetCustomType3Byte;
  Expected1, Expected2: TTestSetCustomType3Byte;
begin
  Value1 := [1..31];
  Value2 := [1, 3, 5];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetCustomType3Byte)), SizeOf(Value1), Value1, Value2, '1..31', '1, 3, 5');
  Expected1 := [];
  Expected2 := [1..31];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType3Byte)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType3Byte)), Expected2, Value2);
end;

type
  TTestCustomType4Byte = 1..31;
  TTestSetCustomType4Byte = set of TTestCustomType4Byte;

procedure TTypeHandlerTest.TestSetCustomType4Byte;
var
  Value1, Value2: TTestSetCustomType4Byte;
  Expected1, Expected2: TTestSetCustomType4Byte;
begin
  Value1 := [1..31];
  Value2 := [1, 3, 5];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetCustomType4Byte)), SizeOf(Value1), Value1, Value2, '1..31', '1, 3, 5');
  Expected1 := [];
  Expected2 := [1..31];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType4Byte)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType4Byte)), Expected2, Value2);
end;

type
  TTestCustomType5Byte = 1..39;
  TTestSetCustomType5Byte = set of TTestCustomType5Byte;

procedure TTypeHandlerTest.TestSetCustomType5Byte;
var
  Value1, Value2: TTestSetCustomType5Byte;
  Expected1, Expected2: TTestSetCustomType5Byte;
begin
  Value1 := [1..39];
  Value2 := [1, 3, 5];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetCustomType5Byte)), SizeOf(Value1), Value1, Value2, '1..39', '1, 3, 5');
  Expected1 := [];
  Expected2 := [1..39];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType5Byte)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType5Byte)), Expected2, Value2);
end;

type
  TTestCustomType16Byte = 1..127;
  TTestSetCustomType16Byte = set of TTestCustomType16Byte;

procedure TTypeHandlerTest.TestSetCustomType16Byte;
var
  Value1, Value2: TTestSetCustomType16Byte;
  Expected1, Expected2: TTestSetCustomType16Byte;
begin
  Value1 := [1..127];
  Value2 := [1, 3, 5];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetCustomType16Byte)), SizeOf(Value1), Value1, Value2, '1..127', '1, 3, 5');
  Expected1 := [];
  Expected2 := [1..127];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType16Byte)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType16Byte)), Expected2, Value2);
end;


type
  TTestCustomType32Byte = 1..255;
  TTestSetCustomType32Byte = set of TTestCustomType32Byte;

procedure TTypeHandlerTest.TestSetCustomType32Byte;
var
  Value1, Value2: TTestSetCustomType32Byte;
  Expected1, Expected2: TTestSetCustomType32Byte;
begin
  Value1 := [1..255];
  Value2 := [1, 3, 5];
  TestTypeValues(TType.GetTypeHandler(TypeInfo(TTestSetCustomType32Byte)), SizeOf(Value1), Value1, Value2, '1..255', '1, 3, 5');
  Expected1 := [];
  Expected2 := [1..255];
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType32Byte)), Expected1, Value1);
  AssertEquals(TType.GetTypeHandler(TypeInfo(TTestSetCustomType32Byte)), Expected2, Value2);
end;

procedure TTypeHandlerTest.TestShortString;
var
  Value1, Value2: ShortString;
begin
  Value1 := 'ABC';
  Value2 := 'DEF';
  TestTypeValues(TType.GetTypeHandler(TypeInfo(ShortString)), SizeOf(Value1), Value1, Value2, 'ABC', 'DEF');
  AssertEquals('', Value1);
  AssertEquals('ABC', Value2);
end;

type
  UserShortString = string[5];

procedure TTypeHandlerTest.TestUserShortString;
var
  Value1, Value2: UserShortString;
begin
  Value1 := 'ABC';
  Value2 := 'DEF';
  TestTypeValues(TType.GetTypeHandler(TypeInfo(UserShortString)), SizeOf(Value1), Value1, Value2, 'ABC', 'DEF');
  AssertEquals('', Value1);
  AssertEquals('ABC', Value2);
end;

type
  UserInteger = -65536..65536;

procedure TTypeHandlerTest.TestUserTypeInteger;
var
  Value1, Value2: UserInteger;
begin
  Value1 := -65536;
  Value2 := 65536;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(UserInteger)), SizeOf(Value1), Value1, Value2, '-65536', '65536');
  AssertEquals(0, Value1);
  AssertEquals(-65536, Value2);
end;

procedure TTypeHandlerTest.TestBoolean;
var
  Value1, Value2: Boolean;
begin
  Value1 := true;
  Value2 := false;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(Boolean)), SizeOf(Value1), Value1, Value2, 'True', 'False');
  AssertFalse(Value1);
  AssertTrue(Value2);
end;

procedure TTypeHandlerTest.TestByteBool;
var
  Value1, Value2: ByteBool;
begin
  Value1 := true;
  Value2 := false;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(ByteBool)), SizeOf(Value1), Value1, Value2, 'True', 'False');
  AssertFalse(Value1);
  AssertTrue(Value2);
end;

procedure TTypeHandlerTest.TestLongBool;
var
  Value1, Value2: LongBool;
begin
  Value1 := true;
  Value2 := false;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(LongBool)), SizeOf(Value1), Value1, Value2, 'True', 'False');
  AssertFalse(Value1);
  AssertTrue(Value2);
end;

procedure TTypeHandlerTest.TestWordBool;
var
  Value1, Value2: WordBool;
begin
  Value1 := true;
  Value2 := false;
  TestTypeValues(TType.GetTypeHandler(TypeInfo(WordBool)), SizeOf(Value1), Value1, Value2, 'True', 'False');
  AssertFalse(Value1);
  AssertTrue(Value2);
end;

end.

