{ **
  * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
  * Code licensed under the BSD License:
  * http://searchmarketing.yahoo.com/developer/docs/license.txt
  ******
  * pascal convertion by herux
  * }

unit YahooMessengerYTLoginUtilities;

interface

uses
  Classes, YahooMessengerConstants, HTTPUtils, StrUtils, Types, SysUtils,
  MessengerException, SessionData;

function performLoginGetPwToken(username, password: String): String;
procedure performLoginGetYTCookie(loginData: TSessionData; token: String);

implementation

function performLoginGetPwToken(username, password: String): String;
var
  cs, resultString: String;
  nameValuePairs: TStringList;
  token: string;
begin
  cs := pwTokenGetURL + 'src=ymsgr&' + 'login=' + username + '&' + 'passwd='
    + password;
  resultString := performHttpGet(cs);
  nameValuePairs := TStringList.Create;
  try
    nameValuePairs.Delimiter := '/';
    nameValuePairs.DelimitedText := resultString;
    if (nameValuePairs.Count = 1) then
    begin
      case StrToInt(nameValuePairs.Strings[0]) of
        100:
          raise EMessengerException.Create(NO_USERNAME_GIVEN);
        1235:
          raise EMessengerException.Create(UNKNOWN_USERNAME,
            'Unknown Username');
        1212:
          raise EMessengerException.Create(INCORRECT_PASSWORD,
            'Incorrect Password');
      else
        raise EMessengerException.Create(UNKNOWN_ERROR, 'Unknown Error');
      end;
    end
    else if (nameValuePairs.Count = 3) then
    begin
      token := nameValuePairs.Values['ymsgr'];
      Result := token;
    end
    else
      raise EMessengerException.Create(UNKNOWN_ERROR, 'Unknown Error');
  finally
    nameValuePairs.Free;
  end;

end;

procedure performLoginGetYTCookie(loginData: TSessionData; token: String);
var
  cs, resultString: string;
  nameValuePairs: TStringList;
  cookie: string;
begin
  cs := pwTokenLoginURL + 'src=ymsgr&' + 'token=' + token;
  resultString := performHttpGet(cs);
  nameValuePairs := TStringList.Create;
  try
    nameValuePairs.Delimiter := '&';
    nameValuePairs.DelimitedText := resultString;
    if nameValuePairs.Count = 1 then
    begin
      if nameValuePairs.Strings[0] = '100' then
        raise EMessengerException.Create(INVALID_TOKEN, 'Invalid TOKEN')
      else
        raise EMessengerException.Create(UNKNOWN_ERROR, 'Unkown Error');
    end
    else if nameValuePairs.Count > 18 then
    begin
      cookie := 'Y=' + nameValuePairs.Values['Y'] + '&' + 'n=' +
        nameValuePairs.Values['n'] + '&' + 'l=' + nameValuePairs.Values['l'] +
        '&' + 'p=' + nameValuePairs.Values['p'] + '&' + 'jb=' +
        nameValuePairs.Values['jb'] + '&' + 'iz=' + nameValuePairs.Values['iz']
        + '&' + 'r=' + nameValuePairs.Values['r'] + '&' + 'lg=' +
        nameValuePairs.Values['lg'] + '&' + 'intl=' + nameValuePairs.Values
        ['intl'] + '&' + 'np=' + nameValuePairs.Values['np'] + ' ' + 'T=' +
        nameValuePairs.Values['T'] + '&' + 'a=' + nameValuePairs.Values['a'] +
        '&' + 'sk=' + nameValuePairs.Values['sk'] + '&' + 'ks=' +
        nameValuePairs.Values['ks'] + '&' + 'd=' + nameValuePairs.Values['d'];
      loginData.cookie := cookie;
    end else
      raise EMessengerException.Create(UNKNOWN_ERROR, 'Unkown Error');
  finally
    nameValuePairs.Free;
  end;
end;

end.
