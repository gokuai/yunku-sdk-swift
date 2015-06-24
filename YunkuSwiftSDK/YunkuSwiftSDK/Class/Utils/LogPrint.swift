//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 Brandon. All rights reserved.
//

import Foundation

@objc class LogPrint: NSObject {

    private class func printLog<T>(log: T, logLevel: LogLevel) {

        if Config.logPrint {

            if logLevel.rawValue >= Config.logLevel.rawValue {
                println("LogLevel:\(logLevel.description), \(log)")
            }

        }

    }


    class func error<T>(msg: T) {
        printLog(msg, logLevel: LogLevel.Error)
    }

    class func warning<T>(msg: T) {
        printLog(msg, logLevel: LogLevel.Warning)

    }

    class func info<T>(msg: T) {
        printLog(msg, logLevel: LogLevel.Info)
    }

}
