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

end.

