package com.ibm.mobilefirstplatform.clientsdk.cordovaplugins.core;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AuthenticationContext;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AuthenticationListener;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AuthorizationManager;

import android.util.Log;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.MalformedURLException;

import java.lang.reflect.Method;

public class CDVBMSClient extends CordovaPlugin {
    private static final String TAG = "CDVBMSClient";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d(TAG, "In execute()");
        if("initialize".equals(action)) {
            this.initialize(args, callbackContext);
            return true;
        }
        // TODO: registerAuthenticationListener and unregisterAuthenticationListener
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
                //TODO: Verify exception is passed back.
                callbackContext.error(e.getMessage());
            }
            Log.d(TAG, "initialize() : Successfully set up BMSClient");
            callbackContext.success();
        } else {
            callbackContext.error("Expected non-empty string arguments.");
        }
    }

    //TODO
    public void registerAuthenticationListener(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String realm                  = args.getString(0);
        String authenticationListener = args.getString(1);
        if (realm != null && realm.length() > 0) {
            Log.d(TAG, "Called registerAuthenticationListener");

            Log.d(TAG, "Arg1: " + realm);
            Log.d(TAG, "Arg2: " + authenticationListener);
            callbackContext.success(realm);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    //TODO
    public void unregisterAuthenticationListener(JSONArray args, CallbackContext callbackContext) throws JSONException {
        String authenticationListener = args.getString(0);
        if (authenticationListener != null && authenticationListener.length() > 0) {
            Log.d(TAG, "Called unregisterAuthenticationListener");
            Log.d(TAG, "Arg1: " + authenticationListener);
            callbackContext.success(authenticationListener);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }
}
