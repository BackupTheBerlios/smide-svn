unit Smide.System.Reflection.Runtime;

interface

uses
  Smide.System,
  Smide.System.Reflection;

type
  TRuntimeMethodInfo = class(TMethodInfo)
  private
    FMethodHandle: TRuntimeMethodHandle;
    FName: WideString;
    FDeclaringType: TType;
    FReflectedType: TType;
    FAddress: Pointer;
    FReturnType: TType;
    FAttributes: TMethodAttributes;
  protected // TMemberInfo overrides
    function get_Name: WideString; override;
    function get_DeclaringType: TType; override;
    function get_ReflectedType: TType; override;
  protected // TMethodInfo overrides
    function get_IsFunction: Boolean; override;
    function get_IsProcedure: Boolean; override;
    function get_ReturnType: TType; override;
    function get_Attributes: TMethodAttributes; override;
    function get_CallingConventions: TCallingConventions; override;
    function get_MethodHandle: TRuntimeMethodHandle; override;
  protected
    procedure InvokeImpl(const Obj; InvokeAttr: TBindingFlags; Binder: TBinder;
      Parameters: array of const; {culture: CultureInfo;} out Result); override;

  public
    constructor Create(MethodHandle: TRuntimeMethodHandle; Name: WideString; ReflectedType, DeclaringType: TType;
      Attributes: TMethodAttributes; Address: Pointer; Parameters: TParameterInfoCollection; ReturnType: TType;
      CallingConvention: TCallingConvention; VirtualIndex, DynamicIndex: Integer; ParentDefinition: TMethodInfo);

    function get_BaseDefinition: TMethodInfo; override;
    function get_ParentDefinition: TMethodInfo; override;
  end;

  TRuntimeFieldInfo = class(TFieldInfo)
  private
    FFieldHandle: TRuntimeFieldHandle;
    FName: WideString;
    FReflectedType, FDeclaringType: TType;
    FAttributes: TFieldAttributes;
    FFieldType: TType;
  protected // TMemberInfo overrides
    function get_Name: WideString; override;
    function get_DeclaringType: TType; override;
    function get_ReflectedType: TType; override;
  protected // TFieldInfo overrides
    function get_FieldType: TType; override;
    function get_FieldHandle: TRuntimeFieldHandle; override;
    function get_Attributes: TFieldAttributes; override;
  public
    constructor Create(FieldHandle: TRuntimeFieldHandle; Name: WideString;
      ReflectedType, DeclaringType: TType; Attributes: TFieldAttributes; FieldType: TType);

    function ToString: widestring; override;
  end;

  TRuntimeInheritedFieldInfo = class(TFieldInfo)
  private
    FFieldInfo: TFieldInfo;
    FReflectedType: TType;
  protected // TMemberInfo overrides
    function get_Name: WideString; override;
    function get_DeclaringType: TType; override;
    function get_ReflectedType: TType; override;
  protected // TFieldInfo overrides
    function get_FieldType: TType; override;
    function get_FieldHandle: TRuntimeFieldHandle; override;
    function get_Attributes: TFieldAttributes; override;
  public
    procedure GetValue(const Obj; out Result); override;
  public
    constructor Create(FieldInfo: TFieldInfo; ReflectedType: TType);

    function ToString: widestring; override;
  end;

  TRuntimeEnumerationFieldInfo = class(TRuntimeFieldInfo)
  private
    FValue: Integer;
  public
    procedure GetValue(const Obj; out Result); override;
  public
    constructor Create(FieldHandle: TRuntimeFieldHandle; Name: WideString; ReflectedType, DeclaringType: TType; FieldType: TType; Value: Longint);
  end;

  TRuntimeEnumerationValueFieldInfo = class(TRuntimeFieldInfo)
  public
    procedure GetValue(const Obj; out Result); override;
  end;

  TRuntimeClassFieldInfo = class(TRuntimeFieldInfo)
  public
    procedure GetValue(const Obj; out Result); override;
  end;

implementation

uses
  Smide.System.Types.Runtime.TypeInfo,
  Smide.System.Types.Runtime.TypeHandlers,
  Smide.System.Common.GetText;

{ TRuntimeMethodInfo }

constructor TRuntimeMethodInfo.Create(MethodHandle: TRuntimeMethodHandle; Name: WideString; ReflectedType, DeclaringType: TType;
  Attributes: TMethodAttributes; Address: Pointer; Parameters: TParameterInfoCollection; ReturnType: TType;
  CallingConvention: TCallingConvention; VirtualIndex, DynamicIndex: Integer; ParentDefinition: TMethodInfo);
begin
  FMethodHandle := MethodHandle;
  FName := Name;
  FAddress := Address;
  FDeclaringType := DeclaringType;
  FReflectedType := ReflectedType;
  FReturnType := ReturnType;
  FAttributes := Attributes;
end;

function TRuntimeMethodInfo.get_Attributes: TMethodAttributes;
begin
  Result := FAttributes;
end;

function TRuntimeMethodInfo.get_BaseDefinition: TMethodInfo;
begin
  raise ENotImplemented.Create('TRuntimeMethodInfo.get_BaseDefinition');
end;

function TRuntimeMethodInfo.get_CallingConventions: TCallingConventions;
begin
  raise ENotImplemented.Create('TRuntimeMethodInfo.get_CallingConventions');
end;

function TRuntimeMethodInfo.get_DeclaringType: TType;
begin
  Result := FDeclaringType;
end;

function TRuntimeMethodInfo.get_IsFunction: Boolean;
begin
  Result := ReturnType <> nil;
end;

function TRuntimeMethodInfo.get_IsProcedure: Boolean;
begin
  Result := ReturnType = nil;
end;

function TRuntimeMethodInfo.get_MethodHandle: TRuntimeMethodHandle;
begin
  Result := FMethodHandle;
end;

function TRuntimeMethodInfo.get_Name: WideString;
begin
  Result := FName;
end;

function TRuntimeMethodInfo.get_ParentDefinition: TMethodInfo;
begin
  raise ENotImplemented.Create('TRuntimeMethodInfo.get_ParentDefinition');
end;

function TRuntimeMethodInfo.get_ReflectedType: TType;
begin
  Result := FReflectedType;
end;

function TRuntimeMethodInfo.get_ReturnType: TType;
begin
  Result := FReturnType;
end;

procedure TRuntimeMethodInfo.InvokeImpl(const Obj; InvokeAttr: TBindingFlags;
  Binder: TBinder; Parameters: array of const; out Result);
type
  TVoidMethod = procedure of object;
var
  FMethod: TVoidMethod;
begin
  // TODO:
  TMethod(FMethod).Code := FAddress;
  TMethod(FMethod).Data := Pointer(Obj);

  FMethod;
end;

{ TRuntimeFieldInfo }

constructor TRuntimeFieldInfo.Create(FieldHandle: TRuntimeFieldHandle;
  Name: WideString; ReflectedType, DeclaringType: TType;
  Attributes: TFieldAttributes; FieldType: TType);
begin
  FFieldHandle := FieldHandle;

  // TODO: Check the Arguments
  FName := Name;
  FReflectedType := ReflectedType;
  FDeclaringType := DeclaringType;
  FAttributes := Attributes;
  FFieldType := FieldType;
end;

function TRuntimeFieldInfo.get_Attributes: TFieldAttributes;
begin
  Result := FAttributes;
end;

function TRuntimeFieldInfo.get_DeclaringType: TType;
begin
  Result := FDeclaringType;
end;

function TRuntimeFieldInfo.get_FieldHandle: TRuntimeFieldHandle;
begin
  Result := FFieldHandle;
end;

function TRuntimeFieldInfo.get_FieldType: TType;
begin
  Result := FFieldType;
end;

function TRuntimeFieldInfo.get_Name: WideString;
begin
  Result := FName;
end;

function TRuntimeFieldInfo.get_ReflectedType: TType;
begin
  Result := FReflectedType;
end;

function TRuntimeFieldInfo.ToString: widestring;
begin
  result := Name + ': ' + FieldType.ToString;
end;

{ TRuntimeInheritedFieldInfo }

constructor TRuntimeInheritedFieldInfo.Create(FieldInfo: TFieldInfo; ReflectedType: TType);
begin
  inherited Create;
  if FieldInfo = nil then
    raise EArgumentNil.Create('FieldInfo');
  if ReflectedType = nil then
    raise EArgumentNil.Create('ReflectedType');

  FFieldInfo := FieldInfo;
  FReflectedType := ReflectedType;
end;

function TRuntimeInheritedFieldInfo.get_Attributes: TFieldAttributes;
begin
  Result := FFieldInfo.Attributes;
end;

function TRuntimeInheritedFieldInfo.get_DeclaringType: TType;
begin
  Result := FFieldInfo.DeclaringType;
end;

function TRuntimeInheritedFieldInfo.get_FieldHandle: TRuntimeFieldHandle;
begin
  Result := FFieldInfo.FieldHandle;
end;

function TRuntimeInheritedFieldInfo.get_FieldType: TType;
begin
  Result := FFieldInfo.FieldType;
end;

function TRuntimeInheritedFieldInfo.get_Name: WideString;
begin
  Result := FFieldInfo.Name;
end;

function TRuntimeInheritedFieldInfo.get_ReflectedType: TType;
begin
  Result := FReflectedType;
end;

procedure TRuntimeInheritedFieldInfo.GetValue(const Obj; out Result);
begin
  FFieldInfo.GetValue(Obj, Result);
end;

function TRuntimeInheritedFieldInfo.ToString: widestring;
begin
  result := FFieldInfo.ToString;
end;

{ TRuntimeEnumerationFieldInfo }

constructor TRuntimeEnumerationFieldInfo.Create(
  FieldHandle: TRuntimeFieldHandle; Name: WideString; ReflectedType,
  DeclaringType, FieldType: TType; Value: Integer);
begin
  inherited Create(FieldHandle, Name, ReflectedType, DeclaringType,
    [faPublic, faStatic, faLiteral, faHasDefault], FieldType);

  FValue := Value;
end;

procedure TRuntimeEnumerationFieldInfo.GetValue(const Obj; out Result);
begin
  case (DeclaringType as TEnumerationType).OrdinalKind of
    okUnsignedByte: Byte(Result) := Byte(FValue);
    okSignedByte: ShortInt(Result) := ShortInt(FValue);
    otUnsignedWord: Word(Result) := Word(FValue);
    okSignedWord: SmallInt(Result) := SmallInt(FValue);
    otUnsignedLong: Cardinal(Result) := Cardinal(FValue);
    otSignedLong: Integer(Result) := Integer(FValue);
  else
    raise EUnknownType.Create(Name);
  end;
end;

{ TRuntimeEnumerationValueFieldInfo }

procedure TRuntimeEnumerationValueFieldInfo.GetValue(const Obj; out Result);
begin
  raise ENotImplemented.Create('TFieldInfo.GetValue');
end;

{ TRuntimeClassFieldInfo }

procedure TRuntimeClassFieldInfo.GetValue(const Obj; out Result);
begin
  if (pointer(Obj)=nil) and not IsStatic then
    raise ETarget.Create(_('Non-static field requires a target'));

  if not TType.GetType(TObject(Obj)).IsSubclassOf(ReflectedType) then
    raise EArgument.Create(_('Object type cannot be converted to target type.'));

  FieldType.DataToValue(TDataType(PPointer(integer(Obj) + PField(FieldHandle)^.Offset)^), Result);
end;

end.

