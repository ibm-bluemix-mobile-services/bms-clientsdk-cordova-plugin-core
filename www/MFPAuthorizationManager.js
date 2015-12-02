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
var exec = require("cordova/exec");



var MFPAuthorizationManager = function() {
	this.PersistencePolicyAlways = "ALWAYS";
	this.PersistencePolicyNever = "NEVER";

    var AuthorizationManagerString = "MFPAuthorizationManager";

	var success = function() { console.log("AuthorizationManager Success: default success is called"); };
    var failure = function() { console.log("AuthorizationManager Error: default failure is called"); };

    /**
     * Invoke process for obtaining authorization header. during this process
     * @param success The success callback that was supplied
     * @param failure The failure callback that was supplied
     */
	this.obtainAuthorizationHeader = function(success, failure) {
		cordova.exec(success, failure, AuthorizationManagerString, "obtainAuthorizationHeader", []);
	};

    /**
     * Check if the params came from response that requires authorization
     * @param {statusCode} of the response
     * @param {responseAuthorizationHeader} 'WWW-Authenticate' header
     * @param {success} The success callback that was supplied
     * @param {failure} The failure callback that was supplied
     * @return true if status is 401 or 403 and The value of the header contains 'Bearer' AND 'realm="imfAuthentication"'
     */
	this.isAuthorizationRequired = function(statusCode, responseAuthHeader, success, failure){
	    cordova.exec(success, failure, AuthorizationManagerString, "isAuthorizationRequired", [statusCode,responseAuthHeader]);
	};

    /**
     * Clear the local stored authorization data
     */
    this.clearAuthorizationData = function(){
        cordova.exec(success, failure, AuthorizationManagerString, "clearAuthorizationData", []);
    };

    /**
     * @param success The success callback that was supplied
     * @param failure The failure callback that was supplied
     * @return the locally stored authorization header or null if the value is not exist.
     */
    this.getCachedAuthorizationHeader = function(success, failure){
        cordova.exec(success, failure, AuthorizationManagerString, "getCachedAuthorizationHeader", []);
    };

    /**
     * @param success The success callback that was supplied
     * @param failure The failure callback that was supplied
     * @return Current authorization persistence policy.
     */
    this.getAuthorizationPersistencePolicy= function(success, failure){
        cordova.exec(success, failure, AuthorizationManagerString, "getAuthorizationPersistencePolicy", []);
    };

    /**
     * Change the sate of the current authorization persistence policy
     * @param policy new policy to use
     */
    this.setAuthorizationPersistencePolicy = function(success, failure, policy){
        cordova.exec(success, failure, AuthorizationManagerString, "setAuthorizationPersistencePolicy", [policy]);
    };

    /**
     * @param success The success callback that was supplied
     * @param failure The failure callback that was supplied
     * @return authorized user identity.
     */
    this.getUserIdentity = function(success, failure){
        cordova.exec(success, failure, AuthorizationManagerString, "getUserIdentity", []);
    };

    /**
     * @param success The success callback that was supplied
     * @param failure The failure callback that was supplied
     * @return application identity.
     */
    this.getAppIdentity = function(success, failure){
         cordova.exec(success, failure, AuthorizationManagerString, "getAppIdentity", []);
    };

    /**
     * @param success The success callback that was supplied
     * @param failure The failure callback that was supplied
     * @return device identity.
     */
    this.getDeviceIdentity = function(success, failure){
        cordova.exec(success, failure, AuthorizationManagerString, "getDeviceIdentity", []);
    };
};

//Return singleton instance
module.exports = new MFPAuthorizationManager();
