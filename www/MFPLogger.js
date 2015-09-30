//TODO: Uncomment line below
//var exec = require("cordova/exec");

var MFPLogger = (function () {
    var instance = {};

    function createInstance(name) {
        var logger = new Logger(name);
        return logger;
    }

    this.getInstance = function (name) {
        if (!instance[name]) {
            instance[name] = createInstance(name);
        }
        console.log("instance Dicgtionary is:" + JSON.stringify(instance));

        return instance[name];
    };

    this.getCapture = function () {
        //return capture;
    };

    this.setCapture = function (capture) {
        //this.capture = capture;
    };

    this.getFilters = function () {

    };

    this.setFilters = function (filter) {

    };

    this.getMaxStoreSize = function () {
        //return maxStoreSize;
    };

    this.setMaxStoreSize = function () {
        //return maxStoreSize;
    };

    this.getLevel = function () {
        //return level;
    };

    this.setLevel = function (level) {
        //this.level = level;
    };

    this.isUncaughtExceptionDetected = function () {

    };

    this.send = function () {

    };

    return {
        getInstance : getInstance,
        getCapture : getCapture,
        setCapture : setCapture,
        getFilters : getFilters,
        setFilters : setFilters,
        getMaxStoreSize : getMaxStoreSize,
        setMaxStoreSize : setMaxStoreSize,
        getLevel : getLevel,
        setLevel : setLevel,
        isUncaughtExceptionDetected : isUncaughtExceptionDetected,
        send : send
    };
})();

MFPLogger.FATAL = "FATAL";
MFPLogger.ERROR = "ERROR";
MFPLogger.WARN = "WARN";
MFPLogger.INFO = "INFO";
MFPLogger.DEBUG = "DEBUG";



var Logger = function (name){
    this.name = name; // instance variable
};

Logger.prototype = function(){
    var func1 = function(){console.log("Hello from func1 " + this.name)};
    var func2 = function(){console.log("Hello from func2 " + this.name)};

    var debug = function () {

    }

    var info = function () {

    }

    var error = function () {

    }

    var fatal = function () {

    }

    var warn = function () {

    }

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




/////////////////////////////


function run() {

    var instance1 = MFPLogger.getInstance("Larry");
    var instance2 = MFPLogger.getInstance("Serge");

    console.log("Same instance? " + (instance1 === instance2));
    console.log(instance1);
    console.log(instance2);

    var instance3 = MFPLogger.getInstance("Larry");
    var instance4 = MFPLogger.getInstance("Serge");

    console.log("Same instance? " + (instance1 === instance3));
    console.log("Same instance? " + (instance2 === instance4));

    instance1.func1();
    instance2.func1();
    instance3.func1();
    instance4.func1();

    instance1.func2();
    instance2.func2();
    instance3.func2();
    instance4.func2();

}

run();

//TODO: Uncomment line below
//module.exports = new MFPLogger();

