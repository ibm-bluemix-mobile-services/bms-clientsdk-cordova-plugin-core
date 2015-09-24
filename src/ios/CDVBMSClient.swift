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
        let route = command.arguments[0] as! String
        let guid = command.arguments[1] as! String
        let client = IMFClient.sharedInstance()
        
        //use category to handle objective-c exception
        client.tryInitializeWithBackendRoute(route, backendGUID: guid, iMFClient:client)
        
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "")
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    
    func backendRoute(command: CDVInvokedUrlCommand) {
        let client = IMFClient.sharedInstance()
        let backendRoute: String = client.backendRoute
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: backendRoute)
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
    
    func backendGUID(command: CDVInvokedUrlCommand) {
        let client = IMFClient.sharedInstance()
        let backendGUID: String = client.backendGUID
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: backendGUID)
        commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
    }
}