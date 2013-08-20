{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}
unit NotificationData;

interface

uses
  ResponseList;

type
  TNotificationData = class(TObject)
  private
    FSyncStatus: integer;
    FPendingMsg: Integer;
    FResponseList: TResponseList;
  published
    property PendingMsg: Integer read FPendingMsg write FPendingMsg;
    property SyncStatus: integer read FSyncStatus write FSyncStatus;
    property ResponseList: TResponseList read FResponseList write FResponseList;
  end;

implementation

end.
