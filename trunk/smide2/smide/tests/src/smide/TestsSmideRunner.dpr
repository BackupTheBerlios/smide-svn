program TestsSmideRunner;

{$APPTYPE CONSOLE}

uses
  Smunit.Framework,
  Smunit.Textui,
  Tests.Smide.System.AllTests;


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
  Suite := TTestSuite.Create('Smide Tests');

  Suite.AddTest(Tests.Smide.System.AllTests.TAllTests.Suite);

  Result := Suite;
end;

begin
  TAllTests.Main;
end.
