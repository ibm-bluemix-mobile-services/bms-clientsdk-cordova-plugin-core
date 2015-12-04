//
//  CDVMFPAuthenticationContext.swift
//  HelloCordova
//
//  Created by Vitaly Meytin on 11/9/15.
//
//

import Foundation
import IMFCore

@objc(CDVMFPAuthenticationContext) class CDVMFPAuthenticationContext : CDVPlugin {
    
    func submitAuthenticationChallengeAnswer(command: CDVInvokedUrlCommand) {
    
        self.commandDelegate!.runInBackground({
            let answer = command.argumentAtIndex(0)
            let realm = command.argumentAtIndex(1) as! String
            let context = CDVBMSClient.authenticationContexts[realm] as! IMFAuthenticationContext
            context.submitAuthenticationChallengeAnswer(answer as! [NSObject : AnyObject])
        })
    }
    
    func submitAuthenticationSuccess(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let realm = command.argumentAtIndex(0) as! String
            let context = CDVBMSClient.authenticationContexts[realm] as! IMFAuthenticationContext
            context.submitAuthenticationSuccess()
        })
    }
    
    func submitAuthenticationFailure(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            let info = command.argumentAtIndex(0) as! [NSObject : AnyObject]
            let realm = command.argumentAtIndex(1) as! String
            let context = CDVBMSClient.authenticationContexts[realm] as! IMFAuthenticationContext
            context.submitAuthenticationFailure(info)
        })
    }
}