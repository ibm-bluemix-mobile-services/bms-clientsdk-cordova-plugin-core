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


@objc(CDVBMSClient) class CDVBMSClient : CDVPlugin {

    func initialize(_ command: CDVInvokedUrlCommand) {
#if swift(>=3.0)
        self.commandDelegate!.run(inBackground: {

            guard let region  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: CustomErrorMessages.invalidRoute)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            let client = BMSClient.sharedInstance;

            //use category to handle objective-c exception
            client.initialize(bluemixAppRoute: "", bluemixAppGUID: "", bluemixRegion: region)


            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)

        })
#else
        self.commandDelegate.runInBackground({

            guard let region  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.invalidRoute)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }

            let client = BMSClient.sharedInstance;

            //use category to handle objective-c exception
            client.initialize(bluemixAppRoute: "", bluemixAppGUID: "", bluemixRegion: region)


            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "")
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
#endif
    }

    func getBluemixAppRoute(_ command: CDVInvokedUrlCommand) {

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {

            let client = BMSClient.sharedInstance
            let backendRoute: String = client.bluemixAppRoute!
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: backendRoute)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({

                let client = BMSClient.sharedInstance
                let backendRoute: String = client.bluemixAppRoute!
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: backendRoute)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif

    }

    func getBluemixAppGUID(_ command: CDVInvokedUrlCommand) {

        #if swift(>=3.0)
        self.commandDelegate!.run(inBackground: {

            let client = BMSClient.sharedInstance
            let backendGUID: String = client.bluemixAppGUID!
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: backendGUID)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
            #else
            self.commandDelegate!.runInBackground({

                let client = BMSClient.sharedInstance
                let backendGUID: String = client.bluemixAppGUID!
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: backendGUID)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif

    }
}
