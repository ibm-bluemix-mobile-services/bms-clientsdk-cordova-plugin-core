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

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import android.util.Log;

public class CDVMFPLogger extends CordovaPlugin {
    private static final String TAG = "CDVMFPLogger";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("getInstance".equals(action)) {
            callbackContext.success("getInstance called");
            this.getInstance(args);
            return true;
        } else if("getCapture".equals(action)) {
            callbackContext.success("getCapture called");
            // this.getCapture();
        } else if("setCapture".equals(action)) {
            callbackContext.success("setCapture called");
            // this.getCapture();
        } else if("getFilters".equals(action)) {
            callbackContext.success("getFilters called");
            return true;
        } else if("setFilters".equals(action)) {
            callbackContext.success("setFilters called");
            return true;
        } else if("getMaxStoreSize".equals(action)) {
            callbackContext.success("getMaxStoreSize called");
            return true;
        } else if("setMaxStoreSize".equals(action)) {
            callbackContext.success("setMaxStoreSize called");
            return true;
        } else if("getLevel".equals(action)) {
            callbackContext.success("getLevel called");
            return true;
        } else if("setLevel".equals(action)) {
            callbackContext.success("setLevel called");
            return true;
        } else if("isUncaughtExceptionDetected".equals(action)) {
            callbackContext.success("isUncaughtExceptionDetected called");
            return true;
        } else if("send".equals(action)) {
            callbackContext.success("send called");
            return true;
        } else if("debug".equals(action)) {
            this.debug(args);
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

    private static void getInstance(JSONArray args) throws JSONException {
        String packageName = args.getString(0);
        Log.d(TAG, "getInstance() -> creating a new instance");
        Log.d(TAG, "getInstance() packageName: " + packageName);

        Logger.getInstance(packageName);

    }

    private static void debug(JSONArray args) throws JSONException {
        Log.d(TAG, "debug() -> creating a log with DEBUG level.");
        String packageName = args.getString(0);
        String message = args.getString(1);
        Log.d(TAG, "debug() -> creating a log with DEBUG level.");
        Log.d(TAG, "debug() packageName: " + packageName);
        Log.d(TAG, "debug() message: " + message);

        Logger logger = Logger.getInstance(packageName);
        logger.debug(message);

    }

}