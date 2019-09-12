unit ufrmDashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit,
  {$IFDEF ANDROID}
  AndroidAPI.Helpers, Androidapi.JNI.GraphicsContentViewText,
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
    btnMenu: TButton;
    btnBack: TButton;
    gplTopButtons: TGridPanelLayout;
    btnGallery: TButton;
    btnCoupons: TButton;
    btnAccount: TButton;
    gblBottomButtons: TGridPanelLayout;
    btnCallUs: TButton;
    btnEmailUs: TButton;
    btnDirections: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnEmailUsClick(Sender: TObject);
    procedure btnCallUsClick(Sender: TObject);
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
  btnCallUs.Text:= 'Call Us';
  btnEmailUs.Text:= 'Email Us';
  btnDirections.Text:= 'Directions';
end;

procedure TfrmDashboard.btnCallUsClick(Sender: TObject);

  function ClearPhoneNumb(const ANumb: string): string;
  var
    ifor: integer;
  begin
    Result:= '';

    for ifor:= 1 to length(ANumb) do
      if ANumb[ifor] in ['0'..'9'] then
        Result:= Result + ANumb[ifor];
  end;

{$IF DEFINED(ANDROID)}
var
  lIntent: JIntent;
{$ENDIF}
{$IF DEFINED(IOS)}
var
  lNSU: NSUrl;
  lPhoneNumber: string;
{$ENDIF}
begin
  {$IF DEFINED(ANDROID)}
  lIntent:= TJIntent.Create;
  lIntent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  lIntent.setData(StrToJURI('tel:' + DMUnit.PhoneNumber));
  SharedActivity.startActivity(lIntent);
  {$ENDIF}

  {$IF DEFINED(IOS)}
  lPhoneNumber:= 'tel:' + ClearPhoneNumb(DMUnit.PhoneNumber);
  lNSU:= TNSURL.Wrap(TNSURL.OCClass.URLWithString(StrToNSStr(lPhoneNumber)));
  if SharedApplication.canOpenURL(lNSU) then
    SharedApplication.openUrl(lNSU);
  {$ENDIF}
end;

procedure TfrmDashboard.btnEmailUsClick(Sender: TObject);
{$IF DEFINED(ANDROID)}
var
  lIntent: JIntent;
{$ENDIF}

{$IF DEFINED(IOS)}
var
  lNSU: NSUrl;
  lUrl: string;
{$ENDIF}
begin
  {$IF DEFINED(ANDROID)}
  lIntent:= TJIntent.Create;
  lIntent.setAction(TJIntent.JavaClass.ACTION_SENDTO);
  lIntent.setData(StrToJURI('mailto:' + DMUnit.EmailUs));
  SharedActivity.startActivity(lIntent);
  {$ENDIF}

  {$IF DEFINED(IOS)}
  lUrl:= 'mailto:' + DMUnit.EmailUs;
  lNSU:= TNSURL.Wrap(TNSURL.OCClass.URLWithString(StrToNSStr(lUrl)));
  if SharedApplication.canOpenURL(lNSU) then
    SharedApplication.openUrl(lNSU);
  {$ENDIF}
end;

end.
