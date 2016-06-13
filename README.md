# Cordova Plugin for IBM Bluemix Mobile Services Core SDK

[![Build Status](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core.svg?branch=v2)](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core)

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
registerAuthenticationListener(realm:string, userAuthenticationListener:Object) | Registers a delegate that will handle authentication for the specified realm.
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
isUncaughtExceptionDetected(callback:function) | Returns if the app crashed recently due to an uncaught exception. This property will be set back to false if the logs are sent to the server.
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
initialize(appName:string, apiKey:string, deviceEvents:string) | The required initializer for the BMSAnalytics class when communicating with a Bluemix analytics service. This method must be called after the BMSClient.initializeWithBluemixAppRoute() method and before calling BMSAnalytics.send() or BMSLogger.send()
enable() | Enable analytics logging.
disable() | Disable analytics logging.
isEnabled(callback:function) | Returns whether or not analytics logging is enabled. The first parameter of the callback function is the returned boolean value.
setUserIdentity(identity:string) | Identifies the current application user. To reset the userId, set the value to null.
log(eventMetadata:Object) | Write analytics data to file.
send(callback:function) | Send the accumulated analytics logs to the Bluemix server. Analytics logs can only be sent if the BMSClient was initialized via the initializeWithBluemixAppRoute() method.

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
