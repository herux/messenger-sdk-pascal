{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit SessionData;

interface

uses
  YahooMessengerAuthentication, ClientCapabilityList, Types, Classes;

type
  TSessionData = class(TObject)
  private
    FNotifyServer: String;
    FCookie: String;
    FLoggedIn: Integer;
    FLoginPresenceState: Integer;
    FClientCapabilities: TClientCapabilityList;
    FCrumb: String;
    FAuthentication: TYahooMessengerAuthentication;
    FSessionID: String;
    FFieldsBuddyList: String;
    FNotifyServerToken: String;
    FPrimaryLoginID: String;
    FProfileLoginIDs: TStringDynArray;
    FRequestServer: String;
    FLoginPresenceMessage: String;
    FDisplayInfo: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Crumb: String read FCrumb write FCrumb;
    property SessionID: String read FSessionID write FSessionID;
    property Authentication: TYahooMessengerAuthentication read FAuthentication write FAuthentication;

    //  Request parameters

    property NotifyServerToken: String read FNotifyServerToken write FNotifyServerToken;
    property FieldsBuddyList: String read FFieldsBuddyList write FFieldsBuddyList;
    property LoginPresenceState: Integer read FLoginPresenceState write FLoginPresenceState;
    property LoginPresenceMessage: String read FLoginPresenceMessage write FLoginPresenceMessage;

    //  Response parameters

    property Cookie: String read FCookie write FCookie;
    property LoggedIn: Integer read FLoggedIn write FLoggedIn;
    property RequestServer: String read FRequestServer write FRequestServer;
    property NotifyServer: String read FNotifyServer write FNotifyServer;
    property DisplayInfo: TStringList read FDisplayInfo write FDisplayInfo;
    property PrimaryLoginID: String read FPrimaryLoginID write FPrimaryLoginID;
    property ProfileLoginIDs: TStringDynArray read FProfileLoginIDs write FProfileLoginIDs;
    property ClientCapabilities: TClientCapabilityList read FClientCapabilities write FClientCapabilities;
  end;

implementation

{ TSessionData }

constructor TSessionData.Create;
begin
  FDisplayInfo := TStringList.Create;
  FClientCapabilities := TClientCapabilityList.Create;
end;

destructor TSessionData.Destroy;
begin
  FDisplayInfo.Free;
  FClientCapabilities.Free;
  inherited;
end;

end.
