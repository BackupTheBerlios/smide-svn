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

    property CultureId: Integer read FCultureId;
  end;

  TRuntimeCultureInfo = class(TCultureInfo)
  public
    class function GetRuntimeCurrentCulture: TCultureInfo;
  end;

implementation

uses
  Windows,
  Smide.System.Runtime.Exceptions;

{ TRuntimeCompareInfo }

function TRuntimeCompareInfo.Compare(s1, s2: WideString; Options: TCompareOptions): Integer;
begin
  Result := Windows.CompareStringW(CultureId, 0, PWideChar(s1), -1, PWideChar(s2), -1);
  if Result = 0 then
  begin
    raise EOsError.Create(GetLastError);
  end
  else
    Result := Result - 2;
  raise EOsError.Create(GetLastError);
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

