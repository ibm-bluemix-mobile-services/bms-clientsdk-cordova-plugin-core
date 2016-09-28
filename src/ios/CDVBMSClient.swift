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

    static var jsChallengeHandlers:NSMutableDictionary = [:]
    static var authenticationContexts:NSMutableDictionary = [:]

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

  /*  internal class InternalAuthenticationDelegate : NSObject, AuthenticationDelegate {

        var realm: String
        var commandDelegate: CDVCommandDelegate

        init(realm: String, commandDelegate: CDVCommandDelegate) {
            self.realm = realm
            self.commandDelegate = commandDelegate
        }

        /**
         * Called when authentication challenge was received
         @param context Authentication context
         @param challenge Dictionary with challenge data
         */
        @objc @available(iOS 2.0, *)
        internal func authenticationContext(context: AuthenticationContext!, didReceiveAuthenticationChallenge challenge: [NSObject : AnyObject]!) {

            let command: CDVInvokedUrlCommand = jsChallengeHandlers[realm] as! CDVInvokedUrlCommand
            let jsonResponse: [NSString: AnyObject] = ["action": "onAuthenticationChallengeReceived" as AnyObject, "challenge": challenge as AnyObject];

            CDVBMSClient.authenticationContexts.setValue(context, forKey: realm)

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

        /**
         * Called when authentication succeeded
         @param context Authentication context
         @param userInfo Dictionary with extended data about authentication success
         */
        @objc @available(iOS 2.0, *)
        internal func authenticationContext(context: AuthenticationContext!, didReceiveAuthenticationSuccess userInfo: [NSObject : AnyObject]!) {

            #if swift(>=3.0)
                self.handleAuthSuccessOrFailure(userInfo: userInfo, callbackName: "onAuthenticationSuccess")
            #else
                self.handleAuthSuccessOrFailure(userInfo, callbackName: "onAuthenticationSuccess")
            #endif

        }

        /**
         * Called when authentication failed.
         @param context Authentication context
         @param userInfo Dictionary with extended data about authentication failure
         */
        @objc @available(iOS 2.0, *)
        internal func authenticationContext(context: AuthenticationContext!, didReceiveAuthenticationFailure userInfo: [NSObject : AnyObject]!) {
            #if swift(>=3.0)
                self.handleAuthSuccessOrFailure(userInfo: userInfo, callbackName: "onAuthenticationFailure")
            #else
                self.handleAuthSuccessOrFailure(userInfo, callbackName: "onAuthenticationFailure")
            #endif

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

    */
}