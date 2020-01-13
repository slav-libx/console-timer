program ctimer;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  Lib.Timer in 'Lib.Timer.pas';

var
  Timer1,Timer2,Timer3,Timer4: TTimer;
  Terminated: Boolean;

begin
  try

  Terminated:=False;

  Timer2:=TTimer.Create;
  Timer2.Interval:=7000;
  Timer2.Enabled:=True;
  Timer2.OnTimerProc:=procedure
  begin
    Writeln('tick 2 '+FormatDateTime('nn:ss.zzz',Time));
  end;

  Timer4:=TTimer.Create;
  Timer4.Interval:=100000;
  Timer4.Enabled:=True;
  Timer4.OnTimerProc:=procedure
  begin
    Terminated:=True;
    Writeln('tick terminated');
  end;

  Timer3:=TTimer.Create;
  Timer3.Interval:=30000;
  Timer3.Enabled:=True;
  Timer3.OnTimerProc:=procedure
  begin
    if Timer1=nil then
    begin
      Timer1:=TTimer.Create;
      Timer1.Interval:=2000;
      Timer1.Enabled:=True;
      Timer1.OnTimerProc:=procedure
      begin
        Writeln('tick 1 '+FormatDateTime('nn:ss.zzz',Time));
      end;
      Writeln('enable tick 1 ')
    end else begin
      Timer1.Free;
      Timer1:=nil;
      Writeln('disable tick 1 ');
    end;
//    Timer1.Enabled:=not Timer1.Enabled;
//    if Timer1.Enabled then
//    else
  end;

  while not Terminated do
  begin
    CheckSynchronize(1000);
  end;

  Timer1.Free;
  Timer2.Free;
  Timer3.Free;
  Timer4.Free;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
