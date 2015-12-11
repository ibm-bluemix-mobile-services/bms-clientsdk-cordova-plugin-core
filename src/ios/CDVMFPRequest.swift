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
        self.commandDelegate!.runInBackground({
            let nativeRequest = self.unPackRequest(command.arguments[0] as! NSDictionary)
            
            nativeRequest.sendWithCompletionHandler { (response: IMFResponse!, error: NSError!) -> Void in
                var responseString: String?
                do {
                    
                    if (error != nil) {
                        // process the error
                        try responseString = self.packResponse(response,error: error)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    } else {
                        // process success
                        try responseString = self.packResponse(response)
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
        })
    }
    
    private func unPackRequest(requestDict:NSDictionary) -> IMFResourceRequest {
        // create a native request
        var url     = requestDict.objectForKey("url") as! String

        // Detect if url is relative and convert to absolute
        if((url ?? "").isEmpty == false && url[url.startIndex] == "/") {
            url = convertRelativeURLToBluemixAbsolute(url)
        }

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
        if let body = requestDict.objectForKey("body") as? String {
            let bodyData = body.dataUsingEncoding(NSUTF8StringEncoding)
            nativeRequest.setHTTPBody(bodyData)
        }
        
        // get the headers
        let requestHeaderDict = requestDict.objectForKey("headers") as! Dictionary<String,String>
        let requestHeaderNamesArray = Array(requestHeaderDict.keys)
        
        for name in requestHeaderNamesArray {
            nativeRequest.setValue(requestHeaderDict[ name ]!, forHTTPHeaderField: name)
        }
        return nativeRequest
    }
    
    func packResponse(response: IMFResponse!,error:NSError?=nil) throws -> String {
        let jsonResponse:NSMutableDictionary = [:]
        var responseString: NSString = ""
        
        if error != nil {
            jsonResponse.setObject(Int((error!.code)), forKey: "errorCode")
            jsonResponse.setObject((error!.localizedDescription), forKey: "errorDescription")
            jsonResponse.setObject((error!.userInfo), forKey: "userInfo")
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

    func convertRelativeURLToBluemixAbsolute(url:String) -> String {
        let client = IMFClient.sharedInstance()
        let backendRoute: String = client.backendRoute
        
        //do Trim first
        var appRoute = backendRoute.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());

        // Remove trailing slashes
        if(appRoute.characters.last! == "/") {
            appRoute = appRoute.substringToIndex(appRoute.endIndex.predecessor())
        }
        appRoute = appRoute + url
        
        return appRoute
    }
}
