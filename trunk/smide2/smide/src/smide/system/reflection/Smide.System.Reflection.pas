unit Smide.System.Reflection;

interface

uses
  Smide.System.Reflection.Runtime.Handles,
  Smide.System.Types.Runtime.TypeData,
  Smide.System.Common,
  Smide.System.Types.Common,
  Smide.System.Runtime,
  Smide.System.Collections;

type
  TBindingFlag = (
    bfMethodInfo,
    bfNoMethodInfo,
    bfParameterInfo,
    bfNoParameterInfo,
    bfInstance,
    bfDeclaredOnly,
    bfStatic,
    bfPublic,
    bfNonPublic,
    bfFunction,
    bfProcedure,
    bfIgnoreCase,
    bfInvokeMethod,
    bfCreateInstance,
    bfGetField,
    bfSetField,
    bfGetProperty,
    bfSetProperty,
    bfPutDispProperty,
    bfPutRefDispProperty,
    bfExactBinding,
    bfSuppressChangeType,
    bfOptionalParamBinding,
    bfIgnoreReturn,
    bfVirtual,
    bfDynamic
    );
  TBindingFlags = set of TBindingFlag;

const
  bfDefault = [];

type
  TTypeAttribute = (
    taNotPublic,
    taPublic,
    taClass,
    taInterface,
    taAbstract,
    taSealed,
    taSpecialName,
    taImport,
    taSerializable
    );

  TTypeAttributes = set of TTypeAttribute;

  TType = class;

  TBinder = class
  end;

  TMemberType = (
    mtConstructor,
    mtEvent,
    mtField,
    mtMethod,
    mtProperty,
    mtTypeInfo,
    mtCustom);
  TMemberTypes = set of TMemberType;

  TMemberInfo = class(TSmideObject)
  protected
    function get_MemberType: TMemberType; virtual; abstract;
    function get_Name: WideString; virtual; abstract;
    function get_DeclaringType: TType; virtual; abstract;
    function get_ReflectedType: TType; virtual; abstract;
  public
    property MemberType: TMemberType read get_MemberType;
    property Name: WideString read get_Name;
    property DeclaringType: TType read get_DeclaringType;
    property ReflectedType: TType read get_ReflectedType;
  protected
    constructor Create;
  end;

  TParameterInfo = class(TSmideObject)
  end;

  TParameterInfoCollection = class
  end;

  TMethodAttribute = (
    maMethodInfo,
    maParameterInfo,
    maPrivate,
    maProtected,
    maPublic,
    maPublished,
    maVirtual,
    maDynamic,
    maStatic,
    maAbstract,
    maOverloaded,
    maOverridden,
    maFunction,
    maProcedure,
    maFinal,
    maHideBySig,
    maSpecialName);
  TMethodAttributes = set of TMethodAttribute;

  TCallingConvention = (
    ccRegister,
    ccCdecl,
    ccPascal,
    ccStdCall,
    ccSafeCall,
    ccUnknown);
  TCallingConventions = set of TCallingConvention;

  TMethodBase = class(TMemberInfo)
  protected
    function get_MethodHandle: TRuntimeMethodHandle; virtual; abstract;
  public
    // TODO: GetParameters;
    // TODO: GetMethodImplementationFlags
    property MethodHandle: TRuntimeMethodHandle read get_MethodHandle;
    // TODO: GetMethodFromHandle
  protected // Attributes
    function get_Attributes: TMethodAttributes; virtual; abstract;
    function get_CallingConventions: TCallingConventions; virtual; abstract;
    function get_IsAbstract: Boolean;
    function get_IsConstructor: Boolean; virtual;
    function get_IsDynamic: Boolean;
    function get_IsFinal: Boolean;
    function get_IsHideBySig: Boolean;
    function get_IsPrivate: Boolean;
    function get_IsPublic: Boolean;
    function get_IsSpecialName: Boolean;
    function get_IsStatic: Boolean;
    function get_IsVirtual: Boolean;
  public
    property Attributes: TMethodAttributes read get_Attributes;
    property IsPublic: Boolean read get_IsPublic;
    property IsPrivate: Boolean read get_IsPrivate;
    property IsStatic: Boolean read get_IsStatic;
    property IsFinal: Boolean read get_IsFinal;
    property IsVirtual: Boolean read get_IsVirtual;
    property IsDynamic: Boolean read get_IsDynamic;
    property IsHideBySig: Boolean read get_IsHideBySig;
    property IsAbstract: Boolean read get_IsAbstract;
    property IsSpecialName: Boolean read get_IsSpecialName;
    property IsConstructor: Boolean read get_IsConstructor;
    property CallingConventions: TCallingConventions read get_CallingConventions;
  protected
    procedure InvokeImpl(const Obj; InvokeAttr: TBindingFlags; Binder: TBinder;
      Parameters: array of const; {culture: CultureInfo;} out Result); virtual; abstract;
  public
    // TODO: class function GetCurrentMethod: MethodBase;
    procedure Invoke(const Obj; Parameters: array of const; out Result); overload;
    procedure Invoke(const Obj; InvokeAttr: TBindingFlags; Binder: TBinder;
      Parameters: array of const; {culture: CultureInfo;} out Result); overload;
  end;

  TMethodInfo = class(TMethodBase)
  protected // TMemberInfo overrides
    function get_MemberType: TMemberType; override;
  protected // Attributes
    function get_IsFunction: Boolean; virtual; abstract;
    function get_IsProcedure: Boolean; virtual; abstract;
    function get_ReturnType: TType; virtual; abstract;
    function get_BaseDefinition: TMethodInfo; virtual; abstract;
    function get_ParentDefinition: TMethodInfo; virtual; abstract;
  public
    property IsProcedure: Boolean read get_IsProcedure;
    property IsFunction: Boolean read get_IsFunction;
    property ReturnType: TType read get_ReturnType;

    property BaseDefinition: TMethodInfo read get_BaseDefinition;
    property ParentDefinition: TMethodInfo read get_ParentDefinition;
  end;

  IMethodInfoEnumerator = interface(IEnumerator)
    ['{D31FC038-356C-4132-9CE4-B9E0BB71243B}']
    function get_Current: TMethodInfo;
    property Current: TMethodInfo read get_Current;
  end;

  TMethodInfoEnumerator = class(TEnumeratorBase, IMethodInfoEnumerator)
  protected
    function get_Current: TMethodInfo;
  public
    property Current: TMethodInfo read get_Current;
  end;

  IMethodInfoCollection = interface(ICollection)
    ['{3EF03E41-A18C-4CA1-92D0-1288D8CBFF80}']
    function Add(const Value: TMethodInfo): Integer;
    procedure Insert(Index: Integer; const Value: TMethodInfo);
    procedure Remove(const Value: TMethodInfo);
    function Contains(const Value: TMethodInfo): Boolean;
    function IndexOf(const Value: TMethodInfo): Integer;
    function GetEnumerator: IMethodInfoEnumerator;

    function get_Items(Index: Integer): TMethodInfo;
    procedure set_Items(Index: Integer; const Value: TMethodInfo);
    property Items[Index: Integer]: TMethodInfo read get_Items write set_Items; default;
  end;

  TMethodInfoCollection = class(TCollectionBase, IMethodInfoCollection)
  private
    function get_Items(Index: Integer): TMethodInfo;
    procedure set_Items(Index: Integer; const Value: TMethodInfo);
  protected
    function get_TypeHandler: ITypeHandler; override;
  public
    function Add(const Value: TMethodInfo): Integer;
    procedure Insert(Index: Integer; const Value: TMethodInfo);
    procedure Remove(const Value: TMethodInfo);
    function Contains(const Value: TMethodInfo): Boolean;
    function IndexOf(const Value: TMethodInfo): Integer;
    procedure GetEnumerator(out Enumerator: IEnumerator); override;
    function GetEnumerator: IMethodInfoEnumerator; overload; virtual;

    property Items[Index: Integer]: TMethodInfo read get_Items write set_Items; default;
  end;

  TFieldAttribute = (
    ftPrivate,
    ftPublic,
    ftStatic,

    ftInitOnly,
    ftLiteral,
    ftNotSerialized,
    ftSpecialName,
    ftRTSpecialName,
    ftHasDefault
    );
  TFieldAttributes = set of TFieldAttribute;

  TFieldInfo = class(TMemberInfo)
  private
  protected // TMemberInfo overrides
    function get_MemberType: TMemberType; override;
  protected
    function get_FieldType: TType; virtual; abstract;
    function get_FieldHandle: TRuntimeFieldHandle; virtual; abstract;
  public
    procedure GetValue(const Obj; out Result); virtual; abstract;
    // TODO: GetFieldFromHandle
    property FieldHandle: TRuntimeFieldHandle read get_FieldHandle;
    property FieldType: TType read get_FieldType;
  protected // Attributes
    function get_Attributes: TFieldAttributes; virtual; abstract;
    function get_IsInitOnly: Boolean;
    function get_IsLiteral: Boolean;
    function get_IsPrivate: Boolean;
    function get_IsPublic: Boolean;
    function get_IsStatic: Boolean;
    function get_IsNotSerialized: Boolean;
    function get_IsSpecialName: Boolean;
  public
    property Attributes: TFieldAttributes read get_Attributes;
    property IsPublic: Boolean read get_IsPublic;
    property IsPrivate: Boolean read get_IsPrivate;
    property IsStatic: Boolean read get_IsStatic;
    property IsInitOnly: Boolean read get_IsInitOnly;
    property IsLiteral: Boolean read get_IsLiteral;
    property IsNotSerialized: Boolean read get_IsNotSerialized;
    property IsSpecialName: Boolean read get_IsSpecialName;
  end;

  IFieldInfoEnumerator = interface(IEnumerator)
    ['{D31FC038-356C-4132-9CE4-B9E0BB71243B}']
    function get_Current: TFieldInfo;
    property Current: TFieldInfo read get_Current;
  end;

  TFieldInfoEnumerator = class(TEnumeratorBase, IFieldInfoEnumerator)
  protected
    function get_Current: TFieldInfo;
  public
    property Current: TFieldInfo read get_Current;
  end;

  IFieldInfoCollection = interface(ICollection)
    ['{3EF03E41-A18C-4CA1-92D0-1288D8CBFF80}']
    function Add(const Value: TFieldInfo): Integer;
    procedure Insert(Index: Integer; const Value: TFieldInfo);
    procedure Remove(const Value: TFieldInfo);
    function Contains(const Value: TFieldInfo): Boolean;
    function IndexOf(const Value: TFieldInfo): Integer;
    function GetEnumerator: IFieldInfoEnumerator;

    function get_Items(Index: Integer): TFieldInfo;
    procedure set_Items(Index: Integer; const Value: TFieldInfo);
    property Items[Index: Integer]: TFieldInfo read get_Items write set_Items; default;
  end;

  TFieldInfoCollection = class(TCollectionBase, IFieldInfoCollection)
  private
    function get_Items(Index: Integer): TFieldInfo;
    procedure set_Items(Index: Integer; const Value: TFieldInfo);
  protected
    function get_TypeHandler: ITypeHandler; override;
  public
    function Add(const Value: TFieldInfo): Integer;
    procedure Insert(Index: Integer; const Value: TFieldInfo);
    procedure Remove(const Value: TFieldInfo);
    function Contains(const Value: TFieldInfo): Boolean;
    function IndexOf(const Value: TFieldInfo): Integer;
    procedure GetEnumerator(out Enumerator: IEnumerator); override;
    function GetEnumerator: IFieldInfoEnumerator; overload; virtual;

    property Items[Index: Integer]: TFieldInfo read get_Items write set_Items; default;
  end;

  TPropertyInfo = class
  end;

  TParameterModifier = class
  end;

  IPropertyInfoCollection = interface
  end;

  TPropertyInfoCollection = class
  end;

  IMemberInfoCollection = interface
  end;

  TMemberInfoCollection = class
  end;

  ITypeCollection = interface
    ['{F1BCEBC9-0D06-4ABF-8CDC-10B85CCB0885}']
  end;

  IReflect = interface
    ['{E6942053-1DEC-47F3-BBBF-F37106467171}']
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
      Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo; overload;
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags): TMethodInfo; overload;
    function GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection;

    function GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo;
    function GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection;

    function GetProperty(Name: WideString; BindingAttr: TBindingFlags): TPropertyInfo; overload;
    function GetProperty(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
      ReturnType: TType; Types: ITypeCollection; Modifiers: array of TParameterModifier): TPropertyInfo; overload;
    function GetProperties(BindingAttr: TBindingFlags): IPropertyInfoCollection;

    function GetMember(Name: WideString; BindingAttr: TBindingFlags): IMemberInfoCollection;
    function GetMembers(BindingAttr: TBindingFlags): IMemberInfoCollection;

    procedure InvokeMember(Name: WideString; InvokeAttr: TBindingFlags; Binder: TBinder;
      const Target; Args: array of const; Modifiers: array of TParameterModifier;
      {CultureInfo culture,}NamedParameters: array of WideString; out Result);

    function get_UnderlyingSystemType: TType;
    property UnderlyingSystemType: TType read get_UnderlyingSystemType;
  end;

  TType = class(TMemberInfo, IReflect, ITypeHandler)
  public // ITypeHandler
    procedure ValueToData(const Value; out Data: TTypeData); virtual;
    procedure DataToValue(const Data: TTypeData; var Value); virtual;
    procedure ClearValue(var Value); virtual;
    procedure FreeData(var Data: TTypeData); virtual;
    function CompareValues(const Value1; const Value2): Integer; virtual;
    function EqualsValues(const Value1; const Value2): Boolean; virtual;
    function SameValues(const Value1; const Value2): Boolean; virtual;
    function ValueToString(const Value): WideString;
    function FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider = nil): WideString; virtual;
  private
    FRuntimeTypeHandle: TRuntimeTypeHandle;
    FRuntimeTypeInfoData: TRuntimeTypeInfoData;
  protected
    function get_TypeSize: Integer; virtual;
    function get_RuntimeTypeHandle: TRuntimeTypeHandle;
    function get_RuntimeTypeInfoData: TRuntimeTypeInfoData;
  public
    property TypeSize: Integer read get_TypeSize;
    property RuntimeTypeHandle: TRuntimeTypeHandle read get_RuntimeTypeHandle;
    property RuntimeTypeInfoData: TRuntimeTypeInfoData read get_RuntimeTypeInfoData;
  public // IReflect
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
      Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo; overload; virtual;
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags): TMethodInfo; overload; virtual;
    function GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection; virtual;

    function GetField(Name: WideString): TFieldInfo; overload;
    function GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo; overload; virtual;

    function GetFields: IFieldInfoCollection; overload;
    function GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection; overload; virtual;

    function GetProperty(Name: WideString; BindingAttr: TBindingFlags): TPropertyInfo; overload; virtual;
    function GetProperty(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
      ReturnType: TType; Types: ITypeCollection; Modifiers: array of TParameterModifier): TPropertyInfo; overload; virtual;
    function GetProperties(BindingAttr: TBindingFlags): IPropertyInfoCollection; virtual;

    function GetMember(Name: WideString; BindingAttr: TBindingFlags): IMemberInfoCollection; virtual;
    function GetMembers(BindingAttr: TBindingFlags): IMemberInfoCollection; virtual;

    procedure InvokeMember(Name: WideString; InvokeAttr: TBindingFlags; Binder: TBinder;
      const Target; Args: array of const; Modifiers: array of TParameterModifier;
      {CultureInfo culture,}NamedParameters: array of WideString; out Result); virtual;

    function get_UnderlyingSystemType: TType; virtual;
    property UnderlyingSystemType: TType read get_UnderlyingSystemType;
  public
    class function GetType(Name: WideString; ThrowOnError: Boolean = false; IgnoreCase: Boolean = true): TType; overload; virtual;
    class function GetType(TypeHandle: TRuntimeTypeHandle): TType; overload;
    class function GetType(Instance: TObject): TType; overload;
    class function GetType(AClass: TClass): TType; overload;

    class function GetTypeHandler(TypeInfo: TRuntimeTypeHandle): ITypeHandler; overload;
    class function GetTypeHandler(Instance: TObject): ITypeHandler; overload;
    class function GetTypeHandler(AClass: TClass): ITypeHandler; overload;

    class function HasTypeInfo(Instance: TObject): Boolean; overload;
    class function HasTypeInfo(AClass: TClass): Boolean; overload;

    class function GetTypeDataTypeHandler: ITypeHandler;
  protected
    constructor Create(TypeHandle: TRuntimeTypeHandle; TypeInfoData: TRuntimeTypeInfoData); virtual;

  protected // IntegerType support
    function get_MinInt64Value: Int64; virtual;
    function get_MaxInt64Value: Int64; virtual;
    function get_MinValue: Integer; virtual;
    function get_MaxValue: Integer; virtual;
  public
    property MinValue: Integer read get_MinValue;
    property MaxValue: Integer read get_MaxValue;
    property MinInt64Value: Int64 read get_MinInt64Value;
    property MaxInt64Value: Int64 read get_MaxInt64Value;
  protected // ShortString Support
    function get_MaxLength: Byte; virtual;
  public
    property MaxLength: Byte read get_MaxLength;
  protected // TMemberInfo overrides
    function get_MemberType: TMemberType; override;
    function get_Name: WideString; override;
    function get_DeclaringType: TType; override;
    function get_ReflectedType: TType; override;
  protected // Name and Namespace
    function get_FullName: WideString; virtual;
    function get_Namespace: WideString; virtual;
    function get_AssemblyQualifiedName: WideString; virtual;
  public
    property Namespace: WideString read get_Namespace;
    property FullName: WideString read get_FullName;
    property AssemblyQualifiedName: WideString read get_AssemblyQualifiedName;
  protected
    function get_BaseType: TType; virtual; abstract;
  public
    property BaseType: TType read get_BaseType;

  protected // Attributes
    function get_Attributes: TTypeAttributes; virtual;
    function get_HasElementType: Boolean; virtual;
    function get_IsAbstract: Boolean; virtual;
    function get_IsArray: Boolean; virtual;
    function get_IsSet: Boolean; virtual;
    function get_IsByRef: Boolean; virtual;
    function get_IsClass: Boolean; virtual;
    function get_IsEnum: Boolean; virtual;
    function get_IsInterface: Boolean; virtual;
    function get_IsOrdinal: Boolean; virtual;
    function get_IsPointer: Boolean; virtual;
    function get_IsPrimitive: Boolean; virtual;
    function get_IsPublic: Boolean; virtual;
    function get_IsSealed: Boolean; virtual;
    function get_IsSerializable: Boolean; virtual;
    function get_IsSpecialName: Boolean; virtual;
    function get_IsValueType: Boolean; virtual;
  public
    property Attributes: TTypeAttributes read get_Attributes;
    property IsPublic: Boolean read get_IsPublic;
    property IsClass: Boolean read get_IsClass;
    property IsInterface: Boolean read get_IsInterface;
    property IsValueType: Boolean read get_IsValueType;
    property IsAbstract: Boolean read get_IsAbstract;
    property IsSealed: Boolean read get_IsSealed;
    property IsEnum: Boolean read get_IsEnum;
    property IsSpecialName: Boolean read get_IsSpecialName;
    property IsSerializable: Boolean read get_IsSerializable;
    property IsArray: Boolean read get_IsArray;
    property IsByRef: Boolean read get_IsByRef;
    property IsPointer: Boolean read get_IsPointer;
    property IsPrimitive: Boolean read get_IsPrimitive;
    property IsOrdinal: Boolean read get_IsOrdinal;
    property HasElementType: Boolean read get_HasElementType;
    property IsSet: Boolean read get_IsSet;
  public
    function GetElementType: TType; virtual;
  public
    function IsSubclassOf(c: TType): Boolean; virtual;
    // TODO: isInstanceOf
    // TODO: IsAssignableFrom
  public
    function ToString: WideString; override;
  end;

const
  NAMESPACE_SEPARATOR = '.';

implementation

uses
  Smide.System.Types,
  Smide.System.Types.Runtime;

{ TMemberInfo }

constructor TMemberInfo.Create;
begin
  inherited;
end;

{ TMethodBase }

function TMethodBase.get_IsAbstract: Boolean;
begin
  Result := maAbstract in Attributes;
end;

function TMethodBase.get_IsConstructor: Boolean;
begin
  raise ENotImplemented.Create('TMethodBase.get_IsConstructor');
end;

function TMethodBase.get_IsDynamic: Boolean;
begin
  Result := maDynamic in Attributes;
end;

function TMethodBase.get_IsFinal: Boolean;
begin
  Result := maFinal in Attributes;
end;

function TMethodBase.get_IsHideBySig: Boolean;
begin
  Result := maHideBySig in Attributes;
end;

function TMethodBase.get_IsPrivate: Boolean;
begin
  Result := maPrivate in Attributes;
end;

function TMethodBase.get_IsPublic: Boolean;
begin
  Result := maPublic in Attributes;
end;

function TMethodBase.get_IsSpecialName: Boolean;
begin
  Result := maSpecialName in Attributes;
end;

function TMethodBase.get_IsStatic: Boolean;
begin
  Result := maStatic in Attributes;
end;

function TMethodBase.get_IsVirtual: Boolean;
begin
  Result := maVirtual in Attributes;
end;

procedure TMethodBase.Invoke(const Obj; Parameters: array of const; out Result);
begin
  Invoke(Obj, bfDefault, nil, Parameters, Result);
end;

procedure TMethodBase.Invoke(const Obj; InvokeAttr: TBindingFlags;
  Binder: TBinder; Parameters: array of const; out Result);
begin
  InvokeImpl(Obj, InvokeAttr, Binder, Parameters, Result);
end;

{ TMethodInfo }

function TMethodInfo.get_MemberType: TMemberType;
begin
  Result := mtMethod;
end;

{ TMethodInfoEnumerator }

function TMethodInfoEnumerator.get_Current: TMethodInfo;
begin
  GetCurrentItem(Result);
end;

{ TMethodInfoCollection }

function TMethodInfoCollection.Add(const Value: TMethodInfo): Integer;
begin
  Result := ItemAdd(Value);
end;

function TMethodInfoCollection.Contains(const Value: TMethodInfo): Boolean;
begin
  Result := ItemContains(Value);
end;

function TMethodInfoCollection.GetEnumerator: IMethodInfoEnumerator;
begin
  Result := TMethodInfoEnumerator.Create(InnerList);
end;

procedure TMethodInfoCollection.GetEnumerator(out Enumerator: IEnumerator);
begin
  Enumerator := GetEnumerator;
end;

function TMethodInfoCollection.get_Items(Index: Integer): TMethodInfo;
begin
  ItemGet(Index, Result);
end;

function TMethodInfoCollection.get_TypeHandler: ITypeHandler;
begin
  Result := TType.GetTypeHandler(TypeInfo(TMethodInfo));
end;

function TMethodInfoCollection.IndexOf(const Value: TMethodInfo): Integer;
begin
  Result := ItemIndexOf(Value);
end;

procedure TMethodInfoCollection.Insert(Index: Integer; const Value: TMethodInfo);
begin
  ItemInsert(Index, Value);
end;

procedure TMethodInfoCollection.Remove(const Value: TMethodInfo);
begin
  ItemRemove(Value);
end;

procedure TMethodInfoCollection.set_Items(Index: Integer; const Value: TMethodInfo);
begin
  ItemSet(Index, Value);
end;

{ TFieldInfo }

function TFieldInfo.get_IsInitOnly: Boolean;
begin
  Result := ftInitOnly in Attributes;
end;

function TFieldInfo.get_IsLiteral: Boolean;
begin
  Result := ftLiteral in Attributes;
end;

function TFieldInfo.get_IsNotSerialized: Boolean;
begin
  Result := ftNotSerialized in Attributes;
end;

function TFieldInfo.get_IsPrivate: Boolean;
begin
  Result := ftPrivate in Attributes;
end;

function TFieldInfo.get_IsPublic: Boolean;
begin
  Result := ftPublic in Attributes;
end;

function TFieldInfo.get_IsSpecialName: Boolean;
begin
  Result := ftSpecialName in Attributes;
end;

function TFieldInfo.get_IsStatic: Boolean;
begin
  Result := ftStatic in Attributes;
end;

function TFieldInfo.get_MemberType: TMemberType;
begin
  Result := mtField;
end;

{ TFieldInfoEnumerator }

function TFieldInfoEnumerator.get_Current: TFieldInfo;
begin
  GetCurrentItem(Result);
end;

{ TFieldInfoCollection }

function TFieldInfoCollection.Add(const Value: TFieldInfo): Integer;
begin
  Result := ItemAdd(Value);
end;

function TFieldInfoCollection.Contains(const Value: TFieldInfo): Boolean;
begin
  Result := ItemContains(Value);
end;

function TFieldInfoCollection.GetEnumerator: IFieldInfoEnumerator;
begin
  Result := TFieldInfoEnumerator.Create(InnerList);
end;

procedure TFieldInfoCollection.GetEnumerator(out Enumerator: IEnumerator);
begin
  Enumerator := GetEnumerator;
end;

function TFieldInfoCollection.get_Items(Index: Integer): TFieldInfo;
begin
  ItemGet(Index, Result);
end;

function TFieldInfoCollection.get_TypeHandler: ITypeHandler;
begin
  Result := TType.GetTypeHandler(TFieldInfoCollection);
end;

function TFieldInfoCollection.IndexOf(const Value: TFieldInfo): Integer;
begin
  Result := ItemIndexOf(Value);
end;

procedure TFieldInfoCollection.Insert(Index: Integer; const Value: TFieldInfo);
begin
  ItemInsert(Index, Value);
end;

procedure TFieldInfoCollection.Remove(const Value: TFieldInfo);
begin
  ItemRemove(Value);
end;

procedure TFieldInfoCollection.set_Items(Index: Integer; const Value: TFieldInfo);
begin
  ItemSet(Index, Value);
end;

{ TType }

const
  bfDefaultLookup = [bfInstance, bfStatic, bfPublic];

procedure TType.ClearValue(var Value);
begin
  raise ENotSupported.Create('ITypeHandler.ClearValue');
end;

function TType.CompareValues(const Value1, Value2): Integer;
begin
  raise ENotSupported.Create('ITypeHandler.CompareValues');
end;

constructor TType.Create(TypeHandle: TRuntimeTypeHandle; TypeInfoData: TRuntimeTypeInfoData);
begin
  inherited Create;
  if TypeHandle = nil then
    raise EArgumentNil.Create('TypeHandle');

  FRuntimeTypeHandle := TypeHandle;
  FRuntimeTypeInfoData := TypeInfoData;
end;

function TType.EqualsValues(const Value1, Value2): Boolean;
begin
  raise ENotSupported.Create('ITypeHandler.EqualsValue');
end;

function TType.FormatValueToString(Format: WideString; const Value; FormatProvider: IFormatProvider): WideString;
begin
  raise ENotSupported.Create('ITypeHandler.FormatValueToString');
end;

procedure TType.FreeData(var Data: TTypeData);
begin
  raise ENotSupported.Create('ITypeHandler.FreePointer');
end;

function TType.GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo;
begin
  raise ENotSupported.Create('IReflect.GetField');
end;

function TType.GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection;
begin
  raise ENotSupported.Create('IReflect.GetFields');
end;

function TType.get_MaxLength: Byte;
begin
  raise ENotSupported.Create('TType.get_MaxLength');
end;

function TType.get_MaxValue: Integer;
begin
  raise ENotSupported.Create('TType.get_MaxValue');
end;

function TType.GetMember(Name: WideString; BindingAttr: TBindingFlags): IMemberInfoCollection;
begin
  raise ENotSupported.Create('IReflect.GetMember');
end;

function TType.GetMembers(BindingAttr: TBindingFlags): IMemberInfoCollection;
begin
  raise ENotSupported.Create('IReflect.GetMembers');
end;

function TType.GetMethod(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
  Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo;
begin
  raise ENotSupported.Create('IReflect.GetMethod');
end;

function TType.GetMethod(Name: WideString; BindingAttr: TBindingFlags): TMethodInfo;
begin
  raise ENotSupported.Create('IReflect.GetMethod');
end;

function TType.GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection;
begin
  raise ENotSupported.Create('IReflect.GetMethods');
end;

function TType.get_MinValue: Integer;
begin
  raise ENotSupported.Create('TType.get_MinValue');
end;

function TType.GetProperties(BindingAttr: TBindingFlags): IPropertyInfoCollection;
begin
  raise ENotSupported.Create('IReflect.GetProperties');
end;

function TType.GetProperty(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
  ReturnType: TType; Types: ITypeCollection; Modifiers: array of TParameterModifier): TPropertyInfo;
begin
  raise ENotSupported.Create('IReflect.GetProperty');
end;

function TType.GetProperty(Name: WideString; BindingAttr: TBindingFlags): TPropertyInfo;
begin
  raise ENotSupported.Create('IReflect.GetProperty');
end;

class function TType.GetType(Instance: TObject): TType;
begin
  if Instance = nil then
    raise EArgumentNil.Create('Instance');
  Result := GetType(Instance.ClassInfo);
end;

class function TType.GetType(TypeHandle: TRuntimeTypeHandle): TType;
begin
  Result := TRuntimeType.GetRuntimeType(TypeHandle);
end;

class function TType.GetType(Name: WideString; ThrowOnError, IgnoreCase: Boolean): TType;
begin
  raise ENotImplemented.Create('TType.GetType');
end;

class function TType.GetType(AClass: TClass): TType;
begin
  if AClass = nil then
    raise EArgumentNil.Create('AClass');
  Result := GetType(AClass.ClassInfo);
end;

class function TType.GetTypeHandler(AClass: TClass): ITypeHandler;
begin
  if AClass = nil then
    raise EArgumentNil.Create('AClass');
  Result := GetTypeHandler(AClass.ClassInfo);
end;

class function TType.GetTypeHandler(Instance: TObject): ITypeHandler;
begin
  if Instance = nil then
    raise EArgumentNil.Create('Instance');
  Result := GetTypeHandler(Instance.ClassInfo);
end;

class function TType.GetTypeHandler(TypeInfo: TRuntimeTypeHandle): ITypeHandler;
begin
  Result := TRuntimeType.GetRuntimeTypeHandler(TypeInfo);
end;

function TType.get_TypeSize: Integer;
begin
  raise ENotSupported.Create('ITypeHandler.get_TypeSize');
end;

function TType.get_UnderlyingSystemType: TType;
begin
  raise ENotSupported.Create('IReflect.GetUnderlyingSystemType');
end;

class function TType.HasTypeInfo(Instance: TObject): Boolean;
begin
  Result := Instance.ClassInfo <> nil;
end;

class function TType.HasTypeInfo(AClass: TClass): Boolean;
begin
  Result := AClass.ClassInfo <> nil;
end;

procedure TType.InvokeMember(Name: WideString; InvokeAttr: TBindingFlags; Binder: TBinder;
  const Target; Args: array of const; Modifiers: array of TParameterModifier;
  NamedParameters: array of WideString; out Result);
begin
  raise ENotSupported.Create('IReflect.InvokeMember');
end;

procedure TType.DataToValue(const Data: TTypeData; var Value);
begin
  raise ENotSupported.Create('ITypeHandler.PointerToValue');
end;

function TType.SameValues(const Value1, Value2): Boolean;
begin
  raise ENotSupported.Create('ITypeHandler.SameValue');
end;

procedure TType.ValueToData(const Value; out Data: TTypeData);
begin
  raise ENotSupported.Create('ITypeHandler.ValueToPointer');
end;

function TType.ValueToString(const Value): WideString;
begin
  Result := FormatValueToString('', Value, nil);
end;

function TType.get_MaxInt64Value: Int64;
begin
  raise ENotSupported.Create('TType.get_MaxInt64Value');
end;

function TType.get_MinInt64Value: Int64;
begin
  raise ENotSupported.Create('TType.get_MinInt64Value');
end;

function TType.get_FullName: WideString;
begin
  if Namespace = '' then
    Result := Name
  else
    Result := Namespace + NAMESPACE_SEPARATOR + Name;
end;

function TType.get_Name: WideString;
begin
  Result := RuntimeTypeHandle.Name;
end;

function TType.get_Namespace: WideString;
begin
  Result := '';
end;

function TType.get_AssemblyQualifiedName: WideString;
begin
  raise ENotImplemented.Create('TType.get_AssemblyQualifiedName');
end;

function TType.get_Attributes: TTypeAttributes;
begin
  raise ENotSupported.Create('TType.get_Attributes');
end;

function TType.GetElementType: TType;
begin
  raise ENotImplemented.Create('TType.GetElementType');
end;

function TType.get_HasElementType: Boolean;
begin
  raise ENotImplemented.Create('TType.get_HasElementType');
end;

function TType.get_IsAbstract: Boolean;
begin
  Result := taAbstract in Attributes;
end;

function TType.get_IsArray: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsArray');
end;

function TType.get_IsSet: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsSet');
end;

function TType.get_IsByRef: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsByRef');
end;

function TType.get_IsClass: Boolean;
begin
  Result := (taClass in Attributes) and not IsValueType;
end;

function TType.get_IsEnum: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsEnum');
end;

function TType.get_IsInterface: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsInterface');
end;

function TType.get_IsOrdinal: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsOrdinal');
end;

function TType.get_IsPointer: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsPointer');
end;

function TType.get_IsPrimitive: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsPrimitive');
end;

function TType.get_IsPublic: Boolean;
begin
  Result := taPublic in Attributes;
end;

function TType.get_IsSealed: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsSealed');
end;

function TType.get_IsSerializable: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsSerializable');
end;

function TType.get_IsSpecialName: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsSpecialName');
end;

function TType.get_IsValueType: Boolean;
begin
  raise ENotImplemented.Create('TType.get_IsValueType');
end;

function TType.get_DeclaringType: TType;
begin
  Result := Self;
end;

function TType.get_MemberType: TMemberType;
begin
  Result := mtTypeInfo;
end;

function TType.get_ReflectedType: TType;
begin
  Result := Self;
end;

function TType.IsSubclassOf(c: TType): Boolean;
var
  P: TType;
begin
  Result := false;
  P := Self;
  if P = c then
    exit;

  while P <> nil do
  begin
    if P = c then
    begin
      Result := true;
      Break;
    end;
    P := P.BaseType;
  end;
end;

function TType.ToString: WideString;
begin
  Result := 'Type: ' + Name;
end;

function TType.get_RuntimeTypeHandle: TRuntimeTypeHandle;
begin
  Result := FRuntimeTypeHandle;
end;

function TType.GetFields: IFieldInfoCollection;
begin
  Result := GetFields(bfDefaultLookup);
end;

function TType.GetField(Name: WideString): TFieldInfo;
begin
  Result := GetField(Name, bfDefaultLookup);
end;

function TType.get_RuntimeTypeInfoData: TRuntimeTypeInfoData;
begin
  Result := FRuntimeTypeInfoData;
end;

class function TType.GetTypeDataTypeHandler: ITypeHandler;
begin
  Result := TRuntimeType.GetRuntimeTypeDataTypeHandler;
end;

end.

