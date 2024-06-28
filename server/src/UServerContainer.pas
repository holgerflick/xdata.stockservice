unit UServerContainer;

interface

uses
    Aurelius.Comp.Connection
  , Aurelius.Drivers.Interfaces

  , Sparkle.Comp.CorsMiddleware
  , Sparkle.Comp.HttpSysDispatcher
  , Sparkle.Comp.Server
  , Sparkle.HttpServer.Context
  , Sparkle.HttpServer.Module

  , System.Classes
  , System.SysUtils

  , XData.Comp.ConnectionPool
  , XData.Comp.Server
  , XData.Server.Module

  ;


type
  TServerContainer = class(TDataModule)
    Dispatcher: TSparkleHttpSysDispatcher;
    Server: TXDataServer;
    MiddlewareCors: TSparkleCorsMiddleware;

  strict private
    class var FInstance: TServerContainer;

  private

    function GetActive: Boolean;
    function GetBaseUrl: String;
    function GetExternalUrl: String;


  public


    class function Instance: TServerContainer;
    class destructor Destroy;

    procedure Start;
    procedure Stop;

    property Active: Boolean read GetActive;
    property BaseUrl: String read GetBaseUrl;
    property ExternalUrl: String read GetExternalUrl;

  public
  end;



implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}



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


function TServerContainer.GetExternalUrl: String;
begin
  // TODO: this is hard-coded
  Result := 'http://192.168.4.80/';
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
