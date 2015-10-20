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

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import org.json.JSONArray;
import org.json.JSONException;
import java.net.MalformedURLException;

public class CDVBMSClient extends CordovaPlugin {
    private static final String TAG = "CDVBMSClient";

    private static final Logger bmsLogger = Logger.getInstance("CDVBMSClient");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("initialize".equals(action)) {
            this.initialize(args, callbackContext);
            return true;
        }
        // TODO: Implement registerAuthenticationListener and unregisterAuthenticationListener
        // else if("registerAuthenticationListener".equals(action)) {
        //     return true;
        // } else if("unregisterAuthenticationListener".equals(action)) {
        //     return true;
        // }
        return false;
    }

    /**
     * Use the native SDK API to set the base URL for the authorization server.
     * @param args JSONArray that contains the backendRoute and backendGUID
     * @param callbackContext 
     */
    public void initialize(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String backendRoute = args.getString(0);
        String backendGUID = args.getString(1);
        if (backendRoute != null && backendRoute.length() > 0 && backendGUID != null && backendGUID.length() > 0) {
            try {
                BMSClient.getInstance().initialize(this.cordova.getActivity().getApplicationContext(), backendRoute, backendGUID);
            } catch (MalformedURLException e) {
                callbackContext.error(e.getMessage());
            }
            bmsLogger.debug("Successfully initialized BMSClient");
            callbackContext.success();
        } else {
            bmsLogger.error("Trouble initializing BMSClient");
            callbackContext.error("Expected non-empty string arguments.");
        }
    }

    //TODO
    public void registerAuthenticationListener(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String realm                  = args.getString(0);
        String authenticationListener = args.getString(1);
        if (realm != null && realm.length() > 0) {
            bmsLogger.debug("Called registerAuthenticationListener");
            callbackContext.success(realm);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    //TODO
    public void unregisterAuthenticationListener(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String authenticationListener = args.getString(0);
        if (authenticationListener != null && authenticationListener.length() > 0) {
            bmsLogger.debug("Called unregisterAuthenticationListener");
            callbackContext.success(authenticationListener);
        } else {
            bmsLogger.error("Expected one non-empty string argument.");
            callbackContext.error("Expected one non-empty string argument.");
        }
    }
}
