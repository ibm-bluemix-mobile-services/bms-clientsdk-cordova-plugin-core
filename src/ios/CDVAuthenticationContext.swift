//
//  CDVAuthenticationContext.swift
//  HelloCordova
//
//  Created by Vitaly Meytin on 11/9/15.
//
//

import Foundation
import IMFCore

@objc(CDVAuthenticationContext) class CDVAuthenticationContext : CDVPlugin {
    
    func submitAuthenticationChallengeAnswer(command: CDVInvokedUrlCommand) {
    
        self.commandDelegate!.runInBackground({
            let answer = command.argumentAtIndex(0)
            let realm = command.argumentAtIndex(1) as! String
            let context = CDVBMSClient.authenticationContexts[realm] as! IMFAuthenticationContext
            context.submitAuthenticationChallengeAnswer(answer as! [NSObject : AnyObject])
            
        })
    }
    
    func submitAuthenticationSuccess(command: CDVInvokedUrlCommand) {
        
    }
    
    func submitAuthenticationFailure(command: CDVInvokedUrlCommand) {
        
    }
}