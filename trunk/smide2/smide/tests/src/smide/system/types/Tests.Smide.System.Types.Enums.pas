unit Tests.Smide.System.Types.Enums;

interface

uses
  Smide.System,
  Smide.System.Reflection,
  Smunit.Framework;

type
  TTestEnum1 = (TE0, TE1, TE2, TE3);
  TTestEnum2 = TE1..TE2;

type
  TEnumsTest = class(TTestCase)
  private
    FTestEnum1: TTestEnum1;
    FTestEnum2: TTestEnum2;
    FEnumType1: TType;
    FEnumType2: TType;
  protected
    procedure SetUp; override;
  public
    procedure TestEnum1GetFieldsWithBindingFlags;
    procedure TestEnum2GetFieldsWithBindingFlags;
    procedure TestEnum1GetFields;
    procedure TestEnum2GetFields;
    procedure TestBaseType;
  end;

implementation

{ TEnumsTest }

procedure TEnumsTest.SetUp;
begin
  FTestEnum1 := TE0;
  FTestEnum2 := TE1;
  FEnumType1 := TType.GetType(TypeInfo(TTestEnum1));
  FEnumType2 := TType.GetType(TypeInfo(TTestEnum2));
end;

procedure TEnumsTest.TestEnum1GetFieldsWithBindingFlags;
begin
  // Test FieldCount, One for Value__ and the others for
  // the static fields TE0..TE3

  // Default Binding Flags
  AssertEquals(5, FEnumType1.GetFields.Count);

  // No Binding Flags
  AssertEquals(0, FEnumType1.GetFields([]).Count);

  // Public Static
  AssertEquals(4, FEnumType1.GetFields([bfPublic, bfStatic]).Count);

  // Public Static
  AssertEquals(4, FEnumType1.GetFields([bfPublic, bfStatic]).Count);

  // Public Instance
  AssertEquals(1, FEnumType1.GetFields([bfPublic, bfInstance]).Count);
end;

procedure TEnumsTest.TestEnum2GetFieldsWithBindingFlags;
begin
  // Test FieldCount, One for Value__ and the others for
  // the static fields TE0..TE3

  // Default Binding Flags
  AssertEquals(5, FEnumType2.GetFields.Count);

  // No Binding Flags
  AssertEquals(0, FEnumType2.GetFields([]).Count);

  // Public Static
  AssertEquals(4, FEnumType2.GetFields([bfPublic, bfStatic]).Count);

  // Public Static
  AssertEquals(4, FEnumType2.GetFields([bfPublic, bfStatic]).Count);

  // Public Instance
  AssertEquals(1, FEnumType2.GetFields([bfPublic, bfInstance]).Count);

  // DeclaredOnly, only the Value Field
  AssertEquals(1, FEnumType2.GetFields([bfPublic, bfStatic, bfInstance, bfNonPublic, bfDeclaredOnly]).Count);
end;

procedure TEnumsTest.TestEnum1GetFields;
begin
  AssertEquals('value__', FEnumType1.GetFields[FEnumType1.GetFields.Count - 1].Name);
  AssertEquals('TE0', FEnumType1.GetFields[Ord(TE0)].Name);
  AssertEquals('TE1', FEnumType1.GetFields[Ord(TE1)].Name);
  AssertEquals('TE2', FEnumType1.GetFields[Ord(TE2)].Name);
  AssertEquals('TE3', FEnumType1.GetFields[Ord(TE3)].Name);
end;

procedure TEnumsTest.TestEnum2GetFields;
begin
  AssertEquals('value__', FEnumType2.GetFields[FEnumType1.GetFields.Count - 1].Name);
  AssertEquals('TE1', FEnumType2.GetFields[Ord(TE1)].Name);
  AssertEquals('TE2', FEnumType2.GetFields[Ord(TE2)].Name);
end;

procedure TEnumsTest.TestBaseType;
begin
  AssertEquals(FEnumType2.BaseType, FEnumType1);
end;

end.

