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
    FMethods: TMethodInfoCollection;
  public
    constructor Create(OwnerType: TType); override;
    destructor Destroy; override;
  public
    class function CreateMethodCollector(OwnerType: TClassType): TClassTypeMethodCollector;
  end;

  TClassTypeMethodInfoMethodCollector = class(TClassTypeMethodCollector)
  protected
    function GetMethodInfos: TMethodInfoCollection; override;
  end;

  TClassTypeFieldCollector = class(TFieldCollector)
  private
    FFields: TFieldInfoCollection;
  protected
    function GetFieldInfos: TFieldInfoCollection; override;
  public
    constructor Create(OwnerType: TType); override;
    destructor Destroy; override;
  end;

implementation

uses
  Smide.System.Reflection.Runtime;

{ TClassTypeMethodCollector }

constructor TClassTypeMethodCollector.Create(OwnerType: TType);
begin
  if not (OwnerType is TClassType) then
    raise EArgument.Create('OwnerType must be of TClassType');
  inherited;
end;

class function TClassTypeMethodCollector.CreateMethodCollector(OwnerType: TClassType): TClassTypeMethodCollector;
begin
  Result := TClassTypeMethodInfoMethodCollector.Create(OwnerType);
end;

destructor TClassTypeMethodCollector.Destroy;
begin
  FMethods.Free;
  inherited;
end;

{ TMethodInfoMethodCollector }

function TClassTypeMethodInfoMethodCollector.GetMethodInfos: TMethodInfoCollection;
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

    MethodInfoPtr := PPointer(Integer(OwnerType.RuntimeTypeInfoData^.ClassType) + vmtMethodTable)^;

    if MethodInfoPtr <> nil then
    begin
      Count := PWord(MethodInfoPtr)^;
      Inc(Integer(MethodInfoPtr), 2);

      for i := 0 to Count - 1 do
      begin
        Address := PVmtMethodInfo(MethodInfoPtr)^.Address;
        RuntimeMethodInfo := TRuntimeMethodInfo.Create(MethodInfoPtr, PVmtMethodInfo(MethodInfoPtr)^.Name,
          OwnerType, OwnerType, [maPublic], Address, nil, nil, ccUnknown, 0, 0, nil);

        FMethods.Add(RuntimeMethodInfo);

        Inc(Integer(MethodInfoPtr), PVmtMethodInfo(MethodInfoPtr)^.Size);
      end;
    end;
  end;
  Result := FMethods;
end;

{ TClassTypeFieldCollector }

constructor TClassTypeFieldCollector.Create(OwnerType: TType);
begin
  if not (OwnerType is TClassType) then
    raise EArgument.Create('OwnerType must be of TClassType');
  inherited;
end;

destructor TClassTypeFieldCollector.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TClassTypeFieldCollector.GetFieldInfos: TFieldInfoCollection;
var
  FieldInfoPtr: PFieldTable;
  i: Integer;
  FieldPtr: PField;
  FieldInfo: TRuntimeClassFieldInfo;
begin
  if not Assigned(FFields) then
  begin
    FFields := TFieldInfoCollection.Create(true);

    if Assigned(OwnerType.BaseType) then
    begin
      with OwnerType.BaseType.GetFields.GetEnumerator do
        while MoveNext do
          FFields.Add(TRuntimeInheritedFieldInfo.Create(Current, OwnerType));
    end;

    FieldInfoPtr := PPointer(Integer(OwnerType.RuntimeTypeInfoData^.ClassType) + vmtFieldTable)^;
    if FieldInfoPtr <> nil then
    begin
      FieldPtr := @FieldInfoPtr^.Fields;
      for i := 0 to FieldInfoPtr^.Count - 1 do
      begin

        FieldInfo := TRuntimeClassFieldInfo.Create(FieldPtr, FieldPtr^.Name, OwnerType, OwnerType, [faPublic],
          TType.GetType(FieldInfoPtr^.FieldClassTable^.Classes[FieldPtr^.ClassIndex]^));

        FFields.Add(FieldInfo);

        Inc(Integer(FieldPtr), SizeOf(TField) - SizeOf(ShortString) + Length(FieldPtr^.Name) + 1);
      end;
    end;
  end;
  Result := FFields;
end;

end.

