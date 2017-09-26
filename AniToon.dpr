program AniToon;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  JkAnime in 'JkAnime.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
