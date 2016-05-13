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

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import com.ibm.mobilefirstplatform.clientsdk.android.analytics.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CDVBMSAnalytics extends CordovaPlugin {

    private static final Logger bmsLogger = Logger.getLogger("CDVBMSAnalytics");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {

        if (action.equals("initialize")) {
            this.initialize(args, callbackContext);
        }
        else if (action.equals("enable")) {
            this.enable(callbackContext);
        }
        else if (action.equals("disable")) {
            this.disable(callbackContext);
        }
        else if (action.equals("isEnabled")) {
            this.isEnabled(callbackContext);
        }
        else if (action.equals("setUserIdentity")) {
            this.setUserIdentity(args, callbackContext);
        }
        else if (action.equals("log")) {
            this.log(args, callbackContext);
        }
        else if (action.equals("send")) {
            this.send(callbackContext);
        }
        else {
            return false;
        }
        return true;
    }

    public void initialize(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!(args.get(0) instanceof String)) {
                        String message = "Unable to initialize Analytics. Invalid app name";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    String appName = args.getString(0);

                    if (!(args.get(1) instanceof String)) {
                        String message = "Unable to initialize Analytics. Invalid API key";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    String apiKey = args.getString(1);

                    Analytics.init(cordova.getActivity().getApplication(), appName, apiKey, Analytics.DeviceEvent.LIFECYCLE);

                    String message = "Initialized Analytics";
                    bmsLogger.debug(message);
                    callbackContext.success(message);
                }
                catch (JSONException e) {
                    bmsLogger.debug(e.getMessage());
                    callbackContext.error(e.getMessage());
                }

            }
        });
    }

    public void enable(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Analytics.enable();
                String message = "Enabled Analytics";
                bmsLogger.debug(message);
                callbackContext.success(message);
            }
        });
    }

    public void disable(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Analytics.disable();
                String message = "Disabled Analytics";
                bmsLogger.debug(message);
                callbackContext.success(message);
            }
        });
    }

    public void isEnabled(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                boolean enabled = Analytics.isEnabled();
                PluginResult result = new PluginResult(PluginResult.Status.OK, enabled);
                callbackContext.sendPluginResult(result);
            }
        });
    }

    public void setUserIdentity(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!(args.get(0) instanceof String)) {
                        String message = "Unable to set user identity. Invalid identity parameter";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    final String identity = args.getString(0);

                    Analytics.setUserIdentity(identity);

                    String message = "Set user identity to " + identity;
                    bmsLogger.debug(message);
                    callbackContext.success(message);
                }
                catch (JSONException e) {
                    bmsLogger.debug(e.getMessage());
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public void log(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!(args.get(0) instanceof JSONObject)) {
                        String message = "Unable to log analytics. Invalid parameter. Should be JSON object";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    final JSONObject eventMetadata = args.getJSONObject(0);

                    Analytics.log(eventMetadata);

                    String message = "Logged Analytics message";
                    callbackContext.success(message);
                }
                catch (JSONException e) {
                    bmsLogger.debug(e.getMessage());
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public void send(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                Analytics.send();
                String message = "Sent Analytics logs";
                bmsLogger.debug(message);
                callbackContext.success(message);
            }
        });
    }
}