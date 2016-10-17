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

#if swift(>=3.0)
    enum CustomErrors : Error {
        case InvalidParameterCount(expected: Int, actual: Int)
        case InvalidParameterType(expected: String, actual: AnyObject)
    }
#else
    enum CustomErrors : ErrorType {
        case InvalidParameterCount(expected: Int, actual: Int)
        case InvalidParameterType(expected: String, actual: AnyObject)
    }
#endif


class CustomErrorMessages {
#if swift(>=3.0)
    static func invalidParameterTypeError(expected: String, actual: AnyObject) -> String {
        return "Parameter type is invalid. Expected: \(expected), actual: \(type(of: actual))"
    }
#else
    static func invalidParameterTypeError(expected: String, actual: AnyObject) -> String {
        return "Parameter type is invalid. Expected: \(expected), actual: \(actual.dynamicType)"
    }
#endif

    static func invalidParameterCountError(_ expected: Int, actual: Int) -> String {
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
    static let invalidTenantId = "Invalid MCA service tenantID."
}