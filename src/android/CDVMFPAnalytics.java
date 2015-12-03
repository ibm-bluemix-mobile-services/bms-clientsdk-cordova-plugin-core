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

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.Response;
import com.ibm.mobilefirstplatform.clientsdk.android.core.api.ResponseListener;
import com.ibm.mobilefirstplatform.clientsdk.android.analytics.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.Logger;

import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

public class CDVMFPAnalytics extends CordovaPlugin {

    private static final Logger analyticsLogger = Logger.getInstance(Logger.INTERNAL_PREFIX + "CDVMFPAnalytics");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        analyticsLogger.debug("execute() : action = " + action);

        if("enable".equals(action)) {
            Logger.setAnalyticsCapture(true);
            MFPAnalytics.enable();
            callbackContext.success();
            return true;
        } else if("disable".equals(action)) {
            Logger.setAnalyticsCapture(false);
            MFPAnalytics.disable();
            callbackContext.success();
            return true;
        } else if("isEnabled".equals(action)) {
            //TODO: This does not exist for Android SDK
            callbackContext.error("Not yet implemented");
            return true;
        } else if("send".equals(action)) {
            this.send(callbackContext);
            return true;
        } else if("logEvent".equals(action)) {
            // TODO: Not yet implemented for the Android SDK
            callbackContext.error("Not yet implemented");
            return true;
        }
        return false;
    }

    /**
     * Sends the Analytics logs to the server
     * @param callbackContext Callback that will indicate whether the request succeeded or failed
     */
    public void send(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                Logger.sendAnalytics(new ResponseListener() {
                    @Override
                    public void onSuccess(Response response) {
                        callbackContext.success();
                    }

                    @Override
                    public void onFailure(Response failResponse, Throwable t, JSONObject extendedInfo) {
                        callbackContext.error(failResponse.toString());
                    }

                });
            }
        });


    }

}