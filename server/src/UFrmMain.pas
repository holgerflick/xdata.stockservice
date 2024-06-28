unit UFrmMain;

interface

uses
    System.Classes
  , System.SysUtils
  , System.Variants

  , Winapi.Messages
  , Winapi.Windows

  , Vcl.Controls
  , Vcl.Dialogs
  , Vcl.Forms
  , Vcl.Graphics
  , Vcl.StdCtrls

  , UServerContainer
  , Vcl.ExtCtrls
  , Vcl.BaseImageCollection
  , Vcl.ImageCollection
  , Vcl.VirtualImage
  ;


type
  TMainForm = class(TForm)
    txtLog: TMemo;
    btStart: TButton;
    btStop: TButton;
    Logo: TVirtualImage;
    ImageCollection: TImageCollection;
    VirtualImage1: TVirtualImage;
    btSwagger: TButton;
    procedure btStartClick(ASender: TObject);
    procedure btStopClick(ASender: TObject);
    procedure btSwaggerClick(Sender: TObject);
    procedure FormCreate(ASender: TObject);
  strict private
    procedure UpdateGUI;
    procedure ShowSwagger;

  public
    procedure Log( AText: String; ATimeStamp: Boolean = true );

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
    System.DateUtils
  , WinApi.ShellAPI
  ;

resourcestring
  SServerStopped = 'Server stopped';
  SServerStartedAt = 'Server started at ';

{ TMainForm }

procedure TMainForm.btStartClick(ASender: TObject);
begin
  TServerContainer.Instance.Start;
  UpdateGUI;
end;

procedure TMainForm.btStopClick(ASender: TObject);
begin
  TServerContainer.Instance.Stop;
  UpdateGUI;
end;

procedure TMainForm.btSwaggerClick(Sender: TObject);
begin
  ShowSwagger;
end;

procedure TMainForm.FormCreate(ASender: TObject);
begin
  UpdateGUI;
end;

procedure TMainForm.Log(AText: String; ATimeStamp: Boolean);
var
  LLine: String;

begin
  if ATimeStamp then begin
    LLine := DateTimeToStr( TDateTime.Now ) + ': ';
  end;

  LLine := LLine + AText;

  txtLog.Lines.Append(LLine);
end;

procedure TMainForm.ShowSwagger;
begin
  var LUrl := TServerContainer.Instance.ExternalUrl + 'swaggerui';
  ShellExecute( self.Handle, 'open', pWideChar( LUrl ), '', '',  SW_SHOWNORMAL );
end;

procedure TMainForm.UpdateGUI;
const
  cHttp = 'http://+';
  cHttpLocalhost = 'http://localhost';
begin
  btStart.Enabled := not TServerContainer.Instance.Active;
  btStop.Enabled := not btStart.Enabled;
  btSwagger.Enabled := not btStart.Enabled;
  if TServerContainer.Instance.Active then
    Log(SServerStartedAt + StringReplace(
      TServerContainer.Instance.BaseUrl,
      cHttp, cHttpLocalhost, [rfIgnoreCase]))
  else
    Log(SServerStopped);
end;

end.
