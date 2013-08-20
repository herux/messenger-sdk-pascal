{ **
  * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
  * Code licensed under the BSD License:
  * http://searchmarketing.yahoo.com/developer/docs/license.txt
  ******
  * pascal convertion by herux
  * }

unit YahooMessengerNotificationManager;

interface

uses
  Classes, PropertyChangeSupport, PropertyChangeListener, SessionData,
  YahooMessengerLoginManager, YahooMessengerGetNotificationsReqResp,
  NotificationData, Message;

type
  TYahooMessengerNotificationManager = class;

  TYahooMessengerNotificationThread = class(TThread)
  private
    FOwner: TYahooMessengerNotificationManager;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TYahooMessengerNotificationManager);
  end;

  TYahooMessengerNotificationNewMessageEvent = procedure(Sender: TObject;
    Msg: TMessage) of Object;

  TYahooMessengerNotificationManager = class(TObject)
  private
    FPropertyChangeSupport: TPropertyChangeSupport;
    t: TYahooMessengerNotificationThread;
    FOnNewMessage: TYahooMessengerNotificationNewMessageEvent;
    FSequence: Integer;
    FLoginManager: TYahooMessengerLoginManager;
  public
    constructor Create; overload;
    constructor Create(ALoginManager: TYahooMessengerLoginManager); overload;
    destructor Destroy; override;

    procedure addPropertyChangeListener(l: IPropertyChangeListener);
    procedure removePropertyChangeListener(l: IPropertyChangeListener);
    procedure getNewNotifications();

    property PropertyChangeSupport: TPropertyChangeSupport
      read FPropertyChangeSupport write FPropertyChangeSupport;
    property Sequence: Integer Read FSequence write FSequence;
    property OnNewMessage: TYahooMessengerNotificationNewMessageEvent
      read FOnNewMessage write FOnNewMessage;
  end;

const
  NOTIFICATION = 'Notification';

var
  instance: TYahooMessengerNotificationManager;

function getInstance(): TYahooMessengerNotificationManager;

implementation

function getInstance(): TYahooMessengerNotificationManager;
begin
  if instance = nil then
    instance := TYahooMessengerNotificationManager.Create;

  result := instance;
end;

{ TYahooMessengerNotificationManager }

procedure TYahooMessengerNotificationManager.addPropertyChangeListener
  (l: IPropertyChangeListener);
begin
  PropertyChangeSupport.addPropertyChangeListener(l);
end;

constructor TYahooMessengerNotificationManager.Create;
begin
  FPropertyChangeSupport := TPropertyChangeSupport.Create;
  t := TYahooMessengerNotificationThread.Create(Self);
  FSequence := 1;
end;

constructor TYahooMessengerNotificationManager.Create(ALoginManager
  : TYahooMessengerLoginManager);
begin
  FLoginManager := ALoginManager;
  FPropertyChangeSupport := TPropertyChangeSupport.Create;
  t := TYahooMessengerNotificationThread.Create(Self);
  FSequence := 1;
end;

destructor TYahooMessengerNotificationManager.Destroy;
begin
  if (t <> nil) or (not t.Terminated) then
    t.Terminate;
  FPropertyChangeSupport.Free;
  inherited;
end;

procedure TYahooMessengerNotificationManager.getNewNotifications();
var
  currentSessionData: TSessionData;
  getNotificationsRequest: TYahooMessengerGetNotificationsReqResp;
  n: TNotificationData;
  I: Integer;
begin
  if FLoginManager = nil then
    currentSessionData := YahooMessengerLoginManager.getInstance.
      currentSessionData
  else
    currentSessionData := FLoginManager.currentSessionData;
  getNotificationsRequest := TYahooMessengerGetNotificationsReqResp.Create;
  try

    getNotificationsRequest.RequestServer := currentSessionData.RequestServer;
    getNotificationsRequest.Authentication := currentSessionData.Authentication;
    getNotificationsRequest.SessionID := currentSessionData.SessionID;
    getNotificationsRequest.Crumb := currentSessionData.Crumb;
    getNotificationsRequest.Sequence := Sequence;
    getNotificationsRequest.Count := 100;
    getNotificationsRequest.executeRequest();

    n := TNotificationData.Create;
    try
      n.PendingMsg := getNotificationsRequest.PendingMsg;
      n.SyncStatus := getNotificationsRequest.SyncStatus;
      n.ResponseList := getNotificationsRequest.ResponseList;

      // PropertyChangeSupport.firePropertyChange(NOTIFICATION, nil, n);
      for I := Low(n.ResponseList.Responses)
        to High(n.ResponseList.Responses) do
      begin
        if n.ResponseList.Responses[I] is TMessage then
        begin
          // increment as much as Message.count
          // to remove notification from server, one by one
          inc(FSequence);
          if Assigned(FOnNewMessage) then
          begin
            FOnNewMessage(Self, TMessage(n.ResponseList.Responses[I]));
          end;
        end;
      end;
    finally
      n.Free;
    end;

  finally
    getNotificationsRequest.Free;
  end;

end;

procedure TYahooMessengerNotificationManager.removePropertyChangeListener
  (l: IPropertyChangeListener);
begin
  PropertyChangeSupport.removePropertyChangeListener(l);
end;

{ TYahooMessengerNotificationThread }

constructor TYahooMessengerNotificationThread.Create
  (AOwner: TYahooMessengerNotificationManager);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FOwner := AOwner;
end;

procedure TYahooMessengerNotificationThread.Execute;
const
  SecToExec = 8; // old = 5
var
  Count: Integer;
begin
  inherited;
  while not Terminated do
  begin
    inc(Count);
    if Count = SecToExec then
    begin
      Count := 0;
      try
        FOwner.getNewNotifications();
      except // silent error without closing the thread
      end;
    end;
    Sleep(500);
  end;
end;

end.
