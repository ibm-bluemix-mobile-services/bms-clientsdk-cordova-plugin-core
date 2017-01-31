/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/


import Foundation
import BMSCore
import BMSAnalytics


@objc(CDVBMSAnalytics) class CDVBMSAnalytics : CDVPlugin {

    func setUserIdentity(_ command: CDVInvokedUrlCommand){
        let userIdentity = command.arguments[0] as! String

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                Analytics.userIdentity = userIdentity
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: true)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                Analytics.userIdentity = userIdentity
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: true)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            })
        #endif
    }

    func enable(_ command: CDVInvokedUrlCommand) {

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                Analytics.isEnabled = true
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: true)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                Analytics.isEnabled = true
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: true)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            })
        #endif
    }

    func disable(_ command: CDVInvokedUrlCommand) {

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                Analytics.isEnabled = false
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: false)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                Analytics.isEnabled = false
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: false)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            })
        #endif
    }

    func isEnabled(_ command: CDVInvokedUrlCommand) {

        // has success, failure callbacks

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let isEnabled = Analytics.isEnabled
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isEnabled)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                Analytics.isEnabled = false
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: false)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            })
        #endif
    }



    func send(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                Analytics.send(completionHandler: { (response: Response?, error:Error?) in
                        if (error != nil) {
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: false)
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                        } else {
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: true)
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                        }
                })
            })
        #else
            self.commandDelegate!.runInBackground({
                Analytics.send(completionHandler: { (response: Response?, error:NSError?) in
                    if (error != nil) {
                        // process the error
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsBool:false)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    } else {
                        // process success
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: true)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    }
                })
            })
        #endif
    }

     func initialize(_ command: CDVInvokedUrlCommand){

            let appName = command.arguments[0] as! String
            let clientApiKey = command.arguments[1] as! String
            let hasUserContext = command.arguments[2] as! Bool
            let events = command.arguments[3] as! [Int]
            var deviceEvents = [DeviceEvent]()
            var lifecycleFlag: Bool = false
            var networkFlag:Bool = false
            var noneFlag:Bool = false

            for i in 0..<events.count {
                switch(events[i]){
                case 0:
                    noneFlag = true
                    break; // NONE should not enable any deviceEvents
                case 1:
                    lifecycleFlag = true;
                    networkFlag = true;
                    break;
                case 2:
                    lifecycleFlag = true
                    deviceEvents.append(.lifecycle)
                    break
                case 3:
                    networkFlag = true
                    deviceEvents.append(.network)
                    break
                default:
                    lifecycleFlag = true
                    deviceEvents.append(.lifecycle)
                    break
                }

            }

            #if swift(>=3.0)
                self.commandDelegate!.run(inBackground: {
                    if(noneFlag){
                        Analytics.initialize(appName: appName, apiKey: clientApiKey, hasUserContext: hasUserContext)
                    } else if (lifecycleFlag && networkFlag){
                        Analytics.initialize(appName: appName, apiKey: clientApiKey, hasUserContext: hasUserContext, deviceEvents: .lifecycle, .network)
                    } else if(networkFlag) {
                        Analytics.initialize(appName: appName, apiKey: clientApiKey, hasUserContext: hasUserContext, deviceEvents: .network)
                    } else if(lifecycleFlag){
                        Analytics.initialize(appName: appName, apiKey: clientApiKey, hasUserContext: hasUserContext, deviceEvents: .lifecycle)
                    }

                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:true)
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
            #else
                self.commandDelegate!.runInBackground({
                    if(noneFlag){
                        Analytics.initialize(appName: appName, apiKey: clientApiKey, hasUserContext: hasUserContext)
                    } else if (lifecycleFlag && networkFlag){
                        Analytics.initialize(appName: appName, apiKey: clientApiKey, hasUserContext: hasUserContext, deviceEvents: .lifecycle, .network)
                    } else if(lifecycleFlag){
                        Analytics.initialize(appName: appName, apiKey: clientApiKey, hasUserContext: hasUserContext, deviceEvents: .lifecycle)
                    }  else if(networkFlag) {
                        Analytics.initialize(appName: appName, apiKey: clientApiKey, hasUserContext: hasUserContext, deviceEvents: .network)
                    }

                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool:true)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                })
            #endif

     }


    func log(_ command: CDVInvokedUrlCommand) {
        let meta = command.arguments[0] as! Dictionary<String, Any>

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                Analytics.log(metadata: meta)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:true)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                Analytics.log(metadata: (meta as? [String: AnyObject])!)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool:true)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif

    }
}
