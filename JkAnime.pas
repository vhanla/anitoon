unit JkAnime;

interface

uses
  WinAPI.Windows, System.Classes, Generics.Collections, Generics.Defaults;

{$M+}

type
  TJKInfo = Record
    Size: TSize;
    VideoLink: String;
    MimeType: String;
  End;

  TJkAnime = class
  private
    FJkAnimeURL : String;
  public
    constructor Create(const aJkAnimeUrl: String; const aAutoParse: Boolean = True); reintroduce;
    destructor Destroy; override;
    procedure Parse;
  end;

  TJkAnimeThread = class(TThread)
  private
    FJkAnime : TJkAnime;
  protected
    procedure Execute; override;
  public
    constructor Create(aJkAnimeUrl: String); reintroduce;
    destructor Destroy; override;
    property JkAnime: TJkAnime read FJkAnime;
  end;

implementation

uses
  System.SysUtils, Web.HTTPApp,
  IdHTTP, IdComponent, IdSSLOpenSSL, XSuperObject;

{ TJkAnimeThread }

constructor TJkAnimeThread.Create(aJkAnimeUrl: String);
begin
  //
//  FJkAnime := TJkAnime.Create;
  inherited Create(False);
end;

destructor TJkAnimeThread.Destroy;
begin
  FreeAndNil(FJkAnime);
  inherited;
end;

procedure TJkAnimeThread.Execute;
begin
  inherited;
  FreeOnTerminate := True;

end;

{ TJkAnime }

constructor TJkAnime.Create(const aJkAnimeUrl: String;
  const aAutoParse: Boolean);
begin
  inherited Create;


end;

destructor TJkAnime.Destroy;
begin

  inherited;
end;

procedure TJkAnime.Parse;
begin

end;

end.
