unit Smexperts.System;

interface

uses
  Windows,
  Dialogs,
  Classes,
  SysUtils,
  ToolsApi,
  ActnList;

type
  {$TYPEINFO ON}
  TNotifierBase = class(TInterfacedObject)
  private
    FOnAfterSave: TNotifyEvent;
    FOnBeforeSave: TNotifyEvent;
    FOnDestroyed: TNotifyEvent;
    FOnModified: TNotifyEvent;
  protected
    procedure AfterSave; virtual;
    procedure BeforeSave; virtual;
    procedure Destroyed; virtual;
    procedure Modified; virtual;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  published
    property OnAfterSave: TNotifyEvent read FOnAfterSave write FOnAfterSave;
    property OnBeforeSave: TNotifyEvent read FOnBeforeSave write FOnBeforeSave;
    property OnDestroyed: TNotifyEvent read FOnDestroyed write FOnDestroyed;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;
  {$TYPEINFO OFF}

  TConnectableNotifierBase = class(TNotifierBase)
  protected
    FNotifierIndex: Integer;
    procedure Destroyed; override;

  public
    constructor Create;
    destructor Destroy; override;

    procedure BeforeDestruction; override;

    procedure Connect; virtual; abstract;
    procedure Disconnect; virtual; abstract;
  end;

  TNotifier = class(TNotifierBase, IOTANotifier)
  end;

  TCheckOverwriteEvent = function(Sender: TObject): Boolean of object;
  TModuleRenamedEvent = procedure(Sender: TObject; const NewName: string) of object;

  TModuleNotifierBase = class(TConnectableNotifierBase)
  private
    FOnCheckOverwrite: TCheckOverwriteEvent;
    FOnModuleRenamed: TModuleRenamedEvent;
    FModule: IOTAModule;
  protected
    function CheckOverwrite: Boolean; virtual;
    procedure ModuleRenamed(const NewName: string); virtual;

    function GetModule: IOTAModule;
  public
    constructor Create(AModule: IOTAModule);

    property Module: IOTAModule read GetModule;
  published
    property OnCheckOverwrite: TCheckOverwriteEvent read FOnCheckOverwrite write FOnCheckOverwrite;
    property OnModuleRenamed: TModuleRenamedEvent read FOnModuleRenamed write FOnModuleRenamed;
  end;

  TModuleNotifier = class(TModuleNotifierBase, IOTAModuleNotifier)
  public
    procedure Connect; override;
    procedure Disconnect; override;
  end;

  TFileNotificationEvent = procedure(Sender: TObject; NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean) of object;
  TBeforeCompileEvent = procedure(Sender: TObject; const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean) of object;
  TAfterCompileEvent = procedure(Sender: TObject; Succeeded: Boolean; IsCodeInsight: Boolean) of object;

  TIDENotifierBase = class(TConnectableNotifierBase)
  private
    FOnAfterCompile: TAfterCompileEvent;
    FOnBeforeCompile: TBeforeCompileEvent;
    FOnFileNotification: TFileNotificationEvent;
  protected
    procedure FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean); virtual;
    procedure BeforeCompile(const Project: IOTAProject; var Cancel: Boolean); overload; virtual;
    procedure AfterCompile(Succeeded: Boolean); overload; virtual;
  published
    property OnFileNotification: TFileNotificationEvent read FOnFileNotification write FOnFileNotification;
    property OnBeforeCompile: TBeforeCompileEvent read FOnBeforeCompile write FOnBeforeCompile;
    property OnAfterCompile: TAfterCompileEvent read FOnAfterCompile write FOnAfterCompile;
  end;

  TIDENotifier = class(TIDENotifierBase, IOTAIDENotifier)
  public
    procedure Connect; override;
    procedure Disconnect; override;
  public
    constructor Create;
  end;

  TIDENotifier50Base = class(TIDENotifierBase)
  protected
    procedure BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean); overload; virtual;
    procedure AfterCompile(Succeeded: Boolean; IsCodeInsight: Boolean); overload; virtual;
  end;

  TIDENotifier50 = class(TIDENotifier50Base, IOTAIDENotifier, IOTAIDENotifier50)
  public
    constructor Create;
    procedure Connect; override;
    procedure Disconnect; override;
  end;

  TWizardBase = class(TNotifierBase, IOTAWizard)
  public
    function GetIDString: string; virtual;
    function GetName: string; virtual;
    function GetState: TWizardState; virtual;

    { Launch the AddIn }
    procedure Execute; virtual;

    constructor Create; virtual;
  end;

  TOpenToolsServices = class
  public
    class function HighlightServices: IOTAHighlightServices;
    class function ActionServices: IOTAActionServices;
    class function ModuleServices: IOTAModuleServices;
    class function DebuggerServices: IOTADebuggerServices;
    class function WizardServices: IOTAWizardServices;
    class function PackageServices: IOTAPackageServices;
    class function MessageServices: IOTAMessageServices;
    class function Services: IOTAServices;
    class function KeyBindingServices: IOTAKeyBindingServices;
    class function KeyboardServices: IOTAKeyboardServices;
    class function EditorServices: IOTAEditorServices;
    class function ToDoServices: IOTAToDoServices;
    class function CodeInsightServices: IOTACodeInsightServices;

    class function GetActiveProjectGroup: IOTAProjectGroup;
  end;

  TNativeToolsServices = class
  public
    class function Services: INTAServices;
  end;

procedure Register;
procedure UnRegister;

implementation

uses
  Smexperts.ConfigurationManager,
  TypInfo;

var
  WizardIndex: Integer;

procedure Register;
begin
  // TODO: Register all Wizards dynamically
  WizardIndex := TOpenToolsServices.WizardServices.AddWizard(Smexperts.ConfigurationManager.TConfigurationManagerWizard.Create);
  //RegisterPackageWizard(Smexperts.ConfigurationManager.TConfigurationManagerWizard.Create);
  //RegisterPackageWizard(TWizardBase.Create);
end;

procedure UnRegister;
begin
  TOpenToolsServices.WizardServices.RemoveWizard(WizardIndex);
end;

{ TNotifierBase }

procedure TNotifierBase.AfterConstruction;
begin
  inherited;
end;

procedure TNotifierBase.AfterSave;
begin
  if Assigned(FOnAfterSave) then FOnAfterSave(Self);
end;

procedure TNotifierBase.BeforeDestruction;
begin
  inherited;
end;

procedure TNotifierBase.BeforeSave;
begin
  if Assigned(FOnBeforeSave) then FOnBeforeSave(Self);
end;

procedure TNotifierBase.Destroyed;
begin
  if Assigned(FOnDestroyed) then FOnDestroyed(Self);
end;

procedure TNotifierBase.Modified;
begin
  if Assigned(FOnModified) then FOnModified(Self);
end;

{ TWizardBase }

constructor TWizardBase.Create;
begin

end;

procedure TWizardBase.Execute;
begin
  // Does nothing
end;

function TWizardBase.GetIDString: string;
begin
  // TODO: TType.Fullname
  Result := GetTypeData(PTypeInfo(Self.ClassInfo))^.UnitName + '.' + PTypeInfo(Self.ClassInfo)^.Name;
end;

function TWizardBase.GetName: string;
begin
  // TODO: TType.Name
  Result := PTypeInfo(Self.ClassInfo)^.Name;
end;

function TWizardBase.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

{ TOpenToolsServices }

class function TOpenToolsServices.ActionServices: IOTAActionServices;
begin
  Result := BorlandIDEServices as IOTAActionServices;
end;

class function TOpenToolsServices.CodeInsightServices: IOTACodeInsightServices;
begin
  Result := BorlandIDEServices as IOTACodeInsightServices;
end;

class function TOpenToolsServices.DebuggerServices: IOTADebuggerServices;
begin
  Result := BorlandIDEServices as IOTADebuggerServices;
end;

class function TOpenToolsServices.EditorServices: IOTAEditorServices;
begin
  Result := BorlandIDEServices as IOTAEditorServices;
end;

class function TOpenToolsServices.GetActiveProjectGroup: IOTAProjectGroup;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to ModuleServices.ModuleCount - 1 do
    if Supports(ModuleServices.Modules[i], IOTAProjectGroup, Result) then
      Break;
end;

class function TOpenToolsServices.HighlightServices: IOTAHighlightServices;
begin
  Result := BorlandIDEServices as IOTAHighlightServices;
end;

class function TOpenToolsServices.KeyBindingServices: IOTAKeyBindingServices;
begin
  Result := BorlandIDEServices as IOTAKeyBindingServices;
end;

class function TOpenToolsServices.KeyboardServices: IOTAKeyboardServices;
begin
  Result := BorlandIDEServices as IOTAKeyboardServices;
end;

class function TOpenToolsServices.MessageServices: IOTAMessageServices;
begin
  Result := BorlandIDEServices as IOTAMessageServices;
end;

class function TOpenToolsServices.ModuleServices: IOTAModuleServices;
begin
  Result := BorlandIDEServices as IOTAModuleServices;
end;

class function TOpenToolsServices.PackageServices: IOTAPackageServices;
begin
  Result := BorlandIDEServices as IOTAPackageServices;
end;

class function TOpenToolsServices.Services: IOTAServices;
begin
  Result := BorlandIDEServices as IOTAServices;
end;

class function TOpenToolsServices.ToDoServices: IOTAToDoServices;
begin
  Result := BorlandIDEServices as IOTAToDoServices;
end;

class function TOpenToolsServices.WizardServices: IOTAWizardServices;
begin
  Result := BorlandIDEServices as IOTAWizardServices;
end;

{ TNativeToolsServices }

class function TNativeToolsServices.Services: INTAServices;
begin
  Result := BorlandIDEServices as INTAServices;
end;

{ TModuleNotifier }

function TModuleNotifierBase.CheckOverwrite: Boolean;
begin
  if Assigned(FOnCheckOverwrite) then
    Result := FOnCheckOverwrite(Self)
  else
    Result := true;
end;

constructor TModuleNotifierBase.Create(AModule: IOTAModule);
begin
  inherited Create;
  FModule := AModule;

  FNotifierIndex := -1;
  Connect;
end;

function TModuleNotifierBase.GetModule: IOTAModule;
begin
  Result := FModule;
end;

procedure TModuleNotifierBase.ModuleRenamed(const NewName: string);
begin
  if Assigned(FOnModuleRenamed) then
    FOnModuleRenamed(Self, NewName);
end;

{ TModuleNotifier }

procedure TModuleNotifier.Connect;
begin
  if FNotifierIndex = -1 then
    FNotifierIndex := FModule.AddNotifier(Self)
  else
    raise Exception.Create('Not is allway connected.');
end;

procedure TModuleNotifier.Disconnect;
begin
  if FNotifierIndex <> -1 then
    FModule.RemoveNotifier(FNotifierIndex);
  FNotifierIndex := -1;
  FModule := nil;
end;

{ TIDENotifierBase }

procedure TIDENotifierBase.AfterCompile(Succeeded: Boolean);
begin
  if Assigned(FOnAfterCompile) then
    FOnAfterCompile(Self, Succeeded, false);
end;

procedure TIDENotifierBase.BeforeCompile(const Project: IOTAProject; var Cancel: Boolean);
begin
  if Assigned(FOnBeforeCompile) then
    FOnBeforeCompile(Self, Project, false, Cancel);
end;

procedure TIDENotifierBase.FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
begin
  if Assigned(FOnFileNotification) then
    FOnFileNotification(Self, NotifyCode, FileName, Cancel);
end;

{ TIDENotifier50Base }

procedure TIDENotifier50Base.AfterCompile(Succeeded, IsCodeInsight: Boolean);
begin
  if Assigned(FOnAfterCompile) then
    FOnAfterCompile(Self, Succeeded, IsCodeInsight);
end;

procedure TIDENotifier50Base.BeforeCompile(const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean);
begin
  if Assigned(FOnBeforeCompile) then
    FOnBeforeCompile(Self, Project, IsCodeInsight, Cancel);
end;

{ TConnectableNotifierBase }

procedure TConnectableNotifierBase.BeforeDestruction;
begin
  Disconnect;
  inherited;
end;

constructor TConnectableNotifierBase.Create;
begin
  inherited;
  FNotifierIndex := -1;
end;

destructor TConnectableNotifierBase.Destroy;
begin
  inherited;
end;

procedure TConnectableNotifierBase.Destroyed;
begin
  inherited;
  Disconnect;
end;

{ TIDENotifier }

procedure TIDENotifier.Connect;
begin
  if FNotifierIndex = -1 then
    FNotifierIndex := TOpenToolsServices.Services.AddNotifier(Self as IOTAIDENotifier)
  else
    raise Exception.Create('Not is allway connected.');
end;

constructor TIDENotifier.Create;
begin
  inherited;
  Connect;
end;

procedure TIDENotifier.Disconnect;
begin
  if FNotifierIndex <> -1 then
    TOpenToolsServices.Services.RemoveNotifier(FNotifierIndex);
  FNotifierIndex := -1;
end;

{ TIDENotifier50 }

procedure TIDENotifier50.Connect;
begin
  FNotifierIndex := TOpenToolsServices.Services.AddNotifier(Self);
end;

constructor TIDENotifier50.Create;
begin
  inherited;
  Connect;
end;

procedure TIDENotifier50.Disconnect;
begin
  if FNotifierIndex <> -1 then
    TOpenToolsServices.Services.RemoveNotifier(FNotifierIndex);
  FNotifierIndex := -1;
end;

initialization
finalization
end.

