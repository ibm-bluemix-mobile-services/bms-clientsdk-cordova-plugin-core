# Cordova Plugin for IBM Bluemix Mobile Services Core SDK
 [![Build Status](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core.svg?branch=master)](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core
)

 [![npm package](https://nodei.co/npm/bms-core.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/bms-core/)


## Table of Contents

* [Before you begin](#before_you_begin) 
* [Installing the Cordova Plugin for Bluemix Mobile Services Core SDK](#init_sdk)
* [Using the Cordova Plugin](#using_cordova)
* [Examples](#examples)
* [ChangeLog](#change_log)
* [Copyrights](#copyrights)



<a name="before_you_begin"></a>
## Before you begin

Make sure you install the following tools and libraries.

* You should already have Node.js/npm and the Cordova package installed. If you don't, you can download and install Node from [https://nodejs.org/en/download/](https://nodejs.org/en/download/).

* The Cordova CLI tool is also required to use this plugin. You can find instructions to install Cordova and set up your Cordova app at [https://cordova.apache.org/#getstarted](https://cordova.apache.org/#getstarted).
    * Make sure you are using Cordova version is 6.3.0 or below.

* You should have Cocoapods installed. If you don't, you can download and install Cocoapods from [http://cocoapods.org/](http://cocoapods.org/) 

To create a Cordova application, use the Cordova Plugin for the IBM Bluemix Mobile Services Core SDK:

1. Create a Cordova application
1. Add Cordova platforms
1. Add Cordova plugin
1. Configure your platform 

<a name="init_sdk"></a>
## Installing the Cordova Plugin for Bluemix Mobile Services Core SDK

### 1. Creating a Cordova application

1. Run the following commands to create a new Cordova application. Alternatively you can use an existing application as well. 

	```
	$ cordova create {appName}
	$ cd {appName}
	```
	
2. Edit the `config.xml` file and set the desired application name in the `<name>` element instead of a default HelloCordova.

3. Continue editing `config.xml`

##### iOS
  For iOS, update the `<platform name="ios">` element with a deployment target declaration as shown in the following code snippet.

```XML
	<platform name="ios">
		<preference name="deployment-target" value="8.0" />
		<!-- add deployment target declaration -->
	</platform>
```
##### Android
  For Android, update the `<platform name="android">` element with a minimum and target SDK versions as shown in the following code snippet.

```XML
	<platform name="android">
		<preference name="android-minSdkVersion" value="15" />
		<preference name="android-targetSdkVersion" value="23" />
		<!-- add minimum and target Android API level declaration -->
	</platform>
```

Note: 

* The minSdkVersion should be above 15.

* The targetSdkVersion should always reflect the latest Android SDK available from Google supported by Cordova. Currently, 
Cordova supports up to Android 24.


### 2. Adding Cordova platforms

Run the following commands for the platforms that you want to add to your Cordova application:

```Bash
cordova platform add ios

cordova platform add android@5.2.2
```

### 3. Adding Cordova plugin

Run the following command from your Cordova application's root directory to add the bms-core plugin:

```Bash
cordova plugin add bms-core
```

You can check if the plugin installed successfully by running the following command, which lists your installed Cordova plugins:

```Bash
cordova plugin list
```

### 4. Configuring your platform

#### Configuring Your iOS Environment

**Note**: Before you begin, make sure that you are using Xcode 7 or above.

1. Run `cordova prepare ios` to prepare the Cordova application with the necessary CocoaPod dependencies.

2. Build and run your application with Xcode or by running the following command:

    ```Bash
    cordova build ios
    ``` 
    
**Note**: You may receive the following error when running `cordova build ios`. This issue is due to a bug in a dependency plugin which is being tracked in [Issue 12](https://github.com/blakgeek/cordova-plugin-cocoapods-support/issues/12). You can still run the iOS project in XCode through a simulator or device. 

```
xcodebuild: error: Unable to find a destination matching the provided destination specifier:
		{ platform:iOS Simulator }

	Missing required device specifier option.
	The device type “iOS Simulator” requires that either “name” or “id” be specified.
	Please supply either “name” or “id”.
```

3. Verify that your Cordova application was correctly linked with the iOS Bluemix Core SDK that is bundled with the Plugin.

* If you get a prompt asking whether you want to convert Swift code to the latest version, click **Cancel**.
    1. Click your project name in the project directory and go to **Build Phases** > **Link Library with Libraries**.
    2. Verify that the `Pods_{YOUR_PROJECT_MODULE_NAME}.framework` is present in the linked libraries list.
 
* **Note**: If you get the message that your application requires `Use Legacy Swift Language Version`, set the flag to `NO`.
    1. Go to **Build Settings** > **Use Legacy Swift Language**.
    2. You may need to do this with other Pod dependencies such as `BMSAnalytics` and `BMSAnalyticsAPI`. 
 
#### Configuring Your Android Environment

1. Build your Android project by running the following command:

    ```Bash
    cordova build android
    ```

**Important**: Before opening your project in Android Studio, you **must** first build your Cordova application through the Cordova commmand-line interface (CLI). Otherwise, you will encounter build errors.

<a name="using_cordova"></a>
## Using the Cordova Plugin

### BMSClient

The `BMSClient` class allows you to initialize the SDK. By initializing the SDK, you can connect to the server app that you created in the Bluemix dashboard. Initializing the `BMSClient` instance is required before sending requests.

* Initialize the `BMSClient` by copying and pasting the following code snippet into your main JavaScript file. If your app is in a different region, the following constants are available: `BMSClient.REGION_US_SOUTH`, `BMSClient.REGION_UK`, and `BMSClient.REGION_SYDNEY`

    ```JavaScript
    BMSClient.initialize(BMSClient.REGION_US_SOUTH);
    ```

**Note**: If you created a Cordova app using the cordova CLI, for example, `cordova create app-name` command with the Cordova command-line, add the following Javascript code in the `index.js` file, within the `onDeviceReady` function to initialize the `BMSClient`.

```JavaScript
onDeviceReady: function() {
    BMSClient.initialize(BMSClient.REGION_US_SOUTH);
},
```
<a name="examples"></a>
## Examples

### Using BMSClient, BMSAuthorizationManager, and BMSRequest

#### Initializing BMSClient

The following JavaScript code is your entry point to the Bluemix Mobile services. Call this method before making any request. You must pass in the region for your application. The following constants are provided: 

```JavaScript
 REGION_US_SOUTH // ".ng.bluemix.net";
 REGION_UK //".eu-gb.bluemix.net";
 REGION_SYDNEY // ".au-syd.bluemix.net";
```

```JavaScript
BMSClient.initialize(BMSClient.REGION_US_SOUTH);
```
#### Initializing BMSAuthorizationManager

In order to use `BMSAuthorizationManager` you will need to add the following code snippet. The following native code initializes the `BMSAuthorizationManager` with the MCA service `tenantId`, the `tenantId` can be found under the service credentials by clicking on the show credentials button on the MCA service tile. This method should be called before making a request.

* Android (*OnCreate in MainActivity.java before `loadUrl`*)
```Java
MCAAuthorizationManager mcaAuthorizationManager = MCAAuthorizationManager.createInstance(this.getApplicationContext(),"<tenantId>");
BMSClient.getInstance().setAuthorizationManager(mcaAuthorizationManager);
```
* iOS (*AppDelegate.m*)
```Objective-C
  [CDVBMSClient initMCAAuthorizationManagerManager:@"<tenantId>"]; //Xcode 7 and Xcode 8 with Swift 2.3
  [CDVBMSClient initMCAAuthorizationManagerManagerWithTenantId:@"<tenantId>"]; // Xcode 8 with Swift 3
```

#### Keychain Sharing

If you plan on using BMSAuthorization in iOS you will need to enable Keychain Sharing. Also, keep in mind that Keychain Sharing requires an Apple ID. Enable `Keychain Sharing` by going to `Capabilities` > `Keychain Sharing` and switch the tab to `On`. 

#### Creating a request 
After you initialize the client, you can create a new `BMSRequest` instance by specifiying a URL endpoint, request method, and an optional timeout value in milliseconds.

```JavaScript
var request = new BMSRequest("http://your_app.mybluemix.net/protected", BMSRequest.GET, 20000);
```

#### Setting headers for your request 

```JavaScript
var headers = {
	header1: "val1",
	header2: "val2"
};
request.setHeaders(headers);
```

#### Setting your BMSRequest's query parameters

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
		console.log("text :: " + successResponse.responseText);
		console.log("status :: " + successResponse.status);
		console.log("headers :: " + successResponse.headers);
	}, 
	function (failureResponse){
		console.log("text :: " + failureResponse.responseText);
		console.log("errorCode:: " + failureResponse.errorCode);
		console.log("errorDescription :: " + failureResponse.errorDescription);
	}
);
```

The `successResponse` and `failureResponse` parameters are JSON objects that will be passed to your callbacks with the following fields:

```JavaScript
response.status  =>  Integer
response.responseText  =>  Undefined or String
response.headers  =>  JSON object with key:value pairs of headers
response.errorCode  =>  Integer 
response.errorDescription  =>  Undefined or String
```

### Using BMSLogger

```JavaScript
var myPackageLogger = BMSLogger.getLogger("myPackage");


// Globally set the logging level
BMSLogger.setLogLevel(BMSLogger.WARN);

// Log a message at FATAL level
myPackageLogger.fatal("Fatal level message");


// Send the logs to the server
BMSLogger.send();
```

### Using BMSAnalytics

```JavaScript

//Initialize BMSClient
BMSClient.initialize(BMClient.REGION_US_SOUTH);

//Initialize BMSAnalytics
BMSAnalytics.initialize(appName, apiKey, hasUserContext, [BMSAnalytics.ALL]

// Enable analytics logging
BMSAnalytics.enable();

// If hasUserContext is set to true set "userIdentity"
BMSAnalytcs.setUserIdentity("user1");

// Send the analytics log to the server 
BMSAnalytics.send();
```

**Note**: In iOS, BMSAnalytics.ALL and BMSAnalytics.NONE is not supported natively and will be treated as BMAnaltyics.LIFECYCLE.

**Note**: For more information about Mobile Analytics, see the [documentation](https://new-console.stage1.ng.bluemix.net/docs/services/mobileanalytics/index.html).



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

**Note**: For more information about Mobile Client Access, see the [documentation](https://new-console.ng.bluemix.net/docs/services/mobileaccess/custom-auth-cordova.html)

<a name="change_log"></a>
## Change log

##### 2.3.7
* Fixed bug with DeviceEvents in iOS
 * See [Issue 29](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core/issues/29)
##### 2.3.6
* Update README to state only Cordova 6 and Android 24 support

##### 2.3.5 
* Update code snippet to show setting `userIdentity`

##### 2.3.4
* Updated Cocoapods requirment and fixed examples in README

##### 2.3.3
* Fixed `logLevelDictionary` EXEC_BAD_ACCESS error

##### 2.3.2
* Added `DeviceEvent.NETWORK` as an available event for `BMSAnalytics`

##### 2.2.2
* Use `<pod id=/podId/ value="~>2.0"/>` to grab the latest pod dependency from version [2.0,3.0)

##### 2.2.1
* Use `<pod id=/podId/ value=">=2.0.0"/>` to grab the latest pod dependency

##### 2.2.0
* Update `BMSAnalytics` pod dependency to 2.1.1
* Update `BMSSecurity` pod dependency to 2.0.2

##### 2.1.0
* Added `setUserIdentity` method to `BMSAnalytics`

##### 2.0.0
 * Changed JS API signatures 
      * `BMSClient.initialize(backendRoute, backendGuid)` --> `BMSClient.initialize(region)`
      * `MFPRequest` --> `BMSClient`
      * `MFPLogger` --> `BMSLogger`
       * `getInstance` --> `getLogger`
       * `getCapture` --> `isStoringLogs`
       * `setCapture` --> `storeLogs`
       * `getMaxStoreSize` --> `getMaxLogStoreSize`
       * `setMaxStoreSize` --> `setMaxLogStoreSize`
       * `getLevel` --> `getLogLevel`
       * `setLevel` --> `setLogLevel`
      * `MFPAuthorizationManager` --> `BMSAuthorizationManager`
      * `MFPAnalytics` --> `BMSAnalytics`
       
 * Added `isSDKDebugLoggingEnabled` to `BMSLogger`/`MFPLogger`
 * Added `BMSAnalytics.NONE`, `BMSAnalytics.ALL`, and `BMSAnalytics.LIFECYCLE` to `BMSLogger`/`MFPLogger`
 * Added `BMSAnalytics.initialize` to `BMSLogger`/`MFPLogger`
 * Removed `initialize` from `BMSAuthorization`/`MFPAuthorizationManager`, use native implementation
 * Removed the use of using a copy of `Bridging-Header.h`, so that developers will no longer need to do this manually
 * Added a new initializer for BMSClient that does not require the app route and app guid: `BMSClient.initialize(BMSClient.REGION_US_SOUTH);`
 * Removed filters and capture methods for `BMSLogger`, use `BMSLogger.getLogLevel` or `BMSLogger.setLogLevel`
 * Added `initMCAAuthorizationManagerManager` to handle initialize MCA in iOS native 

##### 1.0.0
 * Initial release
 
 
<a name="copyrights"></a>
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
