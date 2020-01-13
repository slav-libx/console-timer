program ftimer;

uses
  System.StartUpCopy,
  FMX.Forms,
  Form.Timer in 'Form.Timer.pas' {Form1},
  Lib.Timer in 'Lib.Timer.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
