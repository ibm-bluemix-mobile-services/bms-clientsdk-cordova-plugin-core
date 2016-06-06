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
import BMSCore
import BMSAnalytics
import BMSAnalyticsAPI
import BMSSecurity

@objc(CDVBMSClient) class CDVBMSClient : CDVPlugin {
    
    static let bmsLogger = Logger.logger(forName: Logger.bmsLoggerPrefix + "CDVBMSClient")
    
    func initialize(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.runInBackground({
            
            guard let route = command.arguments[0] as? String else {
                let message = "Unable to initialize BMSClient. Invalid route"
                CDVBMSClient.bmsLogger.debug(message);
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            guard let guid = command.arguments[1] as? String else {
                let message = "Unable to initialize BMSClient. Invalid GUID"
                CDVBMSClient.bmsLogger.debug(message);
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            guard let region = command.arguments[2] as? String else {
                let message = "Unable to initialize BMSClient. Invalid region"
                CDVBMSClient.bmsLogger.debug(message);
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            BMSClient.sharedInstance.initializeWithBluemixAppRoute(route, bluemixAppGUID: guid, bluemixRegion: region)

            BMSClient.sharedInstance.authorizationManager = MCAAuthorizationManager.sharedInstance
            
            let message = "Initialized BMSClient"
            CDVBMSClient.bmsLogger.debug(message);
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
        
    }
    
    func getBluemixAppRoute(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let route = BMSClient.sharedInstance.bluemixAppRoute
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: route)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getBluemixAppGUID(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let guid = BMSClient.sharedInstance.bluemixAppGUID
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: guid)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
        
    }
    
    func getDefaultRequestTimeout(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let timeout = BMSClient.sharedInstance.defaultRequestTimeout
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDouble: timeout)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func setDefaultRequestTimeout(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let timeout = command.arguments[0] as? Double else {
                let message = "Unable to set default request timeout. Invalid timeout value"
                CDVBMSClient.bmsLogger.debug(message);
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            BMSClient.sharedInstance.defaultRequestTimeout = timeout
            
            let message = "The default request timeout is set to " + String(timeout)
            CDVBMSClient.bmsLogger.debug(message);
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
}