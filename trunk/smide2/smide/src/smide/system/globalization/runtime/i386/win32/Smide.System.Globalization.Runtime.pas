unit Smide.System.Globalization.Runtime;

interface

uses
  Smide.System.Globalization;

type

  TRuntimeCompareInfo = class(TCompareInfo)
  private
    FCultureId: Integer;
  protected
    constructor Create(CultureId: Integer); override;
  public
    class function GetRuntimeCompareInfo(CultureId: Integer): TCompareInfo;

    function Compare(s1, s2: WideString; Options: TCompareOptions): Integer; override;

    function CompareOrdinal(s1: WideString; l1: Integer; s2: WideString; l2: Integer): Integer; override;

    property CultureId: Integer read FCultureId;
  end;

  TRuntimeCultureInfo = class(TCultureInfo)
  public
    class function GetRuntimeCurrentCulture: TCultureInfo;
  end;

implementation

uses
  Windows,
  Smide.System.Common,
  Smide.System.Common.GetText,
  Smide.System.Runtime.Exceptions;

{ TRuntimeCompareInfo }

function TRuntimeCompareInfo.Compare(s1, s2: WideString; Options: TCompareOptions): Integer;
const
  CompareOptions: array[TCompareOption] of Integer =
  (NORM_IGNORECASE,
    NORM_IGNORENONSPACE,
    NORM_IGNORESYMBOLS,
    NORM_IGNOREKANATYPE,
    NORM_IGNOREWIDTH,
    SORT_STRINGSORT,
    0);
var
  Flags: Integer;
  i: TCompareOption;
begin
  Flags := 0;
  if coOrdinal in Options then
  begin
    if Options = [coOrdinal] then
      Result := CompareOrdinal(s1, s2)
    else
      raise EArgument.Create(_('coOrdinal cannot be used with other options.'), 'Options');
  end
  else
  begin
    for i := low(TCompareOption) to High(TCompareOption) do
      if i in Options then
        Flags := Flags or CompareOptions[i];

    Result := Windows.CompareStringW(CultureId, Flags, PWideChar(s1), -1, PWideChar(s2), -1);
    if Result = 0 then
    begin
      raise EOsError.Create(GetLastError);
    end
    else
      Result := Result - 2;
  end;
end;

function TRuntimeCompareInfo.CompareOrdinal(s1: WideString; l1: Integer; s2: WideString; l2: Integer): Integer;
begin
  raise ENotImplemented.Create('TRuntimeCompareInfo.CompareOrdinal');
end;

constructor TRuntimeCompareInfo.Create(CultureId: Integer);
begin
  FCultureId := CultureId;
end;

class function TRuntimeCompareInfo.GetRuntimeCompareInfo(CultureId: Integer): TCompareInfo;
begin
  Result := TRuntimeCompareInfo.Create(CultureId);
end;

{ TRuntimeCultureInfo }

var
  FUserDefaultCulture: TCultureInfo = nil;

class function TRuntimeCultureInfo.GetRuntimeCurrentCulture: TCultureInfo;
begin
  if not Assigned(FUserDefaultCulture) then
  begin
    FUserDefaultCulture := TRuntimeCultureInfo.Create(GetUserDefaultLCID);
  end;
  Result := FUserDefaultCulture;
end;

initialization

finalization
  FUserDefaultCulture.Free;
end.

