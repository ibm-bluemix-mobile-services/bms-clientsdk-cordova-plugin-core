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

var BMSClient = function() {
    var BMSClientString = "BMSClient";
    var success = function(message) {
        console.log(BMSClientString + ": Success: " + message);
    };
    var failure = function(message) {
        console.log(BMSClientString + ": Failure: " + message);
    };

    /**
     *  Define region constants
     * @type {string}
     */
    this.REGION_US_SOUTH = ".ng.bluemix.net";
    this.REGION_UK = ".eu-gb.bluemix.net";
    this.REGION_SYDNEY = ".au-syd.bluemix.net";
    this.REGION_GERMANY = ".eu-de.bluemix.net";
    this.REGION_US_EAST = ".us-east.bluemix.net";
    this.REGION_TOKYO = ".jp-tok.bluemix.net";
    this.REGION_JP_OSA = ".jp-osa.bluemix.net";


    /**
     * Sets the base URL for the authorization server.
     * <p>
     * This method should be called before you send the first request that requires authorization.
     * </p>
     * @param {string} bluemixRegion Specifies the region of the application
     */
    this.initialize = function(bluemixRegion) {
        cordova.exec(success, failure, BMSClientString, "initialize", [bluemixRegion]);
    };

    /**
     *
     * @return backendRoute
     */
    this.getBluemixAppRoute = function(callback) {
        cordova.exec(callback, failure, BMSClientString, "getBluemixAppRoute", []);
    };

    /**
     * 
     * @return backendGUID
     */
    this.getBluemixAppGUID = function(callback) {
        cordova.exec(callback, failure, BMSClientString, "getBluemixAppGUID", []);
    };

};

//Return singleton instance
module.exports = new BMSClient();

