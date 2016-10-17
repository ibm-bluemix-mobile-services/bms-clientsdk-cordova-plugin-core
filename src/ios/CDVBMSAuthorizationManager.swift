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
import BMSSecurity


@objc(CDVBMSAuthenticationManager) class CDVBMSAuthorizationManager : CDVPlugin {

    func initialize(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {

                guard let tenantId = command.arguments[0] as? String else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: CustomErrorMessages.invalidTenantId)
                    // call failure callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    return
                }

                let authManager = MCAAuthorizationManager.sharedInstance
                authManager.initialize(tenantId: tenantId)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            });
        #else
            self.commandDelegate!.runInBackground({

                guard let tenantId = command.arguments[0] as? String else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.invalidTenantId)
                    // call failure callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    return
                }

                let authManager = MCAAuthorizationManager.sharedInstance
                authManager.initialize(tenantId: tenantId)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            });

        #endif
    }

    func obtainAuthorizationHeader(_ command: CDVInvokedUrlCommand) {
        let authManager = MCAAuthorizationManager.sharedInstance;

        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                authManager.obtainAuthorization{ (response: Response?, error: Error?) -> Void in
                    var responseString: String?

                    do {
                        if (error != nil) {
                            // process the error
                            try responseString = Utils.packResponse(response, error: error as NSError?)
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: responseString)
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                        } else {
                            // process success
                            try responseString = Utils.packResponse(response)
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: responseString)
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                        }
                    } catch {
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: CustomErrorMessages.errorParsingJSONResponse)
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    }
                }


            });
        #else
            self.commandDelegate!.runInBackground({

                authManager.obtainAuthorization { (response: Response?, error: NSError?) -> Void in
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
        #endif

    }

    func isAuthorizationRequired(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {

                do {
                    let authManager = MCAAuthorizationManager.sharedInstance
                    let params = try self.unpackIsAuthorizationRequiredParams(command);

                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:authManager.isAuthorizationRequired(for: Int(params.statusCode), httpResponseAuthorizationHeader: params.authorizationHeaderValue))

                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                } catch {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid parameters passed to isAuthorizationRequired method")
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                }
            })
        #else
            self.commandDelegate!.runInBackground({

                do {
                    let authManager = MCAAuthorizationManager.sharedInstance
                    let params = try self.unpackIsAuthorizationRequiredParams(command);

                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool:authManager.isAuthorizationRequired(for: Int(params.statusCode), httpResponseAuthorizationHeader: params.authorizationHeaderValue))

                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                } catch {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid parameters passed to isAuthorizationRequired method")
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            })
        #endif
    }

    func clearAuthorizationData(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let authManager = MCAAuthorizationManager.sharedInstance
                authManager.clearAuthorizationData()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                let authManager = MCAAuthorizationManager.sharedInstance
                authManager.clearAuthorizationData()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func getCachedAuthorizationHeader(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
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
        #else
            self.commandDelegate!.runInBackground({
                let authManager = MCAAuthorizationManager.sharedInstance

                if let authHeader: String = authManager.cachedAuthorizationHeader {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:authHeader)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                } else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.noCachedAuthorizationHeader)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            })
        #endif
    }

    func getUserIdentity(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let authManager = MCAAuthorizationManager.sharedInstance
                var pluginResult: CDVPluginResult? = nil

                do {
                    let userIdentity: String = try Utils.stringifyResponse(authManager.userIdentity as AnyObject)
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:userIdentity)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.errorObtainUserIdentity)
                }

                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                let authManager = MCAAuthorizationManager.sharedInstance
                var pluginResult: CDVPluginResult? = nil

                do {
                    let userIdentity: String = try Utils.stringifyResponse(authManager.userIdentity as! AnyObject)
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:userIdentity)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.errorObtainUserIdentity)
                }

                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func getAppIdentity(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let authManager = MCAAuthorizationManager.sharedInstance
                var pluginResult: CDVPluginResult? = nil

                do {
                    let appIdentity: String = try Utils.stringifyResponse(authManager.appIdentity as AnyObject)
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:appIdentity)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.errorObtainAppIdentity)
                }

                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                let authManager = MCAAuthorizationManager.sharedInstance
                var pluginResult: CDVPluginResult? = nil

                do {
                    let appIdentity: String = try Utils.stringifyResponse(authManager.appIdentity as! AnyObject)
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:appIdentity)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.errorObtainAppIdentity)
                }

                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func getDeviceIdentity(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let authManager = MCAAuthorizationManager.sharedInstance
                var pluginResult: CDVPluginResult? = nil

                do {
                    let deviceIdentity: String = try Utils.stringifyResponse(authManager.deviceIdentity as AnyObject)
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:deviceIdentity)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.errorObtainDeviceIdentity)
                }

                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                let authManager = MCAAuthorizationManager.sharedInstance
                var pluginResult: CDVPluginResult? = nil

                do {
                    let deviceIdentity: String = try Utils.stringifyResponse(authManager.deviceIdentity as! AnyObject)
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:deviceIdentity)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.errorObtainDeviceIdentity)
                }

                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func getAuthorizationPersistencePolicy(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let authManager = MCAAuthorizationManager.sharedInstance
                let policy: PersistencePolicy = authManager.authorizationPersistencePolicy()
                var pluginResult: CDVPluginResult? = nil

                switch policy {
                    case PersistencePolicy.always:
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:PersistencePolicy.always.rawValue)
                    case PersistencePolicy.never:
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs:PersistencePolicy.never.rawValue)
                    default:
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.invalidPolicyType)
                }

                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                let authManager = MCAAuthorizationManager.sharedInstance
                let policy: PersistencePolicy = authManager.authorizationPersistencePolicy()
                var pluginResult: CDVPluginResult? = nil

                switch policy {
                case PersistencePolicy.always:
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:PersistencePolicy.always.rawValue)
                case PersistencePolicy.never:
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:PersistencePolicy.never.rawValue)
                default:
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.invalidPolicyType)
                }

                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func setAuthorizationPersistencePolicy(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let authManager = MCAAuthorizationManager.sharedInstance
                guard let policy: String = command.arguments[0] as? String else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs:CustomErrorMessages.invalidPolicySpecified)
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    return
                }

                switch policy {
                    case PersistencePolicy.always.rawValue:
                        authManager.setAuthorizationPersistencePolicy(PersistencePolicy.always)
                    case PersistencePolicy.never.rawValue:
                        authManager.setAuthorizationPersistencePolicy(PersistencePolicy.never)
                    default:
                        authManager.setAuthorizationPersistencePolicy(PersistencePolicy.never)
                }

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            })
        #else
            self.commandDelegate!.runInBackground({
                let authManager = MCAAuthorizationManager.sharedInstance
                guard let policy: String = command.arguments[0] as? String else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.invalidPolicySpecified)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    return
                }

                switch policy {
                    case PersistencePolicy.always.rawValue:
                        authManager.setAuthorizationPersistencePolicy(PersistencePolicy.always)
                    case PersistencePolicy.never.rawValue:
                        authManager.setAuthorizationPersistencePolicy(PersistencePolicy.never)
                    default:
                        authManager.setAuthorizationPersistencePolicy(PersistencePolicy.never)
                }

                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
        #endif
    }

    func logout(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let authManager = MCAAuthorizationManager.sharedInstance
                    authManager.logout{ (response: Response?, error: Error?) -> Void in
                    var responseString: String?
                    do {
                        if (error != nil) {
                            // process the error
                            try responseString = Utils.packResponse(response, error: error as NSError?)
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: responseString)
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                        } else {
                            // process success
                            try responseString = Utils.packResponse(response)
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: responseString)
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                        }
                    } catch {
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: CustomErrorMessages.errorParsingJSONResponse)
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    }
                }

            });
        #else
            self.commandDelegate!.runInBackground({
                let authManager = MCAAuthorizationManager.sharedInstance
                authManager.logout{ (response: Response?, error: NSError?) -> Void in
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
        #endif
    }

    func unpackIsAuthorizationRequiredParams(_ command: CDVInvokedUrlCommand) throws -> (statusCode: Int32, authorizationHeaderValue: String) {
        if (command.arguments.count < 2) {
            throw CustomErrors.InvalidParameterCount(expected: 2, actual: command.arguments.count)
        }
        #if swift(>=3.0)
            guard let param0 = command.argument(at: 0) as? NSNumber else {
                throw CustomErrors.InvalidParameterType(expected: "NSNumber", actual: command.argument(at: 1) as AnyObject)
            }

            guard let param1: NSString = command.argument(at: 1) as? NSString else {
                throw CustomErrors.InvalidParameterType(expected: "String", actual: command.argument(at: 1) as AnyObject)
            }
        #else
            guard let param0 = command.argumentAtIndex(0) as? NSNumber else {
                throw CustomErrors.InvalidParameterType(expected: "NSNumber", actual: command.argumentAtIndex(1) as AnyObject)
            }

            guard let param1: NSString = command.argumentAtIndex(1) as? NSString else {
                throw CustomErrors.InvalidParameterType(expected: "String", actual: command.argumentAtIndex(1) as AnyObject)
            }
        #endif

        return (statusCode: Int32(param0.intValue), authorizationHeaderValue: param1 as String)
    }

}
