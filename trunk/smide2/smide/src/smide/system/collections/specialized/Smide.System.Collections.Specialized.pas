unit Smide.System.Collections.Specialized;

interface

uses
  Smide.System,
  Smide.System.Types,
  Smide.System.Collections;

type
  IStringEnumerator = interface(IEnumerator)
    ['{D31FC038-356C-4132-9CE4-B9E0BB71243B}']
    function get_Current: WideString;
    property Current: WideString read get_Current;
  end;

  TStringEnumerator = class(TEnumeratorBase, IStringEnumerator)
  protected
    function get_Current: WideString;
  public
    property Current: WideString read get_Current;
  end;

  IStringCollection = interface(ICollection)
    ['{EDC1B6B1-52CB-4C6E-AC18-DCC571FACB23}']
    function Add(const Value: WideString): Integer;
    procedure Insert(Index: Integer; const Value: WideString);
    procedure Remove(const Value: WideString);
    function Contains(const Value: WideString): Boolean;
    function IndexOf(const Value: WideString): Integer;
    function GetEnumerator: IStringEnumerator;

    function get_Items(Index: Integer): WideString;
    procedure set_Items(Index: Integer; const Value: WideString);
    property Items[Index: Integer]: WideString read get_Items write set_Items; default;
  end;

  TStringCollection = class(TCollectionBase, IStringCollection)
  private
    function get_Items(Index: Integer): WideString;
    procedure set_Items(Index: Integer; const Value: WideString);
  protected
    function get_TypeHandler: ITypeHandler; override;
  public
    function Add(const Value: WideString): Integer;
    procedure Insert(Index: Integer; const Value: WideString);
    procedure Remove(const Value: WideString);
    function Contains(const Value: WideString): Boolean;
    function IndexOf(const Value: WideString): Integer;
    procedure GetEnumerator(out Enumerator: IEnumerator); override;
    function GetEnumerator: IStringEnumerator; overload; virtual;

    property Items[Index: Integer]: WideString read get_Items write set_Items; default;
  end;

implementation

{ TStringEnumerator }

function TStringEnumerator.get_Current: WideString;
begin
  GetCurrentItem(Result);
end;

{ TStringCollection }

function TStringCollection.Add(const Value: WideString): Integer;
begin
  Result := ItemAdd(Value);
end;

function TStringCollection.Contains(const Value: WideString): Boolean;
begin
  Result := ItemContains(Value);
end;

function TStringCollection.GetEnumerator: IStringEnumerator;
begin
  Result := TStringEnumerator.Create(InnerList);
end;

procedure TStringCollection.GetEnumerator(out Enumerator: IEnumerator);
begin
  Enumerator := GetEnumerator;
end;

function TStringCollection.get_Items(Index: Integer): WideString;
begin
  ItemGet(Index, Result);
end;

function TStringCollection.get_TypeHandler: ITypeHandler;
begin
  Result := TType.GetTypeHandler(TypeInfo(WideString));
end;

function TStringCollection.IndexOf(const Value: WideString): Integer;
begin
  Result := ItemIndexOf(Value);
end;

procedure TStringCollection.Insert(Index: Integer; const Value: WideString);
begin
  ItemInsert(Index, Value);
end;

procedure TStringCollection.Remove(const Value: WideString);
begin
  ItemRemove(Value);
end;

procedure TStringCollection.set_Items(Index: Integer; const Value: WideString);
begin
  ItemSet(Index, Value);
end;

end.
