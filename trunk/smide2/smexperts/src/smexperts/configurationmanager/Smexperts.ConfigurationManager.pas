unit Smexperts.ConfigurationManager;

interface

uses
  Windows,
  Classes,
  SysUtils,
  ToolsApi,
  TypInfo,
  Smexperts.System,
  Menus,
  ActnList,
  Dialogs,
  IniFiles,
  Forms,
  Controls,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  IDEDockPanel;

resourcestring
  rsConfigurationNameIsNotValid = 'Configuration name is not valid.';
  rsConfigurationNameAllreadyInUse = 'Configuration name allready in use.';

  rsBuildMenu = 'Build';

  rsConfigurationManagerCategory = 'Configuration Manager';
  rsConfigurationManagerAction = 'Configuration &Manager...';

const
  CONFIG_PROJECT_FILE_EXTENSION = '.smeconfr';
  CONFIG_PROJECT_GROUP_FILE_EXTENSION = '.smeconfg';

const
  DIRECTORY_OPTIONS: array[0..3] of string = ('OutputDir', 'UnitOutputDir', 'PkgDllDir', 'PkgDcpDir');

type
  IConfigurationList = interface;

  IConfiguration = interface
    ['{600EF76F-371B-46F7-BF01-DCCBB8BBB87A}']

    function GetName: string;
    procedure SetName(const Value: string);
    property Name: string read GetName write SetName;

    procedure Serialize(IniFile: TIniFile);
    procedure Deserialize(IniFile: TIniFile);

    function GetOwner: IConfigurationList;
    property Owner: IConfigurationList read GetOwner;

    procedure Copy(Dest: IConfiguration);

    procedure StoreState;
    procedure RestoreState;

    function GetBuild: Boolean;
    procedure SetBuild(Value: Boolean);
    property Build: Boolean read GetBuild write SetBuild;
  end;

  IConfigurationList = interface
    ['{3958C861-9472-4924-B50D-F4E03F0A08C1}']
    procedure Deserialize;
    procedure Serialize;

    function GetModule: IOTAModule;
    property Module: IOTAModule read GetModule;

    function GetFilename: string;
    property FileName: string read GetFilename;

    function GetConfigurations(Index: Integer): IConfiguration;
    property Configurations[Index: Integer]: IConfiguration read GetConfigurations;

    function GetNames(Name: string): IConfiguration;
    property Names[Name: string]: IConfiguration read GetNames;

    function GetCount: Integer;
    property Count: Integer read GetCount;

    function Add(Name: string; CopyFrom: IConfiguration; CreateAdditional: Boolean; Activate: Boolean; CheckDuplicate: Boolean): IConfiguration;

    function GetActive: IConfiguration;
    procedure SetActive(Value: IConfiguration);
    property Active: IConfiguration read GetActive write SetActive;

    function GetActiveIndex: Integer;
    procedure SetActiveIndex(Value: Integer);
    property ActiveIndex: Integer read GetActiveIndex write SetActiveIndex;
  end;

  IProjectConfiguration = interface(IConfiguration)
    ['{D85A8DE2-6DE2-4273-A429-2F94A4CD46AB}']
    procedure AssignOptions(Options: IOTAOptions);
    procedure AssignOptionsTo(Option: IOTAOptions);

    function GetOptions: IOTAOptions;
    procedure SetOptions(Value: IOTAOptions);
    property Options: IOTAOptions read GetOptions write SetOptions;
  end;

  IProjectGroupConfiguration = interface(IConfiguration)
    ['{A7144CBC-32FD-4880-BD12-4EC390A61E7A}']
    function GetStates: TStringList;

    property States: TStringList read GetStates;
  end;

  IProjectConfigurationList = interface(IConfigurationList)
    ['{30145D85-81FC-4A9A-AFE9-778BEC509F4E}']
    function GetProject: IOTAProject;
    property Project: IOTAProject read GetProject;
  end;

  IProjectGroupConfigurationList = interface(IConfigurationList)
    ['{4E978755-1C32-461B-B572-562A09ED46AD}']
    function GetProjectGroup: IOTAProjectGroup;
    property ProjectGroup: IOTAProjectGroup read GetProjectGroup;

    function GetActive: IProjectGroupConfiguration;
    procedure SetActive(Value: IProjectGroupConfiguration);
    property Active: IProjectGroupConfiguration read GetActive write SetActive;
  end;

  TConfigurationManager = class(TWizardBase)
  private
    FIDENotifier: TIDENotifier;
    FConfigurations: TInterfaceList;
    FConfigurationManagerAction: TAction;
    FConfigurationComboBoxAction: TAction;
    FConfigurationManagerMenuItem: TMenuItem;

    {$IFDEF VER160}
    FConfigurationsBar: TToolBar;
    {$ELSE}
    FConfigurationsBar: TDockPanel;
    {$ENDIF}

    FConfigurationsComboBox: TComboBox;

    function GetConfigurations(Module: IOTAModule): IConfigurationList;
    function GetCount: Integer;
    function GetItems(Index: Integer): IConfigurationList;
    function GetProjectGroupConfigurations: IProjectGroupConfigurationList;
    function CreateConfigurationList(Owner: TConfigurationManager; Module: IOTAModule): IConfigurationList;

    procedure CreateToolbar;

    procedure DoConfigurationsComboBoxChange(Sender: TObject);
    procedure DoConfigurationManagerActionExceute(Sender: TObject);
    procedure DoConfigurationManagerActionUpdate(Sender: TObject);
  protected

    procedure FileNotification(Sender: TObject; NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
    procedure BeforeCompile(Sender: TObject; const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean);

    procedure DoConfigurationsChanged(ConfigurationList: IConfigurationList);
  public
    constructor Create; override;
    destructor Destroy; override;

    class function ConfigurationManager: TConfigurationManager;
    class procedure ShowConfigurationManager;

    procedure DeserializeConfigurations;

    procedure RemoveConfiguration(Config: IConfigurationList);
    property Configurations[Module: IOTAModule]: IConfigurationList read GetConfigurations;
    property Items[Index: Integer]: IConfigurationList read GetItems; default;
    property Count: Integer read GetCount;

    property ConfigurationManagerMenuItem: TMenuItem read FConfigurationManagerMenuItem;
    property ConfigurationManagerAction: TAction read FConfigurationManagerAction;

    property ProjectGroupConfigurations: IProjectGroupConfigurationList read GetProjectGroupConfigurations;
  end;

  TConfigurationManagerWizard = class(TConfigurationManager)
  end;

  TConfiguration = class(TInterfacedObject, IConfiguration)
  private
    FName: string;
    FOwner: IConfigurationList;
    FBuild: Boolean;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetOwner: IConfigurationList;
  protected
    procedure StoreState; virtual; abstract;
    procedure RestoreState; virtual; abstract;
  public
    property Name: string read GetName write SetName;

    procedure Serialize(IniFile: TIniFile); virtual; abstract;
    procedure Deserialize(IniFile: TIniFile); virtual; abstract;
    procedure Copy(Dest: IConfiguration); virtual; abstract;

    property Owner: IConfigurationList read GetOwner;

    constructor Create(Owner: IConfigurationList; Name: string); virtual;

    function GetBuild: Boolean;
    procedure SetBuild(Value: Boolean);
    property Build: Boolean read GetBuild write SetBuild;
  end;

  TOptionEntry = record
    Name: string;
    Kind: TTypeKind;
    Value: Variant;
    KeyValue: TStrings;
  end;

  TProjectConfiguration = class(TConfiguration, IOTAOptions, IProjectConfiguration)
  private
    FOptions: array of TOptionEntry;

  protected
    procedure StoreState; override;
    procedure RestoreState; override;
  public
    procedure Serialize(IniFile: TIniFile); override;
    procedure Deserialize(IniFile: TIniFile); override;

  public // IOTAOptions
    procedure EditOptions;
    function GetOptionValue(const ValueName: string): Variant;
    procedure SetOptionValue(const ValueName: string; const Value: Variant);
    function GetOptionNames: TOTAOptionNameArray;
    property Values[const ValueName: string]: Variant read GetOptionValue write SetOptionValue;
  public // IProjectConfiguration

    procedure AssignOptions(AOptions: IOTAOptions);
    procedure AssignOptionsTo(AOptions: IOTAOptions);

    procedure Copy(Dest: IConfiguration); override;

    constructor Create(Owner: IConfigurationList; Name: string); override;
    destructor Destroy; override;

    function GetOptions: IOTAOptions;
    procedure SetOptions(Value: IOTAOptions);
    property Options: IOTAOptions read GetOptions write SetOptions;

    function GetProject: IOTAProject;
    property Project: IOTAProject read GetProject;
  end;

  TProjectGroupConfiguration = class(TConfiguration, IProjectGroupConfiguration)
  private
    FStates: TStringList;
  protected
    function GetStates: TStringList;

    function ExtractProjectName(Name: string): string;

    procedure StoreState; override;
    procedure RestoreState; override;
  public
    procedure Serialize(IniFile: TIniFile); override;
    procedure Deserialize(IniFile: TIniFile); override;

    procedure Copy(Dest: IConfiguration); override;
  public
    constructor Create(Owner: IConfigurationList; Name: string); override;
    destructor Destroy; override;

    property States: TStringList read GetStates;
  end;

  TConfigurationList = class(TModuleNotifier, IConfigurationList)
  private
    FOwner: TConfigurationManager;
    FList: TInterfaceList;
    FActiveIndex: Integer;
    FDeserializing: Boolean;
    function GetConfigurations(Index: Integer): IConfiguration;
    function GetFilename: string; virtual; abstract;
    function GetCount: Integer;
    function GetActive: IConfiguration;
    procedure SetActive(Value: IConfiguration);
    function GetActiveIndex: Integer;
    function GetNames(Name: string): IConfiguration;
  protected
    procedure AfterSave; override;

    procedure SetActiveIndex(Value: Integer); virtual;

    function CreateConfiguration(Name: string): IConfiguration; virtual; abstract;

    procedure Changed;
  public
    property Configurations[Index: Integer]: IConfiguration read GetConfigurations; default;
    property Count: Integer read GetCount;

    property Names[Name: string]: IConfiguration read GetNames;

    constructor Create(Owner: TConfigurationManager; Module: IOTAModule);

    procedure AfterConstruction; override;

    procedure Disconnect; override;

    procedure Deserialize; virtual;
    procedure Serialize; virtual;

    property FileName: string read GetFilename;

    function Add(Name: string; CopyFrom: IConfiguration; CreateAdditional: Boolean; Activate: Boolean; CheckDuplicate: Boolean): IConfiguration;
      virtual;

    procedure Clear;

    property Active: IConfiguration read GetActive write SetActive;
    property ActiveIndex: Integer read GetActiveIndex write SetActiveIndex;
  end;

  TProjectConfigurationList = class(TConfigurationList, IProjectConfigurationList)
  private
    function GetProject: IOTAProject;
  protected
    function GetFilename: string; override;
    function CreateConfiguration(Name: string): IConfiguration; override;
  public
    function Add(Name: string; CopyFrom: IConfiguration; CreateAdditional: Boolean; Activate: Boolean; CheckDuplicate: Boolean): IConfiguration;
      override;

    property Project: IOTAProject read GetProject;
  end;

  TProjectGroupConfigurationList = class(TConfigurationList, IProjectGroupConfigurationList)
  private
    function GetProjectGroup: IOTAProjectGroup;
  protected
    function GetFilename: string; override;
    function CreateConfiguration(Name: string): IConfiguration; override;
  public
    function Add(Name: string; CopyFrom: IConfiguration; CreateAdditional: Boolean; Activate: Boolean; CheckDuplicate: Boolean): IConfiguration;
      override;

    property ProjectGroup: IOTAProjectGroup read GetProjectGroup;

    function GetActive_: IProjectGroupConfiguration;
    function IProjectGroupConfigurationList.GetActive = GetActive_;
    procedure SetActive_(Value: IProjectGroupConfiguration);
    procedure IProjectGroupConfigurationList.SetActive = SetActive_;

    property Active: IProjectGroupConfiguration read GetActive_ write SetActive_;
  end;

implementation

uses
  Smexperts.ConfigurationManager.ManagerForm,
  Variants;

function FindMenuItem(Item: TMenuItem; const Name: string): TMenuItem;
var
  i: Integer;
begin
  Result := nil;
  if Item.Name = Name then
    Result := Item
  else
    for i := 0 to Item.Count - 1 do
    begin
      Result := FindMenuItem(Item.Items[i], Name);
      if Result <> nil then
        exit;
    end;
end;

{ TConfigurationManager }

var
  FConfigurationManager: TConfigurationManager = nil;

class function TConfigurationManager.ConfigurationManager: TConfigurationManager;
begin
  Assert(Assigned(FConfigurationManager));
  Result := FConfigurationManager;
end;

procedure TConfigurationManager.CreateToolbar;
{$IFDEF VER160}
{$ELSE}
var
  PaletteBar: TDockPanel;
  {$ENDIF}
begin
  {$IFDEF VER160}
  FConfigurationsBar := TNativeToolsServices.Services.NewToolbar('ConfigurationBar', 'Configuration', '', true);
  {$ELSE}
  PaletteBar := TDockPanel(Application.MainForm.FindComponent('PaletteBar'));

  FConfigurationsBar := TDockPanel.Create(Application.MainForm);
  with FConfigurationsBar do
  begin
    AutoSize := true;
    BevelEdges := [];
    OnEndDock := PaletteBar.OnEndDock;
    Parent := PaletteBar.Parent;
    Left := 50;
    Name := 'ConfigurationBar';
    Caption := 'Configuration';
  end;
  {$ENDIF}

  FConfigurationComboBoxAction := TAction.Create(nil);
  with FConfigurationComboBoxAction do
  begin
    Caption := 'Update Configuration';
    Category := 'Configuration Manager';
    OnExecute := DoConfigurationsComboBoxChange;
    OnUpdate := DoConfigurationManagerActionUpdate;
  end;

  FConfigurationsComboBox := TComboBox.Create(nil);
  FConfigurationsComboBox.Width := 150;
  FConfigurationsComboBox.Style := csDropDownList;
  FConfigurationsComboBox.Action := FConfigurationComboBoxAction;
  FConfigurationManagerAction.ActionList := TNativeToolsServices.Services.ActionList;
  FConfigurationsComboBox.Parent := FConfigurationsBar;
end;

constructor TConfigurationManager.Create;
var
  ProjectMenu: TMenuItem;
begin
  inherited;
  if Assigned(FConfigurationManager) then
    raise Exception.Create('Only one Configuration Manager is allowed.');
  FConfigurationManager := Self;

  FIDENotifier := TIDENotifier.Create;
  FIDENotifier.OnFileNotification := FileNotification;
  FIDENotifier.OnBeforeCompile := BeforeCompile;

  FConfigurationManagerAction := TAction.Create(Application.MainForm);
  FConfigurationManagerAction.Caption := rsConfigurationManagerAction;
  FConfigurationManagerAction.Category := rsConfigurationManagerCategory;
  FConfigurationManagerAction.OnExecute := DoConfigurationManagerActionExceute;
  FConfigurationManagerAction.OnUpdate := DoConfigurationManagerActionUpdate;
  FConfigurationManagerAction.ActionList := TNativeToolsServices.Services.ActionList;

  //FConfigurationManagerAction.ActionList := TNativeToolsServices.Services.ActionList;

  FConfigurationManagerMenuItem := TMenuItem.Create(Application.MainForm);
  FConfigurationManagerMenuItem.Action := FConfigurationManagerAction;

  ProjectMenu := FindMenuItem(TNativeToolsServices.Services.MainMenu.Items, 'ProjectMenu');
  ProjectMenu.Insert(ProjectMenu.IndexOf(FindMenuItem(ProjectMenu, 'ProjectOptionsItem')), FConfigurationManagerMenuItem);

  CreateToolbar;

  DeserializeConfigurations;
end;

destructor TConfigurationManager.Destroy;
begin
  FConfigurations.Free;

  FIDENotifier.Disconnect;

  FConfigurationComboBoxAction.Free;
  FConfigurationsComboBox.Free;
  FConfigurationsBar.Free;

  FConfigurationManagerAction.Free;
  FConfigurationManagerMenuItem.Free;

  FConfigurationManager := nil;
  inherited;
end;

procedure TConfigurationManager.DoConfigurationManagerActionExceute(Sender: TObject);
begin
  ShowConfigurationManager;
end;

procedure TConfigurationManager.DoConfigurationManagerActionUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := TOpenToolsServices.GetActiveProjectGroup <> nil;
end;

class procedure TConfigurationManager.ShowConfigurationManager;
var
  Frm: TManagerForm;
begin
  Frm := TManagerForm.Create(Application);
  try
    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TConfigurationManager.FileNotification(Sender: TObject; NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
var
  i: Integer;
begin
  case NotifyCode of
    ofnFileOpened:
      begin
        for i := 0 to TOpenToolsServices.ModuleServices.ModuleCount - 1 do
        begin
          if TOpenToolsServices.ModuleServices.Modules[i].FileName = FileName then
            if Supports(TOpenToolsServices.ModuleServices.Modules[i], IOTAProject) or
              Supports(TOpenToolsServices.ModuleServices.Modules[i], IOTAProjectGroup) then
              Configurations[TOpenToolsServices.ModuleServices.Modules[i]].Deserialize;
        end;
      end;
  end;
end;

function TConfigurationManager.GetConfigurations(Module: IOTAModule): IConfigurationList;
var
  i: Integer;
begin
  Result := nil;
  if not Assigned(FConfigurations) then
    FConfigurations := TInterfaceList.Create;

  for i := 0 to FConfigurations.Count - 1 do
  begin
    if ((FConfigurations[i] as IConfigurationList).Module as IOTAModule) = (Module as IOTAModule) then
      Result := IConfigurationList(FConfigurations[i]);
  end;

  if Result = nil then
  begin
    Result := CreateConfigurationList(Self, Module);
    FConfigurations.Add(Result);
  end;
end;

function TConfigurationManager.CreateConfigurationList(Owner: TConfigurationManager; Module: IOTAModule): IConfigurationList;
begin
  if Supports(Module, IOTAProjectGroup) then
    Result := TProjectGroupConfigurationList.Create(Owner, Module)
  else
    if Supports(Module, IOTAProject) then
      Result := TProjectConfigurationList.Create(Owner, Module);
end;

function TConfigurationManager.GetCount: Integer;
begin
  Result := FConfigurations.Count;
end;

function TConfigurationManager.GetItems(Index: Integer): IConfigurationList;
begin
  Result := FConfigurations[Index] as IConfigurationList;
end;

function TConfigurationManager.GetProjectGroupConfigurations: IProjectGroupConfigurationList;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  begin
    if Supports(Items[i].Module, IOTAProjectGroup) then
    begin
      Result := Items[i] as IProjectGroupConfigurationList;
      exit;
    end;
  end;
end;

procedure TConfigurationManager.DeserializeConfigurations;
var
  i: Integer;
begin
  if TOpenToolsServices.GetActiveProjectGroup <> nil then
  begin
    Configurations[TOpenToolsServices.GetActiveProjectGroup].Deserialize;
    for i := 0 to TOpenToolsServices.GetActiveProjectGroup.ProjectCount - 1 do
      Configurations[TOpenToolsServices.GetActiveProjectGroup.Projects[i]].Deserialize;
  end;
end;

procedure TConfigurationManager.RemoveConfiguration(Config: IConfigurationList);
begin
  FConfigurations.Remove(Config);
end;

procedure TConfigurationManager.DoConfigurationsComboBoxChange(Sender: TObject);
begin
  with FConfigurationsComboBox do
  begin
    if ItemIndex > -1 then
    begin
      if Items.Objects[ItemIndex] = nil then
      begin
        ShowConfigurationManager;
        ItemIndex := ProjectGroupConfigurations.ActiveIndex;
      end
      else
        ProjectGroupConfigurations.ActiveIndex := ItemIndex;
    end;
  end;
end;

procedure TConfigurationManager.DoConfigurationsChanged(ConfigurationList: IConfigurationList);
var
  List: IProjectGroupConfigurationList;
  i: Integer;
begin
  if (TOpenToolsServices.GetActiveProjectGroup <> nil) then
  begin
    if Supports(ConfigurationList, IProjectGroupConfigurationList, List) then
    begin

      with FConfigurationsComboBox do
      begin
        Items.Clear;

        Items.BeginUpdate;
        ItemIndex := -1;
        try
          for i := 0 to List.Count - 1 do
          begin
            Items.AddObject(List.Configurations[i].Name, TObject(List.Configurations[i]));
          end;

          //if Items.Count > 0 then
          Items.Add('Configuration Manager...');
        finally
          Items.EndUpdate;
        end;
        ItemIndex := List.ActiveIndex;
      end;
    end;
  end;
end;

procedure TConfigurationManager.BeforeCompile(Sender: TObject; const Project: IOTAProject; IsCodeInsight: Boolean; var Cancel: Boolean);
var
  i: Integer;
begin
  if not IsCodeInsight then
  begin
    //TOpenToolsServices.MessageServices.AddTitleMessage('Checking project' + Project.FileName + 'dependencies');

    for i := 0 to Length(DIRECTORY_OPTIONS) - 1 do
      if Project.ProjectOptions.Values[DIRECTORY_OPTIONS[i]] <> '' then
        ForceDirectories(ExpandFileName(Project.ProjectOptions.Values[DIRECTORY_OPTIONS[i]]));

    Cancel := not Configurations[Project].Active.Build;

  end;
end;

{ TConfiguration }

constructor TConfiguration.Create(Owner: IConfigurationList; Name: string);
begin
  inherited Create;
  FOwner := Owner;
  FName := Name;
  FBuild := true;
end;

function TConfiguration.GetBuild: Boolean;
begin
  Result := FBuild;
end;

function TConfiguration.GetName: string;
begin
  Result := FName;
end;

function TConfiguration.GetOwner: IConfigurationList;
begin
  Result := FOwner;
end;

procedure TConfiguration.SetBuild(Value: Boolean);
begin
  FBuild := Value;
end;

procedure TConfiguration.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
  end;
end;

function IsValidFilename(s: string): Boolean;
const
  NOT_ALLOWED_CHARS = [#0..#31, '<', '>', ':', '"', '/', '\', '|'];
  NOT_ALLOWED_NAMES: array[0..22] of PChar = (
    'CON',
    'PRN',
    'AUX',
    'CLOCK$',
    'NUL',
    'COM1',
    'COM2',
    'COM3',
    'COM4',
    'COM5',
    'COM6',
    'COM7',
    'COM8',
    'COM9',
    'LPT1',
    'LPT2',
    'LPT3',
    'LPT4',
    'LPT5',
    'LPT6',
    'LPT7',
    'LPT8',
    'LPT9'
    );
var
  i: Integer;
begin
  Result := false;

  if s = '' then
    exit;

  for i := 1 to Length(s) do
  begin
    if s[i] in NOT_ALLOWED_CHARS then
      exit;
  end;

  for i := 0 to Length(NOT_ALLOWED_NAMES) - 1 do
  begin
    if SameFileName(s, NOT_ALLOWED_NAMES[i]) then
      exit;
  end;

  Result := true;
end;

{ TConfigurationList }

function TConfigurationList.Add(Name: string; CopyFrom: IConfiguration; CreateAdditional: Boolean; Activate: Boolean; CheckDuplicate: Boolean):
  IConfiguration;
var
  i, Index: Integer;
begin
  Result := nil;
  Name := Trim(Name);

  Index := -1;

  if not IsValidFilename(Name) then
    raise Exception.Create(rsConfigurationNameIsNotValid);

  for i := 0 to Count - 1 do
  begin
    if SameFileName(Configurations[i].Name, Name) then
    begin
      if CheckDuplicate then
        raise Exception.Create(rsConfigurationNameAllreadyInUse);

      Index := i;
    end;
  end;

  if Index = -1 then
  begin
    Result := CreateConfiguration(Name);
    Index := FList.Add(Result);
  end;

  if Assigned(CopyFrom) then
    CopyFrom.Copy(Result);

  if Activate then
    ActiveIndex := Index
  else
    Changed;
end;

procedure TConfigurationList.AfterSave;
begin
  Serialize;
  inherited;
end;

constructor TConfigurationList.Create(Owner: TConfigurationManager; Module: IOTAModule);
begin
  inherited Create(Module);
  FActiveIndex := -1;
  FOwner := Owner;
  FList := TInterfaceList.Create;
end;

procedure TConfigurationList.Disconnect;
begin
  if Assigned(FOwner) then
    FOwner.RemoveConfiguration(Self);
  FOwner := nil;
  Clear;
  inherited;
end;

function TConfigurationList.GetActive: IConfiguration;
begin
  if FActiveIndex = -1 then
    Result := nil
  else
    Result := FList[FActiveIndex] as IConfiguration;
end;

function TConfigurationList.GetActiveIndex: Integer;
begin
  Result := FActiveIndex;
end;

function TConfigurationList.GetCount: Integer;
begin
  Result := FList.Count
end;

function TConfigurationList.GetConfigurations(Index: Integer): IConfiguration;
begin
  Result := FList[Index] as IConfiguration;
end;

function TConfigurationList.GetNames(Name: string): IConfiguration;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if CompareText(Configurations[i].Name, Name) = 0 then
    begin
      Result := Configurations[i];
      break;
    end;
end;

procedure TConfigurationList.Deserialize;
var
  IniFile: TIniFile;
  i, c: Integer;
  s: string;
  ActiveConfig: IConfiguration;
begin
  FDeserializing := true;
  try
    if ActiveIndex > -1 then
      Active.StoreState;

    Clear;

    IniFile := TIniFile.Create(FileName);
    try
      c := IniFile.ReadInteger('Configurations', 'Count', 0);
      for i := 0 to c - 1 do
      begin
        s := IniFile.ReadString('Configurations', inttostr(i), '');
        if s <> '' then
          Add(s, nil, false, false, true).Deserialize(IniFile);
      end;

      s := IniFile.ReadString('Configurations', 'Active', '');
      ActiveConfig := Names[s];
      if ActiveConfig <> nil then
        Active := ActiveConfig
      else
        if Count > 0 then
          ActiveIndex := 0;
    finally
      IniFile.Free;
    end;
  finally
    FDeserializing := false;
  end;
end;

procedure TConfigurationList.Serialize;
var
  IniFile: TIniFile;
  i: Integer;
begin
  if ActiveIndex > -1 then
    Active.StoreState;

  IniFile := TIniFile.Create(FileName);
  try
    IniFile.EraseSection('Configurations');
    IniFile.WriteInteger('Configurations', 'Count', Count);
    for i := 0 to Count - 1 do
    begin
      IniFile.WriteString('Configurations', inttostr(i), Configurations[i].Name);
      Configurations[i].Serialize(IniFile);
    end;
    if ActiveIndex > -1 then
      IniFile.WriteString('Configurations', 'Active', Active.Name);
  finally
    IniFile.Free;
  end;
end;

procedure TConfigurationList.SetActive(Value: IConfiguration);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if (Configurations[i] as IConfiguration) = (Value as IConfiguration) then
    begin
      ActiveIndex := i;
      break;
    end;
end;

procedure TConfigurationList.SetActiveIndex(Value: Integer);
begin
  if FActiveIndex <> Value then
  begin
    if FActiveIndex > -1 then
      Configurations[FActiveIndex].StoreState;

    FActiveIndex := Value;

    if FActiveIndex > -1 then
      Configurations[FActiveIndex].RestoreState;

    if not FDeserializing then
    begin
      Module.MarkModified;
      with TConfigurationManager.ConfigurationManager do
        if ProjectGroupConfigurations <> nil then
        begin
          ProjectGroupConfigurations.Module.MarkModified;
        end;
    end;
    Changed;
  end;
end;

procedure TConfigurationList.Changed;
begin
  if Assigned(FOwner) then
    FOwner.DoConfigurationsChanged(Self);
end;

procedure TConfigurationList.Clear;
begin
  FList.Clear;
  Changed;
end;

procedure TConfigurationList.AfterConstruction;
begin
  inherited;
  Changed;
end;

{ TProjectConfiguration }

procedure TProjectConfiguration.AssignOptions(AOptions: IOTAOptions);
var
  i: Integer;
  OptionNames: TOTAOptionNameArray;
  kv: Integer;
begin
  SetLength(OptionNames, 0);
  if Assigned(AOptions) then
  begin
    OptionNames := AOptions.GetOptionNames;

    SetLength(FOptions, Length(OptionNames));

    for i := 0 to Length(FOptions) - 1 do
    begin
      FOptions[i].Name := OptionNames[i].Name;
      FOptions[i].Kind := OptionNames[i].Kind;
      if OptionNames[i].Kind = tkClass then
      begin
        if not Assigned(FOptions[i].KeyValue) then
          FOptions[i].KeyValue := TStringList.Create;
        kv := AOptions.Values[FOptions[i].Name];
        FOptions[i].KeyValue.Assign(TStrings(kv));
      end
      else
      begin
        FOptions[i].Value := AOptions.Values[FOptions[i].Name];
      end;
    end;
  end;
end;

procedure TProjectConfiguration.AssignOptionsTo(AOptions: IOTAOptions);
var
  i: Integer;
  j: Integer;
  kv: Integer;
begin
  if Assigned(AOptions) then
  begin
    for i := 0 to Length(FOptions) - 1 do
    begin
      if FOptions[i].Kind = tkClass then
      begin
        if Assigned(FOptions[i].KeyValue) then
        begin
          kv := AOptions.Values[FOptions[i].Name];

          for j := 0 to FOptions[i].KeyValue.Count - 1 do
          begin
            if TStrings(kv).Values[FOptions[i].KeyValue.Names[j]] <> FOptions[i].KeyValue.ValueFromIndex[j] then
            begin
              AOptions.Values[FOptions[i].Name] := Integer(FOptions[i].KeyValue);
              break;
            end;
          end;
        end;
      end
      else
      begin
        if AOptions.Values[FOptions[i].Name] <> FOptions[i].Value then
          AOptions.Values[FOptions[i].Name] := FOptions[i].Value;
      end;
    end;
  end;
end;

procedure TProjectConfiguration.Copy(Dest: IConfiguration);
begin
  if Supports(Dest, IOTAOptions) then
  begin
    AssignOptionsTo(Dest as IOTAOptions);
  end;
end;

constructor TProjectConfiguration.Create(Owner: IConfigurationList; Name: string);
var
  i: Integer;
begin
  inherited;

  AssignOptions(Project.ProjectOptions);

  for i := 0 to Length(DIRECTORY_OPTIONS) - 1 do
    Values[DIRECTORY_OPTIONS[i]] := Name;
end;

procedure TProjectConfiguration.Deserialize(IniFile: TIniFile);
var
  i: Integer;
  SList: TStringList;
  Key, Sub: string;
  kv: Integer;
begin
  SList := TStringList.Create;
  try
    IniFile.ReadSectionValues(Name, SList);

    for i := 0 to SList.Count - 1 do
    begin
      Key := SList.Names[i];
      if Pos('.', Key) > 0 then
      begin
        Sub := System.Copy(Key, Pos('.', Key) + 1, Length(Key));
        Key := System.Copy(Key, 1, Pos('.', Key) - 1);
        kv := Options.Values[Key];
        TStrings(kv).Values[Sub] := SList.ValueFromIndex[i];
      end
      else
        Options.Values[Key] := SList.ValueFromIndex[i];
    end;
  finally
    SList.Free;
  end;
end;

destructor TProjectConfiguration.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(FOptions) - 1 do
    if Assigned(FOptions[i].KeyValue) then
      FOptions[i].KeyValue.Free;

  inherited;
end;

procedure TProjectConfiguration.EditOptions;
begin

end;

function TProjectConfiguration.GetOptionNames: TOTAOptionNameArray;
var
  i: Integer;
begin
  SetLength(Result, Length(FOptions));

  for i := 0 to Length(Result) - 1 do
  begin
    Result[i].Name := FOptions[i].Name;
    Result[i].Kind := FOptions[i].Kind;
  end;
end;

function TProjectConfiguration.GetOptions: IOTAOptions;
begin
  Result := Self;
end;

function TProjectConfiguration.GetOptionValue(const ValueName: string): Variant;
var
  i: Integer;
begin
  Result := Null;
  for i := 0 to Length(FOptions) - 1 do
  begin
    if ValueName = FOptions[i].Name then
    begin
      if FOptions[i].Kind = tkClass then
      begin
        if not Assigned(FOptions[i].KeyValue) then
          FOptions[i].KeyValue := TStringList.Create;

        Result := Integer(FOptions[i].KeyValue)
      end
      else
        Result := FOptions[i].Value;
      break;
    end;
  end;
end;

function TProjectConfiguration.GetProject: IOTAProject;
begin
  Result := Owner.Module as IOTAProject;
end;

procedure TProjectConfiguration.RestoreState;
begin
  AssignOptionsTo(Project.ProjectOptions);
end;

procedure TProjectConfiguration.Serialize(IniFile: TIniFile);
var
  i, j: Integer;
begin
  IniFile.EraseSection(Name);
  for i := 0 to Length(FOptions) - 1 do
  begin
    if FOptions[i].Kind = tkClass then
    begin
      if Assigned(FOptions[i].KeyValue) then
      begin
        for j := 0 to FOptions[i].KeyValue.Count - 1 do
        begin
          IniFile.WriteString(Name, FOptions[i].Name + '.' + FOptions[i].KeyValue.Names[j], FOptions[i].KeyValue.ValueFromIndex[j]);
        end;
      end;
    end
    else
      IniFile.WriteString(Name, FOptions[i].Name, FOptions[i].Value);
  end;
end;

procedure TProjectConfiguration.SetOptions(Value: IOTAOptions);
begin
  AssignOptions(Value);
end;

procedure TProjectConfiguration.SetOptionValue(const ValueName: string; const Value: Variant);
var
  i: Integer;
begin
  for i := 0 to Length(FOptions) - 1 do
  begin
    if ValueName = FOptions[i].Name then
    begin
      FOptions[i].Value := VarAsType(Value, VarType(FOptions[i].Value));
      break;
    end;
  end;
end;

procedure TProjectConfiguration.StoreState;
begin
  AssignOptions(Project.ProjectOptions);
end;

{ TProjectConfigurationList }

function TProjectConfigurationList.Add(Name: string; CopyFrom: IConfiguration; CreateAdditional, Activate: Boolean; CheckDuplicate: Boolean):
  IConfiguration;
begin
  if CreateAdditional or FDeserializing then
  begin
    with TConfigurationManager.ConfigurationManager do
    begin
      if ProjectGroupConfigurations <> nil then
        if CopyFrom = nil then
          ProjectGroupConfigurations.Add(Name, nil, false, true, false)
        else
          ProjectGroupConfigurations.Add(Name, Names[CopyFrom.Name], false, true, false)
    end;
  end;
  Result := inherited Add(Name, CopyFrom, CreateAdditional, Activate, CheckDuplicate);
end;

function TProjectConfigurationList.CreateConfiguration(Name: string): IConfiguration;
begin
  Result := TProjectConfiguration.Create(Self, Name);
end;

function TProjectConfigurationList.GetFilename: string;
begin
  Result := ChangeFileExt(Module.FileName, CONFIG_PROJECT_FILE_EXTENSION)
end;

function TProjectConfigurationList.GetProject: IOTAProject;
begin
  Result := Module as IOTAProject;
end;

{ TProjectGroupConfigurationList }

function TProjectGroupConfigurationList.Add(Name: string; CopyFrom: IConfiguration; CreateAdditional, Activate: Boolean; CheckDuplicate: Boolean):
  IConfiguration;
var
  i: Integer;
begin
  Result := inherited Add(Name, CopyFrom, CreateAdditional, Activate, CheckDuplicate);
  if CreateAdditional then
  begin
    for i := 0 to ProjectGroup.ProjectCount - 1 do
    begin
      with TConfigurationManager.ConfigurationManager.Configurations[ProjectGroup.Projects[i]] do
      begin
        if CopyFrom = nil then
          Add(Name, nil, false, true, false)
        else
          Add(Name, Names[CopyFrom.Name], false, true, false);
      end;
    end;
  end;
end;

function TProjectGroupConfigurationList.CreateConfiguration(Name: string): IConfiguration;
begin
  Result := TProjectGroupConfiguration.Create(Self, Name);
end;

function TProjectGroupConfigurationList.GetActive_: IProjectGroupConfiguration;
begin
  Result := inherited Active as IProjectGroupConfiguration;
end;

function TProjectGroupConfigurationList.GetFilename: string;
begin
  Result := ChangeFileExt(Module.FileName, CONFIG_PROJECT_GROUP_FILE_EXTENSION)
end;

function TProjectGroupConfigurationList.GetProjectGroup: IOTAProjectGroup;
begin
  Result := Module as IOTAProjectGroup;
end;

procedure TProjectGroupConfigurationList.SetActive_(Value: IProjectGroupConfiguration);
begin
  inherited Active := Value;
end;

{ TProjectGroupConfiguration }

procedure TProjectGroupConfiguration.Copy(Dest: IConfiguration);
var
  DestGroup: IProjectGroupConfiguration;
begin
  if Supports(Dest, IProjectGroupConfiguration, DestGroup) then
  begin
    DestGroup.States.Assign(States);
  end;
end;

constructor TProjectGroupConfiguration.Create(Owner: IConfigurationList; Name: string);
begin
  inherited;
  FStates := TStringList.Create;
end;

procedure TProjectGroupConfiguration.Deserialize(IniFile: TIniFile);

begin
  States.Clear;
  IniFile.ReadSectionValues(Name, States);
end;

destructor TProjectGroupConfiguration.Destroy;
begin
  FStates.Free;
  inherited;
end;

function TProjectGroupConfiguration.ExtractProjectName(Name: string): string;
begin
  Result := ExtractRelativePath(Owner.Module.FileName, Name);
end;

function TProjectGroupConfiguration.GetStates: TStringList;
begin
  Result := FStates;
end;

procedure TProjectGroupConfiguration.RestoreState;
var
  i: Integer;
  b: Boolean;
  n, n1: string;
  P: Integer;
begin
  for i := 0 to TConfigurationManager.ConfigurationManager.Count - 1 do
  begin
    if Supports(TConfigurationManager.ConfigurationManager.Items[i].Module, IOTAProject) then
    begin
      b := true;

      n := States.Values[ExtractProjectName(TConfigurationManager.ConfigurationManager.Items[i].Module.FileName)];

      P := Pos(',', n);
      if P <> 0 then
      begin
        n1 := System.Copy(n, P + 1, Length(n));
        Delete(n, P, Length(n));
        if n1 <> '' then
          b := StrToInt(n1) <> 0;
      end;

      TConfigurationManager.ConfigurationManager.Items[i].Active := TConfigurationManager.ConfigurationManager.Items[i].Names[n];
      if TConfigurationManager.ConfigurationManager.Items[i].Active <> nil then
        TConfigurationManager.ConfigurationManager.Items[i].Active.Build := b;
    end;
  end;
end;

procedure TProjectGroupConfiguration.Serialize(IniFile: TIniFile);
var
  i: Integer;
begin
  for i := 0 to States.Count - 1 do
  begin
    IniFile.WriteString(Name, States.Names[i], States.ValueFromIndex[i]);
  end;
end;

procedure TProjectGroupConfiguration.StoreState;
var
  i: Integer;
begin
  FStates.Clear;

  for i := 0 to TConfigurationManager.ConfigurationManager.Count - 1 do
  begin
    if Supports(TConfigurationManager.ConfigurationManager.Items[i], IProjectConfigurationList) then
      with TConfigurationManager.ConfigurationManager.Items[i] do
        if Active <> nil then
        begin
          States.Values[ExtractProjectName(TConfigurationManager.ConfigurationManager.Items[i].Module.FileName)] :=
            Active.Name + ',' + inttostr(Integer(Active.Build));
        end;
  end;
end;

end.

