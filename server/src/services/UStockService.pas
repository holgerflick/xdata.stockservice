unit UStockService;

interface

uses
    XData.Service.Common

  , UStockService.Types

  , UChartJs
  , UChartJsDataItem

  , System.JSON
  ;

type
  [ServiceContract]
  IStockService = interface(IInvokable)
    ['{05A2B513-CA6E-45D6-8EEF-EA68091AAE0C}']
    [HttpGet] function Symbols: TDTOSymbols;
    [HttpGet] function Years: TDTOYears;
    [HttpGet] function Historical( Symbol: String ): TDTOHistorical;
    [HttpGet] function LineChart( Symbol: String;
      [XDefault(0)] Year: Integer = 0): TChartJs<TDailyStockValue>;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IStockService));

end.
