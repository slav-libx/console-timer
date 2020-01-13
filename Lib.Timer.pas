unit Lib.Timer;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  System.Generics.Collections;

type
  TTimer = class
  private
    FEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure DoInterval;
  public
    Interval: Cardinal;
    OnTimerProc: TProc;
    OnTimer: TNotifyEvent;
    ProcTime: Cardinal;
    constructor Create(Owner: TComponent=nil);
    destructor Destroy; override;
    property Enabled: Boolean read FEnabled write SetEnabled;
  end;

implementation

uses
  System.SyncObjs;

type
  TTimersThread = class(TThread)
    Timers: TList<TTimer>;
    SleepEvent: TEvent;
    procedure Execute; override;
    constructor Create;
    destructor Destroy; override;
  end;

constructor TTimersThread.Create;
begin
  SleepEvent:=TEvent.Create;
  Timers:=TList<TTimer>.Create;
  inherited Create(False);
end;

destructor TTimersThread.Destroy;
begin
  SleepEvent.SetEvent;
  inherited;
  Timers.Free;
  SleepEvent.Free;
end;

procedure TTimersThread.Execute;
var SleepTo,SleepInterval: Cardinal;
begin

  SleepInterval:=INFINITE;

  while not Terminated do
  begin

    SleepEvent.WaitFor(SleepInterval);

    TThread.Synchronize(nil,
      procedure
      begin
        SleepTo:=INFINITE;
        for var Timer in Timers.ToArray do
        if Timers.Contains(Timer) then
        begin
          Timer.DoInterval;
          if Timers.Contains(Timer) and Timer.Enabled then
            SleepTo:=Min(SleepTo,Timer.ProcTime);
        end;
      end);

    if SleepTo=INFINITE then
      SleepInterval:=INFINITE
    else
      SleepInterval:=SleepTo-Min(SleepTo,GetTickCount);

    SleepEvent.ResetEvent;

  end;
end;

var Timers: TTimersThread = nil;

constructor TTimer.Create(Owner: TComponent=nil);
begin
  Interval:=1000;
  Enabled:=False;
  OnTimerProc:=nil;
  if Timers=nil then Timers:=TTimersThread.Create;
  Timers.Timers.Add(Self);
end;

destructor TTimer.Destroy;
begin
  Timers.Timers.Remove(Self);
  if Timers.Timers.Count=0 then
  begin
    Timers.Free;
    Timers:=nil;
  end;
end;

procedure TTimer.SetEnabled(const Value: Boolean);
begin
  if Enabled<>Value then
  begin
    FEnabled:=Value;
    if Value then
    begin
      ProcTime:=TThread.GetTickCount+Interval;
      Timers.SleepEvent.SetEvent;
    end;
  end;
end;

procedure TTimer.DoInterval;
begin
  if Enabled and (ProcTime<=TThread.GetTickCount) then
  begin
    if Assigned(OnTimer) then OnTimer(Self);
    if Assigned(OnTimerProc) then OnTimerProc();
    ProcTime:=TThread.GetTickCount+Interval;
  end;
end;

end.
