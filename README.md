# IBM Bluemix Mobile Services - Client SDK Cordova

Cordova Plugin for IBM Bluemix Mobile Services Core SDK

## Installation

### Installing necessary libraries

You should already have Node.js/npm and the Cordova package installed. If you don't, you can download and install Node from [https://nodejs.org/en/download/](https://nodejs.org/en/download/).

The Cordova library is also required to use this plugin. You can find instructions to install Cordova and set up your Cordova app at [https://cordova.apache.org/#getstarted](https://cordova.apache.org/#getstarted).

### Creating a Cordova application

1. Run the following commands to create a new Cordova application. Alternatively you can use an existing application as well. 

	$ cordova create {appName}
	$ cd {appName}
	
1. Edit `config.xml` file and set the desired application name in the `<name>` element instead of a default HelloCordova.

1. Continue editing `config.xml`. Update the `<platform name="ios">` element with a deployment target declaration as shown in the code snippet below.

	```XML
	<platform name="ios">
		<preference name="deployment-target" value="8.0" />
		// other properties
	</platform>
	```
	
1. Continue editing `config.xml`. Update the `<platform name="android">` element with a minimum and target SDK versions as shown in the code snippet below.

	```XML
	<platform name="android">
		<preference name="android-minSdkVersion" value="15" />
		<preference name="android-targetSdkVersion" value="23" />
		// other properties
	</platform>
	```

	> The minSdkVersion should be above 15.
	
	> The targetSdkVersion should always reflect the latest Android SDK available from Google.

### Adding Cordova platforms

Run the following commands according to which platform you want to add to your Cordova application

```Bash
cordova platform add ios

cordova platform add android
```

### Adding Cordova plugin

Run the following command from your Cordova application's root directory to add the ibm-mfp-core plugin:

```Bash
cordova plugin add ibm-mfp-core
```

You can check if the plugin installed successfully by running the following command, which lists your installed Cordova plugins:

```Bash
cordova plugin list
```

## Configuration

### Configuring iOS Development Environment

1. Make sure to use the latest Xcode version.

1. Open your `[your-app-name].xcodeproj` file in `[your-app-name]/platforms/ios` directory with Xcode

	> If you get a prompt asking whether you want to convert Swift code to the latest version click Cancel

1. Click your project name in the project directory and go to `Build Phases` > `Link Library with Libraries`

1. Verify that the `IMFCore.framework` is present in the linked libraries list

1. Go to `Build Settings` > `Search Paths` > `Framework Search Paths` and verify that the following parameters were added in your project's Target
	
	```
	$(inherited)	
	"[your-project-name]/Plugins/ibm-mfp-core"
	```

1. Go to `Build settings` and search for “bridging” > `Objective-C Bridging Header` and add the following path:

	```
	[your-project-name]/Plugins/ibm-mfp-core/Bridging-Header.h
	```
	
1. Go to `Build Settings` > `Linking` > `Runpath Search Paths` and add the following parameter
	
	```
	@executable_path/Frameworks
	```

1. Build and run your application with Xcode. 

### Configure Your Android Development Environment

Android development environement does not require any additional configuration.

## Usage

### BMSClient

`BMSClient` class is your entry point to the Bluemix Mobile Services SDK. Initializing the `BMSClient` instance is required before sending requests.

Example:

```JavaScript
BMSClient.initialize("appRoute", "appGUID");
```

> Replace appRoute and appGUID parameters with values obtained from `Mobile Options` in your Bluemix applications dashboard.

### API reference

Function | Use
|----|----|
initialize(bluemixAppRoute, bluemixAppGUID) | Sets the base URL for the authorization server. This method should be called before you send the first request that requires authorization.
getBluemixAppRoute(callback) | Return the Bluemix app route.
getBluemixAppGUID(callback) | Return the Bluemix app GUID.
registerAuthenticationListener(realm, authenticationListener) | Registers authentication callback for the specified realm.
unregisterAuthenticationListener(realm) | Unregisters the authentication callback for the specified realm.

### MFPRequest

After initializing the client you may create a new MFPRequest instance, used to send a request to a specified URL.

You can specify a path relative to your Bluemix app route

```JavaScript
var request = new MFPRequest("/myapp/API/action", MFPRequest.GET);
```

or you can specify a full URL path:

```JavaScript
var request = new MFPRequest("http://www.example.com", MFPRequest.GET);
```

Following HTTP verbs are supported by MFPRequest

Method |
--- |
MFPRequest.GET |
MFPRequest.PUT |
MFPRequest.POST |
MFPRequest.DELETE |
MFPRequest.TRACE |
MFPRequest.HEAD |
MFPRequest.OPTIONS |

Following methods are available for MFPRequest objects

Function | Use
--- | ---
setHeaders(jsonObj) | Set the headers for the request object in JSON format.
getHeaders | Return the headers object for the request object.
getUrl | Return the url for this request.
getMethod | Return the HTTP method for this request.
getTimeout | Return the timeout (in ms) for this request.
setQueryParameters(jsonObj) | Return the queryParameters object for this request.
getQueryParameters | Set the Query Parameters for the request object in JSON format.
send(success, failure) | Send this resource request asynchronously. You must supply success and failure callback functions, and optionally a body parameter.
send(body, success, failure) | With optional body text parameter.
send(json, success, failure) | With optional JSON object parameter.

Success and failure callbacks of the MFPRequest.send() receive a response object as an argument (see Examples section). The following properties are available for the response object:

Property | Info
--- | ---
status | The response status as an integer.
responseText | Return response text as null or string.
headers | Return response headers in JSON format.
errorCode | Return response error code as integer. 
errorDescription | Return response error description as null or string.

See the Examples section for more samples how to use BMSClient and MFPRequest.

### MFPLogger

`MFPLogger` is a used for logging messages. In addition to printing log messages to respective log console it can persist logs to file. When you call the send() function it will send the persisted logs to the Mobile Client Access Service.

You can create an instance of MFPLogger using:

```JavaScript
MFPLogger.getInstance("myLogger");
```

Example of sending a specific log message using your logger instance:

```JavaScript
myLogger.debug(message);
```

Following static methods are exposed by the MFPLogger 

Function | Use
--- | ---
getInstance(name) | Return a named logger instance.
getCapture(success, failure) | Get the current setting for determining if log data should be saved persistently.
setCapture(enabled) | Global setting: turn on or off the persisting of the log data that is passed to the log methods of this class.
getFilters(success, failure) | Retrieve the filters that are used to determine which log messages are persisted.
setFilters(filters) | Set the filters that are used to determine which log messages are persisted. Each key defines a name and each value defines a logging level.
getMaxStoreSize(success, failure) | Gets the current setting for the maximum storage size threshold.
setMaxStoreSize(size) | Set the maximum size of the local persistent storage for queuing log data. When the maximum storage size is reached, no more data is queued. This content of the storage is sent to a server.
getLevel(success, failure) | Get the currently configured Log Level.
setLevel(logLevel) | Set the level from which log messages must be saved and printed. For example, passing MFPLogger.INFO logs INFO, WARN, and ERROR.
isUncaughtExceptionDetected(success, failure) | Indicates that an uncaught exception was detected. The indicator is cleared on successful send.
send(success, failure) | Send the log file when the log store exists and is not empty. If the send fails, the local store is preserved. If the send succeeds, the local store is deleted.

Log levels available:

Level |
--- |
FATAL |
ERROR |
WARN |
INFO |
DEBUG |

The following instance methods are available for the logger instances to send a specific log message:

Function |
--- |
debug(message) |
info(message) |
warn(message) | 
error(message) |
fatal(message) |

See below for more Examples of how to use MFPLogger.

### MFPAnalytics

MFPAnalytics is used for sending operational analytics information to the Mobile Client Access Service.

MFPAnalytics methods:

Function | Use
--- | ---
enable() | Turn on the global setting for persisting of the analytics data.
disable() | Turn off the global setting for persisting of the analytics data.
isEnabled(success, failure) | Get the current setting for determining if log data should be saved persistently.
send(success, failure) | Send the analytics log file when the log store exists and is not empty. If the send fails, the local store is preserved. If the send succeeds, the local store is deleted.

See below for Examples of how to use MFPAnalytics.

## Examples

### Using BMSClient and MFPRequest

#### Initializing BMSClient

The following JavaScript code is your entry point to the Bluemix Mobile Services. This method should be called before making a request. Your appRoute and appGUID can be found by going to your app's dashboard on Bluemix and clicking on "Mobile Options".

```JavaScript
BMSClient.initialize("appRoute", "appGUID");
```

#### Creating a request 
After initializing the client you may create a new MFPRequest instance by specifiying a URL endpoint, request method, and an optional timeout value in milliseconds.

```JavaScript
var request = new MFPRequest("/myapp/API/action", MFPRequest.GET, 20000);
```

#### Setting  headers for your request 

```JavaScript
var headers = {
	header1: "val1",
	header2: "val2"
};
request.setHeaders(headers);
```


#### Setting your MFPRequest's query parameters

```JavaScript
var queryParams = {
	param1: "val1",
	param2: "val2
};
request.setQueryParameters(queryParams);
```

The query parameters are parameters that are added to the request URL.

#### Sending the request

```JavaScript
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

The successResponse and failureResponse parameters are JSON objects that will be passed to your callbacks with the following fields:

```JavaScript
response.status  =>  Integer
response.responseText  =>  Undefined or String
response.headers  =>  JSON object with key:value pairs of headers
response.errorCode  =>  Integer 
response.errorDescription  =>  Undefined or String
```

### Using MFPLogger

Below are some examples of how to use the MFPLogger class.

```JavaScript
var myPackageLogger = MFPLogger.getInstance("myPackage");

// Persist logs to a file
MFPLogger.setCapture(true);

// Globally set the logging level
MFPLogger.setLevel(MFPLogger.WARN);

// Log a message at FATAL level
myPackageLogger.fatal("Fatal level message");

// Only use the logger specified here. 
// All others will be ignored, including Analytics.
MFPLogger.setFilters( { "myPackage": MFPLogger.WARN} );

// Send the logs to the server
MFPLogger.send();
```

### Using MFPAnalytics

Below are some examples of how to use the MFPAnalytics class.

```JavaScript
// Enable analytics logging
MFPAnalytics.enable();

// Send the analytics log to the server 
MFPAnalytics.send();
```

## Release Notes


## Copyrights
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
