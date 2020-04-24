unit uDMUnit;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, System.ImageList, FMX.ImgList,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.DateUtils;

const
  cSalesTax = 20; // In percent
  cEmailUs = 'help@email.com';
  cPhoneNumber = '0(800)111-22-33';

type
  TCartItemType = (citItem, citModificator);

  TCartList = Array of record
    ID: int64;
    OwnerID: int64;
    Name: string;
    CartItemType: TCartItemType;
    Quantity: Extended;
    Price: Extended;
    Index: Integer;
    OwnerIndex: Integer;
  end;

  TDMUnit = class(TDataModule)
    MenuListTable: TFDMemTable;
    MenuListTableID: TIntegerField;
    MenuListTableImage: TBlobField;
    ImageListContactsExample: TImageList;
    MenuListTableLinkTo: TIntegerField;
    MenuListTableName: TStringField;
    MenuListTableDescription: TStringField;
    MenuListTableOpacity: TFloatField;
    MenuListTablePrice: TFloatField;
    CouponsListTable: TFDMemTable;
    IntegerField1: TIntegerField;
    BlobField1: TBlobField;
    StringField1: TStringField;
    CouponsListTableDiscount: TIntegerField;
    CouponsListTableExpiresDate: TDateField;
    CouponsListTableGMTPlus: TIntegerField;
    ilCoupons: TImageList;
    GalleryListTable: TFDMemTable;
    IntegerField2: TIntegerField;
    BlobField2: TBlobField;
    StringField2: TStringField;
    MenuListTableLageImage: TBlobField;
    ilMenuBigImgs: TImageList;
    OptionsListTable: TFDMemTable;
    IntegerField3: TIntegerField;
    StringField3: TStringField;
    OptionsListTablePrice: TFloatField;
    OptionsListTableOwnerItemID: TIntegerField;
    OptionsListTableIsSelected: TBooleanField;
    AboutUsTable: TFDMemTable;
    IntegerField4: TIntegerField;
    BlobField3: TBlobField;
    AboutUsTableName: TStringField;
    AboutUsDesciptionTable: TFDMemTable;
    IntegerField5: TIntegerField;
    StringField4: TStringField;
    StringField9: TStringField;
    ilAboutUs: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    FCloseFormClass: TClass;
    FCartList: TCartList;
    FOffersPercValue: Integer;
    FSalesTax: Extended;
    FEmailUs: string;
    FPhoneNumber: string;

    procedure InsertTestDataForTheMenu();
    procedure InsertTestDataForTheCoupons();
    procedure InsertTestDataForTheGallery();
    procedure InsertTestDataForTheOptions();
    procedure InsertTestDataForAboutUs();
    procedure InsertTestDataForContactInfo();

    procedure AddDataToFDMT1(aID: Integer; aLinkTo: Integer; aOpacity: Extended; const aName: string; const aDescription: string; aPrice: Extended);
    procedure AddDataToFDMT3(aID: Integer; const aName: string);

    function GetCartCount(): Integer;
    function GetOffersAmount(): Extended;
    function GetSalesAmount(): Extended;
    function GetDeliveryFeeAmount(): Extended;
  public
    function AddItemToCart(aItemId: int64 = 0; aOwnerID: int64 = 0; const aItemName: string = ''; aItemType: TCartItemType = citItem; aQuantity: Extended = 1; aItemPrice: Extended = 0; aOwnerIndex: Integer = -1): Integer;
    procedure DelItemFromCart(aItemIndex: Integer = 0);
    procedure ClearCart();
    function GetCartTotalAmount(): Extended;

    function MyFormatFloat(aFloat: Extended = 0; aFloatSigns: Integer = 2): string;

    (* PROPERTIES *)
    property CloseFormClass: TClass read FCloseFormClass write FCloseFormClass;
    property CartList: TCartList read FCartList write FCartList;

    property CartCount: Integer read GetCartCount;
    property OffersPerValue: Integer read FOffersPercValue write FOffersPercValue;
    property SalesTax: Extended read FSalesTax write FSalesTax;

    property OffersAmount: Extended read GetOffersAmount;
    property SalesAmount: Extended read GetSalesAmount;
    property DeliveryFeeAmount: Extended read GetDeliveryFeeAmount;
    property EmailUs: string read FEmailUs write FEmailUs;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
  end;

var
  DMUnit: TDMUnit;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDMUnit.DataModuleCreate(Sender: TObject);
begin
  // Test offers and Tax values
  OffersPerValue:= 0;
  SalesTax:= cSalesTax;
  EmailUs:= cEmailUs;
  PhoneNumber:= cPhoneNumber;

  InsertTestDataForTheMenu();
  InsertTestDataForTheOptions();
  InsertTestDataForTheCoupons();
  InsertTestDataForTheGallery();
  InsertTestDataForAboutUs();
  InsertTestDataForContactInfo();
end;

procedure TDMUnit.AddDataToFDMT1(aID: Integer; aLinkTo: Integer; aOpacity: Extended; const aName: string; const aDescription: string; aPrice: Extended);
begin
  MenuListTable.Insert;
  MenuListTable.FieldByName('ID').AsInteger:= aID;
  MenuListTable.FieldByName('LinkTo').AsInteger:= aLinkTo;
  MenuListTable.FieldByName('Opacity').AsFloat:= aOpacity;
  MenuListTable.FieldByName('Name').AsString:= aName;
  MenuListTable.FieldByName('Description').AsString:= aDescription;
  MenuListTable.FieldByName('Price').AsFloat:= aPrice;
end;

procedure TDMUnit.InsertTestDataForTheMenu();
var
  lMemoryStream: TMemoryStream;
  lMemoryStreamBig: TMemoryStream;
begin
  {$region ' for top listbox '}
  MenuListTable.Open;

  // 7 item
  AddDataToFDMT1(9, 8, 1, 'Strudel', 'Fantastic taste and delicious aroma of freshly baked strudel.', 4.75);

  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[5].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (MenuListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[5].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (MenuListTable.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  MenuListTable.Post;

  // 8 item
  AddDataToFDMT1(8, 0, 1, '3. Desserts', '', 0);
  MenuListTable.Post;

  // 7 item
  AddDataToFDMT1(7, 5, 0.4, 'Pasta presto', 'Fine and delicate parmesan flavor...', 9.30);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[4].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (MenuListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[4].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (MenuListTable.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  MenuListTable.Post;

  // 6 item
  AddDataToFDMT1(6, 5, 1, 'Risotto Fresco', 'Creamy white wine risotto with oak-...', 11.00);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[3].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (MenuListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[3].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (MenuListTable.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  MenuListTable.Post;

  // 5 item
  AddDataToFDMT1(5, 0, 1, '2. Mains', '', 0);
  MenuListTable.Post;

  // 4 item
  AddDataToFDMT1(4, 1, 0.4, 'Garlic Bread', 'Freshly baked garlic bread. Soft and lightly...', 3.50);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[2].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (MenuListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[2].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (MenuListTable.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  MenuListTable.Post;

  // 3 item
  AddDataToFDMT1(3, 1, 1, 'Spicy Calamari', 'Tender calamari, lightly breaded and soft...', 4.95);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[1].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (MenuListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[1].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (MenuListTable.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  MenuListTable.Post;

  // 2 item
  AddDataToFDMT1(2, 1, 0.4, 'Garlic Bread', 'Perfect light garlic bread', 10);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (MenuListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (MenuListTable.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  MenuListTable.Post;

  // 1 item
  AddDataToFDMT1(1, 0, 1, '1. Starters', '', 0);
  MenuListTable.Post;
end;

procedure TDMUnit.InsertTestDataForTheOptions();
begin
  OptionsListTable.Open;

  //5. Owner Item 3
  OptionsListTable.Insert;
  OptionsListTable.FieldByName('ID').AsInteger:= 5;
  OptionsListTable.FieldByName('OwnerItemID').AsInteger:= 3;
  OptionsListTable.FieldByName('Price').AsFloat:= 1;
  OptionsListTable.FieldByName('Name').AsString:= 'Garlic';
  OptionsListTable.FieldByName('IsSelected').AsBoolean:= False;
  OptionsListTable.Post;

  //4. Owner Item 3
  OptionsListTable.Insert;
  OptionsListTable.FieldByName('ID').AsInteger:= 4;
  OptionsListTable.FieldByName('OwnerItemID').AsInteger:= 3;
  OptionsListTable.FieldByName('Price').AsFloat:= 1;
  OptionsListTable.FieldByName('Name').AsString:= 'Spicy';
  OptionsListTable.FieldByName('IsSelected').AsBoolean:= True;
  OptionsListTable.Post;

  //3. Owner Item 2
  OptionsListTable.Insert;
  OptionsListTable.FieldByName('ID').AsInteger:= 3;
  OptionsListTable.FieldByName('OwnerItemID').AsInteger:= 2;
  OptionsListTable.FieldByName('Price').AsFloat:= 1;
  OptionsListTable.FieldByName('Name').AsString:= 'Garlic';
  OptionsListTable.FieldByName('IsSelected').AsBoolean:= False;
  OptionsListTable.Post;

  //2. Owner Item 2
  OptionsListTable.Insert;
  OptionsListTable.FieldByName('ID').AsInteger:= 2;
  OptionsListTable.FieldByName('OwnerItemID').AsInteger:= 2;
  OptionsListTable.FieldByName('Price').AsFloat:= 1;
  OptionsListTable.FieldByName('Name').AsString:= 'Sause';
  OptionsListTable.FieldByName('IsSelected').AsBoolean:= False;
  OptionsListTable.Post;

  //1. Owner Item 2
  OptionsListTable.Insert;
  OptionsListTable.FieldByName('ID').AsInteger:= 1;
  OptionsListTable.FieldByName('OwnerItemID').AsInteger:= 2;
  OptionsListTable.FieldByName('Price').AsFloat:= 1;
  OptionsListTable.FieldByName('Name').AsString:= 'Onion';
  OptionsListTable.FieldByName('IsSelected').AsBoolean:= False;
  OptionsListTable.Post;
end;

procedure TDMUnit.InsertTestDataForTheCoupons();
var
  lMemoryStream: TMemoryStream;
begin
  CouponsListTable.Open;

  // 2 item
  CouponsListTable.Insert;
  CouponsListTable.FieldByName('ID').AsInteger:= 2;
  CouponsListTable.FieldByName('Discount').AsInteger:= 10;
  CouponsListTable.FieldByName('ExpiresDate').AsDateTime:= TDate(IncDay(Now, 2));
  CouponsListTable.FieldByName('Name').AsString:= 'Welcom Offer';
  CouponsListTable.FieldByName('GMTPlus').AsInteger:= 1;

  lMemoryStream:= TMemoryStream.Create;
  try
    ilCoupons.Source[1].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (CouponsListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  CouponsListTable.Post;

  // 1 item
  CouponsListTable.Insert;
  CouponsListTable.FieldByName('ID').AsInteger:= 1;
  CouponsListTable.FieldByName('Discount').AsInteger:= 20;
  CouponsListTable.FieldByName('ExpiresDate').AsDateTime:= TDate(IncDay(Now, 5));
  CouponsListTable.FieldByName('Name').AsString:= 'Dessert Coupon';
  CouponsListTable.FieldByName('GMTPlus').AsInteger:= 1;

  lMemoryStream:= TMemoryStream.Create;
  try
    ilCoupons.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (CouponsListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  CouponsListTable.Post;
end;

procedure TDMUnit.AddDataToFDMT3(aID: Integer; const aName: string);
begin
  GalleryListTable.Insert;
  GalleryListTable.FieldByName('ID').AsInteger:= aID;
  GalleryListTable.FieldByName('Name').AsString:= aName;
end;

procedure TDMUnit.InsertTestDataForTheGallery();
var
  lMemoryStream: TMemoryStream;
begin
  GalleryListTable.Open;

  // 4 item
  AddDataToFDMT3(4, 'Photo 4');
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[3].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (GalleryListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  GalleryListTable.Post;

  // 3 item
  AddDataToFDMT3(3, 'Photo 3');
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[2].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (GalleryListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  GalleryListTable.Post;

  // 2 item
  AddDataToFDMT3(2, 'Photo 2');
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[1].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (GalleryListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  GalleryListTable.Post;

  // 1 item
  AddDataToFDMT3(1, 'Photo 1');
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (GalleryListTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  GalleryListTable.Post;
end;

procedure TDMUnit.InsertTestDataForAboutUs();
var
  lMemoryStream: TMemoryStream;
begin
  AboutUsTable.Open;

  // 1 item
  AboutUsTable.Insert;
  AboutUsTable.FieldByName('ID').AsInteger:= 1;
  AboutUsTable.FieldByName('Name').AsString:= 'LA COZZA INFURIATA';

  lMemoryStream:= TMemoryStream.Create;
  try
    ilAboutUs.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (AboutUsTable.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  AboutUsTable.Post;
end;

procedure TDMUnit.InsertTestDataForContactInfo();
begin
  AboutUsDesciptionTable.Open;

  // 4 item
  AboutUsDesciptionTable.Insert;
  AboutUsDesciptionTable.FieldByName('ID').AsInteger:= 4;
  AboutUsDesciptionTable.FieldByName('Name').AsString:= 'ABOUT US';
  AboutUsDesciptionTable.FieldByName('Description').AsString:= 'Fresh, organic produce cooked to order.';
  AboutUsDesciptionTable.Post;

  // 3 item
  AboutUsDesciptionTable.Insert;
  AboutUsDesciptionTable.FieldByName('ID').AsInteger:= 3;
  AboutUsDesciptionTable.FieldByName('Name').AsString:= 'EMAIL';
  AboutUsDesciptionTable.FieldByName('Description').AsString:= EmailUs;
  AboutUsDesciptionTable.Post;

  // 2 item
  AboutUsDesciptionTable.Insert;
  AboutUsDesciptionTable.FieldByName('ID').AsInteger:= 2;
  AboutUsDesciptionTable.FieldByName('Name').AsString:= 'PHONE NUMBER';
  AboutUsDesciptionTable.FieldByName('Description').AsString:= PhoneNumber;
  AboutUsDesciptionTable.Post;

  // 1 item
  AboutUsDesciptionTable.Insert;
  AboutUsDesciptionTable.FieldByName('ID').AsInteger:= 1;
  AboutUsDesciptionTable.FieldByName('Name').AsString:= 'ADDRESS';
  AboutUsDesciptionTable.FieldByName('Description').AsString:= '150 London Wall Barbican EC2Y 5HN';
  AboutUsDesciptionTable.Post;
end;

function TDMUnit.AddItemToCart(aItemId: int64 = 0; aOwnerID: int64 = 0; const aItemName: string = ''; aItemType: TCartItemType = citItem; aQuantity: Extended = 1; aItemPrice: Extended = 0; aOwnerIndex: Integer = -1): Integer;
begin
  SetLength(FCartList, Length(CartList) + 1);

  Result:= pred(Length(CartList));

  CartList[pred(Length(CartList))].ID:= aItemId;
  CartList[pred(Length(CartList))].Name:= aItemName;
  CartList[pred(Length(CartList))].CartItemType:= aItemType;
  CartList[pred(Length(CartList))].Quantity:= aQuantity;
  CartList[pred(Length(CartList))].Price:= aItemPrice;
  CartList[pred(Length(CartList))].OwnerID:= aOwnerID;
  CartList[pred(Length(CartList))].Index:= pred(Length(CartList));
  CartList[pred(Length(CartList))].OwnerIndex:= aOwnerIndex;
end;

procedure TDMUnit.DelItemFromCart(aItemIndex: Integer = 0);
var
  ifor: Integer;
begin
  for ifor:= 0 to pred(Length(CartList)) do
    if (CartList[ifor].Index = aItemIndex) or
       (CartList[ifor].OwnerIndex = aItemIndex)
    then
    begin
      CartList[ifor].ID:= 0;
      CartList[ifor].Quantity:= 0;
      CartList[ifor].OwnerID:= 0;
      CartList[ifor].Index:= -1;
      CartList[ifor].OwnerIndex:= -1;
    end;
end;

procedure TDMUnit.ClearCart();
begin
  SetLength(FCartList, 0);
end;

function TDMUnit.GetCartCount(): Integer;
var
  ifor: Integer;
begin
  Result:= 0;
  for ifor:= 0 to pred(Length(CartList)) do
    if (CartList[ifor].ID > 0) and
       (CartList[ifor].OwnerID = 0) then
      Result:= Result + 1;
end;

function TDMUnit.GetCartTotalAmount(): Extended;
var
  ifor: Integer;
begin
  Result:= 0;

  for ifor:= 0 to pred(Length(CartList)) do
    if CartList[ifor].ID > 0 then
      Result:= Result + (CartList[ifor].Price * CartList[ifor].Quantity);
end;

function TDMUnit.GetOffersAmount(): Extended;
begin
  Result:= (GetCartTotalAmount() * OffersPerValue) / 100;
end;

function TDMUnit.GetSalesAmount(): Extended;
begin
  Result:= (GetCartTotalAmount() * SalesTax) / 100;
end;

function TDMUnit.GetDeliveryFeeAmount(): Extended;
begin
  Result:= 0;
end;

function TDMUnit.MyFormatFloat(aFloat: Extended = 0; aFloatSigns: Integer = 2): string;
var
  lFS: TFormatSettings;
begin
  lFS.DecimalSeparator:= '.';
  Result:= FloatToStrF(aFloat, ffFixed, 18, aFloatSigns, lFS);
end;

end.
