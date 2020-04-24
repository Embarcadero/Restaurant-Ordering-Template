unit ufrmCoupons;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, System.Rtti, FMX.StdCtrls, Data.DB, FMX.DialogService,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox;

type
  TfrmCoupons = class(TForm)
    LayoutContent: TLayout;
    lbCoupons: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    procedure FormCreate(Sender: TObject);
    procedure lbCouponsItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
  private
    procedure LoadCouponsList();
    procedure lbCouponsItemOnClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmCoupons: TfrmCoupons;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmCoupons.FormCreate(Sender: TObject);
begin
  Caption:= 'Coupons';

  LoadCouponsList();
end;

procedure TfrmCoupons.LoadCouponsList();
var
  lLBItem: TListBoxItem;
  lMemoryStream: TMemoryStream;
begin
  lbCoupons.BeginUpdate;
  with DMUnit.CouponsListTable do
  try
    lbCoupons.Clear;

    First;
    while not Eof do
    begin
      lLBItem:= TListBoxItem.Create(nil);
      lLBItem.StyleLookup:= 'ListboxItemCouponeStyle';

      lLBItem.Tag:= FieldByName('ID').AsInteger;
      lLBItem.Text:= FieldByName('Name').AsString;
      lLBItem.StylesData['ExpiresText.Text']:= 'Expires ' + FormatDateTime('dd/MM/yy', FieldByName('ExpiresDate').AsDateTime) + ' - BST (GMP +0' + FieldByName('GMTPlus').AsString + ':00)';
      lLBItem.Hint:= FieldByName('Discount').AsString;
      lLBItem.ShowHint:= False;
      lLBItem.StylesData['RectDiscount.Visible']:= FieldByName('Discount').AsInteger > 0;
      lLBItem.StylesData['Discount.Text']:= FieldByName('Discount').AsString + '% off';

      {$region ' Load image to stream '}
      if (FieldByName('Image').AsString <> '') then
      begin
        lMemoryStream:= TMemoryStream.Create;
        try
          (FieldByName('Image') as TBlobField).SaveToStream(lMemoryStream);
          lLBItem.ItemData.Bitmap:= TBitmap.CreateFromStream(lMemoryStream);
        finally
          lMemoryStream.Free;
        end;
      end;
      {$endregion}

      lbCoupons.AddObject(lLBItem);

      Next;
    end;
  finally
    lbCoupons.EndUpdate;
  end;
end;

procedure TfrmCoupons.lbCouponsItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  if Assigned(Item) then
    lbCouponsItemOnClick(Item);
end;

procedure TfrmCoupons.lbCouponsItemOnClick(Sender: TObject);
begin
  if (TListBoxItem(Sender).Tag > 0) then
  begin
    DMUnit.OffersPerValue:= DMUnit.OffersPerValue + StrToIntDef(TListBoxItem(Sender).Hint, 0);
    TDialogService.ShowMessage('The selected coupone ' + TListBoxItem(Sender).Hint + '% was successfully added to your cart.');
  end;
end;

end.
