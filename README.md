# Cordova Plugin for IBM Bluemix Mobile Services Core SDK

[![Build Status](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core.svg?branch=v2)](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core)

## Contents

* [Installation](#installing-the-cordova-plugin-for-bluemix-mobile-services-core-sdk)
	* [Configuring iOS](#configuring-your-ios-environment)
	* [Congiuring Android](#configuring-your-android-environment)
* [API Reference](#api-reference)
	* [BMSClient](#bmsclient)
	* [BMSRequest](#bmsrequest)
	* [BMSLogger](#bmslogger)
	* [BMSAnalytics](#bmsanalytics)
	* [MCAAuthorizationManager](#mcaauthorizationmanager)
	* [AuthenticationListener](#authenticationlistener-interface)
	* [AuthenticationContext](#authenticationcontext)
* [Examples](#examples)
	* [Using BMSClient](#using-bmsclient)
	* [Using BMSRequest](#using-bmsrequest)
	* [Using BMSLogger](#using-bmslogger)
	* [Using BMSAnalytics](#using-bmsanalytics)
	* [Custom Authentication](#custom-authentication)

## Before you begin

Make sure you install the following tools and libraries.

* You should already have Node.js/NPM installed. If you don't, you can download and install Node from [https://nodejs.org/en/download/](https://nodejs.org/en/download/).

* The Cordova CLI tool is required to use this plugin. You can find instructions to install Cordova and set up your Cordova app at [https://cordova.apache.org/#getstarted](https://cordova.apache.org/#getstarted).

* Carthage is required to install the necessary frameworks for iOS. You can learn more about Carthage at [https://github.com/Carthage/Carthage](https://github.com/Carthage/Carthage)

Install Carthage using Homebrew:

```
brew install carthage
```

## Installing the Cordova Plugin for Bluemix Mobile Services Core SDK

### 1. Creating a Cordova application

1. Run the following commands to create a new Cordova application. Alternatively you can use an existing application as well. 

```Bash
$ cordova create {appName}
$ cd {appName}
```
	
### 2. Adding Cordova platforms

Run the following commands for the platforms that you want to add to your Cordova application:

```Bash
cordova platform add ios

cordova platform add android
```

### 3. Adding Cordova plugin

Run the following command from your Cordova application's root directory to add the ibm-mfp-core plugin:

```Bash
cordova plugin add ibm-bms-core
```

You can check if the plugin installed successfully by running the following command, which lists your installed Cordova plugins:

```Bash
cordova plugin list
```

### 4. Configuring your platform

#### Configuring Your iOS Environment

**Note**: Before you begin, make sure that you are using the latest version of Xcode.

1. Open your `[your-app-name].xcodeproj` file in the `[your-app-name]/platforms/ios` directory with Xcode

	> If confronted with an alert asking to “Convert to Latest Swift Syntax”, click **Cancel**.

1. On your application targets’ "General" settings tab, in the "Linked Frameworks and Libraries" section, drag and drop each of the following frameworks from the platforms/ios/Carthage/Build/iOS folder on disk:

	* `BMSCore.framework`
	* `BMSAnalytics.framework`
	* `BMSAnalyticsAPI.framework`
	* `BMSSecurity.framework`
	* `RNCryptor.framework`
	
1. Click on your application target click the “Build Phases” settings tab

1. Click the top left “+” icon and choose “New Run Script Phase”

1. Create a Run Script in which you specify your shell (/bin/sh) and add the following to the script area below the shell:

	* `/usr/local/bin/carthage copy-frameworks`

1. Add the paths to the frameworks under “Input Files”:

	* `$(SRCROOT)/Carthage/Build/iOS/BMSCore.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/BMSAnalytics.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/BMSAnalyticsAPI.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/BMSSecurity.framework`
	* `$(SRCROOT)/Carthage/Build/iOS/RNCryptor.framework`

1. Build and run your application with Xcode or by running the following command:

```Bash
cordova build ios
``` 

#### Configuring Your Android Environment

Build your Android project by running the following command:

```Bash
cordova build android
```

**Important**: Before opening your project in Android Studio, you **must** first build your Cordova application through the Cordova commmand-line interface (CLI). Otherwise, you will encounter build errors.

## API Reference

### BMSClient

The `BMSClient` class is a singleton that serves as an entry point to Bluemix client-server communication.

| Javascript Function | Description |
| :---|:---|
initialize(bluemixAppRoute:string, bluemixAppGUID:string, bluemixRegion:string) | Sets the base URL for the authorization server. For the region use one of the BMSClient.REGION constants.
getBluemixAppRoute(callback:function) | Returns the base URL for the authorization server. The first parameter of the callback is the returned Bluemix app route.
getBluemixAppGUID(callback:function) |  Returns the backend application id. The first parameter of the callback is the returned Bluemix app GUID.
getDefaultTimeoutRequest(callback:function) | Returns the default timeout (in seconds) for all BMS network requests. The first parameter of the callback is the returned default timeout.
setDefaultTimeoutRequest(timeout:int) | Sets the default timeout (in seconds) for all BMS network requests.
registerAuthenticationListener(realm:string, userAuthenticationListener:Object) | Registers a delegate that will handle authentication for the specified realm. See below for how to create the authentication listener.
unregisterAuthenticationListener(realm:string) | Unregisters the authentication callback for the specified realm. 

The following constants are available:

| Regions |
| :---|
BMSClient.REGION_US_SOUTH |
BMSClient.REGION_UK |
BMSClient.REGION_SYDNEY |

### BMSRequest

The `BMSRequest` class is used to build and send HTTP network requests.

| Javascript Function | Description |
| :---|:---|
getHeaders | Returns the headers for the request.
setHeaders(headers:Object) | Sets the headers for the request.
getQueryParameters() | Returns the query parameters for the request.
setQueryParameters(queryParameters:Object) | Sets the query parameters for the request.
getURL() | Returns the URL of the request.
getMethod() | Returns the HTTP method of the request.
getTimeout() | Returns the timeout of the request in ms.
setTimeout(timeout:int) | Sets the timeout of the request in ms.
send(body:Object, success:function, failure:function) | Sends the request asynchronously. The body parameter is optional.

### BMSLogger

The `BMSLogger` class is a singleton that provides a wrapper to the native platform Logger.

| Javascript Function | Description |
| :---|:---|
getLogger(name:string) | Creates a Logger instance.
getLogLevelFilter(callback:function) | Returns the current log level filter. The first parameter of the callback is current log level.
setLogLevelFilter(level:string) | Only logs that are at or above this level will be output to the console. Use one of the the appropriate BMSLogger.Level constants.
sdkDebugLoggingEnabled(callback:function) | Returns whether the native SDK debug logging is enabled. The first parameter of the callback is the returned boolean value.
setSDKDebugLogging(value:boolean) | Enable or disable the native SDK debug logging.
getStoreLogs(callback:function) | Returns whether logs get written to file on the client device. The first parameter of the callback is the returned boolean value.
setStoreLogs(value:boolean) | Enable or disable storing logs.
getMaxLogStoreSize(callback:function) | Returns the maximum file size (in bytes) for log storage. The first parameter of the callback is the returned store size value.
setMaxLogStoreSize(size:int) | Sets the maximum file size (in bytes) for log storage. Both the Analytics and Logger log files are limited by maxLogStoreSize.
isUncaughtExceptionDetected(callback:function) | Returns if the app crashed recently due to an uncaught exception. This property will be set back to false if the logs are sent to the server. The first parameter of the callback is the returned boolean value.
send(callback:function) | Send the logs to the Analytics server.

The following log level constants are available:

| Level |
| :---|
BMSLogger.FATAL |
BMSLogger.ERROR |
BMSLogger.WARN |
BMSLogger.INFO |
BMSLogger.DEBUG |

The following methods are available for an instance of BMSLogger:

| Function | Description |
| :---|:---|
debug(message:string) | Log at the Debug log level.
info(message:string) | Log at the Info log level.
error(message:string) | Log at the Error log level.
warn(message:string) | Log at the Warn log level.
fatal(message:string) | Log at the Fatal log level.
getName() | Return the name that identifies the logger instance.

### BMSAnalytics

The `BMSAnalytics` class is a singleton that serves as an entry point to Bluemix client-server communication.

| Function | Description |
| :---|:---|
initialize(appName:string, apiKey:string, deviceEvents:array[string]) | The required initializer for the BMSAnalytics class when communicating with a Bluemix analytics service. This method must be called after the BMSClient.initialize() method and before calling BMSAnalytics.send() or BMSLogger.send(). Use one of the DeviceEvents constants in an array for the parameter.
enable() | Enable analytics logging.
disable() | Disable analytics logging.
isEnabled(callback:function) | Returns whether or not analytics logging is enabled. The first parameter of the callback function is the returned boolean value.
setUserIdentity(identity:string) | Identifies the current application user. To reset the userId, set the value to null.
log(eventMetadata:Object) | Write analytics data to file.
send(callback:function) | Send the accumulated analytics logs to the Bluemix server. Analytics logs can only be sent after calling the BMSClient.initialize() method.

The following DeviceEvent constants are available:

| DeviceEvent |
| :---|
DeviceEvents.LIFECYCLE |
DeviceEvents.ALL |
DeviceEvents.NONE |

### MCAAuthorizationManager

The `MCAAuthorizationManager` class is used for obtaining authorization tokens from Mobile Client Access service and providing user, device and application identities.

| Function | Description |
| :---|:---|
obtainAuthorizationHeader(success:function, failure:function) | Invokes the process for obtaining authorization header. The first parameter of both callback functions is the returned JSON.
isAuthorizationRequired(statusCode:int, header:string, success:function, failure:function) | Check if the params came from response that requires authorization. The first parameter of the success callback is the returned boolean. The first parameter of the failure callback is the returned error string.
clearAuthorizationData() | Clear the local stored authorization data.
getCachedAuthorizationHeader(success:function, failure:function) | Returns the locally stored authorization header or null if the value does not exist. The first parameter of the success callback is the returned string.
getUserIdentity(callback:function) | Returns the user identity. The first parameter of the callback is the returned user identity.
getAppIdentity(callback:function) | Returns the app identity. The first parameter of the callback is the returned app identity.
getDeviceIdentity(callback:function) | Returns the user identity. The first parameter of the callback is the returned device identity.
getAuthorizationPersistencePolicy(callback:function) | Returns the current persistence policy. The first parameter of the callback is the returned policy.
setAuthorizationPersistencePolicy(policy:string, success:function, failure:function) | Sets the persistence policy.
logout(success:function, failure:function) | Logs out user from MCA. The first paramter of both callback functions is a returned JSON response.

### AuthenticationListener interface

Mobile Client Access Client SDK provides an Authentication Listener interface to implement custom authentication flows. A developer implementing Authentication Listener is expected to add the three below methods that will be called in different phases of an authentication process.

| Function | Description |
| :---|:---|
onAuthenticationChallengeReceived(authContext, challenge) | Triggered when authentication challenge was received.
onAuthenticationSuccess(info) | Triggered when authentication succeeded.
onAuthenticationFailure(info) | Triggered when authentication failed.

### AuthenticationContext

authenticationContext is supplied as an argument to the onAuthenticationChallengeReceived method of a custom Authentication Listener. It is developer's responsibility to collect credentials and use authenticationContext methods to either return credentials to Mobile Client Access Client SDK or report a failure. Use one of the below methods.

| Function | Description |
| :---|:---|
submitAuthenticationChallengeAnswer(answer) | Submits authentication challenge response.
submitAuthenticationSuccess(info) | Informs client about a successful authentication.
submitAuthenticationFailure(info) | Informs client about a failed authentication.

## Examples

### Using BMSClient

The `BMSClient class` allows you to initialize the SDK. By initializing the SDK, you can connect to the server app that you created in the Bluemix dashboard. Initializing the BMSClient instance is required before sending requests.

#### Initializing BMSClient

Initialize the BMSClient by copying and pasting the following code snippet into your main JavaScript file.

```Javascript
BMSClient.initialize("http://example.mybluemix.net", "appGUID", BMSClient.REGION_US_SOUTH);
```

**Note**: If you have created a Cordova app using the cordova CLI, for example, using the `cordova create app-name` command with the Cordova command-line, put this Javascript code in the index.js file, within the onDeviceReady function to initialize the BMS client.

```Javascript
onDeviceReady: function() {
    BMSClient.initialize("http://example.mybluemix.net", "appGUID", BMSClient.REGION_US_SOUTH);
}
```

#### Get functions

```Javascript
BMSClient.getDefaultRequestTimeout(function(timeout) {
	console.log(timeout);
});
```

### Using BMSRequest

#### Creating a request

After initializing the BMSClient you may create a new BMSRequest instance by specifiying a URL endpoint, request method, and an optional timeout value in milliseconds.

```Javascript
// Specific URL
var request = new BMSRequest("http://example.mybluemix.net", BMSRequest.GET, 200);

// Relative endpoint
var request = new BMSRequest("myapp/API/action", BMSRequest.POST, 200);
```

#### Setting the headers

```Javascript
var headers = {
    header1: "val1",
    header2: "val2"
};
request.setHeaders(headers);
```

#### Setting the query parameters

```Javascript
var queryParams = {
    param1: "val1",
    param2: "val2"
};
request.setQueryParameters(queryParams);
```

The query parameters are parameters that are added to the request URL.

#### Sending the request

```Javascript
request.send("some body",
    function(successResponse){
        console.log("text :: " + successResponse.text);
        console.log("status :: " + successResponse.status);
        console.log("headers :: " + successResponse.headers);
    }, 
    function (failureResponse){
        console.log("text :: " + failureResponse.text);
        console.log("errorCode:: " + failureResponse.errorCode);
        console.log("errorDescription :: " + failureResponse.errorDescription);
    }
);
```

The response parameters are JSON objects that will be passed to your callbacks with the following fields:

```
response.status  =>  Integer
response.responseText  =>  Undefined or String
response.headers  =>  JSON object with key:value pairs of headers
response.errorCode  =>  Undefined or Integer 
response.errorDescription  =>  Undefined or String
```

### Using BMSLogger

Below are some examples of how to use the BMSLogger class.

```Javascript
var myLogger = BMSLogger.getLogger("myLogger");

// Enable native SDK debug logging
BMSLogger.setSDKDebugLogging(true);

// Globally set the logging level
BMSLogger.setLogLevelFilter(BMSLogger.WARN);

// Get the maximum file size for log storage
BMSLogger.getMaxLogStoreSize(function(size) {
	console.log(size);
});

// Log a message at FATAL level
myLogger.fatal("Fatal level message");

// Send the logs to the server
BMSLogger.send();

// Send the logs with a callback
BMSLogger.send(function(message) {
	console.log(message);
})
```

### Using BMSAnalytics

Below are some examples of how to use the BMSAnalytics class.

```Javascript
// Initialize analytics logging
BMSAnalytics.initialize("appName", "appGUID", [DeviceEvents.LIFECYCLE]);

// Enable analytics logging
BMSAnalytcs.enable();

// Set user identity
BMSAnalytics.setUserIdentity("myIdentity");

// Log analytics data
var eventMetadata = {
	data1: "val1",
	data2: "val2"
}
BMSAnalytics.log(eventMetadata);

// Send the analytics log to the server 
BMSAnalytics.send();
```

### Custom Authentication

```Javascript
var customAuthenticationListener = {
    onAuthenticationChallengeReceived: function(authenticationContext, challenge) {
        console.log("onAuthenticationChallengeReceived :: ", challenge);

        // In this sample the Authentication Listener immediatelly returns a hardcoded
        // set of credentials. In a real life scenario this is where developer would
        // show a login screen, collect credentials and invoke 
        // authenticationContext.submitAuthenticationChallengeAnswer()

        var challengeResponse = {
            username: "john.lennon",
            password: "12345"
        }

        authenticationContext.submitAuthenticationChallengeAnswer(challengeResponse);

        // In case there was a failure collecting credentials you need to report
        // it back to the authenticationContext. Otherwise Mobile Client 
        // Access Client SDK will remain in a waiting-for-credentials state forever
    },

    onAuthenticationSuccess: function(info){
        console.log("onAuthenticationSuccess :: ", info);
    },

    onAuthenticationFailure: function(info){
        console.log("onAuthenticationFailure :: ", info);
    }
};

// Once you create a custom Authentication Listener you need to register it 
// with BMSClient before you can start using it. 
// Use realmName you've specified when configuring custom authentication
// in Mobile Client Access Dashboard

BMSClient.registerAuthenticationListener(realmName, customAuthenticationListener);
```

## Release Notes

## Copyrights

Copyright 2016 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
