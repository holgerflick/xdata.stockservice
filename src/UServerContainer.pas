unit UServerContainer;

interface

uses
  System.SysUtils, System.Classes, Sparkle.HttpServer.Module,
  Sparkle.HttpServer.Context, Sparkle.Comp.Server,
  Sparkle.Comp.HttpSysDispatcher, Aurelius.Drivers.Interfaces,
  Aurelius.Comp.Connection, XData.Comp.ConnectionPool, XData.Server.Module,
  XData.Comp.Server, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.DApt,
  Sparkle.Comp.CorsMiddleware;

type
  TServerContainer = class(TDataModule)
    Dispatcher: TSparkleHttpSysDispatcher;
    Server: TXDataServer;
    Manager: TFDManager;
    MiddlewareCors: TSparkleCorsMiddleware;

  strict private
    class var FInstance: TServerContainer;

  private
    function GetActive: Boolean;
    function GetBaseUrl: String;


  public
    function GetConnection: TFDConnection;

    class function Instance: TServerContainer;
    class destructor Destroy;

    procedure Start;
    procedure Stop;

    property Active: Boolean read GetActive;
    property BaseUrl: String read GetBaseUrl;

  public
  end;



implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

const
  CONDEF = 'sqlite_pool';

class destructor TServerContainer.Destroy;
begin
  FInstance.Free;

  inherited;
end;

function TServerContainer.GetActive: Boolean;
begin
  Result := Dispatcher.Active;
end;

function TServerContainer.GetBaseUrl: String;
begin
  Result := Server.BaseUrl;
end;

function TServerContainer.GetConnection: TFDConnection;
begin
  if not Manager.IsConnectionDef(CONDEF) then
  begin
    var LParams := TStringList.Create;
    try
      LParams.Add('Database=stock.db');
      LParams.Add('Pooling=True');

      Manager.AddConnectionDef(CONDEF, 'SQLite', LParams, False );
    finally
      LParams.Free;
    end;
  end;

  Result := TFDConnection.Create(nil);
  Result.ConnectionDefName := CONDEF;
end;

class function TServerContainer.Instance: TServerContainer;
begin
  if not Assigned( FInstance ) then
  begin
    FInstance := TServerContainer.Create(nil);
  end;

  Result := FInstance;
end;


procedure TServerContainer.Start;
begin
  Dispatcher.Active := True;
end;

procedure TServerContainer.Stop;
begin
  Dispatcher.Active := False;
end;

end.
