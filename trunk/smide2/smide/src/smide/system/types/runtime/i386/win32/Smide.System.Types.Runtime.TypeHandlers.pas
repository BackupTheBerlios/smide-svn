unit Smide.System.Types.Runtime.TypeHandlers;

interface

uses
  Smide.System.Types.Runtime.TypeInfo,
  Smide.System.Types.Runtime.TypeData,
  Smide.System.Common,
  Smide.System.Reflection,
  Smide.System.Collections;

type
  TPointerType = class(TType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    procedure FreeData(var Data: TTypeData); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider = nil): WideString; override;

    function get_TypeSize: Integer; override;
  protected
    function GetBaseType: TType; override;
  end;

  TVoidType = class(TPointerType)
  end;

  TValueType = class(TType)
  protected
    function GetBaseType: TType; override;
  end;

  TDataType = class(TValueType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure FreeData(var Data: TTypeData); override;
  public
    procedure Alloc(var Result: TTypeData); virtual; abstract;
    procedure Dispose(var Value: TTypeData); virtual; abstract;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); virtual; abstract;
    procedure New(const Value: TTypeData; var Result: TTypeData); virtual;
  end;

  TOrdinalType = class(TValueType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    procedure FreeData(var Data: TTypeData); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  protected
    function GetOrdinalKind: TOrdinalKind; virtual; abstract;
  public
    property OrdinalKind: TOrdinalKind read GetOrdinalKind;
  end;

  TRangeOrdinalType = class(TOrdinalType)
  end;

  TIntegerType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TCardinalType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TShortIntType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TSmallIntType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TLongIntType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TByteType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TWordType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TLongWordType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TInt64Type = class(TDataType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TCharType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TEnumerationType = class(TRangeOrdinalType)
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TSetType = class(TOrdinalType)
  end;

  TWideCharType = class(TRangeOrdinalType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TFloatType = class(TDataType)
  end;

  TSingleType = class(TFloatType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TDoubleType = class(TFloatType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TExtendedType = class(TFloatType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TCompType = class(TFloatType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TCurrencyType = class(TFloatType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TStringType = class(TDataType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TShortStringType = class(TStringType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TWideStringType = class(TDataType)
  public // ITypeHandler
    procedure ClearValue(var Value); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  public // TDataType overrides
    procedure Alloc(var Result: TTypeData); override;
    procedure Dispose(var Value: TTypeData); override;
    procedure Copy(const Source: TTypeData; const Dest: TTypeData); override;
  end;

  TClassType = class(TVoidType)
  public // ITypeHandler
    procedure FreeData(var Data: TTypeData); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function get_TypeSize: Integer; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
  end;

  TMethodType = class(TVoidType)
  end;

  TInterfaceType = class(TVoidType)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); override;
    procedure DataToValue(const Data: TTypeData; var Value); override;
    procedure ClearValue(var Value); override;
    procedure FreeData(var Data: TTypeData); override;
    function CompareValues(const Value1; const Value2): Integer; override;
    function EqualsValues(const Value1; const Value2): Boolean; override;
    function SameValues(const Value1; const Value2): Boolean; override;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString; override;
    function get_TypeSize: Integer; override;
  end;

  TArrayType = class(TDataType)
  end;

  TDynamicArrayType = class(TArrayType)
  end;

  TVariantType = class(TDataType)
  end;

  TRecordType = class(TDataType)
  end;

implementation
uses
  Smide.System,
  Smide.System.Common.Number,
  Smide.System.Globalization,
  Smide.System.Reflection.Runtime;

{ TPointerType }

procedure TPointerType.ClearValue(var Value);
begin
  Pointer(Value) := nil;
end;

function TPointerType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Integer(Value1) - Integer(Value2);
end;

function TPointerType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TPointerType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  // TODO:
  Result := TNumber.FormatInteger(Integer(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

procedure TPointerType.FreeData(var Data: TTypeData);
begin
  Pointer(Data) := nil;
end;

function TPointerType.get_TypeSize: Integer;
begin
  Result := SizeOf(Pointer);
end;

procedure TPointerType.DataToValue(const Data: TTypeData; var Value);
begin
  TTypeData(Value) := Data;
end;

function TPointerType.SameValues(const Value1, Value2): Boolean;
begin
  Result := TTypeData(Value1) = TTypeData(Value2);
end;

procedure TPointerType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(Value);
end;

function TPointerType.GetBaseType: TType;
begin
  Result := nil;
end;

{ TDataType }

procedure TDataType.FreeData(var Data: TTypeData);
begin
  if Data <> nil then
  try
    ClearValue(Data^);
  finally
    Dispose(Data);
    Data := nil;
  end;
end;

procedure TDataType.New(const Value: TTypeData; var Result: TTypeData);
begin
  Alloc(Result);
  Copy(Value, Result);
end;

procedure TDataType.DataToValue(const Data: TTypeData; var Value);
begin
  Copy(Data, @Value);
end;

procedure TDataType.ValueToData(const Value; out Data: TTypeData);
begin
  New(@Value, Data);
end;

{ TInt64Type }

procedure TInt64Type.Alloc(var Result: TTypeData);
begin
  System.New(PInt64(Result));
end;

procedure TInt64Type.ClearValue(var Value);
begin
  Int64(Value) := 0;
end;

function TInt64Type.CompareValues(const Value1, Value2): Integer;
begin
  if Int64(Value1) < Int64(Value2) then
    Result := -1
  else
    if Int64(Value1) > Int64(Value2) then
      Result := 1
    else
      Result := 0;
end;

procedure TInt64Type.Copy(const Source, Dest: TTypeData);
begin
  PInt64(Dest)^ := PInt64(Source)^;
end;

procedure TInt64Type.Dispose(var Value: TTypeData);
begin
  System.Dispose(PInt64(Value));
end;

function TInt64Type.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TInt64Type.get_TypeSize: Integer;
begin
  Result := SizeOf(Int64);
end;

function TInt64Type.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TInt64Type.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  if MinInt64Value < 0 then
    Result := TNumber.FormatInt64(Int64(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)))
  else
    Result := TNumber.FormatUInt64(UInt64(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TStringType }

procedure TStringType.Alloc(var Result: TTypeData);
begin
  System.New(PString(Result));
end;

procedure TStringType.ClearValue(var Value);
begin
  SetLength(string(Value), 0);
end;

function TStringType.CompareValues(const Value1, Value2): Integer;
begin
  // TODO: String.Compare
  if string(Value1) = string(Value2) then
    Result := 0
  else
    Result := 1;
end;

procedure TStringType.Copy(const Source, Dest: TTypeData);
begin
  PString(Dest)^ := PString(Source)^;
end;

procedure TStringType.Dispose(var Value: TTypeData);
begin
  System.Dispose(PString(Value));
end;

function TStringType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TStringType.get_TypeSize: Integer;
begin
  Result := SizeOf(string);
end;

function TStringType.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TStringType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := WideString(string(Value));
end;

{ TShortStringType }

procedure TShortStringType.Alloc(var Result: TTypeData);
begin
  System.New(PShortString(Result));
end;

procedure TShortStringType.ClearValue(var Value);
begin
  SetLength(ShortString(Value), 0);
end;

function TShortStringType.CompareValues(const Value1, Value2): Integer;
begin
  // TODO: String.Compare
  if ShortString(Value1) = ShortString(Value2) then
    Result := 0
  else
    Result := 1;
end;

procedure TShortStringType.Copy(const Source, Dest: TTypeData);
begin
  PShortString(Dest)^ := System.Copy(PShortString(Source)^, 1, MaxLength);
end;

procedure TShortStringType.Dispose(var Value: TTypeData);
begin
  System.Dispose(PShortString(Value));
end;

function TShortStringType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TShortStringType.get_TypeSize: Integer;
begin
  Result := MaxLength + 1;
end;

function TShortStringType.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TShortStringType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := WideString(ShortString(Value));
end;

{ TWideStringType }

procedure TWideStringType.Alloc(var Result: TTypeData);
begin
  System.New(PWideString(Result));
end;

procedure TWideStringType.ClearValue(var Value);
begin
  SetLength(WideString(Value), 0);
end;

function TWideStringType.CompareValues(const Value1, Value2): Integer;
begin
  // TODO: String.Compare
  if WideString(Value1) = WideString(Value2) then
    Result := 0
  else
    Result := 1;
end;

procedure TWideStringType.Copy(const Source, Dest: TTypeData);
begin
  PWideString(Dest)^ := PWideString(Source)^;
end;

procedure TWideStringType.Dispose(var Value: TTypeData);
begin
  System.Dispose(PWideString(Value));
end;

function TWideStringType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TWideStringType.get_TypeSize: Integer;
begin
  Result := SizeOf(WideString);
end;

function TWideStringType.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TWideStringType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := WideString(Value);
end;

{ TClassType }

function TClassType.CompareValues(const Value1, Value2): Integer;
var
  o1, o2: TObject;
  Comparable: IComparable;
begin
  o1 := TObject(Value1);
  o2 := TObject(Value2);

  if o1 <> nil then
  begin
    if TReference.GetInterface(o1, IComparable, Comparable) then
    begin
      Result := Comparable.CompareTo(TObject(Value2));
      exit;
    end;
  end;

  if o2 <> nil then
  begin
    if TReference.GetInterface(o2, IComparable, Comparable) then
    begin
      Result := Comparable.CompareTo(TObject(Value1));
      exit;
    end;
  end;

  Result := inherited CompareValues(o1, o2);
end;

function TClassType.EqualsValues(const Value1, Value2): Boolean;
var
  o1, o2: TObject;
begin
  o1 := TObject(Value1);
  o2 := TObject(Value2);

  if o1 is TSmideObject then
  begin
    Result := (o1 as TSmideObject).Equals(o2);
    exit;
  end;

  if o2 is TSmideObject then
  begin
    Result := (o2 as TSmideObject).Equals(o1);
    exit;
  end;

  Result := SameValues(Value1, Value2);
end;

procedure TClassType.FreeData(var Data: TTypeData);
begin
  TReference.Free(Data);
end;

function TClassType.get_TypeSize: Integer;
begin
  Result := SizeOf(TObject);
end;

function TClassType.SameValues(const Value1, Value2): Boolean;
begin
  Result := TSmideObject.ReferenceEquals(TObject(Value1), TObject(Value2));
end;

function TClassType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
var
  Obj: TObject;
begin
  Obj := TObject(Value);

  if Obj = nil then
    Result := ''
  else
    if Obj is TSmideObject then
      Result := (Obj as TSmideObject).ToString
    else
      Result := Obj.ClassName;
end;

{ TCharType }

procedure TCharType.ClearValue(var Value);
begin
  Char(Value) := #0;
end;

function TCharType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Integer(Char(Value1)) - Integer(Char(Value2));
end;

procedure TCharType.DataToValue(const Data: TTypeData; var Value);
begin
  Char(Value) := Char(Data);
end;

procedure TCharType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(Char(Value));
end;

function TCharType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := Char(Value);
end;

{ TWideCharType }

procedure TWideCharType.ClearValue(var Value);
begin
  WideChar(Value) := #0;
end;

function TWideCharType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Integer(WideChar(Value1)) - Integer(WideChar(Value2));
end;

procedure TWideCharType.DataToValue(const Data: TTypeData; var Value);
begin
  WideChar(Value) := WideChar(Data);
end;

procedure TWideCharType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(WideChar(Value));
end;

function TWideCharType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := WideChar(Value);
end;

{ TIntegerType }

procedure TIntegerType.ClearValue(var Value);
begin
  Integer(Value) := 0;
end;

function TIntegerType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Integer(Value1) - Integer(Value2);
end;

procedure TIntegerType.DataToValue(const Data: TTypeData; var Value);
begin
  Integer(Value) := Integer(Data);
end;

procedure TIntegerType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(Integer(Value));
end;

function TIntegerType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatInteger(Integer(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TCardinalType }

procedure TCardinalType.ClearValue(var Value);
begin
  Cardinal(Value) := 0;
end;

function TCardinalType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Cardinal(Value1) - Cardinal(Value2);
end;

procedure TCardinalType.DataToValue(const Data: TTypeData; var Value);
begin
  Cardinal(Value) := Cardinal(Data);
end;

procedure TCardinalType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(Cardinal(Value));
end;

function TCardinalType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatCardinal(Cardinal(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TShortIntType }

procedure TShortIntType.ClearValue(var Value);
begin
  ShortInt(Value) := 0;
end;

function TShortIntType.CompareValues(const Value1, Value2): Integer;
begin
  Result := ShortInt(Value1) - ShortInt(Value2);
end;

procedure TShortIntType.DataToValue(const Data: TTypeData; var Value);
begin
  ShortInt(Value) := ShortInt(Data);
end;

procedure TShortIntType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(ShortInt(Value));
end;

function TShortIntType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatShortInt(ShortInt(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TSmallIntType }

procedure TSmallIntType.ClearValue(var Value);
begin
  SmallInt(Value) := 0;
end;

function TSmallIntType.CompareValues(const Value1, Value2): Integer;
begin
  Result := SmallInt(Value1) - SmallInt(Value2);
end;

procedure TSmallIntType.DataToValue(const Data: TTypeData; var Value);
begin
  SmallInt(Value) := SmallInt(Data);
end;

procedure TSmallIntType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(SmallInt(Value));
end;

function TSmallIntType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatSmallInt(SmallInt(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TLongIntType }

procedure TLongIntType.ClearValue(var Value);
begin
  Longint(Value) := 0;
end;

function TLongIntType.CompareValues(const Value1, Value2): Longint;
begin
  Result := Longint(Value1) - Longint(Value2);
end;

procedure TLongIntType.DataToValue(const Data: TTypeData; var Value);
begin
  Longint(Value) := Longint(Data);
end;

procedure TLongIntType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(Longint(Value));
end;

function TLongIntType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatLongInt(Longint(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TByteType }

procedure TByteType.ClearValue(var Value);
begin
  Byte(Value) := 0;
end;

function TByteType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Byte(Value1) - Byte(Value2);
end;

procedure TByteType.DataToValue(const Data: TTypeData; var Value);
begin
  Byte(Value) := Byte(Data);
end;

procedure TByteType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(Byte(Value));
end;

function TByteType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatByte(Byte(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TWordType }

procedure TWordType.ClearValue(var Value);
begin
  Word(Value) := 0;
end;

function TWordType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Word(Value1) - Word(Value2);
end;

procedure TWordType.DataToValue(const Data: TTypeData; var Value);
begin
  Word(Value) := Word(Data);
end;

procedure TWordType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(Word(Value));
end;

function TWordType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatWord(Word(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TLongWordType }

procedure TLongWordType.ClearValue(var Value);
begin
  LongWord(Value) := 0;
end;

function TLongWordType.CompareValues(const Value1, Value2): Integer;
begin
  Result := LongWord(Value1) - LongWord(Value2);
end;

procedure TLongWordType.DataToValue(const Data: TTypeData; var Value);
begin
  LongWord(Value) := LongWord(Data);
end;

procedure TLongWordType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := TTypeData(LongWord(Value));
end;

function TLongWordType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatLongWord(LongWord(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TInterfaceType }

procedure TInterfaceType.ClearValue(var Value);
begin
  IInterface(Value) := nil;
end;

function TInterfaceType.CompareValues(const Value1, Value2): Integer;
begin
  Result := TReference.Compare(IInterface(Value1), IInterface(Value2));
end;

function TInterfaceType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

procedure TInterfaceType.FreeData(var Data: TTypeData);
begin
  IInterface(Data) := nil;
end;

function TInterfaceType.get_TypeSize: Integer;
begin
  Result := SizeOf(IInterface);
end;

procedure TInterfaceType.DataToValue(const Data: TTypeData; var Value);
begin
  IInterface(Value) := IInterface(Data);
end;

function TInterfaceType.SameValues(const Value1, Value2): Boolean;
begin
  Result := TReference.SameObject(IInterface(Value1), IInterface(Value2));
end;

procedure TInterfaceType.ValueToData(const Value; out Data: TTypeData);
begin
  Data := nil;
  IInterface(Data) := IInterface(Value);
end;

function TInterfaceType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
var
  Formatible: IFormatible;
  Obj: TObject;
  Intf: IInterface;
begin
  // First check if the interface supports the IFormatible
  if TReference.GetInterface(IInterface(Value), IFormatible, Formatible) then
  begin
    Result := Formatible.ToString(Format, FormatProvider);
    exit;
  end;

  // if the value supports the IReferenceable interface and the instance of this
  // interface inherits from TSmideObject, call the ToString Method
  Obj := TReference.GetInstance(IInterface(Value));
  if Obj is TSmideObject then
  begin
    Result := (Obj as TSmideObject).ToString;
    exit;
  end;

  // now the hard way
  // Get the IInterface instance of the value and try
  // if there is an interface map entry for this in the class typeinfo,
  // to get the value instance
  // not realy working

  if TReference.GetInterface(IInterface(Value), IInterface, Intf) then
  begin
    Obj := TReference.GetObject(Intf, IInterface, TSmideObject);
    if Obj is TSmideObject then
    begin
      Result := (Obj as TSmideObject).ToString;
      exit;
    end;
  end;

  // everything goes wrong...
  // return the Fullname
  Result := FullName;
end;

{ TValueType }

function TValueType.GetBaseType: TType;
begin
  Result := nil;
end;

{ TSingleType }

procedure TSingleType.Alloc(var Result: TTypeData);
begin
  System.New(PSingle(Result));
end;

procedure TSingleType.ClearValue(var Value);
begin
  Single(Value) := 0;
end;

function TSingleType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Trunc(Single(Value1) - Single(Value2));
end;

procedure TSingleType.Copy(const Source, Dest: TTypeData);
begin
  PSingle(Dest)^ := PSingle(Source)^;
end;

procedure TSingleType.Dispose(var Value: TTypeData);
begin
  System.Dispose(PSingle(Value));
end;

function TSingleType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TSingleType.get_TypeSize: Integer;
begin
  Result := SizeOf(Single);
end;

function TSingleType.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TSingleType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatSingle(Single(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TDoubleType }

procedure TDoubleType.Alloc(var Result: TTypeData);
begin
  System.New(PDouble(Result));
end;

procedure TDoubleType.ClearValue(var Value);
begin
  Double(Value) := 0;
end;

function TDoubleType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Trunc(Double(Value1) - Double(Value2));
end;

procedure TDoubleType.Copy(const Source, Dest: TTypeData);
begin
  PDouble(Dest)^ := PDouble(Source)^;
end;

procedure TDoubleType.Dispose(var Value: TTypeData);
begin
  System.Dispose(PDouble(Value));
end;

function TDoubleType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TDoubleType.get_TypeSize: Integer;
begin
  Result := SizeOf(Double);
end;

function TDoubleType.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TDoubleType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatDouble(Double(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TExtendedType }

procedure TExtendedType.Alloc(var Result: TTypeData);
begin
  System.New(PExtended(Result));
end;

procedure TExtendedType.ClearValue(var Value);
begin
  Extended(Value) := 0;
end;

function TExtendedType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Trunc(Extended(Value1) - Extended(Value2));
end;

procedure TExtendedType.Copy(const Source, Dest: TTypeData);
begin
  PExtended(Dest)^ := PExtended(Source)^;
end;

procedure TExtendedType.Dispose(var Value: TTypeData);
begin
  System.Dispose(PExtended(Value));
end;

function TExtendedType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TExtendedType.get_TypeSize: Integer;
begin
  Result := SizeOf(Extended);
end;

function TExtendedType.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TExtendedType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatExtended(Extended(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TCompType }

procedure TCompType.Alloc(var Result: TTypeData);
begin
  System.New(PComp(Result));
end;

procedure TCompType.ClearValue(var Value);
begin
  Comp(Value) := 0;
end;

function TCompType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Trunc(Comp(Value1) - Comp(Value2));
end;

procedure TCompType.Copy(const Source, Dest: TTypeData);
begin
  PComp(Dest)^ := PComp(Source)^;
end;

procedure TCompType.Dispose(var Value: TTypeData);
begin
  System.Dispose(PComp(Value));
end;

function TCompType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TCompType.get_TypeSize: Integer;
begin
  Result := SizeOf(Comp);
end;

function TCompType.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TCompType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatComp(Comp(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TCurrencyType }

procedure TCurrencyType.Alloc(var Result: TTypeData);
begin
  System.New(PCurrency(Result));
end;

procedure TCurrencyType.ClearValue(var Value);
begin
  Currency(Value) := 0;
end;

function TCurrencyType.CompareValues(const Value1, Value2): Integer;
begin
  Result := Trunc(Currency(Value1) - Currency(Value2));
end;

procedure TCurrencyType.Copy(const Source, Dest: TTypeData);
begin
  PCurrency(Dest)^ := PCurrency(Source)^;
end;

procedure TCurrencyType.Dispose(var Value: TTypeData);
begin
  System.Dispose(PCurrency(Value));
end;

function TCurrencyType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TCurrencyType.get_TypeSize: Integer;
begin
  Result := SizeOf(Currency);
end;

function TCurrencyType.SameValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

function TCurrencyType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  Result := TNumber.FormatCurrency(Currency(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
end;

{ TOrdinalType }

procedure TOrdinalType.ClearValue(var Value);
begin
  case OrdinalKind of
    okUnsignedByte: Byte(Value) := 0;
    okSignedByte: ShortInt(Value) := 0;
    otUnsignedWord: Word(Value) := 0;
    okSignedWord: SmallInt(Value) := 0;
    otUnsignedLong: Cardinal(Value) := 0;
    otSignedLong: Integer(Value) := 0;
  else
    raise EUnknownType.Create(Name);
  end;
end;

function TOrdinalType.CompareValues(const Value1, Value2): Integer;
begin
  case OrdinalKind of
    okUnsignedByte: Result := Byte(Value1) - Byte(Value2);
    okSignedByte: Result := ShortInt(Value1) - ShortInt(Value2);
    otUnsignedWord: Result := Word(Value1) - Word(Value2);
    okSignedWord: Result := SmallInt(Value1) - SmallInt(Value2);
    otUnsignedLong: Result := Cardinal(Value1) - Cardinal(Value2);
    otSignedLong: Result := Integer(Value1) - Integer(Value2);
  else
    raise EUnknownType.Create(Name);
  end;
end;

function TOrdinalType.EqualsValues(const Value1, Value2): Boolean;
begin
  Result := CompareValues(Value1, Value2) = 0;
end;

procedure TOrdinalType.FreeData(var Data: TTypeData);
begin
  Data := nil;
end;

function TOrdinalType.get_TypeSize: Integer;
begin
  case OrdinalKind of
    okSignedByte: Result := SizeOf(ShortInt);
    okUnsignedByte: Result := SizeOf(Byte);
    okSignedWord: Result := SizeOf(SmallInt);
    otUnsignedWord: Result := SizeOf(Word);
    otSignedLong: Result := SizeOf(Integer);
    otUnsignedLong: Result := SizeOf(Cardinal);
  else
    raise EUnknownType.Create(Name);
  end;
end;

procedure TOrdinalType.DataToValue(const Data: TTypeData; var Value);
begin
  case OrdinalKind of
    okUnsignedByte: Byte(Value) := Byte(Data);
    okSignedByte: ShortInt(Value) := ShortInt(Data);
    otUnsignedWord: Word(Value) := Word(Data);
    okSignedWord: SmallInt(Value) := SmallInt(Data);
    otUnsignedLong: Cardinal(Value) := Cardinal(Data);
    otSignedLong: Integer(Value) := Integer(Data);
  else
    raise EUnknownType.Create(Name);
  end;
end;

function TOrdinalType.SameValues(const Value1, Value2): Boolean;
begin
  Result := EqualsValues(Value1, Value2);
end;

procedure TOrdinalType.ValueToData(const Value; out Data: TTypeData);
begin
  case OrdinalKind of
    okUnsignedByte: Data := TTypeData(Byte(Value));
    okSignedByte: Data := TTypeData(ShortInt(Value));
    otUnsignedWord: Data := TTypeData(Word(Value));
    okSignedWord: Data := TTypeData(SmallInt(Value));
    otUnsignedLong: Data := TTypeData(Cardinal(Value));
    otSignedLong: Data := TTypeData(Integer(Value));
  else
    raise EUnknownType.Create(Name);
  end;
end;

function TOrdinalType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  case OrdinalKind of
    okUnsignedByte: Result := TNumber.FormatByte(Byte(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
    okSignedByte: Result := TNumber.FormatShortInt(ShortInt(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
    otUnsignedWord: Result := TNumber.FormatWord(Word(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
    okSignedWord: Result := TNumber.FormatSmallInt(SmallInt(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
    otUnsignedLong: Result := TNumber.FormatCardinal(Cardinal(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
    otSignedLong: Result := TNumber.FormatInteger(Integer(Value), Format, TNumberFormatInfo(TNumberFormatInfo.GetInstance(FormatProvider)));
  else
    raise EUnknownType.Create(Name);
  end;
end;

{ TEnumerationType }

function TEnumerationType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
var
  v, v2: Integer;
begin
  case OrdinalKind of
    okUnsignedByte: v := Byte(Value);
    okSignedByte: v := ShortInt(Value);
    otUnsignedWord: v := Word(Value);
    okSignedWord: v := SmallInt(Value);
    otUnsignedLong: v := Cardinal(Value);
    otSignedLong: v := Integer(Value);
  else
    raise EUnknownType.Create(Name);
  end;

  with GetFields.GetEnumerator do
    while MoveNext do
    begin
      if Current is TRuntimeEnumerationFieldInfo then
      begin
        Current.GetValue(Value, v2);
        if EqualsValues(v, v2) then
        begin
          Result := Current.Name;
          exit;
        end;
      end
    end;

  raise EInvalidOperation.Create;
end;

end.
