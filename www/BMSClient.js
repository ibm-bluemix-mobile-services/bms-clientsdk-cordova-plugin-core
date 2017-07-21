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
    var AuthContextString = "BMSAuthenticationContext";
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
     * Registers authentication callback for the specified realm.
     * @param {string} realm Authentication realm.
     * @param {function} userAuthenticationListener
     */
    this.registerAuthenticationListener = function(realm, userAuthenticationListener) {

         var AuthenticationContext = {

                            submitAuthenticationChallengeAnswer: function(answer){
                                cordova.exec(success, failure, AuthContextString, "submitAuthenticationChallengeAnswer", [answer, realm]);
                            },

                            submitAuthenticationSuccess: function(){
                                console.log("submitAuthenticationSuccess called");
                                cordova.exec(success, failure,  AuthContextString, "submitAuthenticationSuccess", [realm]);
                            },

                            submitAuthenticationFailure: function(info){
                                console.log("submitAuthenticationFailure called");
                                cordova.exec(success, failure,  AuthContextString, "submitAuthenticationFailure", [info, realm]);
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
        cordova.exec(success, failure, BMSClientString, "registerAuthenticationListener", [realm]);

    };

    /**
     * Unregisters the authentication callback for the specified realm.
     * @param {string} realm Authentication realm
     */
    this.unregisterAuthenticationListener = function(realm) {
        cordova.exec(success, failure, BMSClientString, "unregisterAuthenticationListener", [realm]);
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


    var addCallbackHandler = function(realm, challengeHandler){
        var cdvsuccess =  callbackWrap.bind(this, challengeHandler);
        var cdvfailure = function() { console.log("Error: addCallbackHandler failed"); };
        cordova.exec(cdvsuccess, cdvfailure, BMSClientString, "addCallbackHandler", [realm]);
     };

     var callbackWrap = function (callback, action) {
         callback(action);
     };

    };

//Return singleton instance
module.exports = new BMSClient();
