package com.ibm.mobilefirstplatform.clientsdk.cordovaplugins.core;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import android.util.Log;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;

public class CDVMFPRequest extends CordovaPlugin {
    private static final String TAG = "CDVMFPRequest";

    /* START OF THREAD TEST */

    private interface ExecOp {
        void run(JSONArray args) throws Exception;
    }

    private void threadHelper(final ExecOp f, final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                try {
                    f.run(args);
                    //test
                }
                catch(Exception e) {
                    if (e instanceof JSONException) {
                        callbackContext.error(e.getMessage());
                    }
                    else {
                        e.printStackTrace();
                        callbackContext.error(e.getMessage());
                    }
                }
            }
        });
    }

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (action.equals("send")) {

            JSONObject myRequest = args.getJSONObject(0);
            final Context currentContext = this.cordova.getActivity();
            final Request nativeRequest  = unpackJSONRequest(myRequest);
            final String bodyText        = myRequest.optString("body", "");

            threadHelper(new ExecOp() {
                public void run(JSONArray args) {
                    nativeRequest.send(currentContext, bodyText, new ResponseListener() {
                        @Override
                        public void onSuccess(Response response) {
                            try {
                                PluginResult result = new PluginResult(PluginResult.Status.OK, packJavaResponseToJSON(response));
                                //TODO: Logging
                                Log.d(TAG, "Success = Sending plugin result to javascript");
                                callbackContext.sendPluginResult(result);
                            } catch (JSONException e) {
                                callbackContext.error(e.getMessage());
                            }
                        }
                        @Override
                        public void onFailure(Response failResponse, Throwable t, JSONObject extendedInfo) {
                            try {
                                PluginResult result = new PluginResult(PluginResult.Status.ERROR, packJavaResponseToJSON(failResponse));
                                //TODO: Logging
                                Log.d(TAG, "Failure = Sending plugin result to javascript");
                                callbackContext.sendPluginResult(result);
                            } catch (JSONException e) {
                                callbackContext.error(e.getMessage());
                            }
                        }
                    });
                }
            }, args, callbackContext);
        }
        if (action.equals("log")) {
            threadHelper(new ExecOp() {
                public void run(JSONArray args) {

                }
            })
        }
        else {
            return false;
        }
        return true;
    }

    /* END OF THREAD TEST */

    /* START OF ORIGINAL CODE */

    /*
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("send".equals(action)) {
            this.send(args, callbackContext);
            return true;
        }
        return false;
    }

    /**
     * Responsible for converting a JSON request to a Bluemix Request, sending the request, receiving a Response, and converting it to a
     *    JSON object that is sent back to the Javascript layer.
     * @param args A JSONArray that contains the JSONObject with the request
     * @param callbackContext Callback that will indicate whether the request succeeded or failed
     */
    /*
    public void send(JSONArray args, final CallbackContext callbackContext) throws JSONException {
        JSONObject myrequest = args.getJSONObject(0);

        final Context currentContext = this.cordova.getActivity();
        final Request nativeRequest  = unpackJSONRequest(myrequest);
        final String bodyText        = myrequest.optString("body", "");

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {

                nativeRequest.send(currentContext, bodyText, new ResponseListener() {
                    @Override
                    public void onSuccess(Response response) {
                        try {
                            PluginResult result = new PluginResult(PluginResult.Status.OK, packJavaResponseToJSON(response));
                            //TODO: Logging
                            Log.d(TAG, "Success = Sending plugin result to javascript");
                            callbackContext.sendPluginResult(result);
                        } catch (JSONException e) {
                            callbackContext.error(e.getMessage());
                        }
                    }
                    @Override
                    public void onFailure(Response failResponse, Throwable t, JSONObject extendedInfo) {
                        try {
                            PluginResult result = new PluginResult(PluginResult.Status.ERROR, packJavaResponseToJSON(failResponse));
                            //TODO: Logging
                            Log.d(TAG, "Failure = Sending plugin result to javascript");
                            callbackContext.sendPluginResult(result);
                        } catch (JSONException e) {
                            callbackContext.error(e.getMessage());
                        }
                    }
                });

            }
        });
    }
    */

    /**
     * Unpacks a JSONObject to create a Bluemix Request
     * @param jsRequest JSON request that will be converted to a native Bluemix Request Object
     * @return nativeRequest The converted Bluemix Request Object
     */
    private Request unpackJSONRequest(JSONObject jsRequest) throws JSONException {
        //Parse request from Javascript
        String url    = jsRequest.getString("url");
        String method = jsRequest.getString("method");
        int timeout   = jsRequest.optInt("timeout", Request.DEFAULT_TIMEOUT);

        Map<String, List<String>> headers = null;
        Map<String, String> queryParameters = null;

        if (jsRequest.has("headers") && !jsRequest.isNull("headers")) {
            headers = convertJSONtoHashMap(jsRequest.getJSONObject("headers"));
        }
        if (jsRequest.has("queryParameters") && !jsRequest.isNull("queryParameters")){
            queryParameters = convertJSONtoHashMap(jsRequest.getJSONObject("queryParameters"));
        }

        //Build request using the native Android SDK
        Request nativeRequest = new Request(url, method, timeout);
        if (headers != null){
            nativeRequest.setHeaders(headers);
        }
        if (queryParameters != null) {
            nativeRequest.setQueryParameters(queryParameters);
        }
        return nativeRequest;
    }

    /**
     * Packs a Bluemix Response object into a JSONObject
     * @param response The native Bluemix Response that will be converted to a JSONObject
     * @return jsonResponse The String representation of the JSONObject
     */
    private String packJavaResponseToJSON(Response response) throws JSONException {
        if(response != null) {
            JSONObject jsonResponse = new JSONObject();

            int status                 = (response.getStatus() != 0)          ? response.getStatus() : 0;
            String responseText        = (response.getResponseText() != null) ? response.getResponseText() : "";
            JSONObject responseHeaders = (response.getHeaders() != null)      ? convertHashMaptoJSON(response.getHeaders()) : null;

            if( response.getStatus() == 0 || response.getStatus() >= 400) {
                jsonResponse.put("errorCode", status);
                jsonResponse.put("errorDescription", responseText);
            } else {
                jsonResponse.put("status", status);
                jsonResponse.put("responseText", responseText);
            }

            jsonResponse.put("responseHeaders", responseHeaders);

            //TODO: Use Internal Logger class instead
            Log.d(TAG, "packJavaResponseToJSON -> Complete JSON");
            Log.d(TAG, jsonResponse.toString());

            return jsonResponse.toString();
        } else {
            return null;
        }
    }

    /**
     * Converts a HashMap<String, List<String>> to a JSONObject
     * @param originalMap A hashmap that will be converted to a JSONObject
     * @return convertedJSON The converted JSONObject
     */
    private static JSONObject convertHashMaptoJSON(Map<String, List<String>> originalMap) throws JSONException {
        JSONObject convertedJSON = new JSONObject();
        Iterator it = originalMap.entrySet().iterator();
        while(it.hasNext()) {
            Map.Entry pair = (Map.Entry)it.next();
            String key = (String) pair.getKey();
            List<String> headerValuesList = (List<String>)pair.getValue();
            for(String headerValue : headerValuesList) {
                convertedJSON.put(key, headerValue);
            }
        }
        return convertedJSON;
    }

    /**
     * Converts a JSONObject to a HashMap
     * @param originalJSON A JSONObject that will be converted to a Hashmap
     * @return convertedMap The converted HashMap
     */
    private static Map convertJSONtoHashMap(JSONObject originalJSON) throws JSONException {
        Map<String, Object> convertedMap = new HashMap<String, Object>();

        Iterator<?> keys = originalJSON.keys();
        while(keys.hasNext()) {
            String key = (String)keys.next();
            // Handle "key" => [array of Strings]
            if(originalJSON.get(key) instanceof JSONArray) {
                JSONArray headerValues = originalJSON.getJSONArray(key);

                ArrayList<String> listedHeaderValues = new ArrayList<String>();
                for(int i=0; i < headerValues.length(); i++) {
                    listedHeaderValues.add(headerValues.getString(i));
                }
                convertedMap.put(key, listedHeaderValues);
            }
            // Handle "key" => "value (string)"
            else if (originalJSON.get(key) instanceof String) {
                convertedMap.put(key, originalJSON.getString(key));
            }
        }
        return convertedMap;
    }

}
