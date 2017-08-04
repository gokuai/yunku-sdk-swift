//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 Brandon. All rights reserved.
//

import Foundation

@objc class LogPrint: NSObject {

    fileprivate class func printLog<T>(_ log: T, logLevel: LogLevel) {

        if Config.logPrint {

            if logLevel.rawValue >= Config.logLevel.rawValue {
                let now = Date()
                let dformatter = DateFormatter()
                dformatter.dateFormat = "HH:mm:ss.fff"
                print("YunkuLog =>\(now) Level:\(logLevel.description), \(log)")
            }

        }

    }

    class func error<T>(_ msg: T) {
        LogPrint.error("", msg: msg)
    }
    
    class func error<T>(_ tag:String,msg:T){
        printLog("\(tag) \(msg)", logLevel: LogLevel.error)
    }

 
    class func warning<T>(_ msg: T) {
        LogPrint.warning("", msg: msg)
    }
    
    class func warning<T>(_ tag:String,msg:T){
        printLog("\(tag) \(msg)", logLevel: LogLevel.warning)
    }
    
    class func info<T>(_ msg: T) {
        LogPrint.info("", msg: msg)
    }
    
    class func info<T>(_ tag:String,msg:T){
        printLog("\(tag) \(msg)", logLevel: LogLevel.info)
    }

}
