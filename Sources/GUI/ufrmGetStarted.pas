unit ufrmGetStarted;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, FMX.DialogService, System.Rtti,
  {$IFDEF ANDROID}
  AndroidAPI.Helpers, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net,
  Androidapi.JNI.App,
  {$ENDIF}
  {$IFDEF IOS}
  Macapi.Helpers, iOSapi.Foundation, FMX.Helpers.IOS,
  {$ENDIF}

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListBox;

type
  TfrmGetStarted = class(TForm)
    LayoutGetStarted: TLayout;
    PanelBackGround: TPanel;
    rButtonsBG: TRectangle;
    btnGetStarted: TButton;
    LayoutButtons: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    Layout1: TLayout;
    tRestaurantName: TText;
    Layout2: TLayout;
    lbContactInfo: TListBox;
    ListBoxItem2: TListBoxItem;
    procedure FormCreate(Sender: TObject);
    procedure btnGetStartedClick(Sender: TObject);
  private
    procedure ShowInfoAboutRestaurant();
    procedure BuildContsctInfoList();
    procedure ContactInfoButtonClick(Sender: TObject);
    procedure UnSupportedMessage();
  public

  end;

var
  frmGetStarted: TfrmGetStarted;

implementation

uses
  ufrmMain;

{$R *.fmx}

procedure TfrmGetStarted.FormCreate(Sender: TObject);
begin
  Caption:= 'Get Started';
  btnGetStarted.Text:= 'Get Started';

  ShowInfoAboutRestaurant();
  BuildContsctInfoList();
end;

procedure TfrmGetStarted.ShowInfoAboutRestaurant();
begin
  with DMUnit.FDMemTable5 do
  begin
    First;
    tRestaurantName.Text:= FieldByName('Name').AsString;;
  end;
end;

procedure TfrmGetStarted.BuildContsctInfoList();
var
  lLBItem: TListBoxItem;
begin
  lbContactInfo.BeginUpdate;
  try
    lbContactInfo.Clear;

    with DMUnit.FDMemTable6 do
    begin
      First;
      while not Eof do
      begin
        lLBItem:= TListBoxItem.Create(nil);
        lLBItem.StyleLookup:= 'ListboxItemContactInfoNullStyle';
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
  end;
end;

procedure TfrmGetStarted.ContactInfoButtonClick(Sender: TObject);

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

procedure TfrmGetStarted.UnSupportedMessage();
begin
  TDialogService.ShowMessage('It is not supported on this platform.');
end;

procedure TfrmGetStarted.btnGetStartedClick(Sender: TObject);
begin
  DMUnit.CloseFormClass:= TfrmGetStarted;
end;

end.
