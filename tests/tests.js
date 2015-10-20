exports.defineAutoTests = function () {
	describe('MFPCore test suite', function () {

		var fail = function (done, context, message) {
            if (context) {
                if (context.done) return;
                context.done = true;
            }

            if (message) {
                expect(false).toBe(true, message);
            } else {
                expect(false).toBe(true);
            }
            setTimeout(function () {
                done();
            });
    	};
        var succeed = function (done, context) {
            if (context) {
                if (context.done) return;
                context.done = true;
            }

            expect(true).toBe(true);

            setTimeout(function () {
                done();
            });
        };

		describe('BMSClient API', function() {

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
			it('should initialize and call the success callback', function(done) {
				spyOn(BMSClient, 'initialize').and.callFake(
					function(backendRoute, backendGuid) {
						cordova.exec(succeed.bind(null,done), fail.bind(null, done), "BMSClient", "initialize", [backendRoute, backendGuid]);
				});
				BMSClient.initialize("http://httpbin.org", "someGUID");
				
			}, 5000);
		});
		
		describe('MFPRequest API', function() {
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
			var TEST_URL = "http://httpbin.org"

			BMSClient.initialize(TEST_URL, "someGUID");

			beforeEach(function() {
				testRequest = new MFPRequest(TEST_URL, MFPRequest.GET, DEFAULT_TIMEOUT);
			});

			it('should correctly create a new request with correct URL and Method', function() {
				expect(testRequest._url).toEqual(TEST_URL);
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

			it('should retrieve the header object with getHeaders', function() {
				testRequest._headers = {"oneheader":"retrieve1",
										"twoheader": "retrieve2",
										"threeheader": "retrieve3"};

				expect(testRequest.getHeaders()).toEqual({"oneheader":"retrieve1",
															"twoheader": "retrieve2",
															"threeheader": "retrieve3"});
			});

			it('should retrieve the url with getUrl', function() {
				expect(testRequest.getUrl()).toEqual(TEST_URL);
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

			it('should send and invoke the success callback', function(done) {
				spyOn(testRequest, 'send').and.callThrough();
				testRequest.send(succeed.bind(null, done), fail.bind(null, done));
			}, 25000);

			it('should send and invoke the success callback', function(done) {
				spyOn(testRequest, 'send').and.callThrough();
				testRequest.send("stuff", succeed.bind(null, done), fail.bind(null, done));
			}, 25000);

		});

		describe('MFPLogger API', function() {
			it('should exist', function() {
				expect(MFPLogger).toBeDefined();
			});

			it('should have getInstance() and is a function', function() {
				expect(typeof MFPLogger.getInstance).toBeDefined();
				expect(typeof MFPLogger.getInstance == 'function').toBe(true);
			});

			it('should have getCapture() and is a function', function() {
				expect(typeof MFPLogger.getCapture).toBeDefined();
				expect(typeof MFPLogger.getCapture == 'function').toBe(true);
			});

			it('should have setCapture() and is a function', function() {
				expect(typeof MFPLogger.setCapture).toBeDefined();
				expect(typeof MFPLogger.setCapture == 'function').toBe(true);
			});

			it('should have getFilters() and is a function', function() {
				expect(typeof MFPLogger.getFilters).toBeDefined();
				expect(typeof MFPLogger.getFilters == 'function').toBe(true);
			});

			it('should have setFilters() and is a function', function() {
				expect(typeof MFPLogger.setFilters).toBeDefined();
				expect(typeof MFPLogger.setFilters == 'function').toBe(true);
			});

			it('should have getMaxStoreSize() and is a function', function() {
				expect(typeof MFPLogger.getMaxStoreSize).toBeDefined();
				expect(typeof MFPLogger.getMaxStoreSize == 'function').toBe(true);
			});

			it('should have setMaxStoreSize() and is a function', function() {
				expect(typeof MFPLogger.setMaxStoreSize).toBeDefined();
				expect(typeof MFPLogger.setMaxStoreSize == 'function').toBe(true);
			});

			it('should have getLevel() and is a function', function() {
				expect(typeof MFPLogger.getLevel).toBeDefined();
				expect(typeof MFPLogger.getLevel == 'function').toBe(true);
			});

			it('should have setLevel() and is a function', function() {
				expect(typeof MFPLogger.setLevel).toBeDefined();
				expect(typeof MFPLogger.setLevel == 'function').toBe(true);
			});

			it('should have isUncaughtExceptionDetected() and is a function', function() {
				expect(typeof MFPLogger.isUncaughtExceptionDetected).toBeDefined();
				expect(typeof MFPLogger.isUncaughtExceptionDetected == 'function').toBe(true);
			});

			it('should have send() and is a function', function() {
				expect(typeof MFPLogger.send).toBeDefined();
				expect(typeof MFPLogger.send == 'function').toBe(true);
			});
		});

		describe('Logger API', function() {
			var logger;

			beforeEach(function () {
				logger = MFPLogger.getInstance("logger-test");
			});

			it('should exist', function() {
				expect(logger).toBeDefined();
			});

			it('should have debug() and is a function', function() {
				expect(typeof logger.debug).toBeDefined();
				expect(typeof logger.debug == 'function').toBe(true);
			});

			it('should have info() and is a function', function() {
				expect(typeof logger.info).toBeDefined();
				expect(typeof logger.info == 'function').toBe(true);
			});

			it('should have error() and is a function', function() {
				expect(typeof logger.error).toBeDefined();
				expect(typeof logger.error == 'function').toBe(true);
			});

			it('should have warn() and is a function', function() {
				expect(typeof logger.warn).toBeDefined();
				expect(typeof logger.warn == 'function').toBe(true);
			});

			it('should have fatal() and is a function', function() {
				expect(typeof logger.fatal).toBeDefined();
				expect(typeof logger.fatal == 'function').toBe(true);
			});

			it('should have getName() and is a function', function() {
				expect(typeof logger.getName).toBeDefined();
				expect(typeof logger.getName == 'function').toBe(true);
			});
		});

		describe('MFPLogger behavior', function() {
			it('should create a new instance for a new name', function() {
				var log1 = MFPLogger.getInstance("logger1");
				var log2 = MFPLogger.getInstance("logger2");

				expect(log1).not.toBe(log2);
			});

			it('should retrieve the same internal instance if using the same name ', function() {
				var log1 = MFPLogger.getInstance("logger1");
				var log2 = MFPLogger.getInstance("logger1");

				expect(log1).toBe(log2);
			});


			it('should Set capture and invoke the success callback', function(done) {
				spyOn(MFPLogger, 'setCapture').and.callFake(function(enabled) {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPLogger", "setCapture", [enabled]);
				});
				MFPLogger.setCapture(true);
			}, 25000);


			it('should Set AND Get the capture flag correctly #1', function(done) {
				MFPLogger.setCapture(true);

				MFPLogger.getCapture(
					function(result) {
						// result should be a proper 'boolean'
						expect(typeof(result) == "boolean").toBe(true);
						// result should return the value that was previously set
						expect(result).toBe(true);
						done();
					},
					fail.bind(null, done));
			}, 25000);

			it('should Set AND Get the capture flag correctly #2', function(done) {
				MFPLogger.setCapture(false);

				MFPLogger.getCapture(
					function(result) {
						// result should be a proper 'boolean'
						expect(typeof(result) == "boolean").toBe(true);
						// result should return the value that was previously set
						expect(result).toBe(false);
						done();
					},
					fail.bind(null, done));
			}, 25000);

			it('should Set filters and invoke success callback', function(done) {
				spyOn(MFPLogger, 'setFilters').and.callFake(function(filters) {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPLogger", "setFilters", [filters]);
				});

				MFPLogger.setFilters({
					"stuff": MFPLogger.FATAL
				});

			}, 25000);

			it('should Set AND Get the filters correctly #1', function(done) {
				MFPLogger.setFilters({
					"pkgOne": MFPLogger.INFO,
					"pkgTwo": MFPLogger.DEBUG
				});

				MFPLogger.getFilters(
					function(filter) {
						// filter should be a proper 'object'
						expect(typeof(filter) == "object").toBe(true);
						// filter should return the value that was previously set
						expect(filter).toEqual(
							{
							"pkgOne": "INFO",
							"pkgTwo": "DEBUG"
							});
						done();
					},
					fail.bind(null, done));
			}, 25000);

			it('should Set Max Store Size and invoke the Succeed callback', function(done) {
				spyOn(MFPLogger, 'setMaxStoreSize').and.callFake(function(intSize) {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPLogger", "setMaxStoreSize", [intSize]);
				});
				MFPLogger.setMaxStoreSize(20000);
			}, 25000);

			it('should Set Max Store Size and Get the previously set value', function(done) {
				MFPLogger.setMaxStoreSize(20000);

				MFPLogger.getMaxStoreSize(
					function(intSize) {
						// intSize should be a proper int
						expect(typeof(intSize) == "number").toBe(true);
						// intSize should return the value that was previously set
						expect(intSize).toBe(20000);
						done();
					}, 
					fail.bind(null, done));
			}, 25000);


			it('should Set the Logger Level and invoke the Succeed callback', function(done) {
				spyOn(MFPLogger, 'setLevel').and.callFake(function(logLevel) {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPLogger", "setLevel", [logLevel]);
				});
				MFPLogger.setLevel(MFPLogger.FATAL);
			}, 25000);

			it('should Set and Get the logger level', function(done) {
				MFPLogger.setLevel(MFPLogger.ERROR);

				MFPLogger.getLevel(
					function(logLevel){
						// logLevel should be a proper String
						expect(typeof(logLevel) == "string").toBe(true);
						// logLevel should return the value that was previously set
						expect(logLevel).toBe(MFPLogger.ERROR);
						done();
					},
					fail.bind(null, done));
			}, 25000);

			it('should call isUncaughtExceptionDetected and invoke the Succeed callback', function(done) {
				MFPLogger.isUncaughtExceptionDetected(succeed.bind(null, done), fail.bind(null, done));
			}, 25000);

		});

		describe('MFPAnalytics API', function() {
			it('should exist', function() {
				expect(MFPAnalytics).toBeDefined();
			});

			it('should have enable() and is a function', function() {
				expect(typeof MFPAnalytics.enable).toBeDefined();
				expect(typeof MFPAnalytics.enable == 'function').toBe(true);
			});

			it('should have disable() and is a function', function() {
				expect(typeof MFPAnalytics.disable).toBeDefined();
				expect(typeof MFPAnalytics.disable == 'function').toBe(true);
			});

			it('should have isEnabled() and is a function', function() {
				expect(typeof MFPAnalytics.isEnabled).toBeDefined();
				expect(typeof MFPAnalytics.isEnabled == 'function').toBe(true);
			});

			it('should have send() and is a function', function() {
				expect(typeof MFPAnalytics.send).toBeDefined();
				expect(typeof MFPAnalytics.send == 'function').toBe(true);
			});

			// (TODO: For future release)
			xit('should have logEvent() and is a function', function() {
				expect(typeof MFPAnalytics.logEvent).toBeDefined();
				expect(typeof MFPAnalytics.logEvent == 'function').toBe(true);
			});
		});

		describe('MFPAnalytics behavior', function() {

			it('should Enable Analytics logging and invoke the Succeed callback', function(done) {
				spyOn(MFPAnalytics, 'enable').and.callFake(function() {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPAnalytics", "enable", []);
				});
				MFPAnalytics.enable();
			}, 5000);

			it('should disable Analytics logging and invoke the Succeed callback', function(done) {
				spyOn(MFPAnalytics, 'disable').and.callFake(function() {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "MFPAnalytics", "disable", []);
				});

				MFPAnalytics.disable();
			}, 5000);

			xit('should use isEnabled to get Capture flag and return the value to success callback', function(done) {
			}, 5000);

			it('should invoke failure callback if using send without setting up correctly', function(done) {
				spyOn(MFPAnalytics, 'send').and.callFake(function() {
					cordova.exec(fail.bind(null, done), succeed.bind(null, done), "MFPAnalytics", "send", []);
				});
				MFPAnalytics.send();
			}, 5000);
		});

	});
};