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
var BMSAnalytics = function() {

    var success = function(message) {
        console.log("BMSAnalytics" + ": Success: " + message);
    };
    var failure = function(message) {
        console.log("BMSAnalytics" + ": Failure: " + message);
    };

    /**
     * The required initializer for the BMSAnalytics class when communicating with a Bluemix analytics service
     * This method must be called after the BMSClient.initializeWithBluemixAppRoute() method and before calling BMSAnalytics.send() or BMSLogger.send()
     * 
     * @param  {String} appName - The application name. Should be consistent across platforms (e.g. Android and iOS).
     * @param  {String} apiKey - A unique ID used to authenticate with the Bluemix analytics service
     */
    this.initialize = function(appName, apiKey) {
    	cordova.exec(success, failure, "BMSAnalytics", "initialize", [appName, apiKey]);
    }

    /**
     * Enable analytics logging
     */
    this.enable = function() {
    	cordova.exec(success, failure, "BMSAnalytics", "enable", []);
    }

    /**
     * Disable analytics logging
     */
    this.disable = function() {
    	cordova.exec(success, failure, "BMSAnalytics", "disable", []);
    }

    /**
     * Whether or not analytics logging is enabled
     * 
     * @param  {Function} callback - Callback function whose first parameter is the returned boolean value
     */
    this.isEnabled = function(callback) {
    	cordova.exec(callback, failure, "BMSAnalytics", "isEnabled", []);
    }

    /**
     * Identifies the current application user. To reset the userId, set the value to null
     * 
     * @param {String} identity - The current application user
     */
    this.setUserIdentity = function(identity) {
    	cordova.exec(success, failure, "BMSAnalytics", "setUserIdentity", [identity]);
    }

    /**
     * Write analytics data to file
     * 
     * @param  {JSON Object} eventMetadata - Data to write
     */
    this.log = function(eventMetadata) {
    	cordova.exec(success, failure, "BMSAnalytics", "log", [eventMetadata]);
    }

    /**
     * Send the accumulated analytics logs to the Bluemix server
     * Analytics logs can only be sent if the BMSClient was initialized via the initializeWithBluemixAppRoute() method
     * 
     * @param  {Function} callback - Callback function called on success
     */
    this.send = function(callback) {
    	cordova.exec(callback, failure, "BMSAnalytics", "send", []);
    }
};

module.exports = new BMSAnalytics();
