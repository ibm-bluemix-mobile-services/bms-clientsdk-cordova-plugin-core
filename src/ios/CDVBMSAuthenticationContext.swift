/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/


import Foundation
import BMSCore
import BMSSecurity

@objc(CDVBMSAuthenticationContext) class CDVBMSAuthenticationContext : CDVPlugin {

    func submitAuthenticationChallengeAnswer(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let answer = command.argument(at: 0)
                let realm = command.argument(at: 1) as! String
                 let context = CDVBMSClient.authenticationContexts[realm] as! AuthenticationContext
                context.submitAuthenticationChallengeAnswer(answer as! [String : AnyObject]?)
            })
        #else
            self.commandDelegate!.runInBackground({
                let answer = command.argumentAtIndex(0)
                let realm = command.argumentAtIndex(1) as! String
                let context = CDVBMSClient.authenticationContexts[realm] as! AuthenticationContext
                context.submitAuthenticationChallengeAnswer(answer as? [String : AnyObject])
            })
        #endif
    }

    func submitAuthenticationSuccess(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let realm = command.argument(at: 0) as! String
                let context = CDVBMSClient.authenticationContexts[realm] as! AuthenticationContext
                context.submitAuthenticationSuccess()
            })
        #else
            self.commandDelegate!.runInBackground({
                let realm = command.argumentAtIndex(0) as! String
                let context = CDVBMSClient.authenticationContexts[realm] as! AuthenticationContext
                context.submitAuthenticationSuccess()
            })
        #endif
    }

    func submitAuthenticationFailure(_ command: CDVInvokedUrlCommand) {
        #if swift(>=3.0)
            self.commandDelegate!.run(inBackground: {
                let info = command.argument(at: 0) as! [String : AnyObject]
                let realm = command.argument(at: 1) as! String
                let context = CDVBMSClient.authenticationContexts[realm] as! AuthenticationContext
                context.submitAuthenticationFailure(info)
        })
        #else
            self.commandDelegate!.runInBackground({
                let info = command.argumentAtIndex(0) as! [NSObject : AnyObject]
                let realm = command.argumentAtIndex(1) as! String
                let context = CDVBMSClient.authenticationContexts[realm] as! AuthenticationContext
                context.submitAuthenticationFailure(info as? [String: AnyObject])
            })
        #endif
    }
}
