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

class CDVBMSAnalytics : CDVPlugin {

    func enable(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.run(inBackground: {
            Analytics.isEnabled = true
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: true)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        })
    }

    func disable(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.run(inBackground: {
            Analytics.isEnabled = false
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: false)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        })
    }

    func isEnabled(command: CDVInvokedUrlCommand) {

        // has success, failure callbacks

        self.commandDelegate!.run(inBackground: {
            let isEnabled = Analytics.isEnabled
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: isEnabled)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        })
    }



    func send(command: CDVInvokedUrlCommand) {
    // has success, failure callbacks
        self.commandDelegate!.run(inBackground: {
        //TODO: Need Analytics (Nana)    Analytics.send()
        })
    }

    // TODO (For future release)
    func logEvent(command: CDVInvokedUrlCommand) {
    // takes parms: msg, name

    }
}
