unit Smide.System.Globalization;

interface

uses
  Smide.System.Runtime,
  Smide.System.Common;

type
  TNumberFormatInfo = class(TSmideObject)
  public
    class function GetInstance(FormatProvider: IFormatProvider): TObject;

    class function GetCurrentInfo: TNumberFormatInfo;
  end;

  TCompareOption = (
    coIgnoreCase,
    coIgnoreNonSpace,
    coIgnoreSymbols,
    coIgnoreKanaType,
    coIgnoreWidth,
    coStringSort,
    coOrdinal);

  TCompareOptions = set of TCompareOption;

  TCompareInfo = class(TSmideObject)
  protected
    constructor Create(Culture: Integer); virtual; abstract;
  public
    class function GetCurrentInfo: TCompareInfo;

    class function GetCompareInfo(Culture: Integer): TCompareInfo;

    function Compare(s1, s2: WideString): Integer; overload;
    function Compare(s1, s2: WideString; Options: TCompareOptions): Integer; overload; virtual; abstract;

    function CompareOrdinal(s1, s2: WideString): Integer; overload;
    function CompareOrdinal(s1: WideString; l1: Integer; s2: WideString; l2: Integer): Integer; overload; virtual; abstract;
  end;

  TCultureInfo = class(TSmideObject)
  private
    FCultureId: Integer;
    function get_CompareInfo: TCompareInfo;
  public
    constructor Create(CultureId: Integer);

    class function GetCurrentCulture: TCultureInfo;

    property CompareInfo: TCompareInfo read get_CompareInfo;
    property CultureId: Integer read FCultureId;
  end;

implementation

uses
  Smide.System.Types,
  Smide.System.Globalization.Runtime;

{ TNumberFormatInfo }

class function TNumberFormatInfo.GetCurrentInfo: TNumberFormatInfo;
begin
  // TODO
  Result := nil;
end;

class function TNumberFormatInfo.GetInstance(FormatProvider: IFormatProvider): TObject;
var
  Service: TObject;
begin
  if FormatProvider <> nil then
  begin
    Service := FormatProvider.GetFormat(TType.GetType(TNumberFormatInfo).RuntimeTypeHandle);
    if Service <> nil then
    begin
      Result := Service as TNumberFormatInfo;
      exit;
    end;
  end;

  Result := GetCurrentInfo;
end;

{ TCompareInfo }

function TCompareInfo.Compare(s1, s2: WideString): Integer;
begin
  Result := Compare(s1, s2, []);
end;

function TCompareInfo.CompareOrdinal(s1, s2: WideString): Integer;
begin
  Result := CompareOrdinal(s1, Length(s1), s2, Length(s2));
end;

class function TCompareInfo.GetCompareInfo(Culture: Integer): TCompareInfo;
begin
  Result := TRuntimeCompareInfo.GetRuntimeCompareInfo(Culture);
end;

class function TCompareInfo.GetCurrentInfo: TCompareInfo;
begin
  Result := TCultureInfo.GetCurrentCulture.CompareInfo;
end;

{ TCultureInfo }

function TCultureInfo.get_CompareInfo: TCompareInfo;
begin
  Result := TCompareInfo.GetCompareInfo(CultureId);
end;

class function TCultureInfo.GetCurrentCulture: TCultureInfo;
begin
  Result := TRuntimeCultureInfo.GetRuntimeCurrentCulture;
end;

constructor TCultureInfo.Create(CultureId: Integer);
begin
  inherited Create;
  FCultureId := CultureId;
end;

end.

