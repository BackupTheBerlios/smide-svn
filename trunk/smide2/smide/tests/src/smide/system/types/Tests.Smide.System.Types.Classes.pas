unit Tests.Smide.System.Types.Classes;

interface

uses
  Smide.System,
  Smide.System.Reflection,
  Smunit.Framework;

type
  {$TYPEINFO ON}
  {$METHODINFO ON}
  TTestObject = class
  public
    IntegerField: Integer;
    WordField: Integer;
    StringField: Integer;
  published
    ObjectField1: TObject;
    ObjectField2: TSmideObject;
    InterfaceField: IUnknown;
  end;
  {$METHODINFO OFF}
  {$TYPEINFO OFF}

  TClassesTest = class(TTestCase)
  private
    FClassType: TType;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    //procedure TestGetFieldsWithBindingFlags;
    procedure TestGetFields;
  end;

implementation

{ TClassesTest }

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
  AssertEquals(2, FClassType.GetFields.Count);

  AssertEquals('ObjectField1', FClassType.GetFields[0].Name);
  AssertEquals(TObject.ClassName, FClassType.GetFields[0].FieldType.Name);

  AssertEquals('ObjectField2', FClassType.GetFields[1].Name);
  AssertEquals(TSmideObject.ClassName, FClassType.GetFields[1].FieldType.Name);
end;

end.

