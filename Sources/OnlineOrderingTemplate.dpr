program OnlineOrderingTemplate;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmMain in 'GUI\ufrmMain.pas' {frmMain},
  uDMUnit in 'ORM\uDMUnit.pas' {DMUnit: TDataModule},
  ufrmGetStarted in 'GUI\ufrmGetStarted.pas' {frmGetStarted},
  ufrmDashboard in 'GUI\ufrmDashboard.pas' {frmDashboard},
  ufrmMenu in 'GUI\ufrmMenu.pas' {frmMenu},
  ufrmCoupons in 'GUI\ufrmCoupons.pas' {frmCoupons},
  ufrmAccount in 'GUI\ufrmAccount.pas' {frmAccount},
  ufrmGallery in 'GUI\ufrmGallery.pas' {frmGallery},
  ufrmAddToCart in 'GUI\ufrmAddToCart.pas' {frmAddToCart},
  ufrmOptionsList in 'GUI\ufrmOptionsList.pas' {frmOptionsList},
  ufrmCart in 'GUI\ufrmCart.pas' {frmCart},
  ufrmAboutUs in 'GUI\ufrmAboutUs.pas' {frmAboutUs};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDMUnit, DMUnit);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
