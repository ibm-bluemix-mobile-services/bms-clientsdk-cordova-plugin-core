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

@objc(CDVMFPAnalytics) class CDVMFPAnalytics : CDVPlugin {

    func enable(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            IMFAnalytics.sharedInstance().setEnabled(true)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: true)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }

    func disable(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            IMFAnalytics.sharedInstance().setEnabled(false)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: false)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }

    func isEnabled(command: CDVInvokedUrlCommand) {
        
        // has success, failure callbacks
        
        self.commandDelegate!.runInBackground({
            let isEnabled = IMFAnalytics.sharedInstance().isEnabled()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: isEnabled)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
        })
    }

    func send(command: CDVInvokedUrlCommand) {
    // has success, failure callbacks
    self.commandDelegate!.runInBackground({
        IMFAnalytics.sharedInstance().sendPersistedLogs()
    })
    }

    // TODO (For future release)
    func logEvent(command: CDVInvokedUrlCommand) {
    // takes parms: msg, name

    }
}