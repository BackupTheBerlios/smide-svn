unit Smide.System.Types.Runtime.EnumerationTypeCollectors;

interface

uses
  Smide.System,
  Smide.System.Reflection,
  Smide.System.Types,
  Smide.System.Types.Runtime.TypeInfo,
  Smide.System.Types.Runtime.Collectors,
  Smide.System.Types.Runtime.TypeHandlers;

type
  TEnumerationTypeFieldCollector = class(TFieldCollector)
  private
    FEnumType: TEnumerationType;
    FFields: TFieldInfoCollection;
  protected
    function GetFieldInfos: TFieldInfoCollection; virtual;
  public
    function GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo; override;
    function GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection; override;
  public
    constructor Create(EnumType: TEnumerationType); virtual;
    destructor Destroy; override;

    property EnumType: TEnumerationType read FEnumType;
    property Fields: TFieldInfoCollection read GetFieldInfos;
  end;

const
  FIELD_VALUE_HANDLE = TRuntimeFieldHandle(-1);
  FIELD_VALUE_NAME = 'value__';

implementation

uses
  Smide.System.Types.Runtime,
  Smide.System.Reflection.Runtime;

{ TEnumerationTypeFieldCollector }

constructor TEnumerationTypeFieldCollector.Create(EnumType: TEnumerationType);
begin
  if EnumType = nil then
    raise EArgumentNil.Create('EnumType');
  FEnumType := EnumType;
end;

destructor TEnumerationTypeFieldCollector.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TEnumerationTypeFieldCollector.GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo;
begin
  Result := nil;
end;

function TEnumerationTypeFieldCollector.GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection;
var
  i: Integer;
  FieldInfo: TFieldInfo;
begin
  Result := TFieldInfoCollection.Create;
  for i := 0 to Fields.Count - 1 do
  begin
    FieldInfo := Fields[i];

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

    if FieldInfo.DeclaringType.RuntimeTypeHandle <> EnumType.RuntimeTypeHandle then
      if (bfDeclaredOnly in BindingAttr) then
        continue;

    Result.Add(FieldInfo);
  end;
end;

function TEnumerationTypeFieldCollector.GetFieldInfos: TFieldInfoCollection;
var
  FieldInfo: TRuntimeFieldInfo;
  i: Integer;
  P: ^ShortString;
begin
  if not Assigned(FFields) then
  begin
    FFields := TFieldInfoCollection.Create(true);

    // Add the inherited Fields
    if Assigned(EnumType.BaseType) then
    begin
      with EnumType.BaseType.GetFields.GetEnumerator do
        while MoveNext do
          if Current.FieldHandle <> FIELD_VALUE_HANDLE then
            FFields.Add(TRuntimeInheritedFieldInfo.Create(Current, EnumType));
    end
    else
    begin
      P := @EnumType.RuntimeTypeInfoData^.NameList;

      // Special case Boolean types
      if (EnumType as TRuntimeEnumerationType).IsBoolean then
      begin
        for i := EnumType.MaxValue downto EnumType.MinValue do
        begin
          FieldInfo := TRuntimeEnumerationFieldInfo.Create(P, P^, EnumType, EnumType, EnumType, i);
          FFields.Add(FieldInfo);

          Inc(Integer(P), Length(P^) + 1);
        end;
      end
      else
      begin
        for i := EnumType.MinValue to EnumType.MaxValue do
        begin
          FieldInfo := TRuntimeEnumerationFieldInfo.Create(P, P^, EnumType, EnumType, EnumType, i);
          FFields.Add(FieldInfo);

          Inc(Integer(P), Length(P^) + 1);
        end;
      end;
    end;

    // this is the value field
    FieldInfo := TRuntimeFieldInfo.Create(FIELD_VALUE_HANDLE, FIELD_VALUE_NAME, EnumType, EnumType, [ftPublic, ftSpecialName, ftRTSpecialName],
      TRuntimeType.GetRuntimeOrdinalType(EnumType.RuntimeTypeHandle));
    FFields.Add(FieldInfo);
  end;

  Result := FFields;
end;

end.
