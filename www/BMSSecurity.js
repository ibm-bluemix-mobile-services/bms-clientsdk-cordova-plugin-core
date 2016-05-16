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
 * [BMSSecurity description]
 */
var BMSSecurity = function() {

    var success = function(message) {
        console.log("BMSClient" + ": Success: " + message);
    };
    var failure = function(message) {
        console.log("BMSClient" + ": Failure: " + message);
    };

    /**
     * Sets the base URL for the authorization server
     * 
     * @param  {string} bluemixAppRoute - The base URL for the authorization server
     * @param  {string} bluemixAppGUID - The GUID of the Bluemix application
     * @param  {string} bluemixRegion - The region where your Bluemix application is hosted. Use one of the BMSClient.REGION constants
     */
	this.initialize = function(bluemixAppRoute, bluemixAppGUID, bluemixRegion) {
		cordova.exec(success, failure, "BMSSecurity", "initialize", [bluemixAppRoute, bluemixAppGUID, bluemixRegion]);
	}
};

module.exports = new BMSSecurity();
