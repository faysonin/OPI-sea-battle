program OpiBattleShip;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TMATRIX = array [1 .. 10, 1 .. 10] of ansistring;
  TMASSTR = array [1 .. 40] of ansistring;
  Pole = Array [1 .. 10, 1 .. 10] of ansistring;
  Str = Array [1 .. 10] of ansistring;

function IfFileValid(FileName: string): Pole;
var
  f: textfile;
  FileData: Str;
  i, j, k: integer;
  TempMat: array [1 .. 10, 1 .. 10] of Ansichar;
  Pol: Pole;
begin
  AssignFile(f, 'C:\Player1.TXT', CP_UTF8);
  Reset(f);
  i := 1;
  while (not EOF(f)) do
  begin
    Readln(f, FileData[i]);
    i := i + 1;
  end;
  for var h := 1 to Length(FileData) do
  begin
    k:=1;
    while k<=Length(FileData[h]) do
    begin
      if FileData[h][k]=' ' then
      begin
      delete(FileData[h], k, 1);
      end;
      k:=k+1;
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

begin
  var Setka: pole;
  Setka:=IfFileValid('1pl');
  for var l := 1 to 10 do
    begin
      for var f := 1 to 10 do
        begin
          write(Setka[f][l], ' ');
        end;
        writeln;
    end;
    readln;
end.
