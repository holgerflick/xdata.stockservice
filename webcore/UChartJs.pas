unit UChartJs;

interface

uses
    Web
  , JS
  ;

type
  TChartJs = class
  private
    FChart: TJSObject;
    FElementId: String;

    procedure DestroyChart;

  public
    constructor Create( AElementId: String );
    destructor Destroy; override;

    procedure Render( AData: TJSObject );
  end;

implementation

{ TChartJs }

uses
   System.SysUtils
  ;
constructor TChartJs.Create(AElementId: String);
begin
  inherited Create;

  if AElementId.IsEmpty then
  begin
    raise EArgumentException.Create( 'Element needs to be specified.');
  end;

  FElementId := AElementId;
end;

destructor TChartJs.Destroy;
begin
  inherited;
end;

procedure TChartJs.DestroyChart;
begin
  if Assigned( FChart ) then
  begin
    asm
      this.FChart.destroy();
    end;
  end;
end;

procedure TChartJs.Render(AData: TJSObject);
begin
  DestroyChart;

  asm
    const ctx = document.getElementById( this.FElementId );
    this.FChart = new Chart( ctx, AData );
  end;
end;

end.
