unit UChartJsDataItem;

interface

uses
    System.Generics.Collections
  , Bcl.Json.Attributes
  , Bcl.Json.Converters
  , Bcl.Json.NamingStrategies
  ;

type
  [JsonManaged]
  TChartDataItem = class
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TChartDataItems = TObjectList<TChartDataItem>;

  [JsonManaged]
  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
  TValue<T> = class(TChartDataItem)
  private
    [JsonProperty('y')]
    FValue: T;

  public
    property Value: T read FValue write FValue;
  end;

  [JsonManaged]
  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
  TPoint2D<T, U> = class(TChartDataItem)
  private
    [JsonProperty('x')]
    FX: T;

    [JsonProperty('y')]
    FY: U;
  public
    constructor Create( X: T; Y: U );

    property X: T read FX write FX;
    property Y: U read FY write FY;
  end;

implementation

{ TPoint2D<T, U> }

constructor TPoint2D<T, U>.Create(X: T; Y: U);
begin
  inherited Create;

  self.X := X;
  self.Y := Y;
end;

{ TChartDataItem }

constructor TChartDataItem.Create;
begin
  inherited;
end;

destructor TChartDataItem.Destroy;
begin

  inherited;
end;

end.
