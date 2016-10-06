/*
    Copyright 2016 IBM Corp.
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

@objc(CDVBMSRequest) class CDVBMSRequest : CDVPlugin {

    func send(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
        self.commandDelegate!.run(inBackground: {
            let requestDict = command.arguments[0] as! NSDictionary
            var bodyData : Data? = nil

            let nativeRequest = self.unPackRequest(requestDict)

            if let body = requestDict.object(forKey: "body") as? String {
                bodyData = body.data(using: String.Encoding.utf8)
            }

            nativeRequest.send(requestBody: bodyData, completionHandler: { (response: Response?, error:Error?) in
                var responseString: String?
                do {

                    if (error != nil) {
                        // process the error
                        try responseString = self.packResponse(response,error: error)
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: responseString)
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    } else {
                        // process success
                        try responseString = self.packResponse(response)
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

        #else
            self.commandDelegate!.runInBackground({
                let requestDict = command.arguments[0] as! NSDictionary
                var bodyData : NSData? = nil

                let nativeRequest = self.unPackRequest(requestDict)

                if let body = requestDict.objectForKey("body") as? String {
                    bodyData = body.dataUsingEncoding(NSUTF8StringEncoding)
                }

                nativeRequest.send(requestBody: bodyData, completionHandler: { (response: Response?, error:NSError?) in
                    var responseString: String?
                    do {

                        if (error != nil) {
                            // process the error
                            try responseString = self.packResponse(response,error: error)
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString:responseString)
                            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                        } else {
                            // process success
                            try responseString = self.packResponse(response)
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: responseString)
                            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                        }
                    } catch {
                        responseString = "Error Parsing JSON response."
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: responseString)
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    }
                })

            })
        #endif
    }

    #if swift(>=3.0)
        fileprivate func unPackRequest(_ requestDict:NSDictionary) -> Request {
            // create a native request
            var url     = requestDict.object(forKey: "url") as! String

            // Detect if url is relative and convert to absolute
            if((url ?? "").isEmpty == false && url[url.startIndex] == "/") {
                url = convertRelativeURLToBluemixAbsolute(url)

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

            let nativeRequest = Request(url: url, method: method, headers: requestHeaderDict, queryParameters: requestQueryParamsDict, timeout: timeout)
            return nativeRequest
        }
    #else
        private func unPackRequest(requestDict:NSDictionary) -> Request {
                // create a native request
                var url     = requestDict.objectForKey("url") as! String

                // Detect if url is relative and convert to absolute
                if((url ?? "").isEmpty == false && url[url.startIndex] == "/") {
                    url = convertRelativeURLToBluemixAbsolute(url)
                }

                // method
                let methodString = requestDict.objectForKey("method") as? String
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
                let requestQueryParamsDict = requestDict.objectForKey("queryParameters") as! Dictionary<String,String>

                // timeout
                let timeout = (requestDict.objectForKey("timeout") as! Double) / Double(1000)

                // get the headers
                let requestHeaderDict = requestDict.objectForKey("headers") as! Dictionary<String,String>
                let nativeRequest = Request(url: url, method: method, headers: requestHeaderDict, queryParameters: requestQueryParamsDict, timeout: timeout)
                return nativeRequest
            }

    #endif

    #if swift(>=3.0)
    func packResponse(_ response: Response!,error:Error?=nil) throws -> String {
        var jsonResponse:[String: Any] = [:]
        var responseString: String = ""

        if error != nil {
            jsonResponse["errorDescription"] = error!.localizedDescription
        }
        else {
            jsonResponse["errorCode"] = 0
            jsonResponse["errorDescription"] = ""
        }

        if (response == nil)
        {
            jsonResponse["responseText"] = ""
            jsonResponse["headers"] = []
            jsonResponse["status"] = 0
        }
        else {
            let responseText: String = (response.responseText != nil)    ? response.responseText! : ""
            jsonResponse["responseText"] = responseText


            if response.headers != nil {
                jsonResponse["headers"] = response.headers as! [String:Any]
            }
            else {
                jsonResponse["headers"] = [:]
            }

            jsonResponse["status"] = response.statusCode
        }

        let responseData = try JSONSerialization.data(withJSONObject: jsonResponse, options: [])

        responseString =  String(data: responseData, encoding: .utf8)!//try self.stringifyResponse(jsonResponse) as NSString;
        return responseString as String
    }
    #else
    func packResponse(response: Response!,error:NSError?=nil) throws -> String {
        let jsonResponse:NSMutableDictionary = [:]
        var responseString: NSString = ""

        if error != nil {
            jsonResponse.setObject((error!.localizedDescription), forKey: "errorDescription" as NSCopying)
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
                jsonResponse.setObject(response.headers!, forKey:"headers" as NSCopying)
            }
            else {
                jsonResponse.setObject([], forKey:"headers" as NSCopying)
            }

            jsonResponse.setObject(response.statusCode!, forKey:"status" as NSCopying)
        }

        responseString = try self.stringifyResponse(jsonResponse) as NSString;
        return responseString as String
    }

    #endif

    func stringifyResponse(_ value: AnyObject,prettyPrinted:Bool = false) throws -> String {
        #if swift(>=3.0)
            let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
            var jsonString : String? = ""
        #else
            let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
            var jsonString : String? = ""
        #endif

        #if swift(>=3.0)
            if JSONSerialization.isValidJSONObject(value) {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            }
        #else
            if NSJSONSerialization.isValidJSONObject(value) {
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
            }
        #endif
        return jsonString!
    }

    func convertRelativeURLToBluemixAbsolute(_ url:String) -> String {
        let client = BMSClient.sharedInstance
        let bluemixAppRoute: String = client.bluemixAppRoute!

        //do Trim first
        #if swift(>=3.0)
            var appRoute = bluemixAppRoute.trimmingCharacters(in: CharacterSet.whitespaces)
        #else
            var appRoute = bluemixAppRoute.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        #endif

        // Remove trailing slashes
        #if swift(>=3.0)
            if(appRoute.characters.last! == "/") {
                appRoute = appRoute.substring(to: appRoute.endIndex)
            }
        #else
            if(appRoute.characters.last! == "/") {
                appRoute = appRoute.substringToIndex(appRoute.endIndex.predecessor())
            }
        #endif
        appRoute = appRoute + url

        return appRoute
    }
}
