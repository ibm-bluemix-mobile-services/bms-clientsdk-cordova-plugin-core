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

var exec = require('cordova/exec');

/**
 * The security component of the Swift SDK used for obtaining authorization tokens from Mobile Client Access service and providing user, device and application identities. 
 */
var MCAAuthorizationManager = function() {

    var success = function(message) {
        console.log("MCAAuthorizationManager" + ": Success: " + message);
    };
    var failure = function(message) {
        console.log("MCAAuthorizationManager" + ": Failure: " + message);
    };

    /**
     * Invokes the process for obtaining authorization header.
     * 
     * @param  {Function} success - Success callback function whose first parameter is the returned JSON
     * @param  {Function} failure - Failure callback function whose first parameter is the returned JSON
     */
	this.obtainAuthorizationHeader = function(success, failure) {
		var cbSuccess = callbackWrap.bind(this, success);
		var cbFailure = callbackWrap.bind(this, failure);
		cordova.exec(cbSuccess, cbFailure, "MCAAuthorizationManager", "obtainAuthorizationHeader", []);
	}

	/**
	 * Check if the params came from response that requires authorization
	 * 
	 * @param  {Int} statusCode - Status code of the response 
	 * @param  {String} header -  Response header
	 * @param  {Function} success - Success callback function whose first parameter is the returned Boolean
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.isAuthorizationRequired = function(statusCode, header, success, failure) {
		cordova.exec(success, failure, "MCAAuthorizationManager", "isAuthorizationRequired", [statusCode, header]);
	}

	/**
	 * Clear the local stored authorization data
	 */
	this.clearAuthorizationData = function() {
		cordova.exec(success, failure, "MCAAuthorizationManager", "clearAuthorizationData", []);
	}

	/**
	 * Returns he locally stored authorization header or null if the value does not exist.
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned String
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getCachedAuthorizationHeader = function(success, failure) {
		cordova.exec(success, failure, "MCAAuthorizationManager", "getCachedAuthorizationHeader", []);
	}

	/**
	 * Returns the user identity
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned JSON
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getUserIdentity = function(success) {
		cordova.exec(success, failure, "MCAAuthorizationManager", "getUserIdentity", []);
	}

	/**
	 * Returns the application identity
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned JSON
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getAppIdentity = function(success) {
		cordova.exec(success, failure, "MCAAuthorizationManager", "getAppIdentity", []);
	}

	/**
	 * Returns the device identity
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned JSON
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getDeviceIdentity = function(success) {
		cordova.exec(success, failure, "MCAAuthorizationManager", "getDeviceIdentity", []);
	}

	/**
	 * Returns the current persistence policy
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned String
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getAuthorizationPersistencePolicy = function(success) {
		cordova.exec(success, failure, "MCAAuthorizationManager", "getAuthorizationPersistencePolicy", []);
	}

	/**
	 * Sets the persistence policy
	 * 
	 * @param {String} policy - The peristence policy to set. Use one of the MCAAuthorizationManager.Policy constants
	 * @param  {Function} success - Success callback function whose first parameter is the returned success String
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned failure String
	 */
	this.setAuthorizationPersistencePolicy = function(policy, success, failure) {
		cordova.exec(success, failure, "MCAAuthorizationManager", "setAuthorizationPersistencePolicy", [policy]);
	}

	/**
	 * Logs out user from MCA. Both callback functions first parameter is a returned JSON response.
	 * 
	 * @param  {[type]} success - Success callback function
	 * @param  {[type]} failure - Failure callback function
	 */
	this.logout = function(success, failure) {
		var cbSuccess = callbackWrap.bind(this, success);
		var cbFailure = callbackWrap.bind(this, failure);
		cordova.exec(cbSuccess, cbFailure, "MCAAuthorizationManager", "logout", []);
	}

    var callbackWrap = function(callback, response) {
        callback(response);
    };
};



module.exports = new MCAAuthorizationManager();
