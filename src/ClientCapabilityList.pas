{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit ClientCapabilityList;

interface

uses
  ClientCapability, superobject;

type
  TClientCapabilityArray = array of TClientCapability;

  TClientCapabilityList = class(TObject)
  private
    FClientCapabilities: TClientCapabilityArray;
  public
    procedure UnserializeJSON(a: ISuperObject);
    function SerializeJSON(): ISuperObject;

    property ClientCapabilities: TClientCapabilityArray read FClientCapabilities write FClientCapabilities;
  end;

implementation

{ TClientCapabilityList }

function TClientCapabilityList.SerializeJSON: ISuperObject;
var
  I: Integer;
  c: TClientCapability;
  o: ISuperObject;
begin
  Result := TSuperObject.Create(stArray);
  //  Mandatory items
  for I := Low(ClientCapabilities) to High(ClientCapabilities) do
  begin
    c := ClientCapabilities[I];
    o := TSuperObject.Create(stObject);
    o.O['clientCapability'] := c.SerializeJSON;
    Result.AsArray.Add(o);
  end;
end;

procedure TClientCapabilityList.UnserializeJSON(a: ISuperObject);
var
  I: Integer;
  o: ISuperObject;
  c: TClientCapability;
begin
  for I := 0 to a.AsArray.Length - 1 do
  begin
    o := a.AsArray.O[I];
    c := TClientCapability.Create;
    c.UnserializeJSON(o.O['clientCapability']);
  end;
end;

end.
