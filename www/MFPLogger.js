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

/**
 *
 * @param name
 * @constructor
 */
var Logger = function (name){
    this.name = name; // instance variable
};

Logger.prototype = function(){
    /**
     *
     * @param message
     */
    var debug = function (message) {
        cordova.exec(success, failure, "MFPLogger", "debug", [this.name, message]);
    };
    /**
     *
     * @param message
     */
    var info = function (message) {
        cordova.exec(success, failure, "MFPLogger", "info", [this.name, message]);
    };
    /**
     *
     * @param message
     */
    var error = function (message) {
        cordova.exec(success, failure, "MFPLogger", "error", [this.name, message]);
    };
    /**
     *
     * @param message
     */
    var fatal = function (message) {
        cordova.exec(success, failure, "MFPLogger", "fatal", [this.name, message]);
    };
    /**
     *
     * @param message
     */
    var warn = function (message) {
        cordova.exec(success, failure, "MFPLogger", "warn", [this.name, message]);
    };
    /**
     *
     * @returns {*}
     */
    var getName = function () {
        return this.name;
    };

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

    /**
     * Private Method for creating logger instances
     * @param name
     * @returns {Logger}
     */
    function createInstance(name) {
        var logger = new Logger(name);
        return logger;
    }

    return {
        /**
         *  Returns a named Logger Instance
         * @param name - the name for the logger
         * @returns {*} a Logger instance
         */
        getInstance: function (name) {
            if (!instances[name]) {
                instances[name] = createInstance(name);
            }
            cordova.exec(success , failure, "MFPLogger", "getInstance", [name]);
            return instances[name];
        },
        /**
         *  Gets the current setting for determining if log data should be saved persistently
         * @param success callback takes single boolean parameter which indicates whether capture is set
         * @param failure callback
         */
        getCapture : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "getCapture", []);
        },
        setCapture : function (enabled) {
            cordova.exec(success , failure, "MFPLogger", "setCapture", [enabled]);
        },
        getFilters : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "getFilters", []);
        },
        setFilters : function (filters) {
            cordova.exec(success , failure, "MFPLogger", "setFilters", [filters]);
        },
        getMaxStoreSize : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "getMaxStoreSize", []);
        },
        setMaxStoreSize : function (intSize) {
            cordova.exec(success , failure, "MFPLogger", "setMaxStoreSize", [intSize]);
        },
        getLevel : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "getLevel", []);
        },
        setLevel : function (logLevel) {
            cordova.exec(success , failure, "MFPLogger", "setLevel", [logLevel]);
        },
        isUncaughtExceptionDetected : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "isUncaughtExceptionDetected", []);
        },
        send : function (success, failure) {
            cordova.exec(success , failure, "MFPLogger", "send", []);
        }
    };
})();

/** Trace level */
MFPLogger.FATAL = 50;
MFPLogger.ERROR = 100;
MFPLogger.WARN = 200;
MFPLogger.INFO = 300;
MFPLogger.DEBUG = 500;

module.exports = MFPLogger;