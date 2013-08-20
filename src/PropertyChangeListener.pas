{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit PropertyChangeListener;

interface

type
  IPropertyChangeListener = interface
    procedure propertyChanged(id: String; oldValue, newValue: TObject);
  end;

implementation

end.
