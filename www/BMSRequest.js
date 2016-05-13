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

/**
 * Build and send HTTP network requests
 * 
 * @param {String} url - URL endpoint for the request
 * @param {String} method - Type of HTTP request to be made. Use BMSRequest.METHOD 
 * @param {Integer} timeout - Request timeout in ms
 */
var BMSRequest = function(url, method, timeout, followRedirects) {
	this.headers = {};
	this.queryParameters = {};
	this.url = url;
	this.method = method;
	this.timeout = timeout || 20000
	this.followRedirects = followRedirects || true
}

BMSRequest.GET = "GET";
BMSRequest.POST = "POST";
BMSRequest.PUT = "PUT";
BMSRequest.DELETE = "DELETE";
BMSRequest.TRACE = "TRACE";
BMSRequest.HEAD = "HEAD";
BMSRequest.OPTIONS = "OPTIONS";
BMSRequest.CONNECT = "CONNECT";
BMSRequest.PATCH = "PATCH";

BMSRequest.prototype = function() {

	/**
	 * Returns the headers for the request
	 * 
	 * @return {Object}
	 */
	var getHeaders = function() {
		return this.headers;
	}

	/**
	 * Sets the headers for the request
	 * 
	 * @param {Object} myHeaders - Request headers as key/value pairs
	 */
	var setHeaders = function(headers) {
		this.headers = JSON.parse(JSON.stringify(headers));
	}

	/**
	 * Returns the query parameters for the request
	 *
	 * @return {Object}
	 */
	var getQueryParameters = function() {
		return this.queryParameters;
	}

	/**
	 * Sets the query parameters for the request
	 * 
	 * @param {Object} myQueryParameters - Request parameters are key/value pairs
	 */
	var setQueryParameters = function(queryParameters) {
		this.queryParameters = JSON.parse(JSON.stringify(queryParameters));
	}

	/**
	 * Returns the url of the request
	 * 
	 * @return {String}
	 */
	var getURL = function() {
		return this.url;
	}

	/**
	 * Returns the HTTP method of the request
	 * 
	 * @return {String}
	 */
	var getMethod = function() {
		return this.method;
	}

	/**
	 * Returns the timeout of the request in ms
	 * 
	 * @return {Integer}
	 */
	var getTimeout = function() {
		return this.timeout;
	}

	/**
	 * Sets the timeout of the request
	 * 
	 * @param {Integer} timeout - Value of timeout in ms
	 */
	var setTimeout = function(timeout) {
		this.timeout = timeout;
	}

	/**
     * Sends the request asynchronously
     * 
     * @param body (Optional) - The body supplied as either a string or an object
     * @param success - The success callback that was supplied
     * @param failure - The failure callback that was supplied
     */
	var send = function() {

		var buildRequest = buildJSONRequest.bind(this);

		if (arguments.length === 2) {
			// Empty body
			var cbSuccess = callbackWrap.bind(this, arguments[0]);
			var cbFailure = callbackWrap.bind(this, arguments[1]);

			cordova.exec(cbSuccess, cbFailure, "BMSRequest", "send", [buildRequest()]);
		}
		else if (arguments.length >= 3) {
			// Non-empty body
			var cbSuccess = callbackWrap.bind(this, arguments[1]);
			var cbFailures = callbackWrap.bind(this, arguments[2]);

			cordova.exec(cbSuccess, cbFailure, "BMSRequest", "send", [buildRequest(arguments[0])]);
		}
		else {
			console.log("BMSRequest: Error: Function requires success and failure callback functions");
		}
	}

	/**
	 * Function that invokes the callback of the send function
	 * 
	 * @param  {Function} callback - The success or failure callback
	 * @param  {JSON Object} jsonResponse - The JSON object response coming from the native SDK
	 */
	var callbackWrap = function(callback, jsonResponse) {
		callback && callback(jsonResponse);
	}

	/**
	 * Construct the request before sending to the native SDK
	 * 
	 * @param  {String} body [description]
	 * @return {Object} The request object to send to the native SDK
	 */
	var buildJSONRequest = function(body) {
		var request = {
			url: this.url,
			method: this.method,
			timeout: this.timeout,
			headers: this.headers,
			queryParameters: this.queryParameters,
			followRedirects: this.followRedirects,
		};

		if (typeof body === "string") {
			request.body = body;
		}
		else if (typeof body === "object") {
			request.body = JSON.stringify(body);
			if (!("Content-Type" in this.headers)) {
				request.headers["Content-Type"] = "application/json";
			}
		}
		else {
			request.body = "";
		}

		return request;
	}

	return {
		getHeaders: getHeaders,
		setHeaders: setHeaders,
		getQueryParameters: getQueryParameters,
		setQueryParameters: setQueryParameters,
		getURL: getURL,
		getMethod: getMethod,
		getTimeout: getTimeout,
		setTimeout: setTimeout,
		send: send
	}
}();

module.exports = BMSRequest;