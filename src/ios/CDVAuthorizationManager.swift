//
//  File.swift
//  HelloCordova
//
//  Created by Vitaly Meytin on 10/21/15.
//
//

import Foundation
import IMFCore

enum PersistencePolicy: String {
    case PersistencePolicyAlways = "ALWAYS"
    case PersistencePolicyNever = "NEVER"
}

@objc(CDVAuthorizationManager) class CDVAuthorizationManager : CDVPlugin {
    
    func obtainAuthorizationHeader(command: CDVInvokedUrlCommand) {
        let authManager = IMFAuthorizationManager.sharedInstance();
        
        self.commandDelegate!.runInBackground({
        
            authManager.obtainAuthorizationHeaderWithCompletionHandler { (response: IMFResponse!, error: NSError!) -> Void in
                var responseString: String?
                
                do {
                    if (error != nil) {
                        // process the error
                        try responseString = self.packResponse(response, error: error)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    } else {
                        // process success
                        try responseString = self.packResponse(response)
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
        
        self.commandDelegate!.runInBackground({
            
            do {
                let authManager = IMFAuthorizationManager.sharedInstance()
                let params = try self.unpackIsAuthorizationRequiredParams(command);
                
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool:authManager.isAuthorizationRequired(params.statusCode, authorizationHeaderValue: params.authorizationHeaderValue))
                
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            } catch {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid parameters passed to isAuthorizationRequired method")
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
        })
    }
    
    func clearAuthorizationData(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let authManager = IMFAuthorizationManager.sharedInstance()
            authManager.clearAuthorizationData()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getCachedAuthorizationHeader(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let authManager = IMFAuthorizationManager.sharedInstance()
            
            if let authHeader: String = authManager.cachedAuthorizationHeader {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:authHeader)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            } else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.noCachedAuthorizationHeader)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
        })
    }
    
    func getUserIdentity(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let authManager = IMFAuthorizationManager.sharedInstance()
            var pluginResult: CDVPluginResult? = nil
    
            do {
                let userIdentity: String = try self.stringifyResponse(authManager.userIdentity)
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:userIdentity)
            } catch {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.errorObtainUserIdentity)
            }
            
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getAppIdentity(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let authManager = IMFAuthorizationManager.sharedInstance()
            var pluginResult: CDVPluginResult? = nil
            
            do {
                let appIdentity: String = try self.stringifyResponse(authManager.appIdentity)
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:appIdentity)
            } catch {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.errorObtainAppIdentity)
            }
            
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getDeviceIdentity(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let authManager = IMFAuthorizationManager.sharedInstance()
            var pluginResult: CDVPluginResult? = nil
            
            do {
                let deviceIdentity: String = try self.stringifyResponse(authManager.deviceIdentity)
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:deviceIdentity)
            } catch {
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.errorObtainDeviceIdentity)
            }
            
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func getAuthorizationPersistencePolicy(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let authManager = IMFAuthorizationManager.sharedInstance()
            let policy: IMFAuthorizationPerisistencePolicy = authManager.getAuthorizationPersistensePolicy()
            var pluginResult: CDVPluginResult? = nil
            
            switch policy {
            case IMFAuthorizationPerisistencePolicy.Always:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:PersistencePolicy.PersistencePolicyAlways.rawValue)
            case IMFAuthorizationPerisistencePolicy.Never:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:PersistencePolicy.PersistencePolicyNever.rawValue)
            default:
                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.invalidPolicyType)
            }
            
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func setAuthorizationPersistencePolicy(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let authManager = IMFAuthorizationManager.sharedInstance()
            guard let policy: String = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:CustomErrorMessages.invalidPolicySpecified)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            
            switch policy {
            case PersistencePolicy.PersistencePolicyAlways.rawValue:
                authManager.setAuthorizationPersistencePolicy(IMFAuthorizationPerisistencePolicy.Always)
            case PersistencePolicy.PersistencePolicyNever.rawValue:
                authManager.setAuthorizationPersistencePolicy(IMFAuthorizationPerisistencePolicy.Never)
            default:
                authManager.setAuthorizationPersistencePolicy(IMFAuthorizationPerisistencePolicy.Never)
            }
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    
    func unpackIsAuthorizationRequiredParams(command: CDVInvokedUrlCommand) throws -> (statusCode: Int32, authorizationHeaderValue: String) {
        if (command.arguments.count < 2) {
            throw CustomErrors.InvalidParameterCount(expected: 2, actual: command.arguments.count)
        }
        
        guard let param0 = command.argumentAtIndex(0) as? NSNumber else {
            throw CustomErrors.InvalidParameterType(expected: "NSNumber", actual: command.argumentAtIndex(1))
        }
        
        guard let param1: NSString = command.argumentAtIndex(1) as? NSString else {
            throw CustomErrors.InvalidParameterType(expected: "String", actual: command.argumentAtIndex(1))
        }
        
        return (statusCode: param0.intValue, authorizationHeaderValue: param1 as String)
    }
    
    func packResponse(response: IMFResponse!,error:NSError?=nil) throws -> String {
        var jsonResponse = [String:AnyObject]()
        var responseString: NSString = ""
        
        if error != nil {
            jsonResponse["errorCode"] = Int((error!.code))
            jsonResponse["errorDescription"] = (error!.localizedDescription)
            
            if let userInfo = error?.userInfo {
                var validUserInfo = [String:AnyObject]()
                for (key, value) in userInfo {
                    if let k = key as? String  {
                        var actualValue = value
                        if let url = value as? NSURL {
                            actualValue = url.absoluteString
                        }
                        let tempValue:[String:AnyObject] = [key as! String: actualValue]
                        
                        if NSJSONSerialization.isValidJSONObject(tempValue) {
                            validUserInfo[k] = actualValue
                        }
                    }
                }
                
                jsonResponse["userInfo"] = validUserInfo
            }
        }
        else {
            jsonResponse["errorCode"] = Int((0))
            jsonResponse["errorDescription"] = ""
        }
        
        if (response == nil) {
            jsonResponse["responseText"] = ""
            jsonResponse["headers"] = []
            jsonResponse["status"] = Int((0))
            
        } else {
            let responseText: String = (response.responseText != nil)    ? response.responseText : ""
            jsonResponse["responseText"] = responseText
            
            
            if response.responseHeaders != nil {
                jsonResponse["headers"] = response.responseHeaders
            }
            else {
                jsonResponse["headers"] = []
            }
            
            jsonResponse["status"] = Int(response.httpStatus)
        }
        
        responseString = try self.stringifyResponse(jsonResponse);
        return responseString as String
    }
    
    func stringifyResponse(value: AnyObject,prettyPrinted:Bool = false) throws -> String {
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        var jsonString : String? = ""
        
        if NSJSONSerialization.isValidJSONObject(value) {
            let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
            jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
        }
        return jsonString!
    }
    
}