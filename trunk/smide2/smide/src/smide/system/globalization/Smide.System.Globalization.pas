unit Smide.System.Globalization;

interface

uses
  Smide.System.Runtime,
  Smide.System.Common;

type
  TNumberFormatInfo = class(TSmideObject)
  public
    class function GetInstance(FormatProvider: IFormatProvider): TObject;

    class function CurrentInfo: TNumberFormatInfo;
  end;

implementation

uses
  Smide.System.Types;

{ TNumberFormatInfo }

class function TNumberFormatInfo.CurrentInfo: TNumberFormatInfo;
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

  Result := CurrentInfo;
end;

end.
