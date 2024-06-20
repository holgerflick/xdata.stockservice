program StocksChartWeb;

uses
  Vcl.Forms,
  WEBLib.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain: TWebForm} {*.html};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
