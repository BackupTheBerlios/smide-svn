unit Tests.Smide.System.Types.AllTests;

interface

uses
  Smunit.Framework,
  Smunit.Textui;

type
  {$TYPEINFO ON}
  {$METHODINFO ON}
  {$WARNINGS OFF}
  TAllTests = class
  public
    class function Suite: ITest;
    class procedure Main;
  end;
  {$WARNINGS ON}

implementation

uses
  Tests.Smide.System.Types.Enums,
  Tests.Smide.System.Types.TypeHandlers,
  Tests.Smide.System.Types.Types,
  Tests.Smide.System.Types.Classes;

{ TAllTests }

class procedure TAllTests.Main;
begin
  Smunit.Textui.TTestRunner.Run(Suite).Free;
end;

class function TAllTests.Suite: ITest;
var
  Suite: TTestSuite;
begin
  Suite := TTestSuite.Create('Smide Types Tests');

  Suite.AddTestSuite(Tests.Smide.System.Types.Enums.TEnumsTest);
  Suite.AddTestSuite(Tests.Smide.System.Types.TypeHandlers.TTypeHandlerTest);
  Suite.AddTestSuite(Tests.Smide.System.Types.Types.TTypeTest);
  Suite.AddTestSuite(Tests.Smide.System.Types.Classes.TClassesTest);

  Result := Suite;
end;

end.

