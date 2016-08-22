//
//  CustomErrorTypes.swift
//  HelloCordova
//
//  Created by Vitaly Meytin on 11/10/15.
//
//

import Foundation

enum CustomErrors : ErrorType {
    case InvalidParameterCount(expected: Int, actual: Int)
    case InvalidParameterType(expected: String, actual: AnyObject)
}

class CustomErrorMessages {
    static func invalidParameterTypeError(expected: String, actual: AnyObject) -> String {
        return "Parameter type is invalid. Expected: \(expected), actual: \(actual.dynamicType)"
    }
    
    static func invalidParameterCountError(expected: Int, actual: Int) -> String {
        return "Parameter count is invalid. Expected: \(expected), actual: \(actual)"
    }
    
    static let unexpectedError = "Unexpected error."
    static let invalidRoute = "Invalid backend route."
    static let invalidGuid = "Invalid backend application GUID."
    static let errorParsingJSONResponse = "Error parsing JSON response."
    static let noCachedAuthorizationHeader = "There is no cached authorization header."
    static let errorObtainUserIdentity = "Failed to obtain user identity."
    static let errorObtainAppIdentity = "Failed to obtain application identity."
    static let errorObtainDeviceIdentity = "Failed to obtain device identity."
    static let invalidPolicySpecified = "Invalid presistence policy specified."
    static let invalidPolicyType = "Invalid presistence policy returned from native code."
}