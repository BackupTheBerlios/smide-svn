unit Smexperts.ConfigurationManager.NewConfiguration;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TNewConfigurationForm = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    Label1: TLabel;
    ConfigurationNameEdit: TEdit;
    Label2: TLabel;
    AlsoCreateConfigurationCheckBox: TCheckBox;
    Bevel1: TBevel;
    ComboBox1: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewConfigurationForm: TNewConfigurationForm;

implementation

{$R *.dfm}

end.
