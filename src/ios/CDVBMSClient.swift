//
//  MFPClient.swift
//  HelloCordova
//
//  Created by Larry Nickerson on 9/15/15.
//
//
import Foundation
import IMFCore

@objc(CDVBMSClient) class CDVBMSClient : CDVPlugin {
    
    static var jsChallengeHandlers:NSMutableDictionary = [:]
    static var authenticationContexts:NSMutableDictionary = [:]
    
    func initialize(command: CDVInvokedUrlCommand) {

        self.commandDelegate!.runInBackground({

            guard let route  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.invalidRoute)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            
            guard let guid = command.arguments[1] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.invalidGuid)
                // call failure callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }

            let client = IMFClient.sharedInstance()
            
            //use category to handle objective-c exception
            let exceptionString = client.tryInitializeWithBackendRoute(route, backendGUID: guid)
            
            if exceptionString  == "" {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "")
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            } else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: exceptionString)
                // call failure callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
        })
    }
    
    func getBluemixAppRoute(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({

            let client = IMFClient.sharedInstance()
            let backendRoute: String = client.backendRoute
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: backendRoute)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getBluemixAppGUID(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({

            let client = IMFClient.sharedInstance()
            let backendGUID: String = client.backendGUID
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: backendGUID)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
        
    }
    
    func registerAuthenticationListener(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            var errorText: String = ""
            
            do {
                let realm = try self.unpackRealm(command);
                let client = IMFClient.sharedInstance()
                let delegate = InternalAuthenticationDelegate(realm: realm, commandDelegate: self.commandDelegate!)
                
                client.registerAuthenticationDelegate(delegate, forRealm: realm)
                
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
    }
    
    func unregisterAuthenticationListener(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            var errorText: String = ""
            
            do {
                let realm = try self.unpackRealm(command)
                let client = IMFClient.sharedInstance()
                client.unregisterAuthenticationDelegateForRealm(realm)
                
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
    }
    
    func addCallbackHandler(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            var errorText: String = ""
            
            do {
                let realm = try self.unpackRealm(command)
                CDVBMSClient.jsChallengeHandlers.setValue(command, forKey: realm)
                
                defer {
                    if (!errorText.isEmpty) {
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorText)
                        pluginResult.setKeepCallbackAsBool(true)
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
    }
    
    private func unpackRealm(command: CDVInvokedUrlCommand) throws -> String {
        if (command.arguments.count < 1) {
            throw CustomErrors.InvalidParameterCount(expected: 1, actual: 0)
        }
        
        guard let realm = command.argumentAtIndex(0) as? String else {
            throw CustomErrors.InvalidParameterType(expected: "String", actual: command.argumentAtIndex(0))
        }
        
        return realm
    }
    
    internal class InternalAuthenticationDelegate : NSObject, IMFAuthenticationDelegate {
        
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
        internal func authenticationContext(context: IMFAuthenticationContext!, didReceiveAuthenticationChallenge challenge: [NSObject : AnyObject]!) {
            
            let command: CDVInvokedUrlCommand = jsChallengeHandlers[realm] as! CDVInvokedUrlCommand
            let jsonResponse: [NSString: AnyObject] = ["action": "onAuthenticationChallengeReceived", "challenge": challenge];
            
            CDVBMSClient.authenticationContexts.setValue(context, forKey: realm)
           
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: jsonResponse)
            pluginResult.setKeepCallbackAsBool(true)
            commandDelegate.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
        
        /**
         * Called when authentication succeeded
         @param context Authentication context
         @param userInfo Dictionary with extended data about authentication success
         */
        @objc @available(iOS 2.0, *)
        internal func authenticationContext(context: IMFAuthenticationContext!, didReceiveAuthenticationSuccess userInfo: [NSObject : AnyObject]!) {
            self.handleAuthSuccessOrFailure(userInfo, callbackName: "onAuthenticationSuccess")
        }
        
        /**
         * Called when authentication failed.
         @param context Authentication context
         @param userInfo Dictionary with extended data about authentication failure
         */
        @objc @available(iOS 2.0, *)
        internal func authenticationContext(context: IMFAuthenticationContext!, didReceiveAuthenticationFailure userInfo: [NSObject : AnyObject]!) {
            self.handleAuthSuccessOrFailure(userInfo, callbackName: "onAuthenticationFailure")
        }
        
        private func handleAuthSuccessOrFailure(userInfo: [NSObject : AnyObject], callbackName: String) {
            let command: CDVInvokedUrlCommand = jsChallengeHandlers[realm] as! CDVInvokedUrlCommand
            let jsonResponse: [NSString: AnyObject] = ["action": callbackName, "info": userInfo];
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: jsonResponse)
            pluginResult.setKeepCallbackAsBool(true)
            commandDelegate.sendPluginResult(pluginResult, callbackId: command.callbackId)
        }
    }
}