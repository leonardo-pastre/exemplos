object FrmFiltroPadrao: TFrmFiltroPadrao
  Left = 0
  Top = 0
  Caption = 'Filtro Padr'#227'o'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 168
    Top = 96
    Width = 16
    Height = 13
    Caption = 'at'#233
  end
  object Label2: TLabel
    Left = 32
    Top = 39
    Width = 48
    Height = 13
    Caption = 'CPF/CNPJ'
  end
  object Label3: TLabel
    Left = 32
    Top = 146
    Width = 33
    Height = 13
    Caption = 'Estado'
  end
  object Label4: TLabel
    Left = 32
    Top = 96
    Width = 28
    Height = 13
    Caption = 'Idade'
  end
  object Label5: TLabel
    Left = 217
    Top = 68
    Width = 6
    Height = 13
    Caption = 'a'
  end
  object Label6: TLabel
    Left = 32
    Top = 68
    Width = 49
    Height = 13
    Caption = 'Data Cad.'
  end
  object CbbEstado: TComboBox
    Left = 88
    Top = 138
    Width = 145
    Height = 21
    ItemIndex = 0
    TabOrder = 6
    Text = 'SP'
    Items.Strings = (
      'SP'
      'RJ')
  end
  object EdtCPFCNPJ: TEdit
    Left = 88
    Top = 31
    Width = 145
    Height = 21
    TabOrder = 0
    Text = '123456789'
  end
  object CbxClienteAtivo: TCheckBox
    Left = 88
    Top = 113
    Width = 97
    Height = 17
    Caption = 'Cliente Ativo'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object EdtIdadeInicial: TEdit
    Left = 88
    Top = 88
    Width = 73
    Height = 21
    TabOrder = 3
    Text = '10'
  end
  object EdtIdadeFinal: TEdit
    Left = 191
    Top = 88
    Width = 73
    Height = 21
    TabOrder = 4
    Text = '30'
  end
  object BtnFiltrar: TButton
    Left = 88
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Filtrar'
    TabOrder = 7
    OnClick = BtnFiltrarClick
  end
  object DtpDataCadInicial: TDateTimePicker
    Left = 88
    Top = 60
    Width = 121
    Height = 21
    Date = 43839.337470243050000000
    Time = 43839.337470243050000000
    TabOrder = 1
  end
  object DtpDataCadFinal: TDateTimePicker
    Left = 232
    Top = 60
    Width = 121
    Height = 21
    Date = 43870.337470243050000000
    Time = 43870.337470243050000000
    TabOrder = 2
  end
end
