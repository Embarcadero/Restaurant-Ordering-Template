unit ufrmDashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit,
  {$IFDEF ANDROID}
  AndroidAPI.Helpers, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net,
  Androidapi.JNI.App,
  {$ENDIF}
  {$IFDEF IOS}
  Macapi.Helpers, iOSapi.Foundation, FMX.Helpers.IOS,
  {$ENDIF}

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Objects, FMX.Controls.Presentation, FMX.Edit;

type
  TfrmDashboard = class(TForm)
    LayoutDashboard: TLayout;
    PanelBackGround: TPanel;
    tbMain: TToolBar;
    btnSideMenu: TButton;
    btnBack: TButton;
    gplTopButtons: TGridPanelLayout;
    btnMenu: TButton;
    btnCart: TButton;
    btnCoupons: TButton;
    gblBottomButtons: TGridPanelLayout;
    btnGallery: TButton;
    btnAccount: TButton;
    btnAboutUs: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDashboard: TfrmDashboard;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmDashboard.FormCreate(Sender: TObject);
begin
  Caption:= 'DASHBOARD';
  tbMain.StylesData['CAPTION.TEXT']:= Caption;

  btnGallery.Text:= 'Gallery';
  btnCoupons.Text:= 'Coupons';
  btnAccount.Text:= 'Account';
  btnMenu.Text:= 'Menu';
  btnCart.Text:= 'Cart';
  btnAboutUs.Text:= 'About Us';
end;

end.
