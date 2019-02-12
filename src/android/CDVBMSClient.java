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

import android.content.Context;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

public class CDVBMSClient extends CordovaPlugin {
    private String errorEmptyArg = "Expected non-empty string argument.";
    private static final Logger bmsLogger = Logger.getLogger(Logger.INTERNAL_PREFIX + "CDVBMSClient");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        boolean ans = true;
        if ("initialize".equals(action)) {
            this.initialize(args, callbackContext);
        } else if ("getBluemixAppRoute".equals(action)) {
            this.getBluemixAppRoute(callbackContext);
        } else if ("getBluemixAppGUID".equals(action)) {
            this.getBluemixAppGUID(callbackContext);
        } else {
            ans = false;
        }
        return ans;
    }


    /**
     * Use the native SDK API to set the base URL for the authorization server.
     *
     * @param args            JSONArray that contains the backendRoute and backendGUID
     * @param callbackContext
     */
    public void initialize(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String region = args.getString(0);
        if (region != null && region.length() > 0) {
            BMSClient.getInstance().initialize(this.cordova.getActivity().getApplicationContext(),region);
            bmsLogger.debug("Successfully initialized BMSClient");
            callbackContext.success();
        } else {
            bmsLogger.error("Trouble initializing BMSClient");
            callbackContext.error(errorEmptyArg);
        }
    }

    private void getBluemixAppRoute(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                String bluemixAppRoute = BMSClient.getInstance().getBluemixAppRoute();
                callbackContext.success(bluemixAppRoute);
            }
        });
    }

    private void getBluemixAppGUID(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                String bluemixAppGUID = BMSClient.getInstance().getBluemixAppGUID();
                callbackContext.success(bluemixAppGUID);
            }
        });
    }
}
