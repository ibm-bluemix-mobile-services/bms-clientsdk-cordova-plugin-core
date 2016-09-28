/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/


import Foundation
import BMSCore

class Utils {
    static func packResponse(_ response: Response!,error:NSError?=nil) throws -> String {
        var jsonResponse = [String:AnyObject]()
        var responseString: NSString = ""

        if error != nil {
            jsonResponse["errorCode"] = Int((error!.code)) as AnyObject?
            jsonResponse["errorDescription"] = (error!.localizedDescription as AnyObject?)

            if let userInfo = error?.userInfo {
                var validUserInfo = [String:AnyObject]()
                for (key, value) in userInfo {
                    if let k = key as? String  {
                        var actualValue = value
                        #if swift(>=3.0)
                            if let url = value as? URL {
                                actualValue = url.absoluteString
                            }
                        #else
                            if let url = value as? NSURL {
                                actualValue = url.absoluteString
                            }
                        #endif
                        let tempValue:[String:AnyObject] = [key as! String: actualValue as AnyObject]

                        #if swift(>=3.0)
                            if JSONSerialization.isValidJSONObject(tempValue) {
                                validUserInfo[k] = actualValue as AnyObject?
                            }
                        #else
                            if NSJSONSerialization.isValidJSONObject(tempValue) {
                                validUserInfo[k] = actualValue as AnyObject?
                            }
                        #endif
                    }
                }

                jsonResponse["userInfo"] = validUserInfo as AnyObject?
            }
        }
        else {
            jsonResponse["errorCode"] = Int((0)) as AnyObject?
            jsonResponse["errorDescription"] = "" as AnyObject?
        }

        if (response == nil) {
            jsonResponse["responseText"] = "" as AnyObject?
            jsonResponse["headers"] = [String:AnyObject]() as AnyObject?
            jsonResponse["status"] = Int((0)) as AnyObject?

        } else {
            let responseText: String = (response.responseText != nil)    ? response.responseText! : ""
            jsonResponse["responseText"] = responseText as AnyObject?


            if response.headers != nil {
                jsonResponse["headers"] = response.headers as AnyObject?
            }
            else {
                jsonResponse["headers"] = [String:AnyObject]() as AnyObject?
            }

            jsonResponse["status"] = response.statusCode as AnyObject?
        }

        #if swift(>=3.0)
            responseString = try Utils.stringifyResponse(jsonResponse as AnyObject) as NSString;
        #else
            responseString = try Utils.stringifyResponse(jsonResponse as AnyObject) as NSString;
        #endif
        return responseString as String
    }

    static func stringifyResponse(_ value: AnyObject,prettyPrinted:Bool = false) throws -> String {
        #if swift(>=3.0)
            let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
            var jsonString : String? = ""

            if JSONSerialization.isValidJSONObject(value) {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                jsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            }
        #else
            let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
            var jsonString : String? = ""

            if NSJSONSerialization.isValidJSONObject(value) {
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
            }
        #endif
        return jsonString!
    }

}