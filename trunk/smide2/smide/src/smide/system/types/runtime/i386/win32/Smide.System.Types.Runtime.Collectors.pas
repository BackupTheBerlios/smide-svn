unit Smide.System.Types.Runtime.Collectors;

interface

uses
  Smide.System,
  Smide.System.Reflection;

type
  TMethodCollector = class(TSmideObject)
  public
    function GetMethod(Name: WideString; BindingAttr: TBindingFlags; Binder: TBinder;
      Types: ITypeCollection; Modifiers: array of TParameterModifier): TMethodInfo; overload; virtual; abstract;
    function GetMethods(BindingAttr: TBindingFlags): IMethodInfoCollection; virtual; abstract;
  protected
    constructor Create;
  end;

  TPropertyCollector = class(TSmideObject)
    // TODO:
  protected
    constructor Create;
  end;

  TFieldCollector = class(TSmideObject)
  public
    function GetField(Name: WideString; BindingAttr: TBindingFlags): TFieldInfo; virtual; abstract;
    function GetFields(BindingAttr: TBindingFlags): IFieldInfoCollection; virtual; abstract;
  protected
    constructor Create;
  end;

implementation

{ TMethodCollector }

constructor TMethodCollector.Create;
begin
  inherited;
end;

{ TPropertyCollector }

constructor TPropertyCollector.Create;
begin
  inherited;
end;

{ TFieldCollector }

constructor TFieldCollector.Create;
begin
  inherited;
end;

end.
