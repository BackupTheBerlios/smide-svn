program TestsSmunitRunner;

{$APPTYPE CONSOLE}

uses
  Smunit.Framework,
  Smunit.Textui,
  Tests.Smunit.Framework.AllTests;

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

  { TAllTests }

class procedure TAllTests.Main;
begin
  Smunit.Textui.TTestRunner.Run(Suite).Free;
end;

class function TAllTests.Suite: ITest;
var
  Suite: TTestSuite;
begin
  Suite := TTestSuite.Create('Smunit Tests');

  Suite.AddTest(Tests.Smunit.Framework.AllTests.TAllTests.Suite);

  Result := Suite;
end;

begin
  TAllTests.Main;
end.

