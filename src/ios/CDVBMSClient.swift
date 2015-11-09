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
            let message = "Invalid route."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let guid = command.arguments[1] as? String else{
            let message = "Invalid guid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
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
            }
            else{
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: exceptionString)
                // call failure callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
        })
    }
    
    func backendRoute(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({

            let client = IMFClient.sharedInstance()
            let backendRoute: String = client.backendRoute
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: backendRoute)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func backendGUID(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({

            let client = IMFClient.sharedInstance()
            let backendGUID: String = client.backendGUID
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: backendGUID)
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
        
    }
    
    func registerAuthenticationListener(command: CDVInvokedUrlCommand) {
        
        func unpackParams() throws -> String {
            return command.argumentAtIndex(0) as! String
        }
        
        self.commandDelegate!.runInBackground({
            do {
                let realm = try unpackParams();
                let client = IMFClient.sharedInstance()
                let delegate = InternalAuthenticationDelegate(realm: realm, commandDelegate: self.commandDelegate!)
                
                client.registerAuthenticationDelegate(delegate, forRealm: realm)
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            } catch {
                
            }
        })
    }
    
    func unregisterAuthenticationListener(command: CDVInvokedUrlCommand) {
        
    }
    
    func addCallbackHandler(command: CDVInvokedUrlCommand) {
        func unpackParams() throws -> String {
            return command.argumentAtIndex(0) as! String
        }
        
        do {
            let realm = try unpackParams()
            CDVBMSClient.jsChallengeHandlers.setValue(command, forKey: realm)
        } catch {
            
        }
        
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
        pluginResult.setKeepCallbackAsBool(true)
        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        
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
            
            let jsonResponse: NSMutableDictionary = [:]
            jsonResponse.setObject("onAuthenticationChallengeReceived", forKey: "action")
            jsonResponse.setObject(challenge, forKey: "challenge")
            CDVBMSClient.authenticationContexts.setValue(context, forKey: realm)
           
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: jsonResponse as [NSObject : AnyObject])
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
            
        }
        
        /**
         * Called when authentication failed.
         @param context Authentication context
         @param userInfo Dictionary with extended data about authentication failure
         */
        @objc @available(iOS 2.0, *)
        internal func authenticationContext(context: IMFAuthenticationContext!, didReceiveAuthenticationFailure userInfo: [NSObject : AnyObject]!) {
            
        }
        
        func stringifyResponse(value: AnyObject,prettyPrinted:Bool = false) -> String {
            let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
            var jsonString : String? = ""
            
            do {
                if NSJSONSerialization.isValidJSONObject(value) {
                    let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                    jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
                }
            } catch {
                
            }
            return jsonString!
        }
    }
}