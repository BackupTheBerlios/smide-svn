unit Smide.System.Types.Runtime.Collectors;

interface

uses
  Smide.System,
  Smide.System.Reflection;

type
  TBaseCollector = class(TSmideObject)
  private
    FOwnerType: TType;
  protected
    constructor Create(OwnerType: TType); virtual;

    property OwnerType: TType read FOwnerType;
  end;

  TMethodCollector = class(TBaseCollector)
  protected
    function GetMethodInfos: TMethodInfoCollection; virtual; abstract;
    property MethodInfos: TMethodInfoCollection read GetMethodInfos;
  public
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
      Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo; overload; virtual;
    function GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection; virtual;
  end;

  TPropertyCollector = class(TBaseCollector)
    // TODO:
  protected
  end;

  TFieldCollector = class(TBaseCollector)
  protected
    function GetFieldInfos: TFieldInfoCollection; virtual; abstract;
    property FieldInfos: TFieldInfoCollection read GetFieldInfos;
  public
    function GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo; virtual;
    function GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection; virtual;

    function MatchField(FieldInfo: TFieldInfo; Name: WideString; BindingAttr: TBindingFlags): Boolean;
  protected
  end;

implementation

{ TBaseCollector }

constructor TBaseCollector.Create(OwnerType: TType);
begin
  if OwnerType = nil then
    raise EArgumentNil.Create('OwnerType');
  FOwnerType := OwnerType;
end;

{ TMethodCollector }

{ TPropertyCollector }

{ TFieldCollector }

function TFieldCollector.MatchField(FieldInfo: TFieldInfo; Name: WideString; BindingAttr: TBindingFlags): Boolean;
begin
  Result := false;

  if FieldInfo.IsPublic then
    if not (bfPublic in BindingAttr) then
      exit
    else
  else
    if not (bfNonPublic in BindingAttr) then
      exit;

  if FieldInfo.IsStatic then
    if not (bfStatic in BindingAttr) then
      exit
    else
  else
    if not (bfInstance in BindingAttr) then
      exit;

  if bfIgnoreCase in BindingAttr then
    if TString.Compare(FieldInfo.Name, Name, true) <> 0 then
      exit
    else
  else
    if TString.Compare(FieldInfo.Name, Name) <> 0 then
      exit;

  if FieldInfo.DeclaringType.RuntimeTypeHandle <> OwnerType.RuntimeTypeHandle then
    if (bfDeclaredOnly in BindingAttr) then
      exit;

  Result := true;
end;

function TFieldCollector.GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo;
var
  i: Integer;
begin
  Result := nil;

  if Name = '' then
    raise EArgumentEmpty.Create('Name');

  for i := 0 to FieldInfos.Count - 1 do
  begin
    if MatchField(FieldInfos[i], Name, BindingAttr) then
    begin
      Result := FieldInfos[i];
      break;
    end;
  end;
end;

function TFieldCollector.GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection;
var
  i: Integer;
  FieldInfo: TFieldInfo;
begin
  Result := TFieldInfoCollection.Create;
  for i := 0 to FieldInfos.Count - 1 do
  begin
    FieldInfo := FieldInfos[i];

    if FieldInfo.IsPublic then
      if not (bfPublic in BindingAttr) then
        continue
      else
    else
      if not (bfNonPublic in BindingAttr) then
        continue;

    if FieldInfo.IsStatic then
      if not (bfStatic in BindingAttr) then
        continue
      else
    else
      if not (bfInstance in BindingAttr) then
        continue;

    if FieldInfo.DeclaringType.RuntimeTypeHandle <> OwnerType.RuntimeTypeHandle then
      if (bfDeclaredOnly in BindingAttr) then
        continue;

    Result.Add(FieldInfo);
  end;
end;

{ TMethodCollector }

function TMethodCollector.GetMethod(Name: WideString;
  BindingAttr: TBindingFlags; Binder: TBinder; Types: ITypeCollection;
  Modifiers: array of TParameterModifier): TMethodInfo;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to MethodInfos.Count - 1 do
  begin
    if MethodInfos[i].Name = Name then
    begin
      Result := MethodInfos[i];
      exit;
    end;
  end;
end;

function TMethodCollector.GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection;
var
  i: Integer;
begin
  Result := TMethodInfoCollection.Create;
  for i := 0 to MethodInfos.Count - 1 do
  begin
    // TODO: BindingAttrs
    Result.Add(MethodInfos[i]);
  end;
end;

end.

