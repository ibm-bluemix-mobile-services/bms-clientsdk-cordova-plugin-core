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
import BMSSecurity



@objc(CDVBMSClient) class CDVBMSClient : CDVPlugin {

    static var jsChallengeHandlers:NSMutableDictionary = [:]
    static var authenticationContexts:NSMutableDictionary = [:]

        // Initialize MCA Auth with Tenant Id using Objective-C
        @objc static func initMCAAuthorizationManagerManager(tenantId: String){
                let mcaAuthManager = MCAAuthorizationManager.sharedInstance
                BMSClient.sharedInstance.authorizationManager = MCAAuthorizationManager.sharedInstance
                mcaAuthManager.initialize(tenantId: tenantId)

        }


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


    func registerAuthenticationListener(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                var errorText: String = ""

                do {
                    let realm = try self.unpackRealm(command)
                    let mca = MCAAuthorizationManager.sharedInstance
                    let delegate = InternalAuthenticationDelegate(realm: realm, commandDelegate: self.commandDelegate!)

                    mca.registerAuthenticationDelegate(delegate, realm: realm)

                    defer {
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: errorText)
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    }

                } catch CustomErrors.InvalidParameterType(let expected, let actual) {
                    errorText = CustomErrorMessages.invalidParameterTypeError(expected: expected, actual: actual)
                } catch CustomErrors.InvalidParameterCount(let expected, let actual) {
                    errorText = CustomErrorMessages.invalidParameterCountError(expected, actual: actual)
                } catch {
                    errorText = CustomErrorMessages.unexpectedError
                }
            })
    #else
            self.commandDelegate!.runInBackground({
            var errorText: String = ""

                do {
                let realm = try self.unpackRealm(command)
                let mca = MCAAuthorizationManager.sharedInstance
                let delegate = InternalAuthenticationDelegate(realm: realm, commandDelegate: self.commandDelegate!)

                mca.registerAuthenticationDelegate(delegate, realm: realm)

                defer {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: errorText)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }

                } catch CustomErrors.InvalidParameterType(let expected, let actual) {
                    errorText = CustomErrorMessages.invalidParameterTypeError(expected, actual: actual)
                } catch CustomErrors.InvalidParameterCount(let expected, let actual) {
                    errorText = CustomErrorMessages.invalidParameterCountError(expected, actual: actual)
                } catch {
                errorText = CustomErrorMessages.unexpectedError
                }
            })
    #endif
    }


    func unregisterAuthenticationListener(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                var errorText: String = ""

                do {
                    let realm = try self.unpackRealm(command)
                    let mca = MCAAuthorizationManager.sharedInstance
                    mca.unregisterAuthenticationDelegate(realm)

                    defer {
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: errorText)
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    }
                } catch CustomErrors.InvalidParameterType(let expected, let actual) {
                    errorText = CustomErrorMessages.invalidParameterTypeError(expected: expected, actual: actual)
                } catch CustomErrors.InvalidParameterCount(let expected, let actual) {
                    errorText = CustomErrorMessages.invalidParameterCountError(expected, actual: actual)
                } catch {
                    errorText = CustomErrorMessages.unexpectedError
                }
            })
        #else
            self.commandDelegate!.runInBackground({
            var errorText: String = ""

            do {
                let realm = try self.unpackRealm(command)
                let mca = MCAAuthorizationManager.sharedInstance
                mca.unregisterAuthenticationDelegate(realm)

                defer {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: errorText)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            } catch CustomErrors.InvalidParameterType(let expected, let actual) {
                errorText = CustomErrorMessages.invalidParameterTypeError(expected, actual: actual)
            } catch CustomErrors.InvalidParameterCount(let expected, let actual) {
                errorText = CustomErrorMessages.invalidParameterCountError(expected, actual: actual)
            } catch {
                errorText = CustomErrorMessages.unexpectedError
            }
        })
        #endif
    }


    func addCallbackHandler(_ command: CDVInvokedUrlCommand) {

        #if swift(>=3.0)
        self.commandDelegate!.run(inBackground: {
            var errorText: String = ""

            do {
                let realm = try self.unpackRealm(command)
                CDVBMSClient.jsChallengeHandlers.setValue(command, forKey: realm)

                defer {
                    if (!errorText.isEmpty) {
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: errorText)
                        pluginResult?.setKeepCallbackAs(true)
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    }
                }

            } catch CustomErrors.InvalidParameterType(let expected, let actual) {
                errorText = CustomErrorMessages.invalidParameterTypeError(expected: expected, actual: actual)
            } catch CustomErrors.InvalidParameterCount(let expected, let actual) {
                errorText = CustomErrorMessages.invalidParameterCountError(expected, actual: actual)
            } catch {
                errorText = CustomErrorMessages.unexpectedError
            }
        })
            #else
            self.commandDelegate!.runInBackground({
                var errorText: String = ""

                do {
                    let realm = try self.unpackRealm(command)
                    CDVBMSClient.jsChallengeHandlers.setValue(command, forKey: realm)

                    defer {
                        if (!errorText.isEmpty) {
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorText)
                            pluginResult?.setKeepCallbackAsBool(true)
                            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                        }
                    }

                } catch CustomErrors.InvalidParameterType(let expected, let actual) {
                    errorText = CustomErrorMessages.invalidParameterTypeError(expected, actual: actual)
                } catch CustomErrors.InvalidParameterCount(let expected, let actual) {
                    errorText = CustomErrorMessages.invalidParameterCountError(expected, actual: actual)
                } catch {
                    errorText = CustomErrorMessages.unexpectedError
                }
            })
        #endif
    }
    #if swift(>=3.0)
        fileprivate func unpackRealm(_ command: CDVInvokedUrlCommand) throws -> String {
            if (command.arguments.count < 1) {
                throw CustomErrors.InvalidParameterCount(expected: 1, actual: 0)
            }

            guard let realm = command.argument(at: 0) as? String else {
                throw CustomErrors.InvalidParameterType(expected: "String", actual: command.argument(at: 0) as AnyObject)
            }
            return realm
        }
    #else
        private func unpackRealm(_ command: CDVInvokedUrlCommand) throws -> String {
                if (command.arguments.count < 1) {
                    throw CustomErrors.InvalidParameterCount(expected: 1, actual: 0)
                }

                guard let realm = command.argumentAtIndex(0) as? String else {
                        throw CustomErrors.InvalidParameterType(expected: "String", actual: command.argumentAtIndex(0) as AnyObject)
                }

                return realm
            }

    #endif

    internal class InternalAuthenticationDelegate : NSObject, AuthenticationDelegate {
        /**
         Called when authentication fails.
         - Parameter info - Extended data describing authentication failure.
         */
        public func onAuthenticationFailure(_ info: AnyObject?) {
            #if swift(>=3.0)
                self.handleAuthSuccessOrFailure(userInfo: info as! [NSObject : AnyObject], callbackName: "onAuthenticationFailure")
            #else
                self.handleAuthSuccessOrFailure(info as! [NSObject:AnyObject], callbackName: "onAuthenticationFailure")
            #endif
        }

        /**
         Called when authentication succeeded.
         - Parameter info - Extended data describing the authentication success.
         */
        public func onAuthenticationSuccess(_ info: AnyObject?) {
            #if swift(>=3.0)
                self.handleAuthSuccessOrFailure(userInfo: info as! [NSObject : AnyObject], callbackName: "onAuthenticationSuccess")
            #else
                self.handleAuthSuccessOrFailure(info as! [NSObject: AnyObject], callbackName: "onAuthenticationSuccess")
            #endif

        }

        /**
         Called when authentication challenge was received. The implementor should handle the challenge and call AuthenticationContext:submitAuthenticationChallengeAnswer(answer:[String:AnyObject]?)}
         with authentication challenge answer.

         - Parameter authContext  - Authentication context the answer should be sent to.
         - Parameter challenge - Information about authentication challenge.
         */
        public func onAuthenticationChallengeReceived(_ authContext: AuthenticationContext, challenge: AnyObject) {
            let command: CDVInvokedUrlCommand = jsChallengeHandlers[realm] as! CDVInvokedUrlCommand
            let jsonResponse: [NSString: AnyObject] = ["action": "onAuthenticationChallengeReceived" as AnyObject, "challenge": challenge as AnyObject];

            CDVBMSClient.authenticationContexts.setValue(authContext as? AnyObject, forKey: realm)

            #if swift(>=3.0)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: jsonResponse)
                pluginResult?.setKeepCallbackAs(true)
                commandDelegate.send(pluginResult, callbackId: command.callbackId)
            #else
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: jsonResponse)
                pluginResult?.setKeepCallbackAsBool(true)
                commandDelegate.sendPluginResult(pluginResult, callbackId: command.callbackId)
            #endif

        }

        var realm: String
        var commandDelegate: CDVCommandDelegate

        init(realm: String, commandDelegate: CDVCommandDelegate) {
            self.realm = realm
            self.commandDelegate = commandDelegate
        }

        private func handleAuthSuccessOrFailure(userInfo: [NSObject : AnyObject], callbackName: String) {
            let command: CDVInvokedUrlCommand = jsChallengeHandlers[realm] as! CDVInvokedUrlCommand
            let jsonResponse: [NSString: AnyObject] = ["action": callbackName as AnyObject, "info": userInfo as AnyObject];

            #if swift(>=3.0)
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: jsonResponse)
                pluginResult?.setKeepCallbackAs(true)
                commandDelegate.send(pluginResult, callbackId: command.callbackId)
            #else
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary:  jsonResponse)
                pluginResult?.setKeepCallbackAsBool(true)
                commandDelegate.sendPluginResult(pluginResult, callbackId: command.callbackId)
            #endif

        }
    }


}
