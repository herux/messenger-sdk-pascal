{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerGetCrumbReqResp;

interface

uses
  YahooMessengerBaseReqResp, YahooMessengerConstants, HTTPUtils, superobject,
  MessengerException;

type
  TYahooMessengerGetCrumbReqResp = class(TYahooMessengerBaseReqResp)
  private
    FLoggedIn: Integer;
  public
    procedure unserializeJSONResponseParameters(o: ISuperObject); override;
    procedure ExecuteRequest();
    // Response parameters
    property LoggedIn: Integer read FLoggedIn write FLoggedIn;
  end;

implementation

{ TYahooMessengerGetCrumbReqResp }

procedure TYahooMessengerGetCrumbReqResp.ExecuteRequest;
var
  uri: string;
  responseString: string;
  response: ISuperObject;
begin
  uri := 'http://' + RequestServer + sessionManagementURL + '?' +
    Authentication.getOAuthParameters;
  responseString := performHttpGet(uri, Authentication);
  response := TSuperObject.ParseString(PWideChar(responseString), True);
  try
    if response <> nil then
      unserializeJSONResponseParameters(response)
    else
      raise EMessengerException.Create(UNKNOWN_SERVER_ERROR,
        'Unknown server error');
  finally
    response := nil;
  end;
end;

procedure TYahooMessengerGetCrumbReqResp.unserializeJSONResponseParameters
  (o: ISuperObject);
begin
  inherited;
  // Mandatory fields
  FCrumb := o.S['crumb'];
  FLoggedIn := o.I['LoggedIn'];
end;

end.
