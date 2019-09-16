unit ufrmGallery;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, System.Rtti, FMX.StdCtrls, Data.DB, FMX.DialogService,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.ListBox;

type
  TfrmGallery = class(TForm)
    LayoutContent: TLayout;
    lbGallery: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    procedure FormCreate(Sender: TObject);
    procedure lbGalleryItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure LoadGalleryList();
    procedure lbGalleryItemOnClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmGallery: TfrmGallery;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmGallery.FormCreate(Sender: TObject);
begin
  Caption:= 'Gallery';

  LoadGalleryList();
end;

procedure TfrmGallery.LoadGalleryList();
var
  lLBItem: TListBoxItem;
  lMemoryStream: TMemoryStream;
begin
  lbGallery.BeginUpdate;
  with DMUnit.FDMemTable3 do
  try
    lbGallery.Clear;

    First;
    while not Eof do
    begin
      lLBItem:= TListBoxItem.Create(nil);
      lLBItem.StyleLookup:= 'ListboxItemGalleryStyle';

      lLBItem.Tag:= FieldByName('ID').AsInteger;
      lLBItem.Text:= FieldByName('Name').AsString;

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

      lbGallery.AddObject(lLBItem);

      Next;
    end;
  finally
    lbGallery.EndUpdate;
  end;
end;

procedure TfrmGallery.lbGalleryItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  if Assigned(Item) then
    lbGalleryItemOnClick(Item);
end;

procedure TfrmGallery.lbGalleryItemOnClick(Sender: TObject);
begin
  if (TListBoxItem(Sender).Tag > 0) then
  begin
    TDialogService.ShowMessage('This function is not implemented.');
  end;
end;

end.
