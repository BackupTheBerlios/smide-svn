unit Tests.Smide.System.Globalization.CompareInfo;

interface

uses
  Smunit.Framework,
  Smide.System.Globalization;

type
  TCompareInfoTest = class(TTestCase)
  protected
    FCompareInfo: TCompareInfo;
    procedure SetUp; override;
  public
    procedure Test;
    //TODO: CompareInfo Tests
  end;

implementation

{ TCompareInfoTest }

procedure TCompareInfoTest.SetUp;
begin
  FCompareInfo := TCompareInfo.GetCurrentInfo;
end;

procedure TCompareInfoTest.Test;
const
  AlphabetLower: WideString = 'abcdefghijklmnopqrstuvwxyz';
  AlphabetUpper: WideString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  s1: WideString;
begin
  AssertTrue(FCompareInfo.Compare('a', '-', [coStringSort]) > 0);
  AssertTrue(FCompareInfo.Compare('a', '-a', [coStringSort]) > 0);
  AssertTrue(FCompareInfo.Compare('a', '-') > 0);
  AssertTrue(FCompareInfo.Compare('a', '-a') < 0);
  AssertTrue(FCompareInfo.Compare('coop', 'co-op') < 0);

  s1 := AlphabetLower;
  AssertTrue(FCompareInfo.Compare(s1, AlphabetLower) = 0);
  AssertTrue(FCompareInfo.Compare(s1, AlphabetUpper) < 0);
end;

end.

