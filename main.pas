unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, APlayer3Lib_TLB, GDIPApi, GDIPObj,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, SHDocVw, MSHTML, YouTubeU, JkAnime;

type
  //http://www.delphipages.com/forum/showthread.php?t=163110
  TBrowserClick = class(TComponent, IUnknown, IDispatch)
  private
    { Private Declarations }
    FOnclick: TNotifyEvent;
    FRefCount: Integer;
    function QueryInterface( const IID: TGUID; out Obj): Integer; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function Invoke( DispID:Integer; const IID:TGUID; LocaleID:Integer; Flags:Word; var Params; VarResult, ExcepInfo, ArgErr:Pointer):HResult; stdcall;
  protected
    { Protected Declarations }
  public
    { Public Declarations }
    property OnClick : TNotifyEvent read FOnclick write FOnclick;
  published
    { Published Declarations }
  end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    StatusBar1: TStatusBar;
    WebBrowser1: TWebBrowser;
    OpenDialog1: TOpenDialog;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WebBrowser1DownloadComplete(Sender: TObject);
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
  private
    { Private declarations }
    BClick: TBrowserClick;
    BChange: TBrowserClick;
    FInformation: TInformation;

//    procedure MyMessages(var Msg: TMsg; var Handled: Boolean);
    procedure webAPI(strCmd: string);
    { APlayer3 events }
    procedure Player1Buffer(ASender: TObject; nPercent: Integer);
    procedure Player1StateChanged(ASender: TObject; nOldState, nNewState: Integer);
    procedure Player1VideoSizeChanged(ASender: TObject);
    procedure Player1OnMessage(ASender: TObject; nMessage: Integer; wParam: Integer; lParam: Integer);

    { Broser click event handler }
    procedure BrowserClick( Sender: TObject);
    procedure BrowserChange( Sender: TObject);

    { Youtube Parser }
    procedure YouTubeThreadTerminate(Sender: TObject);
  public
    { Public declarations }
    Player1: TPlayer;
  end;

var
  Form1: TForm1;

implementation

uses
  YoutubeURLParserU;

{$R *.dfm}

procedure TForm1.BrowserChange(Sender: TObject);
begin

end;

procedure TForm1.BrowserClick(Sender: TObject);
var
  vClick : IHTMLElement;
  vTag, vID, vClass, vType, vName, vValue, vWebAPI : WideString;
begin
  vClick := ( WebBrowser1.Document as IHTMLDocument2).activeElement;
  vTag := vClick.Get_tagName;
  vID := vClick.Get_id;
  vClass := vClick._className;
  if vClick <> nil then
  begin
    if vClick.getAttribute( 'type', 0) <> null then
      vType := vClick.getAttribute('type', 0);
    if vClick.getAttribute( 'name', 0) <> null then
      vName := vClick.getAttribute('name', 0);
    if vClick.getAttribute( 'value', 0) <> null then
      vValue := vClick.getAttribute('value', 0);

    if vClick.getAttribute( 'webAPI', 0) <> null then
    begin
      vWebAPI := vClick.getAttribute('webAPI', 0);
      // proceed to analize webAPI actions by Vue2Desktop
      webAPI(vWebAPI);
    end;
  end;
  StatusBar1.Panels[0].Text := vType;
  StatusBar1.Panels[1].Text := vClick.outerHTML;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  Player1.Open('http://video7.stream.mx:1935/raxatv/raxatv/chunklist_w884577146.m3u8');
//  WebBrowser1.Navigate('file:///'+StringReplace(ExtractFilePath(ParamStr(0))+'anigui/index.html','\','/',[rfReplaceAll]));

//  WebBrowser1.Navigate('http://localhost:8080');
  with TYoutubeThread.Create('https://www.youtube.com/watch?v=pLQWmJ7vX-g') do
    OnTerminate := YouTubeThreadTerminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
const
  APLAYER_AUTO_PLAY = 8;
var
  bmp : TGPBitmap;
  bmphwnd: HBITMAP;
begin
  Color := clWhite;

  // APlayer3 initialization
  Player1 := TPlayer.Create(Self);
  Player1.Left := 0;
  Player1.Top := 0;
  Player1.Width := 100;
  Player1.Height := 320;
  Player1.Align := alClient;
  Player1.Parent := Panel1;

  Player1.SetConfig(APLAYER_AUTO_PLAY, IntToStr(1));
  Player1.SetVolume(100);

  bmp := TGPBitmap.Create(ExtractFilePath(ParamStr(0)) + 'logo.png');
  try
    bmp.GetHBITMAP(0, bmphwnd);
    Player1.SetCustomLogo(bmphwnd);
  finally
    bmp.Free;
  end;

  Player1.OnBuffer := Player1Buffer;
  Player1.OnStateChanged := Player1StateChanged;
  Player1.OnVideoSizeChanged := Player1VideoSizeChanged;
  Player1.OnMessage := Player1OnMessage;

  Panel1.Width := 256;
  Panel1.Height := 144;
  Panel1.Left := WebBrowser1.Width - 256 - 30;
  Panel1.Top := WebBrowser1.Height - 144 - 30;
  Panel1.Anchors := [akRight, akBottom];

//  Application.OnMessage := MyMessages;

//  WebBrowser1.Navigate('file:///'+StringReplace(ExtractFilePath(ParamStr(0))+'anigui\index.html','\','/',[rfReplaceAll]));
  WebBrowser1.Navigate('http://localhost:8080');

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Player1.Free;
end;

//http://www.delphigroups.info/2/38/301847.html
//procedure TForm1.MyMessages(var Msg: TMsg; var Handled: Boolean);
//var
//  X, Y: Integer;
//  Document, E: OleVariant;
//begin
//  Handled := False;
//  if (WebBrowser1 = nil) or (Msg.message <> WM_LBUTTONDOWN) then Exit;
//  Handled := IsDialogMessage(WebBrowser1.Handle, Msg);
//
//  if (Handled) then
//  begin
//    case (Msg.message) of
//      WM_LBUTTONDOWN:
//      begin
//        X := LOWORD(Msg.lParam);
//        Y := HIWORD(Msg.lParam);
//        Document := WebBrowser1.Document;
//        E := Document.elementFromPoint(X, Y);
//        StatusBar1.Panels[1].Text := E.outerHTML;
//      end;
//    end;
//  end;
//
//end;

procedure TForm1.Player1Buffer(ASender: TObject; nPercent: Integer);
var
  progress: Integer;
begin
  progress := Player1.GetBufferProgress;
  if (progress < 0 ) or (progress > 99) then
  begin
    Player1.Play;
  end
  else
  begin
    Player1.Pause;
  end;
end;

procedure TForm1.Player1OnMessage(ASender: TObject; nMessage, wParam,
  lParam: Integer);
const
  PS_PLAY = 5;
var
  PlayerState: Integer;
begin
  case nMessage of
    WM_LBUTTONDBLCLK:
    begin
      if WindowState = wsMaximized then
      begin
        BorderStyle := bsSizeable;
        WindowState := wsNormal;
        Button1.Visible := True;
        StatusBar1.Visible := True;
        Panel1.Align := alNone;
        Panel1.Anchors := [akRight, akBottom];
        Panel1.Width := 256;
        Panel1.Height := 144;
        Panel1.Left := WebBrowser1.Width - 256 - 30;
        Panel1.Top := WebBrowser1.Height - 144 - 30;
//        FormStyle := fsNormal;
      end
      else
      begin
        BorderStyle := bsNone;
        WindowState := wsMaximized;
        Button1.Visible := False;
        StatusBar1.Visible := False;
        Panel1.Align := alClient;
//        FormStyle := fsStayOnTop;
      end;
    end;
//    WM_LBUTTONDOWN: // let's make it fullscreen :P
//    begin
//      PlayerState := Player1.GetState;
//      if Player1.GetState = PS_PLAY then
//        Player1.Pause
//      else
//        Player1.Play;
//    end;
  end;
end;

procedure TForm1.Player1StateChanged(ASender: TObject; nOldState,
  nNewState: Integer);
const
  CONFIGID_PLAYRESULT = 7;
begin
  case nNewState of
    5:
      StatusBar1.Panels[0].Text := 'Started Playing';
    3:
      StatusBar1.Panels[0].Text := 'Paused';
    1:
      StatusBar1.Panels[0].Text := 'Opening';
    6:
      StatusBar1.Panels[0].Text := 'Closing';
  end;
end;

procedure TForm1.Player1VideoSizeChanged(ASender: TObject);
begin
  //
end;

// webAPI parser and command executor
procedure TForm1.webAPI(strCmd: string);
begin
  if Pos('video', strCmd) = 1  then
  begin

    Player1.Open('http://video7.stream.mx:1935/raxatv/raxatv/chunklist_w884577146.m3u8');
  end
  else if Pos('openM3U', strCmd) = 1 then
  begin
    OpenDialog1.Filter := 'Archivo M3U|*.m3u';
    if OpenDialog1.Execute then
    begin

    end;
  end;


end;

procedure TForm1.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  vDoc: OleVariant;
begin
  if BClick <> nil then
    BClick.Free;
  BClick := TBrowserClick.Create(Application);
  BClick.OnClick := BrowserClick;

  vDoc := WebBrowser1.Document;
  vDoc.attachEvent( 'onclick', OleVariant( BClick as IDispatch));

  if BChange <> nil then
    BChange.Free;
  BChange := TBrowserClick.Create(Application);
  BChange.OnClick := BrowserChange;
  vDoc.attachEvent( 'onchange', OleVariant( BChange as IDispatch));
end;

procedure TForm1.WebBrowser1DownloadComplete(Sender: TObject);
var
  cURL: string;
begin
  cURL := WebBrowser1.LocationURL;

  if Pos('file:///', cURL) = 1 then
  begin
    // parse URL
    cURL := Copy(cURL, Pos('=', cURL) + 1, Length(cURL) - Pos('=', cURL));

    if Pos('#webapi=', cURL) > 0 then
    begin
      ShowMessage(cURL);
    end;

  end;

end;


procedure TForm1.YouTubeThreadTerminate(Sender: TObject);
var
  YouTubeThread: TYoutubeThread;
begin
  YouTubeThread := Sender as TYoutubeThread;
  if YouTubeThread = nil then
    Exit;

  FInformation := YouTubeThread.Youtube.Informations.Last;

  Caption := Format('%s %s (%dx%d)', [YouTubeThread.Youtube.Title, FInformation.Quality, FInformation.Size.cx, FInformation.Size.cy]);
  Player1.Open(FInformation.VideoLink);
end;

{ TBrowserClick }

function TBrowserClick.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
begin
  if Assigned( OnClick ) then
    OnClick( Self );

  Result := S_OK;

end;

function TBrowserClick.QueryInterface(const IID: TGUID; out Obj): Integer;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TBrowserClick._AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TBrowserClick._Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
end;

end.
