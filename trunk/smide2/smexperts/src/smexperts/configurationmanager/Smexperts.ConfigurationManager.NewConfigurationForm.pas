unit Smexperts.ConfigurationManager.NewConfigurationForm;

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
  ExtCtrls,
  Smexperts.ConfigurationManager;

type
  TNewConfigurationForm = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    Label1: TLabel;
    ConfigurationNameEdit: TEdit;
    Label2: TLabel;
    AlsoCreateConfigurationCheckBox: TCheckBox;
    Bevel1: TBevel;
    CopyFromComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  protected
    FConfigurationList: IConfigurationList;
    procedure InitCopyFrom; virtual;
    function CreateNewConfiguration: Boolean; virtual;
    { Private declarations }
  public
    { Public declarations }
    class procedure Show(ConfigurationList: IConfigurationList);

    property ConfigurationList: IConfigurationList read FConfigurationList;

    constructor Create(AOwner: TComponent; ConfigurationList: IConfigurationList); reintroduce;
  end;

var
  NewConfigurationForm: TNewConfigurationForm;

implementation

{$R *.dfm}

const
  DEFAULT_ITEM = '<Default>';

  { TNewConfigurationForm }

constructor TNewConfigurationForm.Create(AOwner: TComponent; ConfigurationList: IConfigurationList);
begin
  FConfigurationList := ConfigurationList;
  inherited Create(AOwner);
end;

class procedure TNewConfigurationForm.Show(ConfigurationList: IConfigurationList);
var
  Frm: TNewConfigurationForm;
begin
  Frm := TNewConfigurationForm(NewInstance);
  Frm.Create(Application, ConfigurationList);
  try
    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TNewConfigurationForm.FormCreate(Sender: TObject);
begin
  InitCopyFrom;
end;

procedure TNewConfigurationForm.InitCopyFrom;
var
  i: Integer;
begin
  CopyFromComboBox.Items.Clear;
  CopyFromComboBox.ItemIndex := CopyFromComboBox.Items.Add(DEFAULT_ITEM);

  for i := 0 to ConfigurationList.Count - 1 do
    CopyFromComboBox.Items.AddObject(ConfigurationList.Configurations[i].Name, TObject(ConfigurationList.Configurations[i]));
end;

function TNewConfigurationForm.CreateNewConfiguration: Boolean;
var
  Configuration: IConfiguration;
begin
  Result := false;
  try
    Configuration := ConfigurationList.Add(ConfigurationNameEdit.Text,
      IConfiguration(Pointer(CopyFromComboBox.Items.Objects[CopyFromComboBox.ItemIndex])), AlsoCreateConfigurationCheckBox.Checked, true, true);

    Result := Configuration <> nil;
  except
    on e: Exception do
      Application.ShowException(e);
  end;
end;

procedure TNewConfigurationForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    CanClose := CreateNewConfiguration;
  end;
end;

end.

