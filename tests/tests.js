exports.defineAutoTests = function () {
	describe('MFPCore test suite', function () {

		describe('BMSClient method definitions', function() {

			it('BMSClient should exist', function(){
				expect(BMSClient).toBeDefined();
			});

			it('BMSClient.initialize() should exist and is a function', function(){
				expect(typeof BMSClient.initialize).toBeDefined();
				expect(typeof BMSClient.initialize == 'function').toBe(true);
			});

			it('BMSClient.registerAuthenticationListener() should exist and is a function', function(){
				expect(typeof BMSClient.registerAuthenticationListener).toBeDefined();
				expect(typeof BMSClient.registerAuthenticationListener == 'function').toBe(true);
			});

			it('BMSClient.unregisterAuthenticationListener() should exist and is a function', function(){
				expect(typeof BMSClient.unregisterAuthenticationListener).toBeDefined();
				expect(typeof BMSClient.unregisterAuthenticationListener == 'function').toBe(true);
			});

			it('BMSClient.version() should exist and is a function', function(){
				expect(typeof BMSClient.version).toBeDefined();
				expect(typeof BMSClient.version == 'function').toBe(true);
			});
		});

		describe('BMSClient behavior', function() {
			//TODO: Pending
			xit('TODO: should...', function() {
				BMSClient.initialize("", "");
				//BMSClient
			});
		});

		describe('MFPRequest method definitions', function() {
			var testRequest;

			beforeEach(function () {
				testRequest = new MFPRequest("url_test", "guid_test");
			});

			it('MFPRequest should exist', function() {
				expect(MFPRequest).toBeDefined();
			});

			it('MFPRequest.addHeader() should exist and is a function', function() {
				expect(typeof testRequest.addHeader).toBeDefined();
				expect(typeof testRequest.addHeader == 'function').toBe(true);
			});
			it('MFPRequest.setHeader() should exist and is a function', function() {
				expect(typeof testRequest.setHeader).toBeDefined();
				expect(typeof testRequest.setHeader == 'function').toBe(true);
			});
			it('MFPRequest.removeHeaders() should exist and is a function', function() {
				expect(typeof testRequest.removeHeaders).toBeDefined();
				expect(typeof testRequest.removeHeaders == 'function').toBe(true);
			});
			it('MFPRequest.getHeaderNames() should exist and is a function', function() {
				expect(typeof testRequest.getHeaderNames).toBeDefined();
				expect(typeof testRequest.getHeaderNames == 'function').toBe(true);
			});
			it('MFPRequest.getHeader() should exist and is a function', function() {
				expect(typeof testRequest.getHeader).toBeDefined();
				expect(typeof testRequest.getHeader == 'function').toBe(true);
			});
			it('MFPRequest.getheaders() should exist and is a function', function() {
				expect(typeof testRequest.getHeaders).toBeDefined();
				expect(typeof testRequest.getHeaders == 'function').toBe(true);
			});
			it('MFPRequest.getAllHeaders() should exist and is a function', function() {
				expect(typeof testRequest.getAllHeaders).toBeDefined();
				expect(typeof testRequest.getAllHeaders == 'function').toBe(true);
			});
			it('MFPRequest.getUrl() should exist and is a function', function() {
				expect(typeof testRequest.getUrl).toBeDefined();
				expect(typeof testRequest.getUrl == 'function').toBe(true);
			});
			it('MFPRequest.getMethod() should exist and is a function', function() {
				expect(typeof testRequest.getMethod).toBeDefined();
				expect(typeof testRequest.getMethod == 'function').toBe(true);
			});
			it('MFPRequest.setTimeout() should exist and is a function', function() {
				expect(typeof testRequest.setTimeout).toBeDefined();
				expect(typeof testRequest.setTimeout == 'function').toBe(true);
			});
			it('MFPRequest.getTimeout() should exist and is a function', function() {
				expect(typeof testRequest.getTimeout).toBeDefined();
				expect(typeof testRequest.getTimeout == 'function').toBe(true);
			});
			it('MFPRequest.getQueryParameters() should exist and is a function', function() {
				expect(typeof testRequest.getQueryParameters).toBeDefined();
				expect(typeof testRequest.getQueryParameters == 'function').toBe(true);
			});
			it('MFPRequest.setQueryParameter() should exist and is a function', function() {
				expect(typeof testRequest.setQueryParameter).toBeDefined();
				expect(typeof testRequest.setQueryParameter == 'function').toBe(true);
			});
			it('MFPRequest.setQueryParameters() should exist and is a function', function() {
				expect(typeof testRequest.setQueryParameters).toBeDefined();
				expect(typeof testRequest.setQueryParameters == 'function').toBe(true);
			});
		});

		describe('MFPRequest behavior', function() {
			var testRequest;
			var DEFAULT_TIMEOUT = 60000;

			beforeEach(function() {
				testRequest = new MFPRequest("http://www.google.com", MFPRequest.GET);
			});

			it('should correctly create a new request with correct URL and Method', function() {
				expect(testRequest._url).toEqual("http://www.google.com");
				expect(testRequest._method).toEqual(MFPRequest.GET);
			});

			it('should have a default timeout of ' + DEFAULT_TIMEOUT + ' milliseconds', function() {
				expect(testRequest._timeout).toBe(DEFAULT_TIMEOUT);
			});

			it('should add a header with addHeader', function() {
				testRequest.addHeader("someheader", "somevalue");

				expect(testRequest._headers.someheader).toBeDefined();
				expect(testRequest._headers.someheader).toEqual(["somevalue"]);
			});

			it('should change headers with setHeader', function() {
				testRequest.setHeader("newheader", "newvalue");

				expect(testRequest._headers.newheader).toBeDefined();
				expect(testRequest._headers.newheader).toEqual(["newvalue"]);
			});

			it('should remove headers with removeHeaders', function() {
				testRequest.addHeader("someheader", "somevalue1");
				testRequest.addHeader("someheader", "somevalue2");
				testRequest.removeHeaders("someheader");
				
				expect(testRequest._headers.someheader).not.toBeDefined();
				expect(testRequest._headers).toEqual( {} );
			});

			it('should retrieve a header value with getHeader', function() {
				testRequest.addHeader("someheader", "testRetrieve");

				expect(testRequest.getHeader("someheader")).toEqual("testRetrieve");
			});

			it('should retrieve a list of header names with getHeaderNames', function() {
				testRequest.addHeader("someheader", "retrieve1");
				testRequest.addHeader("anotherheader", "retrieve2");
				testRequest.addHeader("newheader", "retrieve3");

				expect(testRequest.getHeaderNames()).toEqual(["someheader", "anotherheader", "newheader"]);
			});

			it('should retrieve the header object with getAllHeaders', function() {
				testRequest.addHeader("oneheader", "retrieve1");
				testRequest.addHeader("twoheader", "retrieve2");
				testRequest.addHeader("threeheader", "retrieve3");

				expect(testRequest.getAllHeaders()).toEqual({"oneheader":["retrieve1"],
															"twoheader": ["retrieve2"],
															"threeheader": ["retrieve3"]});
			});

			it('should retrieve the url with getUrl', function() {
				expect(testRequest.getUrl()).toEqual("http://www.google.com");
			});

			it('should retrieve the method with getMethod', function() {
				expect(testRequest.getMethod()).toEqual(MFPRequest.GET);
			});

			it('should set the timeout with setTimeout', function() {
				testRequest.setTimeout(45*1000);
				expect(testRequest._timeout).toBe(45000);
			});

			it('should retrieve the timeout with getTimeout', function() {
				expect(testRequest.getTimeout()).toBe(DEFAULT_TIMEOUT);
			});

			it('should set a query parameter with setQueryParameter', function() {
				testRequest.setQueryParameter("singlequery", "singlevalue");
				expect(testRequest.getQueryParameters()).toEqual({singlequery: "singlevalue"});
			});

			it('should set the query parameters with setQueryParameters', function() {
				testRequest.setQueryParameters({"somequery": "somevalue", "anotherquery": "anothervalue"});
				expect(testRequest._queryParameters).toEqual({"somequery": "somevalue", "anotherquery": "anothervalue"});
			});

			it('should retrieve the list of query parameters with getQueryParameters', function() {
				testRequest._queryParameters.somequery = "somevalue";
				testRequest._queryParameters.anotherquery = "anothervalue";
				expect(testRequest.getQueryParameters()).toEqual({"somequery": "somevalue", "anotherquery": "anothervalue"});
			});

			//TODO
			xit('should correctly send a request (no headers and no query parameters) with send', function() {});

			xit('should correctly send a request (with headers and no query parameters) with send', function() {});

			xit('should correctly send a request (with headers and query parameters) with send', function() {});

			//TODO
			xit('should correctly send a form request with sendFormParameters', function() {});

			it('buildRequest - private method - should build and return an object correctly', function() {
				var serializedRequest = testRequest.buildRequest();

				expect(serializedRequest.url).toEqual(testRequest.getUrl());
				expect(serializedRequest.method).toEqual(testRequest.getMethod());
				expect(serializedRequest.headers).toEqual(testRequest.getAllHeaders());
				expect(serializedRequest.timeout).toEqual(testRequest.getTimeout());
				expect(serializedRequest.queryParameters).toEqual(testRequest.getQueryParameters());
			});
		});

	});
};