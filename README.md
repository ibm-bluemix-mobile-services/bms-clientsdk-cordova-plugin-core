[![npm package](https://nodei.co/npm/ibm-mfp-core.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/ibm-mfp-core/)

# Cordova Plugin for IBM Bluemix Mobile Services Core SDK


## Before you begin

Make sure you install the following tools and libraries.

* You should already have Node.js/npm and the Cordova package installed. If you don't, you can download and install Node from [https://nodejs.org/en/download/](https://nodejs.org/en/download/).

* The Cordova CLI tool is also required to use this plugin. You can find instructions to install Cordova and set up your Cordova app at [https://cordova.apache.org/#getstarted](https://cordova.apache.org/#getstarted).

To create a Cordova application, use the Cordova Plugin for the IBM Bluemix Mobile Services Core SDK:

1. Create a Cordova application
1. Add Cordova platforms
1. Add Cordova plugin
1. Configure your platform 

## Video tutorials 

The following videos demonstrate how to install and use the Cordova Plugin for the IBM Bluemix Mobile Services Core SDK in iOS and Android applications. 

<a href="https://www.youtube.com/watch?v=AbUpUjP9wmQ" target="_blank">
<img src="ios-video.png"/>
</a>
<a href="https://www.youtube.com/watch?v=kQLA8AYYSoA" target="_blank">
<img src="android-video.png"/>
</a>


## Installing the Cordova Plugin for Bluemix Mobile Services Core SDK

### 1. Creating a Cordova application

1. Run the following commands to create a new Cordova application. Alternatively you can use an existing application as well. 

	```
	$ cordova create {appName}
	$ cd {appName}
	```
	
2. Edit `config.xml` file and set the desired application name in the `<name>` element instead of a default HelloCordova.

3. Continue editing `config.xml`

##### iOS
  For iOS, update the `<platform name="ios">` element with a deployment target declaration as shown in the code snippet below.

	```XML
	<platform name="ios">
		<preference name="deployment-target" value="8.0" />
		<!-- add deployment target declaration -->
	</platform>
	```
##### Android
  For Android, update the `<platform name="android">` element with a minimum and target SDK versions as shown in the code snippet below.

	```XML
	<platform name="android">
		<preference name="android-minSdkVersion" value="15" />
		<preference name="android-targetSdkVersion" value="23" />
		<!-- add minimum and target Android API level declaration -->
	</platform>
	```

	> The minSdkVersion should be above 15.
	
	> The targetSdkVersion should always reflect the latest Android SDK available from Google.


### 2. Adding Cordova platforms

Run the following commands for the platforms that you want to add to your Cordova application

```Bash
cordova platform add ios@4.1.0

cordova platform add android
```

### 3. Adding Cordova plugin

Run the following command from your Cordova application's root directory to add the ibm-mfp-core plugin:

```Bash
cordova plugin add bms-core
```

You can check if the plugin installed successfully by running the following command, which lists your installed Cordova plugins:

```Bash
cordova plugin list
```

### 4. Configuring your platform

#### Configuring Your iOS Environment

**Note**: Before you begin, make sure that you are using the latest version of Xcode.

1. Build and run your application with Xcode or by running the following command:

```Bash
cordova build ios
``` 


<!---
Verify that your Cordova application was correctly linked with the iOS Bluemix Core SDK bundled with the  Plugin.

	Verification Steps:
	
	> If you get a prompt asking whether you want to convert Swift code to the latest version click Cancel

1. Click your project name in the project directory and go to `Build Phases` > `Link Library with Libraries`

1. Verify that the `IMFCore.framework` is present in the linked libraries list

1. Go to `Build Settings` > `Search Paths` > `Framework Search Paths` and verify that the following parameters are included in the Target field for your project.
	
	```
	$(inherited)	
	"[your-project-name]/Plugins/ibm-mfp-core"
	```
!-->

**Note**: If you get the message that your application requires `Use Legacy Swift Language Version` enable the flag to NO by going
 into your Build Settings and search for `Use Legacy Swift Language Version`. You may need to do this for the Pods as well by going to the Pod's Build Setting and updating the flag.
 
 **Note**: If the Pod files were not install when you run added the plugins. Run `cordova prepare ios`.


#### Configuring Your Android Environment

1. Build your Android project by running the following command:

```Bash
cordova build android
```

**Important**: Before opening your project in Android Studio, you **must** first build your Cordova application through the Cordova commmand-line interface (CLI). Otherwise, you will encounter build errors.

## Using the Cordova Plugin

### BMSClient

The `BMSClient` class allows you to initialize the SDK. By initializing the SDK, you can connect to the server app that you created in the Bluemix dashboard. Initializing the `BMSClient` instance is required before sending requests.

* Initialize the BMSClient by copying and pasting the following code snippet into your main JavaScript file. If your app in a different region the following constants are available: `BMSClient.REGION_UK`, `BMSClient.REGION_UK`, and `BMSClient.REGION_SYDNEY`

```JavaScript
BMSClient.initialize(BMSClient.REGION_US_SOUTH);
```

**Note**: If you have created a Cordova app using the cordova CLI, for example, `cordova create app-name` command with the Cordova command-line, put this Javascript code in the **index.js** file, within the `onDeviceReady` function to initialize the BMS client.

```JavaScript
onDeviceReady: function() {
    BMSClient.initialize(BMSClient.REGION_US_SOUTH);
},
```

* Modify the code snippet to use your Bluemix Route and appGUID parameters. To get these parameters, click the **Mobile Options** link in your Bluemix Application Dashboard to get the application route and application GUID. Use the Route and App GUID values as your parameters in your BMSClient.initialize code snippet.


## Examples

### Using BMSClient, BMSAuthorizationManager and BMSRequest

#### Initializing BMSClient

The following JavaScript code is your entry point to the Bluemix Mobile Services. This method should be called before making a request. You will need to pass in the region for your application. The following constants are provided: 

```JavaScript
 REGION_US_SOUTH // ".ng.bluemix.net";
 REGION_UK //".eu-gb.bluemix.net";
 REGION_SYDNEY // ".au-syd.bluemix.net";
```

```JavaScript
BMSClient.initialize(BMSClient.REGION_US_SOUTH);
```

#### Initializing BMSAuthorizationManager

The following JavaScript code initialize the BMSAuthorizationManager with the MCA service tenantId, the tenantId can be found under the service credentials by clicking on the show credentials button on the MCA service tile. This method should be called before making a request.

```JavaScript
BMSAuthorizationManager.initialize("tenantId");
```

#### Creating a request 
After initializing the client you may create a new BMSRequest instance by specifiying a URL endpoint, request method, and an optional timeout value in milliseconds.

```JavaScript
var request = new BMSRequest("/myapp/API/action", BMSRequest.GET, 20000);
```

#### Setting headers for your request 

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
	param2: "val2"
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

### Using BMSLogger

Below are some examples of how to use the Logger class.

```JavaScript
var myPackageLogger = BMSLogger.getInstance("myPackage");


// Globally set the logging level
BMSLogger.setLogLevel(BMSLogger.WARN);

// Log a message at FATAL level
myPackageLogger.fatal("Fatal level message");


// Send the logs to the server
BMSLogger.send();
```

### Using BMSAnalytics

Below are some examples of how to use the BMSAnalytics class.

```JavaScript

//Initialize BMSClient
BMSClient.initialize(BMClient.REGION_US_SOUTH);

// Enable analytics logging
BMSAnalytics.enable();

// Send the analytics log to the server 
BMSAnalytics.send();
```


**Note**: For more information about Analytics see [README](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-android-analytics).

### Custom Authentication

```JavaScript
var customAuthenticationListener = {
    onAuthenticationChallengeReceived: function(authenticationContext, challenge) {
        console.log("onAuthenticationChallengeReceived :: ", challenge);

        // In this sample the Authentication Listener immediatelly returns a hardcoded
        // set of credentials. In a real life scenario this is where developer would
        // show a login screen, collect credentials and invoke 
        // authenticationContext.submitAuthenticationChallengeAnswer() API

        var challengeResponse = {
            username: "john.lennon",
            password: "12345"
        }

        authenticationContext.submitAuthenticationChallengeAnswer(challengeResponse);

        // In case there was a failure collecting credentials you need to report
        // it back to the authenticationContext. Otherwise Mobile Client 
        // Access Client SDK will remain in a waiting-for-credentials state
        // forever

    },

    onAuthenticationSuccess: function(info){
        console.log("onAuthenticationSuccess :: ", info);
    },

    onAuthenticationFailure: function(info){
        console.log("onAuthenticationFailure :: ", info);
    }
}

// Once you create a custom Authentication Listener you need to register it 
// with BMSClient before you can start using it. 
// Use realmName you've specified when configuring custom authentication
// in Mobile Client Access Dashboard

BMSClient.registerAuthenticationListener(realmName, customAuthenticationListener);
```

## Change log
 
##### 2.0.0
 * Changed JS API signatures 
 * Removed the use of using a copy of Briding-Header.h
 * Changed the BMSClient.intialize method
 * Removed filters and capture methods for BMSLogger
 * Added iniit method for BMSAnalytics
  

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
