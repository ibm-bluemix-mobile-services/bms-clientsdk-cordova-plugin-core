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
    
    func obtainAuthorizationHeader(command: CDVInvokedUrlCommand) {
        let authManager = IMFAuthorizationManager.sharedInstance();
        
        authManager.obtainAuthorizationHeaderWithCompletionHandler { (response: IMFResponse!, error: NSError!) -> Void in
            var responseString: String?
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: responseString)
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        }
        
    }
    
}