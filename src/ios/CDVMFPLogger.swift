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

@objc(CDVMFPLogger) class CDVMFPLogger : CDVPlugin {
    
    func getInstance(command: CDVInvokedUrlCommand){
        // parms: [name]
        let name = command.arguments[0] as! String
        
        self.commandDelegate!.runInBackground({
            _ = IMFLogger(forName: name)
        })
    }
    
    func getCapture(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger02 getCapture called")
    }
    
    func setCapture(command: CDVInvokedUrlCommand){
        // parms: enabled
        print("CDVMFPLogger03 setCapture called")
        
        self.commandDelegate!.runInBackground({
            let enabled = command.arguments[0] as! Bool
            
            IMFLogger.setCapture(enabled)
        })
        
    }
    
    func getFilters(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger04 getFilters called")
    }
    
    func setFilters(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger05 setFilters called")
    }
    
    func getMaxStoreSize(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger06 getMaxStoreSize called")
    }
    
    func setMaxStoreSize(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger07 setMaxStoreSize called")
    }
    
    func getLevel(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger08 getLevel called")
    }
    
    func setLevel(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger09 seLevel called")
    }
    
    func isUncaughtExceptionDetected(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger10 isUncaughtExceptionDetected called")
    }
    
    func send(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger11 send called")
    }
    
    func debug(command: CDVInvokedUrlCommand) {
        // parms: [name, message]

        self.commandDelegate!.runInBackground({
            let name = command.arguments[0] as! String
            let message = command.arguments[1] as! String

            let logger = IMFLogger(forName: name)
            logger.logWithLevel(.Debug, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())
        })
    }
    
    func info(command: CDVInvokedUrlCommand){
        // parms: [name, message]

        self.commandDelegate!.runInBackground({
            let name = command.arguments[0] as! String
            let message = command.arguments[1] as! String

            let logger = IMFLogger(forName: name)
            logger.logWithLevel(.Info, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())
        })
    }
    
    func warn(command: CDVInvokedUrlCommand){
        // parms: [name, message]

        self.commandDelegate!.runInBackground({
            let name = command.arguments[0] as! String
            let message = command.arguments[1] as! String

            let logger = IMFLogger(forName: name)
            logger.logWithLevel(.Warn, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())
        })
    }
    
    func error(command: CDVInvokedUrlCommand){
        // parms: [name, message]

        self.commandDelegate!.runInBackground({
            let name = command.arguments[0] as! String
            let message = command.arguments[1] as! String

            let logger = IMFLogger(forName: name)
            logger.logWithLevel(.Error, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())
        })
    }
    
    func fatal(command: CDVInvokedUrlCommand){
        // parms: [name, message]

        self.commandDelegate!.runInBackground({
            let name = command.arguments[0] as! String
            let message = command.arguments[1] as! String

            let logger = IMFLogger(forName: name)
            logger.logWithLevel(.Fatal, message: message, args: CVaListPointer(_fromUnsafeMutablePointer: nil), userInfo:Dictionary<String, String>())
        })
    }
}