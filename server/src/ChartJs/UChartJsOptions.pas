unit UChartJsOptions;

interface
uses
    System.SysUtils
  , System.JSON
  , System.Generics.Collections

  , Bcl.Json.Attributes
  , Bcl.Json.Converters
  , Bcl.Json.NamingStrategies
  , Bcl.Types.Nullable

  , UChartJsTypes
  ;

type

  [JsonManaged]
  [JsonInclude(TInclusionMode.NonDefault)]
  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
  TChartJsOptions = class
  private
    FResponsive: NullableBoolean;
    FScales: TJSONObject;

    function GetAxisObject( AAxisId: String ): TJSONObject;
  public
    procedure AddTimeAxis(
      AAxisId: String;
      ATimeUnit: String = '';
      ADisplayFormatString: String = ''
      );

    procedure BeginAxisAtZero( AAxisId: String );
    procedure ToggleGrid( AAxisId: String; AIsVisible: Boolean );

    procedure SetDashedGridLine( AAxisId: String );

    property Responsive: NullableBoolean read FResponsive write FResponsive;

    property Scales: TJSONObject read FScales write FScales;
  end;


implementation

{ TChartJsOptions }

procedure TChartJsOptions.AddTimeAxis(AAxisId, ATimeUnit,
  ADisplayFormatString: String);
begin
  if AAxisId.IsEmpty then
  begin
    raise EArgumentException.Create('Axis Id cannot be empty.');
  end;

  // find existing axis definition and remove it
  if Assigned(Scales) then
  begin
    Scales.RemovePair(AAxisId);
  end
  else
  begin
    Scales := TJSONObject.Create;
  end;

  var LTime := TJSONObject.Create;
  if not ATimeUnit.IsEmpty then
  begin
    LTime.AddPair('unit', ATimeUnit);
  end;

  if not ADisplayFormatString.IsEmpty then
  begin
    var LDisplayFormats := TJSONObject.Create;
    LDisplayFormats.AddPair( ATimeUnit, ADisplayFormatString );
    LTime.AddPair( 'displayFormats', LDisplayFormats );
  end;

  var LTimeAxis := TJSONObject.Create;
  LTimeAxis.AddPair('type', 'time');
  LTimeAxis.AddPair('time', LTime );

  Scales.AddPair( AAxisId, LTimeAxis );
end;

procedure TChartJsOptions.BeginAxisAtZero(AAxisId: String);
var
  LAxis: TJSONObject;

begin
  if not Assigned( Scales ) then
  begin
    Scales := TJSONObject.Create;
  end;

  // check if axis exists
  LAxis := GetAxisObject( AAxisId );

  LAxis.AddPair( 'beginAtZero', true );
end;

function TChartJsOptions.GetAxisObject(AAxisId: String): TJSONObject;
begin
  if not Scales.TryGetValue<TJSONObject>(AAxisId, Result ) then
  begin
    Result := TJSONObject.Create;
    Scales.AddPair( AAxisId, Result );
  end;
end;

procedure TChartJsOptions.SetDashedGridLine(AAxisId: String);
var
  LGrid: TJSONObject;

begin
  ToggleGrid(AAxisId, True);

  var LAxis := GetAxisObject( AAxisId );
  if not LAxis.TryGetValue<TJSONObject>('grid', LGrid) then
  begin
    LGrid := TJSONObject.Create;
    LAxis.AddPair('grid', LGrid);
  end;

  var LBorderDash := TJSONArray.Create;
  LBorderDash.Add( 5 );
  LBorderDash.Add( 5 );

  var LBorder := TJSONObject.Create;
  LBorder.AddPair( 'dash', LBorderDash );
  LBorder.AddPair( 'color', 'red' );

  LGrid.AddPair( 'border', LBorder );
end;

procedure TChartJsOptions.ToggleGrid(AAxisId: String; AIsVisible: Boolean);
var
  LGrid: TJSONObject;

begin
  var LAxis := GetAxisObject( AAxisId );
  if not LAxis.TryGetValue<TJSONObject>('grid', LGrid) then
  begin
    LGrid := TJSONObject.Create;
    LAxis.AddPair('grid', LGrid);
  end;

  LGrid.AddPair('display', AIsVisible);
end;

end.
