{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerGetNotificationsReqResp;

interface

uses
  YahooMessengerBaseReqResp, ResponseList, MessengerException,
  YahooMessengerConstants, HttpUtils, superobject, SysUtils;

type
  TYahooMessengerGetNotificationsReqResp = class(TYahooMessengerBaseReqResp)
  private
    FSequence: Integer;
    FSyncStatus: Integer;
    FCount: Integer;
    FPendingMsg: Integer;
    FResponseList: TResponseList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure executeRequest();
    procedure unserializeJSONResponseParameters(o: ISuperObject);
  published
    // Request URI parameters

    property Sequence: Integer read FSequence write FSequence;
    property Count: Integer read FCount write FCount;

    // Response parameters

    property PendingMsg: Integer read FPendingMsg write FPendingMsg;
    property SyncStatus: Integer read FSyncStatus write FSyncStatus;
    property ResponseList: TResponseList read FResponseList write FResponseList;

  end;

implementation

{ TYahooMessengerGetNotificationsReqResp }

constructor TYahooMessengerGetNotificationsReqResp.Create;
begin
  FResponseList := TResponseList.Create;
  FSequence := -1;
  FCount := -1
end;

destructor TYahooMessengerGetNotificationsReqResp.Destroy;
begin
  FResponseList.Free;
  inherited;
end;

procedure TYahooMessengerGetNotificationsReqResp.executeRequest;
var
  url, responseString: string;
  response: ISuperObject;
begin
  // Verify mandatory parameters

  if Crumb = '' then
    raise EMessengerException.Create(NO_CRUMB_GIVEN, 'No crumb given');

  if SessionID = '' then
    raise EMessengerException.Create(NO_SESSION_ID_GIVEN,
      'No session ID given');
  if Sequence = -1 then
    raise EMessengerException.Create(NO_SEQUENCE_GIVEN, 'No sequence given');

  // Create the HTTP URL

  url := 'http://' + RequestServer + notificationManagementURL + '?c=' + Crumb +
    '&sid=' + SessionID + '&seq=' + intToStr(Sequence);


  // Add optional URI parameters

  if (Count > -1) then
    url := url + '&count=' + intToStr(Count);


  // Add authentication parameters

  url := url + Authentication.getOAuthParameters;

  // Perform the actual call to the server

  responseString := performHttpGet(url, Authentication);

  response := TSuperObject.ParseString(PWideChar(responseString), True);
  try
    if response <> nil then
      unserializeJSONResponseParameters(response)
    else
      raise EMessengerException.Create(UNKNOWN_SERVER_ERROR, 'Unknown error');
  finally
    response := nil;
  end;
end;

procedure TYahooMessengerGetNotificationsReqResp.
  unserializeJSONResponseParameters(o: ISuperObject);
begin
  // Mandatory fields

  ResponseList.unserializeJSON(o.O['responses']);

  // Optional fields

  PendingMsg := o.I['@pendingMsg'];
  SyncStatus := o.I['@syncStatus'];
end;

end.
