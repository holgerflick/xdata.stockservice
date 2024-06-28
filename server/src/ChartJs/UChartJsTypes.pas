unit UChartJsTypes;

interface

uses
      System.JSON
    , System.Generics.Collections

    , Bcl.Json.Attributes
    , Bcl.Json.Converters
    , Bcl.Json.NamingStrategies

    ;

type
  TChartJsType =
    (
      ctBar,
      ctBubble,
      ctDoughnut,
      ctLine,
      ctPolarArea,
      ctRadar,
      ctScatter
    );


  TChartJsHelper = class
  public
    class function TypeToString( AType: TChartJsType ): String;

  end;

implementation

{ TChartJsHelper }

class function TChartJsHelper.TypeToString(AType: TChartJsType): String;
begin
  case AType of
    ctBar: Result := 'bar';
    ctBubble: Result := 'bubble';
    ctDoughnut: Result := 'doughnut';
    ctLine: Result := 'line';
    ctPolarArea: Result := 'polarArea';
    ctRadar: Result := 'radar';
    ctScatter: Result := 'scatter'
  end;
end;



end.
