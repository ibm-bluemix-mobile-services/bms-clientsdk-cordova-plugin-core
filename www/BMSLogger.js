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

var exec = require("cordova/exec");

var success = function(message) {
    console.log("BMSLogger: Success: " + message);
};
var failure = function(message) {
    console.log("BMSLogger: Failure: " + message);
};

/**
 * Logger instance used for logging different levels of verbosity
 * 
 * @param {String} name - Name of the logger instance
 */
var Logger = function(name) { 
    this.name = name;
};

Logger.prototype = function() {
    
    /**
     * Log at the Debug log level
     * 
     * @param  {String} message - Message to log
     */
    var debug = function(message) {
        cordova.exec(null, failure, "BMSLogger", "log", [this.name, message, "DEBUG"]);
    };

    /**
     * Log at the Info log level
     * 
     * @param  {String} message - Message to log
     */
    var info = function(message) {
        cordova.exec(null, failure, "BMSLogger", "log", [this.name, message, "INFO"]);
    };

    /**
     * Log at the Warn log level
     * 
     * @param  {String} message - Message to log
     */
    var warn = function(message) {
        cordova.exec(null, failure, "BMSLogger", "log", [this.name, message, "WARN"]);
    };
    
    /**
     * Log at the Error log level
     * 
     * @param  {String} message - Message to log
     */
    var error = function(message) {
        cordova.exec(null, failure, "BMSLogger", "log", [this.name, message, "ERROR"]);
    };
    
    /**
     * Log at the Fatal log level
     * 
     * @param  {String} message - Message to log
     */
    var fatal = function(message) {
        cordova.exec(null, failure, "BMSLogger", "log", [this.name, message, "FATAL"]);
    };

    /**
     * Get the name that identifies this Logger instance
     * 
     * @return {String} - Name of the logger instance
     */
    var getName = function () {
        return this.name;
    };

    return {
        debug: debug,
        info: info,
        error: error,
        fatal: fatal,
        warn: warn,
        getName: getName
    };
}();

/**
 * Provides a wrapper to the native platform Logger
 */
var BMSLogger = (function() {

    var instances = {};

    function createInstance(name) {
        var logger = new Logger(name);
        return logger;
    }

    /**
     * Creates a Logger instance
     * 
     * @param {String} name - The name that identifies this Logger instance
     * @return {Logger} - Newly created Logger instance
     */
    function getLogger(name) {
        //cordova.exec(success, failure, "BMSLogger", "loggerForName", [name]);
        if (!instances[name]) {
            instances[name] = createInstance(name);
        }
        return instances[name];
    }

    /**
     * Retrieve the current log level filter
     * 
     * @param {Function} callback - Callback function whose first parameter is current log level
     */
    function getLogLevelFilter(callback) {
        cordova.exec(callback, failure, "BMSLogger", "getLogLevelFilter", []);
    }

    /**
     * Only logs that are at or above this level will be output to the console
     * 
     * @param {String} level - Log level to set. Use the appropriate BMSLogger.Level
     */
    function setLogLevelFilter(level) {
        cordova.exec(success, failure, "BMSLogger", "setLogLevelFilter", [level]);
    }

    /**
     * Retrieve the current log level filter
     * 
     * @param {Function} callback - Callback function whose first parameter is the returned boolean value
     */
    function sdkDebugLoggingEnabled(callback) {
        cordova.exec(callback, failure, "BMSLogger", "sdkDebugLoggingEnabled", []);
    }

    /**
     * Enable or disable the native SDK debug logging
     * 
     * @param {Boolean} value - If set to false, the internal BMSCore debug logs will not be displayed on the console
     */
    function setSDKDebugLogging(value) {
        cordova.exec(success, failure, "BMSLogger", "setSDKDebugLogging", [value]);
    }

    /**
     * Whether logs get written to file on the client device
     * 
     * @param {Function} callback - Callback function whose first parameter is a returned boolean value
     */
    function getStoreLogs(callback) {
        cordova.exec(callback, failure, "BMSLogger", "getStoreLogs", []);
    }

    /**
     * Enable or disable storing logs
     * 
     * @param {Boolean} value - Must be set to true to be able to send logs to the Bluemix server
     */
    function setStoreLogs(value) {
        cordova.exec(success, failure, "BMSLogger", "setStoreLogs", [value]);
    }

    /**
     * Retrieves the maximum file size (in bytes) for log storage
     * 
     * @param {Function} callback - Callback function whose first parameter is a returned store size value
     */
    function getMaxLogStoreSize(callback) {
        cordova.exec(callback, failure, "BMSLogger", "getMaxLogStoreSize", []);
    }

    /**
     * Sets the maximum file size (in bytes) for log storage. Both the Analytics and Logger log files are limited by maxLogStoreSize.
     * 
     * @param {Int} size - Size to set
     */
    function setMaxLogStoreSize(size) {
        cordova.exec(success, failure, "BMSLogger", "setMaxLogStoreSize", [size]);
    }

    /**
     * Retrieves if the app crashed recently due to an uncaught exception. This property will be set back to false if the logs are sent to the server.
     * 
     * @param  {Function} callback - Callback function whose first parameter is the returned boolean value
     */
    function isUncaughtExceptionDetected(callback) {
        cordova.exec(callback, failure, "BMSLogger", "isUncaughtExceptionDetected", []);
    }

    /**
     * Send the logs to the Analytics server
     * 
     * @param  {Function} callback - Callback function called on success
     */
    function send(callback) {
        cordova.exec(callback, failure, "BMSLogger", "send", []);
    }

    return {
        getLogger: getLogger,
        getLogLevelFilter: getLogLevelFilter,
        setLogLevelFilter: setLogLevelFilter,
        sdkDebugLoggingEnabled: sdkDebugLoggingEnabled,
        setSDKDebugLogging: setSDKDebugLogging,
        getStoreLogs: getStoreLogs,
        setStoreLogs, setStoreLogs,
        getMaxLogStoreSize: getMaxLogStoreSize,
        setMaxLogStoreSize, setMaxLogStoreSize,
        isUncaughtExceptionDetected: isUncaughtExceptionDetected,
        send: send
    }
})();

BMSLogger.FATAL = "FATAL";
BMSLogger.ERROR = "ERROR";
BMSLogger.WARN = "WARN";
BMSLogger.INFO = "INFO";
BMSLogger.DEBUG = "DEBUG";

module.exports = BMSLogger;