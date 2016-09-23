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
import BMSCore

@objc(CDVMFPLogger) class CDVMFPLogger : CDVPlugin {

    let logLevelDictionary: Dictionary<String,LogLevel> = [
        "NONE"      : LogLevel.none,
        "DEBUG"     : LogLevel.debug,
        "INFO"      : LogLevel.info,
        "WARN"      : LogLevel.warn,
        "ERROR"     : LogLevel.error,
        "FATAL"     : LogLevel.fatal,
        "ANALYTICS" : LogLevel.analytics,
    ]

    func storeLogs(command: CDVInvokedUrlCommand){

        self.commandDelegate!.run(inBackground: {

            let isLogStorageEnabled = Logger.isLogStorageEnabled
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isLogStorageEnabled)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func getMaxLogStoreSize(command: CDVInvokedUrlCommand){

        self.commandDelegate!.run(inBackground: {
            let maxStoreSize = Logger.maxLogStoreSize
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: Int32(maxStoreSize))
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func setMaxLogStoreSize(command: CDVInvokedUrlCommand){
        // parms: [maxStoreSize]

        guard let maxStoreSize  = (command.arguments[0] as? Int) else {
            let message = "MaxLogStoreSize is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
            // call error callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            return
        }

        Logger.maxLogStoreSize = UInt64(maxStoreSize)

    }

    func getLevel(command: CDVInvokedUrlCommand){

        self.commandDelegate!.run(inBackground: {

            let logLevel: String = Logger.logLevelFilter.asString
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: logLevel)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func setLevel(command: CDVInvokedUrlCommand){
        // parms: [logLevel]

        guard let levelString =  command.arguments[0] as? String else {
            let message = "LogLevel Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
            // call error callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            return
        }

        // covert inputLevel to the enum type
        guard let logLevel : LogLevel = self.logLevelDictionary[levelString] else
        {
            let message = "LogLevel Parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
            // call error callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            return
        }

        Logger.logLevelFilter = logLevel

    }

    func isUncaughtExceptionDetected(command: CDVInvokedUrlCommand){

        self.commandDelegate!.run(inBackground: {

            let uncaughtExeptionDetected = Logger.isUncaughtExceptionDetected
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: uncaughtExeptionDetected)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    //TODO: (Nana) Need to get Logger.send from Analytics
    /*
    func send(command: CDVInvokedUrlCommand){

        self.commandDelegate!.runInBackground({
            Logger.send()
        })
    }
 */

    func debug(command: CDVInvokedUrlCommand) {
        // parms: [name, message]

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

        let logger = Logger.logger(name: name)
        logger.debug(message: message)
    }

    func info(command: CDVInvokedUrlCommand){
        // parms: [name, message]

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

        let logger = Logger.logger(name: name)
        logger.info(message: message)


    }

    func warn(command: CDVInvokedUrlCommand){
        // parms: [name, message]

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

        let logger = Logger.logger(name: name)
        logger.warn(message: message)
    }

    func error(command: CDVInvokedUrlCommand){
        // parms: [name, message]

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

        let logger = Logger.logger(name: name)
        logger.error(message: message)
    }

    func fatal(command: CDVInvokedUrlCommand){
        // parms: [name, message]

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

        let logger = Logger.logger(name: name)
        logger.fatal(message: message)

    }
}