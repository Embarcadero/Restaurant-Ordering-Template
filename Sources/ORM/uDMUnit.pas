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
    FDMemTable1: TFDMemTable;
    FDMemTable1ID: TIntegerField;
    FDMemTable1Image: TBlobField;
    ImageListContactsExample: TImageList;
    FDMemTable1LinkTo: TIntegerField;
    FDMemTable1Name: TStringField;
    FDMemTable1Description: TStringField;
    FDMemTable1Opacity: TFloatField;
    FDMemTable1Price: TFloatField;
    FDMemTable2: TFDMemTable;
    IntegerField1: TIntegerField;
    BlobField1: TBlobField;
    StringField1: TStringField;
    FDMemTable2Discount: TIntegerField;
    FDMemTable2ExpiresDate: TDateField;
    FDMemTable2GMTPlus: TIntegerField;
    ilCoupons: TImageList;
    FDMemTable3: TFDMemTable;
    IntegerField2: TIntegerField;
    BlobField2: TBlobField;
    StringField2: TStringField;
    FDMemTable1LageImage: TBlobField;
    ilMenuBigImgs: TImageList;
    FDMemTable4: TFDMemTable;
    IntegerField3: TIntegerField;
    StringField3: TStringField;
    FDMemTable4Price: TFloatField;
    FDMemTable4OwnerItemID: TIntegerField;
    FDMemTable4IsSelected: TBooleanField;
    FDMemTable5: TFDMemTable;
    IntegerField4: TIntegerField;
    BlobField3: TBlobField;
    FDMemTable5Name: TStringField;
    FDMemTable6: TFDMemTable;
    IntegerField5: TIntegerField;
    StringField4: TStringField;
    StringField9: TStringField;
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
  FDMemTable1.Insert;
  FDMemTable1.FieldByName('ID').AsInteger:= aID;
  FDMemTable1.FieldByName('LinkTo').AsInteger:= aLinkTo;
  FDMemTable1.FieldByName('Opacity').AsFloat:= aOpacity;
  FDMemTable1.FieldByName('Name').AsString:= aName;
  FDMemTable1.FieldByName('Description').AsString:= aDescription;
  FDMemTable1.FieldByName('Price').AsFloat:= aPrice;
end;

procedure TDMUnit.InsertTestDataForTheMenu();
var
  lMemoryStream: TMemoryStream;
  lMemoryStreamBig: TMemoryStream;
begin
  {$region ' for top listbox '}
  FDMemTable1.Open;

  // 7 item
  AddDataToFDMT1(9, 8, 1, 'Strudel', 'Fantastic taste and delicious aroma of freshly baked strudel.', 4.75);

  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[5].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable1.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[5].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (FDMemTable1.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  FDMemTable1.Post;

  // 8 item
  AddDataToFDMT1(8, 0, 1, '3. Desserts', '', 0);
  FDMemTable1.Post;

  // 7 item
  AddDataToFDMT1(7, 5, 0.4, 'Pasta presto', 'Fine and delicate parmesan flavor...', 9.30);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[4].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable1.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[4].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (FDMemTable1.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  FDMemTable1.Post;

  // 6 item
  AddDataToFDMT1(6, 5, 1, 'Risotto Fresco', 'Creamy white wine risotto with oak-...', 11.00);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[3].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable1.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[3].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (FDMemTable1.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  FDMemTable1.Post;

  // 5 item
  AddDataToFDMT1(5, 0, 1, '2. Mains', '', 0);
  FDMemTable1.Post;

  // 4 item
  AddDataToFDMT1(4, 1, 0.4, 'Garlic Bread', 'Freshly baked garlic bread. Soft and lightly...', 3.50);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[2].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable1.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[2].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (FDMemTable1.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  FDMemTable1.Post;

  // 3 item
  AddDataToFDMT1(3, 1, 1, 'Spicy Calamari', 'Tender calamari, lightly breaded and soft...', 4.95);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[1].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable1.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[1].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (FDMemTable1.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  FDMemTable1.Post;

  // 2 item
  AddDataToFDMT1(2, 1, 0.4, 'Garlic Bread', 'Perfect light garlic bread', 10);
  // Add small image
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable1.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  // Add big Image
  lMemoryStreamBig:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStreamBig);
    lMemoryStreamBig.Position:= 0;
    (FDMemTable1.FieldByName('LageImage') as TBlobField).LoadFromStream(lMemoryStreamBig);
  finally
    lMemoryStreamBig.Free;
  end;

  FDMemTable1.Post;

  // 1 item
  AddDataToFDMT1(1, 0, 1, '1. Starters', '', 0);
  FDMemTable1.Post;
end;

procedure TDMUnit.InsertTestDataForTheOptions();
begin
  FDMemTable4.Open;

  //5. Owner Item 3
  FDMemTable4.Insert;
  FDMemTable4.FieldByName('ID').AsInteger:= 5;
  FDMemTable4.FieldByName('OwnerItemID').AsInteger:= 3;
  FDMemTable4.FieldByName('Price').AsFloat:= 1;
  FDMemTable4.FieldByName('Name').AsString:= 'Garlic';
  FDMemTable4.FieldByName('IsSelected').AsBoolean:= False;
  FDMemTable4.Post;

  //4. Owner Item 3
  FDMemTable4.Insert;
  FDMemTable4.FieldByName('ID').AsInteger:= 4;
  FDMemTable4.FieldByName('OwnerItemID').AsInteger:= 3;
  FDMemTable4.FieldByName('Price').AsFloat:= 1;
  FDMemTable4.FieldByName('Name').AsString:= 'Spicy';
  FDMemTable4.FieldByName('IsSelected').AsBoolean:= True;
  FDMemTable4.Post;

  //3. Owner Item 2
  FDMemTable4.Insert;
  FDMemTable4.FieldByName('ID').AsInteger:= 3;
  FDMemTable4.FieldByName('OwnerItemID').AsInteger:= 2;
  FDMemTable4.FieldByName('Price').AsFloat:= 1;
  FDMemTable4.FieldByName('Name').AsString:= 'Garlic';
  FDMemTable4.FieldByName('IsSelected').AsBoolean:= False;
  FDMemTable4.Post;

  //2. Owner Item 2
  FDMemTable4.Insert;
  FDMemTable4.FieldByName('ID').AsInteger:= 2;
  FDMemTable4.FieldByName('OwnerItemID').AsInteger:= 2;
  FDMemTable4.FieldByName('Price').AsFloat:= 1;
  FDMemTable4.FieldByName('Name').AsString:= 'Sause';
  FDMemTable4.FieldByName('IsSelected').AsBoolean:= False;
  FDMemTable4.Post;

  //1. Owner Item 2
  FDMemTable4.Insert;
  FDMemTable4.FieldByName('ID').AsInteger:= 1;
  FDMemTable4.FieldByName('OwnerItemID').AsInteger:= 2;
  FDMemTable4.FieldByName('Price').AsFloat:= 1;
  FDMemTable4.FieldByName('Name').AsString:= 'Onion';
  FDMemTable4.FieldByName('IsSelected').AsBoolean:= False;
  FDMemTable4.Post;
end;

procedure TDMUnit.InsertTestDataForTheCoupons();
var
  lMemoryStream: TMemoryStream;
begin
  FDMemTable2.Open;

  // 2 item
  FDMemTable2.Insert;
  FDMemTable2.FieldByName('ID').AsInteger:= 2;
  FDMemTable2.FieldByName('Discount').AsInteger:= 10;
  FDMemTable2.FieldByName('ExpiresDate').AsDateTime:= TDate(IncDay(Now, 2));
  FDMemTable2.FieldByName('Name').AsString:= 'Welcom Offer';
  FDMemTable2.FieldByName('GMTPlus').AsInteger:= 1;

  lMemoryStream:= TMemoryStream.Create;
  try
    ilCoupons.Source[1].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable2.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  FDMemTable2.Post;

  // 1 item
  FDMemTable2.Insert;
  FDMemTable2.FieldByName('ID').AsInteger:= 1;
  FDMemTable2.FieldByName('Discount').AsInteger:= 20;
  FDMemTable2.FieldByName('ExpiresDate').AsDateTime:= TDate(IncDay(Now, 5));
  FDMemTable2.FieldByName('Name').AsString:= 'Dessert Coupon';
  FDMemTable2.FieldByName('GMTPlus').AsInteger:= 1;

  lMemoryStream:= TMemoryStream.Create;
  try
    ilCoupons.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable2.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  FDMemTable2.Post;
end;

procedure TDMUnit.AddDataToFDMT3(aID: Integer; const aName: string);
begin
  FDMemTable3.Insert;
  FDMemTable3.FieldByName('ID').AsInteger:= aID;
  FDMemTable3.FieldByName('Name').AsString:= aName;
end;

procedure TDMUnit.InsertTestDataForTheGallery();
var
  lMemoryStream: TMemoryStream;
begin
  FDMemTable3.Open;

  // 4 item
  AddDataToFDMT3(4, 'Photo 4');
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[3].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable3.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  FDMemTable3.Post;

  // 3 item
  AddDataToFDMT3(3, 'Photo 3');
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[2].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable3.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  FDMemTable3.Post;

  // 2 item
  AddDataToFDMT3(2, 'Photo 2');
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[1].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable3.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  FDMemTable3.Post;

  // 1 item
  AddDataToFDMT3(1, 'Photo 1');
  lMemoryStream:= TMemoryStream.Create;
  try
    ImageListContactsExample.Source[0].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable3.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  FDMemTable3.Post;
end;

procedure TDMUnit.InsertTestDataForAboutUs();
var
  lMemoryStream: TMemoryStream;
begin
  FDMemTable5.Open;

  // 1 item
  FDMemTable5.Insert;
  FDMemTable5.FieldByName('ID').AsInteger:= 1;
  FDMemTable5.FieldByName('Name').AsString:= 'LA COZZA INFURIATA';

  lMemoryStream:= TMemoryStream.Create;
  try
    ilMenuBigImgs.Source[6].MultiResBitmap.Bitmaps[1].SaveToStream(lMemoryStream);
    lMemoryStream.Position:= 0;
    (FDMemTable5.FieldByName('Image') as TBlobField).LoadFromStream(lMemoryStream);
  finally
    lMemoryStream.Free;
  end;

  FDMemTable5.Post;
end;

procedure TDMUnit.InsertTestDataForContactInfo();
begin
  FDMemTable6.Open;

  // 4 item
  FDMemTable6.Insert;
  FDMemTable6.FieldByName('ID').AsInteger:= 4;
  FDMemTable6.FieldByName('Name').AsString:= 'ABOUT US';
  FDMemTable6.FieldByName('Description').AsString:= 'Fresh, organic produce cooked to order.';
  FDMemTable6.Post;

  // 3 item
  FDMemTable6.Insert;
  FDMemTable6.FieldByName('ID').AsInteger:= 3;
  FDMemTable6.FieldByName('Name').AsString:= 'EMAIL';
  FDMemTable6.FieldByName('Description').AsString:= EmailUs;
  FDMemTable6.Post;

  // 2 item
  FDMemTable6.Insert;
  FDMemTable6.FieldByName('ID').AsInteger:= 2;
  FDMemTable6.FieldByName('Name').AsString:= 'PHONE NUMBER';
  FDMemTable6.FieldByName('Description').AsString:= PhoneNumber;
  FDMemTable6.Post;

  // 1 item
  FDMemTable6.Insert;
  FDMemTable6.FieldByName('ID').AsInteger:= 1;
  FDMemTable6.FieldByName('Name').AsString:= 'ADDRESS';
  FDMemTable6.FieldByName('Description').AsString:= '150 London Wall Barbican EC2Y 5HN';
  FDMemTable6.Post;
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

end.
