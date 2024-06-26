unit UChartJs;

interface

uses
    System.SysUtils
  , System.JSON
  , System.Generics.Collections

  , Bcl.Json.Attributes
  , Bcl.Json.Converters
  , Bcl.Json.NamingStrategies

  , UChartJsTypes
  , UChartJsDataset
  , UChartJsDataItem
  , UChartJsOptions
  ;


type
  [JsonManaged]
  [JsonNamingStrategy(TCamelCaseNamingStrategy)]
  TChartJs<T: TChartDataItem> = class
  private

    [JsonIgnore]
    FType: TChartJsType;

    [JsonProperty('type')]
    FChartType: String;

    [JsonProperty('data')]
    FDataSets: TChartJsDatasets<T>;

    FOptions: TChartJsOptions;

  public
    constructor Create;
    destructor Destroy; override;

    procedure SetType( AType: TChartJsType );

    procedure AddDataSet( ADataSet: TChartJsDataset<T> );

    property Options: TChartJsOptions read FOptions write FOptions;
  end;


implementation

procedure TChartJs<T>.AddDataSet(ADataSet: TChartJsDataset<T>);
begin
  FDataSets.Add( ADataSet );
end;

{ TChartJs }


constructor TChartJs<T>.Create;
begin
  inherited Create;

  SetType( ctLine );

  FDataSets := TChartJsDataSets<T>.Create;
  FOptions := TChartJsOptions.Create;
end;

destructor TChartJs<T>.Destroy;
begin
  FOptions.Free;
  FDataSets.Free;

  inherited;
end;


procedure TChartJs<T>.SetType(AType: TChartJsType);
begin
  FType := AType;
  FChartType := TChartJsHelper.TypeToString(AType);
end;


end.
