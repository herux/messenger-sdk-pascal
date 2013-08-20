{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}
unit YahooMessengerMessageManager;

interface

uses
  Contact, SessionData, YahooMessengerLoginManager,
  YahooMessengerMessageReqResp;

type
  TYahooMessengerMessageManager = class(TObject)
  private
    FLoginManager: TYahooMessengerLoginManager;
  public
    constructor Create; overload;
    constructor Create(ALoginManager: TYahooMessengerLoginManager); overload;

    procedure SendMessage(Contact: TContact; message: String);
  end;

var
  instance: TYahooMessengerMessageManager;

function getInstance(): TYahooMessengerMessageManager;

implementation

function getInstance(): TYahooMessengerMessageManager;
begin
  if instance <> nil then
    instance := TYahooMessengerMessageManager.Create;

  Result := instance;
end;

{ TYahooMessengerMessageManager }

constructor TYahooMessengerMessageManager.Create;
begin
  //
end;

constructor TYahooMessengerMessageManager.Create(
  ALoginManager: TYahooMessengerLoginManager);
begin
  FLoginManager := ALoginManager;
end;

procedure TYahooMessengerMessageManager.SendMessage(Contact: TContact;
  message: String);
var
  currentSessionData: TSessionData;
  sendMessageRequest: TYahooMessengerMessageReqResp;
begin
  if Contact.Network = '' then
    Contact.Network := 'yahoo';

  if FLoginManager = nil then
    FLoginManager := YahooMessengerLoginManager.getInstance;
  currentSessionData := FLoginManager.currentSessionData;

  sendMessageRequest := TYahooMessengerMessageReqResp.Create;
  try
    sendMessageRequest.RequestServer := currentSessionData.RequestServer;
    sendMessageRequest.Authentication := currentSessionData.Authentication;
    sendMessageRequest.SessionID := currentSessionData.SessionID;
    sendMessageRequest.Crumb := currentSessionData.Crumb;
    sendMessageRequest.Network := Contact.Network;
    sendMessageRequest.TargetID := Contact.Id;
    sendMessageRequest.message := message;

    sendMessageRequest.executeRequest();
  finally
    sendMessageRequest.Free;
  end;
end;

end.
