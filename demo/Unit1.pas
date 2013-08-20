unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, YahooMessengerLoginManager,
  YahooMessengerNotificationManager, YahooMessengerConstants,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  YahooMessengerMessageManager, Contact, Message;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Button3: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    LoginManager: TYahooMessengerLoginManager;
    CurrentUsername: string;
    MessageManager: TYahooMessengerMessageManager;
    procedure WriteStatus(Status: string);
    procedure DoOnNewMessage(Sender: TObject; Msg: TMessage);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  notif: TYahooMessengerNotificationManager;
begin
  LoginManager := YahooMessengerLoginManager.getInstance;
  try
    LoginManager.performLoginOAuth(Edit1.Text, Edit2.Text,
      // 'dj0yJmk9UWg3VE1UamE1Nm9SJmQ9WVdrOVl6WkpVVWhGTXpBbWNHbzlOamt5T1RnNE5EWXkmcz1jb25zdW1lcnNlY3JldCZ4PWE3',
      // '307e15d47190a4e87e56c3c8b435687382fea38c');
      authenticationConsumerKey, authenticationConsumerSecret);
    if LoginManager.CurrentSessionData.SessionID <> '' then
    begin
      CurrentUsername := LoginManager.CurrentUsername;
      WriteStatus(CurrentUsername+' - Now Online');
      notif := YahooMessengerNotificationManager.getInstance;
      notif.OnNewMessage := DoOnNewMessage;
    end
    else
      WriteStatus('Offline');
  finally
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  notif: TYahooMessengerNotificationManager;
begin
  LoginManager := YahooMessengerLoginManager.getInstance;
  try
    LoginManager.performLoginYTCookie(Edit1.Text, Edit2.Text);
    CurrentUsername := LoginManager.CurrentUsername;
    if LoginManager.CurrentSessionData.SessionID <> '' then
    begin
      CurrentUsername := LoginManager.CurrentUsername;
      WriteStatus(CurrentUsername+' - Now Online');
      notif := YahooMessengerNotificationManager.getInstance;
      notif.OnNewMessage := DoOnNewMessage;
    end
    else
      WriteStatus('Offline');
  finally
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Contact: TContact;
begin
  Contact := TContact.Create;
  Contact.Id := Edit3.Text;
  YahooMessengerMessageManager.getInstance.SendMessage(Contact, Edit4.Text);
end;

procedure TForm1.DoOnNewMessage(Sender: TObject; Msg: TMessage);
begin
  Memo1.Lines.Add(Msg.Sender+': '+Msg.Msg);
end;

procedure TForm1.WriteStatus(Status: string);
begin
  StatusBar1.Panels[0].Text := Status;
end;

end.
