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
 * A singleton that serves as an entry point to Bluemix client-server communication.
 */
var BMSClient = function() {

    var success = function(message) {
        console.log("BMSClient" + ": Success: " + message);
    };
    var failure = function(message) {
        console.log("BMSClient" + ": Failure: " + message);
    };

    /**
     * The southern United States Bluemix region - Note: Use this in the BMSClient initialize method
     * @type {String}
     */
    this.REGION_US_SOUTH = ".ng.bluemix.net";

    /**
     * The United Kingdom Bluemix region - Note: Use this in the BMSClient initialize method
     * @type {String}
     */
    this.REGION_UK = ".eu-gb.bluemix.net";

    /**
     * The Sydney Bluemix region - Note: Use this in the BMSClient initialize method
     * @type {String}
     */
    this.REGION_SYDNEY = ".au-syd.bluemix.net";

    /**
     * Sets the base URL for the authorization server
     * 
     * @param  {string} bluemixAppRoute - The base URL for the authorization server
     * @param  {string} bluemixAppGUID - The GUID of the Bluemix application
     * @param  {string} bluemixRegion - The region where your Bluemix application is hosted. Use one of the BMSClient.REGION constants
     */
	this.initialize = function(bluemixAppRoute, bluemixAppGUID, bluemixRegion) {
		cordova.exec(success, failure, "BMSClient", "initialize", [bluemixAppRoute, bluemixAppGUID, bluemixRegion]);
	}

	/**
	 * Returns the base URL for the authorization server
	 * 
	 * @param  {Function} callback - Callback function whose parameter is the returned Bluemix app route
	 */
	this.getBluemixAppRoute = function(callback) {
		cordova.exec(callback, failure, "BMSClient", "getBluemixAppRoute", []);
	}

	/**
	 * Returns the backend application id
	 * 
	 * @param  {Function} callback - Callback function whose parameter is the returned Bluemix app GUID
	 */
	this.getBluemixAppGUID = function(callback) {
		cordova.exec(callback, failure, "BMSClient", "getBluemixAppGUID", []);
	}

	/**
	 * Returns the default timeout (in seconds) for all BMS network requests
	 * 
	 * @param  {Function} callback - Callback function whose parameter is the returned default timeout
	 */
	this.getDefaultRequestTimeout = function(callback) {
		cordova.exec(callback, failure, "BMSClient", "getDefaultRequestTimeout", []);
	}

	/**
	 * Sets the default timeout (in seconds) for all BMS network requests.
	 * 
	 * @param {[type]} timeout - The new default timeout value
	 */
	this.setDefaultRequestTimeout = function(timeout) {
		cordova.exec(success, failure, "BMSClient", "setDefaultRequestTimeout", [timeout]);
	}

		/**
	 * Registers a delegate that will handle authentication for the specified realm.
	 * 
	 * @param  {[type]} realm - The realm name
	 * @param  {[type]} userAuthenticationListener - The listener that will handle authentication challenges 
	 */
	this.registerAuthenticationListener = function(realm, userAuthenticationListener) {

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
        cordova.exec(success, failure, "BMSClient", "registerAuthenticationListener", [realm]);
	}

	/**
     * Unregisters the authentication callback for the specified realm.
     * 
     * @param {String} realm - Authentication realm
     */
    this.unregisterAuthenticationListener = function(realm) {
        cordova.exec(success, failure, "BMSClient", "unregisterAuthenticationListener", [realm]);
    };

    var addCallbackHandler = function(realm, challengeHandler) {
	    var cbSuccess = callbackWrap.bind(this, challengeHandler);
	    var cbFailure = function(message) { console.log("Error: addCallbackHandler failed: " + message); };
	    cordova.exec(cbSuccess, cbFailure, "BMSClient", "addCallbackHandler", [realm]);
	};

	var callbackWrap = function(callback, response) {
	    callback(response);
	};
};

module.exports = new BMSClient();
