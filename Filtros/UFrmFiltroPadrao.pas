unit UFrmFiltroPadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TFrmFiltroPadrao = class(TForm)
    CbbEstado: TComboBox;
    EdtCPFCNPJ: TEdit;
    CbxClienteAtivo: TCheckBox;
    EdtIdadeInicial: TEdit;
    EdtIdadeFinal: TEdit;
    Label1: TLabel;
    BtnFiltrar: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DtpDataCadInicial: TDateTimePicker;
    DtpDataCadFinal: TDateTimePicker;
    Label5: TLabel;
    Label6: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmFiltroPadrao: TFrmFiltroPadrao;

implementation

{$R *.dfm}

end.
