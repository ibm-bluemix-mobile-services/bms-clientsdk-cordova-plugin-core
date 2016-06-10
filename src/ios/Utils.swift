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

class Utils {

    static func unpackRequest(requestDict: NSDictionary) -> Request {
        
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
        if let followRedirects = requestDict.objectForKey("followRedirects") as? Bool {
            request.allowRedirects = followRedirects
        }
        
        return request
    }

    static func getHTTPMethod(method: String) -> HttpMethod {
        
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

    static func packResponse(response: Response?, error: NSError?=nil) -> [String : AnyObject]? {
        
        var jsonResponse: [String : AnyObject] = [:]
        
        // Pack response
        if (response != nil) {
            jsonResponse["responseText"] = response!.responseText
            jsonResponse["headers"] = response!.headers
            jsonResponse["statusCode"] = response!.statusCode
        }
        
        // Pack error
        if (error != nil) {
            jsonResponse["errorCode"] = error!.code
            jsonResponse["errorDescription"] = error!.description
        }
        
        return jsonResponse
    }

    static func stringifyResponse(value: AnyObject) -> String? {
        
        if let data = try? NSJSONSerialization.dataWithJSONObject(value, options: NSJSONWritingOptions(rawValue: 0)),
        let str = NSString(data: data, encoding: NSUTF8StringEncoding) {
            return str as String?
        }
        return nil
    }
}