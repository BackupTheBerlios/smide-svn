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

    procedure AfterConstruction; override;
    
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


{ Exception }

constructor Exception.Create;
begin
end;

constructor Exception.Create(Message: WideString);
begin
  FMessage := Message;
end;

procedure Exception.AfterConstruction;
begin
  inherited;
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
  Result := inherited get_Message;
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
  inherited Create(_('Value cannot be nil.'), ParamName);
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
  Result := inherited get_Message;
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

