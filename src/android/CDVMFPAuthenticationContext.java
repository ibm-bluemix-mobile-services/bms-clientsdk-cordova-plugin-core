package com.ibm.mobilefirstplatform.clientsdk.cordovaplugins.core;

import com.ibm.mobilefirstplatform.clientsdk.android.core.api.BMSClient;
import com.ibm.mobilefirstplatform.clientsdk.android.logger.api.Logger;
import com.ibm.mobilefirstplatform.clientsdk.android.security.api.AuthenticationContext;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


/**
 * Created by rotembr on 11/6/15.
 */
public class CDVMFPAuthenticationContext extends CordovaPlugin {
    private String errorEmptyArg = "Expected non-empty string argument.";
    private static final Logger acLogger = Logger.getInstance(Logger.INTERNAL_PREFIX + "CDVMFPAuthContext");

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        boolean ans = true;
        if ("submitAuthenticationChallengeAnswer".equals(action)) {
            this.submitAuthenticationChallengeAnswer(args, callbackContext);
        } else if ("submitAuthenticationSuccess".equals(action)) {
            this.submitAuthenticationSuccess(args, callbackContext);
        } else if ("submitAuthenticationFailure".equals(action)) {
            this.submitAuthenticationFailure(args, callbackContext);
        }else {
            ans = false;
        }
        return ans;

    }

    /**
     * Use the native SDK API to submits authentication challenge response.
     *
     * @param args            JSONArray that contains the realm and JSON with challenge response.
     * @param callbackContext
     */
    private void submitAuthenticationChallengeAnswer(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                JSONObject answer = null;
                try {
                    answer = args.getJSONObject(0);
                    String realm = args.getString(1);
                    acLogger.debug("Called submitAuthenticationChallengeAnswer");
                    callbackContext.success("submitAuthenticationChallengeAnswer called");
                    CDVBMSClient.authContexsMap.get(realm).submitAuthenticationChallengeAnswer(answer);
                } catch (JSONException e) {
                    acLogger.error("submitAuthenticationChallengeAnswer :: " + errorEmptyArg);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    /**
     * Use the native SDK API to informs about authentication success.
     *
     * @param args            JSONArray that contains the realm.
     * @param callbackContext
     */
    private void submitAuthenticationSuccess(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                String realm = null;
                try {
                    realm = args.getString(0);
                    acLogger.debug("Called submitAuthenticationSuccess");
                    callbackContext.success("submitAuthenticationSuccess called");
                    CDVBMSClient.authContexsMap.get(realm).submitAuthenticationSuccess();
                } catch (JSONException e) {
                    acLogger.error("submitAuthenticationSuccess :: " + errorEmptyArg);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

    /**
     * Use the native SDK API to informs about authentication failure.
     *
     * @param args            JSONArray that contains the realm and info, information about the failure.
     * @param callbackContext
     */
    private void submitAuthenticationFailure(final JSONArray args, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            public void run() {
                JSONObject info = null;
                try {
                    info = args.getJSONObject(0);
                    String realm = args.getString(1);
                    callbackContext.success("submitAuthenticationFailure called");
                    acLogger.debug("Called submitAuthenticationFailure");
                    CDVBMSClient.authContexsMap.get(realm).submitAuthenticationFailure(info);
                } catch (JSONException e) {
                    acLogger.error("submitAuthenticationFailure :: " + errorEmptyArg);
                    callbackContext.error(e.getMessage());
                }
            }
        });
    }

}
