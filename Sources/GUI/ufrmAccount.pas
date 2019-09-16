unit ufrmAccount;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  FMX.DialogService,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

type
  TfrmAccount = class(TForm)
    LayoutContent: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    LayoutName: TLayout;
    Layout2Phone: TLayout;
    LayoutEmail: TLayout;
    LayoutPassword: TLayout;
    LayoutAddress: TLayout;
    LayoutZipCode: TLayout;
    lName: TLabel;
    eName: TEdit;
    ePhone: TEdit;
    lPhone: TLabel;
    lPassword: TLabel;
    ePassword: TEdit;
    ePassword2: TEdit;
    lEmail: TLabel;
    eEmail: TEdit;
    lAddress: TLabel;
    eAddress: TEdit;
    lZipCode: TLabel;
    eZipCode: TEdit;
    LayoutbtnCreateAccount: TLayout;
    btnCreateAccount: TButton;
    VertScrollBox1: TVertScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateAccountClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAccount: TfrmAccount;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmAccount.FormCreate(Sender: TObject);
begin
  Caption:= 'Account Details';
  lName.Text:= 'Name';
  eName.TextPrompt:= 'Type account name';
  lPhone.Text:= 'Phone';
  ePhone.TextPrompt:= 'Type your phone number';
  lEmail.Text:= 'Email';
  eEmail.TextPrompt:= 'your@email.com';
  lPassword.Text:= 'Password';
  ePassword.TextPrompt:= 'Password';
  ePassword2.TextPrompt:= 'Retype Password';
  lAddress.Text:= 'Address';
  eAddress.TextPrompt:= 'Type your address';
  lZipCode.Text:= 'Zip Code';
  eZipCode.TextPrompt:= 'Type Zip Code';

  btnCreateAccount.Text:= 'Create Account';
end;

procedure TfrmAccount.btnCreateAccountClick(Sender: TObject);
begin
  TDialogService.ShowMessage('This function is not implemented.');
end;

end.
