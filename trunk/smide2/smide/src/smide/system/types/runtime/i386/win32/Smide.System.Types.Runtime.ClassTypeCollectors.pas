unit Smide.System.Types.Runtime.ClassTypeCollectors;

interface

uses
  Smide.System,
  Smide.System.Reflection,
  Smide.System.Types,
  Smide.System.Types.Runtime.TypeInfo,
  Smide.System.Types.Runtime.Collectors,
  Smide.System.Types.Runtime.TypeHandlers;

type
  TClassTypeMethodCollector = class(TMethodCollector)
  private
    FClsType: TClassType;
    FMethods: TMethodInfoCollection;
  protected
    function GetMethodInfos: TMethodInfoCollection; virtual; abstract;
  public
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
      Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo; override;
    function GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection; override;
  public
    constructor Create(ClsType: TClassType); virtual;
    destructor Destroy; override;

    property ClsType: TClassType read FClsType;
    property Methods: TMethodInfoCollection read GetMethodInfos;
  public
    class function CreateMethodCollector(ClsType: TClassType): TClassTypeMethodCollector;
  end;

  TMethodInfoMethodCollector = class(TClassTypeMethodCollector)
  protected
    function GetMethodInfos: TMethodInfoCollection; override;
  end;

implementation

uses
  Smide.System.Reflection.Runtime;

{ TClassTypeMethodCollector }

constructor TClassTypeMethodCollector.Create(ClsType: TClassType);
begin
  if ClsType = nil then
    raise EArgumentNil.Create('ClsType');

  FClsType := ClsType;
end;

class function TClassTypeMethodCollector.CreateMethodCollector(ClsType: TClassType): TClassTypeMethodCollector;
begin
  Result := TMethodInfoMethodCollector.Create(ClsType);
end;

destructor TClassTypeMethodCollector.Destroy;
begin
  FMethods.Free;
  inherited;
end;

function TClassTypeMethodCollector.GetMethod(Name: WideString; BindingAttr: TBindingFlags;
  Binder: TBinder; Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Methods.Count - 1 do
  begin
    if Methods[i].Name = Name then
    begin
      Result := Methods[i];
      exit;
    end;
  end;
end;

function TClassTypeMethodCollector.GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection;
var
  i: Integer;
begin
  Result := TMethodInfoCollection.Create;
  for i := 0 to Methods.Count - 1 do
  begin
    // TODO: BindingAttrs
    Result.Add(Methods[i]);
  end;
end;

{ TMethodInfoMethodCollector }

function TMethodInfoMethodCollector.GetMethodInfos: TMethodInfoCollection;
var
  MethodInfoPtr: Pointer;
  Count: Integer;
  i: Integer;
  RuntimeMethodInfo: TRuntimeMethodInfo;
  Address: Pointer;
begin
  if not Assigned(FMethods) then
  begin
    FMethods := TMethodInfoCollection.Create(true);

    MethodInfoPtr := PPointer(Integer(ClsType.RuntimeTypeInfoData^.ClassType) + vmtMethodTable)^;

    if MethodInfoPtr <> nil then
    begin
      Count := PWord(MethodInfoPtr)^;
      Inc(Integer(MethodInfoPtr), 2);

      for i := 0 to Count - 1 do
      begin
        Address := PVmtMethodInfo(MethodInfoPtr)^.Address;
        RuntimeMethodInfo := TRuntimeMethodInfo.Create(MethodInfoPtr, PVmtMethodInfo(MethodInfoPtr)^.Name,
          ClsType, ClsType, [maPublic], Address, nil, nil, ccUnknown, 0, 0, nil);

        FMethods.Add(RuntimeMethodInfo);

        Inc(Integer(MethodInfoPtr), PVmtMethodInfo(MethodInfoPtr)^.Size);
      end;
    end;
  end;
  Result := FMethods;
end;

end.
