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

import com.ibm.mobilefirstplatform.clientsdk.android.analytics.api.*;

import android.util.Log;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;

public class CDVMFPAnalytics extends CordovaPlugin {
    private static final String TAG = "CDVMFPAnalytics";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("enable".equals(action)) {
            MFPAnalytics.enable();
            callbackContext.success();
            return true;
        } else if("disable".equals(action)) {
            MFPAnalytics.disable();
            callbackContext.success();
            return true;
        } else if("isEnabled".equals(action)) {
            //TODO: This does not exist for Android SDK
//            Boolean enabledFlag = MFPAnalytics.isEnabled();
//            callbackContext.success(enabledFlag);
            return true;
        } else if("send".equals(action)) {
            MFPAnalytics.send();
            callbackContext.success();
            return true;
        } else if("logEvent".equals(action)) {
            // TODO: Not yet implemented for the Android SDK
            return true;
        }
        return false;
    }

}