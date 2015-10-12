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
    
    func initialize(command: CDVInvokedUrlCommand) {
        
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
        
        self.commandDelegate!.runInBackground({
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
}