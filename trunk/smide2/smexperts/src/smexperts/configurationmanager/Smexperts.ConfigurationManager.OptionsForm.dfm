object OptionsForm: TOptionsForm
  Left = 330
  Top = 199
  Width = 595
  Height = 475
  Caption = 'OptionsForm'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 587
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object Edit1: TEdit
      Left = 320
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Button1: TButton
      Left = 446
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 41
    Width = 587
    Height = 407
    Align = alClient
    Columns = <
      item
      end
      item
      end
      item
      end
      item
      end>
    TabOrder = 1
    ViewStyle = vsReport
  end
end
