{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerDeleteSessionReqResp;

interface

uses
  YahooMessengerBaseReqResp, MessengerException, YahooMessengerConstants,
  HttpUtils;

type
  TYahooMessengerDeleteSessionReqResp = class(TYahooMessengerBaseReqResp)
  public
    procedure executeRequest();
  end;

implementation

{ TYahooMessengerDeleteSessionReqResp }

procedure TYahooMessengerDeleteSessionReqResp.executeRequest;
var
  url, responseString: string;
begin
  if Crumb = '' then
    raise EMessengerException.Create(NO_CRUMB_GIVEN, 'No crumb given');
  if SessionId = '' then
    raise EMessengerException.Create(NO_SESSION_ID_GIVEN,
      'No session ID given');

  // Create the HTTP URL

  url := 'http://' + RequestServer + sessionManagementURL + '?' + deleteSuffix +
    '&c=' + Crumb + '&sid=' + SessionId;

  // Add authentication parameters

  url := url + Authentication.getOAuthParameters();

  // Perform the actual call to the server. If there is no exception,
  // the call worked.

  responseString := performHttpPost(url, Authentication, '');

end;

end.
