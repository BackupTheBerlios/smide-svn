unit Smide.System.Common.Strings;

interface

uses
  Smide.System.Common;

type
  TString = class(TStaticBase)
  public
    class function Compare(s1, s2: WideString): Integer; overload;
    class function Compare(s1, s2: WideString; IgnoreCase: Boolean): Integer; overload;
  end;

implementation

uses
  Smide.System.Globalization;

{ TString }

class function TString.Compare(s1, s2: WideString): Integer;
begin
  Result := TCompareInfo.GetCurrentInfo.Compare(s1, s2);
end;

class function TString.Compare(s1, s2: WideString; IgnoreCase: Boolean): Integer;
const
  Options: array[Boolean] of TCompareOptions = ([], [coIgnoreCase]);
begin
  Result := TCompareInfo.GetCurrentInfo.Compare(s1, s2, Options[IgnoreCase])
end;

end.

