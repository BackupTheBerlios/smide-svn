unit Tests.Smide.System.AllTests;

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
    class procedure Main;
    class function Suite: ITest;
  end;
  {$WARNINGS ON}

implementation

uses
  Tests.Smide.System.Strings,
  Tests.Smide.System.Types.AllTests;

{ TAllTests }

class procedure TAllTests.Main;
begin
  Smunit.Textui.TTestRunner.Run(Suite).Free;
end;

class function TAllTests.Suite: ITest;
var
  Suite: TTestSuite;
begin
  Suite := TTestSuite.Create('Smide Tests');

  Suite.AddTestSuite(Tests.Smide.System.Strings.TStringsTest);

  Suite.AddTest(Tests.Smide.System.Types.AllTests.TAllTests.Suite);

  Result := Suite;
end;

end.

