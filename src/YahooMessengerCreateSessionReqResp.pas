{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerCreateSessionReqResp;

interface

uses
  YahooMessengerBaseReqResp, ClientCapabilityList, Types, Classes,
  MessengerException, HttpUtils, YahooMessengerConstants, superobject;

type
  TYahooMessengerCreateSessionReqResp = class(TYahooMessengerBaseReqResp)
  private
    FNotifyServer: string;
    FPresenceMessage: String;
    FClientCapabilities: TClientCapabilityList;
    FPresenceState: integer;
    FNotifyServerToken: string;
    FFieldsBuddyList: String;
    FPrimaryLoginID: string;
    FDisplayInfo: TStringList;
    FProfileLoginIDList: TStringDynArray;
    FServer: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ExecuteRequest();
    function SerializeJSONRequestParameters(): ISuperObject; override;
    procedure UnserializeJSONResponseParameters(o: ISuperObject); override;
  published
    // Request URI parameters

    Property FieldsBuddyList: String read FFieldsBuddyList
      write FFieldsBuddyList;
    Property NotifyServerToken: string read FNotifyServerToken
      write FNotifyServerToken;

    // Request body parameters

    Property PresenceState: integer read FPresenceState write FPresenceState;
    Property PresenceMessage: String read FPresenceMessage
      write FPresenceMessage;
    Property ClientCapabilities: TClientCapabilityList read FClientCapabilities
      write FClientCapabilities;

    // Response parameters

    // Property ContactList contactList;
    Property PrimaryLoginID: string read FPrimaryLoginID write FPrimaryLoginID;
    Property ProfileLoginIDList: TStringDynArray read FProfileLoginIDList
      write FProfileLoginIDList;
    Property Server: string read FServer write FServer;
    Property NotifyServer: string read FNotifyServer write FNotifyServer;
    Property DisplayInfo: TStringList read FDisplayInfo write FDisplayInfo;

  end;

implementation

{ TYahooMessengerCreateSessionReqResp }

constructor TYahooMessengerCreateSessionReqResp.Create;
begin
  FDisplayInfo := TStringList.Create;
end;

destructor TYahooMessengerCreateSessionReqResp.Destroy;
begin
  FDisplayInfo.Free;
  inherited;
end;

procedure TYahooMessengerCreateSessionReqResp.ExecuteRequest;
var
  url, responseString: string;
  response: ISuperObject;
begin
  if Crumb = '' then
    raise EMessengerException.Create(NO_CRUMB_GIVEN, 'No Crumb given');

  // Create the HTTP URI >> developer.messenger.yahooapis.com'?
  url := 'http://' + RequestServer + sessionManagementURL + '?c=' + Crumb;
  // Add optional URI parameters
  if FieldsBuddyList <> '' then
    url := url + '&fieldBuddyList=' + FieldsBuddyList;

  if (NotifyServerToken <> '') then
    url := url + '&notifyServerToken=' + NotifyServerToken;
  // Add authentication parameters
  url := url + Authentication.getOAuthParameters;
  // Perform the actual call to the server
  responseString := performHttpPost(url, Authentication,
    SerializeJSONRequestParameters().AsJSon);
  // Parse the response
  response := TSuperObject.ParseString(PWideChar(responseString), True);
  try
    if response <> nil then
      UnserializeJSONResponseParameters(response)
    else
      raise EMessengerException.Create(UNKNOWN_SERVER_ERROR,
        'Unknown server error');
  finally
    response := nil;
  end;

end;

function TYahooMessengerCreateSessionReqResp.SerializeJSONRequestParameters
  : ISuperObject;
var
  o: ISuperObject;
begin
  inherited;
  o := TSuperObject.Create(stObject);
  try
    // Optional fields

    if (PresenceState <> 0) then
      o.I['presenceState'] := PresenceState;
    if (PresenceMessage <> '') then
      o.S['PresenceMessage'] := PresenceMessage;
    if (ClientCapabilities <> nil) then
      o.o['ClientCapabilities'] := ClientCapabilities.serializeJSON;
    Result := o;
  finally
    o := nil;
  end;
end;

procedure TYahooMessengerCreateSessionReqResp.UnserializeJSONResponseParameters
  (o: ISuperObject);
var
  displayInfoJSONObject: ISuperObject;
begin
  inherited;
  // Mandatory fields

  SessionID := o.S['sessionId'];
  PrimaryLoginID := o.S['primaryLoginId'];
  Server := o.S['server'];
  NotifyServer := o.S['notifyServer'];

  displayInfoJSONObject := TSuperObject.ParseString
    (PWideChar(o.S['displayInfo']), True);
  try
    FDisplayInfo.DelimitedText := '';
  finally
    displayInfoJSONObject := nil;
  end;

end;

end.
