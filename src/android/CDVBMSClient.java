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

public class CDVBMSClient extends CordovaPlugin {
    private static final String TAG = "CDVBMSClient";

    private static final Logger bmsLogger = Logger.getInstance("CDVBMSClient");

    private static CallbackContext myCallbackContext;

    private AuthenticationContext innerAuthContext;

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
        } else if ("addActionReceiver".equals(action)) {
            this.doAddActionReceiver(args, callbackContext);
            return true;
        }
        //Consider move to separate file
          else if ("submitAuthenticationChallengeAnswer".equals(action)) {
            this.submitAuthenticationChallengeAnswer(args, callbackContext);
            return true;
        }
        return false;
    }

    private void submitAuthenticationChallengeAnswer(JSONArray args, CallbackContext callbackContext) throws JSONException {
        JSONObject answer = args.getJSONObject(1);
        innerAuthContext.submitAuthenticationChallengeAnswer(answer);
        innerAuthContext = null;
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

    //TODO
    public void registerAuthenticationListener(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String realm = args.getString(0);
        //String authenticationListener = args.getString(1);
        if (realm != null && realm.length() > 0) {
            BMSClient.getInstance().registerAuthenticationListener(realm, new InternalAuthenticationListener());
            bmsLogger.debug("Called registerAuthenticationListener");
            callbackContext.success(realm);
        } else {
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

    private void doAddActionReceiver(JSONArray args, CallbackContext callbackContext) throws JSONException {
        bmsLogger.debug("doAddActionReceiver");
        String receiverId = args.getString(0);
        bmsLogger.debug("Adding receiver :: " + receiverId);

        myCallbackContext = callbackContext;
        //ActionReceiverWithCallbackcontext actionReceiver = new ActionReceiverWithCallbackcontext(callbackContext);
        //ActionSender.getInstance().addActionReceiver(actionReceiver, true, tag);
        //actionReceivers.put(receiverId, actionReceiver);
    }


    //AuthenticationListener class that handles the challenges from the server
    public class InternalAuthenticationListener implements AuthenticationListener {

        @Override
        public void onAuthenticationChallengeReceived(final AuthenticationContext authContext, final JSONObject challenge, Context context) {
            //TODO call hybrid onAuthenticationChallengeReceived :done

            cordova.getThreadPool().execute(new Runnable() {
                public void run() {

                    bmsLogger.debug("onActionReceived :: action :: onAuthenticationChallengeReceived , data :: " + authContext.toString());
                    JSONObject responseObj = new JSONObject();
                    try {
                        responseObj.put("action", "onAuthenticationChallengeReceived");
                        responseObj.put("authContext", authContext);
                        responseObj.put("challenge", challenge);
                    } catch (JSONException e) {
                        bmsLogger.debug("onActionReceived :: failed to generate JSON response");
                    }
                    innerAuthContext = authContext;
                    PluginResult result = new PluginResult(PluginResult.Status.OK, responseObj);
                    result.setKeepCallback(true);
                    myCallbackContext.sendPluginResult(result);
                    bmsLogger.debug("onAuthenticationChallengeReceived :: sent to JS");
                }

            });
        }

        @Override
        public void onAuthenticationSuccess(Context context, final JSONObject info) {
            //TODO call hybrid onAuthenticationSuccess

        }

        @Override
        public void onAuthenticationFailure(Context context, final JSONObject info) {
            //TODO call hybrid onAuthenticationFailure
        }

    }
}
