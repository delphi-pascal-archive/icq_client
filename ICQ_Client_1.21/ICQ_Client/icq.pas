unit icq;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ICQClient, ICQWorks, ExtCtrls, ComCtrls, ImgList,
  Menus, Spin;

const
  // Status Icons
  ICON_ONLINE = 0;
  ICON_AWAY = 1;
  ICON_DND = 2;
  ICON_NA = 3;
  ICON_INVISIBLE = 4;
  ICON_OFFLINE = 5;
  ICON_OCCUPIED = 6;
  ICON_FFC = 7;

  // Listview Indexes
  LV_INDEX_STATUS = 0;            //STATUS
  LV_INDEX_INTIP = 1;             //Internal IP
  LV_INDEX_EXTIP = 2;             //External IP
  LV_INDEX_PORT = 3;              //Port
  LV_INDEX_PROTOVER = 4;          //ProtoVer
  LV_INDEX_USERCAPS = 5;          //UserCaps
  LV_INDEX_ONLINETIME = 6;        //Online since
  LV_INDEX_CLIENT = 7;            //ICQ Client
  LV_INDEX_MIRANDAVER = 8;        //Miranda version
  LV_INDEX_NICK = 9;              //Nick
  LV_INDEX_IDLE = 10;

  //Not specified
  NA = '<not specified>';

  // Declare the cursor constant that contains the resource identifier
  // of the system Hand cursor.
  // IDC_HAND = MakeIntResource(32649);
  // Declare the cursor constant for our own use. Constant value must
  // not conflict with any existing Delphi cursor constant.
  NIDC_HAND = 32649;
  USERINFO_ENTRIES = 6;
  WM_NOTIFYICON = wm_user + 400;
  MY_WS_EX_LAYERED = $00080000;
  MY_LWA_ALPHA = $00000002;

type
  _DBCONTACTSETTINGS = record
    dwUIN: DWORD;
    dwStatus: DWORD;
    sInternalIP, sExternalIP: String[15];
    wPort: Word;
    byProtoVer, byUserCaps: Byte;
    dtOnlineTime: TDateTime;
    dwClient, dwMirandaVer: DWORD;
    sNick: String[20];                  // Nick max. 20 chars
  end;

type
  _DBSETTINGS = record
    dwLastStatus: DWORD;                   // Last Status
    bOnTop: Boolean;                       // Window StayOnTop
    sTitleText: String[15];                // Titlebar Text
    bHide: Boolean;                        // Hide or Close main window
    bTransparent: Boolean;                 // Window Transparency
    iBlendValue: Integer;                  // Transparecy level
    iLeft, iTop, iHeight, iWidth: Integer; // Position & Size
    ProxyType: TProxyType;                 // Proxy type
    ProxyAuth: Boolean;                    // Proxy requires auth
    ProxyHost: String[50];                 // Proxy server
    ProxyPass: String[50];                 // Proxy passwd
    ProxyUserID: String[50];               // Username
    ProxyPort: Word;                       // Proxy port
    ProxyResolve: Boolean;                 // Resolve hostnames through proxy
    UIN: DWORD;                            // UIN
    Password: String[15];                  // Passwd
    ICQServer: String[50];                 // ICQ login server
    ICQPort: Word;                         // ICQ Port
    KeepAlive: Boolean;                    // Keep connection alive
    OnSaver, OnWLock: Boolean;             // AutoAway
    OnMouse, SetNA: Boolean;
    AwayTime, NATime: Word;
    MsgAway, MsgNA, MsgDND: String[100];   // AutoAway msgs
    MsgOccupied, MsgFFC: String[100];
  end;  

type
  TForm1 = class(TForm)
    ICQClient1: TICQClient;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    Label4: TLabel;
    Label15: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edit10: TEdit;
    SpinEdit2: TSpinEdit;
    Label21: TLabel;
    popupStatus: TPopupMenu;
    Offline2: TMenuItem;
    Online2: TMenuItem;
    Away2: TMenuItem;
    NA2: TMenuItem;
    Occupied2: TMenuItem;
    DND2: TMenuItem;
    Freeforchat1: TMenuItem;
    Invisible2: TMenuItem;
    AdvIconList: TImageList;
    Memo2: TMemo;
    Label5: TLabel;
    Edit1: TEdit;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure ICQClient1MessageRecv(Sender: TObject; Msg, UIN: String);
    procedure ICQClient1Error(Sender: TObject; ErrorType: TErrorType;
      ErrorMsg: String);
    procedure ICQClient1Login(Sender: TObject);
    procedure ICQClient1OfflineMsgRecv(Sender: TObject;
      DateTime: TDateTime; Msg, UIN: String);
    procedure Offline2Click(Sender: TObject);
    procedure Label21MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label21Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure DoStatusChange(NewStatus: LongWord);
    { Public declarations }
  end;

type
  _DBCONTACTSETTINGSFILE = file of _DBCONTACTSETTINGS;

type
  _DBSETTINGSFILE = file of _DBSETTINGS;

type
  TSetLayeredWindowAttributes = function (Hwnd: THandle; crKey: COLORREF; bAlpha: Byte; dwFlags: DWORD): Boolean; stdcall;

var
  fDCFlag: LongWord = S_ALLOWDCONN;  //S_ALLOWDAUTH;
  DBData: _DBCONTACTSETTINGS;
  F: _DBCONTACTSETTINGSFILE;
  D: _DBSETTINGSFILE;
  LVItemHeight: Integer = 17;
  IsWinVerNT: Boolean;
  IsWinVerNT4Plus: Boolean;
  IsWinVer98Plus: Boolean;
  IsWinVerMEPlus: Boolean;
  IsWinVer2000Plus: Boolean;
  IsWinVerXPPlus: Boolean;

  OnSaver, OnWLock, OnMouse, SetNA: Boolean;
  lastMousePos: TPoint;
  mouseStationaryTimer: Integer = 0;
  awayModeTimer: Integer = 0;
  awaySet: Integer = 0;
  naSet: Integer = 0;
  AwayTime: Word = 5;
  NATime: Word = 20;
  originalStatusMode: DWORD;
  OnTop: HWND = HWND_TOPMOST;
  bHide: Boolean = False;
  bTransparent: Boolean = True;
  iBlendValue: Byte = 70;
  dwLastStatus: DWORD = S_OFFLINE;
  bMyDetails: Boolean = False;

  OldTestHit: TListItem = nil;
  TestHit: TListItem = nil;

  MsgAway: String = '';
  MsgNA: String = '';
  MsgDND: String = '';
  MsgOccupied: String = '';
  MsgFFC: String = '';

  MyGetLastInputInfo: function(var plii: TLastInputInfo): LongBool; stdcall;

  MySetLayeredWindowAttributes: TSetLayeredWindowAttributes = nil;  

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 if (Edit1.Text='') or (Edit2.Text='')
                             or (StrToInt(Edit1.Text)<10000)
 then
  begin
   MessageBox(0, 'Пожалуйста введите верно UIN и Пароль', 'Невозможно подключиться!', MB_ICONWARNING);
   Exit;
  end;
 ICQClient1.UIN:=StrToInt(Edit1.Text);
 ICQClient1.Password:=Edit2.Text;
 //
 ICQClient1.ICQServer:=Edit10.Text;
 ICQClient1.ICQPort:=SpinEdit2.Value;
 ICQClient1.ConvertToPlaintext:=true;
 //логинимся к серверу в статусе Online
 ICQClient1.Login;
 Button1.Enabled:=false;
 Button2.Enabled:=true;
 Button3.Enabled:=true;
 Label21.Enabled:=true;
 //
 Edit1.Enabled:=false;
 Edit2.Enabled:=false;
 Edit10.Enabled:=false;
 SpinEdit2.Enabled:=false;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 ICQClient1.Disconnect; // отключаемся
 Button1.Enabled:=true;
 Button2.Enabled:=false;
 Button3.Enabled:=false;
 Label21.Enabled:=false;
 //
 Edit1.Enabled:=true;
 Edit2.Enabled:=true;
 Edit10.Enabled:=true;
 SpinEdit2.Enabled:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 // пароль как при входе в Win XP
 Edit2.Font.Name:='Wingdings';
 Edit2.PasswordChar:='l'; // символ "точка"
 // Загрузка контакт листа
 ListBox1.Items.Clear;
 ListBox1.Items.LoadFromFile('contacts.txt');
 Label15.Caption:='Контакт лист: '+IntToStr(ListBox1.Items.Count);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Button3.Click; // Отключение
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 i: integer;
begin
 if (not ICQClient1.LoggedIn)
 then
  begin
   MessageBox(0, 'Пожалуйста подключитесь, прежде чем посылать сообщение', 'Невозможно послать сообщение', MB_ICONWARNING);
   Exit;
  end;
 //
 if ListBox1.SelCount=0
 then
  begin
   MessageBox(0, 'UIN отправителя не выбран!', 'Отправка сообщения', MB_ICONERROR);
   Exit;
  end;
 // функция отправки сообщения
 ICQClient1.SendMessage(StrToInt64(ListBox1.Items.Strings[ListBox1.ItemIndex]),Memo1.Text);
 // добавляем инфу о проделанной работе
 MessageBox(0, PChar('Cообщение отправлено на UIN "'+ListBox1.Items.Strings[ListBox1.ItemIndex]+'"!'), 'Отправка сообщения', MB_ICONINFORMATION);
 Memo1.Clear;
end;

procedure TForm1.ICQClient1MessageRecv(Sender: TObject; Msg, UIN: String);
var
 i: integer;
begin
 Memo2.Lines.Add('Новое сообщение от "'+UIN+'": ');
 Memo2.Lines.Add('');
 Memo2.Lines.Add(Msg);
 Memo2.Lines.Add('');
 Memo2.Lines.Add('--------------------------------------------------------');
 //
 for i:=0 to ListBox1.Items.Count-1 do
  begin
   if UIN=ListBox1.Items.Strings[i]
   then
    begin
     ListBox1.Selected[i]:=true;
     ListBox1.SetFocus;
    end;
  end;
end;

procedure TForm1.ICQClient1Error(Sender: TObject; ErrorType: TErrorType;
  ErrorMsg: String);
begin
 if ErrorType=ERR_WARNING
 then ShowMessage('Warning: '+ErrorMsg)
 else
  begin
   ShowMessage('Error: '+ErrorMsg);
   Button1.Enabled:=true;
   Button2.Enabled:=false;
   Button3.Enabled:=false;
   Label21.Enabled:=false;
   //
   Edit1.Enabled:=true;
   Edit2.Enabled:=true;
   Edit10.Enabled:=true;
   SpinEdit2.Enabled:=true;
  end;
end;

procedure TForm1.ICQClient1OfflineMsgRecv(Sender: TObject;
  DateTime: TDateTime; Msg, UIN: String);
var
 i: integer;
begin
 Memo2.Lines.Add('Новое сообщение от "'+UIN+'":');
 Memo2.Lines.Add('');
 Memo2.Lines.Add(Msg);
 Memo2.Lines.Add('');
 Memo2.Lines.Add('--------------------------------------------------------');
 //
 for i:=0 to ListBox1.Items.Count-1 do
  begin
   if UIN=ListBox1.Items.Strings[i]
   then
    begin
     ListBox1.Selected[i]:=true;
     ListBox1.SetFocus;
    end;
  end;
end;

procedure TForm1.ICQClient1Login(Sender: TObject);
begin
 Online2.Click;
 ICQClient1.RequestOfflineMessages;
end;

////////////////////////////////////////////////////

procedure TForm1.DoStatusChange(NewStatus: LongWord);
var
 img: Byte;

 function SetAutoAwayMsg(AnyMsg: string): string;
 begin
  while Pos('%time%', AnyMsg)<>0 do
   begin
    Insert(TimeToStr(Now), AnyMsg, Pos('%time%', AnyMsg));
    Delete(AnyMsg, Pos('%time%', AnyMsg), Length('%time%'));
   end;
  while Pos('%date%', AnyMsg) <> 0 do
   begin
    Insert(DateToStr(Now), AnyMsg, Pos('%date%', AnyMsg));
    Delete(AnyMsg, Pos('%date%', AnyMsg), Length('%date%'));
   end;
  Result := AnyMsg;
 end;

begin
 if not ICQClient1.LoggedIn
 then
  begin
   if (Edit1.Text='') or (Edit2.Text='')
                             or (StrToInt(Edit1.Text)<10000)
   then
    begin
     MessageBox(0, 'Пожалуйста введите верно UIN и Пароль', 'Невозможно подключиться!', MB_ICONWARNING);
     Exit;
    end;
   ICQClient1.UIN:=StrToInt(Edit1.Text);
   ICQClient1.Password:=Edit2.Text;
   //
   if (ICQClient1.Password='') or (ICQClient1.UIN=0)
   then
    begin
     MessageBox(0, 'Пожалуйста введите верно UIN и Пароль', 'Невозможно подключиться!', MB_ICONWARNING);
     Exit;
    end;
   ICQClient1.Login(NewStatus);
  end
 else
  begin
   ICQClient1.Status:=NewStatus;
   Label21.Caption:='Режим ICQ: "'+StatusToStr(ICQClient1.Status)+'"';
  end;
 case StatusToInt(NewStatus) of
    S_ONLINE: img:=ICON_ONLINE;
    S_AWAY:
           begin
            img := ICON_AWAY;
            ICQClient1.AutoAwayMessage := SetAutoAwayMsg(MsgAway);
           end;
    S_DND:
          begin
           img := ICON_DND;
           ICQClient1.AutoAwayMessage := SetAutoAwayMsg(MsgDND);
          end;
    S_NA:
         begin
          img := ICON_NA;
          ICQClient1.AutoAwayMessage := SetAutoAwayMsg(MsgNA);
         end;
    S_INVISIBLE: img := ICON_INVISIBLE;
    S_OCCUPIED:
               begin
                img:=ICON_OCCUPIED;
                ICQClient1.AutoAwayMessage := SetAutoAwayMsg(MsgOccupied);
               end;
    S_FFC:
          begin
           img := ICON_FFC;
           ICQClient1.AutoAwayMessage := SetAutoAwayMsg(MsgFFC);
          end;
  else img := ICON_OFFLINE;
 end;
end;

procedure TForm1.Offline2Click(Sender: TObject);
var
 dwStatus: dWord;
begin
 if Sender = Offline2 then
  begin
   ICQClient1.LogOff;
   Label21.Caption:='Режим ICQ: "Offline"';
   dwLastStatus:=S_OFFLINE;
  end
 else
  begin
   if Sender = Online2
   then dwStatus := S_ONLINE
   else
    if Sender = Away2
    then dwStatus := S_AWAY
    else
     if Sender = NA2
     then dwStatus := S_NA
     else
      if Sender = Occupied2
      then dwStatus := S_OCCUPIED
      else
       if Sender = DND2
       then dwStatus := S_DND
       else
        if Sender = Freeforchat1
        then dwStatus := S_FFC
        else dwStatus := S_INVISIBLE;
   DoStatusChange(dwStatus or fDCFlag);
   dwLastStatus := dwStatus;
  end;
 with Sender as TMenuItem do
  Default:=true;
end;

procedure TForm1.Label21MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 Label21.Cursor:=crHandPoint;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 Label21.Cursor:=crDefault;
end;

procedure TForm1.Label21Click(Sender: TObject);
begin
 popupStatus.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

end.
