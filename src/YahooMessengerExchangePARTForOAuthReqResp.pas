{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerExchangePARTForOAuthReqResp;

interface

uses
  YahooMessengerAuthentication, MessengerException, YahooMessengerConstants,
  HTTPUtils, Classes, synacode;

type
  TYahooMessengerExchangePARTForOAuthReqResp = class(TObject)
  private
    FAuthenticationToken: TYahooMessengerAuthentication;
    FNonce: String;
    FVersion: String;
    FConsumerKey: String;
    FTimestamp: String;
    FToken: String;
    FSignature: String;
    FVerifier: String;
    FSignatureMethod: String;
    procedure SetAuthenticationToken(const Value
      : TYahooMessengerAuthentication);
  public
    destructor Destroy; override;
    procedure ExecuteRequest();
  published
    Property ConsumerKey: String read FConsumerKey write FConsumerKey;
    Property SignatureMethod: String read FSignatureMethod
      write FSignatureMethod;
    Property Nonce: String read FNonce write FNonce;
    Property Timestamp: String read FTimestamp write FTimestamp;
    Property Signature: String read FSignature write FSignature;
    Property Verifier: String read FVerifier write FVerifier;
    Property Version: String read FVersion write FVersion;
    Property Token: String read FToken write FToken;

    Property AuthenticationToken: TYahooMessengerAuthentication
      read FAuthenticationToken write SetAuthenticationToken;
  end;

implementation

{ TYahooMessengerExchangePARTForOAuthReqResp }

destructor TYahooMessengerExchangePARTForOAuthReqResp.Destroy;
begin
  if AuthenticationToken <> nil then
    AuthenticationToken.Free;
  inherited;
end;

procedure TYahooMessengerExchangePARTForOAuthReqResp.ExecuteRequest;
var
  url, resultString, oauth_token: string;
  nameValuePairs: TStringList;
begin
  // Verify mandatory parameters
  if ConsumerKey = '' then
    raise EMessengerException.Create(NO_CONSUMER_KEY_GIVEN,
      'No consumer key given');

  url := exchangePARTGetURL + '?' + '&oauth_consumer_key=' + ConsumerKey +
    '&oauth_signature_method=' + SignatureMethod + '&oauth_nonce=' + Nonce +
    '&oauth_timestamp=' + Timestamp + '&oauth_signature=' + Signature +
  // "&oauth_verifier="+getVerifier()+
    '&oauth_version=' + Version + '&oauth_token=' + Token;

  // Perform the actual call to the server
  resultString := performHttpGet(url);
  nameValuePairs := TStringList.Create;
  try
    nameValuePairs.Delimiter := '&';
    nameValuePairs.DelimitedText := resultString;
    oauth_token := nameValuePairs.Values['oauth_token_secret'];
    AuthenticationToken := TYahooMessengerAuthentication.Create
      (EncodeURL('yahooapis.com'), authenticationConsumerKey, '12345',
      'PLAINTEXT', '0', oauth_token, '1.0',
      authenticationConsumerSecret + '%26');
  finally
    nameValuePairs.Free;
  end;
end;

procedure TYahooMessengerExchangePARTForOAuthReqResp.SetAuthenticationToken
  (const Value: TYahooMessengerAuthentication);
begin
  FAuthenticationToken := Value;
end;

end.
