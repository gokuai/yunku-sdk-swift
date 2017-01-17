//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 Brandon. All rights reserved.
//

import Foundation

@objc class LogPrint: NSObject {

    private class func printLog<T>(log: T, logLevel: LogLevel) {

        if Config.logPrint {

            if logLevel.rawValue >= Config.logLevel.rawValue {
                let now = NSDate()
                let dformatter = NSDateFormatter()
                dformatter.dateFormat = "HH:mm:ss.fff"
                print("YunkuLog =>\(now) Level:\(logLevel.description), \(log)")
            }

        }

    }

    class func error<T>(msg: T) {
        LogPrint.info("", msg: msg)
    }
    
    class func error<T>(tag:String,msg:T){
        printLog("\(tag) \(msg)", logLevel: LogLevel.Info)
    }

 
    class func warning<T>(msg: T) {
        LogPrint.info("", msg: msg)
    }
    
    class func warning<T>(tag:String,msg:T){
        printLog("\(tag) \(msg)", logLevel: LogLevel.Info)
    }
    
    class func info<T>(msg: T) {
        LogPrint.info("", msg: msg)
    }
    
    class func info<T>(tag:String,msg:T){
        printLog("\(tag) \(msg)", logLevel: LogLevel.Info)
    }

}
