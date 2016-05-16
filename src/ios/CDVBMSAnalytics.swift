/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/

import Foundation
import BMSAnalytics
import BMSAnalyticsAPI

@objc(CDVBMSAnalytics) class CDVBMSAnalytics : CDVPlugin {
    
    static let bmsLogger = Logger.logger(forName: Logger.bmsLoggerPrefix + "CDVBMSAnalytics")
    
    func initializeWithAppName(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let appName = command.arguments[0] as? String else {
                let message = "Unable to initialize. App name parameter is invalid"
                CDVBMSAnalytics.bmsLogger.debug(message)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            guard let apiKey = command.arguments[1] as? String else {
                let message = "Unable to initialize. API key parameter is invalid"
                CDVBMSAnalytics.bmsLogger.debug(message)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            guard let jsDeviceEvents = command.arguments[2] as? [String] else {
                let message = "Unable to initialize. Device events parameter is invalid"
                CDVBMSAnalytics.bmsLogger.debug(message)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            var deviceEvents = [DeviceEvent]()
            for event in jsDeviceEvents {
                if (self.validDeviceEvent(event)) {
                    deviceEvents.append(self.getDeviceEvent(event))
                }
            }
            
            Analytics.initializeWithAppName(appName, apiKey: apiKey, deviceEvents: DeviceEvent.LIFECYCLE)
            
            let message = "Initialized app with name \(appName)"
            CDVBMSAnalytics.bmsLogger.debug(message)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    private func validDeviceEvent(event: String) -> Bool {
        switch event {
        case "LIFECYCLE":
            return true
        case "ALL":
            return true
        case "NONE":
            return true
        default:
            return false
        }
    }
    
    private func getDeviceEvent(event: String) -> DeviceEvent {
        
        // TODO: Add new cases for ALL and NONE
        switch event {
        case "LIFECYCLE":
            return DeviceEvent.LIFECYCLE
        default:
            return DeviceEvent.LIFECYCLE
        }
    }
    
    func enable(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            Analytics.enabled = true;
            
            let message = "Analytics logging is enabled"
            CDVBMSAnalytics.bmsLogger.debug(message)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func disable(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            Analytics.enabled = false;
            
            let message = "Analytics logging is disabled"
            CDVBMSAnalytics.bmsLogger.debug(message)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func isEnabled(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let enabled = Analytics.enabled
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: enabled)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func setUserIdentity(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let identity = command.arguments[0] as? String else {
                let message = "Unable to set user identity. Identity parameter is invalid"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                CDVBMSAnalytics.bmsLogger.debug(message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            Analytics.userIdentity = identity
            
            let message = "User identity is set to \(identity)"
            CDVBMSAnalytics.bmsLogger.debug(message)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func log(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let jsonObj = command.arguments[0] as? [String : AnyObject] else {
                let message = "Unable to log. JSON object parameter is invalid"
                CDVBMSAnalytics.bmsLogger.debug(message)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            Analytics.log(jsonObj);
            
            let message = "Logged Analytics data"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func send(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            Analytics.send(completionHandler: { (response, error) -> Void in
                
                if (error != nil) {
                    let message = error.debugDescription
                    CDVBMSAnalytics.bmsLogger.debug(message)
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
                else {
                    let message = response?.responseText
                    CDVBMSAnalytics.bmsLogger.debug(message!)
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
            })
        })
    }   
}