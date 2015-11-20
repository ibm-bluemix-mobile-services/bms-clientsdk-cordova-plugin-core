# IBM Bluemix Mobile Services - Client SDK Cordova

Cordova Plugin for IBM Bluemix Mobile Services Core SDK

## Contents
- <a href="#installation">Installation</a>
- <a href="#configuration">Configuration</a>
    - <a href="#configure-ios">Configure Your iOS Development Environment</a>
    - <a href="#configure-android">Configure Your Android Development Environment</a>
- <a href="#usage">Usage</a>
    - <a href="#bmsclient">BMSClient</a>
    - <a href="#mfprequest">MFPRequest</a>
    - <a href="#mfplogger">MFPLogger</a>
    - <a href="#mfpanalytics">MFPAnalytics</a>
- <a href="#examples">Examples</a> 
    - <a href="#using-bmsclient">Using BMSClient and MFPRequest</a> 
    - <a href="#using-mfplogger">Using MFPLogger</a>
    - <a href="#using-mfpanalytics">Using MFPAnalytics</a> 
- <a href="#release-notes">Release Notes</a> 

<h2 id="installation">Installation</h2>

### Install necessary libraries

You should already have Node.js/npm and the Cordova package installed. If you don't, you can download and install Node from [https://nodejs.org/en/download/](https://nodejs.org/en/download/).

The Cordova library is also required to use this plugin. You can find instructions to install Cordova and set up your Cordova app at [https://cordova.apache.org/#getstarted](https://cordova.apache.org/#getstarted).

### Add the Cordova plugin

Run the following command from your Cordova application's root directory to add the ibm-mfp-core plugin:

    $ cordova plugin install ibm-mfp-core

You can check if the plugin installed successfully by running the following command, which lists your installed Cordova plugins:

    $ cordova plugin list


<h2 id="configuration">Configuration</h2>

<h3 id="configure-ios">Configure Your iOS Development Environment</h3>
- Make sure to use the latest Xcode version.

- Open your Xcode .xcodeproj file in [your-app-name]/platforms/ios

- Change the minimum iOS deployment target to at least 8.0.
  - Optionally, in your Cordova app you can modify your config.xml:
    - Open your config.xml file and look for the section:
      - `<platform name="ios">`
    - Add the following:
      - `<preference name="deployment-target" value="8.0" />`

- Configuring your project in Xcode:
<ol>
    <li>Click your app name in the project directory and go to Build Phases > Link Library with Libraries</li>

    <li>Verify that the IMFCore.framework has been added</li>

    <li>Go to Build Settings > Search Paths > Framework Search Paths and verify that the following parameters were added in your app's Target:</li>
    <ul>
        <li type=circle><code>$(inherited)</code></li>
        <li type=circle><code>"[your-app-name]/Plugins/ibm-mfp-core"</code></li>
    </ul>

    <li>Go to Build settings and search for “bridging” > Objective-C Bridging Header and add the following path:</li>
    <ul>
        <li type=circle><code>[your-app-name]/Plugins/ibm-mfp-core/Bridging-Header.h</code></li>
    </ul>
    
    <li>Go to Build Settings > Linking > Runpath Search Paths and add the following parameter:</li>
    <ul>
        <li type=circle><code>@executable_path/Frameworks</code></li>
    </ul>
</ol>

<h3 id="configure-android">Configure Your Android Development Environment</h3>

In your Cordova app, make sure your config.xml file is configured for the right API:

The minimum API that the BMS Android SDK supports is level 15 (Ice Cream Sandwich):

- Open your config.xml file and look for the section:
    - `<platform name="android">`
- Add the following
    - `<preference name="android-minSdkVersion" value="15" />`
- (Optional) If you want to target a specific Android API Level, you can specify the following preference name:
    - `<preference name="android-targetSdkVersion" value="23" />`  

<h2 id="usage">Usage</h2>

<h3 id="bmsclient">BMSClient</h3>

BMSClient is your entry point to the MobileFirst services. Initializing the BMSClient is required before sending a request that requires authorization.

Example:

    BMSClient.initialize("https://myapp.mybluemix.net", "abcd1234-abcd-1234-abcd-abcd1234abcd");


BMSClient functions available:

Function | Use
--- | ---
`initialize(bluemixAppRoute, bluemixAppGUID)` | Sets the base URL for the authorization server. This method should be called before you send the first request that requires authorization.
`getBluemixAppRoute(callback)` | Return the Bluemix app route.
`getBluemixAppGUID(callback)` | Return the Bluemix app GUID.
`registerAuthenticationListener(realm, authenticationListener)` | Registers authentication callback for the specified realm.
`unregisterAuthenticationListener(realm)` | Unregisters the authentication callback for the specified realm.

<h3 id="mfprequest">MFPRequest</h3>

After initializing the client you may create a new MFPRequest instance, used to send a request to a specified URL.

You can specify a path relative to your Bluemix app route

    var request = new MFPRequest("/myapp/API/action", MFPRequest.GET);

or you can specify a full URL path:

    var request = new MFPRequest("http://www.example.com", MFPRequest.GET);


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
`send(body, success, failure)` | With optional body text parameter.
`send(json, success, failure)` | With optional JSON object parameter.

Success and failure callbacks of the MFPRequest.send() receive a response object as an argument (see <a href="#examples">Examples</a>). The following properties are available for the response:

Property | Info
--- | ---
status | The response status as an integer.
responseText | Return response text as null or string.
headers | Return response headers in JSON format.
errorCode | Return response error code as integer. 
errorDescription | Return response error description as null or string.

The following HTTP methods are available:

Method |
--- |
MFPRequest.GET |
MFPRequest.PUT |
MFPRequest.POST |
MFPRequest.DELETE |
MFPRequest.TRACE |
MFPRequest.HEAD |
MFPRequest.OPTIONS |

See below for more <a href="#using-bmsclient">Examples</a> of how to use BMSClient and MFPRequest.

<h3 id="mfplogger">MFPLogger</h3>

MFPLogger is a Singleton class used for logging messages. It persists logs to the local disk. When you call the send() function it will send the logs to the server.

You can create an instance of MFPLogger using:

    MFPLogger.getInstance("myLogger")


Example of sending a specific log message using your logger instance:

    myLogger.debug(message)


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
`send(success, failure)` | Send the log file when the log store exists and is not empty. If the send fails, the local store is preserved. If the send succeeds, the local store is deleted.

Log levels available:

Level |
--- |
FATAL |
ERROR |
WARN |
INFO |
DEBUG |

The following functions are available for the logger instance to send a specific log message:

Function |
--- |
`debug(message)` |
`info(message)` |
`warn(message)` | 
`error(message)` |
`fatal(message)` |

See below for more <a href="#using-mfplogger">Examples</a> of how to use MFPLogger.

<h3 id="mfpanalytics">MFPAnalytics</h3>

MFPAnalytics is used for sending operational analytics information to the server.

MFPAnalytics functions available:

Function | Use
--- | ---
`enable()` | Turn on the global setting for persisting of the analytics data.
`disable()` | Turn off the global setting for persisting of the analytics data.
`isEnabled(success, failure)` | Get the current setting for determining if log data should be saved persistently.
`send(success, failure)` | Send the analytics log file when the log store exists and is not empty. If the send fails, the local store is preserved. If the send succeeds, the local store is deleted.

See below for <a href="#using-mfpanalytics">Examples</a> of how to use MFPAnalytics.

<h2 id="examples">Examples</h2>

<h3 id="using-bmsclient">Using BMSClient and MFPRequest</h3>

The following Javascript code is your entry point to the MobileFirst services. This method should be called before making a request. Your app URL and GUID can be found by going to your app's dashboard on Bluemix and clicking on "Mobile Options".


    BMSClient.initialize("https://myapp.mybluemix.net", "abcd1234-abcd-1234-abcd-abcd1234abcd");


#### Creating a request 
After initializing the client you may create a new MFPRequest instance by specifiying a URL endpoint, request method, and an optional timeout value.

    var request = new MFPRequest("/myapp/API/action", MFPRequest.GET, 20000);


#### Setting the headers for your request 

    var headers = {
        header1: "val1",
        header2: "val2"
    }
    request.setHeaders(headers)


#### Setting your MFPRequest's query parameters

    var queryParams = {
        param1: "val1",
        param2: "val2
    }
    request.setQueryParameters(queryParams)


The query parameters are parameters that you wish to use for your specific request.

#### Sending the request


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
    )


The successResponse and failureResponse parameters are JSON objects that will be passed to your callbacks with the following fields:


    response.status  =>  Integer
    response.responseText  =>  Undefined or String
    response.headers  =>  Object
    response.errorCode  =>  Integer 
    response.errorDescription  =>  Undefined or String


<h3 id="using-mfplogger">Using MFPLogger</h3>

Below are some examples of how to use the MFPLogger class.


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


<h3 id="using-analytics">Using MFPAnalytics</h3>

Below are some examples of how to use the MFPAnalytics class.


    // Enable analytics logging
    MFPAnalytics.enable();

    // Send the analytics log to the server 
    MFPAnalytics.send(
        function() { 
            console.log("Send() succeeded"); 
        }, 
        function() { 
            console.log("Send() failed"); 
    });


<h2 id="release-notes">Release Notes</h3>

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
