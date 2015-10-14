# IBM Bluemix Mobile Services - Client SDK Cordova

This plugin for Cordova provides access to IBM Bluemix Mobile Services used for logging and analytics.

## Contents
- <a href="#installation">Installation</a>
- <a href="#configure-ios">Configuration</a>
    - <a href="#configure-ios">Configuring Your App for iOS</a>
    - <a href="#configure-android">Configuring Your App for Android</a>
- <a href="#usage">Usage</a>
    - <a href="#bmsclient">BMSClient</a>
    - <a href="#mfprequest">MFPRequest</a>
    - <a href="#mfplogger">MFPLogger</a>
    - <a href="#mfpanalytics">MFPAnalytics</a>
- <a href="#examples">Examples</a> 
    - <a href="#using-bmsclient">Using BMSClient and MFPRequest</a> 
    - <a href="#using-mfplogger">Using MFPLogger</a>
    - <a href="#using-mfpanalytics">Using MFPAnalytics</a> 

<h2 id="installation">Installation</h2>

### Install necessary libraries
The Cordova library is required to use this plugin. Use the following commands to install it and other necessary tools.

**Homebrew**
```
$ ruby -e “$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)”```
```

**Node Package Manager (npm)**
```
$ brew install npm
```

**Cordova**
```
$ npm install -g cordova
```

### Add your app platform

You have to generate your app's platform before adding the plugin.

To generate the iOS platform:
```
$ cordova platform add ios
```

To generate the Android platform:
```
$ cordova platform add android
```

You should see a "Platforms" folder added to your app's directory.

### Add the Cordova plugin

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

In your Cordova app, you need to make sure your config.xml file is configured for the right API:

The minimum API that the BMS Android SDK supports is level 15 (Ice Cream Sandwich):

- Open your config.xml and look for the section:
    - `<platform name="android">`
- Add the following
    - `<preference name="android-minSdkVersion" value="15" />`
- (Optional) If you wish to target a specific Android API Level, you can use the following:
    - `<preference name="android-targetSdkVersion" value="23" />`  

<h2 id="usage">Usage</h2>

<h3 id="bmsclient">BMSClient</h3>

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

<h3 id="mfprequest">MFPRequest</h3>

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

<h3 id="mfplogger">MFPLogger</h3>

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

See below for more <a href="#examples">Examples</a> of how to use MFPLogger.

<h3 id="mfpanalytics">MFPAnalytics</h3>

MFPAnalytics is used for sending analytics logs.

MFPAnalytics functions available:

Function | Use
--- | ---
`enable` | Turn on the global setting for persisting of the analytics data.
`disable` | Turn off the global setting for persisting of the analytics data.
`isEnabled(success, failure)` | Get the current setting for determining if log data should be saved persistently.
`send(success, failure)` | Send the analytics log file when the log store exists and is not empty. If the send fails, the local store is preserved. If the send succeeds, the local store is deleted.

See below for <a href="#examples">Examples</a> of how to use MFPAnalytics.

<h2 id="examples">Examples</h2>

<h3 id="using-bmsclient">Using BMSClient and MFPRequest</h3>

The following Javascript code is your entry point to the MobileFirst services. This method should be called before your send the first request that requires authorization.
```
BMSClient.initialize("https://myapp.mybluemix.net", "abcd12345abcd12345");
```
The first parameter specifies the base URL for the authorization server.
The second parameter specifies the GUID of the application.

### Creating a request 
After initializing the client you may create a new MFPRequest instance by specifiying a URL endpoint, request method, and an optional timeout value.
```
var request = new MFPRequest("/myapp/API/action", MFPRequest.GET, 20000);
```

### Setting the headers for your request 
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

### Sending the request

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

<h3 id="using-mfplogger">Using MFPLogger</h3>

Below are some examples of how to use the MFPLogger class.

```
var myPackageLogger = MFPLogger.getInstance("myPackage");

// Persist logs to a file
MFPLogger.setCapture(true);

// Globally set the logging level
MFPLogger.setLevel(MFPLogger.WARN);

// Log a message at FATAL level
myPackageLogger.fatal("Fatal level message");

// Only use the logger specified here. All others will be ignored, including Analytics.
MFPLogger.setFilters( { "myPackage": MFPLogger.WARN} );

// Send the logs to the server
MFPLogger.send(
    function() { 
        console.log("Send() succeeded"); 
    }, 
    function() { 
        console.log("Send() failed"); 
});
```

<h3 id="using-analytics">Using MFPAnalytics</h3>

Below are some examples of how to use the MFPAnalytics class.

```
// Enable analytics logging
MFPAnalytics.enable();

MFPAnalytics.logEvent("Logging a message to Analytics");

// Send the analytics log to the server 
MFPAnalytics.send(
    function() { 
        console.log("Send() succeeded"); 
    }, 
    function() { 
        console.log("Send() failed"); 
});
```

---

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
