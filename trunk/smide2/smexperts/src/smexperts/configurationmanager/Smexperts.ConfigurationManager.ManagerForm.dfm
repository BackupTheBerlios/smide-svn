object ManagerForm: TManagerForm
  Left = 290
  Top = 240
  BorderStyle = bsDialog
  Caption = 'Configuration Manager'
  ClientHeight = 259
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 14
    Width = 166
    Height = 13
    Caption = '&Active Project Group Configuration:'
    FocusControl = ProjectGroupConfigurationComboBox
  end
  object Label2: TLabel
    Left = 6
    Top = 60
    Width = 75
    Height = 13
    Caption = '&Project Context:'
  end
  object CloseButton: TButton
    Left = 348
    Top = 228
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 0
  end
  object ProjectGroupConfigurationComboBox: TComboBox
    Left = 6
    Top = 30
    Width = 245
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = ProjectGroupConfigurationComboBoxChange
  end
  object CurrentOptionsButton: TButton
    Left = 6
    Top = 228
    Width = 89
    Height = 25
    Caption = 'Current Options'
    TabOrder = 2
    OnClick = CurrentOptionsButtonClick
  end
  object ListTable: TListTable
    Left = 6
    Top = 76
    Width = 410
    Height = 141
    Columns = <
      item
        Caption = 'Project'
        Width = 150
      end
      item
        Caption = 'Configuration'
        Tag = 1
        Width = 100
      end
      item
        Caption = 'Plattform'
        Tag = 2
        Width = 100
      end
      item
        Caption = 'Build'
        Tag = 3
      end>
    ColumnClick = False
    GridLines = True
    TabOrder = 3
    OnGetColumnType = ListTableGetColumnType
    OnGetColumnListItems = ListTableGetColumnListItems
    OnListItemChanged = ListTableListItemChanged
  end
end
