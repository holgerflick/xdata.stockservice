unit UChartJsManager;

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
  ;


type
  TChartJs<T: TChartDataItem> = class
  private

    [JsonIgnore]
    FType: TChartJsType;

    [JsonProperty('type')]
    FChartType: String;

    [JsonProperty('datasets')]
    FDataSets: TChartJsDatasets<T>;

  public
    constructor Create;
    destructor Destroy; override;

    procedure SetType( AType: TChartJsType );
  end;


implementation

{ TChartJs }


constructor TChartJs<T>.Create;
begin
  inherited Create;

  FType := ctLine;

  FDataSets := TChartJsDataSets<T>.Create;
end;

destructor TChartJs<T>.Destroy;
begin
  FDataSets.Free;

  inherited;
end;


procedure TChartJs<T>.SetType(AType: TChartJsType);
begin
  FType := AType;

  FChartType := TChartJsHelper.TypeToString(AType);
end;


end.
