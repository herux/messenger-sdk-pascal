{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}
unit Message;

interface

uses
  Response, superobject, SysUtils;

type
  TMessage = class(TInterfacedObject, IResponse)
  private
    FHash: string;
    FNetwork: string;
    FSequence: Integer;
    FMsg: String;
    FTimeStamp: TDateTime;
    FSender: string;
    FReceiver: string;
    FErrorCode: Integer;
  public
    procedure unserializeJSON(o: ISuperObject);

  published
    property Sequence: Integer read FSequence write FSequence;
    property Sender: string read FSender write FSender;
    property Network: string read FNetwork write FNetwork;
    property Receiver: string Read FReceiver write FReceiver;
    property TimeStamp: TDateTime read FTimeStamp write FTimeStamp;
    property Msg: String read FMsg write FMsg;
    property Hash: string read FHash write FHash;
    property ErrorCode: Integer read FErrorCode write FErrorCode;
  end;

implementation

{ TMessage }

procedure TMessage.unserializeJSON(o: ISuperObject);
begin
  // Mandatory fields

  Sequence := o.I['sequence'];
  Sender := o.S['sender'];
  Receiver := o.S['receiver'];
  Msg := o.S['msg'];

  // Optional fields

  Network := o.S['network'];
  TimeStamp := now; //o.I['timeStamp'];  change later using unixtodate
  Hash := o.S['hash'];
  ErrorCode := o.I['errorCode'];

end;

end.
