unit Smide.System.Common.Strings;

interface

uses
  Smide.System.Common;

type
  TString = class(TStaticBase)
  public
    class function Compare(s1, s2: WideString): Integer;
  end;

implementation

uses
  Smide.System.Globalization;

{ TString }

class function TString.Compare(s1, s2: WideString): Integer;
begin
  Result := TCompareInfo.GetCurrentInfo.Compare(s1, s2);
end;

end.

