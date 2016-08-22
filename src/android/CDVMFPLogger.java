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

import java.util.ArrayList;
import java.util.Iterator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class CDVMFPLogger extends CordovaPlugin {

    private static final Logger mfpLogger = Logger.getInstance(Logger.INTERNAL_PREFIX + "CDVMFPLogger");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        mfpLogger.debug("execute :: action = " + action);
        if("getCapture".equals(action)) {
            this.getCapture(callbackContext);

            return true;
        } else if("setCapture".equals(action)) {
            Boolean captureFlag = args.getBoolean(0);
            Logger.setCapture(captureFlag);
            callbackContext.success();
            return true;

        } else if("getFilters".equals(action)) {
            this.getFilters(callbackContext);

        } else if("setFilters".equals(action)) {
            String myarg = args.getString(0);
            JSONObject filtersAsJSON = new JSONObject(args.getString(0));
            HashMap<String, LEVEL> newFilters = JSONObjectToHashMap(filtersAsJSON);
            Logger.setFilters(newFilters);
            callbackContext.success();
            return true;


        } else if("getMaxStoreSize".equals(action)) {
            this.getMaxStoreSize(callbackContext);
            callbackContext.success(Logger.getMaxStoreSize());

            return true;
        } else if("setMaxStoreSize".equals(action)) {
            int newStoreSize = args.getInt(0);
            Logger.setMaxStoreSize(newStoreSize);
            callbackContext.success();
            return true;

        } else if("getLevel".equals(action)) {
            this.getLevel(callbackContext);
            return true;
        } else if("setLevel".equals(action)) {
            LEVEL newLevel = LEVEL.fromString(args.getString(0));
            Logger.setLevel(newLevel);
            callbackContext.success();
            return true;

        } else if("isUncaughtExceptionDetected".equals(action)) {
            String uncaughtExceptionFlag = String.valueOf(Logger.isUnCaughtExceptionDetected());
            callbackContext.success(uncaughtExceptionFlag);
            return true;

        } else if("send".equals(action)) {
            this.send(callbackContext);
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

    
    public void getCapture(final CallbackContext callbackContext) {
        final String captureFlag = String.valueOf(Logger.getCapture());

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                callbackContext.success(captureFlag);
            }
        });
    }

    public void getFilters(final CallbackContext callbackContext) {
        final JSONObject filters = HashMapToJSONObject(Logger.getFilters());

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                callbackContext.success(filters);
            }
        });
    }

    public void getMaxStoreSize(final CallbackContext callbackContext) {
        final int maxStoreSize = Logger.getMaxStoreSize();

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                callbackContext.success(maxStoreSize);
            }
        });
    }

    public void getLevel(final CallbackContext callbackContext) {
        final String currentLevel = String.valueOf(Logger.getLevel());

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                callbackContext.success(currentLevel);
            }
        });
    }

    /**
     * Sends non-Analytics logs to the server
     * @param callbackContext Callback that will indicate whether the request succeeded or failed
     */
    public void send(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                Logger.send(new ResponseListener() {
                    @Override
                    public void onSuccess(Response r) {
                        callbackContext.success("send(): Successfully sent logs");
                    }

                    @Override
                    public void onFailure(Response r, Throwable t, JSONObject extendedInfo) {
                        callbackContext.error("send(): Failed to send logs");
                    }
                });
            }
        });
    }

    public static JSONObject HashMapToJSONObject(HashMap<String, LEVEL> pairs) {
        if(pairs == null){
            return new JSONObject();
        }

        Set<String> set = pairs.keySet();
        JSONObject jsonObj = new JSONObject();
        @SuppressWarnings("rawtypes")
        Iterator it = set.iterator();
        while (it.hasNext()) {
            String n = (String) it.next();
            try {
                jsonObj.put(n, pairs.get(n).toString());
            } catch (JSONException e) {
                // not possible
            }
        }
        return jsonObj;
    }

    public static HashMap<String, LEVEL> JSONObjectToHashMap(JSONObject object) {
        HashMap<String, LEVEL> pairs = new HashMap<String, LEVEL>();
        @SuppressWarnings("rawtypes")
        Iterator it = object.keys();
        while (it.hasNext()) {
            String n = (String) it.next();
            try {
                pairs.put(n, LEVEL.valueOf(object.getString(n).toUpperCase()));
            } catch (JSONException e) {
                // not possible
            }
        }
        return pairs;
    }

}