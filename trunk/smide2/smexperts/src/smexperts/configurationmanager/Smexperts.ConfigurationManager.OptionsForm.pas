unit Smexperts.ConfigurationManager.OptionsForm;

interface

uses
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
  ToolsApi,
  Smexperts.System,
  Smexperts.ConfigurationManager,
  ComCtrls,
  ExtCtrls;

type
  TOptionsForm = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  OptionsForm: TOptionsForm;

implementation

uses
  TypInfo;

{$R *.dfm}

procedure TOptionsForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  if TOpenToolsServices.GetActiveProjectGroup <> nil then
  begin
    for i := 0 to Length(TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.GetOptionNames) - 1 do
    begin
      with ListView1.Items.Add do
      begin
        Caption := TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.GetOptionNames[i].Name;
        SubItems.Add(TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.Values[
          TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.GetOptionNames[i].Name]);
        SubItems.Add(GetEnumName(TypeInfo(TTypeKind),
          Integer(TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.GetOptionNames[i].Kind)));

        SubItems.Add(IntToStr(VarType(TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.Values[
          TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.GetOptionNames[i].Name])));
      end;
    end;
  end;
end;

procedure TOptionsForm.Button1Click(Sender: TObject);
begin
  TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.Values['TestTest']:='34';
  ShowMessage(TOpenToolsServices.GetActiveProjectGroup.ActiveProject.ProjectOptions.Values['TestTest']);
end;

end.

