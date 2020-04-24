unit ufrmCart;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, System.Rtti, FMX.StdCtrls, Data.DB, FMX.DialogService,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Objects, FMX.Controls.Presentation, FMX.Edit;

type
  TfrmCart = class(TForm)
    LayoutContent: TLayout;
    VertScrollBox1: TVertScrollBox;
    gplCart: TGridPanelLayout;
    LayoutCart: TLayout;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    lbCart: TListBox;
    ListBoxItem1: TListBoxItem;
    tReBuildForm: TTimer;
    tOfferAmount: TText;
    tOffers: TText;
    tSalesTax: TText;
    tSalesAmount: TText;
    tSubTotal: TText;
    tSubTotalAmount: TText;
    tDeliveryFee: TText;
    tDeliveryFeeAmount: TText;
    eOrderNote: TEdit;
    Layout7: TLayout;
    Layout8: TLayout;
    tTotalWithCollAmount: TText;
    tTotalWithColl: TText;
    tTotalwithDeliveryAmount: TText;
    tTotalwithDelivery: TText;
    Layout9: TLayout;
    btnCheckout: TButton;
    procedure FormCreate(Sender: TObject);
    procedure tReBuildFormTimer(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
  private
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonEditClick(Sender: TObject);
    procedure ReCalcGPLHeight();
  public
    procedure BuildCartList();
  end;

var
  frmCart: TfrmCart;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmCart.FormCreate(Sender: TObject);
begin
  Caption:= 'Cart';

  BuildCartList();

  tOffers.Text:= 'Special Offer (' + IntToStr(DMUnit.OffersPerValue) + '%)';
  tSalesTax.Text:= 'Sales Tax';
  tSubTotal.Text:= 'Subtotal';
  tDeliveryFee.Text:= 'Delivery Fee';
  tTotalWithColl.Text:= 'Total with Collection';
  tTotalwithDelivery.Text:= 'Total with Delivery';
end;

procedure TfrmCart.BuildCartList();

  function GetItemAmount(aCartItemIndex: Integer = -1): Extended;
  var
    ifor: Integer;
  begin
    Result:= 0;

    with DMUnit do
    for ifor:= 0 to pred(Length(CartList)) do
      if (CartList[ifor].Index = aCartItemIndex) or (CartList[ifor].OwnerIndex = aCartItemIndex) then
        Result:= Result + CartList[ifor].Price * CartList[ifor].Quantity;
  end;


  function BuildOptionsList(aCartItemIndex: Integer = -1): string;
  var
    ifor: Integer;
  begin
    Result:= '';

    with DMUnit do
    for ifor:= 0 to pred(Length(CartList)) do
      if (CartList[ifor].OwnerIndex = aCartItemIndex) and (CartList[ifor].CartItemType = citModificator) then
        if Result = '' then
          Result:= CartList[ifor].Name
        else
          Result:= Result + ', ' + CartList[ifor].Name;
  end;

var
  lOptionsCount: Integer;
  lLBItem: TListBoxItem;
  ifor: Integer;
begin
  lOptionsCount:= 0;

  lbCart.BeginUpdate;
  with DMUnit do
  try
    lbCart.Clear;

    for ifor:= 0 to pred(Length(CartList)) do
      if (CartList[ifor].OwnerID = 0) and
         (CartList[ifor].OwnerIndex = -1) and
         (CartList[ifor].ID > 0) then
      begin
        inc(lOptionsCount);

        lLBItem:= TListBoxItem.Create(nil);
        lLBItem.StyleLookup:= 'ListboxItemCartStyle';
        lLBItem.Tag:= CartList[ifor].Index;
        lLBItem.Text:= CartList[ifor].Name;
        lLBItem.StylesData['Amount.Text']:= '$' + DMUnit.MyFormatFloat(GetItemAmount(lLBItem.Tag));
        lLBItem.StylesData['Quantity.Text']:= 'x' + FloatToStr(CartList[ifor].Quantity);
        lLBItem.StylesData['Options.Text']:= BuildOptionsList(lLBItem.Tag);
        lLBItem.HitTest:= False;

        lLBItem.StylesData['ButtonDel.Tag']:= lLBItem.Tag;
        lLBItem.StylesData['ButtonEdit.Tag']:= lLBItem.Tag;
        lLBItem.StylesData['ButtonDel.OnClick']:= TValue.From<TNotifyEvent>(ButtonDelClick);
        lLBItem.StylesData['ButtonEdit.OnClick']:= TValue.From<TNotifyEvent>(ButtonEditClick);

        lbCart.AddObject(lLBItem);
      end;

  finally
    lbCart.EndUpdate;

    gplCart.RowCollection.Items[0].Value:= lOptionsCount * 124;

    ReCalcGPLHeight();

    tOffers.Text:= 'Special Offer (' + IntToStr(DMUnit.OffersPerValue) + '%)';
    tOfferAmount.Text:= '-$' + DMUnit.MyFormatFloat(DMUnit.OffersAmount);
    tSalesAmount.Text:= '$' + DMUnit.MyFormatFloat(DMUnit.SalesAmount);
    tSubTotalAmount.Text:= '$' + DMUnit.MyFormatFloat(DMUnit.GetCartTotalAmount() + DMUnit.SalesAmount - DMUnit.OffersAmount);

    if (DMUnit.DeliveryFeeAmount = 0) then
      tDeliveryFeeAmount.Text:= 'Free'
    else
      tDeliveryFeeAmount.Text:= '$' + DMUnit.MyFormatFloat(DMUnit.DeliveryFeeAmount);

    tTotalWithCollAmount.Text:= '$' + DMUnit.MyFormatFloat(DMUnit.GetCartTotalAmount() + DMUnit.SalesAmount - DMUnit.OffersAmount);
    tTotalwithDeliveryAmount.Text:= '$' + DMUnit.MyFormatFloat(DMUnit.GetCartTotalAmount() + DMUnit.SalesAmount + DMUnit.DeliveryFeeAmount - DMUnit.OffersAmount);
  end;
end;

procedure TfrmCart.ButtonDelClick(Sender: TObject);
begin
  if TButton(Sender).Tag >= 0 then
  begin
    DMUnit.DelItemFromCart(TButton(Sender).Tag);
    tReBuildForm.Enabled:= True;
  end;
end;

procedure TfrmCart.ButtonEditClick(Sender: TObject);
begin
  if TButton(Sender).Tag >= 0 then
  begin
    tReBuildForm.Enabled:= True;

    TDialogService.ShowMessage('This function is not implemented.');
  end;
end;

procedure TfrmCart.tReBuildFormTimer(Sender: TObject);
begin
  tReBuildForm.Enabled:= False;

  BuildCartList();
end;

procedure TfrmCart.ReCalcGPLHeight();
var
  ifor: Integer;
begin
  gplCart.Height:= 0;
  for ifor:= 0 to pred(gplCart.RowCollection.Count) do
    gplCart.Height:= gplCart.Height + gplCart.RowCollection.Items[ifor].Value;
end;

procedure TfrmCart.btnCheckoutClick(Sender: TObject);
begin
  { Create your order befor call function for clearing current cart }
  DMUnit.ClearCart();
  DMUnit.OffersPerValue:= 0;

  TDialogService.ShowMessage('Order status: Do not created, beacuse this functionality is not implemented. The cart was automaticaly clear.');

  tReBuildForm.Enabled:= True;
end;

end.
