unit UChartJsDataset;

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
  , UChartJsDataItem
  ;

type
  [JsonManaged]
  [JsonInclude(TInclusionMode.NonDefault)]
  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
  TChartJsDataset<T: TChartDataItem> = class
  private
    [JsonProperty('data')]
    FPoints: TObjectList<T>;

    FLabel: String;
    FOrder: NullableInteger;
    FStack: NullableString;

    FPointRadius: NullableInteger;
    FPointStyle: NullableString;
    FBorderWidth: NullableInteger;
    FCubicInterpolationMode: NullableString;
    FTension: Double;
    FStepped: NullableBoolean;
    FFill: TJSONValue;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Add( APoint: T );

    property DataLabel: String read FLabel write FLabel;
    property Order: NullableInteger read FOrder write FOrder;
    property Stack: NullableString read FStack write FStack;
    property PointStyle: NullableString read FPointStyle write FPointStyle;
    property PointRadius: NullableInteger read FPointRadius write FPointRadius;

    property BorderWidth: NullableInteger read FBorderWidth write FBorderWidth;
    property CubicInterpolationMode: NullableString read FCubicInterpolationMode write FCubicInterpolationMode;
    property Fill: TJSONValue read FFill write FFill;
    property Stepped: NullableBoolean read FStepped write FStepped;
    property Tension: Double read FTension write FTension;
  end;

  [JsonManaged]
  TChartJsDatasets<T: TChartDataItem> = class
  private
    [JsonProperty('datasets')]
    FDataSets: TObjectList<TChartJsDataset<T>>;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Add( ADataSet: TChartJsDataset<T> );
  end;

implementation

{ TChartJsDatasets<T> }

procedure TChartJsDatasets<T>.Add(ADataSet: TChartJsDataset<T>);
begin
  FDataSets.Add( ADataSet );
end;

constructor TChartJsDatasets<T>.Create;
begin
  inherited Create;

  FDataSets := TObjectList<TChartJsDataSet<T>>.Create;
end;

destructor TChartJsDatasets<T>.Destroy;
begin
  FDataSets.Free;

  inherited;
end;


{ TChartJsDataset<T> }

procedure TChartJsDataset<T>.Add(APoint: T);
begin
  FPoints.Add(APoint);
end;

constructor TChartJsDataset<T>.Create;
begin
  inherited;

  FPoints := TObjectList<T>.Create;
  FLabel := '';
  FOrder := SNull;
  FStack := SNull;
  FPointRadius := SNull;
  FPointStyle := SNull;
end;

destructor TChartJsDataset<T>.Destroy;
begin
  FPoints.Free;

  inherited;
end;


end.
