{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit HTTPUtils;

interface

uses
  Classes, YahooMessengerAuthentication, YahooMessengerConstants, httpsend,
  synautil, SysUtils, HttpException, ssl_openssl;

function performHttpGet(cs: String;
  authentication: TYahooMessengerAuthentication): string; overload;
function performHttpPost(cs: String;
  authentication: TYahooMessengerAuthentication; content: String): string;
function performHttpGet(cs: String): string; overload;

implementation

function StreamToString(const AStream: TStream): ansistring; overload;
var
  lPos: integer;
begin
  lPos := AStream.Position;
  AStream.Position := 0;
  SetLength(Result, AStream.Size);
  AStream.Read(Result[1], AStream.Size);
  AStream.Position := lPos;
end;

function performHttpGet(cs: String;
  authentication: TYahooMessengerAuthentication): string;
var
  hc: THTTPSend;
  IsOk: Boolean;
begin
  Result := '';
  if (debugHttpRequestResponse = 1) then
  begin
    // System.out.println("HTTP GET SENT:");
    // System.out.println(cs);
  end;

  hc := THTTPSend.Create;
  if (authentication <> nil) then
  begin
    if not authentication.UsingOAuth then
       hc.Headers.Add('Cookie: ' + authentication.Cookie)
    else
      hc.Headers.Add('Authorization: ' + 'OAuth');
  end;

  try
    IsOk := hc.HTTPMethod('GET', cs);
    if IsOk then
      Result := StreamToString(hc.Document);
  finally
    hc.Free;
  end;
end;

function performHttpPost(cs: String;
  authentication: TYahooMessengerAuthentication; content: String): string;
var
  hc: THTTPSend;
  IsOk: Boolean;
begin
  Result := '';
  if authentication = nil then
    raise EHttpException.Create('Authentication nil');

  hc := THTTPSend.Create;
  if (authentication <> nil) then
  begin
    if not authentication.UsingOAuth then
      hc.Headers.Add('Cookie: ' + authentication.Cookie)
    else
      hc.Headers.Add('Authorization: ' + 'OAuth');
  end;

  try
    if (content <> '') then
    begin
      WriteStrToStream(hc.Document, content);
      hc.MimeType := 'application/json;charset=utf-8';
    end;

    IsOk := hc.HTTPMethod('POST', cs);
    if IsOk then
      Result := StreamToString(hc.Document);
  finally
    hc.Free;
  end;
end;

function performHttpGet(cs: String): string;
begin
  Result := performHttpGet(cs, nil);
end;

end.
