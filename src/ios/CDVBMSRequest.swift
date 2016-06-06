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
import BMSAnalyticsAPI
import BMSAnalytics

@objc(CDVBMSRequest) class CDVBMSRequest : CDVPlugin {
    
    static let bmsLogger = Logger.logger(forName: Logger.bmsLoggerPrefix + "CDVBMSRequest")
    
    func send(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let request = Utils.unpackRequest(command.arguments[0] as! NSDictionary)

            let body = command.arguments[0].objectForKey("body") as! String
            
            request.sendString(body, completionHandler: { (response, error) -> Void in
                
                guard let message = Utils.packResponse(response!, error: error) else {
                    let message = "Error Parsing JSON response"
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    CDVBMSRequest.bmsLogger.debug(message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    return
                }
                
                if (error != nil) {
                    CDVBMSRequest.bmsLogger.debug("Successfully sent request")
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsDictionary: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
                else {
                    CDVBMSRequest.bmsLogger.debug("Failed to send request")
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
            })
        })
    }
}