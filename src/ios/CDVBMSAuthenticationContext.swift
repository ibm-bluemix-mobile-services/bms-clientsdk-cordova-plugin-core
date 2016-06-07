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
import BMSSecurity

@objc(CDVBMSAuthenticationContext) class CDVBMSAuthenticationContext : CDVPlugin {
    
    func submitAuthenticationChallengeAnswer(command: CDVInvokedUrlCommand) {
    
        self.commandDelegate!.runInBackground({
            
            guard let answer = command.arguments[0] as? [String : AnyObject] else {
                let message = "Invalid answer. Unable to submit authentication challenge answer"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            guard let realm = command.arguments[1] as? String else {
                let message = "Invalid realm. Unable to submit authentication challenge answer"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            let context = CDVBMSSecurity.authenticationContexts[realm] as! AuthenticationContext
            context.submitAuthenticationChallengeAnswer(answer)
        })
    }
    
    func submitAuthenticationSuccess(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let realm = command.arguments[0] as? String else {
                let message = "Invalid realm. Unable to submit authentication challenge answer"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            
            let context = CDVBMSSecurity.authenticationContexts[realm] as! AuthenticationContext
            context.submitAuthenticationSuccess()
        })
    }
    
    func submitAuthenticationFailure(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let info = command.arguments[0] as? [String : AnyObject] else {
                let message = "Invalid info. Unable to submit authentication challenge answer"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            guard let realm = command.arguments[1] as? String else {
                let message = "Invalid realm. Unable to submit authentication challenge answer"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            
            let context = CDVBMSSecurity.authenticationContexts[realm] as! AuthenticationContext
            context.submitAuthenticationFailure(info)
        })
    }
}