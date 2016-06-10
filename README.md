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

| Javascript Function | Description |
| :---|:---|
**initialize(bluemixAppRoute:string, bluemixAppGUID:string, bluemixRegion:string)** | Sets the base URL for the authorization server. For the region use one of the BMSClient.REGION constants.
**getBluemixAppRoute(callback:function)** | Returns the base URL for the authorization server. The first parameter of the callback is the returned Bluemix app route.
**getBluemixAppGUID(callback:function)** |  Returns the backend application id. The first parameter of the callback is the returned Bluemix app GUID.
**getDefaultTimeoutRequest(callback:function)** | Returns the default timeout (in seconds) for all BMS network requests. The first parameter of the callback is the returned default timeout.
**setDefaultTimeoutRequest(timeout:int)** | Sets the default timeout (in seconds) for all BMS network requests.
**registerAuthenticationListener(realm:string, userAuthenticationListener:Object)** | Registers a delegate that will handle authentication for the specified realm.
**unregisterAuthenticationListener(realm:string)** | Unregisters the authentication callback for the specified realm.

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
