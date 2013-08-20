{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}
 unit ContactList;

interface

uses
  superobject, {Presence,} AddressBook, ClientCapabilityList;

type
  TGroupList = class;

  TContact = class(TObject)
  private
    FNetwork: string;
    FClientCapabilities: TClientCapabilityList;
    FAddressBook: TAddressBook;
    FAuthorized: Integer;
    FId: String;
    FGroupList: TGroupList;
    FUri: String;
    // FPresence: TPresence;
  public
    procedure unserializeJSON(o: ISuperObject);
    function serializeJSON(): ISuperObject;
  published
    property Id: String read FId write FId;
    property Network: string read FNetwork write FNetwork;
    property Authorized: Integer read FAuthorized write FAuthorized;
    property Groups: TGroupList read FGroupList write FGroupList;
    // property Presence: TPresence read FPresence write FPresence;
    property AddressBook: TAddressBook read FAddressBook write FAddressBook;
    property ClientCapabilities: TClientCapabilityList read FClientCapabilities
      write FClientCapabilities;
    property Uri: String read FUri write FUri;
  end;

  TContactArray = array of TContact;

  TContactList = class(TObject)
  private
    FContacts: TContactArray;
  public
    procedure unserializeJSON(a: ISuperObject);
    function serializeJSON(): ISuperObject;
  published
    property Contacts: TContactArray read FContacts write FContacts;
  end;

  TGroup = class(TObject)
  private
    FName: string;
    FUri: string;
    FContactList: TContactList;
  public
    procedure unserializeJSON(o: ISuperObject);
    function serializeJSON(): ISuperObject;
  published
    property Name: string read FName write FName;
    property ContactList: TContactList read FContactList write FContactList;
    property Uri: string read FUri write FUri;
  end;

  TGroupArray = array of TGroup;

  TGroupList = class(TObject)
  private
    FGroups: TGroupArray;
  public
    procedure unserializeJSON(a: ISuperObject);
    function serializeJSON(): ISuperObject;
  published
    property Groups: TGroupArray read FGroups write FGroups;
  end;

implementation

{ TContactList }

function TContactList.serializeJSON: ISuperObject;
var
  a: ISuperObject;
  I: Integer;
  c: TContact;
  o: ISuperObject;
begin
  a := TSuperObject.Create(stArray);

  // Mandatory items

  for I := Low(Contacts) to High(Contacts) do
  begin
    c := TContact.Create;
    o := TSuperObject.Create(stObject);
    o.o['contact'] := c.serializeJSON;
    a.AsArray.Add(o);
  end;

  Result := a;
end;

procedure TContactList.unserializeJSON(a: ISuperObject);
var
  I: Integer;
  o: ISuperObject;
  c: TContact;
begin
  SetLength(FContacts, a.AsArray.Length);
  for I := 0 to a.AsArray.Length - 1 do
  begin
    o := TSuperObject.Create(stObject);
    c := TContact.Create;
    c.unserializeJSON(o.o['contact']);
    FContacts[I] := c;
  end;
end;

{ TGroupList }

function TGroupList.serializeJSON: ISuperObject;
var
  a: ISuperObject;
  I: Integer;
  c: TGroup;
  o: ISuperObject;
begin
  a := TSuperObject.Create(stArray);

  // Mandatory items

  for I := Low(Groups) to High(Groups) do
  begin
    c := TGroup.Create;
    o := TSuperObject.Create(stObject);
    o.o['group'] := c.serializeJSON;
    a.AsArray.Add(o);
  end;

  Result := a;

end;

procedure TGroupList.unserializeJSON(a: ISuperObject);
var
  I: Integer;
  o: ISuperObject;
  c: TGroup;
begin
  SetLength(FGroups, a.AsArray.Length);
  for I := 0 to a.AsArray.Length - 1 do
  begin
    o := TSuperObject.Create(stObject);
    c := TGroup.Create;
    c.unserializeJSON(o.o['group']);
    FGroups[I] := c;
  end;

end;

{ TContact }

function TContact.serializeJSON: ISuperObject;
var
  o: ISuperObject;
begin
  // Mandatory items

  o.S['id'] := Id;
  o.S['uri'] := Uri;

  // Optional items

  o.S['network'] := Network;
  o.I['authorized'] := Authorized;
  o.o['groups'] := Groups.serializeJSON;
  // o.put("presence", getPresence().serializeJSON());
  o.o['addressbook'] := AddressBook.serializeJSON;
  o.o['clientCapabilities'] := ClientCapabilities.serializeJSON;

  Result := o;

end;

procedure TContact.unserializeJSON(o: ISuperObject);
begin
  // Mandatory fields

  Id := o.S['id'];
  Uri := o.S['uri'];

  // Optional fields

  Network := o.S['network'];
  Authorized := o.I['authorized'];
  Groups.unserializeJSON(o.o['groups']);
  // Presence.unserializeJSON(o.getJSONObject("presence"));
  AddressBook.unserializeJSON(o.o['addressbook']);
  ClientCapabilities.unserializeJSON(o.o['clientCapabilities']);
end;

{ TGroup }

function TGroup.serializeJSON: ISuperObject;
begin
  Result := TSuperObject.Create(stObject);
  Result.S['name'] := Name;
  Result.S['uri'] := Uri;
  if ContactList <> nil then
    Result.o['contacts'] := ContactList.serializeJSON;
end;

procedure TGroup.unserializeJSON(o: ISuperObject);
begin
  Name := o.S['name'];
  Uri := o.S['uri'];
  if o.o['contacts'] <> nil then
    ContactList.unserializeJSON(o.o['contacts']);
end;

end.
