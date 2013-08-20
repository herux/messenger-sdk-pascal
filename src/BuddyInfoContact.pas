{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit BuddyInfoContact;

interface

uses
  Response, superobject;

type
  TBuddyInfoContact = class(TInterfacedObject, IResponse)
  private
    FAvatarPreference: string;
    FNetwork: string;
    FPresenceMessage: string;
    FClientCapabilities: integer;
    FPresenceState: integer;
    FAvatarHash: string;
    FClientType: string;
    FCustomDNDStatus: integer;
    FChecksum: string;
    FSender: string;
  public
    // JSON Serialization methods

    procedure unserializeJSON(o: ISuperObject);

  published
    Property Sender: string read FSender write FSender;
    Property PresenceState: integer read FPresenceState write FPresenceState;
    Property PresenceMessage: string read FPresenceMessage
      write FPresenceMessage;
    Property ClientType: string read FClientType write FClientType;
    Property CustomDNDStatus: integer read FCustomDNDStatus
      write FCustomDNDStatus;
    Property ClientCapabilities: integer read FClientCapabilities
      write FClientCapabilities;
    Property AvatarPreference: string read FAvatarPreference
      write FAvatarPreference;
    Property AvatarHash: string read FAvatarHash write FAvatarHash;
    Property Checksum: string read FChecksum write FChecksum;
    Property Network: string read FNetwork write FNetwork;
  end;

implementation

{ TBuddyInfoContact }

procedure TBuddyInfoContact.unserializeJSON(o: ISuperObject);
begin
  // Mandatory fields

  Sender := o.S['sender'];
  PresenceState := o.I['presenceState'];
  ClientCapabilities := o.I['clientCapabilities'];

  // Optional fields

  PresenceMessage := o.S['presenceMessage'];
  ClientType := o.S['clientType'];
  CustomDNDStatus := o.I['customDNDStatus'];
  AvatarPreference := o.S['avatarPreference'];
  AvatarHash := o.S['avatarHash'];
  Checksum := o.S['checksum'];
  Network := o.S['network'];
end;

end.
