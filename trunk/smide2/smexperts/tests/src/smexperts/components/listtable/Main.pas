unit Main;

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
  ComCtrls,
  Smexperts.Components.ListTable,
  ImgList,
  StdCtrls,
  ToolWin,
  StdActns;

type
  TForm1 = class(TForm)
    ListTable1: TListTable;
    UpDown1: TUpDown;
    Button1: TButton;
    ComboBox2: TComboBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    procedure ListTable1GetColumnType(Sender: TObject; Column: TListColumn;
      var ColumnType: TColumnType);
    procedure ListTable1GetColumnListItems(Sender: TObject;
      Item: TListItem; Column: TListColumn; Items: TStrings);
    procedure ListTable1ListItemChanged(Sender: TObject; Item: TListItem;
      Column: TListColumn; Text: string);
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ListTable1GetColumnType(Sender: TObject;
  Column: TListColumn; var ColumnType: TColumnType);
begin
  if Column.Index > 0 then
    ColumnType := ctText;

  if Column.Index > 1 then
    ColumnType := ctList;
  if Column.Index > 2 then
    ColumnType := ctCheck;
end;

procedure TForm1.ListTable1GetColumnListItems(Sender: TObject;
  Item: TListItem; Column: TListColumn; Items: TStrings);
begin
  Items.Add('Erster');
  Items.Add('Zweiter');
  Items.Add('Dritter');
  Items.Add('Vierter');

  while Items.Count < 500 do
    Items.Add('test' + inttostr(Items.Count))
end;

procedure TForm1.ListTable1ListItemChanged(Sender: TObject; Item: TListItem; Column: TListColumn; Text: string);
begin
  ShowMessage(Item.Caption + ' ' + Column.Caption + ' ' + Text);
end;

procedure TForm1.UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  ListTable1.ItemHeight := UpDown1.Position;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  with TComboBox.Create(Self) do
  begin
    parent := ToolBar1;
  end;
  with TToolButton.Create(Self) do
    parent := ToolBar1;
end;

end.

