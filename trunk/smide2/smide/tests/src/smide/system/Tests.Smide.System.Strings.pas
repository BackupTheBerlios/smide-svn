unit Tests.Smide.System.Strings;

interface

uses
  Smide.System,
  Smunit.Framework;

type
  TStringsTest = class(TTestCase)
  public
    procedure TestCompareWideString;
  end;

implementation

{ TStringsTest }

procedure TStringsTest.TestCompareWideString;
var
  s1, s2: WideString;
begin
  s1 := 'ABC';
  s2 := 'DEF';
  AssertTrue(TString.Compare(s1, s2) <> 0);
end;

end.

