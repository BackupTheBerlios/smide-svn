unit Smide.System.Common;

{$I ..\Smide.inc}

interface

uses
  Smide.System.Runtime,
  Smide.System.Reflection.Runtime.Handles;

type
  // Exceptions

  // Reference support
  IReferenceable = interface
    ['{C28BF91B-2ED2-48C8-BA0E-BF0DF932F882}']
    function GetInstance: Pointer;

    property Instance: Pointer read GetInstance;
  end;

  // Clone support
  ICloneable = interface
    ['{2157E85B-67D8-4202-B96B-0603A2B3CF00}']
    function Clone: TObject;
  end;

  // Compare Support
  IComparable = interface
    ['{E7F92BD9-3194-47ED-A860-2DC17104FFDE}']
    function CompareTo(const Value: TObject): Integer;
  end;

  TStaticBaseClass = class of TStaticBase;
  TStaticBase = class(TSmideObject)
  protected
    // hide the default members of TObject
    constructor Create;

    procedure Free; reintroduce;
    class function InitInstance(Instance: Pointer): TObject; reintroduce;
    procedure CleanupInstance; reintroduce;
    function GetInterface(const IID: TGUID; out Obj): Boolean; reintroduce;
    class function GetInterfaceEntry(const IID: TGUID): PInterfaceEntry; reintroduce;
    class function GetInterfaceTable: PInterfaceTable; reintroduce;
    function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HResult; reintroduce;
    procedure AfterConstruction; reintroduce;
    procedure BeforeDestruction; reintroduce;
    procedure Dispatch(var Message); reintroduce;
    procedure DefaultHandler(var Message); reintroduce;
    destructor Destroy; reintroduce;
  public
    procedure FreeInstance; override;
    class function NewInstance: TObject; override;
  end;

  TReference = class(TStaticBase)
  public
    class function GetInstance(const Intf: IInterface): Pointer;
    class function GetObject(const Intf: IInterface; const IID: TGUID; Cls: TClass): Pointer;
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

  Exception = class(TSmideObject)
  private
    FMessage: WideString;
    FInnerException: Exception;
    FParent: Exception;
    FStackTrace: WideString;
    function get_StackTrace: WideString;
  protected
    function get_Message: WideString; virtual;
  public
    constructor Create; overload; virtual;
    constructor Create(Message: WideString); overload;
    constructor Create(Message: WideString; InnerException: Exception); overload;

    property Message: WideString read get_Message;
    property Parent: Exception read FParent write FParent;

    property StackTrace: WideString read get_StackTrace;
  end;
  ExceptionClass = class of Exception;

  ESystem = class(Exception)
  public
    constructor Create; override;
  end;

  EStaticAccess = class(ESystem)
  public
    constructor Create; override;
  end;

  ENotImplemented = class(ESystem)
  public
    constructor Create; override;
  end;

  EArgument = class(ESystem)
  private
    FParamName: WideString;
  protected
    function get_Message: WideString; override;
  public
    constructor Create; override;
    constructor Create(Message, ParamName: WideString); overload;
    constructor Create(Message, ParamName: WideString; InnerException: Exception); overload;

    property ParamName: WideString read FParamName;
  end;

  EArgumentNil = class(EArgument)
  public
    constructor Create; override;
    constructor Create(ParamName: WideString); overload;
  end;

  EArgumentOutOfRange = class(EArgument)
  private
    FActualValue: WideString;
  protected
    function get_Message: WideString; override;
  public
    constructor Create; override;
    constructor Create(ParamName: WideString); overload;
    constructor Create(ParamName, Message: WideString); overload;
    constructor Create(ParamName, ActualValue, Message: WideString); overload;
  end;

  EInvalidOperation = class(ESystem)
  public
    constructor Create; override;
  end;

  EUnknownType = class(ESystem)
  end;

  ENotSupported = class(ESystem)
  end;

type
  IFormatProvider = interface
    ['{3AB5BE6C-5D18-4D8A-B8BD-1A4BC509B51D}']
    function GetFormat(FormatType: TRuntimeTypeHandle): TObject;
  end;

  IFormatible = interface
    ['{562FD003-0E1E-479F-B817-868F1E414F6A}']
    function ToString(Format: WideString; FormatProvider: IFormatProvider): WideString;
  end;

  ICustomFormatter = interface
    ['{1E0818CB-BCA6-466C-B2EE-D34DE3DB6D13}']
    function Format(Format: WideString; const Arg; FormatProvider: IFormatProvider): WideString;
  end;

implementation

uses
  Smide.System.Common.GetText,
  Smide.System.Runtime.Environment;

{ TStaticBase }

procedure TStaticBase.AfterConstruction;
begin
  raise EStaticAccess.Create;
end;

procedure TStaticBase.BeforeDestruction;
begin
  raise EStaticAccess.Create;
end;

procedure TStaticBase.CleanupInstance;
begin
  raise EStaticAccess.Create;
end;

constructor TStaticBase.Create;
begin
  raise EStaticAccess.Create;
end;

procedure TStaticBase.DefaultHandler(var Message);
begin
  raise EStaticAccess.Create;
end;

destructor TStaticBase.Destroy;
begin
  raise EStaticAccess.Create;
end;

procedure TStaticBase.Dispatch(var Message);
begin
  raise EStaticAccess.Create;
end;

procedure TStaticBase.Free;
begin
  raise EStaticAccess.Create;
end;

procedure TStaticBase.FreeInstance;
begin
  raise EStaticAccess.Create;
end;

function TStaticBase.GetInterface(const IID: TGUID; out Obj): Boolean;
begin
  raise EStaticAccess.Create;
end;

class function TStaticBase.GetInterfaceEntry(const IID: TGUID): PInterfaceEntry;
begin
  raise EStaticAccess.Create;
end;

class function TStaticBase.GetInterfaceTable: PInterfaceTable;
begin
  raise EStaticAccess.Create;
end;

class function TStaticBase.InitInstance(Instance: Pointer): TObject;
begin
  raise EStaticAccess.Create;
end;

class function TStaticBase.NewInstance: TObject;
begin
  raise EStaticAccess.Create;
end;

function TStaticBase.SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HResult;
begin
  raise EStaticAccess.Create;
end;

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

class function TReference.GetObject(const Intf: IInterface; const IID: TGUID; Cls: TClass): Pointer;
var
  Entry: PInterfaceEntry;
begin
  Result := nil;
  if Intf <> nil then
  begin
    Entry := Cls.GetInterfaceEntry(IID);
    if Entry = nil then exit;
    Result := Pointer(Integer(Pointer(Intf)) - Entry.IOffset);

    // the TObject class has the lowest address in memory
    // all other class type must have a higher address
    if Integer(Result^) < Integer(TObject) then
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

{ Exception }

constructor Exception.Create;
begin
  {$IFDEF DEBUG}
  _FIDEMessage_ := Self.Message;
  {$ENDIF}
end;

constructor Exception.Create(Message: WideString);
begin
  FMessage := Message;
  {$IFDEF DEBUG}
  _FIDEMessage_ := Self.Message;
  {$ENDIF}
end;

constructor Exception.Create(Message: WideString; InnerException: Exception);
begin
  FMessage := Message;
  {$IFDEF DEBUG}
  _FIDEMessage_ := Self.Message;
  {$ENDIF}
  FInnerException := InnerException;
  if FInnerException <> nil then
    FInnerException.Parent := Self;
end;

function Exception.get_Message: WideString;
begin
  if FMessage = '' then
    // TODO: -odbiehl -cs : Format the message
    Result := _('Exception of type {0} was raised.', [ClassName])
  else
    Result := FMessage;
end;

function Exception.get_StackTrace: WideString;
begin
  Result := FStackTrace;
end;

{ ESystem }

constructor ESystem.Create;
begin
  inherited Create(_('System error.'));
end;

{ EStaticAccess }

constructor EStaticAccess.Create;
begin
  inherited Create(_('Cannot invoke a method of static class.'));
end;

{ ENotImplemented }

constructor ENotImplemented.Create;
begin
  inherited Create(_('The method or operation is not implemented.'));
end;

constructor EArgument.Create;
begin
  inherited Create(_('Value does not fall within the expected range.'));
end;

constructor EArgument.Create(Message, ParamName: WideString);
begin
  inherited Create(Message);
  FParamName := ParamName;
end;

constructor EArgument.Create(Message, ParamName: WideString; InnerException: Exception);
begin
  inherited Create(Message, InnerException);
  FParamName := ParamName;
end;

function EArgument.get_Message: WideString;
begin
  Result := inherited Message;
  if ParamName <> '' then
    // TODO: -odbiehl -cs : Format the message
    Result := Result + TEnvironment.NewLine + _('Parameter name: {0}', [FParamName]);
end;

{ EArgumentNil }

constructor EArgumentNil.Create;
begin
  inherited Create(_('Value cannot be null.'));
end;

constructor EArgumentNil.Create(ParamName: WideString);
begin
  inherited Create(_('Value cannot be null.'), ParamName);
end;

{ EArgumentOutOfRange }

constructor EArgumentOutOfRange.Create(ParamName: WideString);
begin
  inherited Create(_('Specified argument was out of the range of valid values.'), ParamName);
end;

constructor EArgumentOutOfRange.Create;
begin
  inherited Create(_('Specified argument was out of the range of valid values.'));
end;

constructor EArgumentOutOfRange.Create(ParamName, ActualValue, Message: WideString);
begin
  inherited Create(Message, ParamName);
  FActualValue := ActualValue;
end;

constructor EArgumentOutOfRange.Create(ParamName, Message: WideString);
begin
  inherited Create(Message, ParamName);
end;

function EArgumentOutOfRange.get_Message: WideString;
var
  ValueMessage: WideString;
begin
  Result := inherited Message;
  if FActualValue <> '' then
  begin
    // TODO: Format
    ValueMessage := _('Actual value was {0}.', [FActualValue]);
    if Result = '' then
      Result := ValueMessage
    else
      Result := Result + TEnvironment.NewLine + ValueMessage;
  end;
end;

{ EInvalidOperation }

constructor EInvalidOperation.Create;
begin
  inherited Create(_('Operation is not valid due to the current state of the object.'));
end;

end.

