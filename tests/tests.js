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

			it('BMSClient.getBluemixAppRoute() should exist and is a function', function(){
				expect(typeof BMSClient.getBluemixAppRoute).toBeDefined();
				expect(typeof BMSClient.getBluemixAppRoute == 'function').toBe(true);
			});

			it('BMSClient.getBluemixAppGUID() should exist and is a function', function(){
				expect(typeof BMSClient.getBluemixAppGUID).toBeDefined();
				expect(typeof BMSClient.getBluemixAppGUID == 'function').toBe(true);
			});

			it('BMSClient.registerAuthenticationListener() should exist and is a function', function(){
				expect(typeof BMSClient.registerAuthenticationListener).toBeDefined();
				expect(typeof BMSClient.registerAuthenticationListener == 'function').toBe(true);
			});

			it('BMSClient.unregisterAuthenticationListener() should exist and is a function', function(){
				expect(typeof BMSClient.unregisterAuthenticationListener).toBeDefined();
				expect(typeof BMSClient.unregisterAuthenticationListener == 'function').toBe(true);
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

			it('MFPRequest.getUrl() should exist and is a function', function() {
				expect(typeof testRequest.getUrl).toBeDefined();
				expect(typeof testRequest.getUrl == 'function').toBe(true);
			});

			it('MFPRequest.getMethod() should exist and is a function', function() {
				expect(typeof testRequest.getMethod).toBeDefined();
				expect(typeof testRequest.getMethod == 'function').toBe(true);
			});

			it('MFPRequest.getTimeout() should exist and is a function', function() {
				expect(typeof testRequest.getTimeout).toBeDefined();
				expect(typeof testRequest.getTimeout == 'function').toBe(true);
			});

			it('MFPRequest.getQueryParameters() should exist and is a function', function() {
				expect(typeof testRequest.getQueryParameters).toBeDefined();
				expect(typeof testRequest.getQueryParameters == 'function').toBe(true);
			});
			it('MFPRequest.setQueryParameters() should exist and is a function', function() {
				expect(typeof testRequest.setQueryParameters).toBeDefined();
				expect(typeof testRequest.setQueryParameters == 'function').toBe(true);
			});

			it('MFPRequest.getheaders() should exist and is a function', function() {
				expect(typeof testRequest.getHeaders).toBeDefined();
				expect(typeof testRequest.getHeaders == 'function').toBe(true);
			});
			it('MFPRequest.setHeaders() should exist and is a function', function() {
				expect(typeof testRequest.setHeaders).toBeDefined();
				expect(typeof testRequest.setHeaders == 'function').toBe(true);
			});

			it('MFPRequest.send() should exist and is a function', function() {
				expect(typeof testRequest.send).toBeDefined();
				expect(typeof testRequest.send == 'function').toBe(true);
			});

		});

		describe('MFPRequest behavior', function() {
			var testRequest;
			var DEFAULT_TIMEOUT = 30000;

			beforeEach(function() {
				testRequest = new MFPRequest("http://www.google.com", MFPRequest.GET, DEFAULT_TIMEOUT);
			});

			it('should correctly create a new request with correct URL and Method', function() {
				expect(testRequest._url).toEqual("http://www.google.com");
				expect(testRequest._method).toEqual(MFPRequest.GET);
			});

			it('should have a default timeout of ' + DEFAULT_TIMEOUT + ' milliseconds', function() {
				expect(testRequest._timeout).toBe(DEFAULT_TIMEOUT);
			});

			it('should set headers with setHeaders', function() {
				testRequest.setHeaders({"headername1":"headervalue1", 
										"headername2": "headervalue2"});

				expect(testRequest._headers.headername1).toBeDefined();
				expect(testRequest._headers.headername2).toBeDefined();
				expect(testRequest._headers.headername1).toEqual("headervalue1");
				expect(testRequest._headers.headername2).toEqual("headervalue2");
			});

			it('should retrieve the header object with getAllHeaders', function() {
				testRequest._headers = {"oneheader":"retrieve1",
										"twoheader": "retrieve2",
										"threeheader": "retrieve3"};

				expect(testRequest.getHeaders()).toEqual({"oneheader":"retrieve1",
															"twoheader": "retrieve2",
															"threeheader": "retrieve3"});
			});

			it('should retrieve the url with getUrl', function() {
				expect(testRequest.getUrl()).toEqual("http://www.google.com");
			});

			it('should retrieve the method with getMethod', function() {
				expect(testRequest.getMethod()).toEqual(MFPRequest.GET);
			});

			it('should retrieve the timeout with getTimeout', function() {
				expect(testRequest.getTimeout()).toBe(DEFAULT_TIMEOUT);
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

		});

	});
};