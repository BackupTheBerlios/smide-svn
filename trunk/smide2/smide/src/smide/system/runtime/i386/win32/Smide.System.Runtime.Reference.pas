unit Smide.System.Runtime.Reference;

interface

uses
  Smide.System.Common;

type
  TReference = class(TStaticBase)
  public
    class function GetInstance(const Intf: IInterface): Pointer;
    class function GetObject(const Intf: IInterface; const IID: TGUID; Cls: TClass): TObject;
    class function GetInterface(const Intf: IInterface; const IID: TGUID; out Res): Boolean; overload;
    class function GetInterface(const Obj: TObject; const IID: TGUID; out Res; RaiseError: Boolean = false): Boolean; overload;
    class function SameObject(const Intf1, Intf2: IInterface; const IID: TGUID): Boolean; overload;
    class function SameObject(const Intf1, Intf2: IInterface): Boolean; overload;
    class function Compare(const Intf1, Intf2: IInterface): Integer;
    class function Supports(const Intf: IInterface; const IID: TGUID): Boolean;
    class procedure Free(var Obj);
    class function AddRef(const Obj: TObject): Pointer; overload;
    class procedure Release(var Obj); overload;
    class function AddRef(const Intf: IInterface): Pointer; overload;
    class function Release(const Intf: Pointer): Pointer; overload;
    class function Extract(const Ptr: Pointer; const IID: TGUID; out Res): Boolean;
    class function ExtractInterface(const Intf: IInterface; const IID: TGUID; out Ptr: Pointer): Boolean;
  end;

implementation

{ TReference }

class function TReference.AddRef(const Intf: IInterface): Pointer;
begin
  IInterface(Result) := Intf;
end;

class function TReference.AddRef(const Obj: TObject): Pointer;
var
  i: IInterface;
  P: Pointer;
begin
  if Obj.GetInterface(IUnknown, i) then
  begin
    IInterface(P) := i;
  end;

  Result := Obj;
end;

class function TReference.Compare(const Intf1, Intf2: IInterface): Integer;
var
  Comp1, Comp2: IComparable;
  Res1, Res2: Integer;
begin
  if GetInterface(Intf1, IComparable, Comp1) then
    Res1 := +Comp1.CompareTo(TReference.GetInstance(Intf2))
  else
    Res1 := -1;

  if GetInterface(Intf2, IComparable, Comp2) then
    Res2 := -Comp2.CompareTo(TReference.GetInstance(Intf1))
  else
    Res2 := +1;

  if (Comp1 <> nil) or (Comp2 <> nil) then
  begin
    if (Res1 > 0) and (Res2 > 0) then
      if Res1 > Res2 then
        Result := Res1
      else
        Result := Res2
    else
      if (Res1 = 0) or (Res2 = 0) then
        Result := 0
      else
        if Res1 < Res2 then
          Result := Res1
        else
          Result := Res2;
  end
  else
    Result := Ord(SameObject(Intf1, Intf2)) - 1;
end;

class function TReference.Extract(const Ptr: Pointer; const IID: TGUID; out Res): Boolean;
begin
  raise ENotImplemented.Create('TReference.Extract');
end;

class function TReference.ExtractInterface(const Intf: IInterface; const IID: TGUID; out Ptr: Pointer): Boolean;
begin
  raise ENotImplemented.Create('TReference.ExtractInterface');
end;

class procedure TReference.Free(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

class function TReference.GetInstance(const Intf: IInterface): Pointer;
var
  Referenceable: IReferenceable;
begin
  if Assigned(Intf) and (Intf.QueryInterface(IReferenceable, Referenceable) = 0) then
    Result := Referenceable.Instance
  else
    Result := nil;
end;

class function TReference.GetInterface(const Obj: TObject; const IID: TGUID; out Res; RaiseError: Boolean): Boolean;
begin
  Result := Assigned(Obj);
  if Result then
  begin
    Result := Obj.GetInterface(IID, Res);
    if not Result and RaiseError then
      System.Error(reInvalidPtr);
  end
  else
    Pointer(Res) := nil;
end;

class function TReference.GetInterface(const Intf: IInterface; const IID: TGUID; out Res): Boolean;
begin
  if Assigned(Intf) then
    Result := Intf.QueryInterface(IID, Res) and HResult($80000000) = 0
  else
    Result := false;
end;

class function TReference.GetObject(const Intf: IInterface; const IID: TGUID; Cls: TClass): TObject;
var
  Entry: PInterfaceEntry;
begin
  Result := nil;
  if Intf <> nil then
  begin
    Entry := Cls.GetInterfaceEntry(IID);
    if Entry = nil then exit;
    Result := Pointer(Integer(Pointer(Intf)) - Entry.IOffset);

    // the TObject class has the lowest address in memory,
    // all other class type must have a higher address
    if Integer(Result.ClassType) < Integer(TObject) then
    begin
      Result := nil;
      exit;
    end;

    // maybe we have a class with the same interface table size
    // be shure we that the class is of same type
    if not TObject(Result).InheritsFrom(Cls) then
      Result := nil;
  end;
end;

class procedure TReference.Release(var Obj);
begin
  raise ENotImplemented.Create('TReference.Release');
end;

class function TReference.Release(const Intf: Pointer): Pointer;
begin
  raise ENotImplemented.Create('TReference.Release');
end;

class function TReference.SameObject(const Intf1, Intf2: IInterface): Boolean;
var
  I1, I2: IUnknown;
begin
  if (Intf1 = nil) and (Intf2 = nil) then
    Result := true
  else
    Result := GetInterface(Intf1, IInterface, I1) and GetInterface(Intf2, IUnknown, I2) and
      (Pointer(I1) = Pointer(I2));
end;

class function TReference.SameObject(const Intf1, Intf2: IInterface; const IID: TGUID): Boolean;
begin
  raise ENotImplemented.Create('TReference.SameObject');
end;

class function TReference.Supports(const Intf: IInterface; const IID: TGUID): Boolean;
begin
  raise ENotImplemented.Create('TReference.Supports');
end;

end.

