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
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeRangeOrdinalType = class(TRangeOrdinalType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeIntegerType = class(TIntegerType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeCardinalType = class(TCardinalType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeShortIntType = class(TShortIntType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeSmallIntType = class(TSmallIntType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeLongIntType = class(TLongIntType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeByteType = class(TByteType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeWordType = class(TWordType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeLongWordType = class(TLongWordType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeCharType = class(TCharType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
  end;

  TRuntimeEnumerationType = class(TEnumerationType)
  public
    function IsBoolean: Boolean;
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
    function get_BaseType: TType; override;
  private
    FFieldCollector: TFieldCollector;
    function get_FieldCollector: TFieldCollector;
  protected
    property FieldCollector: TFieldCollector read get_FieldCollector;
  public
    function GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo; override;
    function GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection; override;
  public
    destructor Destroy; override;
  end;

  TRuntimeSetType = class(TSetType)
  protected
    function get_OrdinalKind: TOrdinalKind; override;
  public
    function GetElementType: TType; override;  
  end;

  TRuntimeWideCharType = class(TWideCharType)
  protected
    function get_MinValue: Integer; override;
    function get_MaxValue: Integer; override;
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
    function get_OrdinalKind: TOrdinalKind; override;
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
    function get_MaxLength: Byte; override;
  end;

  TRuntimeWideStringType = class(TWideStringType)
  end;

  TRuntimeClassType = class(TClassType)
  protected // Name and Namespace overrides
    function get_Namespace: WideString; override;
  protected // Attributes
    function get_Attributes: TTypeAttributes; override;
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
    function get_BaseType: TType; override;
  public
    destructor Destroy; override;
  end;

  TRuntimeMethodType = class(TMethodType)
  end;

  TRuntimeInterfaceType = class(TInterfaceType)
  protected // Name and Namespace overrides
    function get_Namespace: WideString; override;
  end;

  TRuntimeInt64Type = class(TInt64Type)
  protected
    function get_MinInt64Value: Int64; override;
    function get_MaxInt64Value: Int64; override;
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
    raise EUnknownType.Create(TypeHandle.Name);
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

function TRuntimeRangeOrdinalType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeRangeOrdinalType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeRangeOrdinalType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeRangeOrdinalType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeRangeOrdinalType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeIntegerType }

function TRuntimeIntegerType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeIntegerType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeIntegerType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeIntegerType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeIntegerType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeCardinalType }

function TRuntimeCardinalType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeCardinalType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeCardinalType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeCardinalType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeCardinalType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeShortIntType }

function TRuntimeShortIntType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeShortIntType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeShortIntType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeShortIntType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeShortIntType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeSmallIntType }

function TRuntimeSmallIntType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeSmallIntType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeSmallIntType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeSmallIntType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeSmallIntType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeLongIntType }

function TRuntimeLongIntType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeLongIntType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeLongIntType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeLongIntType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeLongIntType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeByteType }

function TRuntimeByteType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeByteType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeByteType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeByteType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeByteType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeWordType }

function TRuntimeWordType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeWordType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeWordType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeWordType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeWordType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeLongWordType }

function TRuntimeLongWordType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeLongWordType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeLongWordType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeLongWordType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeLongWordType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeCharType }

function TRuntimeCharType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeCharType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeCharType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeCharType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeCharType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeEnumerationType }

destructor TRuntimeEnumerationType.Destroy;
begin
  FFieldCollector.Free;
  inherited;
end;

function TRuntimeEnumerationType.get_BaseType: TType;
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

function TRuntimeEnumerationType.get_FieldCollector: TFieldCollector;
begin
  if not Assigned(FFieldCollector) then
    FFieldCollector := TEnumerationTypeFieldCollector.Create(Self);
  Result := FFieldCollector;
end;

function TRuntimeEnumerationType.GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection;
begin
  Result := FieldCollector.GetFields(BindingAttr);
end;

function TRuntimeEnumerationType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeEnumerationType.get_MaxValue: Integer;
begin
  if IsBoolean then
    Result := 0
  else
    Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeEnumerationType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeEnumerationType.get_MinValue: Integer;
begin
  if IsBoolean then
    Result := -1
  else
    Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeEnumerationType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

function TRuntimeEnumerationType.IsBoolean: Boolean;
begin
  Result := (RuntimeTypeInfoData^.MaxValue = High(Integer)) and (RuntimeTypeInfoData^.MinValue = Low(Integer))
end;

{ TRuntimeWideCharType }

function TRuntimeWideCharType.get_MaxInt64Value: Int64;
begin
  Result := MaxValue;
end;

function TRuntimeWideCharType.get_MaxValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MaxValue;
end;

function TRuntimeWideCharType.get_MinInt64Value: Int64;
begin
  Result := MinValue;
end;

function TRuntimeWideCharType.get_MinValue: Integer;
begin
  Result := RuntimeTypeInfoData^.MinValue;
end;

function TRuntimeWideCharType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeClassType }

function TRuntimeClassType.get_Attributes: TTypeAttributes;
begin
  Result := [taPublic];
end;

function TRuntimeClassType.GetMethod(Name: WideString; BindingAttr: TBindingFlags;
  Binder: TBinder; Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo;
begin
  Result := MethodCollector.GetMethod(Name, BindingAttr, Binder, Types, Modifiers);
end;

function TRuntimeClassType.get_BaseType: TType;
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

function TRuntimeClassType.get_Namespace: WideString;
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

function TRuntimeInterfaceType.get_Namespace: WideString;
begin
  Result := RuntimeTypeInfoData^.InterfaceUnit;
end;

{ TRuntimeInt64Type }

function TRuntimeInt64Type.get_MaxInt64Value: Int64;
begin
  Result := RuntimeTypeInfoData^.MaxInt64Value;
end;

function TRuntimeInt64Type.get_MinInt64Value: Int64;
begin
  Result := RuntimeTypeInfoData^.MinInt64Value;
end;

{ TRuntimeShortStringType }

function TRuntimeShortStringType.get_MaxLength: Byte;
begin
  Result := RuntimeTypeInfoData^.MaxLength;
end;

{ TRuntimeOrdinalType }

function TRuntimeOrdinalType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

{ TRuntimeSetType }

function TRuntimeSetType.GetElementType: TType;
begin
  result := TType.GetType(RuntimeTypeInfoData^.CompType^);
end;

function TRuntimeSetType.get_OrdinalKind: TOrdinalKind;
begin
  Result := RuntimeTypeInfoData^.OrdinalKind;
end;

end.

