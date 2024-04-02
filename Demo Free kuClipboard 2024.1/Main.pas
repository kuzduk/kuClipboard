unit Main;

interface

uses
  Windows, Messages, Controls, Forms, ActiveX, ShlObj, ComObj, Classes,
  StdCtrls, SysUtils, FileCtrl, ShellAPI, Dialogs,

  kuClipboard;

type
  TForm1 = class(TForm)
    FileListBox1: TFileListBox;
    btnMail: TButton;
    btnSait: TButton;
    DirectoryListBox1: TDirectoryListBox;
    Label1: TLabel;
    Label2: TLabel;
    btnCopy: TButton;
    btnCut: TButton;
    btnPaste: TButton;

    procedure btnSaitClick(Sender: TObject);
    procedure btnMailClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnCutClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);

  end;

var
  Form1: TForm1;


implementation

{$R *.DFM}




//------------------------------------------------------------------------------ Copy
procedure TForm1.btnCopyClick(Sender: TObject);
var
  i: Integer;
  FileList: TStrings;

begin


FileList := TStringList.Create;
FileList.Capacity := FileListBox1.SelCount;

for i := 0 to FileListBox1.Items.Count - 1
do if FileListBox1.Selected[i] then FileList.Add(IncludeTrailingBackSlash(Label1.Caption) + FileListBox1.Items[i]);


//Clipboard_Send(FileList, stCopy);

Clipboard_Copy(FileList);

ShowMessage('Вы скопировали файлы в буфер обмена, теперь можете их вставить в любом файловом менеджере Ctrl+V' +#13#10#13#10+ FileList.Text);

FileList.Free;

end;



//------------------------------------------------------------------------------ Cut
procedure TForm1.btnCutClick(Sender: TObject);
var
  i: Integer;
  FileList: TStrings;

begin


FileList := TStringList.Create;
FileList.Capacity := FileListBox1.SelCount;

for i := 0 to FileListBox1.Items.Count - 1
do if FileListBox1.Selected[i] then FileList.Add(IncludeTrailingBackSlash(Label1.Caption) + FileListBox1.Items[i]);


//Clipboard_Send(FileList, stCopy);

Clipboard_Cut(FileList);

ShowMessage('Вы вырезали файлы в буфер обмена, теперь можете их вставить в любом файловом менеджере Ctrl+V' +#13#10#13#10+ FileList.Text);

FileList.Free;

end;




//------------------------------------------------------------------------------ Paste
procedure TForm1.btnPasteClick(Sender: TObject);
begin


Clipboard_Paste(Label1.Caption);

FileListBox1.Update; //Обновляем после вставки лист чтоб отобразились новые файлы

end;




//------------------------------------------------------------------------------ email
procedure TForm1.btnMailClick(Sender: TObject);
begin
ShellExecute(Form1.Handle, nil, 'mailto:kuzduk@mail.ru?subject=kuClipboard', nil, nil, SW_RESTORE);
end;





//------------------------------------------------------------------------------ Sait
procedure TForm1.btnSaitClick(Sender: TObject);
begin
ShellExecute(Form1.Handle, nil, PChar('https://kuzduk.ru'), nil, nil, SW_RESTORE);
end;


end.
