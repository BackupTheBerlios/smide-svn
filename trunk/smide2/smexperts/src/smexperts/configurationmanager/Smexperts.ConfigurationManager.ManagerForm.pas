unit Smexperts.ConfigurationManager.ManagerForm;

interface

uses
  Smexperts.System,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ComCtrls,
  ImgList,
  Smexperts.Components.ListTable;

type
  TManagerForm = class(TForm)
    CloseButton: TButton;
    Label1: TLabel;
    ProjectGroupConfigurationComboBox: TComboBox;
    Label2: TLabel;
    CurrentOptionsButton: TButton;
    ListTable: TListTable;
    procedure FormCreate(Sender: TObject);
    procedure CurrentOptionsButtonClick(Sender: TObject);
    procedure ListTableGetColumnType(Sender: TObject; Column: TListColumn; var ColumnType: TColumnType);
    procedure ProjectGroupConfigurationComboBoxChange(Sender: TObject);
    procedure ListTableGetColumnListItems(Sender: TObject; Item: TListItem; Column: TListColumn; Items: TStrings);
    procedure ListTableListItemChanged(Sender: TObject; Item: TListItem; Column: TListColumn; Text: string);
  private
    procedure UpdateTable;
    procedure UpdateProjectGroupList;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ManagerForm: TManagerForm;

implementation

uses
  ToolsApi,
  Smexperts.ConfigurationManager,
  Smexperts.ConfigurationManager.OptionsForm,
  Smexperts.ConfigurationManager.NewProjectConfigurationForm,
  Smexperts.ConfigurationManager.NewProjectGroupConfigurationForm,
  CommCtrl;

{$R *.dfm}

const
  column_types: array[0..3] of TColumnType = (ctNone, ctList, ctList, ctCheck);
  NEW_ITEM = '<New>';
  EDIT_ITEM = '<Edit>';
  NONE_ITEM = '<None>';

procedure TManagerForm.FormCreate(Sender: TObject);
begin
  UpdateProjectGroupList;
  UpdateTable;
end;

procedure TManagerForm.UpdateProjectGroupList;
var
  i: Integer;
begin
  with ProjectGroupConfigurationComboBox do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      if Assigned(TConfigurationManager.ConfigurationManager.ProjectGroupConfigurations) then
      begin
        with TConfigurationManager.ConfigurationManager do
          for i := 0 to ProjectGroupConfigurations.Count - 1 do
          begin
            ProjectGroupConfigurationComboBox.Items.AddObject(ProjectGroupConfigurations.Configurations[i].Name,
              TObject(ProjectGroupConfigurations.Configurations[i]))
          end;

        ItemIndex := TConfigurationManager.ConfigurationManager.ProjectGroupConfigurations.ActiveIndex;
        Items.Add(NEW_ITEM);
        Items.Add(EDIT_ITEM);
      end;
    finally
      Items.EndUpdate;
    end;
  end;
end;

procedure TManagerForm.UpdateTable;
var
  i: Integer;
  ConfigList: IConfigurationList;
begin
  ListTable.Items.BeginUpdate;
  try
    ListTable.Items.Clear;
    if TConfigurationManager.ConfigurationManager.ProjectGroupConfigurations <> nil then
    begin
      with TConfigurationManager.ConfigurationManager do
        for i := 0 to ProjectGroupConfigurations.ProjectGroup.ProjectCount - 1 do
        begin
          with ListTable.Items.Add do
          begin
            ConfigList := Configurations[ProjectGroupConfigurations.ProjectGroup.Projects[i]];
            Caption := ExtractFileName(ConfigList.Module.FileName);

            Data := Pointer(ConfigList);

            if ConfigList.ActiveIndex = -1 then
              SubItems.Add(NONE_ITEM)
            else
              SubItems.Add(ConfigList.Active.Name);

            SubItems.Add('Win32');

            if (ConfigList.ActiveIndex <> -1) and ConfigList.Active.Build then
              SubItems.Add('True')
            else
              SubItems.Add('False')
          end;
        end;
    end;
  finally
    ListTable.Items.EndUpdate;
  end;
end;

procedure TManagerForm.CurrentOptionsButtonClick(Sender: TObject);
begin
  with TOptionsForm.Create(Self) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TManagerForm.ListTableGetColumnType(Sender: TObject; Column: TListColumn; var ColumnType: TColumnType);
begin
  ColumnType := column_types[Column.Tag];
end;

procedure TManagerForm.ProjectGroupConfigurationComboBoxChange(Sender: TObject);
begin
  with ProjectGroupConfigurationComboBox do
    if ItemIndex > -1 then
    begin
      if Items[ItemIndex] = NEW_ITEM then
      begin
        TNewProjectGroupConfigurationForm.Show(TConfigurationManager.ConfigurationManager.ProjectGroupConfigurations);
        UpdateProjectGroupList;
      end
      else
        if Items[ItemIndex] = EDIT_ITEM then
        begin
          UpdateProjectGroupList;
        end
        else
          TConfigurationManager.ConfigurationManager.ProjectGroupConfigurations.ActiveIndex := ItemIndex;
      UpdateTable;
    end;
end;

procedure TManagerForm.ListTableGetColumnListItems(Sender: TObject; Item: TListItem; Column: TListColumn; Items: TStrings);
var
  i: Integer;
  ConfigList: IConfigurationList;
begin
  ConfigList := IConfigurationList(Item.Data);
  case Column.Tag of
    1:
      begin
        for i := 0 to ConfigList.Count - 1 do
          Items.Add(ConfigList.Configurations[i].Name);
        Items.Add(NEW_ITEM);
        Items.Add('<Edit>');
      end;
    2:
      begin
        Items.Add('Win32');
      end;
  end;
end;

procedure TManagerForm.ListTableListItemChanged(Sender: TObject; Item: TListItem; Column: TListColumn; Text: string);
var
  ConfigList: IConfigurationList;
begin
  ConfigList := IConfigurationList(Item.Data);
  case Column.Tag of
    1:
      begin
        if Text = NEW_ITEM then
        begin
          TNewProjectConfigurationForm.Show(ConfigList);
          UpdateProjectGroupList;
          UpdateTable;
        end
        else
          if Text = EDIT_ITEM then
          begin
            TNewProjectConfigurationForm.Show(ConfigList);
            UpdateProjectGroupList;
            UpdateTable;
          end
          else
          begin
            ConfigList.Active := ConfigList.Names[Text];
          end
      end;
    3:
      begin
        ConfigList.Active.Build := CompareText(Text, 'true') = 0;
      end;

  end;
end;

end.

