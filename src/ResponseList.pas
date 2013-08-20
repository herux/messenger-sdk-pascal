{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit ResponseList;

interface

uses
  Response, superobject, Message, Classes, BuddyInfo, SysUtils;

type
  TResponseArray = array of IResponse;

  TResponseList = class(TObject)
  private
    FResponses: TResponseArray;
  public
    constructor Create;
    destructor Destroy; override;
    // JSON Serialization methods
    procedure unserializeJSON(a: ISuperObject);
  published
    Property Responses: TResponseArray read FResponses write FResponses;
  end;

implementation

{ TResponseList }

constructor TResponseList.Create;
begin
  FResponses := nil;
end;

destructor TResponseList.Destroy;
begin
  FResponses := nil;
  inherited;
end;

procedure TResponseList.unserializeJSON(a: ISuperObject);
var
  I: Integer;
  o: ISuperObject;
  c: TMessage;
  v: TList;
  b: TBuddyInfo;
  er: string;
begin
  if a = nil then Exit;
  
  SetLength(FResponses, a.AsArray.Length);
  // Mandatory fields
  for I := 0 to a.AsArray.Length - 1 do
  begin
    o := a.AsArray.o[I];
    if o.o['message'] <> nil then
    begin
      c := TMessage.Create;
      c.unserializeJSON(o.O['message']);
      FResponses[I] := c as IResponse;
    end;

    if o.o['buddyInfo'] <> nil then
    begin
      b := TBuddyInfo.Create;
      b.unserializeJSON(o.O['buddyInfo']);
      FResponses[I] := b as IResponse;
    end;
  end;
end;

end.
