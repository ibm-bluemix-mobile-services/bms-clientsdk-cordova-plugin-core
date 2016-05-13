/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/

package com.ibm.mobilefirstplatform.clientsdk.cordovaplugins.core;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.*;

import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class CDVBMSLogger extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {

        if (action.equals("log")) {
            this.log(args, callbackContext);
        }
        else if (action.equals("getLogLevelFilter")) {
            this.getLogLevelFilter(callbackContext);
        }
        else if (action.equals("setLogLevelFilter")) {
            this.setLogLevelFilter(args, callbackContext);
        }
        else if (action.equals("sdkDebugLoggingEnabled")) {
            this.sdkDebugLoggingEnabled(callbackContext);
        }
        else if (action.equals("setSDKDebugLogging")) {
            this.setSDKDebugLogging(args, callbackContext);
        }
        else if (action.equals("getLogStore")) {
            this.getLogStore(callbackContext);
        }
        else if (action.equals("setLogStore")) {
            this.setLogStore(args, callbackContext);
        }
        else if (action.equals("getMaxLogStoreSize")) {
            this.getMaxLogStoreSize(callbackContext);
        }
        else if (action.equals("setMaxLogStoreSize")) {
            this.setMaxLogStoreSize(args, callbackContext);
        }
        else if (action.equals("isUncaughtExceptionDetected")) {
            this.isUncaughtExceptionDetected(callbackContext);
        }
        else {
            return false;
        }
        return true;
    }

    public void log(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!(args.get(0) instanceof String)) {
                        callbackContext.error("Unable to log message. Logger name parameter is invalid");
                        return;
                    }
                    final String name = args.getString(0);

                    if (!(args.get(1) instanceof String)) {
                        callbackContext.error("Unable to log message. Message parameter is invalid");
                        return;
                    }
                    final String message = args.getString(1);

                    if (!(args.get(2) instanceof String)) {
                        callbackContext.error("Unable to log message. Level parameter is invalid");
                        return;
                    }
                    final String level = args.getString(2);

                    Logger logger = Logger.getLogger(name);

                    if (level.equals("DEBUG")) {
                        logger.debug(message);
                    } else if (level.equals("INFO")) {
                        logger.info(message);
                    } else if (level.equals("WARN")) {
                        logger.warn(message);
                    } else if (level.equals("ERROR")) {
                        logger.error(message);
                    } else if (level.equals("FATAL")) {
                        logger.fatal(message);
                    } else {
                        callbackContext.error("Unable to log message. Invalid log level.");
                        return;
                    }

                    String cbMessage = "Logged " + level + "level message";
                    callbackContext.success(cbMessage);
                }
                catch (JSONException e) {
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public void getLogLevelFilter(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                String level = null;

                switch (Logger.getLogLevel()) {
                    case ANALYTICS:
                        level = "ANALYTICS";
                        break;
                    case FATAL:
                        level = "FATAL";
                        break;
                    case ERROR:
                        level = "ERROR";
                        break;
                    case WARN:
                        level = "WARN";
                        break;
                    case INFO:
                        level = "INFO";
                        break;
                    case DEBUG:
                        level = "DEBUG";
                }

                callbackContext.success(level);
            }
        });
    }

    public void setLogLevelFilter(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!(args.get(0) instanceof String)) {
                        String message = "Unable to set log level filter. Level parameter is invalid. Use one of the BMSLogger.Level constants";
                        callbackContext.error(message);
                        return;
                    }
                    final String level = args.getString(0);

                    Logger.LEVEL levelFilter = getLevelFilter(level);

                    if (levelFilter == null) {
                        String message = "Unable to set log level filter. Level parameter is invalid. Use one of the BMSLogger.Level constants";
                        callbackContext.error(message);
                        return;
                    }

                    Logger.setLogLevel(levelFilter);

                    String message = "Log level filter is set to " + level;
                    callbackContext.success(message);
                }
                catch (JSONException e) {
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public void sdkDebugLoggingEnabled(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                boolean value = Logger.isSDKDebugLoggingEnabled();
                PluginResult result = new PluginResult(PluginResult.Status.OK, value);
                callbackContext.sendPluginResult(result);
            }
        });
    }

    public void setSDKDebugLogging(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!(args.get(0) instanceof Boolean)) {
                        String message = "Unable to set SDK debug logging. Parameter must be a boolean value";
                        callbackContext.error(message);
                        return;
                    }
                    final boolean value = args.getBoolean(0);

                    Logger.setSDKDebugLoggingEnabled(value);

                    String message = "SDK debug logging is set to " + value;
                    callbackContext.success(message);
                }
                catch (JSONException e) {
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public void getLogStore(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                boolean logStore = Logger.isStoringLogs();
                PluginResult result = new PluginResult(PluginResult.Status.OK, logStore);
                callbackContext.sendPluginResult(result);
            }
        });
    }

    public void setLogStore(final JSONArray args, final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!(args.get(0) instanceof Boolean)) {
                        String message = "Unable to set log store. Parameter must be a boolean value";
                        callbackContext.error(message);
                        return;
                    }
                    final boolean value = args.getBoolean(0);

                    Logger.storeLogs(value);

                    String message = "Log store is set to " + value;
                    callbackContext.success(message);
                }
                catch (JSONException e) {
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public void getMaxLogStoreSize(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                int size = Logger.getMaxLogStoreSize();
                PluginResult result = new PluginResult(PluginResult.Status.OK, size);
                callbackContext.sendPluginResult(result);
            }
        });
    }

    public void setMaxLogStoreSize(final JSONArray args, final CallbackContext callbackContext) {
        
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (!(args.get(0) instanceof Integer)) {
                        String message = "Unable to set log store. Parameter must be an integer value";
                        callbackContext.error(message);
                        return;
                    }
                    final int size = args.getInt(0);

                    Logger.setMaxLogStoreSize(size);

                    String message = "Max log store size is set to " + size + " bytes";
                    callbackContext.success(message);
                }
                catch (JSONException e) {
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    public void isUncaughtExceptionDetected(final CallbackContext callbackContext) {

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                boolean caught = Logger.isUnCaughtExceptionDetected();
                PluginResult result = new PluginResult(PluginResult.Status.OK, caught);
                callbackContext.sendPluginResult(result);
            }
        });
    }

    private Logger.LEVEL getLevelFilter(String level) {

        Logger.LEVEL levelFilter;

        if (level.equals("ANALYTICS")) {
            levelFilter = Logger.LEVEL.ANALYTICS;
        }
        else if (level.equals("FATAL")) {
            levelFilter = Logger.LEVEL.FATAL;
        }
        else if (level.equals("ERROR")) {
            levelFilter = Logger.LEVEL.ERROR;
        }
        else if (level.equals("WARN")) {
            levelFilter = Logger.LEVEL.WARN;
        }
        else if (level.equals("INFO")) {
            levelFilter = Logger.LEVEL.INFO;
        }
        else if (level.equals("DEBUG")) {
            levelFilter = Logger.LEVEL.DEBUG;
        }
        else {
            levelFilter = null;
        }

        return levelFilter;
    }
}