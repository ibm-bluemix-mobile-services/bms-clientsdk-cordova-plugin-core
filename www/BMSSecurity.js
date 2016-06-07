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
 * The security component of the Swift SDK
 */
var BMSSecurity = function() {

    var success = function(message) {
        console.log("AuthorizationManager" + ": Success: " + message);
    };
    var failure = function(message) {
        console.log("AuthorizationManager" + ": Failure: " + message);
    };

    /**
     * Invoke process for obtaining authorization header.
     * 
     * @param  {Function} success - Success callback function whose first parameter is the returned JSON
     * @param  {Function} failure - Failure callback function whose first parameter is the returned JSON
     */
	this.obtainAuthorizationHeader = function(success, failure) {
		var cbSuccess = callbackWrap.bind(this, success);
		var cbFailure = callbackWrap.bind(this, failure);
		cordova.exec(callback, failure, "BMSSecurity", "obtainAuthorizationHeader", []);
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
		cordova.exec(success, failure, "BMSSecurity", "isAuthorizationRequired", [statusCode, header]);
	}

	/**
	 * Clear the local stored authorization data
	 */
	this.clearAuthorizationData = function() {
		cordova.exec(success, failure, "BMSSecurity", "clearAuthorizationData", []);
	}

	/**
	 * The locally stored authorization header or null if the value does not exist.
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned String
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getCachedAuthorizationHeader = function(success, failure) {
		cordova.exec(success, failure, "BMSSecurity", "getCachedAuthorizationHeader", []);
	}

	/**
	 * Returns the user identity
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned JSON
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getUserIdentity = function(success, failure) {
		cordova.exec(success, failure, "BMSSecurity", "getUserIdentity", []);
	}

	/**
	 * Returns the application identity
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned JSON
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getAppIdentity = function(success, failure) {
		cordova.exec(success, failure, "BMSSecurity", "getAppIdentity", []);
	}

	/**
	 * Returns the device identity
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned JSON
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getDeviceIdentity = function(success) {
		cordova.exec(success, failure, "BMSSecurity", "getDeviceIdentity", []);
	}

	/**
	 * Returns the current persistence policy
	 * 
	 * @param  {Function} success - Success callback function whose first parameter is the returned String
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned error String
	 */
	this.getAuthorizationPersistencePolicy = function(success, failure) {
		cordova.exec(success, failure, "BMSSecurity", "getAuthorizationPersistencePolicy", []);
	}

	/**
	 * Sets the persistence policy
	 * 
	 * @param {String} policy - The peristence policy to set. Use one of the BMSSecurity.Policy constants
	 * @param  {Function} success - Success callback function whose first parameter is the returned success String
	 * @param  {Function} failure - Failure callback function whose first parameter is the returned failure String
	 */
	this.setAuthorizationPersistencePolicy = function(policy, success, failure) {
		cordova.exec(success, failure, "BMSSecurity", "setAuthorizationPersistencePolicy", [policy]);
	}

	/**
	 * Logs out user from MCA. Both callback functions first parameter is a returned JSON response.
	 * 
	 * @param  {[type]} success - Success callback function
	 * @param  {[type]} failure - Failure callback function
	 */
	this.logout = function(cbSuccess, cbFailure) {
		var cbSuccess = callbackWrap.bind(this, success);
		var cbFailure = callbackWrap.bind(this, failure);
		cordova.exec(cbSuccess, cbFailure, "BMSSecurity", "logout", []);
	}

	/**
	 * Registers a delegate that will handle authentication for the specified realm.
	 * 
	 * @param  {[type]} realm - The realm name
	 * @param  {[type]} userAuthenicationListener - The listener that will handle authentication challenges 
	 */
	this.registerAuthenticationListener = function(userAuthenicationListener, realm) {

		var AuthenticationContext = {
			submitAuthenticationChallengeAnswer: function(answer) {
	            cordova.exec(success, failure, "BMSAuthenticationContext", "submitAuthenticationChallengeAnswer", [answer, realm]);
	        },
	        submitAuthenticationSuccess: function(info) {
	            cordova.exec(success, failure, "BMSAuthenticationContext", "submitAuthenticationSuccess", [realm]);
	        },
	        submitAuthenticationFailure: function(info) {
	            cordova.exec(success, failure, "BMSAuthenticationContext", "submitAuthenticationFailure", [info, realm]);
	        }
		};

		// Callback Challenge Handler function definition
        var challengeHandler = function(received)
        {
			if (received.action === "onAuthenticationChallengeReceived")
			{
				console.log("challengeHandler: onAuthenticationChallengeReceived");
				userAuthenticationListener.onAuthenticationChallengeReceived(AuthenticationContext, received.challenge);
			}
			else if (received.action === "onAuthenticationSuccess")
			{
				console.log("challengeHandler: onAuthenticationSuccess");
				userAuthenticationListener.onAuthenticationSuccess(received.info);
			}
			else if (received.action === "onAuthenticationFailure")
			{
				console.log("challengeHandler: onAuthenticationFailure");
				userAuthenticationListener.onAuthenticationFailure(received.info);
			}
			else {
				console.log("Failure in challengeHandler: action not recognize");
			}
        };

        // Register a callback Handler function
        addCallbackHandler(realm, challengeHandler);
        cordova.exec(success, failure, "BMSSecurity", "registerAuthenticationListener", [realm]);
	}

	/**
     * Unregisters the authentication callback for the specified realm.
     * 
     * @param {String} realm - Authentication realm
     */
    this.unregisterAuthenticationListener = function(realm) {
        cordova.exec(success, failure, "BMSSecurity", "unregisterAuthenticationListener", [realm]);
    };

    var addCallbackHandler = function(realm, challengeHandler) {
        var cbSuccess = callbackWrap.bind(this, challengeHandler);
        var cbFailure = function(message) { console.log("Error: addCallbackHandler failed: " + message); };
        cordova.exec(cbSuccess, cbFailure, "BMSSecurity", "addCallbackHandler", [realm]);
     };

     var callbackWrap = function(callback, response) {
         callback(response);
     };
};

BMSSecurity.ALWAYS = "ALWAYS";
BMSSecurity.NEVER = "NEVER";

module.exports = new BMSSecurity();
