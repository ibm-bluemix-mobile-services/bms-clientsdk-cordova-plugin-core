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



var AuthorizationManager = function() {
	this.PersistencePolicyAlways = "ALWAYS";
	this.PersistencePolicyNever = "NEVER";

    var AuthorizationManagerName = "AuthorizationManager";

	var success = function() { console.log("AuthorizationManager Success: default success is called"); };
    var failure = function() { console.log("AuthorizationManager Error: default failure is called"); };

	this.obtainAuthorizationHeader = function(success, failure) {
		cordova.exec(success, failure, AuthorizationManagerName, "obtainAuthorizationHeader", []);
	};

	this.isAuthorizationRequired = function(statusCode, responseAuthHeader, success, failure){
	    cordova.exec(success, failure, AuthorizationManagerName, "isAuthorizationRequired", [statusCode,responseAuthHeader]);
	};

    this.clearAuthorizationData = function(){
        cordova.exec(success, failure, AuthorizationManagerName, "clearAuthorizationData", []);
    };

    this.getCachedAuthorizationHeader = function(success, failure){
        cordova.exec(success, failure, AuthorizationManagerName, "getCachedAuthorizationHeader", []);
    };

    this.getAuthorizationPersistencePolicy= function(success, failure){
        cordova.exec(success, failure, AuthorizationManagerName, "getAuthorizationPersistencePolicy", []);
    };

     this.setAuthorizationPersistencePolicy = function(policy){
         cordova.exec(success, failure, AuthorizationManagerName, "setAuthorizationPersistencePolicy", [policy]);
     };

     this.getUserIdentity = function(success, failure){
         cordova.exec(success, failure, AuthorizationManagerName, "getUserIdentity", []);
     };

     this.getAppIdentity = function(success, failure){
         cordova.exec(success, failure, AuthorizationManagerName, "getAppIdentity", []);
     };

     this.getDeviceIdentity = function(success, failure){
         cordova.exec(success, failure, AuthorizationManagerName, "getDeviceIdentity", []);
     };


};

//Return singleton instance
module.exports = new AuthorizationManager();