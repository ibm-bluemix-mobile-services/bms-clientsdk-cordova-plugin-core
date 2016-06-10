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
import RNCryptor

enum PersistencePolicy: String {
    case PersistencePolicyAlways = "ALWAYS"
    case PersistencePolicyNever = "NEVER"
}

@objc(CDVMCAAuthorizationManager) class CDVMCAAuthorizationManager: CDVPlugin {
    
    func obtainAuthorizationHeader(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            mcaAuthManager.obtainAuthorization(completionHandler: { (response, error) -> Void in
                
                let message = Utils.packResponse(response, error: error)
                
                if (error != nil) {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsDictionary: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
                else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
            })
            
        })
    }
    
    func isAuthorizationRequired(command: CDVInvokedUrlCommand) {
    
        self.commandDelegate!.runInBackground({
            
            guard let statusCode = command.arguments[0] as? Int else {
                let message = "Invalid status code"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            guard let httpHeader = command.arguments[0] as? String else {
                let message = "Invalid HTTP response authorization header"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                return
            }
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            let required = mcaAuthManager.isAuthorizationRequired(forStatusCode: statusCode, httpResponseAuthorizationHeader: httpHeader)
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: required)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func clearAuthorizationData(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            mcaAuthManager.clearAuthorizationData()
            
            let message = "Cleared authorization data"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getCachedAuthorizationHeader(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            if let header: String = mcaAuthManager.cachedAuthorizationHeader {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: header)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            }
            else {
                let message = "There is no cached authorization header"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
            }
        })
    }
    
    func getUserIdentity(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            var jsonResponse: [String : AnyObject] = [:]
            
            jsonResponse["authBy"] = mcaAuthManager.userIdentity!.authBy
            jsonResponse["displayName"] = mcaAuthManager.userIdentity!.displayName
            jsonResponse["id"] = mcaAuthManager.userIdentity!.id
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: jsonResponse)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getAppIdentity(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            var jsonResponse: [String : AnyObject] = [:]
            
            jsonResponse["id"] = mcaAuthManager.appIdentity.id
            jsonResponse["version"] = mcaAuthManager.appIdentity.version
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: jsonResponse)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getDeviceIdentity(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            var jsonResponse: [String : AnyObject] = [:]
            
            jsonResponse["id"] = mcaAuthManager.deviceIdentity.id
            jsonResponse["model"] = mcaAuthManager.deviceIdentity.model
            jsonResponse["OS"] = mcaAuthManager.deviceIdentity.OS
            jsonResponse["OSVersion"] = mcaAuthManager.deviceIdentity.OSVersion
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: jsonResponse)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getAuthorizationPersistencePolicy(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            let policy = mcaAuthManager.authorizationPersistencePolicy()
            var pluginResult: CDVPluginResult? = nil
            
            switch policy {
            case BMSCore.PersistencePolicy.ALWAYS:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: PersistencePolicy.PersistencePolicyAlways.rawValue)
            case BMSCore.PersistencePolicy.NEVER:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: PersistencePolicy.PersistencePolicyNever.rawValue)
            default:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid Persistence Policy type")
            }
            
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func setAuthorizationPersistencePolicy(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance
            
            guard var policy = command.arguments[0] as? String else {
                let message = "Invalid policy specified"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            
            switch policy {
            case PersistencePolicy.PersistencePolicyAlways.rawValue:
                mcaAuthManager.setAuthorizationPersistencePolicy(BMSCore.PersistencePolicy.ALWAYS)
            case PersistencePolicy.PersistencePolicyNever.rawValue:
                mcaAuthManager.setAuthorizationPersistencePolicy(BMSCore.PersistencePolicy.NEVER)
            default:
                mcaAuthManager.setAuthorizationPersistencePolicy(BMSCore.PersistencePolicy.NEVER)
                policy = "NEVER"
            }
            
            let message = "Set persistence policy to \(policy)"
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func logout(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let mcaAuthManager = MCAAuthorizationManager.sharedInstance;
            
            mcaAuthManager.logout({ (response, error) -> Void in
                
                let message = Utils.packResponse(response, error: error)
                
                if (error != nil) {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsDictionary: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            })
        });
    }
}