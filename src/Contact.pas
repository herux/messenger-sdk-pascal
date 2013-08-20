{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}
unit Contact;

interface

uses
  ContactList, {Presence, }AddressBook, ClientCapabilityList;

type
  TContact = class(TObject)
  private
    FNetwork: string;
    FClientCapabilities: TClientCapabilityList;
    FAddressBook: TAddressBook;
    FAuthorized: Integer;
    FId: String;
    FGroupList: TGroupList;
    FUri: String;
//    FPresence: TPresence;
  published
    property Id: String read FId write FId;
    property Network: string read FNetwork write FNetwork;
    property Authorized: Integer read FAuthorized write FAuthorized;
    property Groups: TGroupList read FGroupList write FGroupList;
//    property Presence: TPresence read FPresence write FPresence;
    property AddressBook: TAddressBook read FAddressBook write FAddressBook;
    property ClientCapabilities: TClientCapabilityList read FClientCapabilities write FClientCapabilities;
    property Uri: String read FUri write FUri;
  end;

implementation

end.
