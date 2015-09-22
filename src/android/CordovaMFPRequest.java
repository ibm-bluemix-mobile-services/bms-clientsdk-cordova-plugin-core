package com.ibm.mobilefirstplatform.clientsdk.cordovaplugins.core;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;

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

public class CordovaMFPRequest extends CordovaPlugin {
    private static final String TAG = "CordovaMFPRequest";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("send".equals(action)) {
            this.send(args, callbackContext);
            return true;
        }
        return false;
    }

    public void send(JSONArray args, final CallbackContext callbackContext) throws JSONException {
        JSONObject myrequest = args.getJSONObject(0);
        try {
            final Context currentContext = this.cordova.getActivity();
            final Request nativeRequest = unpackRequest(myrequest);
            final String bodyText = (myrequest.has("body") && !myrequest.isNull("body")) ? myrequest.getString("body") : "";

            //TODO: Logging
            printNativeRequest(nativeRequest);

            cordova.getThreadPool().execute(new Runnable() {
                public void run() {

                    nativeRequest.send(currentContext, bodyText, new ResponseListener() {
                        @Override
                        public void onSuccess(Response response) {
                            try {
                                PluginResult result = new PluginResult(PluginResult.Status.OK, packResponse(response));
                                //TODO: Logging
                                Log.d(TAG, "Success = Sending plugin result to javascript");
                                callbackContext.sendPluginResult(result);
                            } catch (JSONException e) { e.printStackTrace(); }
                        }
                        @Override
                        public void onFailure(Response failResponse, Throwable t, JSONObject extendedInfo) {
                            try {
                                PluginResult result = new PluginResult(PluginResult.Status.ERROR, packResponse(failResponse));
                                //TODO: Logging
                                Log.d(TAG, "Failure = Sending plugin result to javascript");
                                callbackContext.sendPluginResult(result);
                            } catch (JSONException e) { e.printStackTrace(); }
                        }
                    });

                }
            });
        }
        //TODO: Handle exception similarly to BMSClient
        //TODO: Use Logger
        catch (MalformedURLException e) { Log.d(TAG, "Malformed URL Exception"); e.printStackTrace(); }
    }

    private Request unpackRequest(JSONObject jsRequest) throws JSONException {
        //Parse request from Javascript
        String url    = jsRequest.getString("url");
        String method = jsRequest.getString("method");
        int timeout   = jsRequest.getInt("timeout");
        Map<String, List<String>> headers = null;
        Map<String, String> queryParameters = null;

        if (jsRequest.has("headers") && !jsRequest.isNull("headers")) {
            headers = fromJSONtoHashMap(jsRequest.getJSONObject("headers"));
        }
        if (jsRequest.has("queryParameters") && !jsRequest.isNull("queryParameters")){
            queryParameters = fromJSONtoHashMap(jsRequest.getJSONObject("queryParameters"));
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

    private JSONObject packResponse(Response response) throws JSONException {
        if(response != null) {
            JSONObject jsonResponse = new JSONObject();

            int status                 = (response.getStatus() != 0)          ? response.getStatus() : 0;
            String responseText        = (response.getResponseText() != null) ? response.getResponseText() : "";
            JSONObject responseHeaders = (response.getHeaders() != null)      ? fromHashMaptoJSON(response.getHeaders()) : null;
            
            //TODO: Resolve errorCode & description
            int errorCode = status;
            String errorDescription = "";

            jsonResponse.put("status", status);
            jsonResponse.put("responseText", responseText);
            jsonResponse.put("responseHeaders", responseHeaders);

            jsonResponse.put("errorCode", errorCode);
            jsonResponse.put("errorDescription", errorDescription);

            //TODO: Use Internal Logger class instead
            Log.d(TAG, "packResponse -> Complete JSON");
            Log.d(TAG, jsonResponse.toString());

            return jsonResponse;
        } else {
            return null;
        }
    }

    /**
     *
     *
     */
    private static JSONObject fromHashMaptoJSON(Map<String, List<String>> originalMap) throws JSONException {
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

    private static Map fromJSONtoHashMap(JSONObject originalJSON) throws JSONException {
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

    private void printNativeRequest(Request theRequest) throws MalformedURLException {
        //TODO: Remove
        Log.d(TAG, "\n[START] printNativeRequest()");
        Log.d(TAG, "URL = \t" + theRequest.getUrl());
        Log.d(TAG, "Method = \t" + theRequest.getMethod());
        Log.d(TAG, "Timeout = \t" + theRequest.getTimeout());

        Map<String, List<String>> native_headers = theRequest.getAllHeaders();
        Map<String, String> native_params        = theRequest.getQueryParameters();

        Log.d(TAG, "-----Headers-----");
        if (native_headers != null) {
            for (String key: native_headers.keySet()) {
                        List<String> value = native_headers.get(key);

                        Log.d(TAG, "Header Name = " + key);
                        for(String headerValue : value) {
                            Log.d(TAG, "\tvalue = " + headerValue);
                        }
            }
        }
        Log.d(TAG, "-----Queries-----");
        if(native_params != null) {
            for (String key: native_params.keySet()) {
                        String value = native_params.get(key).toString();
                        Log.d(TAG, key + " : " + value);
            }
        }
        Log.d(TAG, "[END] printNativeRequest()\n\n");
    }

}