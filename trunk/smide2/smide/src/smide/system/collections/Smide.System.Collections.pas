unit Smide.System.Collections;

interface

uses
  Smide.System.Common,
  Smide.System.Runtime,
  Smide.System.Collections.Common,
  Smide.System.Collections.Runtime,
  Smide.System.Types.Common;

type

  IEnumerator = Smide.System.Collections.Common.IEnumerator;
  IEnumerable = Smide.System.Collections.Common.IEnumerable;
  ICollection = Smide.System.Collections.Common.ICollection;
  IList = Smide.System.Collections.Common.IList;

  TListBase = Smide.System.Collections.Runtime.TListBase;
  TEnumeratorBase = Smide.System.Collections.Runtime.TEnumeratorBase;

  TCollectionBase = class(TSmideObject, IList, ICollection, IEnumerable)
  public // IEnumerable & ICollection
    procedure GetEnumerator(out Enumerator: IEnumerator); overload; virtual;
  protected // ICollection
    function get_Count: Integer;
  public
    property Count: Integer read get_Count;
  protected // IList
    procedure ItemGet(Index: Integer; out Value);
    procedure ItemSet(Index: Integer; const Value);
    function ItemAdd(const Value): Integer;
    procedure ItemInsert(Index: Integer; const Value);
    procedure ItemRemove(const Value);
    function ItemContains(const Value): Boolean;
    function ItemIndexOf(const Value): Integer;
    function get_ReadOnly: Boolean;
    function get_IsFixedSize: Boolean;
  public
    procedure RemoveAt(Index: Integer);
    procedure Clear;
    property ReadOnly: Boolean read get_ReadOnly;
    property IsFixedSize: Boolean read get_IsFixedSize;
  private
    FInnerList: TListBase;
    FOwned: Boolean;
  protected
    function get_InnerList: TListBase; virtual;
    property InnerList: TListBase read get_InnerList;
  protected
    function get_TypeHandler: ITypeHandler; virtual; abstract;
  public
    property TypeHandler: ITypeHandler read get_TypeHandler;
  protected
    procedure DoSet(Index: Integer; const OldValue; const NewValue); virtual;
    procedure DoInsert(Index: Integer; const Value); virtual;
    procedure DoClear; virtual;
    procedure DoRemove(Index: Integer; const Value); virtual;
    procedure DoValidate(const Value); virtual;
    procedure DoSetComplete(Index: Integer; const OldValue; const NewValue); virtual;
    procedure DoInsertComplete(Index: Integer; const Value); virtual;
    procedure DoClearComplete; virtual;
    procedure DoRemoveComplete(Index: Integer; const Value); virtual;
  public
    constructor Create(Owned: Boolean = false);
    destructor Destroy; override;

    property Owned: Boolean read FOwned;
  end;

  TReadOnlyCollectionBase = class(TSmideObject, ICollection)
  public // IEnumerable & ICollection
    procedure GetEnumerator(out Enumerator: IEnumerator); overload; virtual;
  protected // ICollection
    function get_Count: Integer;
  public
    property Count: Integer read get_Count;
  private
    FInnerList: TListBase;
    FOwned: Boolean;
  protected
    function get_InnerList: TListBase; virtual;
    property InnerList: TListBase read get_InnerList;
  protected
    function get_TypeHandler: ITypeHandler; virtual; abstract;
  public
    property TypeHandler: ITypeHandler read get_TypeHandler;
  public
    constructor Create(Owned: Boolean = false);
    destructor Destroy; override;

    property Owned: Boolean read FOwned;
  end;

implementation

uses
  Smide.System.Common.GetText,
  Smide.System.Types;

{ TCollectionBase }

procedure TCollectionBase.Clear;
begin
  DoClear;
  InnerList.Clear;
  DoClearComplete;
end;

constructor TCollectionBase.Create(Owned: Boolean);
begin
  inherited Create;
  FOwned := Owned;
end;

destructor TCollectionBase.Destroy;
begin
  FInnerList.Free;
  inherited;
end;

procedure TCollectionBase.DoClear;
begin

end;

procedure TCollectionBase.DoClearComplete;
begin

end;

procedure TCollectionBase.DoInsert(Index: Integer; const Value);
begin

end;

procedure TCollectionBase.DoInsertComplete(Index: Integer; const Value);
begin

end;

procedure TCollectionBase.DoRemove(Index: Integer; const Value);
begin

end;

procedure TCollectionBase.DoRemoveComplete(Index: Integer; const Value);
begin

end;

procedure TCollectionBase.DoSet(Index: Integer; const OldValue, NewValue);
begin

end;

procedure TCollectionBase.DoSetComplete(Index: Integer; const OldValue, NewValue);
begin

end;

procedure TCollectionBase.DoValidate(const Value);
begin

end;

function TCollectionBase.get_Count: Integer;
begin
  if Assigned(FInnerList) then
    Result := FInnerList.Count
  else
    Result := 0;
end;

procedure TCollectionBase.GetEnumerator(out Enumerator: IEnumerator);
begin
  InnerList.GetEnumerator(Enumerator);
end;

function TCollectionBase.get_InnerList: TListBase;
begin
  if not Assigned(FInnerList) then
    FInnerList := TListBase.Create(TypeHandler, Owned);
  Result := FInnerList;
end;

function TCollectionBase.get_IsFixedSize: Boolean;
begin
  Result := InnerList.IsFixedSize;
end;

function TCollectionBase.get_ReadOnly: Boolean;
begin
  Result := InnerList.ReadOnly;
end;

function TCollectionBase.ItemAdd(const Value): Integer;
begin
  DoValidate(Value);
  DoInsert(InnerList.Count, Value);
  Result := InnerList.ItemAdd(Value);
  try
    DoInsertComplete(Result, Value);
  except
    InnerList.RemoveAt(Result);
    raise;
  end;
end;

function TCollectionBase.ItemContains(const Value): Boolean;
begin
  Result := InnerList.ItemContains(Value);
end;

procedure TCollectionBase.ItemGet(Index: Integer; out Value);
begin
  if (Index < 0) or (Index >= InnerList.Count) then
    raise EArgumentOutOfRange.Create('Index', _('Index was out of range. Must be non-negative and less than the size of the collection.'));
  FInnerList.ItemGet(Index, Value);
end;

function TCollectionBase.ItemIndexOf(const Value): Integer;
begin
  Result := InnerList.ItemIndexOf(Value)
end;

procedure TCollectionBase.ItemInsert(Index: Integer; const Value);
begin
  if (Index < 0) or (Index >= InnerList.Count) then
    raise EArgumentOutOfRange.Create('Index', _('Index was out of range. Must be non-negative and less than the size of the collection.'));
  DoValidate(Value);
  DoInsert(Index, Value);
  InnerList.ItemInsert(Index, Value);
  try
    DoInsertComplete(Index, Value);
  except
    InnerList.RemoveAt(Index);
    raise;
  end;
end;

procedure TCollectionBase.ItemRemove(const Value);
var
  Index: Integer;
begin
  DoValidate(Value);
  Index := InnerList.ItemIndexOf(Value);
  if Index < 0 then
    raise EArgument.Create(_('Cannot remove the specified item because it was not found in the specified Collection.'));
  DoRemove(Index, Value);
  InnerList.RemoveAt(Index);
  DoRemoveComplete(Index, Value);
end;

procedure TCollectionBase.ItemSet(Index: Integer; const Value);
var
  P: Pointer;
begin
  if (Index < 0) or (Index >= InnerList.Count) then
    raise EArgumentOutOfRange.Create('Index', _('Index was out of range. Must be non-negative and less than the size of the collection.'));
  DoValidate(Value);
  ItemGet(Index, P);
  DoSet(Index, P, Value);
  InnerList.ItemSet(Index, Value);
  try
    DoSetComplete(Index, P, Value);
  except
    InnerList.ItemSet(Index, P);
    raise;
  end;
end;

procedure TCollectionBase.RemoveAt(Index: Integer);
var
  P: Pointer;
begin
  if (Index < 0) or (Index >= InnerList.Count) then
    raise EArgumentOutOfRange.Create('Index', _('Index was out of range. Must be non-negative and less than the size of the collection.'));
  InnerList.ItemGet(Index, P);
  DoValidate(P);
  DoRemove(Index, P);
  InnerList.RemoveAt(Index);
  DoRemoveComplete(Index, P);
end;

{ TReadOnlyCollectionBase }

constructor TReadOnlyCollectionBase.Create(Owned: Boolean);
begin
  FOwned := Owned;
end;

destructor TReadOnlyCollectionBase.Destroy;
begin
  FInnerList.Free;
  inherited;
end;

function TReadOnlyCollectionBase.get_Count: Integer;
begin
  if Assigned(FInnerList) then
    Result := FInnerList.Count
  else
    Result := 0;
end;

procedure TReadOnlyCollectionBase.GetEnumerator(out Enumerator: IEnumerator);
begin
  InnerList.GetEnumerator(Enumerator);
end;

function TReadOnlyCollectionBase.get_InnerList: TListBase;
begin
  if not Assigned(FInnerList) then
    FInnerList := TListBase.Create(TypeHandler, Owned);
  Result := FInnerList;
end;

end.
