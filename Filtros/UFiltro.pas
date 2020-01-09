unit UFiltro;

interface

uses
  System.Classes;

type
  TRttiFiltro = class(TCustomAttribute)
  private
    fNomeFiltro: string;
    fOrdem: Integer;
  public
    constructor Create(NomeFiltro: string; Ordem: Integer);
    property NomeFiltro: string read fNomeFiltro;
    property Ordem: Integer read fOrdem;
  end;

  TValor = record
    Valor: Variant;
    Ordem: Integer;
  end;

  TExecute = procedure(Params: array of Variant) of object;
  TDados = array of TValor;

  TCriterio = class
  private
    fMetodo: string;
    fDados: TDados;
  public
    constructor Create(Metodo: string);
    procedure AddDado(Valor: Variant; Ordem: Integer);
    property Metodo: string read fMetodo;
    property Dados: TDados read fDados;
  end;

  TCriterios = array of TCriterio;

  TListaCriterios = class
  private
    fCriterios: TCriterios;
  public
    procedure AddCriterio(Metodo: string; Valor: Variant; Ordem: Integer);
    property Criterios: TCriterios read fCriterios;
  end;

  TParametros = array of Variant;

  TFiltro = class
  private
    fTemporario: TStringList;
    fListaCriterios: TListaCriterios;
    function GetParametros(Criterio: TCriterio): TParametros;
    // Metodos para montagem da consulta, incluíndo filtros específicos
    procedure CriterioCPFCNPJ(Dado: TParametros);
    procedure CriterioDataCadastro(Dado: TParametros);
    procedure CriterioIdade(Dado: TParametros);
    procedure CriterioClienteAtivo(Dado: TParametros);
    procedure CriterioEstado(Dado: TParametros);
  public
    constructor Create;
    destructor Destroy; override;
    function BuildSQL: string;
    procedure SetCriterio(Filtro: TFiltro); overload;
    procedure SetCriterio(Metodo: string; Valor: Variant; Ordem: Integer); overload;
    property ListaCriterios: TListaCriterios read fListaCriterios;
  end;

implementation

uses
  System.SysUtils, System.Rtti;

{ TFiltro }

function TFiltro.BuildSQL: string;
var


  RttiContext: TRttiContext;
  RttiInstanceType: TRttiInstanceType;
  RttiMethod: TRttiMethod;
  Instance: TValue;



  lContexto: TRttiContext;
  lTipo: TRttiType;
  lMetodo: TRttiMethod;

  I, J: Integer;
  //lMetodo: TMethod;
  //lExecute: TExecute;
  lNomeMetodo: string;
  lParametros: TParametros;
  lValor: TValue;
begin






  RttiContext := TRttiContext.Create;

  // Encontra o tipo
  //RttiInstanceType := RttiContext.FindType('UFiltro.TFiltro').AsInstance;
  RttiInstanceType := RttiContext.GetType(Self.ClassInfo).AsInstance;

  // Encontra o constructor (pelo nome "Create")
  RttiMethod := RttiInstanceType.GetMethod('Create');

  // Invoca o construtor, atribundo a instância à variável "Instance"
  Instance := RttiMethod.Invoke(RttiInstanceType.MetaclassType,[]);

  // Encontra o método "AbrirNotepad"
  RttiMethod := RttiInstanceType.GetMethod('CriterioCPFCNPJ');

  // Invoca o método
  if Assigned(RttiMethod) then
    RttiMethod.Invoke(Instance, ['123456789']);



  {
  lContexto := TRttiContext.Create;

  try
    lTipo := lContexto.GetType(Self.ClassType);

    for I := 0 to Length(fListaCriterios.Criterios) -1 do
    begin
      lNomeMetodo := fListaCriterios.Criterios[I].Metodo;
      lParametros := GetParametros(fListaCriterios.Criterios[I]);

      for J := 0 to Length(lParametros) -1 do
      begin
        lValor.FromVariant(lParametros[J]);
      end;

      lMetodo := lTipo.GetMethod(lNomeMetodo);

      if Assigned(lMetodo) then
      begin
        lMetodo.Invoke(Self, lValor);
      end;
    end;
  finally
    lContexto.Free;
  end;
  }
  (*
  for I := 0 to Length(fListaCriterios.Criterios) -1 do
  begin
    lNomeMetodo := fListaCriterios.Criterios[I].Metodo;

    //lMetodo.Data := Pointer(fListaCriterios);
    //lMetodo.Code := fListaCriterios.Criterios[I].MethodAddress(lNomeMetodo);

    lMetodo.Data := Pointer(Self);
    lMetodo.Code := Self.MethodAddress(lNomeMetodo);

    if Assigned(lMetodo.Code) then
    begin
      lExecute := TExecute(lMetodo);
      lParametros := GetParametros(fListaCriterios.Criterios[I]);
      lExecute(lParametros);
    end;
  end;
  *)

  // Retorna o buildSQL
  Result := fTemporario.Text;
end;

constructor TFiltro.Create;
begin
  fListaCriterios := TListaCriterios.Create;
  fTemporario := TStringList.Create;
end;

procedure TFiltro.CriterioClienteAtivo(Dado: TParametros);
begin
  fTemporario.Add('Ativo: ' + Dado[0]);
end;

procedure TFiltro.CriterioCPFCNPJ(Dado: TParametros);
begin
  fTemporario.Add('CPF/CNPJ: ' + Dado[0]);
end;

procedure TFiltro.CriterioDataCadastro(Dado: TParametros);
begin
  fTemporario.Add(Format('Data Cadastro: ', [Dado[0], Dado[1]]));
end;

procedure TFiltro.CriterioEstado(Dado: TParametros);
begin
  fTemporario.Add('Estado: ' + Dado[0]);
end;

procedure TFiltro.CriterioIdade(Dado: TParametros);
begin
  fTemporario.Add(Format('Idade: %d até %d', [Dado[0], Dado[1]]));
end;

destructor TFiltro.Destroy;
begin
  fListaCriterios.Free;
  fTemporario.Free;
  inherited;
end;

function TFiltro.GetParametros(Criterio: TCriterio): TParametros;
var
  I: Integer;
  lParametros: TParametros;
begin
  SetLength(lParametros, Length(Criterio.Dados));

  for I := 0 to Length(Criterio.Dados) -1 do
  begin
    lParametros[Criterio.Dados[I].Ordem] := Criterio.Dados[I].Valor;
  end;

  Result := lParametros;
end;

procedure TFiltro.SetCriterio(Metodo: string; Valor: Variant; Ordem: Integer);
begin
  fListaCriterios.AddCriterio(Metodo, Valor, Ordem);
end;

procedure TFiltro.SetCriterio(Filtro: TFiltro);
var
  I, J: Integer;
  lLista: TListaCriterios;
begin
  lLista := Filtro.ListaCriterios;

  for I := 0 to Length(lLista.Criterios) -1 do
  begin
    for J := 0 to Length(lLista.Criterios[I].Dados) -1 do
    begin
      SetCriterio(lLista.Criterios[I].Metodo, lLista.Criterios[I].Dados[J].Valor, lLista.Criterios[I].Dados[J].Ordem);
    end;
  end;
end;

{ TListaCriterios }

procedure TListaCriterios.AddCriterio(Metodo: string; Valor: Variant; Ordem: Integer);
var
  I: Integer;
  lExiste: Boolean;
  lCriterio: TCriterio;
begin
  lExiste := False;

  for I := 0 to Length(fCriterios) -1 do
  begin
    if fCriterios[I].Metodo = Metodo then
    begin
      fCriterios[I].AddDado(Valor, Ordem);
      lExiste := True;
    end;
  end;

  if not lExiste then
  begin
    lCriterio := TCriterio.Create(Metodo);
    lCriterio.AddDado(Valor, Ordem);

    SetLength(fCriterios, Length(fCriterios) +1);
    fCriterios[Length(fCriterios) -1] := lCriterio;
  end;
end;

{ TCriterio }

procedure TCriterio.AddDado(Valor: Variant; Ordem: Integer);
begin
  SetLength(fDados, Length(fDados) +1);
  fDados[Length(fDados) -1].Valor := Valor;
  fDados[Length(fDados) -1].Ordem := Ordem;
end;

constructor TCriterio.Create(Metodo: string);
begin
  fMetodo := Metodo;
end;

{ TRttiFiltro }

constructor TRttiFiltro.Create(NomeFiltro: string; Ordem: Integer);
begin
  fNomeFiltro := NomeFiltro;
  fOrdem := Ordem;
end;

end.
