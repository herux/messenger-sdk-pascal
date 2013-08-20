{**
 * Copyright (c) 2009-2010, Yahoo! Inc. All rights reserved.
 * Code licensed under the BSD License:
 * http://searchmarketing.yahoo.com/developer/docs/license.txt
 ******
 * pascal convertion by herux
 *}

unit YahooMessengerConstants;

interface

const
    debugHttpRequestResponse = 1;

    loginServerURL = 'https://login.yahoo.com';
    apiLoginServerURL = 'https://api.login.yahoo.com';
    //        "https://yosgamma.api.login.yahoo.com";

    pwTokenGetURL = loginServerURL + '/config/pwtoken_get?';
    pwTokenLoginURL = loginServerURL + '/config/pwtoken_login?';
    partTokenGetURL = loginServerURL + '/WSLogin/V1/get_auth_token';
    exchangePARTGetURL = apiLoginServerURL + '/oauth/v2/get_token';

    stagingServerURL = 'stage.rest-core.msg.yahoo.com';
    mobileProductionServerURL = 'mobile.rest-core.msg.yahoo.com';
    stagingServerOAuthURL = 'stage-ydn.rest-core.msg.yahoo.com';
    messengerServerURL = mobileProductionServerURL;//stagingServerURL;

//  authenticationConsumerKey = 'dj0yJmk9YmVSZkFRQjJNdU9aJmQ9WVdrOVFtOWhjM1prTnpnbWNHbzlOekkzTmpBMU9UWXkmcz1jb25zdW1lcnNlY3JldCZ4PTJl';
//  authenticationConsumerSecret = 'd7824ee7ff07b5ab423abf06bc8f24aea4bdb1a6';

    // hersuck77 :
    authenticationConsumerKey = 'dj0yJmk9TncwdVo2VlhQa1NwJmQ9WVdrOVl6WkpVVWhGTXpBbWNHbzlOamt5T1RnNE5EWXkmcz1jb25zdW1lcnNlY3JldCZ4PThm';
    authenticationConsumerSecret = '9f933ce3e9f6825b0cf2111b4e89da65f9c0f3e4';


    deleteSuffix = '_method=delete';
    putSuffix = '_method=put';
    createSuffix = '_method=create';

    messengerAPIVersion = '/v1';

    sessionManagementURL = messengerAPIVersion + '/session';
    sessionManagementKeepaliveURL = messengerAPIVersion + '/session/keepalive';
    presenceManagementURL = messengerAPIVersion + '/presence';
    contactListManagementURL = messengerAPIVersion + '/contacts';
    contactManagementURL = messengerAPIVersion + '/contact';
    messageManagementURL = messengerAPIVersion + '/message';
    notificationManagementURL = messengerAPIVersion + '/notifications';

implementation

end.
