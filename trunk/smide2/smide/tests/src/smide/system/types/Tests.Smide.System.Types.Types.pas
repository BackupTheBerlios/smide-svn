unit Tests.Smide.System.Types.Types;

interface
uses
  Smide.System,
  Smide.System.Types,
  Smunit.Framework;

type
  TTypeTest = class(TTestCase)
  private
  protected
  public
    procedure TestGetTypeTypeInfoNil;
    procedure TestObjectGetTypeClassClassInfoNil;
    procedure TestObjectGetTypeInstanceClassInfoNil;
    procedure TestObjectGetTypeTypeInfoClassInfoNil;
    procedure TestTTypeToString;
  end;

implementation

{ TTypeTest }

type
  TClassInfoNilObject = class
  end;

procedure TTypeTest.TestObjectGetTypeClassClassInfoNil;
begin
  AssertEquals(TClassInfoNilObject.ClassName, TType.GetType(TClassInfoNilObject).Name);
end;

procedure TTypeTest.TestObjectGetTypeInstanceClassInfoNil;
var
  o: TClassInfoNilObject;
begin
  o := TClassInfoNilObject.Create;
  try
    AssertEquals(o.ClassName, TType.GetType(o).Name);
  finally
    o.Free;
  end;
end;

procedure TTypeTest.TestObjectGetTypeTypeInfoClassInfoNil;
begin
  AssertEquals(TClassInfoNilObject.ClassName, TType.GetType(TypeInfo(TClassInfoNilObject)).Name);
end;

procedure TTypeTest.TestGetTypeTypeInfoNil;
begin
  try
    TType.GetType(TRuntimeTypeHandle(nil));
  except
    on EArgumentNil do
      exit;
  end;
  AssertTrue(false);
end;

type
  TTestEnumeration = (TE0, TE1, TE2);
  TTestSet = set of TTestEnumeration;

  TTestObject = class
  end;

  ITestInterface = interface
  end;

procedure TTypeTest.TestTTypeToString;
begin
  AssertEquals('Integer', TType.GetType(TypeInfo(Integer)).ToString);
  AssertEquals('Cardinal', TType.GetType(TypeInfo(Cardinal)).ToString);
  AssertEquals('Byte', TType.GetType(TypeInfo(Byte)).ToString);
  AssertEquals('Char', TType.GetType(TypeInfo(Char)).ToString);
  AssertEquals('Int64', TType.GetType(TypeInfo(Int64)).ToString);
  AssertEquals('Integer', TType.GetType(TypeInfo(Longint)).ToString);
  AssertEquals('Cardinal', TType.GetType(TypeInfo(LongWord)).ToString);
  AssertEquals('Shortint', TType.GetType(TypeInfo(Shortint)).ToString);
  AssertEquals('Smallint', TType.GetType(TypeInfo(SmallInt)).ToString);
  AssertEquals('WideChar', TType.GetType(TypeInfo(WideChar)).ToString);
  AssertEquals('Word', TType.GetType(TypeInfo(Word)).ToString);
  AssertEquals('Single', TType.GetType(TypeInfo(Single)).ToString);
  AssertEquals('Comp', TType.GetType(TypeInfo(Comp)).ToString);
  AssertEquals('Currency', TType.GetType(TypeInfo(Currency)).ToString);
  AssertEquals('Double', TType.GetType(TypeInfo(Double)).ToString);
  AssertEquals('Extended', TType.GetType(TypeInfo(Extended)).ToString);
  AssertEquals('String', TType.GetType(TypeInfo(string)).ToString);
  AssertEquals('WideString', TType.GetType(TypeInfo(WideString)).ToString);
  AssertEquals('ShortString', TType.GetType(TypeInfo(ShortString)).ToString);
  AssertEquals('System.TObject', TType.GetType(TypeInfo(TObject)).ToString);
  AssertEquals('Tests.Smide.System.Types.Types.TTestObject', TType.GetType(TypeInfo(TTestObject)).ToString);
  AssertEquals('System.IInterface', TType.GetType(TypeInfo(IInterface)).ToString);
  AssertEquals('Tests.Smide.System.Types.Types.ITestInterface', TType.GetType(TypeInfo(ITestInterface)).ToString);
  AssertEquals('TTestEnumeration', TType.GetType(TypeInfo(TTestEnumeration)).ToString);
  AssertEquals('Boolean', TType.GetType(TypeInfo(Boolean)).ToString);
  AssertEquals('LongBool', TType.GetType(TypeInfo(LongBool)).ToString);
  AssertEquals('ByteBool', TType.GetType(TypeInfo(ByteBool)).ToString);
  AssertEquals('WordBool', TType.GetType(TypeInfo(WordBool)).ToString);
  AssertEquals('WordBool', TType.GetType(TypeInfo(WordBool)).ToString);
  AssertEquals('TTestSet', TType.GetType(TypeInfo(TTestSet)).ToString);
  // TODO: Array-, Dynamicarray-, Record & Variant types,
end;

end.

