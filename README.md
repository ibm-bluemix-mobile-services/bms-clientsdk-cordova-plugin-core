# IBM Bluemix Mobile Services - Client SDK Cordova

A brief description of our plugin here.

## Installation
```
$ cordova plugin install ibm-mfp-core
```
## Examples

### To initialize:
(Explain line of code below this line)
```
BMSClient.initialize("https://myapp.mybluemix.net", "abcd12345abcd12345");
```

### Creating a Request. 
To create a new MFPRequest instance... (Explain line of code below this line)
```
var request = new MFPRequest("/myapp/API/action", MFPRequest.GET);
```

### Setting the headers for your request. 
(More Explanation of code snippet below this line)
```
var headers = {
    header1: ["val1"]
    header2: ["val2", "val3"]
}
request.setHeaders(headers)
```

### Setting your MFPRequest's query parameters
```
var queryParams = {
    param1: "val1",
    param2: "val2
}
request.setQueryParameters(queryParams)
```

###Sending the request
(A more detailed explanation here. Elaborate on the Response)

```
request.send("some body",
    function(successResponse){
        console.log("status :: " + successResponse.status);
        console.log("headers :: " + successResponse.headers);
    }, 
    function (failureResponse){
        console.log("errorCode:: " + failureResponse.errorCode);
        console.log("errorDescription :: " + failureResponse.errorDescription);
    }
)
```

The successResponse or failureResponse are JSON objects that will be passed to your callbacks with the following fields:

```
response.status  =>  Integer
response.responseText  =>  Undefined or String
response.headers  =>  Object
response.errorCode  =>  Integer 
response.errorDescription  =>  Undefined or String
```

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