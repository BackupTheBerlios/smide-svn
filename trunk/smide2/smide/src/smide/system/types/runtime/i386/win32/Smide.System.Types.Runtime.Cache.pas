unit Smide.System.Types.Runtime.Cache;

interface

uses
  Smide.System,
  Smide.System.Types.Runtime.TypeInfo;

type
  // this is a simple cache
  // TODO: faster cache
  // TODO: Typehandler cache
  TCacheEntry = record
    Info: PTypeInfo;
    Inst: TType;
    Handler: ITypeHandler;
  end;

  TTypeCache = class
  private
    FCache: array of TCacheEntry;
  protected
    constructor Create;
  public
    destructor Destroy; override;
  public
    class function FindEntry(TypeInfo: PTypeInfo): Integer;

    class function AddType(TypeInfo: PTypeInfo; Obj: TType): Integer;
    class function GetType(TypeInfo: PTypeInfo): TType;

    class function AddTypeHandler(TypeInfo: PTypeInfo; Obj: ITypeHandler): Integer;
    class function GetTypeHandler(TypeInfo: PTypeInfo): ITypeHandler;
  end;

implementation

var
  TypeCache: TTypeCache = nil;

  { TTypeCache }

class function TTypeCache.AddType(TypeInfo: PTypeInfo; Obj: TType): Integer;
begin
  Result := -1;

  if TypeInfo = nil then
    raise EArgumentNil.Create('TypeInfo');
  if Obj = nil then
    raise EArgumentNil.Create('Obj');

  if GetType(TypeInfo) <> nil then
    exit;

  if not Assigned(TypeCache) then
    TypeCache := TTypeCache.Create;

  with TypeCache do
  begin
    Result := Length(FCache);
    SetLength(FCache, Result + 1);
    with FCache[Result] do
    begin
      Info := TypeInfo;
      Inst := Obj;
      Handler := Obj as ITypeHandler;
    end;
  end;
end;

class function TTypeCache.AddTypeHandler(TypeInfo: PTypeInfo; Obj: ITypeHandler): Integer;
begin
  Result := -1;

  if GetTypeHandler(TypeInfo) <> nil then
    exit;

  Result := AddType(TypeInfo, TType(TReference.GetObject(Obj, ITypeHandler, TType)));

  if Result > -1 then
    TypeCache.FCache[Result].Handler := Obj;
end;

constructor TTypeCache.Create;
begin

end;

destructor TTypeCache.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FCache) - 1 do
  begin
    if FCache[i].Handler <> nil then
      FCache[i].Handler := nil
    else
      FCache[i].Inst.Free;
  end;
  inherited;
end;

class function TTypeCache.FindEntry(TypeInfo: PTypeInfo): Integer;
var
  i: Integer;
begin
  Result := -1;

  if TypeCache = nil then
    exit;

  with TypeCache do
    for i := 0 to Length(FCache) - 1 do
    begin
      if FCache[i].Info = TypeInfo then
      begin
        Result := i;
        Break;
      end;
    end;
end;

class function TTypeCache.GetType(TypeInfo: PTypeInfo): TType;
var
  i: Integer;
begin
  Result := nil;

  if TypeCache = nil then
    exit;

  i := FindEntry(TypeInfo);

  if i = -1 then
    exit;

  with TypeCache do
    Result := FCache[i].Inst;
end;

class function TTypeCache.GetTypeHandler(TypeInfo: PTypeInfo): ITypeHandler;
var
  i: Integer;
begin
  Result := nil;

  if TypeCache = nil then
    exit;

  i := FindEntry(TypeInfo);

  if i = -1 then
    exit;

  with TypeCache.FCache[i] do
  begin
    if (Handler = nil) and (Inst <> nil) then
      Handler := Inst;

    Result := Handler;
  end;
end;

initialization
finalization
  TypeCache.Free;
end.

