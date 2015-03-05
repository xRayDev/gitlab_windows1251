program get_day;

{$APPTYPE CONSOLE}

uses
  SysUtils, Dialogs;

var
gday: string;
gady_int: integer;

m_day, m_mounth, m_year, m_days_in_mounth: integer;

begin
  try
   //SetConsoleTitle('get_day');
   //gady_int:= StrToInt(FormatDateTime('dd', now));
   //TODO -oUser -cConsole Main : ƒобавить вычитание дн€ -1 с учетом границы на первом дне мес€ца. “.е. если граница нужно получить сколько дней было в предидущем мес€це и заменить значение gady_int на последний день месца.

   m_day:= StrToInt(FormatDateTime('dd', now));

   if m_day = 1 then
   begin
     m_mounth:= StrToInt(FormatDateTime('mm', now));
     m_year:= StrToInt(FormatDateTime('yyyy', now));
     if m_mounth = 1 then
     begin
       m_mounth:= 12;
       m_year:= m_year -1;
     end
     else
     begin
       m_mounth:= m_mounth -1;
     end;

     m_days_in_mounth:= MonthDays[IsLeapYear( m_year )][ m_mounth ];
     m_day:= m_days_in_mounth;
  end
  else
  begin
   m_day:= m_day - 1;
  end;

//  ShowMessage(' оличество дней = '+ IntToStr( MonthDays[IsLeapYear( m_year )][ mounth ]) );

  Halt(m_day);
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
