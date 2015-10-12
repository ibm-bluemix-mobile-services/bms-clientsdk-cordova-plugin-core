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
import Foundation
import IMFCore

@objc(CDVMFPAnalytics) class CDVMFPAnalytics : CDVPlugin {
    
    let analytics = IMFAnalytics.sharedInstance()
    
    func enable(command: CDVInvokedUrlCommand){
        analytics.setEnabled(true)
    }
    
    func disable(command: CDVInvokedUrlCommand){
        analytics.setEnabled(false)
    }
    
    func isEnabled(command: CDVInvokedUrlCommand){
        // has success, failure callbacks
        _ = analytics.isEnabled()
    }
    
    func send(command: CDVInvokedUrlCommand){
        // has success, failure callbacks
        
    }
    
    // TODO (For future release)
    func logEvent(command: CDVInvokedUrlCommand){
        // takes parms: msg, name
        
    }
}