unit Smide.System.Runtime;

interface

{$I ..\..\..\Smide.inc}

type
  {$TYPEINFO ON}
  TSmideObject = class(TObject, IInterface)
  protected
    {$IFDEF DEBUG} // to show the exception text in the IDE
    _FIDEMessage_: string;
    {$ENDIF}
  private
    FRefCount: Integer;
  public // IInterface
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; virtual; stdcall;
    function _Release: Integer; virtual; stdcall;
    property RefCount: Integer read FRefCount;
  public // TObject overrides
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
  public
    function ToString: WideString; overload; virtual;
    function GetHashCode: Integer; virtual;
    function Equals(Obj: TObject): Boolean; overload; virtual;
    class function Equals(ObjA, ObjB: TObject): Boolean; overload;
    class function ReferenceEquals(ObjA, ObjB: TObject): Boolean;
  end;
  {$TYPEINFO OFF}

implementation

uses
  Windows,
  Smide.System.Common,
  Smide.System.Types;

{ TSmideObject }

function TSmideObject.Equals(Obj: TObject): Boolean;
begin
  Result := false;
  if Obj = Self then
  begin
    Result := true;
    exit;
  end;

  { TODO: maybe we can here compare the memory of the object instances
    if the object are from same type}
end;

procedure TSmideObject.AfterConstruction;
begin
  InterlockedDecrement(FRefCount);
end;

procedure TSmideObject.BeforeDestruction;
begin
  if RefCount <> 0 then
    System.Error(reInvalidPtr);
end;

class function TSmideObject.Equals(ObjA, ObjB: TObject): Boolean;
begin
  if (ObjA = ObjB) then
  begin
    Result := true;
    exit;
  end;

  if (ObjA = nil) or (ObjB = nil) then
  begin
    Result := false;
    exit;
  end;

  if ObjA is TSmideObject then
  begin
    Result := (ObjA as TSmideObject).Equals(ObjB);
    exit;
  end;

  if ObjB is TSmideObject then
  begin
    Result := (ObjB as TSmideObject).Equals(ObjA);
    exit;
  end;

  Result := false;
end;

function TSmideObject.GetHashCode: Integer;
begin
  Result := Integer(Self);
end;

class function TSmideObject.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TSmideObject(Result).FRefCount := 1;
end;

function TSmideObject.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

class function TSmideObject.ReferenceEquals(ObjA, ObjB: TObject): Boolean;
begin
  Result := ObjA = ObjB;
end;

function TSmideObject.ToString: WideString;
begin
  Result := TType.GetType(Self).FullName;
end;

function TSmideObject._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TSmideObject._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

end.
