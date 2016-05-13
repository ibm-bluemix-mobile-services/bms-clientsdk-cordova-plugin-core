/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/

import Foundation
import BMSCore
import BMSAnalyticsAPI
import BMSAnalytics

@objc(CDVBMSRequest) class CDVBMSRequest : CDVPlugin {
    
    static let bmsLogger = Logger.logger(forName: Logger.bmsLoggerPrefix + "CDVBMSRequest")
    
    func send(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            let request = self.unpackRequest(command.arguments[0] as! NSDictionary)

            let body = command.arguments[0].objectForKey("body") as! String
            
            request.sendString(body, completionHandler: { (response, error) -> Void in
                
                guard let message = self.packResponse(response!, error: error) else {
                    let message = "Error Parsing JSON response"
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    CDVBMSRequest.bmsLogger.debug(message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    return
                }
                
                if (error != nil) {
                    CDVBMSRequest.bmsLogger.debug("Successfully sent request")
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsDictionary: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
                else {
                    CDVBMSRequest.bmsLogger.debug("Failed to send request")
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: message)
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId: command.callbackId)
                }
            })
        })
    }
    
    private func unpackRequest(requestDict: NSDictionary) -> Request {
        
        // URL
        let url = requestDict.objectForKey("url") as! String
        
        // HTTP method
        let methodStr = requestDict.objectForKey("method") as! String
        let method = getHTTPMethod(methodStr)
        
        // Initialize basic request
        let request = Request(url: url, method: method);
        
        // Headers
        request.headers = requestDict.objectForKey("headers") as! [String : String]
        
        // Query parameters
        request.queryParameters = requestDict.objectForKey("queryParameters") as? [String : String]
        
        // Timeout
        if let timeout = requestDict.objectForKey("timeout") as? Double {
            request.timeout = timeout / 1000.0
        }
        
        // Allow redirects
        // TODO: Change request allow to follow
        if let followRedirects = requestDict.objectForKey("followRedirects") as? Bool {
            request.allowRedirects = followRedirects
        }
        
        return request
    }
    
    private func getHTTPMethod(method: String) -> HttpMethod {
        
        switch method {
        case "GET":
            return HttpMethod.GET
        case "POST":
            return HttpMethod.POST
        case "PUT":
            return HttpMethod.PUT
        case "DELETE":
            return HttpMethod.DELETE
        case "TRACE":
            return HttpMethod.TRACE
        case "HEAD":
            return HttpMethod.HEAD
        case "OPTIONS":
            return HttpMethod.OPTIONS
        case "CONNECT":
            return HttpMethod.CONNECT
        case "PATCH":
            return HttpMethod.PATCH
        default:
            return HttpMethod.GET
        }
    }
    
    private func packResponse(response: Response, error: NSError?=nil) -> [String : AnyObject]? {
        
        var jsonResponse: [String : AnyObject] = [:]
        
        jsonResponse["responseText"] = response.responseText
        jsonResponse["headers"] = response.headers
        jsonResponse["statusCode"] = response.statusCode
        
        // Pack error
        if (error != nil) {
            jsonResponse["errorCode"] = error!.code
            jsonResponse["errorDescription"] = error!.localizedDescription
        }
        
        return jsonResponse
    }
    
    func stringifyResponse(value: AnyObject) -> String? {
        
        if let data = try? NSJSONSerialization.dataWithJSONObject(value, options: NSJSONWritingOptions(rawValue: 0)),
        let str = NSString(data: data, encoding: NSUTF8StringEncoding) {
            return str as String?
        }
        return nil
    }
}