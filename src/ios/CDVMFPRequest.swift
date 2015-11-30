//
//  MFPResourceRequest.swift
//  HelloCordova
//
//  Created by Larry Nickerson on 9/15/15.
//
//

import Foundation
import IMFCore

@objc(CDVMFPRequest) class CDVMFPRequest : CDVPlugin {
    
    func send(command: CDVInvokedUrlCommand) {
        let nativeRequest = unPackRequest(command.arguments[0] as! NSDictionary)
        //dispatch_async(dispatch_get_main_queue()) {
            nativeRequest.sendWithCompletionHandler { (response: IMFResponse!, error: NSError!) -> Void in
                var responseString: String?
                do {
                    
                    if (error != nil) {
                        // process the error
                        try responseString = Utils.packResponse(response,error: error)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    } else {
                        // process success
                        try responseString = Utils.packResponse(response)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    }
                }
                catch {
                    responseString = "Error Parsing JSON response."
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: responseString)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            }
        //}
    }
    
    func unPackRequest(requestDict:NSDictionary) -> IMFResourceRequest {
        // create a native request
        let url     = requestDict.objectForKey("url") as! String
        let nativeRequest = IMFResourceRequest(path: url)
        
        // method
        let method  = requestDict.objectForKey("method") as? String
        nativeRequest.setHTTPMethod(method)
        
        // get the query parameters
        let requestQueryParamsDict = requestDict.objectForKey("queryParameters") as! Dictionary<String,String>
        nativeRequest.setParameters(requestQueryParamsDict)
        
        // timeout
        let timeout = (requestDict.objectForKey("timeout") as! Double) / Double(1000)
        nativeRequest.setTimeoutInterval(NSTimeInterval( timeout  ) )
        
        // process the body
        let canSendBody = method?.compare("GET", options: NSStringCompareOptions.CaseInsensitiveSearch) != NSComparisonResult.OrderedSame
        
        if (canSendBody) {
            if let body = requestDict.objectForKey("body") as? String {
                let bodyData = body.dataUsingEncoding(NSUTF8StringEncoding)
                nativeRequest.setHTTPBody(bodyData)
            }
        }
        
        // get the headers
        let requestHeaderDict = requestDict.objectForKey("headers") as! Dictionary<String,String>
        let requestHeaderNamesArray = Array(requestHeaderDict.keys)
        
        for name in requestHeaderNamesArray {
            nativeRequest.setValue(requestHeaderDict[ name ]!, forHTTPHeaderField: name)
        }
        return nativeRequest
    }
}
