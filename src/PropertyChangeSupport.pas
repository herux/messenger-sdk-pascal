{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit PropertyChangeSupport;

interface

uses
  Classes, PropertyChangeListener;

type
  TPropertyChangeSupport = class(TObject)
  private
    Listeners: TList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure addPropertyChangeListener(l: IPropertyChangeListener);
    procedure removePropertyChangeListener(l: IPropertyChangeListener);
    procedure firePropertyChange(id: String; oldValue, newValue: TObject);
  end;

implementation

{ TPropertyChangeSupport }

procedure TPropertyChangeSupport.addPropertyChangeListener(
  l: IPropertyChangeListener);
begin
  Listeners.Add(l as TObject);
end;

constructor TPropertyChangeSupport.Create;
begin
  Listeners := TList.Create;
end;

destructor TPropertyChangeSupport.Destroy;
begin
  Listeners.Free;
  inherited;
end;

procedure TPropertyChangeSupport.firePropertyChange(id: String; oldValue,
  newValue: TObject);
var
  I: Integer;
  l: IPropertyChangeListener;
begin
  for I := 0 to Listeners.Count - 1 do
  begin
    l := IPropertyChangeListener(Listeners.Items[I]);
    l.propertyChanged(id, oldValue, newValue);
  end;
end;

procedure TPropertyChangeSupport.removePropertyChangeListener(
  l: IPropertyChangeListener);
begin
  Listeners.Remove(l as TObject);
end;

end.
