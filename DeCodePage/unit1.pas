unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;//codepage change button
    Button2: TButton;//exit button
    Edit1: TEdit; //line with input file path
    Label1: TLabel; // input file
    Label2: TLabel; // from codepage
    Label3: TLabel; // to codepage
    Label4: TLabel; //default from codepage
    Label5: TLabel; //default to codepage
    Label6: TLabel;
    ListBox1: TListBox;//listbox with some input file codepages
    ListBox2: TListBox;//listbox with some output file codepages
    OpenDialog1: TOpenDialog;
    Process1: TProcess;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox2SelectionChange(Sender: TObject; User: boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  infile, ofile, incod, ocod, thestring: String;//incoming file, output file...
  //...input file codepage, output file codepage.

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button2Click(Sender: TObject);//exit button
begin
  Process1.Active:=False;
  Form1.Close;
end;

procedure TForm1.Button1Click(Sender: TObject);//codepage changing button push
begin
  thestring:='iconv -f'+' '+incod+' -t'+' '+ocod+' '+infile+' > '+ofile;
  Label6.Caption:=thestring;
  Process1.Create(nil);
  Process1.Executable:='/bin/sh';
  Process1.Parameters.Add('-c');
  Process1.Parameters.Add(thestring);
  Process1.Execute;

end;

procedure TForm1.Edit1Click(Sender: TObject);//click on edit to choose...
begin                                        //...an input file
  if OpenDialog1.Execute then
  begin
   infile:=OpenDialog1.FileName;
  end;
  Edit1.Text:=infile;
  ofile:=infile+'_c.txt';  // assign a name for output file
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListBox1.Selected[0]; //set default values for in & out codepages
  ListBox2.Selected[0];
  incod:=ListBox1.Items.Strings[0];
  ocod:=ListBox2.Items.Strings[0];
  Label4.Caption:=incod;
  Label5.Caption:=ocod;
  Edit1.Text:='';
end;

procedure TForm1.ListBox1SelectionChange(Sender: TObject; User: boolean);
begin
  incod:=ListBox1.GetSelectedText; //codepage selection for input file
  Label4.Caption:=incod;
end;

procedure TForm1.ListBox2SelectionChange(Sender: TObject; User: boolean);
begin
  ocod:=ListBox2.GetSelectedText; //codepage selection for output file
  Label5.Caption:=ocod;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if Process1.Active=True then Label6.Caption:='In process'; //some messages
  if Process1.Active=False then Label6.Caption:='Stopped';
end;

end.

