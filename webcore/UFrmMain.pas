unit UFrmMain;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, WEBLib.Menus, WEBLib.StdCtrls, XData.Web.Client,
  XData.Web.Connection, Vcl.Controls, Vcl.StdCtrls;

type
  TFrmMain = class(TWebForm)
    Connection: TXDataWebConnection;
    Client: TXDataWebClient;
    BtnShowChart: TWebButton;
    procedure ConnectionConnect(Sender: TObject);
    procedure BtnShowChartClick(Sender: TObject);
    procedure WebFormDOMContentLoaded(Sender: TObject);
  private
    { Private declarations }
    FChart: TObject;

    FSelectSymbol,
    FSelectYears: TJSHTMLSelectElement;

    procedure Connect;

    [async]
    procedure ShowChart;

    [async]
    procedure InitInterface;


  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

const
  BASEURL = 'http://localhost/';

procedure TFrmMain.Connect;
begin
  Connection.URL := BASEURL;
  Connection.Connected := true;
end;

procedure TFrmMain.ConnectionConnect(Sender: TObject);
begin
  InitInterface;
end;

procedure TFrmMain.InitInterface;
var
  LYearsResponse,
  LSymbolResponse: TXDataClientResponse;

  LYears: TJSArray;
  LSymbols: TJSArray;
  LSymbol: TJSObject;
  i: Integer;
  LYear: Integer;
  LName: String;

  LOption: TJSHTMLOptionElement;
begin
  // get symbols
  LSymbolResponse := await( Client.RawInvokeAsync('IStockService.Symbols', [] ) );

  // get years
  LYearsResponse := await( Client.RawInvokeAsync( 'IStockService.Years', [] ) );

  if ( LSymbolResponse.StatusCode = 200 ) and ( LYearsResponse.StatusCode = 200 ) then
  begin
    LYears := TJSArray( LYearsResponse.ResultAsObject['value'] );
    FSelectYears := document.getElementById('SelectYear') as TJSHTMLSelectElement;

    for i := 0 to LYears.Length - 1 do
    begin
      LYear := Integer( LYears[i] );

      LOption := document.createElement('option') as TJSHTMLOptionElement;
      LOption.innerText := LYear.ToString;
      LOption.value := LYear.ToString;

      FSelectYears.appendChild(LOption);
    end;


    LSymbols := TJSArray( LSymbolResponse.ResultAsObject['value'] );
    FSelectSymbol := document.getElementById('SelectSymbol') as TJSHTMLSelectElement;

    for i := 0 to LSymbols.Length - 1 do
    begin
      LSymbol := TJSObject( LSymbols[i] );

      LOption := document.createElement('option') as TJSHTMLOptionElement;
      LOption.innerText := String(LSymbol['Name']);
      LOption.value := String(LSymbol['Name']);

      FSelectSymbol.appendChild(LOption);
    end;


  end;

  BtnShowChart.Visible := True;
end;

procedure TFrmMain.ShowChart;
var
  LChartResponse: TXDataClientResponse;
  LData: TJSObject;

  LYear: Integer;
  LSymbol: String;


begin
  if Assigned( FChart ) then
  begin
    asm
      this.FChart.destroy();
    end;
  end;

  LSymbol := FSelectSymbol.value;
  LYear := StrToInt( FSelectYears.value );

  LChartResponse := await(
    Client.RawInvokeAsync(
      'IStockService.LineChart',
      [LSymbol, LYear]
    )
  );

  if LChartResponse.StatusCode = 200 then
  begin
    LData := TJSObject( LChartResponse.ResultAsObject );

    asm
      const ctx = document.getElementById('myChart');
      this.FChart = new Chart( ctx, LData );
    end;
  end;
end;

procedure TFrmMain.WebFormDOMContentLoaded(Sender: TObject);
begin
  Connect;
end;

procedure TFrmMain.BtnShowChartClick(Sender: TObject);
begin
  ShowChart;
end;

end.