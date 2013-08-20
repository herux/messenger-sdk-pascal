{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerLoginManager;

interface

uses
  SessionData, YahooMessengerGetPARTReqResp, YahooMessengerDeleteSessionReqResp,
  YahooMessengerExchangePARTForOAuthReqResp, YahooMessengerAuthentication,
  SysUtils, YahooMessengerGetCrumbReqResp, YahooMessengerCreateSessionReqResp,
  YahooMessengerValidateSessionReqResp, YahooMessengerKeepAliveSessionReqResp,
  YahooMessengerYTLoginUtilities;

type
  TYahooMessengerLoginManager = class(TObject)
  private
    FCurrentUsername: String;
    FCurrentSessionData: TSessionData;
  public
    constructor Create;
    destructor Destroy; override;

    procedure performLoginOAuth(username, password, consumerKey,
      consumerSecret: String);
    procedure performLoginYTCookie(username, password: String);
    procedure performLogout();
    procedure validateLogin();
    procedure sendKeepAlive();
  published
    property CurrentUsername: String read FCurrentUsername
      write FCurrentUsername;
    property CurrentSessionData: TSessionData read FCurrentSessionData
      write FCurrentSessionData;
  end;

var
  instance: TYahooMessengerLoginManager;

function getInstance(): TYahooMessengerLoginManager;

implementation

function getInstance(): TYahooMessengerLoginManager;
begin
  if (instance = nil) then
    instance := TYahooMessengerLoginManager.Create;
  result := instance;
end;

{ TYahooMessengerLoginManager }

constructor TYahooMessengerLoginManager.Create;
begin
  CurrentSessionData := TSessionData.Create;
end;

destructor TYahooMessengerLoginManager.Destroy;
begin
  CurrentSessionData.Free;
  inherited;
end;

procedure TYahooMessengerLoginManager.performLoginOAuth(username, password,
  consumerKey, consumerSecret: String);
var
  partToken, Token: string;
  getPartRequest: TYahooMessengerGetPARTReqResp;
  exchangePartReqResp: TYahooMessengerExchangePARTForOAuthReqResp;
  getCrumbRequest: TYahooMessengerGetCrumbReqResp;
  createSessionRequest: TYahooMessengerCreateSessionReqResp;
  Timestamp: Int64;
  test: TYahooMessengerAuthentication;
begin
  partToken := '';

  // First, connect to the OAuth server and request a Pre-Approved Request Token (PART)
  // given the username, password, and consumerKey that was assigned to you by
  // developer.yahoo.com.
  getPartRequest := TYahooMessengerGetPARTReqResp.Create;
  try
    getPartRequest.username := username;
    getPartRequest.password := password;
    getPartRequest.consumerKey := consumerKey;

    getPartRequest.executeRequest;

    partToken := getPartRequest.RequestToken;
  finally
    getPartRequest.Free;
  end;

  // Next, exchange the PART for a set of OAuth authentication parameters, which will
  // be stored in a YahooMessengerAuthentication object. This object will be used
  // to append URI authorization params to each Messenger IM API call.

  exchangePartReqResp := TYahooMessengerExchangePARTForOAuthReqResp.Create;
  try
    exchangePartReqResp.consumerKey := consumerKey;
    exchangePartReqResp.SignatureMethod := 'PLAINTEXT';
    exchangePartReqResp.Nonce := '123456';
    Timestamp := DateTimeToUnix(Now);
    exchangePartReqResp.Timestamp := IntToStr(Timestamp);
    exchangePartReqResp.Signature := consumerSecret + '%26';
    exchangePartReqResp.Verifier := 'Boasvd78';
    exchangePartReqResp.Version := '1.0';
    exchangePartReqResp.Token := partToken;

    exchangePartReqResp.executeRequest();

    CurrentSessionData.Authentication := TYahooMessengerAuthentication.Create
      (exchangePartReqResp.AuthenticationToken.Realm,
      exchangePartReqResp.consumerKey, exchangePartReqResp.Nonce,
      exchangePartReqResp.SignatureMethod, exchangePartReqResp.Timestamp,
      exchangePartReqResp.Token, exchangePartReqResp.Version,
      exchangePartReqResp.Signature);

  finally
    exchangePartReqResp.Free;
  end;

  // Next, perform a login to get the crumb, which is stored in the
  // currentSessionData
  Token := performLoginGetPwToken(username, password);
  performLoginGetYTCookie(CurrentSessionData, Token);
  getCrumbRequest := TYahooMessengerGetCrumbReqResp.Create;
  try
    getCrumbRequest.Authentication := CurrentSessionData.Authentication;
    getCrumbRequest.Authentication.UsingOAuth := False;
    getCrumbRequest.Authentication.Cookie:= CurrentSessionData.Cookie;
    getCrumbRequest.executeRequest();

    CurrentSessionData.Crumb := getCrumbRequest.Crumb;
    CurrentSessionData.LoggedIn := getCrumbRequest.LoggedIn;

  finally
    getCrumbRequest.Free;
  end;

  // If the loggedIn value that comes back is set to 1, it means that the user
  // is already logged in somewhere else. It is up to the client implementation
  // to handle this as it sees fit.

  if (CurrentSessionData.LoggedIn = 1) then
  begin
    // Do something or nothing
  end;

  // Next, obtain a session ID for the user, as well as other login data.
  createSessionRequest := TYahooMessengerCreateSessionReqResp.Create;
  try
    createSessionRequest.Authentication := CurrentSessionData.Authentication;
    createSessionRequest.Crumb := CurrentSessionData.Crumb;
    createSessionRequest.PresenceState := 0;

    createSessionRequest.executeRequest();

    CurrentSessionData.SessionID := createSessionRequest.SessionID;
    CurrentSessionData.RequestServer := createSessionRequest.Server;
    CurrentSessionData.NotifyServer := createSessionRequest.NotifyServer;

    CurrentUsername := username;
  finally
    createSessionRequest.Free;
  end;
end;

procedure TYahooMessengerLoginManager.performLoginYTCookie(username,
  password: String);
var
  Token: string;
  getCrumbRequest: TYahooMessengerGetCrumbReqResp;
  createSessionRequest: TYahooMessengerCreateSessionReqResp;
begin
  // Contact the login server and attempt to get a pw token
  Token := performLoginGetPwToken(username, password);
  // Once we have the pw token, login to get a TY cookie
  performLoginGetYTCookie(CurrentSessionData, Token);
  // Then perform a login to get the crumb, which is stored in the
  // currentSessionData
  CurrentSessionData.Authentication := TYahooMessengerAuthentication.Create
    (CurrentSessionData.Cookie);

  getCrumbRequest := TYahooMessengerGetCrumbReqResp.Create;
  try
    getCrumbRequest.Authentication := CurrentSessionData.Authentication;
    getCrumbRequest.executeRequest;

    CurrentSessionData.Crumb := getCrumbRequest.Crumb;
    CurrentSessionData.LoggedIn := getCrumbRequest.LoggedIn;
  finally
    getCrumbRequest.Free;
  end;

  // If the loggedIn value that comes back is set to 1, it means that the user
  // is already logged in somewhere else. It is up to the client implementation
  // to handle this as it sees fit.

  // if (currentSessionData.getLoggedIn().intValue() == 1) {
  // //  Do something or nothing
  // }

  // Next, obtain a session ID for the user, as well as other login data.
  createSessionRequest := TYahooMessengerCreateSessionReqResp.Create;
  try
    createSessionRequest.Authentication := CurrentSessionData.Authentication;
    createSessionRequest.Crumb := CurrentSessionData.Crumb;
    createSessionRequest.PresenceState := 0;

    createSessionRequest.executeRequest();

    CurrentSessionData.SessionID := createSessionRequest.SessionID;
    CurrentSessionData.RequestServer := createSessionRequest.Server;
    CurrentSessionData.NotifyServer := createSessionRequest.NotifyServer;

    CurrentUsername := username;
  finally
    createSessionRequest.Free;
  end;

end;

procedure TYahooMessengerLoginManager.performLogout;
var
  deleteSessionRequest: TYahooMessengerDeleteSessionReqResp;
begin
  deleteSessionRequest := TYahooMessengerDeleteSessionReqResp.Create;
  try
    deleteSessionRequest.RequestServer := CurrentSessionData.RequestServer;
    deleteSessionRequest.Authentication := CurrentSessionData.Authentication;
    deleteSessionRequest.SessionID := CurrentSessionData.SessionID;
    deleteSessionRequest.Crumb := CurrentSessionData.Crumb;

    deleteSessionRequest.executeRequest();

    CurrentUsername := '';
  finally
    deleteSessionRequest.Free;
  end;
end;

procedure TYahooMessengerLoginManager.sendKeepAlive;
var
  keepAliveSessionRequest: TYahooMessengerKeepAliveSessionReqResp;
begin
  keepAliveSessionRequest := TYahooMessengerKeepAliveSessionReqResp.Create;
  try
    keepAliveSessionRequest.RequestServer := CurrentSessionData.RequestServer;
    keepAliveSessionRequest.Authentication := CurrentSessionData.Authentication;
    keepAliveSessionRequest.SessionID := CurrentSessionData.SessionID;
    keepAliveSessionRequest.Crumb := CurrentSessionData.Crumb;

    keepAliveSessionRequest.executeRequest();
  finally
    keepAliveSessionRequest.Free;
  end;
end;

procedure TYahooMessengerLoginManager.validateLogin;
var
  validateSessionRequest: TYahooMessengerValidateSessionReqResp;
begin
  validateSessionRequest := TYahooMessengerValidateSessionReqResp.Create;
  try
    validateSessionRequest.RequestServer := CurrentSessionData.RequestServer;
    validateSessionRequest.Authentication := CurrentSessionData.Authentication;
    validateSessionRequest.SessionID := CurrentSessionData.SessionID;
    validateSessionRequest.Crumb := CurrentSessionData.Crumb;

    validateSessionRequest.executeRequest();
  finally
    validateSessionRequest.Free;
  end;
end;

end.
