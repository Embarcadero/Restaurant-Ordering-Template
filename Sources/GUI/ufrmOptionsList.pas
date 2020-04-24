unit ufrmOptionsList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uDMUnit, System.Rtti, FMX.StdCtrls, Data.DB, FMX.DialogService,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ListBox, FMX.Layouts;

type
  TfrmOptionsList = class(TForm)
    lbOptions: TListBox;
    ListBoxItem1: TListBoxItem;
    tbMain: TToolBar;
    btnBack: TButton;
    tRebuilForm: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure lbOptionsItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure btnBackClick(Sender: TObject);
    procedure tRebuilFormTimer(Sender: TObject);
  private
    FSuccProc: TProc;
    FCurrentItemID: Integer;

    procedure BuildOptionsList();
    procedure OptionItemSelect(Sender: TObject);
  public
    procedure RunForm(const SuccProc: TProc);

    property CurrentItemID: Integer read FCurrentItemID write FCurrentItemID;
  end;

  function ShowOptionsForm(aCurrentItemID: Integer = 0): TfrmOptionsList;

var
  frmOptionsList: TfrmOptionsList;

implementation

uses
  ufrmMain;

{$R *.fmx}

function ShowOptionsForm(aCurrentItemID: Integer = 0): TfrmOptionsList;
begin
  if Assigned(frmOptionsList) then
    frmOptionsList.Free;

  frmOptionsList:= TfrmOptionsList.Create(Application);
  frmOptionsList.CurrentItemID:= aCurrentItemID;

  Result:= frmOptionsList;
end;

procedure TfrmOptionsList.RunForm(const SuccProc: TProc);
begin
  FSuccProc:= SuccProc;
  {$IF DEFINED(Win64) or DEFINED(Win32)}
  ShowModal;
  {$ELSE}
  Self.Show;
  {$ENDIF}
end;

procedure TfrmOptionsList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FSuccProc) then
  begin
    FSuccProc();
    FSuccProc:= nil;
  end;
end;

procedure TfrmOptionsList.FormShow(Sender: TObject);
begin
  tbMain.StylesData['CAPTION.TEXT']:= 'Dish Options';

  BuildOptionsList();
end;

procedure TfrmOptionsList.BuildOptionsList();
var
  lLBItem: TListBoxItem;
begin
  lbOptions.BeginUpdate;
  try
    lbOptions.Clear;

    if CurrentItemID > 0 then
    begin
      with DMUnit.OptionsListTable do
      begin
        First;
        while not Eof do
        begin
          if (FieldByName('OwnerItemID').AsInteger = CurrentItemID) then
          begin
            lLBItem:= TListBoxItem.Create(nil);
            lLBItem.StyleLookup:= 'ListboxItemMenuItemOptionsStyle';
            lLBItem.Tag:= FieldByName('ID').AsInteger;
            lLBItem.Text:= FieldByName('Name').AsString;
            lLBItem.StylesData['Price.Text']:= '$' + FieldByName('Price').AsString;
            lLBItem.StylesData['Button.HitTest']:= False;

            if FieldByName('IsSelected').AsBoolean then
              lLBItem.StylesData['Button.IconTintColor']:= TValue.From<TAlphaColor>($FF272727)
            else
              lLBItem.StylesData['Button.IconTintColor']:= TValue.From<TAlphaColor>($FFFEFEFE);

            lbOptions.AddObject(lLBItem);
          end;

          Next;
        end;

      end;
    end;
  finally
    lbOptions.EndUpdate;
  end;
end;

procedure TfrmOptionsList.lbOptionsItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  OptionItemSelect(Item);
end;

procedure TfrmOptionsList.OptionItemSelect(Sender: TObject);
begin
  if TListBoxItem(Sender).Tag > 0 then
    with DMUnit.OptionsListTable do
    begin
      First;
      while not Eof do
      begin
        if (FieldByName('ID').AsInteger = TListBoxItem(Sender).Tag) then
        begin
          Edit;
          FieldByName('IsSelected').AsBoolean:= not FieldByName('IsSelected').AsBoolean;
          Post;
        end;

        Next;
      end;

      tRebuilForm.Enabled:= True;
    end;
end;

procedure TfrmOptionsList.tRebuilFormTimer(Sender: TObject);
begin
  tRebuilForm.Enabled:= False;

  BuildOptionsList();
end;

procedure TfrmOptionsList.btnBackClick(Sender: TObject);
begin
  Close;
end;

end.
