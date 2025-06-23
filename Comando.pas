unit Comando;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  Tfrmcomando = class(TForm)
    EdtComando: TEdit;
    BtnExecutar: TButton;
    btnLSUSB: TButton;
    memoResultado: tmemo;
    btnUSBDevi: TButton;
    btnplacamae: TButton;
    btnProcessador: TButton;
    btnKill: TButton;
    btnfixada: TButton;
    Comando: TLabel;
    btnLimpar: TButton;
    btnSalvar: TButton;
    //Synresultado: TSynEdit;
    procedure FormShow(Sender: TObject);
    procedure BtnExecutarClick(Sender: TObject);
    procedure btnLSUSBClick(Sender: TObject);
    procedure btnKillClick(Sender: TObject);
    procedure btnUSBDeviClick(Sender: TObject);
    procedure btnplacamaeClick(Sender: TObject);
    procedure btnProcessadorClick(Sender: TObject);
    procedure btnfixadaClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure memoResultadoKeyPress(Sender: TObject; var Key: Char);
    procedure btnSalvarClick(Sender: TObject);

  private
    procedure ExecutarComando(const Comando: string);
  public
    procedure AdicionarPrompt;

  end;

var
  frmcomando: Tfrmcomando;

implementation

{$R *.dfm}

uses Valida;

procedure Tfrmcomando.AdicionarPrompt;
begin
  memoResultado.Lines.Add('usuario@ubuntu:~$ ');
  // Posiciona cursor após o prompt
  memoResultado.SelStart := Length(memoResultado.Text);
end;
procedure Tfrmcomando.BtnExecutarClick(Sender: TObject);
begin
  if Trim(EdtComando.Text) = '' then
  begin
    ShowMessage('Digite um comando para executar.');
    Exit;
  end;

  ExecutarComando(EdtComando.Text);
end;

procedure Tfrmcomando.btnLimparClick(Sender: TObject);
begin
  memoResultado.Lines.Clear;
end;

procedure Tfrmcomando.btnLSUSBClick(Sender: TObject);
begin
  memoResultado.Lines.Clear;
  ExecutarComando('lsusb');
end;

procedure Tfrmcomando.btnplacamaeClick(Sender: TObject);
begin
  memoResultado.Lines.Clear;
  ExecutarComando('cat /sys/devices/virtual/dmi/id/board_{vendor,name,version}');
end;

procedure Tfrmcomando.btnUSBDeviClick(Sender: TObject);
begin
  memoResultado.Lines.Clear;
  ExecutarComando('usb-devices');
end;

procedure Tfrmcomando.btnfixadaClick(Sender: TObject);
begin
  memoResultado.Lines.Clear;
  ExecutarComando('ls -ln /dev/ttyS* && ls -l /dev/serial/by-id');
end;

procedure Tfrmcomando.btnProcessadorClick(Sender: TObject);
begin
  memoResultado.Lines.Clear;
  ExecutarComando('cat /proc/cpuinfo');
end;

procedure Tfrmcomando.btnSalvarClick(Sender: TObject);
begin
memoResultado.Lines.SaveToFile('Relatorio_Hardware.txt');

end;

procedure Tfrmcomando.btnKillClick(Sender: TObject);
begin
  memoResultado.Lines.Clear;
  ExecutarComando('killall AcruxPDV');
  memoResultado.Lines.Add('killall AcruxPDV');
end;

procedure Tfrmcomando.ExecutarComando(const Comando: string);
var
  AppPath, Args: string;
  OutputList: TStringList;
begin
  AppPath := ExtractFilePath(ParamStr(0)) + 'plink.exe';
  Args := Format('-ssh -batch %s@%s -pw %s %s', [
    FrmValida.EdtUsuario.Text,
    FrmValida.EdtIP.Text,
    FrmValida.EdtSenha.Text,
    Comando
  ]);

  memoResultado.Lines.Add('---');

  OutputList := TStringList.Create;
  try
    FrmValida.RunPlinkCommand(AppPath, Args, OutputList);
    OutputList.Text := StringReplace(OutputList.Text, #10, sLineBreak, [rfReplaceAll]);
    memoResultado.Lines.AddStrings(OutputList);
  finally
    OutputList.Free;
  end;
end;

procedure Tfrmcomando.FormCreate(Sender: TObject);
begin
memoResultado.Font.Name := 'DejaVu Sans Mono'; // Fonte terminal (ou Courier New)
memoResultado.Font.Size := 11;
memoResultado.Font.Color := clWhite;          // Texto branco
memoResultado.Color := clBlack;               // Fundo preto
memoResultado.ScrollBars := ssVertical;       // Barra de rolagem
memoResultado.ReadOnly := true;              // Permite entrada do usuário
end;

procedure Tfrmcomando.FormShow(Sender: TObject);
begin
  memoResultado.Lines.Clear;
  ExecutarComando('uname -a');
end;



procedure Tfrmcomando.memoResultadoKeyPress(Sender: TObject; var Key: Char);
begin
key := #0;
end;

end.

