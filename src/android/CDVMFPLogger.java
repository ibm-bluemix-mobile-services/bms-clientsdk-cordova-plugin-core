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

import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.core.api.Response;
import com.ibm.mobilefirstplatform.clientsdk.android.core.api.ResponseListener;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.Logger.LEVEL;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
import android.util.Log;
import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

public class CDVMFPLogger extends CordovaPlugin {
    private static final String TAG = "CDVMFPLogger";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("getInstance".equals(action)) {
            String packageName = args.getString(0);
            this.getInstance(packageName, callbackContext);
//            callbackContext.success("getInstance called");
            return true;

        } else if("getCapture".equals(action)) {
            String captureFlag = String.valueOf(Logger.getCapture());
            callbackContext.success(captureFlag);
            return true;
        } else if("setCapture".equals(action)) {
        	Boolean captureFlag = args.getBoolean(0);
            Logger.setCapture(captureFlag);
            callbackContext.success();
            return true;

        } else if("getFilters".equals(action)) {
            JSONObject filters = new JSONObject(Logger.getFilters());
            callbackContext.success(filters);
        } else if("setFilters".equals(action)) {
//            JSONObject filtersAsJSON = new JSONObject(args.getString(0));
//            HashMap<String, LEVEL> newFilters = toMap(filtersAsJSON);
//            Logger.setFilters(newFilters);
            callbackContext.success();
            return true;

        } else if("getMaxStoreSize".equals(action)) {
            callbackContext.success(Logger.getMaxStoreSize());
            return true;
        } else if("setMaxStoreSize".equals(action)) {
            int newStoreSize = args.getInt(0);
            Logger.setMaxStoreSize(newStoreSize);
            callbackContext.success();
            return true;

        } else if("getLevel".equals(action)) {
            String currentLevel = String.valueOf(Logger.getLevel());
            callbackContext.success(currentLevel);
            return true;
        } else if("setLevel".equals(action)) {
            LEVEL newLevel = LEVEL.values()[args.getInt(0)];
            Logger.setLevel(newLevel);
            callbackContext.success();
            return true;

        } else if("isUncaughtExceptionDetected".equals(action)) {
            String uncaughtExceptionFlag = String.valueOf(Logger.isUnCaughtExceptionDetected());
            callbackContext.success(uncaughtExceptionFlag);
            return true;

        } else if("send".equals(action)) {
            this.send();
            callbackContext.success();
            return true;


        } else if("debug".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);
            this.debug(packageName, message, callbackContext);
            callbackContext.success("debug called");
            return true;
        } else if("info".equals(action)) {
        } else if("error".equals(action)) {
        } else if("error".equals(action)) {
        } else if("fatal".equals(action)) {
        } else if("warn".equals(action)) {
        }

        return false;
    }

    public void getInstance(String packageName, CallbackContext callbackContext) {
        Log.d(TAG, "getInstance() -> creating a new instance");
        Log.d(TAG, "getInstance() packageName: " + packageName);

        Logger.getInstance(packageName);
    }

    public void debug(String packageName, String message, CallbackContext callbackContext) {
        Log.d(TAG, "debug(1) -> creating a log with DEBUG level.");
        Log.d(TAG, "debug(2) packageName: " + packageName);
        Log.d(TAG, "debug(3) message: " + message);

        Logger currentInstance = Logger.getInstance(packageName);        
        currentInstance.debug(message);
    }

    public void setCapture(Boolean captureFlag) {
    	Log.d(TAG, "setCapture : setting it " + String.valueOf(captureFlag));
        Logger.setCapture(captureFlag);
    }

    public void setFilters(final HashMap<String, LEVEL> filters) {
    	
    }

    public void getMaxStoreSize() {

    }

    public void setMaxStoreSize(JSONArray args) {

    }

    public void getLevel(CallbackContext callbackContext) {

    }

    public void isUncaughtExceptionDetected() {

    }

    public void send() {
        Log.d(TAG, "send(0) -> Sending logs.");
        Logger.send(new ResponseListener() {
            @Override
            public void onSuccess(Response r) {
                Log.d(TAG, "send(1) -> onSuccess: successfully sent logs");
            }

            ;

            public void onFailure(Response r, Throwable t, JSONObject extendedInfo) {
                Log.d(TAG, "send(1) -> onFailure: Could not send the logs to the server!");
                if (extendedInfo != null) {
                    Log.d(TAG, extendedInfo.toString());
                }
            };
        });
    }

//    public static HashMap<String, LEVEL> toMap(JSONObject object) throws JSONException {
//        HashMap<String, LEVEL> map = new HashMap();
//        Iterator keys = object.keys();
//        while (keys.hasNext()) {
//            String key = (String) keys.next();
//            map.put(key, fromJson(object.get(key)));
//        }
//        return map;
//    }
//
//    private static LEVEL fromJson(LEVEL json) throws JSONException {
//        if (json == JSONObject.NULL) {
//            return null;
//        } else if (json instanceof JSONObject) {
//            return toMap((JSONObject) json);
//        } else if (json instanceof JSONArray) {
//            return toList((JSONArray) json);
//        } else {
//            return json;
//        }
//    }

}