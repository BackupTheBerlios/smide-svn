unit Smide.System.Collections.Runtime;

interface

uses
  Smide.System.Runtime,
  Smide.System.Collections.Common,
  Smide.System.Types.Common,
  Smide.System.Types.Runtime.TypeData;

type
  PListData = ^TListData;
  TListData = array[0..MaxListSize - 1] of TTypeData;

  TListBase = class(TSmideObject, IList)
  private
    FVersion: Integer;
    FCount: Integer;
    FCapacity: Integer;
    FOwned: Boolean;
    procedure CheckIndex(Index: Integer);
    function ValidIndex(Index: Integer): Boolean;
  protected
    FTypeHandler: ITypeHandler;
    FList: PListData;
    function CreateTypeHandler: ITypeHandler; virtual;
  protected
    procedure Grow; virtual;
    function get_Capacity: Integer; virtual;
    procedure set_Capacity(Capacity: Integer); virtual;
    procedure SetCount(Count: Integer); virtual;
  protected // ICollections
    function get_Count: Integer;
  public // IList
    procedure ItemGet(Index: Integer; out Value);
    procedure ItemSet(Index: Integer; const Value);
    function ItemAdd(const Value): Integer;
    procedure ItemInsert(Index: Integer; const Value);
    procedure ItemRemove(const Value);
    function ItemContains(const Value): Boolean;
    function ItemIndexOf(const Value): Integer;
    // TODO: CopyTo
  protected
    function get_ReadOnly: Boolean; virtual;
    function get_IsFixedSize: Boolean; virtual;
  public
    procedure RemoveAt(Index: Integer);
    procedure Clear;
    property ReadOnly: Boolean read get_ReadOnly;
    property IsFixedSize: Boolean read get_IsFixedSize;
  public // IEnumerable
    procedure GetEnumerator(out Enumerator: IEnumerator); overload; virtual;
  public
    property TypeHandler: ITypeHandler read FTypeHandler;
  public
    property Capacity: Integer read get_Capacity write set_Capacity;
    property List: PListData read FList;
  public // ICollections
    property Count: Integer read get_Count;
  public
    constructor Create(TypeHandler: ITypeHandler; Owned: Boolean = false); overload;
    constructor Create(Capacity: Integer; TypeHandler: ITypeHandler = nil; Owned: Boolean = false); overload;
    // TODO: constructor Create(C: ICollection; TypeHandler: ITypeHandler = nil); overload;
    destructor Destroy; override;

    property Version: Integer read FVersion;
    property Owned: Boolean read FOwned;
  end;

  TEnumeratorBase = class(TSmideObject, IEnumerator)
  private
  protected
    FList: TListBase;
    FIndex: Integer;
    FVersion: Integer;
    FCurrent: TTypeData;
    function get_CurrentIndex: Integer;
  public
    constructor Create(List: TListBase); virtual;
    function MoveNext: Boolean;
    procedure GetCurrentItem(out Value);
    procedure Reset;

    property CurrentIndex: Integer read get_CurrentIndex;
  end;

implementation

uses
  Smide.System.Common.GetText,
  Smide.System;

{ TListBase }

procedure TListBase.Clear;
var
  P: TTypeData;
begin
  while FCount > 0 do
  begin
    Dec(FCount);
    if Owned then
    begin
      P := FList^[FCount];
      TypeHandler.FreeData(P);
    end
    else
    begin
      P := nil;
      TypeHandler.DataToValue(FList^[FCount], P);
      TypeHandler.ClearValue(P);
    end;
  end;

  Capacity := 0;
  Inc(FVersion);
end;

constructor TListBase.Create(TypeHandler: ITypeHandler; Owned: Boolean);
begin
  inherited Create;

  FOwned := Owned;

  if TypeHandler = nil then
    TypeHandler := CreateTypeHandler;

  if TypeHandler = nil then
    raise EArgumentNil.Create('TypeHandler');

  FTypeHandler := TypeHandler;
end;

destructor TListBase.Destroy;
begin
  Clear;
  FTypeHandler := nil;
  inherited;
end;

function TListBase.get_Capacity: Integer;
begin
  Result := FCapacity;
end;

function TListBase.get_Count: Integer;
begin
  Result := FCount;
end;

procedure TListBase.GetEnumerator(out Enumerator: IEnumerator);
begin
  Enumerator := TEnumeratorBase.Create(Self);
end;

procedure TListBase.CheckIndex(Index: Integer);
begin
  if not ValidIndex(Index) then
    raise EArgumentOutOfRange.Create('Index', _('Index was out of range.  Must be non-negative and less than the size of the collection.'));
end;

function TListBase.ValidIndex(Index: Integer): Boolean;
begin
  // with Lock do
  Result := (Index >= 0) and (Index < FCount);
end;

procedure TListBase.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then
    Delta := FCapacity div 4
  else
    if FCapacity > 8 then
      Delta := 16
    else
      Delta := 4;
  Capacity := Capacity + Delta;
end;

function TListBase.ItemAdd(const Value): Integer;
var
  PValue: TTypeData;
begin
  // with Lock do
  begin
    Result := FCount;
    if Result = FCapacity then Grow;
    Inc(FCount);
    TypeHandler.ValueToData(Value, PValue);
    FList^[Result] := PValue;
    Inc(FVersion);
  end;
end;

procedure TListBase.ItemGet(Index: Integer; out Value);
var
  Temp: TTypeData;
begin
  // with Lock do
  begin
    CheckIndex(Index);
    Temp := FList^[Index];
    TypeHandler.DataToValue(Temp, Value);
  end;
end;

procedure TListBase.ItemInsert(Index: Integer; const Value);
begin
  // with Lock do
  begin
    if FCount = FCapacity then Grow;

    if Index < FCount then
    begin
      System.Move(FList^[Index], FList^[Index + 1], (FCount - Index) * SizeOf(TTypeData));
      FList^[Index] := nil;
    end;

    Inc(FCount);
    ItemSet(Index, Value);
    Inc(FVersion);
  end;
end;

procedure TListBase.ItemRemove(const Value);
var
  i: Integer;
begin
  // with Lock do
  begin
    i := ItemIndexOf(Value);
    if i >= 0 then
      RemoveAt(i);
  end;
  Inc(FVersion);
end;

procedure TListBase.ItemSet(Index: Integer; const Value);
var
  PValue: TTypeData;
  P: TTypeData;
begin
  // with Lock do
  begin
    CheckIndex(Index);
    PValue := FList^[Index];

    if PValue <> nil then
    begin
      if Owned then
      begin
        TypeHandler.FreeData(PValue);
      end
      else
      begin
        TypeHandler.DataToValue(PValue, P);
        TypeHandler.ClearValue(P);
      end;
    end;

    TypeHandler.ValueToData(Value, PValue);
    FList^[Index] := PValue;
    Inc(FVersion);
  end;
end;

procedure TListBase.RemoveAt(Index: Integer);
var
  P: TTypeData;
begin
  // with Lock do
  begin
    CheckIndex(Index);

    Dec(FCount);
    if Owned then
    begin
      P := FList^[Index];
      TypeHandler.FreeData(P);
    end
    else
    begin
      P := nil;
      TypeHandler.DataToValue(FList^[Index], P);
      TypeHandler.ClearValue(P);
    end;

    if Index < FCount then
      System.Move(FList^[Index + 1], FList^[Index], (FCount - Index) * SizeOf(TTypeData));

    FList^[FCount] := nil;
    Inc(FVersion);
  end;
end;

procedure TListBase.set_Capacity(Capacity: Integer);
begin
  if (Capacity < FCount) or (Capacity > MaxListSize) then
    raise EArgumentOutOfRange.Create('Capacity', _('Capacity was less than the current size.'));

  if Capacity <> FCapacity then
  begin
    ReallocMem(FList, Capacity * SizeOf(TTypeData));
    FCapacity := Capacity;
  end;
end;

procedure TListBase.SetCount(Count: Integer);
var
  i: Integer;
begin
  if (Count < 0) or (Count > MaxListSize) then
    raise EArgumentOutOfRange.Create('Count', _('Count was out of range.  Must be non-negative and less than the max size of the collection.'));
  if Count > FCapacity then
    Capacity := Count;
  if Count > FCount then
    FillChar(FList^[FCount], (Count - FCount) * SizeOf(TTypeData), 0)
  else
    for i := FCount - 1 downto Count do
      RemoveAt(i);
  FCount := Count;
end;

function TListBase.CreateTypeHandler: ITypeHandler;
begin
  Result := nil;
end;

function TListBase.ItemContains(const Value): Boolean;
begin
  Result := ItemIndexOf(Value) >= 0;
end;

function TListBase.ItemIndexOf(const Value): Integer;
var
  tmp: TTypeData;
  i: Integer;
begin
  // with Lock do
  begin
    Result := -1;
    for i := 0 to Count - 1 do
    begin
      tmp := nil;
      ItemGet(i, tmp);
      try
        if TypeHandler.SameValues(tmp, Value) then
        begin
          Result := i;
          Break;
        end;
      finally
        TypeHandler.ClearValue(tmp);
      end;
    end;
  end;
end;

function TListBase.get_IsFixedSize: Boolean;
begin
  Result := false;
end;

function TListBase.get_ReadOnly: Boolean;
begin
  Result := false;
end;

constructor TListBase.Create(Capacity: Integer; TypeHandler: ITypeHandler; Owned: Boolean);
begin
  Create(TypeHandler, Owned);
  Self.Capacity := Capacity;
end;

{ TEnumeratorBase }

constructor TEnumeratorBase.Create(List: TListBase);
begin
  inherited Create;

  FList := List;
  FIndex := -1;
  FVersion := FList.Version;
  FCurrent := List;
end;

procedure TEnumeratorBase.GetCurrentItem(out Value);
var
  Ptr: TTypeData;
begin
  if FCurrent = FList then
    if FIndex = -1 then
      raise EInvalidOperation.Create(_('Enumeration has not started. Call MoveNext.'))
    else
      raise EInvalidOperation.Create(_('Enumeration already finished.'));

  Ptr := FCurrent;
  FList.TypeHandler.DataToValue(Ptr, Value);
end;

function TEnumeratorBase.get_CurrentIndex: Integer;
begin
  Result := FIndex;
end;

function TEnumeratorBase.MoveNext: Boolean;
begin
  Result := false;
  if FVersion <> FList.Version then
    raise EInvalidOperation.Create(_('Collection was modified; enumeration operation may not execute.'));
  if FIndex < FList.Count - 1 then
  begin
    Inc(FIndex);
    FCurrent := FList.List[FIndex];
    Result := true;
  end
  else
  begin
    FCurrent := FList;
    FIndex := FList.Count;
  end;
end;

procedure TEnumeratorBase.Reset;
begin
  if FVersion <> FList.Version then
    raise EInvalidOperation.Create(_('Collection was modified; enumeration operation may not execute.'));

  FCurrent := FList;
  FIndex := -1;
end;

end.
