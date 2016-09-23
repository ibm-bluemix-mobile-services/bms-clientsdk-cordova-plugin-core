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

class CDVBMSAuthenticationContext : CDVPlugin {
    
    func submitAuthenticationChallengeAnswer(command: CDVInvokedUrlCommand) {
    
        self.commandDelegate!.run(inBackground: {
            let answer = command.argument(at: 0)
            let realm = command.argument(at: 1) as! String
            //TODO: Fix later (Nana) let context = CDVBMSClient.authenticationContexts[realm] as! IMFAuthenticationContext
            context.submitAuthenticationChallengeAnswer(answer as! [NSObject : AnyObject])
        })
    }

    func submitAuthenticationSuccess(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let realm = command.argument(at: 0) as! String
           //TODO: Fix later (Nana) let context = CDVBMSClient.authenticationContexts[realm] as! IMFAuthenticationContext
            context.submitAuthenticationSuccess()
        })
    }

    func submitAuthenticationFailure(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            let info = command.argument(at: 0) as! [NSObject : AnyObject]
            let realm = command.argument(at: 1) as! String
           //TODO: Fix later (Nana) let context = CDVBMSClient.authenticationContexts[realm] as! IMFAuthenticationContext
            context.submitAuthenticationFailure(info)
        })
    }
