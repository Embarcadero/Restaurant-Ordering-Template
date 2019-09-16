unit ufrmAddToCart;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, System.Rtti, FMX.StdCtrls, Data.DB, FMX.DialogService, ufrmOptionsList,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ListBox, FMX.Layouts, FMX.ScrollBox, FMX.Memo,
  FMX.Objects, FMX.Ani, FMX.Edit;

type
  TfrmAddToCart = class(TForm)
    tbMain: TToolBar;
    btnBack: TButton;
    LayoutContent: TLayout;
    VertScrollBox1: TVertScrollBox;
    gplCartItemPreview: TGridPanelLayout;
    LayoutImage: TLayout;
    lbPreviewMenuItem: TListBox;
    ListBoxItem2: TListBoxItem;
    LayoutOptions: TLayout;
    LayoutTotal: TLayout;
    LayoutQuantity: TLayout;
    LayoutDescription: TLayout;
    mDescr: TText;
    Text1: TText;
    tTotalSum: TText;
    LayoutButtons: TLayout;
    btnQPlus: TButton;
    ColorAnimation1: TColorAnimation;
    btnQMinus: TButton;
    ColorAnimation2: TColorAnimation;
    tQuantity: TText;
    tRebuildForm: TTimer;
    Layout1: TLayout;
    btnAddToCart: TButton;
    LayoutOptionTop: TLayout;
    lOptions: TText;
    eOptions: TEdit;
    lbOptions: TListBox;
    ListBoxItem1: TListBoxItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnQPlusClick(Sender: TObject);
    procedure tRebuildFormTimer(Sender: TObject);
    procedure btnQMinusClick(Sender: TObject);
    procedure btnAddToCartClick(Sender: TObject);
  private
    FSuccProc: TProc;
    FCurrentItemID: Integer;
    FQuantity: Integer;
    FItemPrice: Extended;
    FItemName: string;
    FTotalPrice: Extended;

    procedure BuildForm();
    procedure BuildOptionsList();
    procedure OptionsButtonClick(Sender: TObject);
    procedure ReCalcGPLHeight();
  public
    procedure RunForm(const SuccProc: TProc);

    property CurrentItemID: Integer read FCurrentItemID write FCurrentItemID;
    property Quantity: Integer read FQuantity write FQuantity;
    property ItemPrice: Extended read FItemPrice write FItemPrice;
    property ItemName: string read FItemName write FItemName;
    property TotalPrice: Extended read FTotalPrice write FTotalPrice;
  end;

  function ShowAddTotCartForm(aCurrentItemID: Integer = 0): TfrmAddToCart;

var
  frmAddToCart: TfrmAddToCart;

implementation

uses
  ufrmMain;

{$R *.fmx}

function ShowAddTotCartForm(aCurrentItemID: Integer = 0): TfrmAddToCart;
begin
  if Assigned(frmAddToCart) then
    frmAddToCart.Free;

  frmAddToCart:= TfrmAddToCart.Create(Application);
  frmAddToCart.CurrentItemID:= aCurrentItemID;

  Result:= frmAddToCart;
end;

procedure TfrmAddToCart.RunForm(const SuccProc: TProc);
begin
  FSuccProc:= SuccProc;
  {$IF DEFINED(Win64) or DEFINED(Win32)}
  ShowModal;
  {$ELSE}
  Self.Show;
  {$ENDIF}
end;

procedure TfrmAddToCart.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FSuccProc) then
  begin
    FSuccProc();
    FSuccProc:= nil;
  end;
end;

procedure TfrmAddToCart.FormShow(Sender: TObject);
begin
  eOptions.Text:= 'Multi choice - min 1 - max 5';
  eOptions.StylesData['Button.OnClick']:= TValue.From<TNotifyEvent>(OptionsButtonClick);
  Quantity:= 1;
  ItemPrice:= 0;

  BuildForm();
end;

procedure TfrmAddToCart.BuildForm();
var
  lLBItem: TListBoxItem;
  lMemoryStream: TMemoryStream;
begin
  TotalPrice:= 0;
  if CurrentItemID > 0 then
  begin
    with DMUnit.FDMemTable1 do
    begin
      First;
      while not Eof do
      begin
        if (FieldByName('ID').AsInteger = CurrentItemID) then
        begin
          ItemName:= FieldByName('Name').AsString;
          tbMain.StylesData['CAPTION.TEXT']:= ItemName;
          mDescr.Text:= FieldByName('Description').AsString;
          TotalPrice:= FieldByName('Price').AsFloat * Quantity;
          ItemPrice:= FieldByName('Price').AsExtended;
          tQuantity.Text:= IntToStr(Quantity);
          btnQMinus.Enabled:= Quantity > 1;

          lbPreviewMenuItem.BeginUpdate;
          try
            lbPreviewMenuItem.Clear;

            lLBItem:= TListBoxItem.Create(nil);
            lLBItem.StyleLookup:= 'ListboxItemAddToCartStyle';
            lLBItem.Tag:= FieldByName('ID').AsInteger;
            lLBItem.Text:= FieldByName('Name').AsString;
            lLBItem.HitTest:= False;

            {$region ' Load image to stream '}
            if (FieldByName('LageImage').AsString <> '') then
            begin
              lMemoryStream:= TMemoryStream.Create;
              try
                (FieldByName('LageImage') as TBlobField).SaveToStream(lMemoryStream);
                lLBItem.ItemData.Bitmap:= TBitmap.CreateFromStream(lMemoryStream);
              finally
                lMemoryStream.Free;
              end;
            end;
            {$endregion}
            lbPreviewMenuItem.AddObject(lLBItem);
          finally
            lbPreviewMenuItem.EndUpdate;
            BuildOptionsList();
          end;
        end;
        Next;
      end;
    end;
  end else
  begin
    TDialogService.ShowMessage('Error! Item not found.');
    Close;
  end;
end;

procedure TfrmAddToCart.BuildOptionsList();
var
  lOptionsCount: Integer;
  lLBItem: TListBoxItem;
begin
  lOptionsCount:= 0;

  lbOptions.BeginUpdate;
  try
    lbOptions.Clear;

    if CurrentItemID > 0 then
    begin
      with DMUnit.FDMemTable4 do
      begin
        First;
        while not Eof do
        begin
          if (FieldByName('OwnerItemID').AsInteger = CurrentItemID) and
             (FieldByName('IsSelected').AsBoolean)
          then
          begin
            inc(lOptionsCount);

            lLBItem:= TListBoxItem.Create(nil);
            lLBItem.StyleLookup:= 'ListboxItemMenuItemOptionsStyle';
            lLBItem.Tag:= FieldByName('ID').AsInteger;
            lLBItem.Text:= FieldByName('Name').AsString;
            lLBItem.StylesData['Price.Text']:= '$' + FieldByName('Price').AsString;
            lLBItem.StylesData['LayoutLeft.Width']:= 0;

            lLBItem.HitTest:= False;

            TotalPrice:= TotalPrice + (FieldByName('Price').AsExtended * Quantity);

            lbOptions.AddObject(lLBItem);
          end;

          Next;
        end;

      end;
    end;
  finally
    lbOptions.EndUpdate;

    gplCartItemPreview.RowCollection.Items[2].Value:= 60 + (lOptionsCount * 40);

    tTotalSum.Text:= '$' + FloatToStr(TotalPrice);
    ReCalcGPLHeight();
  end;
end;

procedure TfrmAddToCart.OptionsButtonClick(Sender: TObject);
begin
  if CurrentItemID > 0 then
    ShowOptionsForm(CurrentItemID).RunForm(
      procedure()
      begin
        tRebuildForm.Enabled:= True;
      end
    );
end;

procedure TfrmAddToCart.btnQMinusClick(Sender: TObject);
begin
  inc(FQuantity, -1);
  tRebuildForm.Enabled:= True;
end;

procedure TfrmAddToCart.btnQPlusClick(Sender: TObject);
begin
  inc(FQuantity);
  tRebuildForm.Enabled:= True;
end;

procedure TfrmAddToCart.tRebuildFormTimer(Sender: TObject);
begin
  tRebuildForm.Enabled:= False;
  BuildForm();
end;

procedure TfrmAddToCart.btnAddToCartClick(Sender: TObject);
var
  lOwnerIndex: Integer;
begin
  if CurrentItemID > 0 then
  begin
    lOwnerIndex:= DMUnit.AddItemToCart(CurrentItemID, 0, ItemName, citItem, Quantity, ItemPrice);

    with DMUnit.FDMemTable4 do
    begin
      First;
      while not Eof do
      begin
        if (FieldByName('OwnerItemID').AsInteger = CurrentItemID) and
           (FieldByName('IsSelected').AsBoolean)
          then
          begin
            DMUnit.AddItemToCart(FieldByName('ID').AsInteger,
                                 CurrentItemID,
                                 FieldByName('Name').AsString,
                                 citModificator,
                                 Quantity,
                                 FieldByName('Price').AsExtended,
                                 lOwnerIndex);
          end;

        Next;
      end;
    end;
  end;

  Quantity:= 1;
  tRebuildForm.Enabled:= True;
  Close;
end;

procedure TfrmAddToCart.ReCalcGPLHeight();
var
  ifor: Integer;
begin
  gplCartItemPreview.Height:= 0;
  for ifor:= 0 to pred(gplCartItemPreview.RowCollection.Count) do
    gplCartItemPreview.Height:= gplCartItemPreview.Height + gplCartItemPreview.RowCollection.Items[ifor].Value;
end;

procedure TfrmAddToCart.btnBackClick(Sender: TObject);
begin
  Close;
end;

end.
