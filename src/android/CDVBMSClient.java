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
import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AuthenticationContext;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AuthenticationListener;
import com.ibm.mobilefirstplatform.clientsdk.android.security.internal.challengehandlers.ChallengeHandler;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.MalformedURLException;
import java.util.HashMap;

public class CDVBMSClient extends CordovaPlugin {
    private static final String TAG = "CDVBMSClient";

    private static final Logger bmsLogger = Logger.getInstance("CDVBMSClient");

    private HashMap<String,CallbackContext> challengeHandlersMap = new HashMap<String, CallbackContext>();

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("initialize".equals(action)) {
            this.initialize(args, callbackContext);
            return true;
        } else if ("registerAuthenticationListener".equals(action)) {
            this.registerAuthenticationListener(args, callbackContext);
            return true;
        } else if ("unregisterAuthenticationListener".equals(action)) {
            this.unregisterAuthenticationListener(args, callbackContext);
            return true;
        } else if ("addCallbackReceiver".equals(action)) {
            this.doAddCallbackReceiver(args, callbackContext);
            return true;
        }
        //Consider move to separate file
          else if ("submitAuthenticationChallengeAnswer".equals(action)) {
            this.submitAuthenticationChallengeAnswer(args, callbackContext);
            return true;
        }
        else if ("submitAuthenticationSuccess".equals(action)) {
            this.submitAuthenticationSuccess(args, callbackContext);
            return true;
        }
        else if ("submitAuthenticationFailure".equals(action)) {
            this.submitAuthenticationFailure(args, callbackContext);
            return true;
        }
        return false;
    }




    /**
     * Use the native SDK API to set the base URL for the authorization server.
     *
     * @param args            JSONArray that contains the backendRoute and backendGUID
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


    public void registerAuthenticationListener(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String realm = args.getString(0);
        if (realm != null && realm.length() > 0) {
            BMSClient.getInstance().registerAuthenticationListener(realm, new InternalAuthenticationListener(realm));
            bmsLogger.debug("Called registerAuthenticationListener");
            callbackContext.success(realm);
        } else {
            bmsLogger.error("Expected one non-empty string argument.");
            callbackContext.error("Expected one non-empty string argument.");
        }
    }


    public void unregisterAuthenticationListener(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String realm = args.getString(0);
        if (realm != null && realm.length() > 0) {
            BMSClient.getInstance().unregisterAuthenticationListener(realm);
            bmsLogger.debug("Called unregisterAuthenticationListener");
            callbackContext.success(realm);
        } else {
            bmsLogger.error("Expected one non-empty string argument.");
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private void doAddCallbackReceiver(JSONArray args, CallbackContext callbackContext) throws JSONException {
        bmsLogger.debug("doAddCallbackReceiver");
        String realm = args.getString(0);
        bmsLogger.debug("realm: " + realm);
        challengeHandlersMap.put(realm, callbackContext);
    }

    private void submitAuthenticationChallengeAnswer(JSONArray args, CallbackContext callbackContext) {
        JSONObject answer = null;
        try {
            answer = args.getJSONObject(0);
            String realm = args.getString(1);
            bmsLogger.debug("Called submitAuthenticationChallengeAnswer");
            callbackContext.success("submitAuthenticationChallengeAnswer called");
            BMSClient.getInstance().getChallengeHandler(realm).submitAuthenticationChallengeAnswer(answer);
        } catch (JSONException e) {
            bmsLogger.error("submitAuthenticationChallengeAnswer :: Expected two non-empty string argument.");
            callbackContext.error(e.getMessage());
        }

    }
    private void submitAuthenticationSuccess(JSONArray args, CallbackContext callbackContext)  {
        String realm = null;
        try {
            realm = args.getString(0);
            bmsLogger.debug("Called submitAuthenticationSuccess");
            callbackContext.success("submitAuthenticationSuccess called");
            BMSClient.getInstance().getChallengeHandler(realm).submitAuthenticationSuccess();
        } catch (JSONException e) {
            bmsLogger.error("submitAuthenticationSuccess :: Expected one non-empty string argument.");
            callbackContext.error(e.getMessage());
        }

    }
    private void submitAuthenticationFailure(JSONArray args,CallbackContext callbackContext) {
        JSONObject info = null;
        try {
            info = args.getJSONObject(0);
            String realm = args.getString(1);
            callbackContext.success("submitAuthenticationFailure called");
            bmsLogger.debug("Called submitAuthenticationFailure");
            BMSClient.getInstance().getChallengeHandler(realm).submitAuthenticationFailure(info);
        } catch (JSONException e) {
            bmsLogger.error("submitAuthenticationFailure :: Expected two non-empty string argument.");
            callbackContext.error(e.getMessage());
        }

    }







    //AuthenticationListener class that handles the challenges from the server
    public class InternalAuthenticationListener implements AuthenticationListener {

        private final String realm;
        public InternalAuthenticationListener(String realm) {
            this.realm = realm;
        }

        @Override
        public void onAuthenticationChallengeReceived(final AuthenticationContext authContext, final JSONObject challenge, Context context) {

            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    bmsLogger.debug("onAuthenticationChallengeReceived called , data :: " + authContext.toString() + "challenge :: " + challenge.toString());
                    JSONObject responseObj = new JSONObject();
                    try {
                        responseObj.put("action", "onAuthenticationChallengeReceived");
                        //responseObj.put("authContext", authContext);
                        responseObj.put("challenge", challenge);
                    } catch (JSONException e) {
                        bmsLogger.debug("onAuthenticationChallengeReceived :: failed to generate JSON response");
                    }
                    PluginResult result = new PluginResult(PluginResult.Status.OK, responseObj);
                    result.setKeepCallback(true);
                    challengeHandlersMap.get(realm).sendPluginResult(result);
                    bmsLogger.debug("onAuthenticationChallengeReceived :: sent to JS");
                }
            });
        }

        @Override
        public void onAuthenticationSuccess(final Context context, final JSONObject info) {
            onAuthhenticationSuccessOrFailure(info, "onAuthenticationSuccess");
        }

        @Override
        public void onAuthenticationFailure(Context context, final JSONObject info) {
            onAuthhenticationSuccessOrFailure(info, "onAuthenticationFailure");
        }

        private void onAuthhenticationSuccessOrFailure(final JSONObject info, final String msg) {
            cordova.getThreadPool().execute(new Runnable() {
                public void run() {
                    bmsLogger.debug(msg + " called");
                    JSONObject responseObj = new JSONObject();
                    try {
                        responseObj.put("action", msg);
                        responseObj.put("info", info);
                    } catch (JSONException e) {
                        bmsLogger.debug(msg + " :: failed to generate JSON response");
                    }
                    PluginResult result = new PluginResult(PluginResult.Status.OK, responseObj);
                    result.setKeepCallback(true);
                    challengeHandlersMap.get(realm).sendPluginResult(result);
                    bmsLogger.debug(msg + " :: sent to JS");
                }
            });
        }

    }
}
