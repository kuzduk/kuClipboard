unit kuClipboard;
{
ver 2024.1 free
Autor: Grigoriy Gorkun
kuzduk@mail.ru
http://kuzduk.ru/delphi/kulibrary
}

interface

uses Forms, Classes, SysUtils, ShellApi, ShlObj, ClipBrd, Windows, Controls,
  math;

type


TClipboardSendType = (stCopy = 5, stCut = 2);

procedure Clipboard_Send(const DataPaths: TStrings; const SendType: TClipboardSendType);
procedure Clipboard_Copy(const DataPaths: TStrings);
procedure Clipboard_Cut(const DataPaths: TStrings);
procedure Clipboard_Paste(const Target: string);
function  Clipboard_GetSendType: TClipboardSendType;
procedure Clipboard_GetPaths(var PathsList: TStrings);
function  Clipboard_GetPath1: string;

function  ShellSpecStr(Strs: TStrings): string; overload;
function  ShellSpecStr(const Str: string): string; overload;

function FilesShellOperations(const Source, Target: string; Operacia: Integer; Flags: Integer = FOF_SIMPLEPROGRESS): Boolean; overload;
function FilesShellOperations(const Source: TStrings; const Target: string; Operacia: Integer; Flags: Integer = FOF_SIMPLEPROGRESS): Boolean; overload;
           

implementation




//------------------------------------------------------------------------------ Send
procedure Clipboard_Send(const DataPaths: TStrings; const SendType: TClipboardSendType);
{
  Отправляет файлы/папки в буфер обмена на:
  stCopy = копирование(будто вы нажали Ctrl+C)
  stCut  = вырезку(будто вы нажали Ctrl+X)
  чтоб потом можно было вставить(Ctrl+V) эти данные в любом файловом менеджере.

  uses ShlObj, ClipBrd, Windows;
}

var
DropFiles: PDropFiles;
hGlobal: THandle;
iLen: Integer;
f: Cardinal;
d: PCardinal;
DataSpecialList: string; //список адресов(FullPaths) файлов/папок которые надо копировать/вырезать


begin

if DataPaths = nil then exit;
if DataPaths.Count = 0 then exit;


Clipboard.Open;
Clipboard.Clear;

//преобразовываем в спец-строку
DataSpecialList := ShellSpecStr(DataPaths);


iLen := Length(DataSpecialList) * SizeOf(Char);
hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf(TDropFiles) + iLen);
Win32Check(hGlobal <> 0);
DropFiles := GlobalLock(hGlobal);
DropFiles^.pFiles := SizeOf(TDropFiles);

{$IFDEF UNICODE}
DropFiles^.fWide := true;
{$ENDIF}

Move(DataSpecialList[1], (PansiChar(DropFiles) + SizeOf(TDropFiles))^, iLen);
SetClipboardData(CF_HDROP, hGlobal);
GlobalUnlock(hGlobal);



f := RegisterClipboardFormat(CFSTR_PREFERREDDROPEFFECT);
hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, sizeof(dword));
d := PCardinal(GlobalLock(hGlobal));

case SendType of
  stCopy: d^ := Cardinal(stCopy);
  stCut:  d^ := Cardinal(stCut);
end;

SetClipboardData(f, hGlobal);
GlobalUnlock(hGlobal);


Clipboard.Close;

end;



//------------------------------------------------------------------------------ Copy
procedure Clipboard_Copy(const DataPaths: TStrings);
begin
Clipboard_Send(DataPaths, stCopy);
end;



//------------------------------------------------------------------------------ Cut
procedure Clipboard_Cut(const DataPaths: TStrings);
begin
Clipboard_Send(DataPaths, stCut);
end;



//------------------------------------------------------------------------------ Paste
procedure Clipboard_Paste(const Target: string);
{
Эта функция вставит из буфера обмена файлы/папки,
которые копировали/вырезали(Ctrl+C / Ctrl+X) в буфер в каком-либо файловом менеджере(Проводник, ТоталКоммандер)

Target - папка в которую будет вставлены данные
Clipboard_OperationType - подфункция которая определяет что надо сделать: Копировать или Вырезать
}

var
  sr : string;
  DataList: TStrings;

begin

//Если то, что находиться в буфере
//НЕ является файлами/папками, которые копированы/вырезаны, то выходим
//CF_HDROP - дескриптор который идентифицирует список файлов.
//Прикладная программа может извлечь информацию о файлах, передавая дескриптор функции DragQueryFile.
if not Clipboard.HasFormat(CF_HDROP) then exit;
if Clipboard.GetAsHandle(CF_HDROP) = 0 then exit;

Clipboard.Open;

try
  DataList := TStringList.Create;
  ClipBoard_GetPaths(DataList);

  sr := DataList[0];           //Path №1
  sr := ExtractFilePath(sr);   //Родительская папка Path №1


  if IncludeTrailingBackslash(AnsiUpperCase(sr)) = IncludeTrailingBackslash(AnsiUpperCase(Target))

  then//Делаем копию: откуда copy туда и paste
  begin
      case Clipboard_GetSendType of
         stCopy: FilesShellOperations(DataList, target, FO_COPY, FOF_SIMPLEPROGRESS or FOF_RENAMEONCOLLISION );
         stCut:  FilesShellOperations(DataList, target, FO_MOVE, FOF_SIMPLEPROGRESS );
      end;
  end

  else
  begin
      case Clipboard_GetSendType of
         stCopy: FilesShellOperations(DataList, target, FO_COPY, FOF_SIMPLEPROGRESS );
         stCut:  FilesShellOperations(DataList, target, FO_MOVE, FOF_SIMPLEPROGRESS );
      end;
  end;

finally
  Clipboard.Close;
  DataList.Free;
end;

end;



//------------------------------------------------------------------------------ Get Send Type
function Clipboard_GetSendType: TClipboardSendType;
{
  Функция определяет на что посланы данные в буфер: на вырезку или на копирование

  Эта функция создаваласть специально для функции ClipBoard_DataPaste,
  чтоб было понятно что делать при вставке(Ctrl+V): копировать или вырезать.
}
var
   ClipFormat, hn: Cardinal;
   szBuffer: array[0..511] of Char;
   FormatID: string;
   pMem: Pointer;
   i: integer;


begin

Result := stCopy;

if not OpenClipboard(Application.Handle) then exit;


try
  ClipFormat := EnumClipboardFormats(0);

  while (ClipFormat <> 0)
  do
  begin

      GetClipboardFormatName(ClipFormat, szBuffer, SizeOf(szBuffer));
      FormatID := string(szBuffer);

      if SameText(FormatID, 'Preferred DropEffect')
      then
      begin
           hn := GetClipboardData(ClipFormat);
           pMem := GlobalLock(hn);

           Move(pMem^, i, 4); //тип send
           case i of
               integer(stCopy) : Result := stCopy;
               integer(stCut)  : Result := stCut;
           end;

           GlobalUnlock(hn);
           Break;
      end;

      ClipFormat := EnumClipboardFormats(ClipFormat);

  end;

  finally
  CloseClipboard;
end;


end;



//------------------------------------------------------------------------------ Get Paths
procedure Clipboard_GetPaths(var PathsList: TStrings);
{
  Процедура загружает в PathsList список файлов/папок, которые были посланы в буфер обмена.
  Послать данные в буфер можно так:
  1) нажатием Ctrl+C или Ctrl+X в каком либо файловом менеджере.
  2) начать Drag&Drop
}

var
  FullPath: array [0..MAX_PATH] of Char;
  i, FileCount: Integer;
  h: THandle;
  
begin

//Только для Ctrl+X или Ctrl+C, но не для Drag&Drop. для Drag&Drop надо свой Handle
//if h = 0
//then
//begin
//  if not Clipboard.HasFormat(CF_HDROP) then exit;
//
//  Clipboard.Open;
//  try
//    h := Clipboard.GetAsHandle(CF_HDROP);
//  finally
//    Clipboard.Close;
//  end;
//end;

PathsList.Clear;

h := Clipboard.GetAsHandle(CF_HDROP);

if h = 0 then exit;


FileCount := DragQueryFile(h, $FFFFFFFF, nil, 0);

for i := 0 to FileCount - 1
do
begin
      DragQueryFile(h, i, FullPath, SizeOf(FullPath));
      PathsList.Add(FullPath);
end;


end;



//------------------------------------------------------------------------------ Get Path 1
function Clipboard_GetPath1: string;
{
Преобразует текст из буфера в строку адреса
Например, вы скопировали кучу файлов, тогда функция вернёт первый в списке путь
}
var
  s: string;
  i: integer;

begin

s := Clipboard.AsText;

if (pos(#10, s) <> 0) and (pos(#13, s) <> 0)
then
begin
    i := min(  pos(#10, s), pos(#13, s)  );
    s := copy( s, 1, i - 1 );
end;

s := StringReplace(S, #0, '', [rfReplaceAll]);
s := StringReplace(S, #10, '', [rfReplaceAll]);
s := StringReplace(S, #13, '', [rfReplaceAll]);
//Str_Trim_Right(s, #0);
//Str_Trim_Right(s, #10);
//Str_Trim_Right(s, #13);

Result := s;

end;







//------------------------------------------------------------------------------ Shell Spec Str
function ShellSpecStr(Strs: TStrings): string; overload;
{
  Функция преобразует TStirngs в спец-список для буфера обмена
  в этом спец-списке строки разделены знаком #0
  и весь спец-список заканчивается #0#0
}
var
s: string;
i: integer;

begin

for i := 0 to Strs.Count - 1
do s := s + Strs[i] + #0;

Result := s + #0;

end;


//------------------------------------------------------------------------------ Shell Spec Str
function ShellSpecStr(const Str: string): string; overload;
begin

Result :=  Str + #0#0;

end;











{$REGION ' Files Shell Operations '}
//Функции для копирования/вырезания/перименования/удаления файлов и папок средсвами проводника Shell API
{
uses ShellAPI

Source - источник. Адреc файлов с которыми что то делаем. Конвертируется в специальный формат Clipboard_SpecStr
Target - приёмник. Адрес папки в которую вставляем вырезанные или скопированные данные

Operacia:
FO_COPY
FO_MOVE
FO_RENAME
FO_DELETE

Flags:
FOF_ALLOWUNDO         - Если возможно, сохраняет информацию для возможности UnDo. Если вы хотите не просто удалить файлы, а переместить их в корзину, должен быть установлен флаг/
FOF_CONFIRMMOUSE      - Не реализовано.
FOF_FILESONLY         - Если в поле pFrom установлено *.*, то операция будет производиться только с файлами.
FOF_MULTIDESTFILES    - Указывает, что для каждого исходного файла в поле pFrom указана своя директория - адресат.
FOF_NOCONFIRMATION    - Отвечает "yes to all" на все запросы в ходе опеации.
FOF_NOCONFIRMMKDIR    - Не подтверждает создание нового каталога, если операция требует, чтобы он был создан.
FOF_RENAMEONCOLLISION - Не показывать диалог перименования: если уже существует файл с данным именем, то НЕ спрашивать о переименовании, а создать файл с именем "Copy #N of..."
FOF_SILENT            - Не показывать диалог с индикатором прогресса.
FOF_SIMPLEPROGRESS    - Показывать диалог с индикатором прогресса, но не показывать имен файлов.
FOF_WANTMAPPINGHANDLE - Вносит hNameMappings элемент. Дескриптор должен быть освобожден функцией SHFreeNameMappings
}


//------------------------------------------------------------------------------ Data Operations #
function FilesShellOperations___(const SourceSpecStr, Target: string; Operacia, Flags: Integer): Boolean;


var SHOS: TSHFileOpStruct;

begin

//FillChar (SHOS, SizeOf(SHOS), #0);
//ZeroMemory(@SHOS, SizeOf(SHOS));

SHOS.Wnd    := 0;
SHOS.wFunc  := Operacia;
SHOS.pFrom  := PChar(SourceSpecStr);
SHOS.pTo    := PChar(Target);
SHOS.fFlags := Flags;

Result := (SHFileOperation(SHOS) = 0) and (not SHOS.fAnyOperationsAborted);

end;



//------------------------------------------------------------------------------ Data Operations Str
function FilesShellOperations(const Source, Target: string; Operacia: Integer; Flags: Integer = FOF_SIMPLEPROGRESS): Boolean; overload;
var SourceSpecStr: string;

begin

SourceSpecStr := ShellSpecStr(Source);

Result := FilesShellOperations___(SourceSpecStr, Target, Operacia, Flags);

end;



//------------------------------------------------------------------------------ Data Operations Strs
function FilesShellOperations(const Source: TStrings; const Target: string; Operacia: Integer; Flags: Integer = FOF_SIMPLEPROGRESS): Boolean; overload;
var SourceSpecStr: string;

begin

SourceSpecStr := ShellSpecStr(Source);

Result := FilesShellOperations___(SourceSpecStr, Target, Operacia, Flags);

end;



{$ENDREGION}






end.
