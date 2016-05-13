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

@objc(CDVBMSLogger) class CDVBMSLogger : CDVPlugin {
    
    func log(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let name = command.arguments[0] as? String else {
                let message = "Unable to log message. Logger name parameter is invalid"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            guard let logMessage = command.arguments[1] as? String else {
                let message = "Unable to log message. Message parameter is invalid"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            guard let level = command.arguments[2] as? String else {
                let message = "Unable to log message. Level parameter is invalid"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            let logger = Logger.logger(forName: name)
            
            switch level {
            case "DEBUG":
                logger.debug(logMessage)
            case "INFO":
                logger.info(logMessage)
            case "WARN":
                logger.warn(logMessage)
            case "ERROR":
                logger.error(logMessage)
            case "FATAL":
                logger.fatal(logMessage)
            default:
                let message = "Unable to log message. Invalid log level"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            let message = "Logged " + String(level) + " level message"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        })
    }
    
    func getLogLevelFilter(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            var level = ""
            
            switch Logger.logLevelFilter {
            case LogLevel.Analytics:
                level = "ANALYTICS"
            case LogLevel.Fatal:
                level = "FATAL"
            case LogLevel.Error:
                level = "ERROR"
            case LogLevel.Warn:
                level = "WARN"
            case LogLevel.Info:
                level = "INFO"
            case LogLevel.Debug:
                level = "DEBUG"
            case LogLevel.None:
                level = "NONE"
            }
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: level)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        })
    }
    
    func setLogLevelFilter(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let levelParam = command.arguments[0] as? String else {
                let message = "Unable to set log level filter. Level parameter is invalid. Use one of the BMSLogger.Level constants"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            var levelFilter = LogLevel.Debug
            
            switch levelParam {
            case "ANALYTICS":
                levelFilter = LogLevel.Analytics
            case "FATAL":
                levelFilter = LogLevel.Fatal
            case "ERROR":
                levelFilter = LogLevel.Error
            case "WARN":
                levelFilter = LogLevel.Warn
            case "INFO":
                levelFilter = LogLevel.Info
            case "DEBUG":
                levelFilter = LogLevel.Debug
            case "NONE":
                levelFilter = LogLevel.None
            default:
                levelFilter = LogLevel.Debug
            }
            
            Logger.logLevelFilter = levelFilter
            
            let message = "Log level filter is set to " + levelParam
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func sdkDebugLoggingEnabled(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let value = Logger.sdkDebugLoggingEnabled
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: value)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            return
        })
    }
    
    func setSDKDebugLogging(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let value = command.arguments[0] as? Bool else {
                let message = "Unable to set SDK debug logging. Parameter must be a boolean value"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            Logger.sdkDebugLoggingEnabled = value
            
            let message = "SDK debug logging is set to " + String(value)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func getLogStore(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let logStore = Logger.logStoreEnabled
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: logStore)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func setLogStore(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
          
            guard let value = command.arguments[0] as? Bool else {
                let message = "Unable to set log store. Parameter must be a boolean value"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }

            Logger.logStoreEnabled = value;
            
            let message = "Log store is set to " + String(value)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func getMaxLogStoreSize(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let maxLogStoreSize = Logger.maxLogStoreSize
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsNSInteger: Int(maxLogStoreSize))
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func setMaxLogStoreSize(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let maxLogStoreSize = command.arguments[0] as? Int else {
                let message = "Unable to set log store. Parameter must be an integer value"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            Logger.maxLogStoreSize = UInt64(maxLogStoreSize)
            
            let message = "Max log store size is set to " + String(Logger.maxLogStoreSize)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func isUncaughtExceptionDetected(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let caught = Logger.isUncaughtExceptionDetected
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: caught)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }
    
    func send(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            Logger.send(completionHandler: { (response, error) -> Void in
                if (error != nil) {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: error.debugDescription)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
                else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: response?.responseText)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
            })
        })
    }
}