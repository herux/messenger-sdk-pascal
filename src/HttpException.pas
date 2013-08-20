{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit HttpException;

interface

uses
  Classes, SysUtils;

type
  EHttpException = class(Exception);


const
  HTTP_OK_NOT_RECEIVED = 100;
  NO_AUTHENTICATION_GIVEN = 101;

implementation

end.
