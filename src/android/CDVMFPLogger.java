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
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

public class CDVMFPLogger extends CordovaPlugin {
    private static final String TAG = "CDVMFPLogger";

    //TODO : Discuss JS API implementation on whether we should need the following
    private static final Map<Integer, LEVEL> INT_TO_ENUM = new HashMap<Integer, LEVEL>(){{
        put(50, LEVEL.FATAL);
        put(100, LEVEL.DEBUG);
        put(200, LEVEL.WARN);
        put(300, LEVEL.INFO);
        put(400, LEVEL.DEBUG);
    }};

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("getInstance".equals(action)) {
            String packageName = args.getString(0);
            this.getInstance(packageName, callbackContext);
            callbackContext.success();
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
            JSONObject filters = Logger.HashMapToJSONObject(Logger.getFilters());
            callbackContext.success(filters);
        } else if("setFilters".equals(action)) {
            String myarg = args.getString(0);
            JSONObject filtersAsJSON = new JSONObject(args.getString(0));
            HashMap<String, LEVEL> newFilters = this.JSONObjectToHashMap(filtersAsJSON);
            Logger.setFilters(newFilters);
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
            LEVEL newLevel = INT_TO_ENUM.get(args.getInt(0));
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

        } else if("fatal".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getInstance(packageName);
            instance.fatal(message);

            callbackContext.success();
            return true;
        } else if("error".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getInstance(packageName);
            instance.error(message);

            callbackContext.success();
            return true;
        } else if("warn".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getInstance(packageName);
            instance.warn(message);

            callbackContext.success();
            return true;
        } else if("info".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getInstance(packageName);
            instance.info(message);

            callbackContext.success();
            return true;
        } else if("debug".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getInstance(packageName);
            instance.debug(message);

            callbackContext.success();
            return true;
        }

        return false;
    }

    public void getInstance(String packageName, CallbackContext callbackContext) {
        Log.d(TAG, "getInstance(" + packageName + ")");
        Logger.getInstance(packageName);
    }


    public void send() {
        Log.d(TAG, "send()");

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                Logger.send(new ResponseListener() {
                    @Override
                    public void onSuccess(Response r) {
                        Log.d(TAG, "send(). Successfully sent logs");
                    }

                    @Override
                    public void onFailure(Response r, Throwable t, JSONObject extendedInfo) {
                        Log.d(TAG, "send(). Failed to send logs");
                    }
                });
            }
        });
    }

    public static HashMap<String, LEVEL> JSONObjectToHashMap(JSONObject object) {
        HashMap<String, LEVEL> pairs = new HashMap<String, LEVEL>();
        @SuppressWarnings("rawtypes")
        Iterator it = object.keys();
        while (it.hasNext()) {
            String n = (String) it.next();
            try {
                pairs.put(n, INT_TO_ENUM.get(object.getInt(n)));
            } catch (JSONException e) {
            }
        }
        return pairs;
    }


}