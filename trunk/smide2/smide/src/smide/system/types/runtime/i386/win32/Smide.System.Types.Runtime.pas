unit Smide.System.Types.Runtime;

interface

uses
  Smide.System,
  Smide.System.Types,
  Smide.System.Types.Runtime.TypeInfo,
  Smide.System.Reflection.Runtime.Handles,
  Smide.System.Reflection,
  Smide.System.Types.Runtime.Collectors,
  Smide.System.Types.Runtime.TypeHandlers;

type
  TRuntimeType = class(TType)
  public
    class function GetRuntimeType(TypeHandle: TRuntimeTypeHandle): TType;
    class function GetRuntimeOrdinalType(TypeHandle: TRuntimeTypeHandle): TType;
    class function GetRuntimeTypeHandler(TypeHandle: TRuntimeTypeHandle): ITypeHandler;
    class function GetRuntimeOrdinalTypeHandler(TypeHandle: TRuntimeTypeHandle): ITypeHandler;

    class function CreateRuntimeType(TypeHandle: TRuntimeTypeHandle; TypeInfoData: TRuntimeTypeInfoData): TType;
    class function CreateRuntimeOrdinalType(TypeHandle: TRuntimeTypeHandle; TypeInfoData: TRuntimeTypeInfoData): TType;

    class function GetRuntimeTypeDataTypeHandler: ITypeHandler;
  end;

  TRuntimeOrdinalType = class(TOrdinalType)
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeRangeOrdinalType = class(TRangeOrdinalType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeIntegerType = class(TIntegerType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeCardinalType = class(TCardinalType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeShortIntType = class(TShortIntType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeSmallIntType = class(TSmallIntType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeLongIntType = class(TLongIntType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeByteType = class(TByteType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeWordType = class(TWordType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeLongWordType = class(TLongWordType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeCharType = class(TCharType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeEnumerationType = class(TEnumerationType)
  public
    function IsBoolean: Boolean;
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
    function GetBaseType: TType; override;
  private
    FFieldCollector: TFieldCollector;
    function GetFieldCollector: TFieldCollector;
  protected
    property FieldCollector: TFieldCollector read GetFieldCollector;
  public
    function GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo; override;
    function GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection; override;
  public
    destructor Destroy; override;
  end;

  TRuntimeSetType = class(TSetType)
  protected
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeWideCharType = class(TWideCharType)
  protected
    function GetMinValue: Integer; override;
    function GetMaxValue: Integer; override;
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
    function GetOrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeFloatType = class(TFloatType)
  end;

  TRuntimeSingleType = class(TSingleType)
  end;

  TRuntimeDoubleType = class(TDoubleType)
  end;

  TRuntimeExtendedType = class(TExtendedType)
  end;

  TRuntimeCompType = class(TCompType)
  end;

  TRuntimeCurrencyType = class(TCurrencyType)
  end;

  TRuntimeStringType = class(TStringType)
  end;

  TRuntimeShortStringType = class(TShortStringType)
  protected
    function GetMaxLength: Byte; override;
  end;

  TRuntimeWideStringType = class(TWideStringType)
  end;

  TRuntimeClassType = class(TClassType)
  protected // Name and Namespace overrides
    function GetNamespace: WideString; override;
  protected // Attributes
    function GetAttributes: TTypeAttributes; override;
  private
    FMethodCollector: TMethodCollector;
    function GetMethodCollector: TMethodCollector;
  protected
    property MethodCollector: TMethodCollector read GetMethodCollector;
  public // IReflect
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
      Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo; override;
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags): TMethodInfo; override;
    function GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection; override;
  protected
    function GetBaseType: TType; override;
  public
    destructor Destroy; override;
  end;

  TRuntimeMethodType = class(TMethodType)
  end;

  TRuntimeInterfaceType = class(TInterfaceType)
  protected // Name and Namespace overrides
    function GetNamespace: WideString; override;
  end;

  TRuntimeInt64Type = class(TInt64Type)
  protected
    function GetMinInt64Value: Int64; override;
    function GetMaxInt64Value: Int64; override;
  end;

  TRuntimeArrayType = class(TArrayType)
  end;

  TRuntimeDynamicArrayType = class(TDynamicArrayType)
  end;

  TRuntimeVariantType = class(TVariantType)
  end;

  TRuntimeRecordType = class(TRecordType)
  end;

const
  TYPE_DATA_TYPEINFO: TTypeInfo = (Kind: tkUnknown; Name: 'TTypeData');

implementation

uses
  Smide.System.Types.Runtime.Cache,
  Smide.System.Types.Runtime.ClassTypeCollectors,
  Smide.System.Types.Runtime.EnumerationTypeCollectors;

{ TRuntimeType }

class function TRuntimeType.CreateRuntimeOrdinalType(TypeHandle: TRuntimeTypeHandle; TypeInfoData: TRuntimeTypeInfoData): TType;
begin
  case TypeInfoData.OrdinalKind of
    okSignedByte: Result := TRuntimeShortIntType.Create(TypeHandle, TypeInfoData);
    okUnsignedByte: Result := TRuntimeByteType.Create(TypeHandle, TypeInfoData);
    okSignedWord: Result := TRuntimeSmallIntType.Create(TypeHandle, TypeInfoData);
    otUnsignedWord: Result := TRuntimeWordType.Create(TypeHandle, TypeInfoData);
    otSignedLong: Result := TRuntimeIntegerType.Create(TypeHandle, TypeInfoData);
    otUnsignedLong: Result := TRuntimeCardinalType.Create(TypeHandle, TypeInfoData);
  else
    raise EUnknownType.Create(TypeHandle^.Name);
  end;
end;

class function TRuntimeType.CreateRuntimeType(TypeHandle: TRuntimeTypeHandle; TypeInfoData: TRuntimeTypeInfoData): TType;
begin
  Result := nil;
  if TypeHandle = nil then
    raise EArgumentNil.Create('TypeHandle');

  case TypeHandle^.Kind of
    tkInteger: Result := CreateRuntimeOrdinalType(TypeHandle, TypeInfoData);

    tkChar: Result := TRuntimeCharType.Create(TypeHandle, TypeInfoData);
    tkEnumeration: Result := TRuntimeEnumerationType.Create(TypeHandle, TypeInfoData);

    tkFloat:
      case TypeInfoData.FloatKind of
        fkSingle: Result := TRuntimeSingleType.Create(TypeHandle, TypeInfoData);
        fkDouble: Result := TRuntimeDoubleType.Create(TypeHandle, TypeInfoData);
        fkExtended: Result := TRuntimeExtendedType.Create(TypeHandle, TypeInfoData);
        fkComp: Result := TRuntimeCompType.Create(TypeHandle, TypeInfoData);
        fkCurrency: Result := TRuntimeCurrencyType.Create(TypeHandle, TypeInfoData);
      else
        Result := TRuntimeFloatType.Create(TypeHandle, TypeInfoData);
      end;

    tkString: Result := TRuntimeShortStringType.Create(TypeHandle, TypeInfoData);
    tkSet: Result := TRuntimeSetType.Create(TypeHandle, TypeInfoData);
    tkClass: Result := TRuntimeClassType.Create(TypeHandle, TypeInfoData);
    tkMethod: Result := TRuntimeMethodType.Create(TypeHandle, TypeInfoData);
    tkWideChar: Result := TRuntimeWideCharType.Create(TypeHandle, TypeInfoData);
    tkLongString: Result := TRuntimeStringType.Create(TypeHandle, TypeInfoData);
    tkWideString: Result := TRuntimeWideStringType.Create(TypeHandle, TypeInfoData);
    tkVariant: Result := TRuntimeVariantType.Create(TypeHandle, TypeInfoData);
    tkArray: Result := TRuntimeArrayType.Create(TypeHandle, TypeInfoData);
    tkRecord: Result := TRuntimeRecordType.Create(TypeHandle, TypeInfoData);
    tkInterface: Result := TRuntimeInterfaceType.Create(TypeHandle, TypeInfoData);
    tkInt64: Result := TRuntimeInt64Type.Create(TypeHandle, TypeInfoData);
    tkDynamicArray: Result := TRuntimeDynamicArrayType.Create(TypeHandle, TypeInfoData);
  end;

  if Result = nil then
    raise EUnknownType.Create;
end;

class function TRuntimeType.GetRuntimeOrdinalType(TypeHandle: TRuntimeTypeHandle): TType;
begin
  Result := TTypeCache.GetType(TypeHandle);
  if Result <> nil then
    exit;

  Result := CreateRuntimeOrdinalType(TypeHandle, TRuntimeTypeInfoData(@TypeHandle^.Name[Byte(TypeHandle^.Name[0]) + 1]));
  TTypeCache.AddType(TypeHandle, Result);
end;

class function TRuntimeType.GetRuntimeOrdinalTypeHandler(TypeHandle: TRuntimeTypeHandle): ITypeHandler;
begin
  Result := TTypeCache.GetTypeHandler(TypeHandle);

  if Result <> nil then
    exit;

  Result := CreateRuntimeOrdinalType(TypeHandle, TRuntimeTypeInfoData(@TypeHandle^.Name[Byte(TypeHandle^.Name[0]) + 1]));
  TTypeCache.AddTypeHandler(TypeHandle, Result);
end;

class function TRuntimeType.GetRuntimeType(TypeHandle: TRuntimeTypeHandle): TType;
begin
  Result := TTypeCache.GetType(TypeHandle);
  if Result <> nil then
    exit;

  Result := CreateRuntimeType(TypeHandle, TRuntimeTypeInfoData(@TypeHandle^.Name[Byte(TypeHandle^.Name[0]) + 1]));
  TTypeCache.AddType(TypeHandle, Result);
end;

class function TRuntimeType.GetRuntimeTypeDataTypeHandler: ITypeHandler;
begin
  Result := TTypeCache.GetTypeHandler(@TYPE_DATA_TYPEINFO);
  if Result <> nil then
    exit;

  Result := TPointerType.Create;

  TTypeCache.AddTypeHandler(@TYPE_DATA_TYPEINFO, Result);
end;

class function TRuntimeType.GetRuntimeTypeHandler(TypeHandle: TRuntimeTypeHandle): ITypeHandler;
begin
  Result := TTypeCache.GetTypeHandler(TypeHandle);

  if Result <> nil then
    exit;

  Result := CreateRuntimeType(TypeHandle, TRuntimeTypeInfoData(@TypeHandle^.Name[Byte(TypeHandle^.Name[0]) + 1]));
  TTypeCache.AddTypeHandler(TypeHandle, Result);
end;

{ TRuntimeRangeOrdinalType }

function TRuntimeRangeOrdinalType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeRangeOrdinalType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeRangeOrdinalType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeRangeOrdinalType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeRangeOrdinalType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeIntegerType }

function TRuntimeIntegerType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeIntegerType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeIntegerType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeIntegerType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeIntegerType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeCardinalType }

function TRuntimeCardinalType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeCardinalType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeCardinalType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeCardinalType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeCardinalType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeShortIntType }

function TRuntimeShortIntType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeShortIntType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeShortIntType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeShortIntType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeShortIntType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeSmallIntType }

function TRuntimeSmallIntType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeSmallIntType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeSmallIntType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeSmallIntType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeSmallIntType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeLongIntType }

function TRuntimeLongIntType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeLongIntType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeLongIntType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeLongIntType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeLongIntType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeByteType }

function TRuntimeByteType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeByteType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeByteType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeByteType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeByteType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeWordType }

function TRuntimeWordType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeWordType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeWordType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeWordType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeWordType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeLongWordType }

function TRuntimeLongWordType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeLongWordType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeLongWordType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeLongWordType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeLongWordType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeCharType }

function TRuntimeCharType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeCharType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeCharType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeCharType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeCharType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeEnumerationType }

destructor TRuntimeEnumerationType.Destroy;
begin
  FFieldCollector.Free;
  inherited;
end;

function TRuntimeEnumerationType.GetBaseType: TType;
begin
  if (RuntimeTypeInfoData^.BaseType <> nil) and (RuntimeTypeInfoData^.BaseType^ <> RuntimeTypeHandle) then
    Result := TType.GetType(RuntimeTypeInfoData^.BaseType^)
  else
    Result := nil;
end;

function TRuntimeEnumerationType.GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo;
begin
  Result := FieldCollector.GetField(Name, BindingAttr);
end;

function TRuntimeEnumerationType.GetFieldCollector: TFieldCollector;
begin
  if not Assigned(FFieldCollector) then
    FFieldCollector := TEnumerationTypeFieldCollector.Create(Self);
  Result := FFieldCollector;
end;

function TRuntimeEnumerationType.GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection;
begin
  Result := FieldCollector.GetFields(BindingAttr);
end;

function TRuntimeEnumerationType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeEnumerationType.GetMaxValue: Integer;
begin
  if IsBoolean then
    Result := 0
  else
    Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeEnumerationType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeEnumerationType.GetMinValue: Integer;
begin
  if IsBoolean then
    Result := -1
  else
    Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeEnumerationType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

function TRuntimeEnumerationType.IsBoolean: Boolean;
begin
  Result := (RuntimeTypeInfoData^.MaxValue = High(Integer)) and (RuntimeTypeInfoData^.MinValue = Low(Integer))
end;

{ TRuntimeWideCharType }

function TRuntimeWideCharType.GetMaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeWideCharType.GetMaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeWideCharType.GetMinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeWideCharType.GetMinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeWideCharType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeClassType }

function TRuntimeClassType.GetAttributes: TTypeAttributes;
begin
  Result := [taPublic];
end;

function TRuntimeClassType.GetMethod(Name: WideString; BindingAttr: TBindingFlags;
  Binder: TBinder; Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo;
begin
  Result := MethodCollector.GetMethod(Name, BindingAttr, Binder, Types, Modifiers);
end;

function TRuntimeClassType.GetBaseType: TType;
begin
  Result := TType.GetType(RuntimeTypeInfoData^.ParentInfo^);
end;

function TRuntimeClassType.GetMethod(Name: WideString; BindingAttr: TBindingFlags): TMethodInfo;
begin
  // TODO:
  Result := MethodCollector.GetMethod(Name, BindingAttr, nil, nil, []);
end;

function TRuntimeClassType.GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection;
begin
  Result := MethodCollector.GetMethods(BindingAttr);
end;

function TRuntimeClassType.GetNamespace: WideString;
begin
  Result := RuntimeTypeInfoData^.UnitName;
end;

function TRuntimeClassType.GetMethodCollector: TMethodCollector;
begin
  if not Assigned(FMethodCollector) then
    FMethodCollector := TClassTypeMethodCollector.CreateMethodCollector(Self);
  Result := FMethodCollector;
end;

destructor TRuntimeClassType.Destroy;
begin
  FMethodCollector.Free;
  inherited;
end;

{ TRuntimeInterfaceType }

function TRuntimeInterfaceType.GetNamespace: WideString;
begin
  Result := RuntimeTypeInfoData^.InterfaceUnit;
end;

{ TRuntimeInt64Type }

function TRuntimeInt64Type.GetMaxInt64Value: Int64;
begin
  Result := RuntimeTypeInfoData^.MaxInt64Value;
end;

function TRuntimeInt64Type.GetMinInt64Value: Int64;
begin
  Result := RuntimeTypeInfoData^.MinInt64Value;
end;

{ TRuntimeShortStringType }

function TRuntimeShortStringType.GetMaxLength: Byte;
begin
  Result := RuntimeTypeInfoData^.MaxLength;
end;

{ TRuntimeOrdinalType }

function TRuntimeOrdinalType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeSetType }

function TRuntimeSetType.GetOrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

end.

