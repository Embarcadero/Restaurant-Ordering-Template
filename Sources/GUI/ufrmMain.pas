unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  FMX.DialogService, System.Rtti,
  uDMUnit, ufrmGetStarted, ufrmDashboard, ufrmMenu, ufrmCoupons, ufrmAccount,
  ufrmGallery, ufrmCart, ufrmAboutUs,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.ListBox, FMX.Layouts, FMX.MultiView, FMX.TabControl,
  FMX.Controls.Presentation, FireDAC.Stan.Intf, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.Text;

const
  cButtonsColor = $FF585858;
  cGetStarted = 'GetStarted';

type
  TClassOfForm = class of TForm;

  TTabsArray = array of record
    TabItem: TTabItem;
    TabForm: TForm;
    ActiveFormTabByClass: TClass;
    IsbtnMenuVisible: Boolean;
    IsbtnBackVisible: Boolean;
    MenuButtonsColor: TAlphaColor;
  end;

  TfrmMain = class(TForm)
    btnSideMenu: TButton;
    btnBack: TButton;
    LayoutContent: TLayout;
    tcMain: TTabControl;
    mvSliderMenu: TMultiView;
    lbMainMenu: TListBox;
    lbItemDashBoard: TListBoxItem;
    lbItemMenu: TListBoxItem;
    lbItemCart: TListBoxItem;
    lbItemAccount: TListBoxItem;
    lbItemCoupons: TListBoxItem;
    lbItemGallery: TListBoxItem;
    lbItemAboutUs: TListBoxItem;
    tShowGetStartedOnStartUp: TTimer;
    tbtnCloseTab: TTimer;
    StyleBook1: TStyleBook;
    tbMain: TToolBar;
    tCloseTabOnSave: TTimer;
    FDBatchMoveTextReader1: TFDBatchMoveTextReader;
    procedure tShowGetStartedOnStartUpTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbtnCloseTabTimer(Sender: TObject);
    procedure LayoutContentClick(Sender: TObject);
    procedure btnSideMenuClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure tCloseTabOnSaveTimer(Sender: TObject);
    procedure lbMainMenuItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
  private
    FTabsArray: TTabsArray;
    FTabForClosingName: string;

    function CheckTabOnExists(const aTabName: string): Boolean;
    procedure LoadScreenByName(const aScreenName: string = '');

    procedure tabItembtnCloseClick(Sender: TObject);
    procedure btnDashboardClick(Sender: TObject);
    procedure CallForm(aFormClass: TClassOfForm = nil; const abtnBackHint: String = ''; aIsMenuButtonVisible: Boolean = True; aIsBackButtonVisible: Boolean = False; aButtonsTintColor: TAlphaColor = $FF631F70);
    procedure IfTabNotExist(const aScreenName: string = '');
    procedure AllTabsExceptDashboard(const aScreenName: string = '');
    procedure JustDashboard(const aScreenName: string = '');

    function CheckIsFormAssigned(aFormClass: TClass = nil): Boolean;
    procedure SetActiveTab(aFor: Integer = -1);
  public
    property TabsArray: TTabsArray read FTabsArray write FTabsArray;
    property TabForClosingName: string read FTabForClosingName write FTabForClosingName;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

function TfrmMain.CheckTabOnExists(const aTabName: string): Boolean;
var
  ifor: Integer;
begin
  Result:= False;

  for ifor:= 0 to pred(Length(TabsArray)) do
    if Assigned(TabsArray[ifor].TabItem) and (LowerCase(TabsArray[ifor].TabItem.Name) = LowerCase(aTabName)) then
    begin
      Result:= True;
      break;
    end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  btnBack.Visible:= False;

  lbItemDashBoard.StyleLookup:= 'ListboxItemMenuItemStyle';
  lbItemDashBoard.StylesData['Button.StyleLookup']:= 'ButtonMenuHomeStyle';

  lbItemMenu.StyleLookup:= 'ListboxItemMenuItemStyle';
  lbItemMenu.StylesData['Button.StyleLookup']:= 'ButtonMenuRestStyle';

  lbItemCart.StyleLookup:= 'ListboxItemMenuItemStyle';
  lbItemCart.StylesData['Button.StyleLookup']:= 'ButtonMenuCartStyle';

  lbItemAccount.StyleLookup:= 'ListboxItemMenuItemStyle';
  lbItemAccount.StylesData['Button.StyleLookup']:= 'ButtonMenuAccountStyle';

  lbItemCoupons.StyleLookup:= 'ListboxItemMenuItemStyle';
  lbItemCoupons.StylesData['Button.StyleLookup']:= 'ButtonMenuCouponStyle';

  lbItemGallery.StyleLookup:= 'ListboxItemMenuItemStyle';
  lbItemGallery.StylesData['Button.StyleLookup']:= 'ButtonMenuGalleryStyle';

  lbItemAboutUs.StyleLookup:= 'ListboxItemMenuItemStyle';
  lbItemAboutUs.StylesData['Button.StyleLookup']:= 'ButtonMenuInfoStyle';

  tShowGetStartedOnStartUp.Enabled:= True;
end;

procedure TfrmMain.LoadScreenByName(const aScreenName: string = '');
begin
  if mvSliderMenu.IsShowed then
    mvSliderMenu.HideMaster;

  // If tab not yet exist
  if not CheckTabOnExists('tab' + aScreenName) then
    IfTabNotExist(aScreenName)
   else
  // If tab exists
  begin
    // All tabs except Dashboard
    if (LowerCase(aScreenName) <> LowerCase(lbItemDashBoard.Name)) then
      AllTabsExceptDashboard(aScreenName)
    else
    // Just Dashboard
    if LowerCase(aScreenName) = LowerCase(lbItemDashboard.Name) then
      JustDashboard(aScreenName);
  end;
end;

procedure TfrmMain.IfTabNotExist(const aScreenName: string = '');
begin
  SetLength(FTabsArray, Length(FTabsArray) + 1);
  TabsArray[Length(TabsArray) - 1].TabItem:= TTabItem.Create(tcMain);
  TabsArray[Length(TabsArray) - 1].TabItem.Parent:= tcMain;

  TabsArray[Length(TabsArray) - 1].TabItem.AutoSize:= False;
  TabsArray[Length(TabsArray) - 1].TabItem.IsSelected:= True;
  TabsArray[Length(TabsArray) - 1].TabItem.Name:= 'tab' + aScreenName;
  TabsArray[Length(TabsArray) - 1].TabItem.Text:= 'cap' + aScreenName;

  tbMain.Visible:= True;
  lbItemDashBoard.Visible:= True;

  // Dashbord
  if LowerCase(aScreenName) = LowerCase(lbItemDashboard.Name) then
  begin
    lbItemDashBoard.Visible:= False;
    CallForm(TfrmDashboard);
    TfrmDashboard(TabsArray[Length(TabsArray) - 1].TabForm).LayoutDashboard.Parent:= TabsArray[Length(TabsArray) - 1].TabItem;
    TfrmDashboard(TabsArray[Length(TabsArray) - 1].TabForm).btnSideMenu.OnClick:= btnSideMenuClick;
  end else

  // Profile
  if LowerCase(aScreenName) = LowerCase(cGetStarted) then
  begin
    tbMain.Visible:= False;
    CallForm(TfrmGetStarted, TabsArray[Length(TabsArray) - 1].TabItem.Name, True, False, cButtonsColor);
    TfrmGetStarted(TabsArray[Length(TabsArray) - 1].TabForm).LayoutGetStarted.Parent:= TabsArray[Length(TabsArray) - 1].TabItem;
  end else

  // Menu
  if LowerCase(aScreenName) = LowerCase(lbItemMenu.Name) then
  begin
    CallForm(TfrmMenu, '', True, False, cButtonsColor);
    TfrmMenu(TabsArray[Length(TabsArray) - 1].TabForm).LayoutContent.Parent:= TabsArray[Length(TabsArray) - 1].TabItem;
  end else

  // Coupons
  if LowerCase(aScreenName) = LowerCase(lbItemCoupons.Name) then
  begin
    CallForm(TfrmCoupons, TabsArray[Length(TabsArray) - 1].TabItem.Name, False, True, cButtonsColor);
    TfrmCoupons(TabsArray[Length(TabsArray) - 1].TabForm).LayoutContent.Parent:= TabsArray[Length(TabsArray) - 1].TabItem;
  end else

  // Account
  if LowerCase(aScreenName) = LowerCase(lbItemAccount.Name) then
  begin
    CallForm(TfrmAccount, '', True, False, cButtonsColor);
    TfrmAccount(TabsArray[Length(TabsArray) - 1].TabForm).LayoutContent.Parent:= TabsArray[Length(TabsArray) - 1].TabItem;
  end else

  // Gallery
  if LowerCase(aScreenName) = LowerCase(lbItemGallery.Name) then
  begin
    CallForm(TfrmGallery, '', True, False, cButtonsColor);
    TfrmGallery(TabsArray[Length(TabsArray) - 1].TabForm).LayoutContent.Parent:= TabsArray[Length(TabsArray) - 1].TabItem;
  end else

  // Cart
  if LowerCase(aScreenName) = LowerCase(lbItemCart.Name) then
  begin
    CallForm(TfrmCart, '', True, False, cButtonsColor);
    TfrmCart(TabsArray[Length(TabsArray) - 1].TabForm).LayoutContent.Parent:= TabsArray[Length(TabsArray) - 1].TabItem;

    if Length(DMUnit.CartList) = 0 then
    begin
      TDialogService.ShowMessage('The cart is empty. First you need to add some items from menu.');
      LoadScreenByName(lbItemDashBoard.Name);
    end;
  end else

  // About Us
  if LowerCase(aScreenName) = LowerCase(lbItemAboutUs.Name) then
  begin
    CallForm(TfrmAboutUs, '', True, False, cButtonsColor);
    TfrmAboutUs(TabsArray[Length(TabsArray) - 1].TabForm).LayoutContent.Parent:= TabsArray[Length(TabsArray) - 1].TabItem;
  end;
end;

procedure TfrmMain.AllTabsExceptDashboard(const aScreenName: string = '');
var
  ifor: Integer;
begin
  for ifor:= 0 to pred(Length(TabsArray)) do
    if Assigned(TabsArray[ifor].TabItem) then
      if (LowerCase(TabsArray[ifor].TabItem.Name) = LowerCase('tab' + aScreenName)) then
      begin
        if Assigned(TabsArray[ifor].TabForm) and (TabsArray[ifor].TabForm is TfrmCart) and (Length(DMUnit.CartList) = 0) then
        begin
          TDialogService.ShowMessage('The cart is empty. First you need to add some items from menu.');
          Exit;
        end;

        tbMain.Visible:= not (TabsArray[ifor].TabForm is TfrmDashboard);
        btnSideMenu.Visible:= TabsArray[ifor].IsbtnMenuVisible;
        btnBack.Visible:= TabsArray[ifor].IsbtnBackVisible;
        btnSideMenu.IconTintColor:= TabsArray[ifor].MenuButtonsColor;
        btnBack.IconTintColor:= TabsArray[ifor].MenuButtonsColor;
        btnBack.StylesData['Text.TextSettings.FontColor']:= TValue.From<TAlphaColor>(TabsArray[ifor].MenuButtonsColor);

        if btnBack.Visible then
          btnBack.Hint:= TabsArray[ifor].TabItem.Name
        else
          btnBack.Hint:= '';

        lbItemDashBoard.Visible:= True;

        if Assigned(TabsArray[ifor].TabForm) then
        begin
          tbMain.StylesData['CAPTION.TEXT']:= TForm(TabsArray[ifor].TabForm).Caption;

          if TabsArray[ifor].TabForm is TfrmCart then
            TfrmCart(TabsArray[ifor].TabForm).BuildCartList();
        end;

        TabsArray[ifor].TabItem.IsSelected:= True;

        Exit;
      end;
end;

procedure TfrmMain.JustDashboard(const aScreenName: string = '');
var
  ifor: Integer;
begin
  for ifor:= 0 to pred(Length(TabsArray)) do
    if Assigned(TabsArray[ifor].TabItem) then
      if (LowerCase(TabsArray[ifor].TabItem.Name) = LowerCase('tab' + aScreenName)) then
      begin
        tbMain.Visible:= not (TabsArray[ifor].TabForm is TfrmDashboard);

        if TabsArray[ifor].TabForm is TfrmDashboard then
        begin
          TfrmDashboard(TabsArray[ifor].TabForm).btnBack.Visible:= False;
          TfrmDashboard(TabsArray[ifor].TabForm).btnBack.Hint:= '';

          TfrmDashboard(TabsArray[ifor].TabForm).btnMenu.OnClick:= btnDashboardClick;
          TfrmDashboard(TabsArray[ifor].TabForm).btnCart.OnClick:= btnDashboardClick;
          TfrmDashboard(TabsArray[ifor].TabForm).btnCoupons.OnClick:= btnDashboardClick;
          TfrmDashboard(TabsArray[ifor].TabForm).btnGallery.OnClick:= btnDashboardClick;
          TfrmDashboard(TabsArray[ifor].TabForm).btnAccount.OnClick:= btnDashboardClick;
          TfrmDashboard(TabsArray[ifor].TabForm).btnAboutUs.OnClick:= btnDashboardClick;

          lbItemDashBoard.Visible:= False;
          btnBack.Visible:= False;
          btnBack.Hint:= '';
        end;

        if Assigned(TabsArray[ifor].TabForm) then
          tbMain.StylesData['CAPTION.TEXT']:= TForm(TabsArray[ifor].TabForm).Caption;

        TabsArray[ifor].TabItem.IsSelected:= True;

        Exit;
      end;
end;

procedure TfrmMain.CallForm(aFormClass: TClassOfForm = nil; const abtnBackHint: String = ''; aIsMenuButtonVisible: Boolean = True; aIsBackButtonVisible: Boolean = False; aButtonsTintColor: TAlphaColor = $FF631F70);
begin
  btnSideMenu.Visible:= aIsMenuButtonVisible;
  btnSideMenu.IconTintColor:= aButtonsTintColor;

  btnBack.Visible:= aIsBackButtonVisible;
  btnBack.Text:= 'Back';
  btnBack.Hint:= abtnBackHint;
  btnBack.IconTintColor:= aButtonsTintColor;
  btnBack.StylesData['Text.TextSettings.FontColor']:= TValue.From<TAlphaColor>(aButtonsTintColor);

  TabsArray[Length(TabsArray) - 1].MenuButtonsColor:= aButtonsTintColor;
  TabsArray[Length(TabsArray) - 1].IsbtnMenuVisible:= aIsMenuButtonVisible;
  TabsArray[Length(TabsArray) - 1].IsbtnBackVisible:= aIsBackButtonVisible;
  TabsArray[Length(TabsArray) - 1].TabForm:= aFormClass.Create(TabsArray[Length(TabsArray) - 1].TabItem);
  TabsArray[Length(TabsArray) - 1].ActiveFormTabByClass:= TfrmDashboard;

  tbMain.StylesData['CAPTION.TEXT']:= TForm(TabsArray[Length(TabsArray) - 1].TabForm).Caption;
end;

procedure TfrmMain.tShowGetStartedOnStartUpTimer(Sender: TObject);
begin
  if Width > 0 then
  begin
    tShowGetStartedOnStartUp.Enabled:= False;

    LoadScreenByName(lbItemDashboard.Name);
    LoadScreenByName(cGetStarted);
  end;
end;

procedure TfrmMain.tabItembtnCloseClick(Sender: TObject);
var
  ifor: Integer;
begin
  for ifor:= 0 to pred(Length(TabsArray)) do
    if Assigned(TabsArray[ifor].TabItem) then
      if LowerCase(TabsArray[ifor].TabItem.Name) = LowerCase(TSpeedButton(Sender).Hint) then
      begin
        TabForClosingName:= TabsArray[ifor].TabItem.Name;
        tbtnCloseTab.Enabled:= True;
        break;
      end;
end;

function TfrmMain.CheckIsFormAssigned(aFormClass: TClass = nil): Boolean;
var
  ffor: Integer;
begin
  Result:= False;

  for ffor:= 0 to pred(Length(TabsArray)) do
    if Assigned(TabsArray[ffor].TabForm) and (TabsArray[ffor].TabForm is aFormClass) then
    begin
      Result:= True;
      break;
    end;
end;

procedure TfrmMain.tbtnCloseTabTimer(Sender: TObject);
var
  ifor: Integer;
begin
  tbtnCloseTab.Enabled:= False;

  for ifor:= 0 to pred(Length(TabsArray)) do
    if Assigned(TabsArray[ifor].TabItem) then
      if LowerCase(TabsArray[ifor].TabItem.Name) = LowerCase(TabForClosingName) then
      begin
        TabForClosingName:= '';

        tbMain.Visible:= True;

        {$region ' Set active tab '}
        if CheckIsFormAssigned(TabsArray[ifor].ActiveFormTabByClass) then
          SetActiveTab(ifor)
        else
        begin
          // Let's stareted Active form tab by class name
          if not Assigned(TabsArray[ifor].ActiveFormTabByClass) then
            TabsArray[ifor].ActiveFormTabByClass:= TfrmDashboard;

          LoadScreenByName(StringReplace(TabsArray[ifor].ActiveFormTabByClass.ClassName, 'Tfrm', 'lbItem', [rfReplaceAll]));
        end;
        {$endregion}

        {$region ' Clear memory '}
        if Assigned(TabsArray[ifor].TabForm) then
        begin
          TabsArray[ifor].TabForm.Close;
          TabsArray[ifor].TabForm.Free;
          TabsArray[ifor].TabForm:= nil;
        end;

        TabsArray[ifor].TabItem.Name:= '';
        TabsArray[ifor].TabItem.Free;
        TabsArray[ifor].TabItem:= nil;
        TabsArray[ifor].ActiveFormTabByClass:= nil;

        break;
        {$endregion}
      end;
end;

procedure TfrmMain.SetActiveTab(aFor: Integer = -1);
var
  yfor: Integer;
begin
  lbItemDashBoard.Visible:= False;
  btnBack.Visible:= False;
  btnBack.Hint:= '';

  for yfor:= 0 to pred(Length(TabsArray)) do
    if Assigned(TabsArray[yfor].TabForm) and (TabsArray[yfor].TabForm is TabsArray[aFor].ActiveFormTabByClass) then
    begin
      tbMain.StylesData['CAPTION.TEXT']:= TForm(TabsArray[yfor].TabForm).Caption;

      tbMain.Visible:= not (TabsArray[yfor].TabForm is TfrmDashboard);

      if TabsArray[yfor].TabForm is TfrmDashboard then
      begin
        TfrmDashboard(TabsArray[yfor].TabForm).btnBack.Visible:= False;
        TfrmDashboard(TabsArray[yfor].TabForm).btnBack.Hint:= '';
        TfrmDashboard(TabsArray[yfor].TabForm).btnMenu.OnClick:= btnSideMenuClick;

        TfrmDashboard(TabsArray[yfor].TabForm).btnMenu.OnClick:= btnDashboardClick;
        TfrmDashboard(TabsArray[yfor].TabForm).btnCart.OnClick:= btnDashboardClick;
        TfrmDashboard(TabsArray[yfor].TabForm).btnCoupons.OnClick:= btnDashboardClick;
        TfrmDashboard(TabsArray[yfor].TabForm).btnGallery.OnClick:= btnDashboardClick;
        TfrmDashboard(TabsArray[yfor].TabForm).btnAccount.OnClick:= btnDashboardClick;
        TfrmDashboard(TabsArray[yfor].TabForm).btnAboutUs.OnClick:= btnDashboardClick;

        lbItemDashBoard.Visible:= False;
        btnBack.Visible:= False;
        btnBack.Hint:= '';
      end;

      TabsArray[yfor].TabItem.IsSelected:= True;
    end;

  Exit;
end;

procedure TfrmMain.tCloseTabOnSaveTimer(Sender: TObject);
var
  ifor: Integer;
begin
  if Assigned(DMUnit.CloseFormClass) then
  for ifor:= 0 to pred(Length(TabsArray)) do
    if Assigned(TabsArray[ifor].TabForm) then
      if (TabsArray[ifor].TabForm is DMUnit.CloseFormClass) then
      begin
        DMUnit.CloseFormClass:= nil;
        tCloseTabOnSave.Enabled:= False;

        TabForClosingName:= TabsArray[ifor].TabItem.Name;
        tbtnCloseTab.Enabled:= True;
        break;
      end;
end;

procedure TfrmMain.LayoutContentClick(Sender: TObject);
begin
  if mvSliderMenu.IsShowed then
    mvSliderMenu.HideMaster;
end;

procedure TfrmMain.lbMainMenuItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  LoadScreenByName(TListBoxItem(Item).Name);
end;

procedure TfrmMain.btnDashboardClick(Sender: TObject);
begin
  LoadScreenByName(StringReplace(TButton(Sender).Name, 'btn', 'lbItem', [rfReplaceAll]));
end;

procedure TfrmMain.btnSideMenuClick(Sender: TObject);
begin
  if not mvSliderMenu.IsShowed then
    mvSliderMenu.ShowMaster
  else
    mvSliderMenu.HideMaster;
end;

procedure TfrmMain.btnBackClick(Sender: TObject);
begin
  tabItembtnCloseClick(Sender);
end;

end.
