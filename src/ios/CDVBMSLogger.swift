/*
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
*/
import Foundation
import BMSCore

@objc(CDVBMSLogger) class CDVBMSLogger : CDVPlugin {

    static let logLevelDictionary: Dictionary<String,LogLevel> = [
        "NONE"      : LogLevel.none,
        "DEBUG"     : LogLevel.debug,
        "INFO"      : LogLevel.info,
        "WARN"      : LogLevel.warn,
        "ERROR"     : LogLevel.error,
        "FATAL"     : LogLevel.fatal,
        "ANALYTICS" : LogLevel.analytics,
    ]

    func isStoringLogs(_ command: CDVInvokedUrlCommand){

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {

                let isLogStorageEnabled = Logger.isLogStorageEnabled
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isLogStorageEnabled)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({

                let isLogStorageEnabled = Logger.isLogStorageEnabled
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: isLogStorageEnabled)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func storeLogs(_ command: CDVInvokedUrlCommand){
        // parms: [LogStorageEnabled]

        #if swift(>=3.0)
            guard let LogStorageEnabled  = (command.arguments[0] as? Bool) else {
                let message = "LogStorageEnabled is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
            guard let LogStorageEnabled  = (command.arguments[0] as? Bool) else {
            let message = "LogStorageEnabled is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
            }
        #endif

        Logger.isLogStorageEnabled = LogStorageEnabled

    }

    func isSDKDebugLoggingEnabled(_ command: CDVInvokedUrlCommand){

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {

                let isInternalDebugLoggingEnabled = Logger.isInternalDebugLoggingEnabled
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isInternalDebugLoggingEnabled)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({

                let isInternalDebugLoggingEnabled = Logger.isInternalDebugLoggingEnabled
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: isInternalDebugLoggingEnabled)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func setSDKDebugLoggingEnabled(_ command: CDVInvokedUrlCommand){
        // parms: [isInternalDebugLoggingEnabled]

        #if swift(>=3.0)
            guard let isInternalDebugLoggingEnabled  = (command.arguments[0] as? Bool) else {
                let message = "isInternalDebugLoggingEnabled is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
            guard let isInternalDebugLoggingEnabled  = (command.arguments[0] as? Bool) else {
            let message = "isInternalDebugLoggingEnabled is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
            }
        #endif

        Logger.isInternalDebugLoggingEnabled = isInternalDebugLoggingEnabled

    }

    func getMaxLogStoreSize(_ command: CDVInvokedUrlCommand){

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let maxStoreSize = Logger.maxLogStoreSize
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: Int32(maxStoreSize))
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                let maxStoreSize = Logger.maxLogStoreSize
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsInt: Int32(maxStoreSize))
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func setMaxLogStoreSize(_ command: CDVInvokedUrlCommand){
        // parms: [maxStoreSize]

        #if swift(>=3.0)
            guard let maxStoreSize  = (command.arguments[0] as? Int) else {
                let message = "MaxLogStoreSize is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
            guard let maxStoreSize  = (command.arguments[0] as? Int) else {
                let message = "MaxLogStoreSize is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                // call error callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
        #endif

        Logger.maxLogStoreSize = UInt64(maxStoreSize)

    }


    func getLogLevel(_ command: CDVInvokedUrlCommand){

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {

                let logLevel: String = Logger.logLevelFilter.asString
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: logLevel)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({

                let logLevel: String = Logger.logLevelFilter.asString
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: logLevel)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func setLogLevel(_ command: CDVInvokedUrlCommand){
        // parms: [logLevel]

        #if swift(>=3.0)
            guard let levelString =  command.arguments[0] as? String else {
                let message = "LogLevel Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            // covert inputLevel to the enum type
            guard let logLevel : LogLevel = CDVBMSLogger.logLevelDictionary[levelString] else
            {
                let message = "LogLevel Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
            guard let levelString =  command.arguments[0] as? String else {
                let message = "LogLevel Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                // call error callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }

            // covert inputLevel to the enum type
            guard let logLevel : LogLevel = CDVBMSLogger.logLevelDictionary[levelString] else
            {
                let message = "LogLevel Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                // call error callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
        #endif

        Logger.logLevelFilter = logLevel

    }

    func isUncaughtExceptionDetected(_ command: CDVInvokedUrlCommand){

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {

                let uncaughtExeptionDetected = Logger.isUncaughtExceptionDetected
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: uncaughtExeptionDetected)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({

                let uncaughtExeptionDetected = Logger.isUncaughtExceptionDetected
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: uncaughtExeptionDetected)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

     func send(_ command: CDVInvokedUrlCommand){
         #if swift(>=3.0)
             self.commandDelegate!.run(inBackground: {
                 Logger.send(completionHandler: { (response: Response?, error:Error?) in
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
                 Logger.send(completionHandler: { (response: Response?, error:NSError?) in
                     if (error != nil) {
                         let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsBool: false)
                         self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                     } else {
                         let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: true)
                         self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                     }
                 })
             })
         #endif
     }

    func debug(_ command: CDVInvokedUrlCommand) {
        // parms: [name, message]

        #if swift(>=3.0)
            guard let name  = command.arguments[0] as? String else {
                let message = "Name  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            guard let message  = command.arguments[1] as? String else {

                let msg = "message  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: msg)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
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
        #endif


        let logger = Logger.logger(name: name)
        logger.debug(message: message)
    }

    func info(_ command: CDVInvokedUrlCommand){
        // parms: [name, message]

        #if swift(>=3.0)
            guard let name  = command.arguments[0] as? String else {
                let message = "Name  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            guard let message  = command.arguments[1] as? String else {
                let msg = "message  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: msg)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
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
        #endif

        let logger = Logger.logger(name: name)
        logger.info(message: message)


    }

    func warn(_ command: CDVInvokedUrlCommand){
        // parms: [name, message]

        #if swift(>=3.0)
            guard let name  = command.arguments[0] as? String else {
                let message = "Name  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            guard let message  = command.arguments[1] as? String else {
                let msg = "message  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: msg)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
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
        #endif

        let logger = Logger.logger(name: name)
        logger.warn(message: message)
    }

    func error(_ command: CDVInvokedUrlCommand){
        // parms: [name, message]

        #if swift(>=3.0)
            guard let name  = command.arguments[0] as? String else {
                let message = "Name  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            guard let message  = command.arguments[1] as? String else {
                let msg = "message  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: msg)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
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
        #endif

        let logger = Logger.logger(name: name)
        logger.error(message: message)
    }

    func fatal(_ command: CDVInvokedUrlCommand){
        // parms: [name, message]

        #if swift(>=3.0)
            guard let name  = command.arguments[0] as? String else {
                let message = "Name  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            guard let message  = command.arguments[1] as? String else {
                let msg = "message  Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: msg)
                // call error callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
        #else
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
        #endif

        let logger = Logger.logger(name: name)
        logger.fatal(message: message)

    }
}