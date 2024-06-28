unit UStockServiceController;

interface

uses
    UStockService.Types

  , System.JSON
  , System.SysUtils

  , UChartJs
  , UChartJsTypes
  , UChartJsDataset
  , UChartJsDataItem

  , XData.Server.Module

  , FireDAC.Stan.Param
  ;

type
  TStockServiceController = class
  public
    function Years: TDTOYears;
    function Symbols: TDTOSymbols;
    function Historical( ASymbol: String ): TDTOHistorical;
    function LineChart( ASymbol: String; AYear: Integer ): TChartJs<TDailyStockValue>;
  end;

implementation

uses
    XData.Sys.Exceptions

  , System.Generics.Collections

  , UDatabaseManager
  ;

{ TStockServiceController }

function TStockServiceController.Historical(ASymbol: String): TDTOHistorical;
begin
  Result := TDTOHistorical.Create;
  try
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
  except
    Result.Free;
  end;

end;

function TStockServiceController.LineChart(ASymbol: String; AYear: Integer): TChartJs<TDailyStockValue>;
begin
  Result := TChartJs<TDailyStockValue>.Create;
  Result.Options.AddTimeAxis('x', 'month', 'MMM YYY' );
  Result.Options.BeginAxisAtZero('y');

  TXDataOperationContext.Current.Handler.ManagedObjects.Add(Result);

  var LQuery := TDatabaseManager.Instance.GetQuery;
  try
    LQuery.SQL.Text :=
    '''
      SELECT date, close
        FROM stocks
        WHERE (symbol = :symbol)
    ''';

    if AYear > 0 then
    begin
      LQuery.SQL.Add( '   AND (strftime(''%Y'', date) = :year)' );
    end;

    LQuery.SQL.Add( '  ORDER BY julianday(date) ' );

    LQuery.ParamByName('symbol').AsString := ASymbol;

    if Assigned( LQuery.Params.FindParam( 'year' ) ) then
    begin
      LQuery.ParamByName('year').AsString := AYear.ToString;
    end;

    LQuery.Open;

    if LQuery.eof then
    begin
      raise EXDataHttpException.Create(404, 'Symbol not found.' );
    end;

    var LDataSet := TChartJsDataset<TDailyStockValue>.Create;
    LDataSet.DataLabel := ASymbol;
    LDataSet.PointRadius := 0;
    LDataSet.BorderWidth := 2;
    LDataSet.CubicInterpolationMode := 'default';
    LDataSet.Tension := 0.2;

//  -- Alternative: filling everything up to 50
//    var LFill := TJSONObject.Create(
//        TJSONPair.Create( 'value', 50 )
//      );

    var LFill := TJSONString.Create('origin');
    LDataSet.Fill := LFill;

    while not LQuery.eof DO
    begin
      var LDate := LQuery.FieldByName('date').AsString;
      var LClose := LQuery.FieldByName('close').AsFloat;

      var LPoint := TDailyStockValue.Create( LDate, LClose );

      LDataSet.Add( LPoint );

      LQuery.Next;
    end;

    Result.AddDataSet(LDataSet);
  finally
    TDatabaseManager.Instance.ReleaseQuery(LQuery);
  end;

end;

function TStockServiceController.Symbols: TDTOSymbols;
begin
  Result := TDTOSymbols.Create;

  try

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
  except
    Result.Free;
    raise;
  end;
end;

function TStockServiceController.Years: TDTOYears;
begin
  Result := TDTOYears.Create;

  try
    var LQuery := TDatabaseManager.Instance.GetQuery;
    try
      LQuery.SQL.Text :=
      '''
        SELECT DISTINCT (strftime('%Y', date)) year
          FROM stocks
          ORDER BY year DESC
      ''';

      LQuery.Open;
      if LQuery.Eof then
      begin
        raise EXDataHttpException.Create(404, 'No data found.');
      end;

      while not LQuery.eof do
      begin
        Result.Add( LQuery.FieldByName('year').AsInteger );

        LQuery.Next;
      end;
    finally
      TDatabaseManager.Instance.ReleaseQuery(LQuery);
    end;
  except
    Result.Free;
    raise;
  end;
end;

end.
