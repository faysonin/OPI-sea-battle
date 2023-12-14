program Battleship;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  SysUtils;

type
  TMATRIX = array [1 .. 10, 1 .. 10] of string;
  TMASSTR = array [1 .. 40] of string;
  Str = Array [1 .. 10] of string;

var
<<<<<<< HEAD
  field1, field2: TMATRIX;
  field1_with_boats: TMATRIX = (('М', 'М', 'М', 'М', 'К', 'К', 'К', 'К', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'К', 'М'),
    ('М', 'К', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'К', 'М', 'М', 'М', 'М', 'М', 'К', 'К', 'М'),
    ('М', 'К', 'М', 'К', 'К', 'К', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'К', 'М', 'М', 'М', 'К', 'М', 'К', 'К', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'К', 'М', 'М', 'М', 'К'),
    ('М', 'М', 'К', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'К', 'М', 'М'));
  field2_with_boats: TMATRIX = (('К', 'К', 'М', 'К', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'К', 'М', 'М'),
    ('К', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('К', 'М', 'К', 'К', 'К', 'К', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('К', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('К', 'М', 'М', 'К', 'М', 'К', 'К', 'К', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М', 'М'),
    ('К', 'К', 'К', 'М', 'К', 'М', 'М', 'М', 'М', 'М'),
    ('М', 'М', 'М', 'М', 'М', 'М', 'К', 'М', 'М', 'М'));
=======
  field1, field2, field1_with_boats, field2_with_boats: TMATRIX;
>>>>>>> 1c3b5438484e0b5f263639b51432d2865d64746c
  lettersро: TMASSTR;
  i, j, index1, index2: integer;
  letter: char;
  shot, boats1, boats2: string;
  flag1, flag2, flag, repeatshot: boolean;
  inputfile: textfile;
function IfFileValid(FileName: string): TMATRIX;
var
  f: textfile;
  FileData: Str;
  i, j: integer;
  TempMat: array [1 .. 10, 1 .. 10] of char;
  Pol: TMATRIX;
begin
  AssignFile(f, FileName + '.txt');
  Reset(f);
  i := 1;
  while (not EOF(f)) do
  begin
    Readln(f, FileData[i]);
    i := i + 1;
  end;
  i := 1;
  j := 1;
  for var k := 1 to 10 do
  begin
    while (j < Length(FileData[i])) do
    begin
      if ((FileData[k][j] = 'M') or (FileData[k][j] = 'К')) then
      begin
        TempMat[i][k] := FileData[k][j];
      end
      else
      begin
        writeln('Невалидный файл');
        break;
      end;
      j := j + 2;
      i := i + 1;
    end;
  end;
  for var k := 1 to 10 do
  begin
    for var h := 1 to 10 do
    begin
      if TempMat[h][k] = 'M' then
      begin
        Pol[h][k] := '0';
      end
      else
      begin
        if TempMat[h][k] = 'К' then
          Pol[h][k] := '1';
      end;
    end;
  end;
  result := Pol
end;

procedure help_table(var for_letters: TMASSTR);                  // для считывания
var                                                              // индексов букв
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

procedure outputMAS(var MAS,MAS2: TMATRIX);            // Выводит матрицу, поле с короблями
var
  nomerstr, i, j: integer;
  nomerstolb: char;
begin
  writeln('                ПОЛЕ ПРОТИВНИКА                                    ВАШЕ ПОЛЕ     ');
  writeln('      А   Б   В   Г   Д   Е   Ж   З   И   К          А   Б   В   Г   Д   Е   Ж   З   И   К');
  writeln('   ------------------------------------------     ------------------------------------------');
  nomerstr := 1;
  for i := 1 to 10 do
  begin
    write(nomerstr:3, ' |');
    for j := 1 to 10 do
    begin
      write(MAS[i, j]:2, ' |');
    end;

    write('  ');

    write(nomerstr:3, ' |');
    for j := 1 to 10 do
    begin
      write(MAS2[i, j]:2, ' |');
    end;

    inc(nomerstr);
    writeln;
    writeln('   ------------------------------------------     ------------------------------------------');
  end;
  writeln;
  writeln;
  writeln;
  writeln;
end;

procedure clean_console;
var i:integer;
begin
  for i := 1 to 30 do
  writeln;
end;

procedure show_war(var field, field_with_boats, other_field_with_boats: TMATRIX;var onemoreshot: boolean);                                  // Процедура для стрельбы
var                                                           // и отоборажение выстрелов и попаданий на матрице
  letter: char;
  shot: string;
  flag1, flag2: boolean;
  i, j, index1, index2: integer;
begin
  writeln('Введите координаты выстрела : (Пример  Д-1)');
  readln(shot);
  flag1 := true;
  flag2 := true;
  repeatshot := false;
  index1 := 0;
  index2 := 0;
  for i := 1 to length(shot) do
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
          if (shot[length(shot)] = '0') and (j = 11) then
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
    (field_with_boats[index2, index1] <> 'X') then
  begin
    field[index2, index1] := '*';
    field_with_boats[index2, index1] := '*';


    outputMAS(field,other_field_with_boats);
    writeln('Ход переходит другом игроку, нажмите Enter для сокрытия поля');
    readln;
    clean_console;
    writeln('просим сесть за компьютер другого игрока и нажать Enter для продолжения');
    readln;
  end
  else
  begin
    if field_with_boats[index2, index1] = 'X' then
    begin
      onemoreshot := false;
      outputMAS(field,other_field_with_boats);


      writeln('Ход переходит другом игроку, нажмите Enter для сокрытия поля');
      readln;
    clean_console;
    writeln('просим сесть за компьютер другого игрока и нажать Enter для продолжения');
    readln;
    end
    else
    begin
      field[index2, index1] := 'X';
      field_with_boats[index2, index1] := 'X';
      onemoreshot := true;


      outputMAS(field,other_field_with_boats);
      writeln('Вы стреляете ещё раз');
    end;
  end;
end;



begin
  help_table(lettersро);
  writeln('Краткое описание : ');
  writeln('Игра - Морской Бой');
  writeln('1. Введите координаты выстрела(Буква вводится на русском языке');
  writeln('2. Попадание засчитывается если вы попали во вражеский корабль(X), если не попали(*) ');
  writeln('3. Игра продолжается до того момента, пока не будут уничтожены все вражеские(ваши) корабли');
  writeln('Приятной игры!');
  flag := true;
  repeatshot := true;
  writeln('---------------------------------------------------------------------');
 // writeln('Начало игры!');
<<<<<<< HEAD
 // field1_with_boats := IfFileValid(boats2);
=======
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
    begin
      field1_with_boats[i, j] := 'К';
    end;
  end;
  for i := 5 to 10 do
  begin
    for j := 5 to 10 do
    begin
      field2_with_boats[i, j] := 'К';
    end;
  end;
>>>>>>> 1c3b5438484e0b5f263639b51432d2865d64746c
  writeln('просим сесть за компьютер игрока номер 1');
  writeln('нажмите Enter для начала игры');
  readln;
  while flag do
  begin
    writeln('Ход игрока Номер 1');
    repeatshot := true;
    while repeatshot do
    begin
      outputMAS(field2, field1_with_boats);
      show_war(field2, field2_with_boats, field1_with_boats, repeatshot);
    end;
    writeln('Ход игрока Номер 2');
    repeatshot := true;
    while repeatshot do
    begin
      outputMAS(field1, field2_with_boats);
      show_war(field1, field1_with_boats, field1_with_boats, repeatshot);
    end;
  end;
  readln;

end.
