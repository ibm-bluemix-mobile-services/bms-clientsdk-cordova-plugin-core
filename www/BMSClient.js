cordova.define("ibm-mfp-core.BMSClient", function(require, exports, module) {
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
    this._backendRoute = "";
    this._backendGuid = "";
    this._challengeHandlers = {};
    var BMSClientName = "BMSClient";
    var AuthContextName = "AuthenticationContext";
    var success = function(message) {
        console.log(BMSClientName + ": Success: " + message);
    };
    var failure = function(message) {
        console.log(BMSClientName + ": Failure: " + message);
    };

    /**
     * Sets the base URL for the authorization server.
     * <p>
     * This method should be called before you send the first request that requires authorization.
     * </p>
     * @param {string} backendRoute Specifies the base URL for the authorization server
     * @param {string} backendGuid Specifies the GUID of the application
     */
    this.initialize = function(backendRoute, backendGuid) {
        this._backendRoute = backendRoute;
        this._backendGuid = backendGuid;
        cordova.exec(success, failure, BMSClientName, "initialize", [backendRoute, backendGuid]);
    };

    /**
     * Registers authentication callback for the specified realm.
     * @param {string} realm Authentication realm.
     * @param {function} userAuthenticationListener
     */
    this.registerAuthenticationListener = function(realm, userAuthenticationListener) {

         var AuthenticationContext = {

                            submitAuthenticationChallengeAnswer: function(answer){
                                cordova.exec(success, failure, AuthContextName, "submitAuthenticationChallengeAnswer", [answer, realm]);
                            },

                            submitAuthenticationSuccess: function(){
                                console.log("submitAuthenticationSuccess called");
                                cordova.exec(success, failure,  AuthContextName, "submitAuthenticationSuccess", [realm]);
                            },

                            submitAuthenticationFailure: function(info){
                                console.log("submitAuthenticationFailure called");
                                cordova.exec(success, failure,  AuthContextName, "submitAuthenticationFailure", [info, realm]);
                            }
         };

        //callback Challenge Handler function definition
        var challengeHandler = function(received)
        {
          if (received.action === "onAuthenticationChallengeReceived")
          {
            console.log("challengeHandler: onAuthenticationChallengeReceived");
            userAuthenticationListener.onAuthenticationChallengeReceived(AuthenticationContext, received.challenge);

          }else if(received.action === "onAuthenticationSuccess")
          {
            console.log("challengeHandler: onAuthenticationSuccess");
            userAuthenticationListener.onAuthenticationSuccess(received.info);

          }
          else if(received.action === "onAuthenticationFailure")
          {
            console.log("challengeHandler: onAuthenticationFailure");
            userAuthenticationListener.onAuthenticationFailure(received.info);

          }else{
          console.log("Failure in challengeHandler: action not recognize");
          }
        };
        // register an callback Handler function
        addCallbackHandler(realm, challengeHandler);
        cordova.exec(success, failure, BMSClientName, "registerAuthenticationListener", [realm]);

    };

    /**
     * Unregisters the authentication callback for the specified realm.
     * @param {string} realm Authentication realm
     */
    this.unregisterAuthenticationListener = function(realm) {
        cordova.exec(success, failure, BMSClientName, "unregisterAuthenticationListener", [realm]);
    };

    /**
     *
     * @return backendRoute
     */
    this.getBluemixAppRoute = function(callback) {
        return this._backendRoute;
    };

    /**
     * 
     * @param backendGUID
     */
    this.getBluemixAppGUID = function(callback) {
        return this._backendGuid;
    };


    var addCallbackHandler = function(realm, challengeHandler){
        var cdvsuccess =  callbackWrap.bind(this, challengeHandler);
        var cdvfailure = function() { console.log("Error: addCallbackHandler failed"); };
        cordova.exec(cdvsuccess, cdvfailure, BMSClientName, "addCallbackHandler", [realm]);
     };

     var callbackWrap = function (callback, action) {
         callback(action);
     };

};

//Return singleton instance
module.exports = new BMSClient();
});
