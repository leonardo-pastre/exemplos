unit UFrmFiltroPadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, UFiltro;

type
  TFrmFiltroPadrao = class(TForm)
    Label1: TLabel;
    BtnFiltrar: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    {Filtros}
    [TRttiFiltro('CriterioCPFCNPJ',0)]
    EdtCPFCNPJ: TEdit;
    [TRttiFiltro('CriterioDataCadastro',0)]
    DtpDataCadInicial: TDateTimePicker;
    [TRttiFiltro('CriterioDataCadastro',1)]
    DtpDataCadFinal: TDateTimePicker;
    [TRttiFiltro('CriterioIdade',0)]
    EdtIdadeInicial: TEdit;
    [TRttiFiltro('CriterioIdade',1)]
    EdtIdadeFinal: TEdit;
    [TRttiFiltro('CriterioClienteAtivo',0)]
    CbxClienteAtivo: TCheckBox;
    [TRttiFiltro('',0)]
    CbbEstado: TComboBox;
    procedure BtnFiltrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    fFiltro: TFiltro;
  public
    { Public declarations }
  end;

var
  FrmFiltroPadrao: TFrmFiltroPadrao;

implementation

uses
  System.Rtti;

{$R *.dfm}

procedure TFrmFiltroPadrao.BtnFiltrarClick(Sender: TObject);
var
  lContexto: TRttiContext;
  lTipo: TRttiType;
  lAtributo: TCustomAttribute;
  lCampo: TRttiField;
begin
  lContexto := TRttiContext.Create;

  try
    lTipo := lContexto.GetType(Self.ClassInfo);

    for lCampo in lTipo.GetFields do
    begin
      for lAtributo in lCampo.GetAttributes do
      begin
        if (lAtributo is TRttiFiltro) then
        begin
          // Verificar uma forma de pegar o valor do campo
          fFiltro.SetCriterio((lAtributo as TRttiFiltro).NomeFiltro, (lAtributo as TRttiFiltro).Ordem, (lAtributo as TRttiFiltro).Ordem);
        end;
      end;
    end;

    ShowMessage(fFiltro.BuildSQL);
  finally
    lContexto.Free;
  end;
end;

procedure TFrmFiltroPadrao.FormCreate(Sender: TObject);
begin
  fFiltro := TFiltro.Create;
end;

procedure TFrmFiltroPadrao.FormDestroy(Sender: TObject);
begin
  fFiltro.Free;
end;

end.
