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

var success = function(message) {
    console.log("Success");
    console.log(message);
};
var failure = function(message) {
    console.log("Failure");
    console.log(message);
};

var Logger = function (name){
    this.name = name; // instance variable
};

Logger.prototype = function(){
    var debug = function (message) {
        cordova.exec(success, failure, "MFPLogger", "debug", [this.name, message]);
    }
    var info = function (message) {
        cordova.exec(success, failure, "MFPLogger", "info", [this.name, message]);
    }
    var error = function (message) {
        cordova.exec(success, failure, "MFPLogger", "error", [this.name, message]);
    }
    var fatal = function (message) {
        cordova.exec(success, failure, "MFPLogger", "fatal", [this.name, message]);
    }
    var warn = function (message) {
        cordova.exec(success, failure, "MFPLogger", "warn", [this.name, message]);
    }
    var getName = function () {
        return this.name;
    }

    return {
        debug : debug,
        info : info,
        error : error,
        fatal : fatal,
        warn : warn,
        getName : getName
    };
}();

var MFPLogger = (function () {
    var instances = {};

    function createInstance(name) {
        var logger = new Logger(name);
        return logger;
    }

    return {
        getInstance: function (name) {
            if (!instances[name]) {
                instances[name] = createInstance(name);
            }
            cordova.exec(success , failure, "MFPLogger", "getInstance", [name]);
            return instances[name];
        },
        getCapture : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "getCapture", []);
        },
        setCapture : function (capture) {
            cordova.exec(success , failure, "MFPLogger", "setCapture", []);
        },
        getFilters : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "getFilters", []);
        },
        setFilters : function (filter) {
            cordova.exec(success , failure, "MFPLogger", "setFilters", []);
        },
        getMaxStoreSize : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "getMaxStoreSize", []);
        },
        setMaxStoreSize : function () {
            cordova.exec(success , failure, "MFPLogger", "setMaxStoreSize", []);
        },
        getLevel : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "getLevel", []);
        },
        setLevel : function (level) {
            cordova.exec(success , failure, "MFPLogger", "setLevel", []);
        },
        isUncaughtExceptionDetected : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "isUncaughtExceptionDetected", []);
        },
        send : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "send", []);
        }
    };
})();
MFPLogger.FATAL = 50;
MFPLogger.ERROR = 100;
MFPLogger.WARN = 200;
MFPLogger.INFO = 300;
MFPLogger.DEBUG = 400;

module.exports = MFPLogger;