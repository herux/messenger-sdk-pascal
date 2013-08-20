{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit Group;

interface

uses
  ContactList;

type
  TGroup = class(TObject)
  private
    FName: string;
    FUri: string;
    FContactList: TContactList;
  published
    property Name: string read FName write FName;
    property ContactList: TContactList read FContactList write FContactList;
    property Uri: string read FUri write FUri;
  end;

implementation

end.
