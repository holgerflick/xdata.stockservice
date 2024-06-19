unit UDatabaseManager;

interface

uses
    Data.DB

  , FireDAC.Comp.Client
  , FireDAC.Comp.DataSet
  , FireDAC.Comp.UI
  , FireDAC.DApt
  , FireDAC.DApt.Intf
  , FireDAC.DatS
  , FireDAC.Phys
  , FireDAC.Phys.Intf
  , FireDAC.Phys.SQLite
  , FireDAC.Phys.SQLiteDef
  , FireDAC.Phys.SQLiteWrapper.Stat
  , FireDAC.Stan.Async
  , FireDAC.Stan.Def
  , FireDAC.Stan.Error
  , FireDAC.Stan.ExprFuncs
  , FireDAC.Stan.Intf
  , FireDAC.Stan.Option
  , FireDAC.Stan.Param
  , FireDAC.UI.Intf
  , FireDAC.VCLUI.Async
  , FireDAC.VCLUI.Wait

  , System.Classes
  , System.SysUtils

  ;


type
  TDatabaseManager = class(TDataModule)
    Manager: TFDManager;
  strict private
    class var FInstance: TDatabaseManager;
  private

  public
    class function Instance: TDatabaseManager;
    class destructor Destroy;

    function GetConnection: TFDConnection;
    function GetQuery: TFDQuery;
    procedure ReleaseQuery(AQuery: TFDQuery);



  end;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

const
  CONDEF = 'sqlite_pool';

class destructor TDatabaseManager.Destroy;
begin
  FInstance.Free;
end;

function TDatabaseManager.GetConnection: TFDConnection;
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

function TDatabaseManager.GetQuery: TFDQuery;
begin
  var LConnection := self.GetConnection;
  Result := TFDQuery.Create(LConnection);
  Result.Connection := LConnection;
end;

class function TDatabaseManager.Instance: TDatabaseManager;
begin
  if not Assigned( FInstance ) then
  begin
    FInstance := TDatabaseManager.Create(nil);
  end;

  Result := FInstance;
end;

procedure TDatabaseManager.ReleaseQuery( AQuery: TFDQuery );
begin
  AQuery.Connection.Free;   // this will free query as it is owned by connection
end;

end.
