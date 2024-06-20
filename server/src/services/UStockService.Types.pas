unit UStockService.Types;

interface

uses
    System.Generics.Collections

  , DB
  ;

type
  TDTOSymbol = class
  private
    FName: String;
  public
    property Name: String read FName write FName;
  end;

  TDTOSymbols = TList<TDTOSymbol>;

  TDTOHistoricalDay = class
  private
    FDate: TDate;
    FOpen: Double;
    FHigh: Double;
    FLow: Double;
    FClose: Double;
    FAdjClose: Double;

    FVolume: Integer;
    FUnadjustedVolume: Integer;
    FDescription: String;
    FChangeOverTime: Double;
    FLabel: String;

    FChange: Double;
    FChangePercent: Double;

    procedure LoadFrom( ADataSet: TDataSet );

  public
    constructor Create( ADataSet: TDataSet );

    property Date: TDate read FDate write FDate;
    property Open: Double read FOpen write FOpen;
    property High: Double read FHigh write FHigh;
    property Low: Double read FLow write FLow;
    property Close: Double read FClose write FClose;
    property AdjClose: Double read FAdjClose write FAdjClose;
    property Volume: Integer read FVolume write FVolume;
    property UnadjustedVolume: Integer read FUnadjustedVolume write FUnadjustedVolume;
    property Change: Double read FChange write FChange;
    property ChangePercent: Double read FChangePercent write FChangePercent;
    property Description: String read FLabel write FLabel;
    property ChangeOverTime: Double read FChangeOverTime write FChangeOverTime;

  end;

  TDTOHistorical = TList<TDTOHistoricalDay>;

  TDTOYears = TList<Integer>;


implementation

{ TDTOHistoricalDay }

uses
    System.SysUtils
  , Bcl.Utils
  ;

constructor TDTOHistoricalDay.Create(ADataSet: TDataSet);
begin
  inherited Create;

  LoadFrom( ADataSet );
end;

procedure TDTOHistoricalDay.LoadFrom(ADataSet: TDataSet);
begin
  if Assigned( ADataSet ) then
  begin
    self.Date :=  TBclUtils.ISOToDate( ADataSet.FieldByName('date').AsString );
    self.Open := ADataSet.FieldByName('open').AsFloat;
    self.High := ADataSet.FieldByName('high').AsFloat;
    self.Low := ADataSet.FieldByName('low').AsFloat;
    self.Close := ADataSet.FieldByName('close').AsFloat;
    self.AdjClose := ADataSet.FieldByName('adjClose').AsFloat;
    self.Volume := ADataSet.FieldByName('volume').AsInteger;
    self.UnadjustedVolume := ADataSet.FieldByName('unadjustedVolume').AsInteger;
    self.Change := ADataSet.FieldByName('change').AsFloat;
    self.ChangePercent := ADataSet.FieldByName('changePercent').AsFloat;
    self.Description := ADataSet.FieldByName('label').AsString;
    self.ChangeOverTime := ADataSet.FieldByName('changeOverTime').AsFloat;
  end
  else
  begin
    raise EArgumentNilException.Create('Dataset cannot be nil.');
  end;
end;

end.
