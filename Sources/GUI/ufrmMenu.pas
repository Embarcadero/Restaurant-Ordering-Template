unit ufrmMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, System.Rtti, FMX.StdCtrls, Data.DB, ufrmAddToCart,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox, FMX.Controls.Presentation;

type
  TfrmMenu = class(TForm)
    LayoutContent: TLayout;
    lbMenu: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    LayoutCheckOut: TLayout;
    btnCheckOut: TButton;
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadMenuList();
    procedure MenuItemButtonOnClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmMenu: TfrmMenu;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  Caption:= 'Menu';

  LayoutCheckOut.Visible:= False;
  btnCheckOut.HitTest:= False;
  LoadMenuList();
end;

procedure TfrmMenu.LoadMenuList();
var
  lLBItem: TListBoxItem;
  lMemoryStream: TMemoryStream;
begin
  lbMenu.BeginUpdate;
  with DMUnit.MenuListTable do
  try
    lbMenu.Clear;

    First;
    while not Eof do
    begin
      lLBItem:= TListBoxItem.Create(nil);
      lLBItem.Tag:= FieldByName('ID').AsInteger;
      lLBItem.Text:= FieldByName('Name').AsString;

      lLBItem.StylesData['background.Opacity']:= FieldByName('Opacity').AsFloat;

      if FieldByName('LinkTo').AsInteger = 0 then
        lLBItem.StyleLookup:= 'ListboxItemMenuStyle'
      else
      begin
        lLBItem.StyleLookup:= 'ListboxItemMenuImgStyle';

        lLBItem.StylesData['Description.Text']:= FieldByName('Description').AsString;
        lLBItem.StylesData['Price.Text']:= '$' + DMUnit.MyFormatFloat(FieldByName('Price').AsFloat);

        lLBItem.StylesData['Button.Tag']:= FieldByName('ID').AsInteger;
        lLBItem.StylesData['Button.OnClick']:= TValue.from<TNotifyEvent>(MenuItemButtonOnClick);

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
      end;

      lbMenu.AddObject(lLBItem);

      Next;
    end;
  finally
    lbMenu.EndUpdate;
  end;
end;

procedure TfrmMenu.MenuItemButtonOnClick(Sender: TObject);
begin
  if TButton(Sender).Tag > 0 then
  begin
    ShowAddTotCartForm(TButton(Sender).Tag).RunForm(
      procedure()
      begin
        if (Length(DMUnit.CartList) > 0) then
        begin
          LayoutCheckOut.Visible:= True;
          btnCheckOut.HitTest:= True;
        end;
      end
    );
  end;
end;

end.
