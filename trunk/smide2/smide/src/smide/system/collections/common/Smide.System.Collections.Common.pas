unit Smide.System.Collections.Common;

interface

const
  MaxListSize = MaxInt div 16;

type
  IEnumerator = interface
    ['{76D0F9E4-77C1-4AC3-85F7-3FC24726E38B}']
    function MoveNext: Boolean;
    procedure GetCurrentItem(out Value);
    procedure Reset;
    function get_CurrentIndex: Integer;

    property CurrentIndex: Integer read get_CurrentIndex;
  end;

  IEnumerable = interface
    ['{3A06A272-ED29-41C1-A876-2F6E92AF338F}']
    procedure GetEnumerator(out Enumerator: IEnumerator);
  end;

  ICollection = interface(IEnumerable)
    ['{BC606219-4FB7-4586-B8E9-B450BC51E6A0}']
    function get_Count: Integer;
    property Count: Integer read get_Count;
  end;

  IList = interface(ICollection)
    ['{B4BE0F74-D4A1-4371-83C8-5E032E6AC6B7}']
    procedure ItemGet(Index: Integer; out Value);
    procedure ItemSet(Index: Integer; const Value);
    function ItemAdd(const Value): Integer;
    procedure ItemInsert(Index: Integer; const Value);
    procedure ItemRemove(const Value);
    function ItemContains(const Value): Boolean;
    function ItemIndexOf(const Value): Integer;

    procedure RemoveAt(Index: Integer);
    procedure Clear;

    function get_ReadOnly: Boolean;
    property ReadOnly: Boolean read get_ReadOnly;

    function get_IsFixedSize: Boolean;
    property IsFixedSize: Boolean read get_IsFixedSize;
  end;

implementation

end.
