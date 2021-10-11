program ICQ_cl;

uses
  Forms,
  icq in 'icq.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
