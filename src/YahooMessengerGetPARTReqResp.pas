{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerGetPARTReqResp;

interface

uses
  MessengerException, YahooMessengerConstants, HTTPUtils, Classes, StrUtils;

type
  TYahooMessengerGetPARTReqResp = class(TObject)
  private
    FConsumerKey: String;
    FPassword: String;
    FUsername: String;
  public
    procedure executeRequest();
  published
    //  Request parameters

    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
    property ConsumerKey: String read FConsumerKey write FConsumerKey;

    //  Response parameters

    property RequestToken: string read FConsumerKey write FConsumerKey;
  end;

implementation

{ TYahooMessengerGetPARTReqResp }

procedure TYahooMessengerGetPARTReqResp.executeRequest;
var
  url, resultString: string;
  nameValuePairs: TStringList;
begin
  //  Verify mandatory parameters
  if Username = '' then
    raise EMessengerException.Create(NO_USERNAME_GIVEN, 'No username given');

  if Password = '' then
    raise EMessengerException.Create(NO_PASSWORD_GIVEN, 'No password given');

  if ConsumerKey = '' then
    raise EMessengerException.Create(NO_CONSUMER_KEY_GIVEN, 'No consumer key given');

   //  Create the HTTP URL
   url := partTokenGetURL + '?' +
                '&login='+Username+'&passwd='+Password+
                '&oauth_consumer_key='+ConsumerKey;
   //  Perform the actual call to the server
   resultString := performHttpGet(url);
   //  Divide each of the lines into its own string, separating by '\n'
   nameValuePairs := TStringList.Create;
   try
      nameValuePairs.Delimiter := '\';
      nameValuePairs.DelimitedText := resultString;

      RequestToken := Copy(nameValuePairs.Strings[0], 14, length(nameValuePairs.Strings[0]));
   finally
     nameValuePairs.Free;
   end;
end;

end.
