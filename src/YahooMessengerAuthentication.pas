{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerAuthentication;

interface

uses
  SysUtils, DateUtils;

Type
  TYahooMessengerAuthentication = class(TObject)
  private
    FOauthSignatureMethod: string;
    FCookie: String;
    FOauthNonce: string;
    FOauthVersion: string;
    FUsingOAuth: boolean;
    FOauthConsumerKey: string;
    FRealm: String;
    FOauthTimestamp: string;
    FOauthToken: string;
    FOauthSignature: string;
    procedure SetCookie(const Value: String);
    procedure SetOauthConsumerKey(const Value: string);
    procedure SetOauthNonce(const Value: string);
    procedure SetOauthSignature(const Value: string);
    procedure SetOauthSignatureMethod(const Value: string);
    procedure SetOauthTimestamp(const Value: string);
    procedure SetOauthToken(const Value: string);
    procedure SetOauthVersion(const Value: string);
    procedure SetRealm(const Value: String);
    procedure SetUsingOAuth(const Value: boolean);
  public
    constructor Create(realm: String; consumerKey: String;
            nonce: String; signatureMethod: String; timestamp: String; token: String;
            version: String; signature: String); overload;
    constructor Create(authenticationCookie: String); overload;
    destructor Destroy; override;

    function getOAuthParameters(): String;
  published
    property Cookie: String read FCookie write SetCookie;
    property UsingOAuth: boolean read FUsingOAuth write SetUsingOAuth;
    property Realm: String read FRealm write SetRealm;
    property OauthConsumerKey: string read FOauthConsumerKey
      write SetOauthConsumerKey;
    property OauthNonce: string read FOauthNonce write SetOauthNonce;
    property OauthSignatureMethod: string read FOauthSignatureMethod
      write SetOauthSignatureMethod;
    property OauthTimestamp: string read FOauthTimestamp
      write SetOauthTimestamp;
    property OauthToken: string read FOauthToken write SetOauthToken;
    property OauthVersion: string read FOauthVersion write SetOauthVersion;
    property OauthSignature: string read FOauthSignature
      write SetOauthSignature;

  end;

const
  // Sets UnixStartDate to TDateTime of 01/01/1970
  UnixStartDate: TDateTime = 25569.0;

function DateTimeToUnix(ConvDate: TDateTime): Longint;
function UnixToDateTime(USec: Longint): TDateTime;

implementation

function DateTimeToUnix(ConvDate: TDateTime): Longint;
begin
  Result := Round((ConvDate - UnixStartDate) * 86400);
end;

function UnixToDateTime(USec: Longint): TDateTime;
begin
  Result := (Usec / 86400) + UnixStartDate;
end;


{ TYahooMessengerAuthentication }

constructor TYahooMessengerAuthentication.Create(realm, consumerKey, nonce,
  signatureMethod, timestamp, token, version, signature: String);
begin
  FRealm := realm;
  FOauthConsumerKey := consumerKey;
  FOauthNonce := nonce;
  FOauthSignatureMethod := signatureMethod;
  FOauthTimestamp := timestamp;
  FOauthToken := token;
  FOauthVersion := version;
  FOauthSignature := signature;
  FUsingOAuth := true;
end;

constructor TYahooMessengerAuthentication.Create(authenticationCookie: String);
begin
  FCookie := authenticationCookie;
  FUsingOAuth := false;
end;

destructor TYahooMessengerAuthentication.Destroy;
begin

  inherited;
end;

function TYahooMessengerAuthentication.getOAuthParameters: String;
var
  timeStamp: Int64;
begin
  Result := '';
  if not UsingOAuth then Exit;

  timeStamp := DateTimeToUnix(Now);
  Result := '&realm='+Realm+'&oauth_consumer_key='+OauthConsumerKey+
          '&oauth_nonce='+OauthNonce+
          '&oauth_signature_method='+OauthSignatureMethod+
          '&oauth_timestamp='+IntToStr(timeStamp)+
          '&oauth_token='+OauthToken+
          '&oauth_version='+OauthVersion+
          '&oauth_signature='+OauthSignature;
end;

procedure TYahooMessengerAuthentication.SetCookie(const Value: String);
begin
  FCookie := Value;
end;

procedure TYahooMessengerAuthentication.SetOauthConsumerKey
  (const Value: string);
begin
  FOauthConsumerKey := Value;
end;

procedure TYahooMessengerAuthentication.SetOauthNonce(const Value: string);
begin
  FOauthNonce := Value;
end;

procedure TYahooMessengerAuthentication.SetOauthSignature(const Value: string);
begin
  FOauthSignature := Value;
end;

procedure TYahooMessengerAuthentication.SetOauthSignatureMethod
  (const Value: string);
begin
  FOauthSignatureMethod := Value;
end;

procedure TYahooMessengerAuthentication.SetOauthTimestamp(const Value: string);
begin
  FOauthTimestamp := Value;
end;

procedure TYahooMessengerAuthentication.SetOauthToken(const Value: string);
begin
  FOauthToken := Value;
end;

procedure TYahooMessengerAuthentication.SetOauthVersion(const Value: string);
begin
  FOauthVersion := Value;
end;

procedure TYahooMessengerAuthentication.SetRealm(const Value: String);
begin
  FRealm := Value;
end;

procedure TYahooMessengerAuthentication.SetUsingOAuth(const Value: boolean);
begin
  FUsingOAuth := Value;
end;

end.
