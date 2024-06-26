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
  public
    property Responsive: NullableBoolean read FResponsive write FResponsive;
  end;


implementation

end.
