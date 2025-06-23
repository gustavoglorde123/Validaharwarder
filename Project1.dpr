program Project1;

uses
  Vcl.Forms,
  Valida in 'Valida.pas' {FrmValida},
  Comando in 'Comando.pas' {frmcomando};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmValida, FrmValida);
  Application.CreateForm(Tfrmcomando, frmcomando);
  Application.Run;
end.
