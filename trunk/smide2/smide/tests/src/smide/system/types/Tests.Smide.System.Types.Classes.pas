unit Tests.Smide.System.Types.Classes;

interface

uses
  Smide.System,
  Smide.System.Reflection,
  Smunit.Framework;

type
  {$TYPEINFO ON}
  {$METHODINFO ON}
  TTestObjectBase = class
  public
    IntegerField: Integer;
    WordField: Integer;
    StringField: Integer;
  published
    ObjectField1: TObject;
    ObjectField2: TSmideObject;
    InterfaceField1: IUnknown;
  end;
  {$METHODINFO OFF}
  {$TYPEINFO OFF}

  TTestObject = class(TTestObjectBase)
  public
    IntegerField: Integer;
    WordField: Integer;
    StringField: Integer;
  published
    ObjectField3: TObject;
    ObjectField4: TSmideObject;
    InterfaceField2: IUnknown;
  end;

  TClassesTest = class(TTestCase)
  private
    FClassType: TType;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    procedure TestGetFieldsWithBindingFlags;
    procedure TestGetFields;
    procedure TestGetFieldValue;
    procedure TestGetFieldValueNilTarget;
    procedure TestGetFieldValueWrongTarget;
    procedure TestGetFieldToString;
  end;

implementation

{ TClassesTest }

procedure TClassesTest.SetUp;
begin
  FClassType := TType.GetType(TTestObject);
end;

procedure TClassesTest.TearDown;
begin

end;

procedure TClassesTest.TestGetFields;
begin
  AssertEquals(4, FClassType.GetFields.Count);

  AssertEquals('ObjectField1', FClassType.GetFields[0].Name);
  AssertEquals(TObject.ClassName, FClassType.GetFields[0].FieldType.Name);

  AssertEquals('ObjectField2', FClassType.GetFields[1].Name);
  AssertEquals(TSmideObject.ClassName, FClassType.GetFields[1].FieldType.Name);

  AssertEquals('ObjectField3', FClassType.GetFields[2].Name);
  AssertEquals(TObject.ClassName, FClassType.GetFields[2].FieldType.Name);

  AssertEquals('ObjectField4', FClassType.GetFields[3].Name);
  AssertEquals(TSmideObject.ClassName, FClassType.GetFields[3].FieldType.Name);
end;

procedure TClassesTest.TestGetFieldsWithBindingFlags;
begin
  // Default Binding Flags
  AssertEquals(4, FClassType.GetFields.Count);

  // No Binding Flags
  AssertEquals(0, FClassType.GetFields([]).Count);

  // Public Static
  AssertEquals(0, FClassType.GetFields([bfPublic, bfStatic]).Count);

  // Public Instance
  AssertEquals(4, FClassType.GetFields([bfPublic, bfInstance]).Count);

  // Public Instance DeclaredOnly
  AssertEquals(2, FClassType.GetFields([bfPublic, bfInstance, bfDeclaredOnly]).Count);

  // All Fields
  AssertEquals(4, FClassType.GetFields([bfPublic, bfStatic, bfInstance, bfNonPublic]).Count);

  // All Declared Fields
  AssertEquals(2, FClassType.GetFields([bfPublic, bfStatic, bfInstance, bfNonPublic, bfDeclaredOnly]).Count);
end;

procedure TClassesTest.TestGetFieldToString;
begin
  AssertEquals('ObjectField1: System.TObject', FClassType.GetFields[0].ToString);
  AssertEquals('ObjectField2: Smide.System.Runtime.TSmideObject', FClassType.GetFields[1].ToString);
  AssertEquals('ObjectField3: System.TObject', FClassType.GetFields[2].ToString);
  AssertEquals('ObjectField4: Smide.System.Runtime.TSmideObject', FClassType.GetFields[3].ToString);
end;

procedure TClassesTest.TestGetFieldValue;
var
  o: TTestObject;
  v: TObject;
begin
  o := TTestObject.Create;
  try
    o.ObjectField1 := o;
    FClassType.GetFields[0].GetValue(o, v);
    AssertEquals(o, v);
  finally
    o.Free;
  end;
end;

procedure TClassesTest.TestGetFieldValueNilTarget;
var
  o: TTestObject;
  v: TObject;
begin
  // non static field and nil target object
  try
    o := nil;
    FClassType.GetFields[0].GetValue(o, v);
  except
    on e: ETarget do
      exit;
  end;
  AssertTrue(false);
end;

procedure TClassesTest.TestGetFieldValueWrongTarget;
var
  o: TObject;
  v: TObject;
begin
  // test wrong target type
  o := TObject.Create;
  try
    try
      FClassType.GetFields[0].GetValue(o, v);
    except
      on e: EArgument do
        exit;
    end;
    AssertTrue(false);
  finally
    o.Free;
  end;
end;

end.

