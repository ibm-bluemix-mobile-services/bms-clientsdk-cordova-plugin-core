//
//  File.swift
//  HelloCordova
//
//  Created by Vitaly Meytin on 10/21/15.
//
//

import Foundation
import IMFCore

@objc(CDVAuthorizationManager) class CDVAuthorizationManager : CDVPlugin {
    
    enum CDVAuthManagerErrors : ErrorType {
        case InvalidParameterCount
        case InvalidParameterType
    }
    
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
                
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: responseString)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                } catch {
                    responseString = "Error Parsing JSON response."
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: responseString)
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
            //let authManager = IMFAuthorizationManager.sharedInstance()
            
            //authManager.cl
        })
    }
    
    func getCachedAuthorizationHeader(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let authManager = IMFAuthorizationManager.sharedInstance()
            
            if let authHeader: String = authManager.cachedAuthorizationHeader {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString:authHeader)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            } else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "There is no cached authorization header.")
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
        })
    }
    
    func unpackIsAuthorizationRequiredParams(command: CDVInvokedUrlCommand) throws -> (statusCode: Int32, authorizationHeaderValue: String) {
        if (command.arguments.count < 2) {
            throw CDVAuthManagerErrors.InvalidParameterCount
        }
        
        let param0 = command.argumentAtIndex(0)
        let param1 = command.argumentAtIndex(1)
        
        if !(param0 is NSNumber) || !(param1 is NSString) {
            throw CDVAuthManagerErrors.InvalidParameterType
        }
        
        let statusValue: NSNumber = param0 as! NSNumber
        let authHeader: String = String(param1)
        
        return (statusCode: statusValue.intValue, authorizationHeaderValue: authHeader)
    }
    
    func packResponse(response: IMFResponse!,error:NSError?=nil) throws -> String {
        let jsonResponse:NSMutableDictionary = [:]
        var responseString: NSString = ""
        
        if error != nil {
            jsonResponse.setObject(Int((error!.code)), forKey: "errorCode")
            jsonResponse.setObject((error!.localizedDescription), forKey: "errorDescription")
        }
        else {
            jsonResponse.setObject(Int((0)), forKey: "errorCode")
            jsonResponse.setObject("", forKey: "errorDescription")
        }
        
        if (response == nil)
        {
            jsonResponse.setObject("", forKey: "responseText")
            jsonResponse.setObject([], forKey:"headers")
            jsonResponse.setObject(Int(0), forKey:"status")
        }
        else {
            let responseText: String = (response.responseText != nil)    ? response.responseText : ""
            jsonResponse.setObject(responseText, forKey: "responseText")
            
            if response.responseHeaders != nil {
                jsonResponse.setObject(response.responseHeaders, forKey:"headers")
            }
            else {
                jsonResponse.setObject([], forKey:"headers")
            }
            
            jsonResponse.setObject(Int(response.httpStatus), forKey:"status")
            responseString = try self.stringifyResponse(jsonResponse);
        }
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