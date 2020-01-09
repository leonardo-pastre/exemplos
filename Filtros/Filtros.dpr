program Filtros;

uses
  Vcl.Forms,
  UFrmFiltroPadrao in 'UFrmFiltroPadrao.pas' {FrmFiltroPadrao},
  UFiltro in 'UFiltro.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmFiltroPadrao, FrmFiltroPadrao);
  Application.Run;
end.
