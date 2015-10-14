# IBM Bluemix Mobile Services - Client SDK Cordova

This plugin for Cordova provides access to IBM Bluemix Mobile Services used for logging and analytics.

## Contents
- <a href="#installation">Installation</a>
- <a href="#configure-ios">Configuration</a>
    - <a href="#configure-ios">Configuring Your App for iOS</a>
    - <a href="#configure-android">Configuring Your App for Android</a>
- <a href="#bmsclient">Usage</a>
    - <a href="#bmsclient">BMSClient</a>
    - <a href="#mfprequest">MFPRequest</a>
    - <a href="#mfplogger">MFPLogger</a>
    - <a href="#mfpanalytics">MFPAnalytics</a>
- <a href="#examples">Examples</a>

<h2 id="installation">Installation</h2>

**_TODO Include info on adding platforms_**

Run the following command from your Cordova application's root directory to add the ibm-mfp-core plugin:
```
$ cordova plugin install ibm-mfp-core
```
You can check if the plugin installed successfully by running the following command, which lists your installed Cordova plugins:
```
$ cordova plugin list
```
<h2 id="configure-ios">Configuring Your App for iOS</h2>
- Make sure your Xcode version is at least 7.0

- Open HelloCordova.xcworkspace from [your-app-name]/platforms/ios/HelloCordova in Xcode

- Make sure to change iOS deployment target to at least 7.0. This is required for using Swift

- Including the IMFCore framework:
    - In [your-app-name]/platforms/ios add a folder named "Frameworks"
    - Download IFMCore.framework from [HERE](https://hub.jazz.net/project/bluemixmobilesdk/imf-ios-sdk/overview#https://hub.jazz.net/git/bluemixmobilesdk%252Fimf-ios-sdk/list/master/Frameworks/IMFCore.framework) and copy it to the Frameworks folder

- Configuring your project in Xcode:

    - Click on your app name in the project directory and navigate to Build Phases => Link Library with Libraries

    - Make sure the IMFCore.framework was added

    - Navigate to Build Settings => Search Paths => Framework Search Paths and add the following:
        - $(inherited)
        - $(PROJECT_DIR)/Frameworks

    - Navigate to Build settings => search for “bridging” => Objective-C Bridging Header and add the following:
        - [your-app-name]/Plugins/ibm-mfp-core/Bridging-Header.h

    - Navigate to Build Settings => Linking => Runpath Search Paths and add the following
        - @executable_path/Frameworks

<h2 id="configure-android">Configuring Your App for Android</h2>

<h2 id="bmsclient">BMSClient</h2>

BMSClient is your entry point to the MobileFirst services. Initializing the BMSClient is required before sending a request that requires authorization.

BMSClient functions available:

Function | Use
--- | ---
`initialize(bluemixAppRoute, bluemixAppGUID)` | Sets the base URL for the authorization server. This method should be called before you send the first request that requires authorization.
`getBluemixAppRoute(callback)` | Return the Bluemix app route.
`getBluemixAppGUID(callback)` | Return the Bluemix app GUID.
`registerAuthenticationListener(realm, authenticationListener)` | Registers authentication callback for the specified realm.
`unregisterAuthenticationListener(realm)` | Unregisters the authentication callback for the specified realm.

Example:
```
BMSClient.initialize("https://myapp.mybluemix.net", "abcd12345abcd12345");
```

<h2 id="mfprequest">MFPRequest</h2>

After initializing the client you may create a new MFPRequest instance, used to send a request to a specified URL.

MFPRequest functions available:

Function | Use
--- | ---
`setHeaders(jsonObj)` | Set the headers for the request object in JSON format.
`getHeaders` | Return the headers object for the request object.
`getUrl` | Return the url for this request.
`getMethod` | Return the HTTP method for this request.
`getTimeout` | Return the timeout (in ms) for this request.
`setQueryParameters(jsonObj)` | Return the queryParameters object for this request.
`getQueryParameters` | Set the Query Parameters for the request object in JSON format.
`send(success, failure)` | Send this resource request asynchronously. You must supply success and failure callback functions, and optionally a body parameter.

Success and failure callbacks of the MFPRequest.send() receive a response object as an argument (see <a href="#examples">Examples</a>). The following properties are available for the response:

Property | Info
--- | ---
status | The response status as an integer.
responseText | Return response text as null or string.
headers | Return response headers in JSON format.
errorCode | Return response error code as integer. 
errorDescription | Return response error description as null or string.

Request methods available:

Method |
--- |
MFPRequest.GET |
MFPRequest.PUT |
MFPRequest.POST |
MFPRequest.DELETE |
MFPRequest.TRACE |
MFPRequest.HEAD |
MFPRequest.OPTIONS |

Example:
```
var request = new MFPRequest("/myapp/API/action", MFPRequest.GET);
```

<h2 id="mfplogger">MFPLogger</h2>

MFPLogger is a Singleton class used for logging messages. 

MFPLogger functions available:

Function | Use
--- | ---
`getInstance(name)` | Return a named logger instance.
`getCapture(success, failure)` | Get the current setting for determining if log data should be saved persistently.
`setCapture(enabled)` | Global setting: turn on or off the persisting of the log data that is passed to the log methods of this class.
`getFilters(success, failure)` | Retrieve the filters that are used to determine which log messages are persisted.
`setFilters(filters)` | Set the filters that are used to determine which log messages are persisted. Each key defines a name and each value defines a logging level.
`getMaxStoreSize(success, failure)` | Gets the current setting for the maximum storage size threshold.
`setMaxStoreSize(size)` | Set the maximum size of the local persistent storage for queuing log data. When the maximum storage size is reached, no more data is queued. This content of the storage is sent to a server.
`getLevel(success, failure)` | Get the currently configured Log Level.
`setLevel(logLevel)` | Set the level from which log messages must be saved and printed. For example, passing MFPLogger.INFO logs INFO, WARN, and ERROR.
`isUncaughtExceptionDetected(success, failure)` | Indicates that an uncaught exception was detected. The indicator is cleared on successful send.
`send` | Send the log file when the log store exists and is not empty. If the send fails, the local store is preserved. If the send succeeds, the local store is deleted.

See below for <a href="#examples">Examples</a> of how to use MFPLogger.

You can create an instance of MFPLogger using:
```
MFPLogger.getInstance("myLogger")
```
The following functions are available for the logger instance to send a specific log message:

Function |
--- |
`debug(message)` |
`info(message)` |
`warn(message)` | 
`error(message)` |
`fatal(message)` |
Example:
```
myLogger.debug(message)
```

See below for <a href="#examples">Examples</a> of how to use MFPLogger.

<h2 id="mfpanalytics">MFPAnalytics</h2>

<h2 id="examples">Examples</h2>

### To initialize:
The following Javascript code is your entry point to the MobileFirst services. This method should be called before your send the first request that requires authorization.
```
BMSClient.initialize("https://myapp.mybluemix.net", "abcd12345abcd12345");
```
The first parameter specifies the base URL for the authorization server.
The second parameter specifies the GUID of the application.

### Creating a Request 
After initializing the client you may create a new MFPRequest instance by specifiying a URL endpoint, request method, and an optional timeout value.
```
var request = new MFPRequest("/myapp/API/action", MFPRequest.GET, 20000);
```

### Setting the headers for your request. 
(More Explanation of code snippet below this line)
```
var headers = {
    header1: ["val1"]
    header2: ["val2", "val3"]
}
request.setHeaders(headers)
```

### Setting your MFPRequest's query parameters
```
var queryParams = {
    param1: "val1",
    param2: "val2
}
request.setQueryParameters(queryParams)
```

###Sending the request
(A more detailed explanation here. Elaborate on the Response)

```
request.send("some body",
    function(successResponse){
        console.log("status :: " + successResponse.status);
        console.log("headers :: " + successResponse.headers);
    }, 
    function (failureResponse){
        console.log("errorCode:: " + failureResponse.errorCode);
        console.log("errorDescription :: " + failureResponse.errorDescription);
    }
)
```

The successResponse or failureResponse are JSON objects that will be passed to your callbacks with the following fields:

```
response.status  =>  Integer
response.responseText  =>  Undefined or String
response.headers  =>  Object
response.errorCode  =>  Integer 
response.errorDescription  =>  Undefined or String
```
## MFPAnalytics
When you show example for method:

ios:
```
code here
```
android:
```
code here
```
note difference between. The ios version of this method takes no arguments, whereas Android version does this

Copyright 2015 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
