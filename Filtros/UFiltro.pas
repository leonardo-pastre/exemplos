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
    procedure AddCriterio(Metodo: string; Ordem: Integer; Valor: Variant);
    property Criterios: TCriterios read fCriterios;
  end;

  TParametros = array of Variant;

  TFiltro = class
  private
    fTemporario: TStringList;
    fListaCriterios: TListaCriterios;
    function GetParametros(Criterio: TCriterio): TParametros;
    function ToString(Dado: Variant): string;
  published
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
    procedure SetCriterio(Metodo: string; Ordem: Integer; Valor: Variant); overload;
    property ListaCriterios: TListaCriterios read fListaCriterios;
  end;

implementation

uses
  System.SysUtils, System.Rtti, System.StrUtils;

{ TFiltro }

function TFiltro.BuildSQL: string;
var
  I: Integer;
  lMetodo: TMethod;
  lExecute: TExecute;
  lParametros: TParametros;
begin
  for I := 0 to Length(fListaCriterios.Criterios) -1 do
  begin
    lMetodo.Data := Pointer(Self);
    lMetodo.Code := Self.MethodAddress(fListaCriterios.Criterios[I].Metodo);

    if Assigned(lMetodo.Code) then
    begin
      lParametros := GetParametros(fListaCriterios.Criterios[I]);
      lExecute := TExecute(lMetodo);
      lExecute(lParametros);
    end;
  end;

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
  fTemporario.Add('Ativo: ' + ToString(Dado[0]));
end;

procedure TFiltro.CriterioCPFCNPJ(Dado: TParametros);
begin
  fTemporario.Add('CPF/CNPJ: ' + ToString(Dado[0]));
end;

procedure TFiltro.CriterioDataCadastro(Dado: TParametros);
begin
  fTemporario.Add(Format('Data Cadastro: ', [ToString(Dado[0]), ToString(Dado[1])]));
end;

procedure TFiltro.CriterioEstado(Dado: TParametros);
begin
  fTemporario.Add('Estado: ' + ToString(Dado[0]));
end;

procedure TFiltro.CriterioIdade(Dado: TParametros);
begin
  fTemporario.Add(Format('Idade: %s até %s', [ToString(Dado[0]), ToString(Dado[1])]));
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

procedure TFiltro.SetCriterio(Metodo: string; Ordem: Integer; Valor: Variant);
begin
  fListaCriterios.AddCriterio(Metodo, Valor, Ordem);
end;

function TFiltro.ToString(Dado: Variant): string;
begin
  case TVarData(Dado).VType of
    varSmallInt,
    varInteger   : Result := IntToStr(Dado);
    varSingle,
    varDouble,
    varCurrency  : Result := FloatToStr(Dado);
    varDate      : Result := FormatDateTime('dd/mm/yyyy', Dado);
    varBoolean   : IfThen(Dado,'1','0');
    varString    : Result := Dado;
  else
    Result := '';
  end;
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

procedure TListaCriterios.AddCriterio(Metodo: string; Ordem: Integer; Valor: Variant);
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
