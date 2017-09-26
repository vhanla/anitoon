unit YoutubeURLParserU;

interface

uses
  System.RegularExpressions;

type
  TYoutubeURLParser = class
  strict private
    class var RegEx: TRegEx;
    function GetIsValid: boolean;
  var
    FYoutubeUrl: String;
    FYouTubeID: string;
  public
    class constructor Create;
    constructor Create(AYoutubeUrl: String); reintroduce;
  public
    property YoutubeUrl: String read FYoutubeUrl;
    property IsValid: boolean read GetIsValid;
    property YouTubeID: string read FYouTubeID;
  end;

implementation

uses
  System.SysUtils;
{ TYoutubeURLParser }

class constructor TYoutubeURLParser.Create;
begin
  RegEx := TRegEx.Create('(youtu.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)([^#\&\?]*)', [TRegExOption.roCompiled]);
end;

constructor TYoutubeURLParser.Create(AYoutubeUrl: String);
var
  Tokens: TArray<string>;
  Match: TMatch;
begin
  inherited Create;
  FYouTubeID := '';
  FYoutubeUrl := AYoutubeUrl;

  Match := RegEx.Match(AYoutubeUrl);

  if Match.Success then
  begin
    Tokens := Match.Value.Split(['/', '='], TStringSplitOptions.ExcludeEmpty);

    if Length(Tokens) = 2 then
      FYouTubeID := Tokens[1];
  end;
end;

function TYoutubeURLParser.GetIsValid: boolean;
begin
  Result := FYouTubeID <> '';
end;

end.
