unit Smexperts.Components.ListTable;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Types,
  Classes,
  ComCtrls,
  StdCtrls,
  Controls,
  Graphics,
  Contnrs,
  Forms,
  ImgList;

type
  IInplaceEditor = interface
    ['{654AE9C0-BADA-4105-8235-70EA29B3287D}']

    procedure Show;
    procedure Hide;
    procedure SetFocus;

    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    property Visible: Boolean read GetVisible write SetVisible;

    function GetParent: TWinControl;
    procedure SetParent(Value: TWinControl);
    property Parent: TWinControl read GetParent write SetParent;

    procedure UpdateBounds(r: TRect);

    procedure UpdateItem(ListItem: TListItem);
    procedure UpdateColumn(ListColumn: TListColumn);

    function GetItem: TListItem;
    property Item: TListItem read GetItem;
    function GetColumn: TListColumn;
    property Column: TListColumn read GetColumn;

    function GetWinControl: TWinControl;
    property WinControl: TWinControl read GetWinControl;
  end;

  TInplaceEditorBucketList = class(TBucketList)
  protected
    function GetData(AItem: TListColumn): IInplaceEditor;
    procedure SetData(AItem: TListColumn; const AData: IInplaceEditor);
    function DeleteItem(ABucket: Integer; AIndex: Integer): Pointer; override;
  public
    function Add(AItem: TListColumn; AData: IInplaceEditor): TListColumn;
    function Remove(AItem: TListColumn): IInplaceEditor;

    property Data[AItem: TListColumn]: IInplaceEditor read GetData write SetData; default;
  end;

  TColumnType = (ctNone, ctText, ctList, ctCheck);

  TGetColumnTypeEvent = procedure(Sender: TObject; Column: TListColumn; var ColumnType: TColumnType) of object;
  TGetColumnListItemsEvent = procedure(Sender: TObject; Item: TListItem; Column: TListColumn; Items: TStrings) of object;
  TListItemChangedEvent = procedure(Sender: TObject; Item: TListItem; Column: TListColumn; Text: string) of object;

  TCustomListTable = class(TCustomListView)
  private
    FInplaceEditor: IInplaceEditor;
    FOnGetColumnType: TGetColumnTypeEvent;
    FColumnIndex: Integer;
    FCurrentRow: Integer;
    FActiveColumn: Integer;
    FOnGetColumnListItems: TGetColumnListItemsEvent;
    FOnListItemChanged: TListItemChangedEvent;

    FHeaderHandle: HWND;
    FItemHeight: Integer;

    procedure SetColumnIndex(const Value: Integer);

    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;

    procedure WMNotify(var Message: TWMNotify); message WM_NOTIFY;
    procedure WMParentNotify(var Message: TWMParentNotify); message WM_PARENTNOTIFY;
    procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;

    function GetColumnFromPos(X: Integer): Integer;
    function GetCurrentColumn: TListColumn;
    procedure SetCurrentColumn(const Value: TListColumn);
    procedure ToogleCheckBox(Column: TListColumn);
    procedure SetItemHeight(const Value: Integer);
  protected
    procedure GetListItems(ListItem: TListItem; ListColumn: TListColumn; Items: TStrings);
    function CanEdit(Item: TListItem): Boolean; override;

    function GetColumnType(Column: TListColumn): TColumnType;

    function CreateInplaceEditor(ColumnType: TColumnType): IInplaceEditor; virtual;
    function GetInplaceEditor(Column: TListColumn): IInplaceEditor; virtual;
    procedure ToggleInplaceEditor;
    procedure HideInplaceEditor;
    procedure ShowInplaceEditor(Column: TListColumn);
    procedure UpdateInplaceEditor(Column: TListColumn);
    procedure UpdateInplaceEditorBounds(Column: TListColumn);

    procedure DrawItem(Item: TListItem; Rect: TRect; State: TOwnerDrawState); override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    procedure ChangeListItem(ListItem: TListItem; ListColumn: TListColumn; Text: string);

    property OnGetColumnType: TGetColumnTypeEvent read FOnGetColumnType write FOnGetColumnType;
    property OnGetColumnListItems: TGetColumnListItemsEvent read FOnGetColumnListItems write FOnGetColumnListItems;
    property OnListItemChanged: TListItemChangedEvent read FOnListItemChanged write FOnListItemChanged;

    property ItemHeight: Integer read FItemHeight write SetItemHeight default 16;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ColumnIndex: Integer read FColumnIndex write SetColumnIndex;
    property CurrentColumn: TListColumn read GetCurrentColumn write SetCurrentColumn;
  end;

  TListTable = class(TCustomListTable)
  published
    property Action;
    property Align;
    property AllocBy;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind default bkNone;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Checkboxes;
    property Color;
    property Columns;
    property ColumnClick;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FlatScrollBars;
    property FullDrag;
    property GridLines;
    property HideSelection;
    property Items;
    property ItemHeight;
    property OwnerData;
    property ReadOnly default false;
    property RowSelect;
    property ParentBiDiMode;
    property ParentColor default false;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowColumnHeaders;
    property SortType;
    property TabOrder;
    property TabStop default true;
    property Visible;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnColumnClick;
    property OnColumnDragged;
    property OnColumnRightClick;
    property OnCompare;
    property OnContextPopup;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDataStateChange;
    property OnDblClick;
    property OnDeletion;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnDragDrop;
    property OnDragOver;
    property OnInfoTip;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnSelectItem;
    property OnStartDock;
    property OnStartDrag;

    property OnGetColumnType;
    property OnGetColumnListItems;
    property OnListItemChanged;

  end;

  TInplaceEdit = class(TCustomEdit, IInplaceEditor)
  private
    FListTable: TCustomListTable;
    FItem: TListItem;
    FColumn: TListColumn;
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function GetParent: TWinControl;
    function GetWinControl: TWinControl;
    function GetItem: TListItem;
    function GetColumn: TListColumn;

    procedure WMKillFocus(var Msg: TMessage); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure UpdateBounds(r: TRect);
    procedure UpdateItem(ListItem: TListItem);
    procedure UpdateColumn(ListColumn: TListColumn);

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor CreateNew(AOwner: TComponent; ListTable: TCustomListTable);

    property Item: TListItem read GetItem;
    property Column: TListColumn read GetColumn;
  end;

  TInplaceListBox = class(TCustomListBox, IInplaceEditor)
  private
    FItem: TListItem;
    FColumn: TListColumn;
    FListTable: TCustomListTable;
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function GetParent: TWinControl;
    function GetWinControl: TWinControl;
    function GetItem: TListItem;
    function GetColumn: TListColumn;
    procedure WMKillFocus(var Msg: TMessage); message WM_KILLFOCUS;
  protected
    procedure UpdateBounds(r: TRect);
    procedure UpdateItem(ListItem: TListItem);
    procedure UpdateColumn(ListColumn: TListColumn);

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;

  public
    constructor CreateNew(AOwner: TComponent; ListTable: TCustomListTable);

    property Item: TListItem read GetItem;
    property Column: TListColumn read GetColumn;
  end;

implementation

uses
  CommCtrl;

{ TInplaceEditorBucketList }

function TInplaceEditorBucketList.Add(AItem: TListColumn; AData: IInplaceEditor): TListColumn;
begin
  AData._AddRef;
  Result := TListColumn(inherited Add(AItem, Pointer(AData)));
end;

function TInplaceEditorBucketList.DeleteItem(ABucket, AIndex: Integer): Pointer;
begin
  Result := inherited DeleteItem(ABucket, AIndex);
  IInplaceEditor(Result)._Release;
end;

function TInplaceEditorBucketList.GetData(AItem: TListColumn): IInplaceEditor;
begin
  IInplaceEditor(Result) := IInplaceEditor(inherited Data[AItem]);
end;

function TInplaceEditorBucketList.Remove(AItem: TListColumn): IInplaceEditor;
begin
  IInplaceEditor(Result) := IInplaceEditor(inherited Remove(AItem));
end;

procedure TInplaceEditorBucketList.SetData(AItem: TListColumn; const AData: IInplaceEditor);
begin
  AData._AddRef;
  inherited Data[AItem] := Pointer(AData);
end;

{ TCustomListTable }

function TCustomListTable.CanEdit(Item: TListItem): Boolean;
begin
  Result := false;
end;

constructor TCustomListTable.Create(AOwner: TComponent);
begin
  inherited;
  ViewStyle := vsReport;
  OwnerDraw := true;
  FColumnIndex := 0;
  FActiveColumn := -1;
  FCurrentRow := -1;
  DoubleBuffered := true;

  FItemHeight := 16;
  SmallImages := TImageList.Create(Self);
  SmallImages.Width := 1;
  SmallImages.Height := FItemHeight;
end;

procedure TCustomListTable.DrawItem(Item: TListItem; Rect: TRect; State: TOwnerDrawState);

  procedure DrawItem(r: TRect; s: string; DrawFocused, DrawActive: Boolean; ColumnType: TColumnType);

  var
    Textr: TRect;
    Textb: TRect;
  begin
    Textr := r;
    InflateRect(Textr, -2, 0);

    case ColumnType of
      ctList:
        begin
          Textb := Textr;
          Textr.Right := Textr.Right - (Textr.Bottom - Textr.Top);
          Textb.Left := Textr.Right + 2;

          Canvas.Font := Font;
          DrawText(Canvas.Handle, PChar(s), Length(s), Textr, DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);

          InflateRect(Textb, 0, -1);
          if DrawActive then
            DrawFrameControl(Canvas.Handle, Textb, DFC_SCROLL, DFCS_SCROLLDOWN or DFCS_PUSHED)
          else
            DrawFrameControl(Canvas.Handle, Textb, DFC_SCROLL, DFCS_SCROLLDOWN);
        end;
      ctCheck:
        begin

          InflateRect(Textr, 0, -2);
          //DrawText(Canvas.Handle, PChar(s), Length(s), Textr, DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
          if CompareText('TRUE', s) = 0 then
            DrawFrameControl(Canvas.Handle, Textr, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_CHECKED)
          else
            DrawFrameControl(Canvas.Handle, Textr, DFC_BUTTON, DFCS_BUTTONCHECK);
        end;
    else
      begin
        Canvas.Font := Font;
        DrawText(Canvas.Handle, PChar(s), Length(s), Textr, DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
      end;
    end;
    if DrawFocused then
    begin
      InflateRect(r, -1, -1);
      Canvas.DrawFocusRect(r);
    end;
  end;

  procedure DrawSubItem(SubItem: Integer);
  var
    Itemrect: TRect;
  begin
    Listview_GetSubItemRect(Handle, Item.Index, SubItem, LVIR_LABEL, @Itemrect);

    DrawItem(Itemrect, Item.SubItems[SubItem - 1], Item.Selected and (FColumnIndex = SubItem), Item.Selected and (FActiveColumn = SubItem),
      GetColumnType(Columns[SubItem]));
  end;

var
  i: Integer;
  Itemrect: TRect;
begin
  Listview_GetSubItemRect(Handle, Item.Index, 0, LVIR_LABEL, @Itemrect);
  DrawItem(Itemrect, Item.Caption, Item.Selected and (FColumnIndex = 0), Item.Selected and (FActiveColumn = 0), GetColumnType(Columns[0]));

  for i := 0 to Item.SubItems.Count - 1 do
    DrawSubItem(i + 1);
end;

function TCustomListTable.GetColumnType(Column: TListColumn): TColumnType;
begin
  Result := ctNone;
  if Assigned(FOnGetColumnType) then
    FOnGetColumnType(Self, Column, Result);
end;

function TCustomListTable.GetColumnFromPos(X: Integer): Integer;
var
  i: Integer;
  w: Integer;
begin
  w := 0;

  Result := -1;

  for i := 0 to Columns.Count - 1 do
  begin
    w := w + Columns[i].Width;
    if X <= w then
    begin
      Result := i;
      break;
    end;
  end;

  inherited;
end;

procedure TCustomListTable.ToogleCheckBox(Column: TListColumn);
var
  s: string;
begin
  if Assigned(Selected) then
  begin
    if Column.Index = 0 then
      s := Selected.Caption
    else
      s := Selected.SubItems[Column.Index - 1];

    if CompareText('TRUE', s) = 0 then
      s := 'FALSE'
    else
      s := 'TRUE';

    ChangeListItem(Selected, Column, s);
  end;
end;

procedure TCustomListTable.ToggleInplaceEditor;
begin
  if not GetInplaceEditor(CurrentColumn).Visible then
  begin
    ShowInplaceEditor(CurrentColumn);
  end
  else
  begin
    HideInplaceEditor;
  end;
end;

procedure TCustomListTable.ShowInplaceEditor(Column: TListColumn);
begin
  UpdateInplaceEditor(Column);
  with GetInplaceEditor(Column) do
  begin
    FActiveColumn := ColumnIndex;
    Invalidate;
    Show;
    SetFocus;
  end;
end;

procedure TCustomListTable.HideInplaceEditor;
begin
  FActiveColumn := -1;
  if Assigned(FInplaceEditor) then
  begin
    FInplaceEditor.Hide;
  end;
  SetFocus;
  Invalidate;
end;

procedure TCustomListTable.SetColumnIndex(const Value: Integer);
begin
  FColumnIndex := Value;
  Update;
end;

procedure TCustomListTable.WMLButtonDown(var Message: TWMLButtonDown);
var
  X: Integer;
begin
  if not (csNoStdEvents in ControlStyle) then
  begin
    with Message do
      if (Width > 32768) or (Height > 32768) then
        X := CalcCursorPos.X
      else
        X := Message.XPos;

    FColumnIndex := GetColumnFromPos(X);
  end;

  // clear the old focusrect
  ListView_RedrawItems(Handle, ItemIndex, ItemIndex);
  inherited;

  if FActiveColumn > -1 then
    HideInplaceEditor
  else
  begin
    if FColumnIndex > -1 then
      case GetColumnType(Columns[FColumnIndex]) of
        ctText,
          ctList:
          begin
            if Assigned(Selected) then
            begin
              //ToggleInplaceEditor;
              ShowInplaceEditor(CurrentColumn);
            end;
          end;
        ctCheck:
          begin
            ToogleCheckBox(CurrentColumn);
          end;
      end;
  end;

  // draw the new focusrect
  ListView_RedrawItems(Handle, ItemIndex, ItemIndex);
end;

procedure TCustomListTable.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

function TCustomListTable.GetInplaceEditor(Column: TListColumn): IInplaceEditor;
begin
  if not Assigned(FInplaceEditor) or
    (Assigned(FInplaceEditor) and ((FInplaceEditor.Column <> Column) or (FInplaceEditor.Item <> Selected))) then
    FInplaceEditor := CreateInplaceEditor(GetColumnType(Column));

  Result := FInplaceEditor;
end;

destructor TCustomListTable.Destroy;
begin
  FInplaceEditor := nil;
  inherited;
end;

function TCustomListTable.CreateInplaceEditor(ColumnType: TColumnType): IInplaceEditor;
begin
  case ColumnType of
    ctText: Result := TInplaceEdit.CreateNew(Self, Self);
    ctList: Result := TInplaceListBox.CreateNew(Self, Self);
  else
    Result := TInplaceEdit.Create(Self);
  end;
  Result.Parent := Self;
end;

procedure TCustomListTable.UpdateInplaceEditor(Column: TListColumn);
begin
  if Assigned(Selected) then
  begin
    with GetInplaceEditor(Column) do
    begin
      UpdateItem(Selected);
      UpdateColumn(CurrentColumn);
    end;
    UpdateInplaceEditorBounds(Column);
  end;
end;

function TCustomListTable.GetCurrentColumn: TListColumn;
begin
  if FColumnIndex = -1 then
    Result := nil
  else
    Result := Columns[ColumnIndex];
end;

procedure TCustomListTable.SetCurrentColumn(const Value: TListColumn);
begin
  HideInplaceEditor;
  if Value = nil then
    FColumnIndex := -1
  else
    FColumnIndex := Value.Index;
  Invalidate;
end;

procedure TCustomListTable.WMKeyDown(var Message: TWMKeyDown);
begin
  if ItemIndex <> -1 then
  begin
    case Message.CharCode of
      VK_UP, VK_DOWN: ;
      VK_LEFT: Dec(FColumnIndex);
      VK_RIGHT: Inc(FColumnIndex);
      VK_F4:
        begin
          if GetColumnType(CurrentColumn) <> ctNone then
          begin
            ShowInplaceEditor(CurrentColumn);
          end;
        end;
      VK_SPACE:
        begin
          if FColumnIndex > -1 then
          begin
            //if Columns[FColumnIndex].Tag = COLUMNSTYLE_CHECK then
            //  ToogleActiveCheckBox;
          end;
        end;
    else
      begin
        if GetColumnType(CurrentColumn) <> ctNone then
        begin
          //ShowInplaceEditor(CurrentColumn);
          //SendMessage(GetInplaceEditor(CurrentColumn).WinControl.Handle, Message.Msg, TMessage(Message).WParam, TMessage(Message).LParam);
        end;
      end;
    end;
    if FColumnIndex < 0 then
      FColumnIndex := 0;

    if FColumnIndex >= Columns.Count - 1 then
      FColumnIndex := Columns.Count - 1;

    ListView_RedrawItems(Handle, ItemIndex, ItemIndex);
  end;
  inherited;
end;

procedure TCustomListTable.GetListItems(ListItem: TListItem; ListColumn: TListColumn; Items: TStrings);
begin
  if Assigned(FOnGetColumnListItems) then
    FOnGetColumnListItems(Self, ListItem, ListColumn, Items);
end;

procedure TCustomListTable.ChangeListItem(ListItem: TListItem; ListColumn: TListColumn; Text: string);
begin
  if ListColumn.Index = 0 then
    ListItem.Caption := Text
  else
    ListItem.SubItems[ListColumn.Index - 1] := Text;

  if Assigned(FOnListItemChanged) then
    FOnListItemChanged(Self, ListItem, ListColumn, Text);
end;

procedure TCustomListTable.WMNotify(var Message: TWMNotify);
begin
  inherited;
  if (FHeaderHandle <> 0) and (Message.NMHdr^.hWndFrom = FHeaderHandle) then
    with Message.NMHdr^ do
      case code of
        HDN_ITEMCHANGED:
          begin
            if Assigned(FInplaceEditor) then
              UpdateInplaceEditorBounds(CurrentColumn);
          end;
      end;
end;

procedure TCustomListTable.WMParentNotify(var Message: TWMParentNotify);
begin
  inherited;
  with Message do
    if (Event = WM_CREATE) and (FHeaderHandle = 0) then
    begin
      FHeaderHandle := ChildWnd;
    end;
end;

procedure TCustomListTable.UpdateInplaceEditorBounds(Column: TListColumn);
var
  Itemrect: TRect;
begin
  if Assigned(Selected) then
  begin
    Listview_GetSubItemRect(Handle, Selected.Index, Column.Index, LVIR_LABEL, @Itemrect);
    with GetInplaceEditor(Column) do
      UpdateBounds(Itemrect);
  end;
end;

procedure TCustomListTable.CNMeasureItem(var Message: TWMMeasureItem);
begin
  inherited;
  Message.MeasureItemStruct^.ItemHeight := FItemHeight;
end;

procedure TCustomListTable.SetItemHeight(const Value: Integer);
begin
  FItemHeight := Value;
  // Workaround
  SmallImages.Height := FItemHeight;
  //TODO: Itemheight
  //RecreateWnd;
end;

{ TInplaceEdit }

constructor TInplaceEdit.CreateNew(AOwner: TComponent; ListTable: TCustomListTable);
begin
  inherited Create(AOwner);
  FListTable := ListTable;
  ParentCtl3D := false;
  Ctl3D := false;
  TabStop := false;
  BorderStyle := bsNone;
  DoubleBuffered := false;
  TabStop := false;
  Visible := false;
end;

function TInplaceEdit.GetColumn: TListColumn;
begin
  Result := FColumn;
end;

function TInplaceEdit.GetItem: TListItem;
begin
  Result := FItem;
end;

function TInplaceEdit.GetParent: TWinControl;
begin
  Result := Parent;
end;

function TInplaceEdit.GetVisible: Boolean;
begin
  Result := Visible;
end;

function TInplaceEdit.GetWinControl: TWinControl;
begin
  Result := Self;
end;

procedure TInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: FListTable.HideInplaceEditor;
    VK_RETURN, VK_TAB:
      begin
        FListTable.HideInplaceEditor;
        FListTable.ChangeListItem(FItem, FColumn, Text);
      end;
  else
    ;
  end;
  inherited;
end;

procedure TInplaceEdit.SetVisible(Value: Boolean);
begin
  Visible := Value;
end;

procedure TInplaceEdit.UpdateBounds(r: TRect);
begin
  InflateRect(r, -1, -1);
  SetBounds(r.Left, r.Top, r.Right - r.Left, r.Bottom - r.Top);
end;

procedure TInplaceEdit.UpdateColumn(ListColumn: TListColumn);
begin
  FColumn := ListColumn;
  if Assigned(FItem) and Assigned(FColumn) then
  begin
    if FColumn.Index = 0 then
      Text := FItem.Caption
    else
      Text := FItem.SubItems[FColumn.Index - 1];
  end;
end;

procedure TInplaceEdit.UpdateItem(ListItem: TListItem);
begin
  FItem := ListItem;
  UpdateColumn(FColumn);
end;

procedure TInplaceEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := Message.Result or DLGC_WANTTAB;
end;

procedure TInplaceEdit.WMKillFocus(var Msg: TMessage);
begin
  inherited;
  FListTable.HideInplaceEditor;
end;

{ TInplaceListBox }

constructor TInplaceListBox.CreateNew(AOwner: TComponent; ListTable: TCustomListTable);
begin
  inherited Create(AOwner);
  FListTable := ListTable;
  ParentCtl3D := false;
  Ctl3D := false;
  TabStop := false;
  BorderStyle := bsNone;
  BevelKind := bkFlat;
  DoubleBuffered := false;
  Visible := false;
  Self.IntegralHeight := true;
end;

procedure TInplaceListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    AddBiDiModeExStyle(ExStyle);
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TInplaceListBox.CreateWnd;
begin
  inherited CreateWnd;
  //Windows.SetParent(Handle, 0);
end;

function TInplaceListBox.GetColumn: TListColumn;
begin
  Result := FColumn;
end;

function TInplaceListBox.GetItem: TListItem;
begin
  Result := FItem;
end;

function TInplaceListBox.GetParent: TWinControl;
begin
  Result := Parent;
end;

function TInplaceListBox.GetVisible: Boolean;
begin
  Result := Visible;
end;

function TInplaceListBox.GetWinControl: TWinControl;
begin
  Result := Self;
end;

procedure TInplaceListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE, VK_F4:
      FListTable.HideInplaceEditor;
    VK_RETURN:
      begin
        FListTable.HideInplaceEditor;
        FListTable.ChangeListItem(FItem, FColumn, Items[ItemIndex]);
      end;
  end;
  inherited;
end;

procedure TInplaceListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  ItemIndex := ItemAtPos(Point(X, Y), false);
end;

procedure TInplaceListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ItemIndex > -1 then
  begin
    FListTable.HideInplaceEditor;
    FListTable.ChangeListItem(FItem, FColumn, Items[ItemIndex]);
  end;
  inherited;
end;

procedure TInplaceListBox.SetVisible(Value: Boolean);
begin
  Visible := Value;
end;

procedure TInplaceListBox.UpdateBounds(r: TRect);
var
  h: Integer;
begin
  //r.TopLeft := FListTable.ClientToScreen(r.TopLeft);
  //r.BottomRight := FListTable.ClientToScreen(r.BottomRight);
  if Items.Count < 8 then
    h := ItemHeight * (Items.Count + 1)
  else
    h := ItemHeight * 9;
  SetBounds(r.Left, r.Bottom, r.Right - r.Left, h);
end;

procedure TInplaceListBox.UpdateColumn(ListColumn: TListColumn);
var
  Text: string;
begin
  FColumn := ListColumn;
  if Assigned(FItem) and Assigned(FColumn) then
  begin
    if FColumn.Index = 0 then
      Text := FItem.Caption
    else
      Text := FItem.SubItems[FColumn.Index - 1];

    Items.Clear;
    FListTable.GetListItems(FItem, FColumn, Items);

    ItemIndex := Items.IndexOf(Text);
  end;
end;

procedure TInplaceListBox.UpdateItem(ListItem: TListItem);
begin
  FItem := ListItem;
  UpdateColumn(FColumn);
end;

procedure TInplaceListBox.WMKillFocus(var Msg: TMessage);
begin
  inherited;
  FListTable.HideInplaceEditor;
end;

end.

