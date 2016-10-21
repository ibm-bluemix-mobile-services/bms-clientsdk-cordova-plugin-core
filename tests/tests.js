exports.defineAutoTests = function () {
	describe('BMSCore test suite', function () {

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
		
		describe('BMSRequest API', function() {
			var testRequest;

			beforeEach(function () {
				testRequest = new BMSRequest("url_test", "guid_test");
			});

			it('BMSRequest should exist', function() {
				expect(BMSRequest).toBeDefined();
			});

			it('BMSRequest.getUrl() should exist and is a function', function() {
				expect(typeof testRequest.getUrl).toBeDefined();
				expect(typeof testRequest.getUrl == 'function').toBe(true);
			});

			it('BMSRequest.getMethod() should exist and is a function', function() {
				expect(typeof testRequest.getMethod).toBeDefined();
				expect(typeof testRequest.getMethod == 'function').toBe(true);
			});

			it('BMSRequest.getTimeout() should exist and is a function', function() {
				expect(typeof testRequest.getTimeout).toBeDefined();
				expect(typeof testRequest.getTimeout == 'function').toBe(true);
			});

			it('BMSRequest.getQueryParameters() should exist and is a function', function() {
				expect(typeof testRequest.getQueryParameters).toBeDefined();
				expect(typeof testRequest.getQueryParameters == 'function').toBe(true);
			});
			it('BMSRequest.setQueryParameters() should exist and is a function', function() {
				expect(typeof testRequest.setQueryParameters).toBeDefined();
				expect(typeof testRequest.setQueryParameters == 'function').toBe(true);
			});

			it('BMSRequest.getheaders() should exist and is a function', function() {
				expect(typeof testRequest.getHeaders).toBeDefined();
				expect(typeof testRequest.getHeaders == 'function').toBe(true);
			});
			it('BMSRequest.setHeaders() should exist and is a function', function() {
				expect(typeof testRequest.setHeaders).toBeDefined();
				expect(typeof testRequest.setHeaders == 'function').toBe(true);
			});

			it('BMSRequest.send() should exist and is a function', function() {
				expect(typeof testRequest.send).toBeDefined();
				expect(typeof testRequest.send == 'function').toBe(true);
			});

		});

		describe('BMSRequest behavior', function() {
			var testRequest;
			var DEFAULT_TIMEOUT = 30000;
			var TEST_URL = "http://httpbin.org"

			BMSClient.initialize(TEST_URL, "someGUID");

			beforeEach(function() {
				testRequest = new BMSRequest(TEST_URL, BMSRequest.GET, DEFAULT_TIMEOUT);
			});

			it('should correctly create a new request with correct URL and Method', function() {
				expect(testRequest._url).toEqual(TEST_URL);
				expect(testRequest._method).toEqual(BMSRequest.GET);
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
				expect(testRequest.getMethod()).toEqual(BMSRequest.GET);
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

		describe('BMSLogger API', function() {
			it('should exist', function() {
				expect(BMSLogger).toBeDefined();
			});

			it('should have getInstance() and is a function', function() {
				expect(typeof BMSLogger.getLogger).toBeDefined();
				expect(typeof BMSLogger.getLogger == 'function').toBe(true);
			});

			it('should have storeLogs() and is a function', function() {
				expect(typeof BMSLogger.storeLogs).toBeDefined();
				expect(typeof BMSLogger.storeLogs == 'function').toBe(true);
			});


			it('should have getMaxLogStoreSize() and is a function', function() {
				expect(typeof BMSLogger.getMaxLogStoreSize).toBeDefined();
				expect(typeof BMSLogger.getMaxLogStoreSize == 'function').toBe(true);
			});

			it('should have setMaxLogStoreSize() and is a function', function() {
				expect(typeof BMSLogger.setMaxLogStoreSize).toBeDefined();
				expect(typeof BMSLogger.setMaxLogStoreSize == 'function').toBe(true);
			});

			it('should have getLogLevel() and is a function', function() {
				expect(typeof BMSLogger.getLogLevel).toBeDefined();
				expect(typeof BMSLogger.getLogLevel == 'function').toBe(true);
			});

			it('should have setLogLevel() and is a function', function() {
				expect(typeof BMSLogger.setLogLevel).toBeDefined();
				expect(typeof BMSLogger.setLogLevel == 'function').toBe(true);
			});

			it('should have isUncaughtExceptionDetected() and is a function', function() {
				expect(typeof BMSLogger.isUncaughtExceptionDetected).toBeDefined();
				expect(typeof BMSLogger.isUncaughtExceptionDetected == 'function').toBe(true);
			});

			it('should have send() and is a function', function() {
				expect(typeof BMSLogger.send).toBeDefined();
				expect(typeof BMSLogger.send == 'function').toBe(true);
			});

			it('should have isStoringLogs() and is a function', function() {
				expect(typeof BMSLogger.isStoringLogs).toBeDefined();
				expect(typeof BMSLogger.isStoringLogs == 'function').toBe(true);
			});

			it('should have setSDKDebugLoggingEnabled() and is a function', function() {
				expect(typeof BMSLogger.setSDKDebugLoggingEnabled).toBeDefined();
				expect(typeof BMSLogger.setSDKDebugLoggingEnabled == 'function').toBe(true);
			});

			it('should have isSDKDebugLoggingEnabled() and is a function', function() {
				expect(typeof BMSLogger.isSDKDebugLoggingEnabled).toBeDefined();
				expect(typeof BMSLogger.isSDKDebugLoggingEnabled == 'function').toBe(true);
			});
		});

		describe('Logger API', function() {
			var logger;

			beforeEach(function () {
				logger = BMSLogger.getLogger("logger-test");
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

		describe('BMSLogger behavior', function() {
			beforeEach(function () {
				cordova.exec(succeed.bind(null, done), fail.bind(null, done), "BMSAnalytics", "initialize", ["dummyApp",
					"dummyApiKey", true, [BMSAnalytics.ALL] ]);

				BMSAnalytics.initialize('dummyApp', 'dummyApiKey', true, [BMSAnalytics.ALL])
			}, 5000);
			
			it('should create a new instance for a new name', function() {
				var log1 = BMSLogger.getLogger("logger1");
				var log2 = BMSLogger.getLogger("logger2");

				expect(log1).not.toBe(log2);
			});

			it('should retrieve the same internal instance if using the same name ', function() {
				var log1 = BMSLogger.getLogger("logger1");
				var log2 = BMSLogger.getLogger("logger1");

				expect(log1).toBe(log2);
			});


			it('should store logs and invoke the success callback', function(done) {
				spyOn(BMSLogger, 'storeLogs').and.callFake(function(enabled) {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "BMSLogger", "storeLogs", [enabled]);
				});
				BMSLogger.storeLogs(true);
			}, 25000);


			it('should Set AND Get the capture flag correctly #1', function(done) {
				BMSLogger.storeLogs(true);

				BMSLogger.isStoringLogs(
					function(result) {
						// result should be a proper 'integer'
						expect(typeof(result) == "integer").toBe(true);
						// result should return the value that was previously set
						expect(result).toBe(1);
						done();
					},
					fail.bind(null, done));
			}, 25000);

			it('should Set AND Get the capture flag correctly #2', function(done) {
				BMSLogger.storeLogs(false);

				BMSLogger.isStoringLogs(
					function(result) {
						// result should be a proper 'integer'
						expect(typeof(result) == "integer").toBe(true);
						// result should return the value that was previously set
						expect(result).toBe(0);
						done();
					},
					fail.bind(null, done));
			}, 25000);


			it('should Set Max Log Store Size and invoke the Succeed callback', function(done) {
				spyOn(BMSLogger, 'setMaxLogStoreSize').and.callFake(function(intSize) {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "BMSLogger", "setMaxLogStoreSize", [intSize]);
				});
				BMSLogger.setMaxLogStoreSize(20000);
			}, 25000);

			it('should Set Max Log Store Size and Get the previously set value', function(done) {
				BMSLogger.setMaxLogStoreSize(20000);

				BMSLogger.getMaxLogStoreSize(
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
				spyOn(BMSLogger, 'setLogLevel').and.callFake(function(logLevel) {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "BMSLogger", "setLogLevel", [logLevel]);
				});
				BMSLogger.setLogLevel(BMSLogger.FATAL);
			}, 25000);0

			it('should Set and Get the logger level', function(done) {
				BMSLogger.setLogLevel(BMSLogger.ERROR);

				BMSLogger.getLogLevel(
					function(logLevel){
						// logLevel should be a proper String
						expect(typeof(logLevel) == "string").toBe(true);
						// logLevel should return the value that was previously set
						expect(logLevel).toBe(BMSLogger.ERROR);
						done();
					},
					fail.bind(null, done));
			}, 25000);

			it('should call isUncaughtExceptionDetected and invoke the Succeed callback', function(done) {
				BMSLogger.isUncaughtExceptionDetected(succeed.bind(null, done), fail.bind(null, done));
			}, 25000);

		});

		describe('BMSAnalytics API', function() {
			beforeEach(function () {
				cordova.exec(succeed.bind(null, done), fail.bind(null, done), "BMSAnalytics", "initialize", ["dummyApp",
					"dummyApiKey", true, [BMSAnalytics.ALL] ]);

				BMSAnalytics.initialize('dummyApp', 'dummyApiKey', true, [BMSAnalytics.ALL])
			}, 5000);

			it('should exist', function() {
				expect(BMSAnalytics).toBeDefined();
			});

			it('should have enable() and is a function', function() {
				expect(typeof BMSAnalytics.enable).toBeDefined();
				expect(typeof BMSAnalytics.enable == 'function').toBe(true);
			});

			it('should have disable() and is a function', function() {
				expect(typeof BMSAnalytics.disable).toBeDefined();
				expect(typeof BMSAnalytics.disable == 'function').toBe(true);
			});

			it('should have isEnabled() and is a function', function() {
				expect(typeof BMSAnalytics.isEnabled).toBeDefined();
				expect(typeof BMSAnalytics.isEnabled == 'function').toBe(true);
			});

			it('should have send() and is a function', function() {
				expect(typeof BMSAnalytics.send).toBeDefined();
				expect(typeof BMSAnalytics.send == 'function').toBe(true);
			});

			it('should have log() and is a function', function() {
				expect(typeof BMSAnalytics.log).toBeDefined();
				expect(typeof BMSAnalytics.log == 'function').toBe(true);
			});
			
			it('should have initialize() and is a function', function() {
				expect(typeof BMSAnalytics.initialize).toBeDefined();
				expect(typeof BMSAnalytics.initialize == 'function').toBe(true);
			});

			it('should have setUserIdentity() and is a function', function() {
				expect(typeof BMSAnalytics.setUserIdentity).toBeDefined();
				expect(typeof BMSAnalytics.setUserIdentity == 'function').toBe(true);
			});


		});

		describe('BMSAnalytics behavior', function() {

			it('should Enable Analytics logging and invoke the Succeed callback', function(done) {
				spyOn(BMSAnalytics, 'enable').and.callFake(function() {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "BMSAnalytics", "enable", []);
				});
				BMSAnalytics.enable();
			}, 5000);

			it('should disable Analytics logging and invoke the Succeed callback', function(done) {
				spyOn(BMSAnalytics, 'disable').and.callFake(function() {
					cordova.exec(succeed.bind(null, done), fail.bind(null, done), "BMSAnalytics", "disable", []);
				});

				BMSAnalytics.disable();
			}, 5000);

			it('should use isEnabled to get Capture flag and return the value to success callback', function(done) {
			}, 5000);

			it('should invoke failure callback if using send without setting up correctly', function(done) {
				spyOn(BMSAnalytics, 'send').and.callFake(function() {
					cordova.exec(fail.bind(null, done), succeed.bind(null, done), "BMSAnalytics", "send", []);
				});
				BMSAnalytics.send();
			}, 5000);
		});
	});
};