/*
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
*/
package com.ibm.mobilefirstplatform.clientsdk.cordovaplugins.core;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import android.content.Context;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;

public class CDVMFPRequest extends CordovaPlugin {

    private static final Logger mfpRequestLogger = Logger.getInstance(Logger.INTERNAL_PREFIX + "CDVMFPRequest");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("send".equals(action)) {
            this.send(args, callbackContext);
            return true;
        }
        return false;
    }

    /**
     * Responsible for converting a JSON request to a Bluemix Request, sending the request, receiving a Response, and converting it to a
     * JSON object that is sent back to the Javascript layer.
     *
     * @param args            A JSONArray that contains the JSONObject with the request
     * @param callbackContext Callback that will indicate whether the request succeeded or failed
     */
    public void send(JSONArray args, final CallbackContext callbackContext) throws JSONException {
        JSONObject myrequest = args.getJSONObject(0);

        final Context currentContext = this.cordova.getActivity();
        final Request nativeRequest = unpackJSONRequest(myrequest);
        final String bodyText = myrequest.optString("body", "");

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {

                nativeRequest.send(currentContext, bodyText, new ResponseListener() {
                    @Override
                    public void onSuccess(Response response) {
                        try {
                            PluginResult result = new PluginResult(PluginResult.Status.OK, packJavaResponseToJSON(response));
                            mfpRequestLogger.debug("Request successful.");
                            callbackContext.sendPluginResult(result);
                        } catch (JSONException e) {
                            callbackContext.error(e.getMessage());
                        }
                    }

                    @Override
                    public void onFailure(Response failResponse, Throwable t, JSONObject extendedInfo) {
                        try {
                            PluginResult result = new PluginResult(PluginResult.Status.ERROR, packJavaResponseToJSON(failResponse, t, extendedInfo));
                            mfpRequestLogger.error("Failed to send request.");
                            callbackContext.sendPluginResult(result);
                        } catch (JSONException e) {
                            callbackContext.error(e.getMessage());
                        }
                    }
                });

            }
        });
    }


    /**
     * Unpacks a JSONObject to create a native Bluemix Request
     *
     * @param jsRequest JSON request that will be converted to a native Bluemix Request Object
     * @return nativeRequest The converted Bluemix Request Object
     */
    @SuppressWarnings("unchecked")
    private Request unpackJSONRequest(JSONObject jsRequest) throws JSONException {
        //Parse request from Javascript
        String url = jsRequest.getString("url");
        String method = jsRequest.getString("method");
        int timeout = jsRequest.optInt("timeout", Request.DEFAULT_TIMEOUT);

        //Build request using the native Android SDK
        Request nativeRequest = new Request(url, method, timeout);

        if (jsRequest.has("headers") && !jsRequest.isNull("headers")) {
            Map<String, List<String>> headers = convertJSONtoHashMap(jsRequest.getJSONObject("headers"), true);
            nativeRequest.setHeaders(headers);
        }
        if (jsRequest.has("queryParameters") && !jsRequest.isNull("queryParameters")) {
            Map<String, String> queryParameters = convertJSONtoHashMap(jsRequest.getJSONObject("queryParameters"), false);
            nativeRequest.setQueryParameters(queryParameters);
        }

        return nativeRequest;
    }

    /**
     * Overloading, Handles the case of a failure and response is null.
     *
     * @param response The native Bluemix Response that will be converted to a JSONObject, May be null if the request did not reach the server.
     * @param t        Exception that could have caused the request to fail. null if no Exception thrown.
     * @param extendedInfo Contains details regarding operational failure. null if no operational failure occurred.
     * @return The String representation of the JSONObject
     */

    private String packJavaResponseToJSON(Response response, Throwable t, JSONObject extendedInfo) throws JSONException {
        if (response != null)
            return packJavaResponseToJSON(response);
        if (extendedInfo != null){
            //extendedinfo contains errorCode and msg, converting that into errorCode and errorDescription according to the format we use.
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("errorCode", extendedInfo.get("errorCode"));
            jsonResponse.put("errorDescription",extendedInfo.get("msg"));
            return jsonResponse.toString();
        }
        if (t != null)
            return packJavaThrowableToJSON(t);
        return null;
    }
    /**
     * Packs a exception into a JSONObject
     *
     * @param t Exception that could have caused the request to fail. null if no Exception thrown.
     * @return jsonException The String representation of the JSONObject
     */
    private String packJavaThrowableToJSON(Throwable t) throws JSONException{
        mfpRequestLogger.debug("packJavaThrowableToJSON");
        JSONObject jsonException = new JSONObject();
        jsonException.put("errorCode", "Exception: request failure");
        if(t.getMessage() != null)
            jsonException.put("errorDescription", t.getMessage());
        else
            jsonException.put("errorDescription",t.toString());

        return jsonException.toString();
    }

    /**
     * Packs a Bluemix Response object into a JSONObject
     *
     * @param response The native Bluemix Response that will be converted to a JSONObject
     * @return jsonResponse The String representation of the JSONObject
     */
    static String packJavaResponseToJSON(Response response) throws JSONException {
        mfpRequestLogger.debug("packJavaResponseToJSON");
        if (response != null) {
            JSONObject jsonResponse = new JSONObject();

            int status = (response.getStatus() != 0) ? response.getStatus() : 0;
            String responseText = (response.getResponseText() != null) ? response.getResponseText() : "";
            JSONObject responseHeaders = (response.getHeaders() != null) ? convertHashMaptoJSON(response.getHeaders()) : null;

            if (response.getStatus() == 0 || response.getStatus() >= 400) {
                jsonResponse.put("errorCode", status);
                jsonResponse.put("errorDescription", responseText);
            } else {
                jsonResponse.put("status", status);
                jsonResponse.put("responseText", responseText);
            }
            jsonResponse.put("responseHeaders", responseHeaders);
            return jsonResponse.toString();
        } else {
            return null;
        }
    }

    /**
     * Converts a HashMap<String, List<String>> to a JSONObject
     *
     * @param originalMap A hashmap that will be converted to a JSONObject
     * @return convertedJSON The converted JSONObject
     */
    private static JSONObject convertHashMaptoJSON(Map<String, List<String>> originalMap) throws JSONException {
        JSONObject convertedJSON = new JSONObject();
        Iterator<Map.Entry<String, List<String>>> it = originalMap.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, List<String>> pair = it.next();
            String key = pair.getKey();
            List<String> headerValuesList = pair.getValue();
            for (String headerValue : headerValuesList) {
                convertedJSON.put(key, headerValue);
            }
        }
        return convertedJSON;
    }

    /**
     * Converts a JSONObject to a HashMap
     *
     * @param originalJSON A JSONObject that will be converted to a Hashmap
     * @return convertedMap The converted HashMap
     */
    private static Map convertJSONtoHashMap(JSONObject originalJSON, boolean wrapInList) throws JSONException {
        Map<String, Object> convertedMap = new HashMap<String, Object>();

        Iterator<?> keys = originalJSON.keys();
        while (keys.hasNext()) {
            String key = (String) keys.next();
            // Detects String => [List of Strings]
            if (originalJSON.get(key) instanceof String) {
                if(wrapInList) {
                    // For headers, we will wrap the string value in an arraylist
                    // since the Android SDK takes in a <String, List<String>> to set its headers.
                    ArrayList<String> headerValue = new ArrayList<String>();
                    headerValue.add(originalJSON.getString(key));
                    convertedMap.put(key, headerValue);
                } else {
                    convertedMap.put(key, originalJSON.getString(key));
                }
            }
        }
        return convertedMap;
    }
}