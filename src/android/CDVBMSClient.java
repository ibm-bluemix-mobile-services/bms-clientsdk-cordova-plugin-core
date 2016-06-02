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

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import java.net.MalformedURLException;

public class CDVBMSClient extends CordovaPlugin {

    private static final Logger bmsLogger = Logger.getLogger(Logger.INTERNAL_PREFIX + "CDVBMSClient");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {

        if (action.equals("initialize")) {
            this.initialize(args, callbackContext);
        }
        else if (action.equals("getBluemixAppRoute")) {
            this.getBluemixAppRoute(callbackContext);
        }
        else if (action.equals("getBluemixAppGUID")) {
            this.getBluemixAppGUID(callbackContext);
        }
        else if (action.equals("getDefaultRequestTimeout")) {
            this.getDefaultRequestTimeout(callbackContext);
        }
        else if (action.equals("setDefaultRequestTimeout")) {
            this.setDefaultRequestTimeout(args, callbackContext);
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
                        String message = "Unable to initialize BMSClient. Invalid route";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    String route = args.getString(0);

                    if (!(args.get(1) instanceof String)) {
                        String message = "Unable to initialize BMSClient. Invalid GUID";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    String guid = args.getString(1);

                    if (!(args.get(2) instanceof String)) {
                        String message = "Unable to initialize BMSClient. Invalid region";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    String region = args.getString(2);
                    
                    try {
                        BMSClient.getInstance().initialize(cordova.getActivity().getApplicationContext(), route, guid, region);
                        String message = "Initialized BMSClient";
                        bmsLogger.debug(message);
                        callbackContext.success(message);
                    }
                    catch (MalformedURLException e) {
                        bmsLogger.debug(e.getMessage());
                        callbackContext.error(e.getMessage());
                    }
                }
                catch (JSONException e) {
                    bmsLogger.debug(e.getMessage());
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public void getBluemixAppRoute(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                String route = BMSClient.getInstance().getBluemixAppRoute();
                callbackContext.success(route);
            }
        });
    }

    public void getBluemixAppGUID(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                String guid = BMSClient.getInstance().getBluemixAppGUID();
                callbackContext.success(guid);
            }
        });
    }

    public void getDefaultRequestTimeout(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                int timeout = BMSClient.getInstance().getDefaultTimeout();
                PluginResult result = new PluginResult(PluginResult.Status.OK, timeout);
                callbackContext.sendPluginResult(result);
            }
        });
    }

    public void setDefaultRequestTimeout(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                try {
                    if (!(args.get(0) instanceof Integer)) {
                        String message = "Unable to set default timeout. Invalid timeout value";
                        bmsLogger.debug(message);
                        callbackContext.error(message);
                        return;
                    }
                    final int timeout = args.getInt(0);

                    BMSClient.getInstance().setDefaultTimeout(timeout);
                    callbackContext.success("The default request timeout is set to " + timeout);
                }
                catch (JSONException e) {
                    bmsLogger.debug(e.getMessage());
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }
}