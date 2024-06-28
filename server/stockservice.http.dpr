program stockservice.http;

uses
  Vcl.Forms,
  UFrmMain in 'src\UFrmMain.pas' {MainForm},
  UServerContainer in 'src\UServerContainer.pas' {ServerContainer: TDataModule},
  UStockService in 'src\services\UStockService.pas',
  UStockServiceImpl in 'src\services\UStockServiceImpl.pas',
  UStockService.Types in 'src\services\UStockService.Types.pas',
  UDatabaseManager in 'src\UDatabaseManager.pas' {DatabaseManager: TDataModule},
  UStockServiceController in 'src\services\UStockServiceController.pas',
  UChartJs in 'src\ChartJs\UChartJs.pas',
  UChartJsDataItem in 'src\ChartJs\UChartJsDataItem.pas',
  UChartJsDataset in 'src\ChartJs\UChartJsDataset.pas',
  UChartJsManager in 'src\ChartJs\UChartJsManager.pas',
  UChartJsOptions in 'src\ChartJs\UChartJsOptions.pas',
  UChartJsTypes in 'src\ChartJs\UChartJsTypes.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
