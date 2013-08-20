{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerKeepAliveSessionReqResp;

interface

uses
  YahooMessengerBaseReqResp, MessengerException, YahooMessengerConstants,
  HttpUtils;

type
  TYahooMessengerKeepAliveSessionReqResp = class(TYahooMessengerBaseReqResp)
  private
    FNotifyServerToken: String;
  public
    procedure executeRequest();
    // Request uri parameters

    property NotifyServerToken: String read FNotifyServerToken
      write FNotifyServerToken;

  end;

implementation

{ TYahooMessengerKeepAliveSessionReqResp }

procedure TYahooMessengerKeepAliveSessionReqResp.executeRequest;
var
  url, resultString: string;
begin
  if Crumb = '' then
    raise EMessengerException.Create(NO_CRUMB_GIVEN, 'No crumb given');

  if SessionID = '' then
    raise EMessengerException.Create(NO_SESSION_ID_GIVEN,
      'No session ID given');

  // Create the HTTP URL
  url := 'http://' + RequestServer + sessionManagementURL + '?' + putSuffix +
    '&c=' + Crumb + '&sid=' + SessionID;

  // Perform the actual call to the server

  if NotifyServerToken <> ''  then
    url :=  url + '&notifyServerToken='+NotifyServerToken;

  // Add authentication parameters

    url := url + Authentication.getOAuthParameters;

    // Perform the actual call to the server

    resultString := performHttpGet(url, Authentication);

end;

end.
