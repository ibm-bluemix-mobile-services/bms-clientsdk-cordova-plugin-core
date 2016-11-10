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

import android.app.Application;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import java.util.Arrays;

public class CDVBMSAnalytics extends CordovaPlugin {

    private static final Logger analyticsLogger = Logger.getLogger(Logger.INTERNAL_PREFIX + "CDVBMSAnalytics");
    private String errorEmptyArg = "Expected non-empty string argument.";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        analyticsLogger.debug("execute() : action = " + action);

        if("enable".equals(action)) {
            Analytics.enable();
            callbackContext.success();
            return true;
        } else if("disable".equals(action)) {
            Analytics.disable();
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
        } else if("initialize".equals(action)){
            this.init(args, callbackContext);
            return true;
        } else if("log".equals(action)){
            this.log(args, callbackContext);
            return true;
        } else if("setUserIdentity".equals(action)){
            this.setUserIdentity(args, callbackContext);
            return true;
        }
        return false;
    }

    /**
     *
     * Specify current application user.  This value will be hashed to ensure privacy.
     * If your application does not have user context, then nothing will happen.
     *
     * @param args  JSONArray that contains the argument the to initialize Analytics
     * @param callbackContext
     */

    public void setUserIdentity(final JSONArray args, final CallbackContext callbackContext){
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    String userIdentity = args.getString(0);
                    Analytics.setUserIdentity(userIdentity);
                } catch(JSONException e){
                    analyticsLogger.error("setUserIdentity :: Analytics failed to set user identity. " +
                            "Please review arguments");
                    callbackContext.error(e.getMessage());
                }

            }
        });
    }

    /**
     * Sends the Analytics logs to the server
     * @param callbackContext Callback that will indicate whether the request succeeded or failed
     */
    public void send(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                Analytics.send(new ResponseListener() {
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

    /**
     * Initialize BMSAnalytics API
     * @param args  JSONArray that contains the argument the to initialize Analytics
     * @param callbackContext
     */
    public void init(final JSONArray args, final CallbackContext callbackContext){

        final Application app = cordova.getActivity().getApplication();
        try {
            String applicationName = args.getString(0);
            String clientApiKey = args.getString(1);
            boolean hasContext = args.getBoolean(2);
            JSONArray deviceEventsArray = args.getJSONArray(3);
            Analytics.DeviceEvent[] devices = new Analytics.DeviceEvent[deviceEventsArray.length()];
            for(int i = 0; i < deviceEventsArray.length(); i++ ){
                if(deviceEventsArray.getInt(i) == 0){
                    devices[i] = Analytics.DeviceEvent.NONE;
                } else if(deviceEventsArray.getInt(i) == 1){
                    devices[i] = Analytics.DeviceEvent.ALL;
                } else if(deviceEventsArray.getInt(i) == 2){
                    devices[i] = Analytics.DeviceEvent.LIFECYCLE;
                } else if(deviceEventsArray.getInt(i) == 3){
                    devices[i] = Analytics.DeviceEvent.NETWORK;
                }
            }
            Analytics.init(app, applicationName, clientApiKey, hasContext, devices);
        } catch (JSONException e) {
            analyticsLogger.error("init :: Analytics failed to initialize. Please review arguments");
            callbackContext.error(e.getMessage());
        }

    }

    /**
     * Log an analytics event
     * @param args  JSONArray that contains the description for the event
     * @param callbackContext
     */

    public void log(final JSONArray args, final CallbackContext callbackContext){
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                try {
                    JSONObject meta = args.getJSONObject(0);
                    Analytics.log(meta);
                } catch (JSONException e) {
                    analyticsLogger.error("log :: " + errorEmptyArg);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

}