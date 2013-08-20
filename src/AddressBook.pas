{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}
unit AddressBook;

interface

uses
  superobject;

type
  TAddressBook = class(TObject)
  private
    FHomeno: String;
    FLastModified: Integer;
    FEmail: String;
    FLastname: String;
    FMobileno: String;
    FNickname: String;
    FId: String;
    FFirstname: String;
    FWorkno: String;
  public
    procedure unserializeJSON(o: ISuperObject);
    function serializeJSON(): ISuperObject;
  published
    property Id: String read FId write FId;
    property Nickname: String read FNickname write FNickname;
    property Firstname: String read FFirstname write FFirstname;
    property Lastname: String read FLastname write FLastname;
    property Mobileno: String read FMobileno write FMobileno;
    property Homeno: String read FHomeno write FHomeno;
    property Workno: String read FWorkno write FWorkno;
    property Email: String read FEmail write FEmail;
    property LastModified: Integer read FLastModified write FLastModified;
  end;

implementation

{ TAddressBook }

function TAddressBook.serializeJSON: ISuperObject;
begin
  // Optional items
  Result := TSuperObject.Create(stObject);
  Result.S['id'] := Id;
  Result.S['nickname'] := Nickname;
  Result.S['firstname'] := Firstname;
  Result.S['lastname'] := Lastname;
  Result.S['mobileno'] := Mobileno;
  Result.S['homeno'] := Homeno;
  Result.S['workno'] := Workno;
  Result.S['email'] := Email;
  Result.I['lastModified'] := LastModified;
end;

procedure TAddressBook.unserializeJSON(o: ISuperObject);
begin
  // Optional items

  Id := o.S['id'];
  Nickname := o.S['nickname'];
  Firstname := o.S['firstname'];
  Lastname := o.S['lastname'];
  Mobileno := o.S['mobileno'];
  Homeno := o.S['homeno'];
  Workno := o.S['workno'];
  Email := o.S['email'];
  LastModified := o.I['lastModified'];
end;

end.
