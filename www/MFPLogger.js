//TODO: Uncomment line below
var exec = require("cordova/exec");

var Logger = function (name){
    this.name = name; // instance variable
};

Logger.prototype = function(){
    var func1 = function(){console.log("Hello from func1 " + this.name)};
    var func2 = function(){console.log("Hello from func2 " + this.name)};

    var debug = function () {}

    var info = function () {}

    var error = function () {}

    var fatal = function () {}

    var warn = function () {}

    // retun the public interface
    return {
        func1 : func1,
        func2 : func2,

        debug : debug,
        info : info,
        error : error,
        fatal : fatal,
        warn : warn
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
            return instances[name];
        },
        getCapture : function () {

        },
        setCapture : function (capture) {},
        getFilters : function () {},
        setFilters : function (filter) {},
        getMaxStoreSize : function () {},
        setMaxStoreSize : function () {},
        getLevel : function () {},
        setLevel : function (level) {},
        isUncaughtExceptionDetected : function () {},
        send : function () {}
    };
});
MFPLogger.FATAL = "FATAL";
MFPLogger.ERROR = "ERROR";
MFPLogger.WARN = "WARN";
MFPLogger.INFO = "INFO";
MFPLogger.DEBUG = "DEBUG";

module.exports = new MFPLogger();