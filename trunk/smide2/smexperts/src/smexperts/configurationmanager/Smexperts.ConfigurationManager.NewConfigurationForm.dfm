object NewConfigurationForm: TNewConfigurationForm
  Left = 395
  Top = 211
  ActiveControl = ConfigurationNameEdit
  BorderStyle = bsDialog
  Caption = 'New Configuration'
  ClientHeight = 174
  ClientWidth = 280
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  DesignSize = (
    280
    174)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 10
    Width = 96
    Height = 13
    Caption = 'Configuration Name:'
  end
  object Label2: TLabel
    Left = 6
    Top = 58
    Width = 91
    Height = 13
    Caption = 'Copy &Settings from:'
    FocusControl = CopyFromComboBox
  end
  object Bevel1: TBevel
    Left = 6
    Top = 134
    Width = 267
    Height = 11
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object OkButton: TButton
    Left = 115
    Top = 143
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 199
    Top = 143
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ConfigurationNameEdit: TEdit
    Left = 6
    Top = 28
    Width = 266
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object AlsoCreateConfigurationCheckBox: TCheckBox
    Left = 6
    Top = 104
    Width = 266
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Also create new configuration(s)'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object CopyFromComboBox: TComboBox
    Left = 6
    Top = 76
    Width = 266
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
end
