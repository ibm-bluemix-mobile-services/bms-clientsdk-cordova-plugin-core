//
//  Utils.swift
//  HelloCordova
//
//  Created by Vitaly Meytin on 11/30/15.
//
//

import Foundation
import IMFCore

class Utils {
    static func packResponse(response: IMFResponse!,error:NSError?=nil) throws -> String {
        var jsonResponse = [String:AnyObject]()
        var responseString: NSString = ""
        
        if error != nil {
            jsonResponse["errorCode"] = Int((error!.code))
            jsonResponse["errorDescription"] = (error!.localizedDescription)
            
            if let userInfo = error?.userInfo {
                var validUserInfo = [String:AnyObject]()
                for (key, value) in userInfo {
                    if let k = key as? String  {
                        var actualValue = value
                        if let url = value as? NSURL {
                            actualValue = url.absoluteString
                        }
                        let tempValue:[String:AnyObject] = [key as! String: actualValue]
                        
                        if NSJSONSerialization.isValidJSONObject(tempValue) {
                            validUserInfo[k] = actualValue
                        }
                    }
                }
                
                jsonResponse["userInfo"] = validUserInfo
            }
        }
        else {
            jsonResponse["errorCode"] = Int((0))
            jsonResponse["errorDescription"] = ""
        }
        
        if (response == nil) {
            jsonResponse["responseText"] = ""
            jsonResponse["headers"] = []
            jsonResponse["status"] = Int((0))
            
        } else {
            let responseText: String = (response.responseText != nil)    ? response.responseText : ""
            jsonResponse["responseText"] = responseText
            
            
            if response.responseHeaders != nil {
                jsonResponse["headers"] = response.responseHeaders
            }
            else {
                jsonResponse["headers"] = []
            }
            
            jsonResponse["status"] = Int(response.httpStatus)
        }
        
        responseString = try Utils.stringifyResponse(jsonResponse);
        return responseString as String
    }
    
    static func stringifyResponse(value: AnyObject,prettyPrinted:Bool = false) throws -> String {
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        var jsonString : String? = ""
        
        if NSJSONSerialization.isValidJSONObject(value) {
            let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
            jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
        }
        return jsonString!
    }

}