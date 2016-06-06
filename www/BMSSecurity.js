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

var BMSSecurity = function() {

    var success = function(message) {
        console.log("AuthorizationManager" + ": Success: " + message);
    };
    var failure = function(message) {
        console.log("AuthorizationManager" + ": Failure: " + message);
    };

	this.obtainAuthorizationHeader = function(callback) {
		cordova.exec(callback, failure, "BMSSecurity", "obtainAuthorizationHeader", []);
	}

	this.isAuthorizationRequired = function(statusCode, header, callback) {
		cordova.exec(callback, failure, "BMSSecurity", "isAuthorizationRequired", [statusCode, header]);
	}

	this.clearAuthorizationData = function() {
		cordova.exec(success, failure, "BMSSecurity", "clearAuthorizationData", []);
	}

	this.getCachedAuthorizationHeader = function(callback) {
		cordova.exec(callback, failure, "BMSSecurity", "getCachedAuthorizationHeader", []);
	}

	this.getUserIdentity = function(callback) {
		cordova.exec(callback, failure, "BMSSecurity", "getUserIdentity", []);
	}

	this.getAppIdentity = function(callback) {
		cordova.exec(callback, failure, "BMSSecurity", "getAppIdentity", []);
	}

	this.getDeviceIdentity = function(callback) {
		cordova.exec(callback, failure, "BMSSecurity", "getDeviceIdentity", []);
	}

	this.getAuthorizationPersistencePolicy = function(callback) {
		cordova.exec(callback, failure, "BMSSecurity", "getAuthorizationPersistencePolicy", []);
	}

	this.setAuthorizationPersistencePolicy = function(policy) {
		cordova.exec(success, failure, "BMSSecurity", "setAuthorizationPersistencePolicy", [policy]);
	}

	this.logout = function(cbSuccess, cbFailure) {
		cordova.exec(cbSuccess, cbFailure, "BMSSecurity", "logout", []);
	}
};

module.exports = new BMSSecurity();
