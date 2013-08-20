{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit MessengerException;

interface

uses
  SysUtils;

const
  UNKNOWN_USERNAME = 101;
  INCORRECT_PASSWORD = 102;
  INVALID_TOKEN = 103;
  NO_USERNAME_GIVEN = 104;
  ALREADY_LOGGED_IN = 105;
  NO_PASSWORD_GIVEN = 106;
  NO_CONSUMER_KEY_GIVEN = 107;

  NO_CRUMB_GIVEN = 110;
  NO_SESSION_ID_GIVEN = 111;

  NO_NETWORK_GIVEN = 120;
  NO_TARGET_ID_GIVEN = 121;
  NO_CONTACT_ID_GIVEN = 122;

  NO_SEQUENCE_GIVEN = 130;


  JSON_PARSER_EXCEPTION = 990;

  UNKNOWN_SERVER_ERROR = 998;
  UNKNOWN_ERROR = 999;

type
  EMessengerException = class(Exception)
  private
    fCode: Integer;
    function GetCode: Integer;
  public
    constructor Create(code: Integer); overload;
    constructor Create(code: Integer; message: string); overload;
    constructor Create(message: string); overload;

    property code: Integer read GetCode;
  end;

implementation

{ EMessengerException }

constructor EMessengerException.Create(code: Integer; message: string);
begin
  inherited Create(message);
  fCode := code;
end;

constructor EMessengerException.Create(code: Integer);
begin
  inherited Create('');
  fCode := code;
end;

constructor EMessengerException.Create(message: string);
begin
  inherited Create(message);
  fCode := UNKNOWN_ERROR;
end;

function EMessengerException.GetCode: Integer;
begin
  Result := fCode;
end;

end.
