object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 346
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 62
    Width = 125
    Height = 25
    Caption = 'Login OAuth'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 146
    Top = 62
    Width = 125
    Height = 25
    Caption = 'Login Cookie'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 263
    Height = 21
    TabOrder = 2
    Text = ''
  end
  object Edit2: TEdit
    Left = 8
    Top = 35
    Width = 263
    Height = 21
    PasswordChar = '#'
    TabOrder = 3
    Text = ''
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 327
    Width = 274
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Memo1: TMemo
    Left = 8
    Top = 120
    Width = 263
    Height = 169
    TabOrder = 5
  end
  object Button3: TButton
    Left = 196
    Top = 295
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Edit3: TEdit
    Left = 8
    Top = 96
    Width = 182
    Height = 21
    TabOrder = 7
    Text = ''
  end
  object Edit4: TEdit
    Left = 8
    Top = 295
    Width = 182
    Height = 21
    TabOrder = 8
    Text = 'Edit4'
  end
end
