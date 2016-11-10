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

var success = function() { console.log("Success: BMSAnalytics "); };
var failure = function() { console.log("Error: BMSAnalytics"); };

var BMSAnalytics = {

    /**
     * Define Device Events
     * @type {int}
     */
    NONE: 0,
    ALL: 1,
    LIFECYCLE: 2,
    NETWORK: 3,

    /**
     * Turns on the global setting for persisting of the analytics data.
     */
    enable: function () {
        cordova.exec(success , failure, "BMSAnalytics", "enable", []);
    },
    /**
     * Turns off the global setting for persisting of the analytics data.
     */
    disable: function () {
        cordova.exec(success , failure, "BMSAnalytics", "disable", []);
    },
    /**
     * Gets the current setting for determining if log data should be saved persistently.
     * @param success recieves {boolean}
     * @param failure
     */
    isEnabled: function (success, failure) {
        cordova.exec(success , failure, "BMSAnalytics", "isEnabled", []);
    },
    /**
     * Sends the analytics log file when the log store exists and is not empty
     * If the send fails, the local store is preserved. If the send succeeds, the local store is deleted.
     * @param success callback (android only)
     * @param failure  callback (android only)
     */
    send: function (success, failure) {
        cordova.exec(success , failure, "BMSAnalytics", "send", []);
    },
    /**
     * Initialize BMSAnalytics API
     * <p>This method must be called before any analytics methods can be called.</p>
     * @param applicationName Application's common name.  Should be consistent across platforms.
     * @param clientApiKey The Client API Key used to communicate with your Bluemix Analytics service.
     * @param hasUserContext If true, Analytics only records one user per device. If false, setting the user identity will keep a record of all users.
     * @param deviceEvents One or more context attributes BMSAnalytics will register event listeners for.
     * (e.g BMSAnalytics.NONE, BMSAnalytics.ALL, BMSAnalytics.LIFECYCLE, BMSAnalytics.NETWORK)
     */
    initialize : function(applicationName, clientApiKey, hasUserContext, deviceEvents){
        cordova.exec(success, failure, "BMSAnalytics", "initialize", [applicationName, clientApiKey, hasUserContext, deviceEvents])

    },
    /**
     * Log an analytics event
     * @param metadata An object that contains the description for the event
     */
    log: function(metadata){
        cordova.exec(success, failure, "BMSAnalytics", "log", [metadata]);
    },
    /**
     * <p>Specify current application user. This value will be hashed to ensure privacy.
     * If your application does not have user context, then nothing will happen.</p>
     *
     * @param username username User id for current app user
     */
    setUserIdentity: function(username){
        cordova.exec(success, failure, "BMSAnalytics", "setUserIdentity", [username]);
    }
};

module.exports = BMSAnalytics;
