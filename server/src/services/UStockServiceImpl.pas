unit UStockServiceImpl;

interface

uses
    XData.Server.Module
  , XData.Service.Common

  , UStockService.Types
  , UStockService
  , UChartJs
  , UChartJsDataItem

  , System.JSON
  ;

type
  [ServiceImplementation]
  TStockService = class(TInterfacedObject, IStockService)
    function Years: TDTOYears;
    function Symbols: TDTOSymbols;
    function Historical( Symbol: String ): TDTOHistorical;
    function LineChart(
      Symbol: String;
      [XDefault(0)] Year: Integer = 0): TChartJs<TPoint2D<string,double>>;
  end;

implementation

uses
  UStockServiceController
  ;

{ TStockService }

function TStockService.Historical(Symbol: String): TDTOHistorical;
begin
  var LStockServiceController := TStockServiceController.Create;
  try
    Result := LStockServiceController.Historical(Symbol);
  finally
    LStockServiceController.Free;
  end;
end;

function TStockService.LineChart(Symbol: String; [XDefault(0)] Year: Integer =
    0): TChartJs<TPoint2D<string,double>>;
begin
  var LStockServiceController := TStockServiceController.Create;
  try
    Result := LStockServiceController.LineChart(Symbol, Year);
  finally
    LStockServiceController.Free;
  end;

end;

function TStockService.Symbols: TDTOSymbols;
begin
  var LStockServiceController := TStockServiceController.Create;
  try
    Result := LStockServiceController.Symbols;
  finally
    LStockServiceController.Free;
  end;
end;

function TStockService.Years: TDTOYears;
begin
  var LStockServiceController := TStockServiceController.Create;
  try
    Result := LStockServiceController.Years;
  finally
    LStockServiceController.Free;
  end;
end;

initialization
  RegisterServiceType(TStockService);

end.
