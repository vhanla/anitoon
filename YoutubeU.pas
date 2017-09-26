unit YoutubeU;

interface

uses
  WinAPI.Windows, System.Classes, Generics.Collections, Generics.Defaults;

{$M+}

type
  TInformation = record
    Size: TSize;
    VideoLink: String;
    MimeType: String;
    Quality: String;
    YoutubeID: String;
    YoutubeURL: String;
    procedure Clear;
    function VideoTag: String;
  private
    function IsEmnpty: Boolean;
    function CalcSize: Integer;
  end;

  TYoutube = class
  private
    FYoutubeURL: String;
    FYoutubeID: String;
    FTitle: String;
    FLength: string;
    FInformations: TList<TInformation>;
  protected
    function GetSourceCode: string;
    function GetJSON: string;
  published
    property Title: String read FTitle;
    property Length: string read FLength;
    property Informations: TList<TInformation> read FInformations;
    property YoutubeURL: String read FYoutubeURL;
    property YoutubeID: String read FYoutubeID;
  public
    constructor Create(const aYoutubeUrl: String; const aAutoParse: Boolean = True); reintroduce;
    destructor Destroy; override;
    procedure Parse;
  end;

  TYoutubeThread = class(TThread)
  private
    FYoutube: TYoutube;
  protected
    procedure Execute; override;
  public
    constructor Create(aYoutubeUrl: String); reintroduce;
    destructor Destroy; override;
    property Youtube: TYoutube read FYoutube;
  end;

function DownloadVideo(const aInformation: TInformation): String;

implementation

uses
  System.Sysutils, Web.HTTPApp, YoutubeURLParserU,
  IdHTTP, IdComponent, IdSSLOpenSSL, XSuperObject;

function WorkingDir: String;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'Tmp\';
  ForceDirectories(Result)
end;

{ TYoutube }

constructor TYoutube.Create(const aYoutubeUrl: String; const aAutoParse: Boolean = True);
begin
  inherited Create;

  FInformations := TList<TInformation>.Create(TComparer<TInformation>.Construct(
    function(const Left, Right: TInformation): Integer
    begin
      Result := Left.CalcSize - Right.CalcSize;
    end));

  FYoutubeURL := aYoutubeUrl.Replace('https', 'http');
  FYoutubeID := FYoutubeURL.Replace('http://www.youtube.com/watch?v=', '').Replace('http://youtu.be/', '');

  if aAutoParse then
    Parse;
end;

destructor TYoutube.Destroy;
begin
  FreeAndNil(FInformations);
  inherited;
end;

function TYoutube.GetJSON: string;
var
  p: Integer;
begin
  Result := GetSourceCode;
  p := Result.IndexOf('ytplayer.config = ') + 'ytplayer.config = '.Length;

  if p < 0 then
    Exit('');

  Result := Result.Substring(p);

  p := Result.IndexOf('</script>');

  if p < 0 then
    Exit('');

  Result := Result.Substring(0, p);
end;

function TYoutube.GetSourceCode: string;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  Url: String;
begin
  Url := 'https://www.youtube.com/watch?v=' + FYoutubeID;
  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nIL);
  HTTP.IOHandler := SSL;
  HTTP.Request.Accept := '*/*';
  HTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1) Gecko/20130101 Firefox/21.0';
  HTTP.Request.Host := 'www.youtube.com';
  HTTP.HandleRedirects := True;
  HTTP.Request.Referer := Url;
  try
    try
      Result := HTTP.Get(Url);
    except
      on e: Exception do
        Result := e.Message;
    end;
  finally
    FreeAndNil(HTTP);
    FreeAndNil(SSL);
  end;
end;

procedure TYoutube.Parse;
var
  Buf: TArray<String>;
  Tmp: string;
  Videos, Videos2, Videos3, Formats, Formats2: TArray<string>;
  SuperObject: ISuperObject;
  i: Integer;
  Information: TInformation;
begin
  Informations.Clear;

  SuperObject := SO(GetJSON);
  try
    FTitle := SuperObject['args."title"'].AsString;
    Formats := SuperObject['args."fmt_list"'].AsString.Split([','], TStringSplitOptions.ExcludeEmpty);
    FLength := SuperObject['args."length_seconds"'].AsString;
    Videos := SuperObject['args."url_encoded_fmt_stream_map"'].AsString.Split([','], TStringSplitOptions.ExcludeEmpty);
  finally
    SuperObject := nil;
  end;

  for i := 0 to System.Length(Videos) - 1 do
  begin
    Videos2 := Videos[i].Split(['&'], TStringSplitOptions.ExcludeEmpty);
    Formats2 := Formats[i].Split(['/'], TStringSplitOptions.ExcludeEmpty);
    Information.Clear;

    if System.Length(Formats2) > 1 then
    begin
      Buf := Formats2[1].Split(['x'], TStringSplitOptions.ExcludeEmpty);
      if System.Length(Buf) = 2 then
      begin
        Information.Size.cx := StrToInt(Buf[0].Trim);
        Information.Size.cy := StrToInt(Buf[1].Trim);
      end;

    end;

    for Tmp in Videos2 do
    begin
      Videos3 := Tmp.Split(['='], TStringSplitOptions.ExcludeEmpty);
      if Videos3[0] = 'url' then
        Information.VideoLink := string(HTTPDecode(AnsiString(Videos3[1])))
      else if Videos3[0] = 'quality' then
        Information.Quality := Videos3[1]
      else if Videos3[0] = 'type' then
        Information.MimeType := string(HTTPDecode(AnsiString(Videos3[1])))
    end;

    Information.YoutubeID := YoutubeID;
    Information.YoutubeURL := YoutubeURL;

    if not Information.IsEmnpty then
      Informations.Add(Information);
  end;

  FInformations.Sort;
end;

{ TInformation }

function TInformation.CalcSize: Integer;
begin
  Result := Size.cx * Size.cy;
end;

procedure TInformation.Clear;
begin
  Size.cx := 0;;
  Size.cy := 0;;
  VideoLink := '';
  MimeType := '';
  Quality := '';
end;

function TInformation.IsEmnpty: Boolean;
begin
  Result := VideoLink = EmptyStr;
end;

function TInformation.VideoTag: String;
begin
  Result := '<embed src="' + VideoLink + '"  ' + Format('width="%d" height="%d">', [Size.cx, Size.cy]);
end;

{ TDownloadThread }

function DownloadVideo(const aInformation: TInformation): String;
var
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  Stream: TMemoryStream;
begin
  Result := WorkingDir + FloatToStr(now).Replace(FormatSettings.DecimalSeparator, '') + '.mp4';
  HTTP := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nIL);
  Stream := TMemoryStream.Create;
  try
    HTTP.IOHandler := SSL;
    HTTP.Request.Accept := '*/*';
    HTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1) Gecko/20130101 Firefox/21.0';
    HTTP.Request.Host := 'www.youtube.com';
    HTTP.HandleRedirects := True;
    HTTP.Get(aInformation.VideoLink, Stream);

    Stream.Seek(0, soFromBeginning);
    Stream.SaveToFile(Result);
  finally
    FreeAndNil(HTTP);
    FreeAndNil(Stream);
  end;
end;

{ TYoutubeThread }

constructor TYoutubeThread.Create(aYoutubeUrl: String);
begin
  // Transform the yuotube url to the http://www.youtube.com/watch?v=<YoutubeID> format
  with TYoutubeURLParser.Create(aYoutubeUrl) do
    try
      aYoutubeUrl := 'http://www.youtube.com/watch?v=' + YoutubeID;
    finally
      free;
    end;

  FYoutube := TYoutube.Create(aYoutubeUrl, False);
  inherited Create(False);
end;

destructor TYoutubeThread.Destroy;
begin
  FreeAndNil(FYoutube);
  inherited;
end;

procedure TYoutubeThread.Execute;
begin
  inherited;
  FreeOnTerminate := True;
  FYoutube.Parse;
end;

end.
