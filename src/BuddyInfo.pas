{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}
unit BuddyInfo;

interface

uses
  Response, BuddyInfoContactList, superobject;

type
  TBuddyInfo = class(TInterfacedObject, IResponse)
  private
    FNetwork: string;
    FSequence: Integer;
    FBuddyInfoContactList: TBuddyInfoContactList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure unserializeJSON(o: ISuperObject);
  published
    property Sequence: Integer read FSequence write FSequence;
    property Network: string read FNetwork write FNetwork;
    property BuddyInfoContactList: TBuddyInfoContactList
      read FBuddyInfoContactList write FBuddyInfoContactList;
  end;

implementation

{ TBuddyInfo }

constructor TBuddyInfo.Create;
begin
  FBuddyInfoContactList := TBuddyInfoContactList.Create;
end;

destructor TBuddyInfo.Destroy;
begin
  FBuddyInfoContactList.Free;
  inherited;
end;

procedure TBuddyInfo.unserializeJSON(o: ISuperObject);
begin
  // Mandatory fields

  Sequence := o.I['sequence'];
  BuddyInfoContactList.unserializeJSON(o.O['contact']);

  // Optional fields

  if o.O['network'] <> nil then
    Network := o.S['network'];
end;

end.
