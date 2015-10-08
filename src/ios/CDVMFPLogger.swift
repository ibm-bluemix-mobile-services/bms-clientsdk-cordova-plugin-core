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
        print("CDVMFPLogger01 getInstance called")
    }
    
    func getCapture(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger02 getCapture called")
    }
    
    func setCapture(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger03 setCapture called")
    }
    
    func getFilters(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger04 getFilters called")
    }
    
    func setFilters(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger05 setFilters called")
    }
    
    func getMaxStoreSize(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger07 getMaxStoreSize called")
    }
    
    func setMaxStoreSize(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger08 setMaxStoreSize called")
    }
    
    func getLevel(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger09 getLevel called")
    }
    
    func seLevel(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger10 seLevel called")
    }
    
    func isUncaughtExceptionDetected(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger11 isUncaughtExceptionDetected called")
    }
    
    func send(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger12 send called")
    }
    
    func debug(command: CDVInvokedUrlCommand) {
        print("CDVMFPLogger13 debug called")
    }
    
    func info(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger14 info called")
    }
    
    func warn(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger15 warn called")
    }
    
    func error(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger16 command called")
    }
    
    func fatal(command: CDVInvokedUrlCommand){
        print("CDVMFPLogger17 fatal called")
    }
    
}