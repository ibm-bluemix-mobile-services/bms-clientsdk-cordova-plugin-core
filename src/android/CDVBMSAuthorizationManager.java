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

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AppIdentity;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.DeviceIdentity;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.UserIdentity;
import com.ibm.mobilefirstplatform.clientsdk.android.security.mca.api.MCAAuthorizationManager;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Map;
import java.util.List;
import java.util.HashMap;


public class CDVBMSAuthorizationManager extends CordovaPlugin {

    private static final Logger amLogger = Logger.getLogger(Logger.INTERNAL_PREFIX + "CDVBMSAuthorizationManager");

    private static final String PersistencePolicyAlways = "ALWAYS";
    private static final String PersistencePolicyNever = "NEVER";
    private static final String WWW_AUTHENTICATE_HEADER_NAME = "Www-Authenticate";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        boolean ans = true;
        if ("initialize".equals(action)) {
            this.initialize(args, callbackContext);
        } else if ("obtainAuthorizationHeader".equals(action)) {
            this.obtainAuthorizationHeader(callbackContext);
        } else if ("clearAuthorizationData".equals(action)) {
            this.clearAuthorizationData(callbackContext);
        } else if ("isAuthorizationRequired".equals(action)) {
            this.isAuthorizationRequired(args, callbackContext);
        } else if ("getCachedAuthorizationHeader".equals(action)) {
            this.getCachedAuthorizationHeader(callbackContext);
        } else if ("getAuthorizationPersistencePolicy".equals(action)) {
            this.getAuthorizationPersistencePolicy(callbackContext);
        } else if ("setAuthorizationPersistencePolicy".equals(action)) {
            this.setAuthorizationPersistencePolicy(args, callbackContext);
        } else if ("getUserIdentity".equals(action)) {
            this.getUserIdentity(callbackContext);
        } else if ("getAppIdentity".equals(action)) {
            this.getAppIdentity(callbackContext);
        } else if ("getDeviceIdentity".equals(action)) {
            this.getDeviceIdentity(callbackContext);
        }else if ("logout".equals(action)) {
            this.logout(callbackContext);
        } else {
            ans = false;
        }
        return ans;
    }

    /**
     * Use the native SDK API to initialize the authorization manager with tenantId.
     *
     * @param args            JSONArray that contains the MCA service tenantId.
     * @param callbackContext
     */
    private void initialize(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final Context currentContext = this.cordova.getActivity();
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                String tenantId = null;
                try {
                    tenantId = args.getString(0);
                } catch (JSONException e) {
                    e.printStackTrace();
                    amLogger.error("Error in parsing the tenantId");
                    callbackContext.error("The specified tenantId cant be parse as String.");
                }
                MCAAuthorizationManager.createInstance(currentContext, tenantId);
                amLogger.debug("Authorization Manager initialize with tenantId: " + tenantId.toString());
                callbackContext.success();
            }
        });
    }

    /**
     * Use the native SDK API to invoke process for obtaining authorization header.
     * @param callbackContext Callback that will indicate whether the request succeeded or failed
     */
    private void obtainAuthorizationHeader(final CallbackContext callbackContext) throws JSONException {

        final Context currentContext = this.cordova.getActivity();

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MCAAuthorizationManager.getInstance().obtainAuthorization(currentContext, new ResponseListener() {
                    @Override
                    public void onSuccess(Response response) {
                        try {
                            PluginResult result = new PluginResult(PluginResult.Status.OK, CDVBMSRequest.packJavaResponseToJSON(response));
                            amLogger.debug("ObtainAuthorizationHeader: request successful.");
                            callbackContext.sendPluginResult(result);
                        } catch (JSONException e) {
                            callbackContext.error(e.getMessage());
                        }
                    }

                    @Override
                    public void onFailure(Response response, Throwable t, JSONObject extendedInfo) {
                        try {
                            PluginResult result = new PluginResult(PluginResult.Status.ERROR, CDVBMSRequest.packJavaResponseToJSON(response));
                            amLogger.error("Failed to send request obtainAuthorizationHeader.");
                            callbackContext.sendPluginResult(result);
                        } catch (JSONException e) {
                            callbackContext.error(e.getMessage());
                        }
                    }
                });

            }
        });

    }
    /**
     * Use the native SDK API to clear the local stored authorization data.
     * @param callbackContext
     */
    private void clearAuthorizationData(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MCAAuthorizationManager.getInstance().clearAuthorizationData();
                amLogger.debug("Authorization data cleared.");
                callbackContext.success();
            }
        });
    }

    /**
     * Use the native SDK API to check if the params came from response that requires authorization.
     *
     * @param args            JSONArray that contains the statusCode of the response, and responseAuthorizationHeader.
     * @param callbackContext Callback that will get the result,true if status is 401 or 403 and The value of the header contains 'Bearer' AND 'realm="imfAuthentication"'
     */
    private void isAuthorizationRequired(final JSONArray args, final CallbackContext callbackContext) throws JSONException {

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                try {
                    int statusCode = args.getInt(0);
                    ArrayList<String> headers = new ArrayList<String>();
                    headers.add(args.getString(1));
                    Map<String, List<String>> responseAuthorizationHeader = new HashMap<String, List<String>>();
                    responseAuthorizationHeader.put(WWW_AUTHENTICATE_HEADER_NAME, headers);
                    boolean answer = MCAAuthorizationManager.getInstance().isAuthorizationRequired(statusCode, responseAuthorizationHeader);
                    amLogger.debug("isAuthorizationRequired return " + answer);
                    callbackContext.success(String.valueOf(answer));
                } catch (JSONException e) {
                    amLogger.debug("Expected non-empty string argument.");
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    /**
     * Use the native SDK API get the locally stored authorization header or null if the value is not exist.
     *
     * @param callbackContext
     */
    private void getCachedAuthorizationHeader(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                String header = MCAAuthorizationManager.getInstance().getCachedAuthorizationHeader();
                amLogger.debug("Cached authorization header: " + header);
                callbackContext.success(header);
            }
        });
    }

    /**
     * Use the native SDK API to get the current authorization persistence policy
     *
     * @param callbackContext
     */
    private void getAuthorizationPersistencePolicy(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                MCAAuthorizationManager.PersistencePolicy policy = MCAAuthorizationManager.getInstance().getAuthorizationPersistencePolicy();
                amLogger.debug("PersistencePolicy:" + policy.toString());
                callbackContext.success(policy.toString());
            }
        });
    }

    /**
     * Use the native SDK API to change the sate of the current authorization persistence policy.
     *
     * @param args            JSONArray that contains the new policy to use.
     * @param callbackContext
     */
    private void setAuthorizationPersistencePolicy(final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                String newPolicy = null;
                try {
                    newPolicy = args.getString(0).toUpperCase();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                boolean success = true;
                if (newPolicy.equals(PersistencePolicyNever)) {
                    MCAAuthorizationManager.getInstance().setAuthorizationPersistencePolicy(MCAAuthorizationManager.PersistencePolicy.NEVER);
                } else if (newPolicy.equals(PersistencePolicyAlways)) {
                    MCAAuthorizationManager.getInstance().setAuthorizationPersistencePolicy(MCAAuthorizationManager.PersistencePolicy.ALWAYS);
                } else {
                    success = false;
                    amLogger.debug("Policy cann't be recognized:" + newPolicy.toString());
                    callbackContext.error("The specified persistence policy is not supported.");
                }

                if (success) {
                    amLogger.debug("PersistencePolicy set to:" + newPolicy.toString());
                    callbackContext.success();
                }
            }
        });
    }

    /**
     * Use the native SDK API to get the authorized user identity.
     *
     * @param callbackContext
     */
    private void getUserIdentity(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                UserIdentity userIdentity = MCAAuthorizationManager.getInstance().getUserIdentity();
                amLogger.debug("userIdentity: " + userIdentity.toString());
                callbackContext.success(userIdentity.toString());
            }
        });
    }

    /**
     * Use the native SDK API to get the application identity.
     *
     * @param callbackContext
     */
    private void getAppIdentity(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                AppIdentity appIdentity = MCAAuthorizationManager.getInstance().getAppIdentity();
                amLogger.debug("appIdentity: " + appIdentity.toString());
                callbackContext.success(appIdentity.toString());
            }
        });
    }

    /**
     * Use the native SDK API to get the device identity.
     *
     * @param callbackContext
     */
    private void getDeviceIdentity(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                DeviceIdentity deviceIdentity = MCAAuthorizationManager.getInstance().getDeviceIdentity();
                amLogger.debug("deviceIdentity: " + deviceIdentity.toString());
                callbackContext.success(deviceIdentity.toString());
            }
        });
    }

    /**
     * Use the native SDK API to invoke process to logout.
     * @param callbackContext Callback that will indicate whether the request succeeded or failed
     */
    private void logout(final CallbackContext callbackContext) throws JSONException {

        final Context currentContext = this.cordova.getActivity();

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {

                MCAAuthorizationManager.getInstance().logout(currentContext, new ResponseListener() {
                    @Override
                    public void onSuccess(Response response) {
                        try {
                            PluginResult result = new PluginResult(PluginResult.Status.OK, CDVBMSRequest.packJavaResponseToJSON(response));
                            amLogger.debug("Logout: request successful.");
                            callbackContext.sendPluginResult(result);
                        } catch (JSONException e) {
                            callbackContext.error(e.getMessage());
                        }
                    }

                    @Override
                    public void onFailure(Response failResponse, Throwable t, JSONObject extendedInfo) {
                        try {
                            PluginResult result = new PluginResult(PluginResult.Status.ERROR, CDVBMSRequest.packJavaResponseToJSON(failResponse));
                            amLogger.error("Failed to logout.");
                            callbackContext.sendPluginResult(result);
                        } catch (JSONException e) {
                            callbackContext.error(e.getMessage());
                        }
                    }
                });

            }
        });

    }
}