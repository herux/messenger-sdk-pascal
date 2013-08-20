{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit BuddyInfoContactList;

interface

uses
  BuddyInfoContact, superobject, Classes, Contnrs;

type
  TBuddyInfoContactArray = array of TBuddyInfoContact;

  TBuddyInfoContactList = class(TObject)
  private
    FBuddyInfoContacts: TBuddyInfoContactArray;
  public
    // JSON Serialization methods
    procedure unserializeJSON(a: ISuperObject);
  published
    property BuddyInfoContacts: TBuddyInfoContactArray read FBuddyInfoContacts
      write FBuddyInfoContacts;
  end;

implementation

{ TBuddyInfoContactList }

procedure TBuddyInfoContactList.unserializeJSON(a: ISuperObject);
var
  I: Integer;
  o: ISuperObject;
  c: TBuddyInfoContact;
begin
  if a = nil then Exit;

  SetLength(FBuddyInfoContacts, a.AsArray.Length);
  for I := 0 to a.AsArray.Length - 1 do
  begin
    o := a.AsArray.o[I];
    c := TBuddyInfoContact.Create;
    c.unserializeJSON(o);
    FBuddyInfoContacts[I] := c;
  end;
end;

end.
