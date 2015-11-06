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
                                cordova.exec(success, failure, BMSClientName, "submitAuthenticationChallengeAnswer", [answer, realm]);
                            },

                            submitAuthenticationSuccess: function(){
                                console.log("submitAuthenticationSuccess called");
                                cordova.exec(success, failure, BMSClientName, "submitAuthenticationSuccess", [realm]);
                            },

                            submitAuthenticationFailure: function(info){
                                console.log("submitAuthenticationFailure called");
                                cordova.exec(success, failure, BMSClientName, "submitAuthenticationFailure", [info, realm]);
                            }
         };

        //callback receiver function definition
        var ChallengeHandlerReceiver = function(received)
        {
          if (received.action === "onAuthenticationChallengeReceived")
          {
            console.log("ChallengeHandlerReceiver: onAuthenticationChallengeReceived");
            userAuthenticationListener.onAuthenticationChallengeReceived(AuthenticationContext, received.challenge);

          }else if(received.action === "onAuthenticationSuccess")
          {
            console.log("ChallengeHandlerReceiver: onAuthenticationSuccess");
            userAuthenticationListener.onAuthenticationSuccess(received.info);

          }
          else if(received.action === "onAuthenticationFailure")
          {
            console.log("ChallengeHandlerReceiver: onAuthenticationFailure");
            userAuthenticationListener.onAuthenticationFailure(received.info);

          }else{
          console.log("Failure in ChallengeHandlerReceiver: action not recognize");
          }
        };
        // register an callback receiver function
        addCallbackReceiver(realm, ChallengeHandlerReceiver);
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


    var addCallbackReceiver = function(realm, actionRecived){
        var cdvsuccess =  callbackWrap.bind(this, actionRecived);
        var cdvfailure = function() { console.log("Error: addCallbackReceiver failed"); };
        cordova.exec(cdvsuccess, cdvfailure, BMSClientName, "addCallbackReceiver", [realm]);
     };

     var callbackWrap = function (callback, action) {
         callback(action);
     };

};

//Return singleton instance
module.exports = new BMSClient();
