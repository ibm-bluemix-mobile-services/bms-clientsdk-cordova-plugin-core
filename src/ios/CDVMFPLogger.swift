/*
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
*/
import Foundation
import IMFCore

@objc(CDVMFPLogger) class CDVMFPLogger : CDVPlugin {
    
    let logLevelDictionary: Dictionary<String,IMFLogLevel> = [
        "TRACE"     : IMFLogLevel.Trace,
        "DEBUG"     : IMFLogLevel.Debug,
        "LOG"       : IMFLogLevel.Log,
        "INFO"      : IMFLogLevel.Info,
        "WARN"      : IMFLogLevel.Warn,
        "ERROR"     : IMFLogLevel.Error,
        "FATAL"     : IMFLogLevel.Fatal,
        "ANALYTICS" : IMFLogLevel.Analytics,
    ]

    func getCapture(command: CDVInvokedUrlCommand){
        
        self.commandDelegate!.runInBackground({
            
            let isCaptureEnabled = IMFLogger.getCapture()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: isCaptureEnabled)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func setCapture(command: CDVInvokedUrlCommand){

        guard let enabled  = command.arguments[0] as? Bool else {
            let message = "Enabled Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        IMFLogger.setCapture(enabled)

    }
    
    func getFilters(command: CDVInvokedUrlCommand){
        
        self.commandDelegate!.runInBackground({
            
            let filters = IMFLogger.getFilters()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: filters)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func setFilters(command: CDVInvokedUrlCommand){
        // parms: [filters]
        
        guard let filters  = (command.arguments[0] as? [NSObject:AnyObject]) else {
            let message = "Filters Object is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        IMFLogger.setFilters(filters)

    }
    
    func getMaxStoreSize(command: CDVInvokedUrlCommand){
        
        self.commandDelegate!.runInBackground({
            
            let maxStoreSize = IMFLogger.getMaxStoreSize()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsInt: maxStoreSize)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func setMaxStoreSize(command: CDVInvokedUrlCommand){
        // parms: [maxStoreSize]
        
        guard let maxStoreSize  = (command.arguments[0] as? Int) else {
            let message = "MaxStoreSize is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        IMFLogger.setMaxStoreSize(Int32(maxStoreSize))

    }
    
    func getLevel(command: CDVInvokedUrlCommand){
        
        self.commandDelegate!.runInBackground({
        
            let logLevel: Int32 = Int32(IMFLogger.getLogLevel().rawValue)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsInt: logLevel)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func setLevel(command: CDVInvokedUrlCommand){
        // parms: [logLevel]
        
        guard let levelString =  command.arguments[0] as? String else {
            let message = "LogLevel Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        // covert inputLevel to the enum type
        guard let logLevel : IMFLogLevel = self.logLevelDictionary[levelString] else
        {
            let message = "LogLevel Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        IMFLogger.setLogLevel(logLevel)

    }
    
    func isUncaughtExceptionDetected(command: CDVInvokedUrlCommand){
        
        self.commandDelegate!.runInBackground({
            
            let uncaughtExeptionDetected = IMFLogger.uncaughtExceptionDetected()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: uncaughtExeptionDetected)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func send(command: CDVInvokedUrlCommand){
        
        self.commandDelegate!.runInBackground({
            IMFLogger.send()
        })
    }
    
    func debug(command: CDVInvokedUrlCommand) {
        // parms: [name, message]
        
        guard let name  = command.arguments[0] as? String else {
            let message = "Name  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let message  = command.arguments[1] as? String else {
            
            let msg = "message  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: msg)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        let logger = IMFLogger(forName: name)
        logger.logWithLevel(.Debug, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())
    }
    
    func info(command: CDVInvokedUrlCommand){
        // parms: [name, message]
        
        guard let name  = command.arguments[0] as? String else {
            let message = "Name  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let message  = command.arguments[1] as? String else {
            let msg = "message  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: msg)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        let logger = IMFLogger(forName: name)
        logger.logWithLevel(.Info, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())

    }
    
    func warn(command: CDVInvokedUrlCommand){
        // parms: [name, message]
        
        guard let name  = command.arguments[0] as? String else {
            let message = "Name  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let message  = command.arguments[1] as? String else {
            let msg = "message  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: msg)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        let logger = IMFLogger(forName: name)
        logger.logWithLevel(.Warn, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())

    }
    
    func error(command: CDVInvokedUrlCommand){
        // parms: [name, message]
        
        guard let name  = command.arguments[0] as? String else {
            let message = "Name  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let message  = command.arguments[1] as? String else {
            let msg = "message  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: msg)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        let logger = IMFLogger(forName: name)
        logger.logWithLevel(.Error, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())

    }
    
    func fatal(command: CDVInvokedUrlCommand){
        // parms: [name, message]
        
        guard let name  = command.arguments[0] as? String else {
            let message = "Name  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let message  = command.arguments[1] as? String else {
            let msg = "message  Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: msg)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        let logger = IMFLogger(forName: name)
        logger.logWithLevel(.Fatal, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())
        
    }
}