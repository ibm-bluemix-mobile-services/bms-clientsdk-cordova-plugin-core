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

package com.ibm.mobilefirstplatform.clientsdk.cordovaplugins.core;

import android.content.Context;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class CDVBMSRequest extends CordovaPlugin {

    private static final Logger bmsLogger = Logger.getLogger("CDVBMSRequest");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {

        if (action.equals("initialize")) {
            this.send(args, callbackContext);
        }
        else {
            return false;
        }
        return true;
    }

    public void send(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                try {
                    if (!(args.get(0) instanceof JSONObject)) {
                        String message = "Unable to send request. Invalid parameter. Should be JSON object";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    JSONObject jsRequest = args.getJSONObject(0);

                    final Context currentContext = cordova.getActivity();
                    final Request request = unpackRequest(jsRequest);
                    final String body = jsRequest.optString("body", "");

                    request.send(currentContext, body, new ResponseListener() {
                        @Override
                        public void onSuccess(Response response) {
                            try {
                                bmsLogger.debug("Successfully sent request");
                                PluginResult result = new PluginResult(PluginResult.Status.OK, packJavaResponseToJSON(response, null));
                                callbackContext.sendPluginResult(result);
                            }
                            catch (JSONException e) {
                                bmsLogger.debug(e.getLocalizedMessage());
                                callbackContext.error(e.getLocalizedMessage());
                            }
                        }

                        @Override
                        public void onFailure(Response response, Throwable throwable, JSONObject jsonObject) {
                            try {
                                bmsLogger.debug("Failed to send request");
                                PluginResult result = new PluginResult(PluginResult.Status.ERROR, packJavaResponseToJSON(response, throwable));
                                callbackContext.sendPluginResult(result);
                            }
                            catch (JSONException e) {
                                bmsLogger.debug(e.getLocalizedMessage());
                                callbackContext.error(e.getLocalizedMessage());
                            }
                        }
                    });
                }
                catch (JSONException e) {
                    bmsLogger.debug(e.getMessage());
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    /**
     * Unpacks a JSONObject to create a native Bluemix Request
     *
     * @param requestDict JSON request that will be converted to a native Bluemix Request Object
     * @return The converted Bluemix Request Object
     * @throws JSONException
     */
    private Request unpackRequest(JSONObject requestDict) throws JSONException {

        // URL
        String url = requestDict.getString("url");

        // HTTP method
        String method = requestDict.getString("method");

        // Timeout
        int timeout = requestDict.optInt("timeout", Request.DEFAULT_TIMEOUT);

        Request nativeRequest = new Request(url, method, timeout);

        // Headers
        // TODO: Discuss this at code review
        if (requestDict.has("headers") && !requestDict.isNull("headers")) {

            JSONObject headers = requestDict.getJSONObject("headers");
            Iterator<?> keys = headers.keys();

            while (keys.hasNext()) {
                String key = (String) keys.next();
                nativeRequest.addHeader(key, headers.getString(key));
            }
        }

        // Query parameters
        // TODO: Discuss this at code review
        if (requestDict.has("queryParameters") && !requestDict.isNull("queryParameters")) {

            JSONObject queryParameters = requestDict.getJSONObject("queryParameters");
            Iterator<?> keys = queryParameters.keys();

            while (keys.hasNext()) {
                String key = (String) keys.next();
                nativeRequest.setQueryParameter(key, queryParameters.getString(key));
            }
        }

        return nativeRequest;
    }

    /**
     * Packs a Bluemix Response object into a JSONObject
     *
     * @param response The native Bluemix Response that will be converted to a JSONObject
     * @return The String representation of the JSONObject
     */
    private JSONObject packJavaResponseToJSON(Response response, Throwable t) throws JSONException {

        JSONObject jsonResponse = new JSONObject();

        jsonResponse.put("responseText", response.getResponseText());
        jsonResponse.put("headers", convertHashMapToJSON(response.getHeaders()));
        jsonResponse.put("statusCode", response.getStatus());

        // Pack error
        // TODO: How to get error code?
        if (t != null) {
            //jsonResponse.put("errorCode", );
            jsonResponse.put("errorDescription", t.getLocalizedMessage());
        }

        return jsonResponse;
    }

    /**
     * Converts a HashMap<String, List<String>> to a JSONObject
     *
     * @param originalMap A HashMap that will be converted to a JSONObject
     * @return The converted JSONObject
     */
    private static JSONObject convertHashMapToJSON(Map<String, List<String>> originalMap) throws JSONException {

        JSONObject convertedJSON = new JSONObject();
        Iterator<Map.Entry<String, List<String>>> it = originalMap.entrySet().iterator();

        while (it.hasNext()) {
            Map.Entry<String, List<String>> pair = it.next();
            String key = pair.getKey();
            List<String> headerValues = pair.getValue();
            for (String value : headerValues) {
                convertedJSON.put(key, value);
            }
        }

        return convertedJSON;
    }
}