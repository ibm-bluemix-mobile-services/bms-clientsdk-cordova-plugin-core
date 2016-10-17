/*
    Copyright 2016 IBM Corp.
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

import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;
import com.ibm.mobilefirstplatform.clientsdk.android.core.api.Response;
import com.ibm.mobilefirstplatform.clientsdk.android.core.api.ResponseListener;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.Logger.LEVEL;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class CDVBMSLogger extends CordovaPlugin {

    private static final Logger mfpLogger = Logger.getLogger(Logger.INTERNAL_PREFIX + "CDVBMSLogger");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        mfpLogger.debug("execute :: action = " + action);
        if("storeLogs".equals(action)) {
            boolean shouldStoreLogs = args.getBoolean(0);
            Logger.storeLogs(shouldStoreLogs);
            return true;
        }  else if("isStoringLogs".equals(action)) {
            this.isStoringLogs(callbackContext);
            return true;
        }  else if("getMaxLogStoreSize".equals(action)) {
            this.getMaxLogStoreSize(callbackContext);
            return true;
        } else if("setMaxLogStoreSize".equals(action)) {
            int newStoreSize = args.getInt(0);
            Logger.setMaxLogStoreSize(newStoreSize);
            callbackContext.success();
            return true;
        } else if("getLogLevel".equals(action)) {
            this.getLogLevel(callbackContext);
            return true;
        } else if("setLogLevel".equals(action)) {
            LEVEL newLevel = LEVEL.fromString(args.getString(0));
            Logger.setLogLevel(newLevel);
            callbackContext.success();
            return true;
        } else if("setSDKDebugLoggingEnabled".equals(action)) {
            boolean debugEnabled = args.getBoolean(0);
            Logger.setSDKDebugLoggingEnabled(debugEnabled);
            callbackContext.success();
            return true;
        }  else if("isSDKDebugLoggingEnabled".equals(action)) {
            this.isSDKDebugLoggingEnabled(callbackContext);
            return true;
        } else if("isUncaughtExceptionDetected".equals(action)) {
            String uncaughtExceptionFlag = String.valueOf(Logger.isUnCaughtExceptionDetected());
            callbackContext.success(uncaughtExceptionFlag);
            return true;
        }  else if("send".equals(action)) {
            this.send(callbackContext);
            return true;

        } else if("fatal".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getLogger(packageName);
            instance.fatal(message);

            callbackContext.success();
            return true;
        } else if("error".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getLogger(packageName);
            instance.error(message);

            callbackContext.success();
            return true;
        } else if("warn".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getLogger(packageName);
            instance.warn(message);

            callbackContext.success();
            return true;
        } else if("info".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getLogger(packageName);
            instance.info(message);

            callbackContext.success();
            return true;
        } else if("debug".equals(action)) {
            String packageName = args.getString(0);
            String message = args.getString(1);

            Logger instance = Logger.getLogger(packageName);
            instance.debug(message);

            callbackContext.success();
            return true;
        }
        return false;
    }


    public void getMaxLogStoreSize(final CallbackContext callbackContext) {
        final int maxStoreSize = Logger.getMaxLogStoreSize();

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                callbackContext.success(maxStoreSize);
            }
        });
    }

    public void isStoringLogs(final CallbackContext callbackContext){
        final int isStoring = Logger.isStoringLogs() ? 1 : 0;

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                callbackContext.success(isStoring);
            }
        });
    }

    public void getLogLevel(final CallbackContext callbackContext) {
        final String currentLevel = String.valueOf(Logger.getLogLevel());

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                callbackContext.success(currentLevel);
            }
        });
    }


    public void isSDKDebugLoggingEnabled(final CallbackContext callbackContext) {
        final int SDKDebugLoggingEnabled = Logger.isSDKDebugLoggingEnabled() ? 1 : 0;

        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                callbackContext.success(SDKDebugLoggingEnabled);
            }
        });
    }


    /**
     * Sends non-Analytics logs to the server
     * @param callbackContext Callback that will indicate whether the request succeeded or failed
     */
    public void send(final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                Logger.send(new ResponseListener() {
                    @Override
                    public void onSuccess(Response r) {
                        callbackContext.success("send(): Successfully sent logs");
                    }

                    @Override
                    public void onFailure(Response r, Throwable t, JSONObject extendedInfo) {
                        callbackContext.error("send(): Failed to send logs");
                    }
                });
            }
        });
    }


}