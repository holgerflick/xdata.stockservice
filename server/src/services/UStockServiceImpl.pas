unit UStockServiceImpl;

interface

uses
    XData.Server.Module
  , XData.Service.Common

  , UStockService.Types
  , UStockService

  , System.JSON
  ;

type
  [ServiceImplementation]
  TStockService = class(TInterfacedObject, IStockService)
    function Years: TDTOYears;
    function Symbols: TDTOSymbols;
    function Historical( Symbol: String ): TDTOHistorical;
    function LineChart( Symbol: String;  Year: Integer  = 0): TJSONObject;
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

function TStockService.LineChart(Symbol: String; Year: Integer): TJSONObject;
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
