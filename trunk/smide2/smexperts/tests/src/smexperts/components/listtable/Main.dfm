object Form1: TForm1
  Left = 213
  Top = 126
  Width = 600
  Height = 389
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListTable1: TListTable
    Left = 88
    Top = 112
    Width = 377
    Height = 211
    Columns = <
      item
      end
      item
      end
      item
      end
      item
      end>
    GridLines = True
    Items.Data = {
      6A0000000200000000000000FFFFFFFFFFFFFFFF030000000000000004546573
      740548616C6C6F034E65750566616C736500000000FFFFFFFFFFFFFFFF030000
      00000000000554657374310648616C6C6F310648616C6C6F320474727565FFFF
      FFFFFFFFFFFFFFFFFFFF}
    ItemHeight = 18
    TabOrder = 0
    OnGetColumnType = ListTable1GetColumnType
    OnGetColumnListItems = ListTable1GetColumnListItems
    OnListItemChanged = ListTable1ListItemChanged
  end
  object UpDown1: TUpDown
    Left = 528
    Top = 88
    Width = 33
    Height = 33
    Min = 16
    Position = 16
    TabOrder = 1
    OnChanging = UpDown1Changing
  end
  object Button1: TButton
    Left = 88
    Top = 58
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
  end
  object ComboBox2: TComboBox
    Left = 280
    Top = 70
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'ComboBox2'
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 592
    Height = 29
    ButtonHeight = 21
    Caption = 'ToolBar1'
    TabOrder = 4
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = 'ToolButton1'
      ImageIndex = 0
    end
  end
end
