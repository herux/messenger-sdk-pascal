program ymAPIDemo;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  HTTPUtils in '..\src\HTTPUtils.pas',
  YahooMessengerAuthentication in '..\src\YahooMessengerAuthentication.pas',
  YahooMessengerConstants in '..\src\YahooMessengerConstants.pas',
  HttpException in '..\src\HttpException.pas',
  YahooMessengerYTLoginUtilities in '..\src\YahooMessengerYTLoginUtilities.pas',
  MessengerException in '..\src\MessengerException.pas',
  SessionData in '..\src\SessionData.pas',
  ClientCapabilityList in '..\src\ClientCapabilityList.pas',
  ClientCapability in '..\src\ClientCapability.pas',
  YahooMessengerLoginManager in '..\src\YahooMessengerLoginManager.pas',
  YahooMessengerGetPARTReqResp in '..\src\YahooMessengerGetPARTReqResp.pas',
  YahooMessengerExchangePARTForOAuthReqResp in '..\src\YahooMessengerExchangePARTForOAuthReqResp.pas',
  YahooMessengerGetCrumbReqResp in '..\src\YahooMessengerGetCrumbReqResp.pas',
  YahooMessengerBaseReqResp in '..\src\YahooMessengerBaseReqResp.pas',
  YahooMessengerCreateSessionReqResp in '..\src\YahooMessengerCreateSessionReqResp.pas',
  YahooMessengerDeleteSessionReqResp in '..\src\YahooMessengerDeleteSessionReqResp.pas',
  YahooMessengerValidateSessionReqResp in '..\src\YahooMessengerValidateSessionReqResp.pas',
  YahooMessengerKeepAliveSessionReqResp in '..\src\YahooMessengerKeepAliveSessionReqResp.pas',
  YahooMessengerNotificationManager in '..\src\YahooMessengerNotificationManager.pas',
  PropertyChangeSupport in '..\src\PropertyChangeSupport.pas',
  PropertyChangeListener in '..\src\PropertyChangeListener.pas',
  YahooMessengerGetNotificationsReqResp in '..\src\YahooMessengerGetNotificationsReqResp.pas',
  ResponseList in '..\src\ResponseList.pas',
  Response in '..\src\Response.pas',
  Message in '..\src\Message.pas',
  BuddyInfo in '..\src\BuddyInfo.pas',
  BuddyInfoContactList in '..\src\BuddyInfoContactList.pas',
  BuddyInfoContact in '..\src\BuddyInfoContact.pas',
  NotificationData in '..\src\NotificationData.pas',
  YahooMessengerMessageManager in '..\src\YahooMessengerMessageManager.pas',
  Contact in '..\src\Contact.pas',
  AddressBook in '..\src\AddressBook.pas',
  Group in '..\src\Group.pas',
  ContactList in '..\src\ContactList.pas',
  YahooMessengerMessageReqResp in '..\src\YahooMessengerMessageReqResp.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
