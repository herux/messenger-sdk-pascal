{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerValidateSessionReqResp;

interface

uses
  YahooMessengerBaseReqResp, Types, YahooMessengerConstants, HttpUtils,
  superobject, MessengerException;

type
  TYahooMessengerValidateSessionReqResp = class(TYahooMessengerBaseReqResp)
  private
    FprimaryLoginID: String;
    FProfileLoginIDs: TStringDynArray;
  public
    procedure executeRequest(); override;
    procedure unserializeJSONResponseParameters(o: ISuperObject); override;
    // Response parameters

    property PrimaryLoginID: String read FprimaryLoginID write FprimaryLoginID;
    property ProfileLoginIDs: TStringDynArray read FProfileLoginIDs
      write FProfileLoginIDs;
  end;

implementation

{ TYahooMessengerValidateSessionReqResp }

procedure TYahooMessengerValidateSessionReqResp.executeRequest;
var
  url, responseString: string;
  response: ISuperObject;
begin
  inherited;
  // Create the HTTP URL

  url := 'http://' + RequestServer + sessionManagementURL + '?c=' + Crumb +
    '&sid=' + SessionID;

  // Add authentication parameters

  url := url + Authentication.getOAuthParameters();

  // Perform the actual call to the server

  responseString := performHttpGet(url, Authentication);
  // Parse the JSON response

  response := TSuperObject.ParseString(PWideChar(responseString), True);
  if response <> nil then
    unserializeJSONResponseParameters(response)
  else
    raise EMessengerException.Create(UNKNOWN_SERVER_ERROR,
      'Unknown server error');

end;

procedure TYahooMessengerValidateSessionReqResp.unserializeJSONResponseParameters(
  o: ISuperObject);
begin
  inherited;
  PrimaryLoginID:= o.S['primaryLoginId'];

//  if (o.has("profileLoginIds"))
//        {
//            JSONArray profileLoginIdsJSONArray = o.getJSONArray("profileLoginIds");
//            String[] profLoginIDs = new String[profileLoginIdsJSONArray.length()];
//            for (int i = 0; i < profileLoginIdsJSONArray.length(); i++) {
//                profLoginIDs[i] = profileLoginIdsJSONArray.getString(i);
//            }
//            setProfileLoginIDs(profLoginIDs);
//        }
end;

end.
