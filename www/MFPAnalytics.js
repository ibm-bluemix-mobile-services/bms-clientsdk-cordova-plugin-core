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

var success = function() { console.log("Success: MFPAnalytics "); };
var failure = function() { console.log("Error: MFPAnalytics"); };

var MFPAnalytics = {

    /**
     * Turns on the global setting for persisting of the analytics data.
     */
    enable: function () {
        cordova.exec(success , failure, "MFPAnalytics", "enable", []);
    },
    /**
     * Turns off the global setting for persisting of the analytics data.
     */
    disable: function () {
        cordova.exec(success , failure, "MFPAnalytics", "disable", []);
    },
    /**
     * Gets the current setting for determining if log data should be saved persistently.
     * @param success recieves {boolean}
     * @param failure
     */
    isEnabled: function (success, failure) {
        cordova.exec(success , failure, "MFPAnalytics", "isEnabled", []);
    },
    /**
     * Sends the analytics log file when the log store exists and is not empty
     * If the send fails, the local store is preserved. If the send succeeds, the local store is deleted.
     * @param success callback (android only)
     * @param failure  callback (android only)
     */
    send: function (success, failure) {
        cordova.exec(success , failure, "MFPAnalytics", "send", []);
    }
};

module.exports = MFPAnalytics;
