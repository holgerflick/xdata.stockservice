unit UStockServiceController;

interface

uses
    UStockService.Types

  , System.JSON
  , System.SysUtils
  ;

type
  TStockServiceController = class
  public
    function Years: TDTOYears;
    function Symbols: TDTOSymbols;
    function Historical( ASymbol: String ): TDTOHistorical;
    function LineChart( ASymbol: String; AYear: Integer ): TJSONObject;
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

(*
{
    type: 'bar',
    data: {
      labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
      datasets: [{
        label: '# of Votes',
        data: [12, 19, 3, 5, 2, 3],
        borderWidth: 1
      }]
    },
    options: {
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  }
*)

function TStockServiceController.LineChart(ASymbol: String; AYear: Integer): TJSONObject;

begin
  Result := TJSONObject.Create;

  try
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
      //

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

      var LValues := TJSONArray.Create;

      while not LQuery.eof DO
      begin
        var LValue := TJSONObject.Create;
        LValue.AddPair('x', LQuery.FieldByName('date').AsString );
        LValue.AddPair('y', LQuery.FieldByName('close').AsFloat );

        LValues.Add(LValue);

        LQuery.Next;
      end;

      var LData := TJSONObject.Create;
      var LDataSets := TJSONArray.Create;
      var LDataSet := TJSONObject.Create;
      LDataSet.AddPair('label', ASymbol);
      LDataSet.AddPair('data', LValues );
      LDataSet.AddPair('borderWidth', 3 );
      LDataSet.AddPair('pointStyle', false );
      LDataSet.AddPair('cubicInterpolationMode', 'default');
      LDataSet.AddPair('tension', 0.2 );

      LDataSets.Add(LDataSet);
      LData.AddPair('datasets', LDataSets );


      var LScalesY :=  TJSONObject.Create(
            TJSONPair.Create( 'y',
              TJSONObject.Create(
                TJSONPair.Create( 'beginAtZero', true )
              )
            )
          );


      var LScales := TJSONObject.Create(
        TJSONPair.Create( 'scales', LScalesY )
        );


      Result.AddPair('type', 'line');
      Result.AddPair('data', LData );
      Result.AddPair( 'options', LScales );


    finally
      TDatabaseManager.Instance.ReleaseQuery(LQuery);
    end;
  except
    Result.Free;
    raise;
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
