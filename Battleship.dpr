program Battleship;

uses
  SysUtils;

type
  TMATRIX = array [1 .. 10, 1 .. 10] of string;
  TMASSTR = array [1 .. 40] of string;
  Pole = Array [1 .. 10, 1 .. 10] of string;
  Str = Array [1 .. 10] of string;

var
  field1, field2: TMATRIX;
  field1_with_boats: Pole = (('М', 'М', 'М', 'М', 'К', 'К', 'К', 'К', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'К', 'М'),
    ('М', 'К', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'К', 'М', 'М', 'М', 'М', 'М', 'К', 'К', 'М'),
    ('М', 'К', 'М', 'К', 'К', 'К', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'К', 'М', 'М', 'М', 'К', 'М', 'К', 'К', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'К', 'М', 'М', 'М', 'К'),
    ('М', 'М', 'К', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'К', 'М', 'М'));
  field2_with_boats: Pole = (('К', 'К', 'М', 'К', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'К', 'М', 'М'),
    ('К', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('К', 'М', 'К', 'К', 'К', 'К', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('К', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('К', 'М', 'М', 'К', 'М', 'К', 'К', 'К', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('К', 'К', 'К', 'М', 'К', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'К', 'М', 'М', 'М'));
  letters: TMASSTR;
  i, j, index1, index2: integer;
  letter: char;
  shot, boats1, boats2: string;
  flag1, flag2, flag, repeatshot: boolean;
  inputfile: textfile;

function IfFileValid(FileName: string): Pole;
var
  f: textfile;
  FileData: Str;
  i, j: integer;
  TempMat: array [1 .. 10, 1 .. 10] of char;
  Pol: Pole;
begin
  AssignFile(f, FileName);
  Reset(f);
  i := 1;
  while (not EOF(f)) do
  begin
    Readln(f, FileData[i]);
    i := i + 1;
  end;
  for var h := 1 to Length(FileData) do
  begin
    for var k := 1 to Length(FileData[h]) do
    begin
      if FileData[h][k]=' ' then
      delete(FileData[h], k, 1);
    end;
  end;
  for var l := 1 to 10 do
  begin
    for var g := 1 to Length(FileData[l]) do
    begin
      case FileData[l][g] of
        'М':
        begin
          Pol[l][g]:='0';
        end;
        'К':
        begin
          Pol[l][g]:='1';
        end;
        else
        begin
          Writeln('Некорректно введенный файл!');
          readln;
          break;
        end;
      end;
    end;
  end;
  result := Pol
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
    letters[i] := letter;
    letter := Chr(Ord(letter) + 1);
  end;

  letter := '1';
  for i := 11 to 20 do
  begin
    if letter = ':' then
    begin
      letters[i] := '10';
    end
    else
    begin
      letters[i] := letter;
      letter := Chr(Ord(letter) + 1);
    end;
  end;
  letter := 'а';
  for i := 21 to 30 do
  begin
    if letter = 'й' then
    begin
      letters[i] := 'к';
    end
    else
    begin
      letters[i] := letter;
      letter := Chr(Ord(letter) + 1);
    end;
  end;
end;

procedure outputMAS(var MAS: TMATRIX); // Выводит матрицу, поле с короблями
var
  nomerstr, i, j: integer;
  nomerstolb: char;
begin
  nomerstolb := 'А';
  write('    ');
  for i := 1 to 10 do
  begin
    if nomerstolb = 'Й' then
    begin
      nomerstolb := 'К';
      write(nomerstolb:3, ' ');
    end
    else
    begin
      write(nomerstolb:3, ' ');
      nomerstolb := Chr(Ord(nomerstolb) + 1);
    end;
  end;
  writeln;
  write('    -');
  for i := 1 to 10 do
  begin
    write('----');
  end;
  writeln;
  nomerstr := 1;
  for i := 1 to 10 do
  begin
    write(nomerstr:3, ' |');
    for j := 1 to 10 do
    begin
      write(MAS[i, j]:2, ' |');
    end;
    inc(nomerstr);
    writeln;
    writeln('   ------------------------------------------');
  end;
  writeln;
end;

procedure show_war(var field: TMATRIX; var field_with_boats: Pole;
  var onemoreshot: boolean); // Процедура для стрельбы
var // и отоборажение выстрелов и попаданий на матрице
  letter: char;
  shot: string;
  counter: integer;
  flag1, flag2, checkflag: boolean;
  i, j, index1, index2, m,n,p,k: integer;
begin
  writeln('Введите координаты выстрела : (Пример  Д-1)');
  Readln(shot);
  flag1 := true;
  flag2 := true;
  repeatshot := false;
  index1 := 0;
  index2 := 0;
  for i := 1 to Length(shot) do
  begin
    for j := 1 to 30 do
    begin
      if (shot[i] = letters[j]) then
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
    (field_with_boats[index2, index1] <> 'Р') then
  begin
    field[index2, index1] := '*';
    field_with_boats[index2, index1] := '*';
    writeln('Ход переходит другом игроку');
  end
  else
  begin
    if field_with_boats[index2, index1] = 'Р' then
    begin
      onemoreshot := false;
      writeln('Ход переходит другом игроку');
    end
    else
    begin
      field[index2, index1] := 'Р';
      field_with_boats[index2, index1] := 'Р';

      onemoreshot := true;
      writeln('Вы стреляете ещё раз');
    end;
  end;
 m:=1;
 n:=1;
 p:=1;
 k:=1;
 flag:=false;
  repeat
    if field_with_boats[index2, index1] = 'Р' then
    begin
      if (field_with_boats[index2 + m, index1] = 'Р') or
      (field_with_boats[index2 + m, index1] = 'К')then
      begin
      inc(m);
      end
      else if (field_with_boats[index2, index1 + n] = 'Р')
      or (field_with_boats[index2, index1+n] = 'К') then
      begin
      inc(n);
      end
      else if (field_with_boats[index2 - p, index1] = 'Р')
      or (field_with_boats[index2-p, index1] = 'К') then
      begin
      inc(p);
      end
      else if (field_with_boats[index2, index1 - k] = 'Р')
      or (field_with_boats[index2, index1-k] = 'К') then
      begin
      inc(k);
      end;

    end;
  until not flag;

end;

begin
  help_table(letters);
  writeln('Краткое описание : ');
  writeln('Игра - Морской Бой');
  writeln('1. Введите координаты выстрела(Буква вводится на русском языке');
  writeln('2. Попадание засчитывается если вы попали во вражеский корабль(X), если не попали(*) ');
  writeln('3. Игра продолжается до того момента, пока не будут уничтожены все вражеские(ваши) корабли');
  writeln('Приятной игры!');
  flag := true;
  repeatshot := true;
  writeln('---------------------------------------------------------------------');
  writeln('Начало игры!');

  // boats2 := 'boats2';
  // field1_with_boats := IfFileValid(boats2);
  while flag do
  begin
    writeln('Ход игрока Номер 1');
    writeln('Поле противника');
    repeatshot := true;
    while repeatshot do
    begin
      outputMAS(field2);
      show_war(field2, field2_with_boats, repeatshot);
      // outputMAS(field2);
      // outputMAS(field2_with_boats);
    end;
    outputMAS(field2);
    writeln('Ход игрока Номер 2');
    writeln('Ваше поле');
    repeatshot := true;
    while repeatshot do
    begin
      outputMAS(field1);
      show_war(field1, field1_with_boats, repeatshot);
      // outputMAS(field1);
      // outputMAS(field1_with_boats);
    end;
    outputMAS(field1);
  end;
  Readln;

end.
