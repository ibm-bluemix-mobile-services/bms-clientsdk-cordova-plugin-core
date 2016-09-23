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

class CDVBMSClient : CDVPlugin {

    static var jsChallengeHandlers:NSMutableDictionary = [:]
    static var authenticationContexts:NSMutableDictionary = [:]

    func initialize(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.run(inBackground: {

            guard let region  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: CustomErrorMessages.invalidRoute)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }

            let client = BMSClient.sharedInstance;

            //use category to handle objective-c exception
            client.initialize(bluemixAppRoute: region)


            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)

        })
    }

    func getBluemixAppRoute(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.run(inBackground: {

            let client = BMSClient.sharedInstance
            let backendRoute: String = client.bluemixAppRoute!
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: backendRoute)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })
    }

    func getBluemixAppGUID(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.run(inBackground: {

            let client = BMSClient.sharedInstance
            let backendGUID: String = client.bluemixAppGUID!
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: backendGUID)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
        })

    }

    func addCallbackHandler(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.run(inBackground: {
            var errorText: String = ""

            do {
                let realm = try self.unpackRealm(command: command)
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
                errorText = CustomErrorMessages.invalidParameterCountError(expected: expected, actual: actual)
            } catch {
                errorText = CustomErrorMessages.unexpectedError
            }
        })
    }

    private func unpackRealm(command: CDVInvokedUrlCommand) throws -> String {
        if (command.arguments.count < 1) {
            throw CustomErrors.InvalidParameterCount(expected: 1, actual: 0)
        }

        guard let realm = command.argument(at: 0) as? String else {
            throw CustomErrors.InvalidParameterType(expected: "String", actual: command.argument(at: 0) as AnyObject)
        }

        return realm
    }

    internal class InternalAuthenticationDelegate : NSObject, AuthenticationDelegate {

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

            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: jsonResponse)
            pluginResult?.setKeepCallbackAs(true)
            commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }

        /**
         * Called when authentication succeeded
         @param context Authentication context
         @param userInfo Dictionary with extended data about authentication success
         */
        @objc @available(iOS 2.0, *)
        internal func authenticationContext(context: AuthenticationContext!, didReceiveAuthenticationSuccess userInfo: [NSObject : AnyObject]!) {
            self.handleAuthSuccessOrFailure(userInfo: userInfo, callbackName: "onAuthenticationSuccess")
        }

        /**
         * Called when authentication failed.
         @param context Authentication context
         @param userInfo Dictionary with extended data about authentication failure
         */
        @objc @available(iOS 2.0, *)
        internal func authenticationContext(context: AuthenticationContext!, didReceiveAuthenticationFailure userInfo: [NSObject : AnyObject]!) {
            self.handleAuthSuccessOrFailure(userInfo: userInfo, callbackName: "onAuthenticationFailure")
        }

        private func handleAuthSuccessOrFailure(userInfo: [NSObject : AnyObject], callbackName: String) {
            let command: CDVInvokedUrlCommand = jsChallengeHandlers[realm] as! CDVInvokedUrlCommand
            let jsonResponse: [NSString: AnyObject] = ["action": callbackName as AnyObject, "info": userInfo as AnyObject];

            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: jsonResponse)
            pluginResult?.setKeepCallbackAs(true)
            commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }
}