var MFPRequest = function (url, method, timeout) {
    var exec = require("cordova/exec");
    this.TAG = "javascript-MFPRequest ";

    this._headers = {};
    this._queryParameters = {};
    this._url = url;
    this._method = method;
    this._timeout = timeout || 30000;
};

MFPRequest.GET = "GET";
MFPRequest.PUT = "PUT";
MFPRequest.POST = "POST";
MFPRequest.DELETE = "DELETE";
MFPRequest.TRACE = "TRACE";
MFPRequest.HEAD = "HEAD";
MFPRequest.OPTIONS = "OPTIONS";

MFPRequest.prototype = function () {

    /**
     *    Destructively modify an existing header name
     * @param name
     * @param value
     */
    var setHeaders = function (jsonObj) {
        //performant Deep Clone the json object
        this._headers = JSON.parse(JSON.stringify(jsonObj));
    };

    /**
     * Return a list of the value or all the values associated with the given header name
     * @param name
     * @returns {null, string}
     */
    var getHeaders = function () {
        return this._headers;
    };

    /**
     *
     * @returns {string}
     */
    var getUrl = function () {
        return this._url;
    };

    /**
     *
     * @returns {string}
     */
    var getMethod = function () {
        return this._method;
    };

    /**
     *
     * @returns {number}
     */
    var getTimeout = function () {
        return this._timeout;
    };

    /**
     *
     * @returns JSON
     */
    var getQueryParameters = function () {
        return this._queryParameters;
    };

    /**
     *
     * @param json_object
     */
    var setQueryParameters = function (jsonObj) {
        //performant Deep Clone the json object
        this._queryParameters = JSON.parse(JSON.stringify(jsonObj));
    };

    /**
     *
     * @param arg
     */
    var send = function (arg, success, failure) {

        var buildRequest = buildJSONRequest.bind(this);

        if (typeof arg === "function") {
            // Empty argument
            failure = success;
            success = arg;

            var cbSuccess = callbackWrap.bind(this, success);
            var cbFailure = callbackWrap.bind(this, failure);
            console.log(this.TAG + " send with empty body");

            cordova.exec(cbSuccess, cbFailure, "MFPRequest", "send", [buildRequest()]);
        } else if (typeof arg === "string" || typeof arg === "object") {
            var cbSuccess = callbackWrap.bind(this, success);
            var cbFailure = callbackWrap.bind(this, failure);
            // Input = String or JSON
            console.log(this.TAG + " send with string or object for the body");
            cordova.exec(cbSuccess, cbFailure, "MFPRequest", "send", [buildRequest(arg)]);
        }
    };

    /**
     *
     * @param callback The Success or Failure callback
     * @param jsonResponse string : The string-form JSON response coming from the Native SDK.
     */
    var callbackWrap = function (callback, jsonResponse) {
        var response = JSON.parse(jsonResponse);
        callback(response);
    };

    var buildJSONRequest = function (body) {
        var request = {};

        request.url = this.getUrl();
        request.method = this.getMethod();
        request.headers = this.getHeaders();
        request.timeout = this.getTimeout();
        request.queryParameters = this.getQueryParameters();
        request.body = "";

        if (typeof body === "string") {
            request.body = body;
        }
        else if (typeof body === "object") {
            request.body = JSON.stringify(body);
            if (!("Content-Type" in this._headers)) {
                request.headers["Content-Type"] = "application/json";
            }
        }
        //TODO update when Logger is complete
        console.log(this.TAG + " The request is: " + JSON.stringify(request));
        return request;
    };

    return {
        setHeaders: setHeaders,
        getHeaders: getHeaders,
        getUrl: getUrl,
        getMethod: getMethod,
        getTimeout: getTimeout,
        setQueryParameters: setQueryParameters,
        getQueryParameters: getQueryParameters,
        send: send
    }
}();

module.exports = MFPRequest;