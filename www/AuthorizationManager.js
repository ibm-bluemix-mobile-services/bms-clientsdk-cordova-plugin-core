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
	
	var success = function() { console.log("Success: default success is called"); };
    var failure = function() { console.log("Error: default failure is called"); };
	
	this.obtainAuthorizationHeader = function(success, failure) {
		cordova.exec(success, failure, "AuthorizationManager", "obtainAuthorizationHeader", []);
	};
};

//Return singleton instance
module.exports = new AuthorizationManager();

