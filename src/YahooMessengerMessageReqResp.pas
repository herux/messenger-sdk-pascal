{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}
unit YahooMessengerMessageReqResp;

interface

uses
  YahooMessengerBaseReqResp, MessengerException, YahooMessengerConstants,
  HTTPUtils, superobject;

type
  TYahooMessengerMessageReqResp = class(TYahooMessengerBaseReqResp)
  private
    FTargetId: string;
    FNetwork: string;
    FMessage: string;
    FSendAs: string;
  public
    procedure executeRequest();
    function serializeJSONRequestParameters(): ISuperObject;
  published
    // Request URI parameters

    property Network: string read FNetwork write FNetwork;
    property TargetId: string read FTargetId write FTargetId;

    // Request parameters

    property Message: string read FMessage write FMessage;
    property SendAs: string read FSendAs write FSendAs;
  end;

implementation

{ TYahooMessengerMessageReqResp }

procedure TYahooMessengerMessageReqResp.executeRequest;
var
  url, responseString: string;
begin
  // Verify mandatory parameters
  if Crumb = '' then
    raise EMessengerException.Create(NO_CRUMB_GIVEN, 'No crumb given');
  if SessionID = '' then
    raise EMessengerException.Create(NO_SESSION_ID_GIVEN,
      'No session ID given');
  // Create the HTTP URL

  if Network = '' then
    raise EMessengerException.Create(NO_NETWORK_GIVEN);

  if TargetId = '' then
    raise EMessengerException.Create(NO_TARGET_ID_GIVEN);

  url := 'http://' + RequestServer + messageManagementURL + '/' + Network + '/'
    + TargetId + '?c=' + Crumb + '&sid=' + SessionID;

  // Add authentication parameters

  url := url + Authentication.getOAuthParameters;

  // Perform the actual call to the server

   responseString := performHttpPost(url, Authentication,
    serializeJSONRequestParameters.AsJSon());

end;

function TYahooMessengerMessageReqResp.serializeJSONRequestParameters: ISuperObject;
var
  o: ISuperObject;
begin
  o := TSuperObject.Create(stObject);
  o.S['message'] := Message;
  if SendAs <> '' then
    o.S['sendAs'] := SendAs;
  Result := o;
end;

end.
