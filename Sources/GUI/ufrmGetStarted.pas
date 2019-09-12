unit ufrmGetStarted;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, FMX.DialogService,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TfrmGetStarted = class(TForm)
    LayoutGetStarted: TLayout;
    PanelBackGround: TPanel;
    rButtonsBG: TRectangle;
    btnGetStarted: TButton;
    LayoutButtons: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure btnGetStartedClick(Sender: TObject);
  private
    { Private declarations }
  public
//    property FormCaption: string read  write
  end;

var
  frmGetStarted: TfrmGetStarted;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmGetStarted.FormCreate(Sender: TObject);
begin
  Caption:= 'Get Started';
  btnGetStarted.Text:= 'Get Started';
end;

procedure TfrmGetStarted.btnGetStartedClick(Sender: TObject);
begin
  DMUnit.CloseFormClass:= TfrmGetStarted;
end;

end.
