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
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AuthenticationContext;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AuthenticationListener;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.MalformedURLException;
import java.util.HashMap;

public class CDVBMSClient extends CordovaPlugin {
    private String errorEmptyArg = "Expected non-empty string argument.";
    private static final Logger bmsLogger = Logger.getInstance(Logger.INTERNAL_PREFIX + "CDVBMSClient");
    private HashMap<String, CallbackContext> challengeHandlersMap = new HashMap<String, CallbackContext>();
    static HashMap<String, AuthenticationContext> authContexsMap = new HashMap<String, AuthenticationContext>();

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        boolean ans = true;
        if ("initialize".equals(action)) {
            this.initialize(args, callbackContext);
        } else if ("registerAuthenticationListener".equals(action)) {
            this.registerAuthenticationListener(args, callbackContext);
        } else if ("unregisterAuthenticationListener".equals(action)) {
            this.unregisterAuthenticationListener(args, callbackContext);
        } else if ("addCallbackHandler".equals(action)) {
            this.doAddCallbackHandler(args, callbackContext);
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
            callbackContext.error(errorEmptyArg);
        }
    }

    /**
     * Use the native SDK API to registers authentication listener for specified realm.
     *
     * @param args            JSONArray that contains the realm name
     * @param callbackContext
     */
    public void registerAuthenticationListener(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                final String realm;
                try {
                    realm = args.getString(0);
                    if (realm != null && realm.length() > 0) {
                        BMSClient.getInstance().registerAuthenticationListener(realm, new InternalAuthenticationListener(realm));
                        bmsLogger.debug("Called registerAuthenticationListener");
                        callbackContext.success(realm);
                    } else {
                        bmsLogger.error(errorEmptyArg);
                        callbackContext.error(errorEmptyArg);
                    }
                } catch (JSONException e) {
                    bmsLogger.error("registerAuthenticationListener :: " + errorEmptyArg);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    /**
     * Use the native SDK API to unregisters authentication listener
     *
     * @param args            JSONArray that contains the realm name the listener was registered for
     * @param callbackContext
     */
    public void unregisterAuthenticationListener(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                final String realm;
                try {
                    realm = args.getString(0);
                    if (realm != null && realm.length() > 0) {
                        BMSClient.getInstance().unregisterAuthenticationListener(realm);
                        bmsLogger.debug("Called unregisterAuthenticationListener");
                        challengeHandlersMap.remove(realm);
                        authContexsMap.remove(realm);
                        callbackContext.success("unregister realm: " + realm);
                    } else {
                        bmsLogger.error(errorEmptyArg);
                        callbackContext.error(errorEmptyArg);
                    }
                } catch (JSONException e) {
                    bmsLogger.error("unregisterAuthenticationListener :: " + errorEmptyArg);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }


    private void doAddCallbackHandler(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                try {
                    bmsLogger.debug("doAddCallbackHandler");
                    final String realm = args.getString(0);
                    if (realm != null && realm.length() > 0) {
                        bmsLogger.debug("realm: " + realm);
                        challengeHandlersMap.put(realm, callbackContext);
                    } else {
                        bmsLogger.error(errorEmptyArg);
                        callbackContext.error(errorEmptyArg);
                    }
                } catch (JSONException e) {
                    bmsLogger.error("doAddCallbackHandler :: " + errorEmptyArg);
                    callbackContext.error(e.getMessage());
                }
            }
        });
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


    //AuthenticationListener class that handles the challenges from the server
    private class InternalAuthenticationListener implements AuthenticationListener {

        private final String realm;

        private InternalAuthenticationListener(String realm) {
            this.realm = realm;
        }

        @Override
        public void onAuthenticationChallengeReceived(final AuthenticationContext authContext, final JSONObject challenge, Context context) {
            bmsLogger.debug("onAuthenticationChallengeReceived called , data :: " + authContext.toString() + "challenge :: " + challenge.toString());
            JSONObject responseObj = new JSONObject();
            try {
                responseObj.putOpt("action", "onAuthenticationChallengeReceived");
                responseObj.putOpt("challenge", challenge);
            } catch (JSONException e) {
                bmsLogger.debug("onAuthenticationChallengeReceived :: failed to generate JSON response");
            }
            authContexsMap.put(realm, authContext);
            PluginResult result = new PluginResult(PluginResult.Status.OK, responseObj);
            result.setKeepCallback(true);
            challengeHandlersMap.get(realm).sendPluginResult(result);
            bmsLogger.debug("onAuthenticationChallengeReceived :: sent to JS");
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

            bmsLogger.debug(msg + " called");
            JSONObject responseObj = new JSONObject();
            try {
                responseObj.putOpt("action", msg);
                responseObj.putOpt("info", info);
            } catch (JSONException e) {
                bmsLogger.debug(msg + " :: failed to generate JSON response");
            }
            PluginResult result = new PluginResult(PluginResult.Status.OK, responseObj);
            result.setKeepCallback(true);
            challengeHandlersMap.get(realm).sendPluginResult(result);
            bmsLogger.debug(msg + " :: sent to JS");
        }

    }
}
