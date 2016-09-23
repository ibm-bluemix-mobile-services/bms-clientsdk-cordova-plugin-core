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

class CDVBMSRequest : CDVPlugin {
    
    func send(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let requestDict = command.arguments[0] as! NSDictionary
            var bodyData : Data? = nil

            let nativeRequest = self.unPackRequest(requestDict: requestDict)

            if let body = requestDict.object(forKey: "body") as? String {
                bodyData = body.data(using: String.Encoding.utf8)
            }

            nativeRequest.send(requestBody: bodyData, completionHandler: { (response: Response?, error:Error?) in
                var responseString: String?
                do {

                    if (error != nil) {
                        // process the error
                        try responseString = self.packResponse(response: response,error: error)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: responseString)
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    } else {
                        // process success
                        try responseString = self.packResponse(response: response)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: responseString)
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    }
                } catch {
                    responseString = "Error Parsing JSON response."
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: responseString)
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                }
            })

        })
    }

    private func unPackRequest(requestDict:NSDictionary) -> BaseRequest {
        // create a native request
        var url     = requestDict.object(forKey: "url") as! String

        // Detect if url is relative and convert to absolute
        if((url ?? "").isEmpty == false && url[url.startIndex] == "/") {
            url = convertRelativeURLToBluemixAbsolute(url: url)
        }

        // method
        let methodString = requestDict.object(forKey: "method") as? String
        var method : HttpMethod = HttpMethod.GET;
        switch(methodString){
            case "GET"?:
                method = HttpMethod.GET
                break
            case "POST"?:
                method = HttpMethod.POST
                break
            case "PUT"?:
                method = HttpMethod.PUT
                break
            case "DELETE"?:
                method = HttpMethod.DELETE
                break
            case "TRACE"?:
                method = HttpMethod.TRACE
                break
            case "HEAD"?:
                method = HttpMethod.HEAD
                break
            case "OPTIONS"?:
                method = HttpMethod.OPTIONS
                break
            case "CONNECT"?:
                method = HttpMethod.CONNECT
                break
            case "PATCH"?:
                method = HttpMethod.PATCH
                break
            default:
                method = HttpMethod.GET
        }

        // get the query parameters
        let requestQueryParamsDict = requestDict.object(forKey: "queryParameters") as! Dictionary<String,String>

        // timeout
        let timeout = (requestDict.object(forKey: "timeout") as! Double) / Double(1000)

        // get the headers
        let requestHeaderDict = requestDict.object(forKey: "headers") as! Dictionary<String,String>

        let nativeRequest = BaseRequest(url: url, method: method, headers: requestHeaderDict, queryParameters: requestQueryParamsDict, timeout: timeout)
        return nativeRequest
    }

    func packResponse(response: Response!,error:Error?=nil) throws -> String {
        let jsonResponse:NSMutableDictionary = [:]
        var responseString: NSString = ""

        if error != nil {
            jsonResponse.setObject((error!.localizedDescription), forKey: "errorDescription" as NSCopying)
          // TODO: Need to find out if userInfo is needed jsonResponse.setObject((error!.userInfo), forKey: "userInfo")
        }
        else {
            jsonResponse.setObject(Int((0)), forKey: "errorCode" as NSCopying)
            jsonResponse.setObject("", forKey: "errorDescription" as NSCopying)
        }

        if (response == nil)
        {
            jsonResponse.setObject("", forKey: "responseText" as NSCopying)
            jsonResponse.setObject([], forKey:"headers" as NSCopying)
            jsonResponse.setObject(Int(0), forKey:"status" as NSCopying)
        }
        else {
            let responseText: String = (response.responseText != nil)    ? response.responseText! : ""
            jsonResponse.setObject(responseText, forKey: "responseText" as NSCopying)

            if response.headers != nil {
                jsonResponse.setObject(response.headers, forKey:"headers" as NSCopying)
            }
            else {
                jsonResponse.setObject([], forKey:"headers" as NSCopying)
            }

            jsonResponse.setObject(response.statusCode, forKey:"status" as NSCopying)
        }

        responseString = try self.stringifyResponse(value: jsonResponse) as NSString;
        return responseString as String
    }

    func stringifyResponse(value: AnyObject,prettyPrinted:Bool = false) throws -> String {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        var jsonString : String? = ""

        if JSONSerialization.isValidJSONObject(value) {
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        }
        return jsonString!
    }

    func convertRelativeURLToBluemixAbsolute(url:String) -> String {
        let client = BMSClient.sharedInstance
        let bluemixAppRoute: String = client.bluemixAppRoute!

        //do Trim first
        var appRoute = bluemixAppRoute.trimmingCharacters(in: CharacterSet.whitespaces)

        // Remove trailing slashes
        if(appRoute.characters.last! == "/") {
            appRoute = appRoute.substring(to: appRoute.endIndex)
        }
        appRoute = appRoute + url
        
        return appRoute
    }
}
