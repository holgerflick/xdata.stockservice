unit UStockServiceController;

interface

uses
    UStockService.Types

  , System.JSON
  ;

type
  TStockServiceController = class
  public
    function Symbols: TDTOSymbols;
    function Historical( ASymbol: String ): TDTOHistorical;
    function LineChart( ASymbol: String ): TJSONObject;
  end;

implementation

uses
    XData.Sys.Exceptions

  , UDatabaseManager
  ;

{ TStockServiceController }

function TStockServiceController.Historical(ASymbol: String): TDTOHistorical;
begin
  Result := TDTOHistorical.Create;

  var LQuery := TDatabaseManager.Instance.GetQuery;
  try
    LQuery.SQL.Text := 'SELECT * FROM stocks WHERE symbol = :symbol';
    LQuery.ParamByName('symbol').AsString := ASymbol;
    LQuery.Open;

    if LQuery.Eof then
    begin
      raise EXDataHttpException.Create(404, 'No historical data found.');
    end;

    while not LQuery.eof do
    begin
      var LDay := TDTOHistoricalDay.Create(LQuery);

      Result.Add(LDay);

      LQuery.Next;
    end;
  finally
    TDatabaseManager.Instance.ReleaseQuery(LQuery);
  end;

end;

function TStockServiceController.Symbols: TDTOSymbols;
begin
  Result := TDTOSymbols.Create;

  var LQuery := TDatabaseManager.Instance.GetQuery;
  try
    LQuery.SQL.Text := 'SELECT DISTINCT symbol FROM stocks ORDER BY symbol';
    LQuery.Open;
    if LQuery.Eof then
    begin
      raise EXDataHttpException.Create(404, 'No symbols found.');
    end;

    while not LQuery.eof do
    begin
      var LSymbol := TDTOSymbol.Create;
      LSymbol.Name := LQuery.FieldByName('symbol').AsString;

      Result.Add(LSymbol);

      LQuery.Next;
    end;
  finally
    TDatabaseManager.Instance.ReleaseQuery(LQuery);
  end;
end;

end.
