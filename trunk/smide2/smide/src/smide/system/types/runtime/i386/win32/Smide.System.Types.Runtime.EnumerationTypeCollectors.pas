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
    FFields: TFieldInfoCollection;
  protected
    function GetFieldInfos: TFieldInfoCollection; override;
  public
    constructor Create(OwnerType: TType); override;
    destructor Destroy; override;
  end;

const
  FIELD_VALUE_HANDLE = TRuntimeFieldHandle(-1);
  FIELD_VALUE_NAME = 'value__';

implementation

uses
  Smide.System.Types.Runtime,
  Smide.System.Reflection.Runtime;

{ TEnumerationTypeFieldCollector }

constructor TEnumerationTypeFieldCollector.Create(OwnerType: TType);
begin
  if not (OwnerType is TEnumerationType) then
    raise EArgument.Create('OwnerType must be of TEnumerationType');
  inherited;
end;

destructor TEnumerationTypeFieldCollector.Destroy;
begin
  FFields.Free;
  inherited;
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
    if Assigned(OwnerType.BaseType) then
    begin
      with OwnerType.BaseType.GetFields.GetEnumerator do
        while MoveNext do
          if Current.FieldHandle <> FIELD_VALUE_HANDLE then
            FFields.Add(TRuntimeInheritedFieldInfo.Create(Current, OwnerType));
    end
    else
    begin
      P := @OwnerType.RuntimeTypeInfoData^.NameList;

      // Special case Boolean types
      if (OwnerType as TRuntimeEnumerationType).IsBoolean then
      begin
        for i := OwnerType.MaxValue downto OwnerType.MinValue do
        begin
          FieldInfo := TRuntimeEnumerationFieldInfo.Create(P, P^, OwnerType, OwnerType, OwnerType, i);
          FFields.Add(FieldInfo);

          Inc(Integer(P), Length(P^) + 1);
        end;
      end
      else
      begin
        for i := OwnerType.MinValue to OwnerType.MaxValue do
        begin
          FieldInfo := TRuntimeEnumerationFieldInfo.Create(P, P^, OwnerType, OwnerType, OwnerType, i);
          FFields.Add(FieldInfo);

          Inc(Integer(P), Length(P^) + 1);
        end;
      end;
    end;

    // this is the value field
    FieldInfo := TRuntimeEnumerationValueFieldInfo.Create(FIELD_VALUE_HANDLE, FIELD_VALUE_NAME, OwnerType, OwnerType, [faPublic, faSpecialName, faRTSpecialName],
      TRuntimeType.GetRuntimeOrdinalType(OwnerType.RuntimeTypeHandle));
    FFields.Add(FieldInfo);
  end;

  Result := FFields;
end;

end.

