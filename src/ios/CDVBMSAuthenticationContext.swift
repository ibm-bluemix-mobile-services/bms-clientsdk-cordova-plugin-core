//
//  CDVMFPAuthenticationContext.swift
//  HelloCordova
//
//  Created by Vitaly Meytin on 11/9/15.
//
//

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
