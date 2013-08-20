{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerBaseReqResp;

interface

uses
  YahooMessengerAuthentication, YahooMessengerConstants, superobject;

type
  TYahooMessengerBaseReqResp = class abstract(TObject)
  private
    FAuthentication: TYahooMessengerAuthentication;
    FSessionID: String;
    FRequestServer: String;
    function GetRequestServer: String;
  protected
    FCrumb: String;
  public
    //  Abstract class that must be overridden in a subclass.
    procedure ExecuteRequest(); virtual; abstract;
    //  JSON request serialization method. Override in a subclass if
    //  necessary.
    function SerializeJSONRequestParameters(): ISuperObject; virtual;
    //  JSON response serialization method. Override in a subclass if
    //  necessary.
    procedure unserializeJSONResponseParameters(o: ISuperObject); virtual;
  published
    Property RequestServer: String read GetRequestServer write FRequestServer;
    Property Authentication: TYahooMessengerAuthentication read FAuthentication
      write FAuthentication;
    // Request uri parameters common to all subclasses
    Property Crumb: String read FCrumb write FCrumb;
    Property SessionID: String read FSessionID write FSessionID;
  end;

implementation

{ TYahooMessengerBaseReqResp }

function TYahooMessengerBaseReqResp.GetRequestServer: String;
begin
  if FRequestServer = '' then
    FRequestServer := messengerServerURL;
  Result := FRequestServer;
end;

function TYahooMessengerBaseReqResp.SerializeJSONRequestParameters: ISuperObject;
begin
  Result := nil;
end;

procedure TYahooMessengerBaseReqResp.unserializeJSONResponseParameters(
  o: ISuperObject);
begin

end;

end.
