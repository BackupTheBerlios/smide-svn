unit Tests.Smide.System.Globalization.AllTests;

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
  Tests.Smide.System.Globalization.CompareInfo;

{ TAllTests }

class procedure TAllTests.Main;
begin
  Smunit.Textui.TTestRunner.Run(Suite).Free;
end;

class function TAllTests.Suite: ITest;
var
  Suite: TTestSuite;
begin
  Suite := TTestSuite.Create('Smide Globalization Tests');

  Suite.AddTestSuite(Tests.Smide.System.Globalization.CompareInfo.TCompareInfoTest);

  Result := Suite;
end;

end.
