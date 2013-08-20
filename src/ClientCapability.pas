{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit ClientCapability;

interface

uses
  superobject;

type
  TClientCapability = class(TObject)
  private
    FClientCapability: string;
  public
    procedure UnserializeJSON(o: ISuperObject);
    function SerializeJSON: ISuperObject;

    property ClientCapability: string read FClientCapability write FClientCapability;
  end;

implementation

{ TClientCapability }

function TClientCapability.SerializeJSON: ISuperObject;
begin
  Result := TSuperObject.Create(stObject);
  Result.S['clientCapability'] := ClientCapability;
end;

procedure TClientCapability.UnserializeJSON(o: ISuperObject);
begin
  ClientCapability := o.S['clientCapability'];
end;

end.
