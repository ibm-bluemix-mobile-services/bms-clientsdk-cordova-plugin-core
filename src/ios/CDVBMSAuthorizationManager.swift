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

enum PersistencePolicy: String {
    case PersistencePolicyAlways = "ALWAYS"
    case PersistencePolicyNever = "NEVER"
}

class CDVBMSAuthorizationManager : CDVPlugin {

    func initialize(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.run(inBackground: {

            guard let tenantId = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: CustomErrorMessages.invalidTenantId)
                // call failure callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            let authManager = MCAAuthorizationManager.sharedInstance
            authManager.initializeWithTenantId(tenantId)
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        });
    }

    func obtainAuthorizationHeader(command: CDVInvokedUrlCommand) {
        let authManager = MCAAuthorizationManager.sharedInstance();

        self.commandDelegate!.runInBackground({

            authManager.obtainAuthorizationHeaderWithCompletionHandler { (response: Response!, error: Error!) -> Void in
                var responseString: String?

                do {
                    if (error != nil) {
                        // process the error
                        try responseString = Utils.packResponse(response, error: error)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    } else {
                        // process success
                        try responseString = Utils.packResponse(response)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    }
                } catch {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.errorParsingJSONResponse)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            }

        });

    }

    func isAuthorizationRequired(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.run(inBackground: {

            do {
                let authManager = MCAAuthorizationManager.sharedInstance
                let params = try self.unpackIsAuthorizationRequiredParams(command: command);

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool:authManager.isAuthorizationRequired(params.statusCode, authorizationHeaderValue: params.authorizationHeaderValue))

                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            } catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid parameters passed to isAuthorizationRequired method")
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            }
        })
    }

    func clearAuthorizationData(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let authManager = MCAAuthorizationManager.sharedInstance
            authManager.clearAuthorizationData()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func getCachedAuthorizationHeader(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let authManager = MCAAuthorizationManager.sharedInstance

            if let authHeader: String = authManager.cachedAuthorizationHeader {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:authHeader)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            } else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: CustomErrorMessages.noCachedAuthorizationHeader)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            }
        })
    }

    func getUserIdentity(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let authManager = MCAAuthorizationManager.sharedInstance
            var pluginResult: CDVPluginResult? = nil

            do {
                let userIdentity: String = try Utils.stringifyResponse(authManager.userIdentity)
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:userIdentity)
            } catch {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.errorObtainUserIdentity)
            }

            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func getAppIdentity(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let authManager = MCAAuthorizationManager.sharedInstance
            var pluginResult: CDVPluginResult? = nil

            do {
                let appIdentity: String = try Utils.stringifyResponse(authManager.appIdentity)
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:appIdentity)
            } catch {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.errorObtainAppIdentity)
            }

            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func getDeviceIdentity(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let authManager = MCAAuthorizationManager.sharedInstance
            var pluginResult: CDVPluginResult? = nil

            do {
                let deviceIdentity: String = try Utils.stringifyResponse(authManager.deviceIdentity)
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:deviceIdentity)
            } catch {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.errorObtainDeviceIdentity)
            }

            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func getAuthorizationPersistencePolicy(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let authManager = MCAAuthorizationManager.sharedInstance
            let policy: PersistencePolicy = authManager.authorizationPersistencePolicy()
            var pluginResult: CDVPluginResult? = nil

            switch policy {
            case PersistencePolicy.PersistencePolicyAlways:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:PersistencePolicy.PersistencePolicyAlways.rawValue)
            case PersistencePolicy.PersistencePolicyNever:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:PersistencePolicy.PersistencePolicyNever.rawValue)
            default:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.invalidPolicyType)
            }

            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func setAuthorizationPersistencePolicy(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let authManager = MCAAuthorizationManager.sharedInstance
            guard let policy: String = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.invalidPolicySpecified)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            switch policy {
            case PersistencePolicy.PersistencePolicyAlways.rawValue:
                authManager.setAuthorizationPersistencePolicy(PersistencePolicy.PersistencePolicyAlways)
            case PersistencePolicy.PersistencePolicyNever.rawValue:
                authManager.setAuthorizationPersistencePolicy(PersistencePolicy.PersistencePolicyNever)
            default:
                authManager.setAuthorizationPersistencePolicy(PersistencePolicy.PersistencePolicyNever)
            }

            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func logout(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let authManager = MCAAuthorizationManager.sharedInstance
            authManager.logout{ (response: Response!, error: Error!) -> Void in
                var responseString: String?
                do {
                    if (error != nil) {
                        // process the error
                        try responseString = Utils.packResponse(response, error: error)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    } else {
                        // process success
                        try responseString = Utils.packResponse(response)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    }
                } catch {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.errorParsingJSONResponse)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            }

        });
    }

    func unpackIsAuthorizationRequiredParams(command: CDVInvokedUrlCommand) throws -> (statusCode: Int32, authorizationHeaderValue: String) {
        if (command.arguments.count < 2) {
            throw CustomErrors.InvalidParameterCount(expected: 2, actual: command.arguments.count)
        }

        guard let param0 = command.argument(at: 0) as? NSNumber else {
            throw CustomErrors.InvalidParameterType(expected: "NSNumber", actual: command.argument(at: 1) as AnyObject)
        }

        guard let param1: NSString = command.argument(at: 1) as? NSString else {
            throw CustomErrors.InvalidParameterType(expected: "String", actual: command.argument(at: 1) as AnyObject)
        }

        return (statusCode: Int32(param0.intValue), authorizationHeaderValue: param1 as String)
    }

}
