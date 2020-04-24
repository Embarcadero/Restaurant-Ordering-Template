unit ufrmAboutUs;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, System.Rtti, FMX.StdCtrls, Data.DB, FMX.DialogService,
  {$IFDEF ANDROID}
  AndroidAPI.Helpers, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net,
  Androidapi.JNI.App,
  {$ENDIF}
  {$IFDEF IOS}
  Macapi.Helpers, iOSapi.Foundation, FMX.Helpers.IOS,
  {$ENDIF}

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.ListBox,
  System.ImageList, FMX.ImgList;

type
  TfrmAboutUs = class(TForm)
    LayoutContent: TLayout;
    VertScrollBox1: TVertScrollBox;
    gplAboutUs: TGridPanelLayout;
    LayoutCart: TLayout;
    lbAboutUsLogo: TListBox;
    ListBoxItem1: TListBoxItem;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    lbContactInfo: TListBox;
    ListBoxItem2: TListBoxItem;
    GridPanelLayout1: TGridPanelLayout;
    Button1: TButton;
    ilSocialIcons: TImageList;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Text1: TText;
    Layout8: TLayout;
    tTotalwithDeliveryAmount: TText;
    tTotalwithDelivery: TText;
    Text2: TText;
    Text3: TText;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure ShareButtonOnClick(Sender: TObject);
    procedure ReCalcGPLHeight();
    procedure BuildContsctInfoList();
    procedure ContactInfoButtonClick(Sender: TObject);
    procedure UnSupportedMessage();
  public
    procedure BuildAboutUsInfo();
  end;

var
  frmAboutUs: TfrmAboutUs;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmAboutUs.FormCreate(Sender: TObject);
begin
  Caption:= 'About Us';

  BuildAboutUsInfo();
end;

procedure TfrmAboutUs.BuildAboutUsInfo();
var
  lLBItem: TListBoxItem;
  lMemoryStream: TMemoryStream;
begin
  lbAboutUsLogo.BeginUpdate;
  with DMUnit.AboutUsTable do
  try
    lbAboutUsLogo.Clear;

    First;
    while not Eof do
    begin
      lLBItem:= TListBoxItem.Create(nil);
      lLBItem.StyleLookup:= 'ListboxItemAboutUsStyle';

      lLBItem.Tag:= FieldByName('ID').AsInteger;
      lLBItem.Text:= FieldByName('Name').AsString;

      lLBItem.StylesData['Button.Tag']:= FieldByName('ID').AsInteger;
      lLBItem.StylesData['Button.OnClick']:= TValue.from<TNotifyEvent>(ShareButtonOnClick);
      lLBItem.StylesData['Button.Visible']:= False;

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

      lbAboutUsLogo.AddObject(lLBItem);

      Next;
    end;

  finally
    lbAboutUsLogo.EndUpdate;

    BuildContsctInfoList();
  end;
end;

procedure TfrmAboutUs.ShareButtonOnClick(Sender: TObject);
begin
  if TButton(Sender).Tag > 0 then
  begin
    TDialogService.ShowMessage('This function is not implemented.');
  end;
end;

procedure TfrmAboutUs.ReCalcGPLHeight();
var
  ifor: Integer;
begin
  gplAboutUs.Height:= 0;
  for ifor:= 0 to pred(gplAboutUs.RowCollection.Count) do
    gplAboutUs.Height:= gplAboutUs.Height + gplAboutUs.RowCollection.Items[ifor].Value;
end;

procedure TfrmAboutUs.BuildContsctInfoList();
var
  lOptionsCount: Integer;
  lLBItem: TListBoxItem;
begin
  lOptionsCount:= 0;

  lbContactInfo.BeginUpdate;
  try
    lbContactInfo.Clear;

    with DMUnit.AboutUsDesciptionTable do
    begin
      First;
      while not Eof do
      begin
        inc(lOptionsCount);

        lLBItem:= TListBoxItem.Create(nil);
        lLBItem.StyleLookup:= 'ListboxItemContactInfoStyle';
        lLBItem.Tag:= FieldByName('ID').AsInteger;
        lLBItem.Text:= FieldByName('Description').AsString;
        lLBItem.StylesData['Caption.Text']:= FieldByName('Name').AsString;

        lLBItem.StylesData['Button.Tag']:= lLBItem.Tag;
        lLBItem.StylesData['Button.Visible']:= True;
        lLBItem.StylesData['Button.OnClick']:= TValue.From<TNotifyEvent>(ContactInfoButtonClick);

        case lLBItem.Tag of
          1:
            begin
              lLBItem.StylesData['Button.StyleLookup']:= 'ButtonDirectionsStyle';
              lLBItem.StylesData['Button.Text']:= 'Directions';
            end;
          2:
            begin
              lLBItem.StylesData['Button.StyleLookup']:= 'ButtonPhoneCallStyle';
              lLBItem.StylesData['Button.Text']:= 'Call Now';
            end;
          3:
            begin
              lLBItem.StylesData['Button.StyleLookup']:= 'ButtonEmailStyle';
              lLBItem.StylesData['Button.Text']:= 'Send Email';
            end;
          4: lLBItem.StylesData['Button.Visible']:= False;
        end;

        lLBItem.HitTest:= False;

        lbContactInfo.AddObject(lLBItem);

        Next;
      end;

    end;
  finally
    lbContactInfo.EndUpdate;

    gplAboutUs.RowCollection.Items[1].Value:= 5 + (lOptionsCount * 80);

    ReCalcGPLHeight();
  end;
end;

procedure TfrmAboutUs.ContactInfoButtonClick(Sender: TObject);

  function ClearPhoneNumb(const ANumb: string): string;
  var
    ifor: integer;
  begin
    Result:= '';

    for ifor:= 1 to length(ANumb) do
      if (ANumb[ifor] = '0') or
         (ANumb[ifor] = '1') or
         (ANumb[ifor] = '2') or
         (ANumb[ifor] = '3') or
         (ANumb[ifor] = '4') or
         (ANumb[ifor] = '5') or
         (ANumb[ifor] = '6') or
         (ANumb[ifor] = '7') or
         (ANumb[ifor] = '8') or
         (ANumb[ifor] = '9')
      then
        Result:= Result + ANumb[ifor];
  end;

{$IF DEFINED(ANDROID)}
var
  lIntent: JIntent;
{$ENDIF}

{$IF DEFINED(IOS)}
var
  lNSU: NSUrl;
  lUrl: string;
  lPhoneNumber: string;
{$ENDIF}
begin
  {$IF DEFINED(Win64) or DEFINED(Win32)}
  UnSupportedMessage();
  {$ENDIF}

  case TButton(Sender).Tag of
    1: // Directions
      begin
        TDialogService.ShowMessage('This function is not implemented.');
      end;
    2: // Call Now
      begin
        {$IF DEFINED(ANDROID)}
        lIntent:= TJIntent.Create;
        lIntent.setAction(TJIntent.JavaClass.ACTION_VIEW);
        lIntent.setData(StrToJURI('tel:' + DMUnit.PhoneNumber));
        TAndroidHelper.Activity.startActivity(lIntent);
        {$ENDIF}

        {$IF DEFINED(IOS)}
        lPhoneNumber:= 'tel:' + ClearPhoneNumb(DMUnit.PhoneNumber);
        lNSU:= TNSURL.Wrap(TNSURL.OCClass.URLWithString(StrToNSStr(lPhoneNumber)));
        if SharedApplication.canOpenURL(lNSU) then
          SharedApplication.openUrl(lNSU);
        {$ENDIF}
      end;
    3: // Send Email
      begin
        {$IF DEFINED(ANDROID)}
        lIntent:= TJIntent.Create;
        lIntent.setAction(TJIntent.JavaClass.ACTION_SENDTO);
        lIntent.setData(StrToJURI('mailto:' + DMUnit.EmailUs));
        TAndroidHelper.Activity.startActivity(lIntent);
        {$ENDIF}

        {$IF DEFINED(IOS)}
        lUrl:= 'mailto:' + DMUnit.EmailUs;
        lNSU:= TNSURL.Wrap(TNSURL.OCClass.URLWithString(StrToNSStr(lUrl)));
        if SharedApplication.canOpenURL(lNSU) then
          SharedApplication.openUrl(lNSU);
        {$ENDIF}
      end;
  end;
end;

procedure TfrmAboutUs.UnSupportedMessage();
begin
  TDialogService.ShowMessage('It is not supported on this platform.');
end;

procedure TfrmAboutUs.Button1Click(Sender: TObject);
begin
  TDialogService.ShowMessage('This function is not implemented.');
end;

procedure TfrmAboutUs.Button2Click(Sender: TObject);
begin
  TDialogService.ShowMessage('This function is not implemented.');
end;

procedure TfrmAboutUs.Button3Click(Sender: TObject);
begin
  TDialogService.ShowMessage('This function is not implemented.');
end;

procedure TfrmAboutUs.Button4Click(Sender: TObject);
begin
  TDialogService.ShowMessage('This function is not implemented.');
end;

end.
