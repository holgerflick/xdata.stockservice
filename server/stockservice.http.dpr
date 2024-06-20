program stockservice.http;

uses
  Vcl.Forms,
  UFrmMain in 'src\UFrmMain.pas' {MainForm},
  UServerContainer in 'src\UServerContainer.pas' {ServerContainer: TDataModule},
  UStockService in 'src\services\UStockService.pas',
  UStockServiceImpl in 'src\services\UStockServiceImpl.pas',
  UStockService.Types in 'src\services\UStockService.Types.pas',
  UDatabaseManager in 'src\UDatabaseManager.pas' {DatabaseManager: TDataModule},
  UStockServiceController in 'src\services\UStockServiceController.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
