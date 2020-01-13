unit Form.Timer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.UIConsts, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Lib.Timer,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, System.Generics.Collections,
  System.Math;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label3: TLabel;
    Rectangle1: TRectangle;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    Timer1,Timer2,Timer3,Timer4: TTimer;
    TimerList: TObjectList<TTimer>;
    procedure OnTimer1(Sender: TObject);
    procedure OnTimerOfList(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.OnTimer1(Sender: TObject);
begin
  label1.text:=label1.text+'o';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Timer1=nil then
  begin
    label1.text:='';
    Timer1:=TTimer.Create;
    Timer1.Interval:=1000;
    Timer1.Enabled:=True;
    Timer1.OnTimer:=OnTimer1;
  end else begin
    Timer1.Free;
    Timer1:=nil;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if Timer2=nil then
  begin
    label2.text:='';
    Timer2:=TTimer.Create;
    Timer2.Interval:=7000;
    Timer2.Enabled:=True;
    Timer2.OnTimerProc:=procedure
    begin
      if Assigned(Timer1) then label1.text:='';
      label2.text:=label2.text+'x';
    end;
  end else begin
    Timer2.Free;
    Timer2:=nil;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if Timer3=nil then
  begin
    Timer3:=TTimer.Create;
    Timer3.Interval:=15000;
    Timer3.Enabled:=True;
    Timer3.OnTimerProc:=procedure
    begin
      Timer3.Enabled:=False;
      Close;
    end;
  end else begin
    Timer3.Free;
    Timer3:=nil;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if Timer4=nil then
  begin
    label3.text:='';
    Timer4:=TTimer.Create;
    Timer4.Interval:=1000;
    Timer4.Enabled:=True;
    Timer4.OnTimerProc:=procedure
    begin
      label3.text:=label3.text+'o';
    end;
  end else begin
    Timer4.Free;
    Timer4:=nil;
  end;
end;

procedure TForm1.OnTimerOfList(Sender: TObject);
begin
  Rectangle1.Fill.Color:=MakeColor(RandomRange(0,255),RandomRange(0,255),RandomRange(0,255));
end;

procedure TForm1.Button5Click(Sender: TObject);
var Timer: TTimer;
begin
  for var I in [0..255] do
  begin
    Timer:=TTimer.Create(Self);
    Timer.Interval:=RandomRange(200,2000);
    Timer.Enabled:=True;
    Timer.OnTimer:=OnTimerOfList;
    TimerList.Add(Timer);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  label1.text:='';
  label2.text:='';
  label3.text:='';
  TimerList:=TObjectList<TTimer>.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Timer1.Free;
  Timer2.Free;
  Timer3.Free;
  Timer4.Free;
  TimerList.Free;
end;

end.
