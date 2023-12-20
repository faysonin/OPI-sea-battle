program battleship;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Windows,
  Messages,
  SysUtils;

type
  TMATRIX = array [1 .. 10, 1 .. 10] of string;
  TMASSTR = array [1 .. 40] of string;
  Str = Array [1 .. 10] of string;
  Pole = Array [1 .. 10, 1 .. 10] of string;
  coord = array [1 .. 4] of integer;
  TMASCOORD = array [1 .. 4] of string;
  boat = array [1 .. 22] of string;

var
  field1, field2: TMATRIX;
  help_field1, help_field2, field1_with_boats, field2_with_boats: TMATRIX;

  lettersро: TMASSTR;
  i, j, index1, index2: integer;
  letter: char;
  boat1, boat2: boat;
  shot, boats1, boats2, s: string;
  flag1, flag2, flag, repeatshot, blood_flag: boolean;
  inputfile, Player1, Player2: textfile;
  coordin: coord;
  pos_coordin: TMASCOORD;

function IfFileValid(FileName: string): TMATRIX;
var
  f: textfile;
  FileData: Str;
  i, j, k: integer;
  flag: boolean;
  TempMat: array [1 .. 10, 1 .. 10] of Ansichar;
  Pol: TMATRIX;
begin
  flag := True;
  AssignFile(f, FileName + '.TXT', CP_UTF8);
  Reset(f);
  i := 1;
  while (not EOF(f)) do
  begin
    Readln(f, FileData[i]);
    i := i + 1;
  end;
  for var h := 1 to Length(FileData) do
  begin
    k := 1;
    while k <= Length(FileData[h]) do
    begin
      if FileData[h][k] = ' ' then
      begin
        delete(FileData[h], k, 1);
      end;
      k := k + 1;
    end;
  end;
  for var t := 1 to Length(FileData) do
  begin
    for var h := 1 to Length(FileData[t]) do
    begin
      FileData[t][h] := (UpperCase(FileData[t][h])[1]);
    end;
  end;
  if Length(FileData) = 10 then
  begin
    for var l := 1 to 10 do
    begin
      if Length(FileData[l]) = Length(Pol[l]) then
      begin
        for var g := 1 to Length(FileData[l]) do
        begin
          case FileData[l][g] of
            'М':
              begin
                Pol[l][g] := 'М';
              end;
            'К':
              begin
                Pol[l][g] := 'К';
              end;
          else
            begin
              Writeln('Некорректно введенный файл!');
              Readln;
              flag := false;
              break;
            end;
          end;
        end;
      end
      else
      begin
        Writeln('Некорректно введенный файл!');
        Readln;
        flag := false;
        break;
      end;
    end;
  end
  else
  begin
    Writeln('Некорректно введенный файл!');
    Readln;
    flag := false;
  end;

  if flag then
    result := Pol
end;
procedure coord_valid(var shot:string);
var
 i:integer;
 bufer:string;
 flag:boolean;
begin
  flag:=false;
  repeat
    repeat
      readln(shot);
    until not(shot='');
    bufer:='';
    for i:=1 to length(shot) do
      begin
        if shot[i]<>' ' then
        bufer:=bufer+shot[i];
      end;
    bufer:=ansiuppercase(bufer);
    //writeln(ord(bufer[1]));
    if (ord(bufer[1])<>1049) and (ord(bufer[1])<1051) and (ord(bufer[1])>1039) and (bufer[2]='-') and (((length(bufer)=3)and(bufer[3] in ['1'..'9']))or((length(bufer)=4)and(bufer[3]='1')and(bufer[4]='0')))then
    flag:=true
    else write('введите координаты заново: ');

  until flag=true;
  shot:=bufer;
end;
procedure ClearScreen;
var
  stdout: THandle;
  csbi: TConsoleScreenBufferInfo;
  ConsoleSize: DWORD;
  NumWritten: DWORD;
  Origin: TCoord;
begin
  stdout := GetStdHandle(STD_OUTPUT_HANDLE);
  Win32Check(stdout <> INVALID_HANDLE_VALUE);
  Win32Check(GetConsoleScreenBufferInfo(stdout, csbi));
  ConsoleSize := csbi.dwSize.X * csbi.dwSize.Y;
  Origin.X := 0;
  Origin.Y := 0;
  Win32Check(FillConsoleOutputCharacter(stdout, ' ', ConsoleSize, Origin,
    NumWritten));
  Win32Check(FillConsoleOutputAttribute(stdout, csbi.wAttributes, ConsoleSize,
    Origin, NumWritten));
  Win32Check(SetConsoleCursorPosition(stdout, Origin));
end;

procedure help_table(var for_letters: TMASSTR); // для считывания
var // индексов букв
  letter: char;

begin
  letter := 'А';

  for i := 1 to 10 do
  begin

    if letter = 'Й' then
    begin
      letter := 'К';
    end;

    lettersро[i] := letter;
    letter := Chr(Ord(letter) + 1);

  end;

  letter := '1';

  for i := 11 to 20 do
  begin

    if letter = ':' then
    begin
      lettersро[i] := '10';
    end

    else
    begin
      lettersро[i] := letter;
      letter := Chr(Ord(letter) + 1);
    end;

  end;

  letter := 'а';

  for i := 21 to 30 do
  begin

    if letter = 'й' then
    begin
      lettersро[i] := 'к';
    end

    else
    begin
      lettersро[i] := letter;
      letter := Chr(Ord(letter) + 1);
    end;

  end;
end;

procedure check_coord(var coorrdin: coord; var field_with_boats, field,
  help_field_1: TMATRIX; var s: string; var change: boolean);
var
  i, count: integer;
  check_flag, blood_flag: boolean;
begin
  if field_with_boats[1, 1] = 'К' then
  begin
    if field_with_boats[1, 2] = 'К' then
    begin
      s := 'right';
    end
    else if field_with_boats[2, 1] = 'К' then
    begin
      s := 'down';
    end;
    if s = 'right' then
    begin
      i := 1;
      while (field_with_boats[1, i] = 'К') or (field_with_boats[1, i] = 'Р') do
      begin
        inc(i);
      end;
      coordin[1] := i - 1;
      pos_coordin[1] := s;
      i := 1;
    end
    else if s = 'down' then
    begin
      i := 1;
      while (field_with_boats[i, 1] = 'К') or (field_with_boats[i, 1] = 'Р') do
      begin
        inc(i);
      end;
      coordin[1] := i - 1;
      pos_coordin[1] := s;
    end;

  end;
  if field_with_boats[10, 1] = 'К' then
  begin
    if field_with_boats[10, 2] = 'К' then
    begin
      s := 'right';
    end
    else if field_with_boats[9, 1] = 'К' then
    begin
      s := 'up';
    end;
    if s = 'right' then
    begin
      i := 1;
      while (field_with_boats[10, i] = 'К') or
        (field_with_boats[10, i] = 'Р') do
      begin
        inc(i);
      end;
      coordin[2] := i;
      pos_coordin[2] := s;
      i := 1;
    end
    else if s = 'up' then
    begin
      i := 10;
      while (field_with_boats[i, 1] = 'К') or (field_with_boats[i, 1] = 'Р') do
      begin
        dec(i);
      end;
      coordin[2] := 10 - i;
      pos_coordin[2] := s;
    end;

  end;
  if field_with_boats[10, 10] = 'К' then
  begin
    if field_with_boats[10, 9] = 'К' then
    begin
      s := 'left';
    end
    else if field_with_boats[9, 10] = 'К' then
    begin
      s := 'up';
    end;
    if s = 'left' then
    begin
      i := 10;
      while (field_with_boats[10, i] = 'К') or
        (field_with_boats[10, i] = 'Р') do
      begin
        dec(i);
      end;
      coordin[3] := 10 - i;
      pos_coordin[3] := s;
      i := 1;
    end
    else if s = 'up' then
    begin
      i := 10;
      while (field_with_boats[i, 10] = 'К') or
        (field_with_boats[i, 10] = 'Р') do
      begin
        dec(i);
      end;
      coordin[3] := 10 - i;
      pos_coordin[3] := s;
    end;
  end;
  if field_with_boats[1, 10] = 'К' then
  begin
    if field_with_boats[1, 9] = 'К' then
    begin
      s := 'left';
    end
    else if field_with_boats[2, 10] = 'К' then
    begin
      s := 'down';
    end;
    if s = 'left' then
    begin
      i := 10;
      while (field_with_boats[10, i] = 'К') or
        (field_with_boats[10, i] = 'Р') do
      begin
        dec(i);
      end;
      coordin[4] := 10 - i;
      i := 1;
      pos_coordin[4] := s;
    end
    else if s = 'down' then
    begin
      i := 1;
      while (field_with_boats[i, 10] = 'К') or
        (field_with_boats[i, 10] = 'Р') do
      begin
        inc(i);
      end;
      coordin[4] := i - 1;
      pos_coordin[4] := s;
    end;
  end;
  { for i := 1 to 4 do
    begin
    Writeln(coorrdin[i], ' ', pos_coordin[i]);
    end; }
  if coordin[1] <> 0 then
  begin
    if pos_coordin[1] = 'right' then
    begin
      blood_flag := True;
      for i := 1 to coordin[1] do
      begin
        if field_with_boats[1, i] <> 'Р' then
        begin
          blood_flag := false;
        end;
      end;
      if blood_flag then
      begin
        for i := 1 to coordin[1] do
        begin
          field_with_boats[1, i] := 'У';
          field[1, i] := 'У';
        end;
      end;
      for i := 1 to coordin[1] do
      begin
        help_field_1[1, i] := field_with_boats[1, i];
      end;
    end
    else
    begin
      blood_flag := True;
      for i := 1 to coordin[1] do
      begin
        if field_with_boats[i, 1] <> 'Р' then
        begin
          blood_flag := false;
        end;
      end;
      if blood_flag then
      begin
        for i := 1 to coordin[1] do
        begin
          field_with_boats[i, 1] := 'У';
          field[i, 1] := 'У';
        end;
      end;
      for i := 1 to coordin[1] do
      begin
        help_field_1[i, 1] := field_with_boats[i, 1];
      end;
    end;
  end;
  if coordin[2] <> 0 then
  begin
    if pos_coordin[2] = 'left' then
    begin
      blood_flag := True;
      for i := 10 downto 10 - coordin[2] + 1 do
      begin
        if field_with_boats[1, i] <> 'Р' then
        begin
          blood_flag := false;
        end;
      end;
      if blood_flag then
      begin
        for i := 10 downto 10 - coordin[2] + 1 do
        begin
          field_with_boats[1, i] := 'У';
          field[1, i] := 'У';
        end;
      end;
      for i := 10 downto 10 - coordin[2] + 1 do
      begin
        help_field_1[1, i] := field_with_boats[1, i];
      end;
    end
    else
    begin
      blood_flag := True;
      for i := 1 to coordin[2] do
      begin
        if field_with_boats[10, i] <> 'Р' then
        begin
          blood_flag := false;
        end;
      end;
      if blood_flag then
      begin
        for i := 1 to coordin[2] do
        begin
          field_with_boats[10, i] := 'У';
          field[10, i] := 'У';
        end;
      end;
      for i := 1 to coordin[2] do
      begin
        help_field_1[10, i] := field_with_boats[10, i];
      end;
    end;
  end;
  if coordin[3] <> 0 then
  begin
    if pos_coordin[3] = 'left' then
    begin
      blood_flag := True;
      for i := 10 downto 10 - coordin[3] + 1 do
      begin
        if field_with_boats[10, i] <> 'Р' then
        begin
          blood_flag := false;
        end;
      end;
      if blood_flag then
      begin
        for i := 10 downto 10 - coordin[3] + 1 do
        begin
          field_with_boats[10, i] := 'У';
          field[10, i] := 'У';
        end;
      end;
      for i := 10 downto 10 - coordin[3] + 1 do
      begin
        help_field_1[10, i] := field_with_boats[10, i];
      end;
    end
    else
    begin
      blood_flag := True;
      for i := 10 downto 10 - coordin[3] + 1 do
      begin
        if field_with_boats[i, 10] <> 'Р' then
        begin
          blood_flag := false;
        end;
      end;
      if blood_flag then
      begin
        for i := 10 downto 10 - coordin[3] + 1 do
        begin
          field_with_boats[i, 10] := 'У';
          field[i, 10] := 'У';
        end;
      end;
      for i := 10 downto 10 - coordin[3] + 1 do
      begin
        help_field_1[i, 10] := field_with_boats[i, 10];
      end;
    end;
  end;
  if coordin[4] <> 0 then
  begin
    if pos_coordin[4] = 'right' then
    begin
      blood_flag := True;
      for i := 1 to coordin[4] do
      begin
        if field_with_boats[10, i] <> 'Р' then
        begin
          blood_flag := false;
        end;
      end;
      if blood_flag then
      begin
        for i := 1 to coordin[4] do
        begin
          field_with_boats[10, i] := 'У';
          field[10, i] := 'У';
        end;
      end;
      for i := 1 to coordin[4] do
      begin
        help_field_1[10, i] := field_with_boats[10, i];
      end;
    end
    else
    begin
      blood_flag := True;
      for i := 10 downto 10 - coordin[4] + 1 do
      begin
        if field_with_boats[i, 10] <> 'Р' then
        begin
          blood_flag := false;
        end;
      end;
      if blood_flag then
      begin
        for i := 10 downto 10 - coordin[4] + 1 do
        begin
          field_with_boats[i, 10] := 'У';
          field[i, 10] := 'У';
        end;
      end;
      for i := 10 downto 10 - coordin[4] + 1 do
      begin
        help_field_1[i, 10] := field_with_boats[i, 10];
      end;
    end;

  end;
end;

procedure outputMAS(var MAS, MAS2: TMATRIX);
// Выводит матрицу, поле с короблями
var
  nomerstr, i, j: integer;
  nomerstolb: char;

begin
  SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), foreground_red);
  Write('                ПОЛЕ ПРОТИВНИКА                                    ');
  SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), foreground_green);
  Writeln('ВАШЕ ПОЛЕ     ');
  SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $0F);
  Writeln('      А   Б   В   Г   Д   Е   Ж   З   И   К          А   Б   В   Г   Д   Е   Ж   З   И   К');
  Writeln('   ------------------------------------------     ------------------------------------------');

  nomerstr := 1;

  for i := 1 to 10 do
  begin

    write(nomerstr:3, ' |');

    for j := 1 to 10 do
    begin
      if MAS[i, j] = 'Р' then
      begin
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $06);
        write(MAS[i, j]:2);
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        write(' |')
      end
      else if MAS[i, j] = 'У' then
      begin
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),
          foreground_red);
        write(MAS[i, j]:2);
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        write(' |')
      end
      else
      begin
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        write(MAS[i, j]:2);

        write(' |');
      end;

    end;

    write('  ');

    write(nomerstr:3, ' |');

    for j := 1 to 10 do
    begin
      if MAS2[i, j] = 'Р' then
      begin
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $06);
        write(MAS2[i, j]:2);
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        write(' |')
      end
      else if MAS2[i, j] = 'У' then
      begin
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),
          foreground_red);
        write(MAS2[i, j]:2);
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        write(' |')
      end
      else if MAS2[i, j] = 'К' then
      begin
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),
          foreground_green);
        write(MAS2[i, j]:2);
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        write(' |')
      end
      else if MAS2[i, j] = 'М' then
      begin
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),
          foreground_blue);
        write(MAS2[i, j]:2);
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        write(' |')
      end
      else
      begin
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        write(MAS2[i, j]:2);

        write(' |');
      end;
    end;

    inc(nomerstr);
    Writeln;
    Writeln('   ------------------------------------------     ------------------------------------------');

  end;
  Writeln;
  Writeln;
  Writeln;
  Writeln;
end;

procedure check_kill(var field, field_with_boats: TMATRIX;
  var index1, index2: integer);
var
  l, m, n, p, k, i, j, counter1, counter2, f_index2, f_index1,
    prev_counter: integer;
  flag1, flag_check1, flag_check2, flag2, pos_flag, kill_flag, f1, f2, f3, f4,
    extra_flag: boolean;
  s: string;
begin
  f_index2 := index2;
  f_index1 := index1;
  m := 1;
  n := 1;
  p := 1;
  k := 1;
  f1 := True;
  f2 := True;
  f3 := True;
  f4 := True;
  flag_check2 := false;
  flag_check1 := True;
  extra_flag := True;
  if field_with_boats[index2, index1] = 'Р' then
  begin
    if index2 = 10 then
    begin
      f1 := false;
      m := 0;
    end;
    if index2 = 1 then
    begin
      f2 := false;
      n := 0;
    end;
    if index1 = 10 then
    begin
      f3 := false;
      p := 0;
    end;
    if index1 = 1 then
    begin
      f4 := false;
      k := 0;
    end;

    if ((field_with_boats[index2 + m, index1] = 'К') or
      (field_with_boats[index2 + m, index1] = 'Р')) and f1 then
    begin
      s := 'down';
      extra_flag := false;
    end
    else if ((field_with_boats[index2 - n, index1] = 'Р') or
      (field_with_boats[index2 - n, index1] = 'К')) and f2 then
    begin
      s := 'up';
      extra_flag := false;
    end
    else if ((field_with_boats[index2, index1 + p] = 'Р') or
      (field_with_boats[index2, index1 + p] = 'К')) and f3 then
    begin
      s := 'right';
      extra_flag := false;
    end
    else if ((field_with_boats[index2, index1 - k] = 'К') or
      (field_with_boats[index2, index1 - k] = 'Р')) and f4 then
    begin
      s := 'left';
      extra_flag := false;
    end;
    counter1 := 0;
    counter2 := 0;
    prev_counter := 0;
    flag1 := True;
    if (s = 'right') or (s = 'left') then
    begin
      while flag1 do
      begin
        if ((field_with_boats[index2, index1 + counter1] <> 'М') and
          (field_with_boats[index2, index1 + counter1] <> '*')) and
          (index1 + counter1 < 10) and flag_check1 then
        begin
          inc(counter1);
        end
        else if flag_check1 then
        begin
          flag_check1 := false;
          flag_check2 := True;
        end;
        if ((field_with_boats[index2, index1 - counter2] <> 'М') and
          (field_with_boats[index2, index1 - counter2] <> '*')) and
          (index1 - counter2 > 1) and flag_check2 then
        begin
          inc(counter2);
        end
        else if flag_check2 then
        begin
          flag_check2 := false;
        end;
        if (field_with_boats[index2, index1 + counter1] <> 'К') and
          (field_with_boats[index2, index1 - counter2] <> 'К') and
          (field_with_boats[index2, index1 + counter1] <> 'Р') and
          (field_with_boats[index2, index1 - counter2] <> 'Р') then
        begin
          flag1 := false;
        end;

      end;
    end
    else if (s = 'up') or (s = 'down') then
    begin
      while flag1 do
      begin
        if ((field_with_boats[index2 + counter1, index1] <> 'М') and
          (field_with_boats[index2 + counter1, index1] <> '*')) and
          (index2 + counter1 < 10) and flag_check1 then
        begin
          inc(counter1);
        end
        else if flag_check1 then
        begin
          flag_check2 := True;
          flag_check1 := false;
        end;
        if ((field_with_boats[index2 - counter2, index1] <> 'М') and
          (field_with_boats[index2 - counter2, index1] <> '*')) and
          (index2 - counter2 > 1) and flag_check2 then
        begin
          inc(counter2);
        end
        else if flag_check2 then

        begin
          flag_check2 := false;
        end;
        if (field_with_boats[index2 + counter1, index1] <> 'К') and
          (field_with_boats[index2 - counter2, index1] <> 'К') and
          (field_with_boats[index2 + counter1, index1] <> 'Р') and
          (field_with_boats[index2 - counter2, index1] <> 'Р') then
        begin
          flag1 := false;
        end;
      end;
    end;
    kill_flag := True;
    if (s = 'right') or (s = 'left') then
    begin
      for i := 1 to counter1 + counter2 - 1 do
      begin
        if field_with_boats[index2, index1 + i - counter2] <> 'Р' then
        begin
          kill_flag := false;
        end;
      end;
      if kill_flag then
      begin
        for i := 1 to counter1 + counter2 - 1 do
        begin
          field_with_boats[index2, index1 + i - counter2] := 'У';
          field[index2, index1 + i - counter2] := 'У';
        end;
      end;
    end
    else
    begin
      for i := 1 to counter1 + counter2 - 1 do
      begin
        if field_with_boats[index2 + i - counter2, index1] <> 'Р' then
        begin
          kill_flag := false;
        end;
      end;
      if kill_flag then
      begin
        for i := 1 to counter1 + counter2 - 1 do
        begin
          field_with_boats[index2 + i - counter2, index1] := 'У';
          field[index2 + i - counter2, index1] := 'У';
        end;
      end;
      if (counter2 = counter1) and extra_flag then
      begin
        field_with_boats[index2, index1] := 'У';
        field[index2, index1] := 'У';
      end;
    end;
  end;
end;

Procedure GameWinner(player: integer; var field_with_boats: TMATRIX);
var
  sum, j, k: integer;
begin

  sum := 0;
  for i := 1 to 10 do
  begin
    for j := 1 to 10 do
    begin
      if (field_with_boats[i, j] = 'У') or (field_with_boats[i, j] = 'Р') or
        (field_with_boats[i, j] = 'К') then
        sum := sum + 1;
    end;
  end;
  if sum = 20 then
  begin
    Writeln;
    Writeln('                |', player, '|        ');
    Writeln('             ---------      ');
    Writeln('            /         \     ');
    Writeln('            | Выиграл |    ');
    Writeln('            |    ', player, '     |    ');
    Writeln('            \  игрок  /     ');
    Writeln('             ---------      ');
    Writeln('                |||         ');
    Writeln('              =======      ');
    Writeln;
    flag := false;
    repeatshot := false;
  end;

end;

procedure show_war(var field, field_with_boats, other_field_with_boats,
  help_field_1, help_field_2: TMATRIX; var onemoreshot: boolean;
  var index1, index2: integer);
// Процедура для стрельбы
var // и отоборажение выстрелов и попаданий на матрице
  letter: char;
  shot, s: string;
  flag1, flag2, killed, changed, new_flag: boolean;
  i, j, m, n, p, k: integer;
begin
  Writeln('Введите координаты выстрела : (Пример  Д-1)');
  coord_valid(shot);
  flag1 := True;
  flag2 := True;
  repeatshot := false;
  index1 := 0;
  index2 := 0;
  for i := 1 to Length(shot) do
  begin
    for j := 1 to 30 do
    begin
      if (shot[i] = lettersро[j]) then
      begin
        if flag1 then
        begin
          index1 := j - 20;
          flag1 := false;
          if index1 < 0 then
          begin
            index1 := j;
          end;
        end
        else if flag2 then
        begin
          if (shot[Length(shot)] = '0') and (j = 11) then
          begin
            index2 := 10;
            flag2 := false;
          end
          else if j = 11 then
          begin
            index2 := 1;
            flag2 := false;
          end
          else
          begin
            index2 := j - 10;
            flag2 := false;
          end;
        end;
      end;
    end;
  end;
  // writeln(index1, ' ', index2);
  if (field_with_boats[index2, index1] <> 'К') and
    (field_with_boats[index2, index1] <> 'Р') and
    (field_with_boats[index2, index1] <> 'У') then
  begin
    field[index2, index1] := '*';
    field_with_boats[index2, index1] := '*';

    outputMAS(field, other_field_with_boats);
    Writeln('Ход переходит другом игроку, нажмите Enter для сокрытия поля');
    Readln;
    ClearScreen;
    Writeln('просим сесть за компьютер другого игрока и нажать Enter для продолжения');
    Readln;
  end
  else
  begin
    if (field_with_boats[index2, index1] = 'Р') or
      (field_with_boats[index2, index1] = 'У') then
    begin
      onemoreshot := false;
      outputMAS(field, other_field_with_boats);

      Writeln('Ход переходит другом игроку, нажмите Enter для сокрытия поля');
      Readln;
      ClearScreen;
      Writeln('просим сесть за компьютер другого игрока и нажать Enter для продолжения');
      Readln;
    end
    else
    begin
      if ((index2 = 1) and (index1 = 1)) and
        (((field_with_boats[1, 2] <> 'Р') and (field_with_boats[1, 2] <> 'К'))
        and ((field_with_boats[2, 1] <> 'Р') and (field_with_boats[2,
        1] <> 'К'))) then
      begin
        field[index2, index1] := 'У';
        field_with_boats[index2, index1] := 'У';
        onemoreshot := True;
      end
      else if ((index2 = 1) and (index1 = 10)) and
        (((field_with_boats[1, 9] <> 'Р') and (field_with_boats[1, 9] <> 'К'))
        and ((field_with_boats[2, 10] <> 'Р') and (field_with_boats[2,
        10] <> 'К'))) then
      begin
        field[index2, index1] := 'У';
        field_with_boats[index2, index1] := 'У';
        onemoreshot := True;
      end
      else if ((index2 = 10) and (index1 = 10)) and
        (((field_with_boats[9, 10] <> 'Р') and (field_with_boats[9, 10] <> 'К'))
        and ((field_with_boats[10, 9] <> 'Р') and (field_with_boats[10,
        9] <> 'К'))) then
      begin
        field[index2, index1] := 'У';
        field_with_boats[index2, index1] := 'У';
        onemoreshot := True;
      end
      else if ((index2 = 10)) and ((index1 = 1)) and
        (((field_with_boats[1, 9] <> 'Р') and (field_with_boats[1, 9] <> 'К'))
        and ((field_with_boats[10, 2] <> 'Р') and (field_with_boats[10,
        2] <> 'К'))) then
      begin
        field[index2, index1] := 'У';
        field_with_boats[index2, index1] := 'У';
        onemoreshot := True;
      end
      else
      begin
        check_coord(coordin, field_with_boats, field, help_field_1, s, changed);
        help_field_2 := help_field_1;
        field[index2, index1] := 'Р';
        field_with_boats[index2, index1] := 'Р';
        check_coord(coordin, field_with_boats, field, help_field_1, s, changed);
        onemoreshot := True;
        new_flag := True;
        for i := 1 to 10 do
        begin
          for j := 1 to 10 do
          begin
            if help_field_1[i, j] <> help_field_2[i, j] then
            begin
              new_flag := false;
            end;
          end;
        end;
        if new_flag then
        begin
          check_kill(field, field_with_boats, index1, index2);
          onemoreshot := True;
        end;
      end;
      outputMAS(field, other_field_with_boats);
      Writeln('Вы стреляете ещё раз');
    end;
  end;

end;

function ships_valid(var MAS: TMATRIX): boolean;
var
  i, j, rep_num, m, k, ship_deck1, ship_deck2, ship_deck3, ship_deck4: integer;
  buf: char;
  diagonal_flag: boolean;
begin
  ships_valid := false;
  rep_num := 0;
  ship_deck1 := 0;
  ship_deck2 := 0;
  ship_deck3 := 0;
  ship_deck4 := 0;
  for i := 1 to 10 do
  begin
    rep_num := 0;
    for j := 1 to 10 do
    begin
      buf := MAS[i, j][1];
      if (MAS[i, j] = 'К') or (MAS[i, j] = 'к') then
      begin
        rep_num := rep_num + 1;
        if j = 10 then
        begin
          case rep_num of
            1:
              ship_deck1 := ship_deck1 + 1;
            2:
              ship_deck2 := ship_deck2 + 1;
            3:
              ship_deck3 := ship_deck3 + 1;
            4:
              ship_deck4 := ship_deck4 + 1;
          end;
          rep_num := 0;
        end;
      end
      else
      begin
        case rep_num of
          1:
            ship_deck1 := ship_deck1 + 1;
          2:
            ship_deck2 := ship_deck2 + 1;
          3:
            ship_deck3 := ship_deck3 + 1;
          4:
            ship_deck4 := ship_deck4 + 1;
        end;
        rep_num := 0;
      end;
    end;
  end;

  rep_num := 0;
  for j := 1 to 10 do
  begin
    rep_num := 0;
    for i := 1 to 10 do
    begin
      buf := MAS[i, j][1];
      if (MAS[i, j] = 'К') or (MAS[i, j] = 'к') then
      begin
        rep_num := rep_num + 1;
        if i = 10 then
        begin
          case rep_num of
            1:
              ship_deck1 := ship_deck1 + 1;
            2:
              ship_deck2 := ship_deck2 + 1;
            3:
              ship_deck3 := ship_deck3 + 1;
            4:
              ship_deck4 := ship_deck4 + 1;
          end;
          rep_num := 0;
        end;
      end
      else
      begin
        case rep_num of
          1:
            ship_deck1 := ship_deck1 + 1;
          2:
            ship_deck2 := ship_deck2 + 1;
          3:
            ship_deck3 := ship_deck3 + 1;
          4:
            ship_deck4 := ship_deck4 + 1;
        end;
        rep_num := 0;
      end;
    end;
  end;

  j := 1;
  for i := 2 to 10 do
  begin
    rep_num := 0;
    k := j;
    m := i;
    repeat
      if (MAS[m, k] = 'К') or (MAS[m, k] = 'к') then
      begin
        rep_num := rep_num + 1;
        if rep_num > 1 then
          diagonal_flag := false;
      end
      else
        rep_num := 0;
      m := m - 1;
      k := k + 1;
    until k > i;
  end;

  i := 10;
  for j := 2 to 9 do
  begin
    rep_num := 0;
    k := j;
    m := i;
    repeat
      if (MAS[m, k] = 'К') or (MAS[m, k] = 'к') then
      begin
        rep_num := rep_num + 1;
        if rep_num > 1 then
          diagonal_flag := false;
      end
      else
        rep_num := 0;
      m := m - 1;
      k := k + 1;
    until m < j;
  end;

  i := 10;
  for j := 2 to 9 do
  begin
    rep_num := 0;
    k := j;
    m := i;
    repeat
      if (MAS[m, k] = 'К') or (MAS[m, k] = 'к') then
      begin
        rep_num := rep_num + 1;
        if rep_num > 1 then
          diagonal_flag := false;
      end
      else
        rep_num := 0;
      m := m - 1;
      k := k - 1;
    until k < 1;
  end;

  i := 1;
  for j := 1 to 9 do
  begin
    rep_num := 0;
    k := j;
    m := i;
    repeat
      if (MAS[m, k] = 'К') or (MAS[m, k] = 'к') then
      begin
        rep_num := rep_num + 1;
        if rep_num > 1 then
          diagonal_flag := false;
      end
      else
        rep_num := 0;
      m := m + 1;
      k := k + 1;
    until k > 10;
  end;

  if (ship_deck1 = 24) and (ship_deck2 = 3) and (ship_deck3 = 2) and
    (ship_deck4 = 1) and diagonal_flag then
    ships_valid := True;
end;

begin

  help_table(lettersро);
  field1_with_boats := IfFileValid('Player1');
  field2_with_boats := IfFileValid('Player2');

  if (ships_valid(field1_with_boats) and ships_valid(field2_with_boats)) then
  begin
    Writeln('Краткое описание: ');
    Writeln('Игра - Морской Бой.');
    Writeln('1. Введите координаты выстрела(Буква вводится на русском языке');
    Writeln('2. Попадание засчитывается если вы попали во вражеский корабль(Р), если не попали(*) ');
    Writeln('3. Игра продолжается до того момента, пока не будут уничтожены все вражеские(ваши) корабли.');
    Writeln('Приятной игры!');
    flag := True;
    repeatshot := True;

    Writeln('---------------------------------------------------------------------');

    // writeln('Начало игры!');
    // field1_with_boats := IfFileValid(boats2);
    Writeln('просим сесть за компьютер игрока номер 1');
    Writeln('нажмите Enter для начала игры');
    Readln;
    ClearScreen;
    while flag do
    begin
      Writeln('Ход игрока Номер 1');
      repeatshot := True;

      while repeatshot do
      begin
        ClearScreen;
        ClearScreen;
        outputMAS(field2, field1_with_boats);
        show_war(field2, field2_with_boats, field1_with_boats, help_field1,
          help_field2, repeatshot, index1, index2);
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),
          FOREGROUND_GREEN or FOREGROUND_RED or FOREGROUND_INTENSITY);
        GameWinner(1, field2);
        SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
      end;
      if flag <> false then
      begin
        Writeln('Ход игрока Номер 2.');
        repeatshot := True;

        while repeatshot do
        begin
          ClearScreen;
          ClearScreen;
          outputMAS(field1, field2_with_boats);
          show_war(field1, field1_with_boats, field1_with_boats, help_field1,
            help_field2, repeatshot, index1, index2);
          SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE),
          FOREGROUND_GREEN or FOREGROUND_RED or FOREGROUND_INTENSITY);
          GameWinner(2, field1);
          SetconsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), $F);
        end;
      end;
    end;
  end

  else
    Writeln('Количество или расположение кораблей неверно');

  Readln;

end.
