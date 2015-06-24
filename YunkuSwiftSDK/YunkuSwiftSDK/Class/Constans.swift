//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 Brandon. All rights reserved.
//

import Foundation

@objc public class Config:NSObject  {
    static let userAgent = "YunkuSwiftSDK"
    static let connectTimeOut: NSTimeInterval = 30

    //如果想打印日志，则在外部调用设置为true
    public static var logPrint = true
    //设定输入日志的等级
    public static var logLevel = LogLevel.Error
}

//MARK:日志等级

@objc public enum LogLevel: Int {
    case Info = 0, Warning, Error

    var description: String {
        switch self {
        case .Info: return "info";
        case .Warning: return "warning";
        case .Error: return "error";
        }
    }

}

//MARK:成员类型

@objc public enum MemberType: Int {
    case  Account = 0, OutId, MemberId

    public var description: String {
        switch self {
        case .Account: return "account";
        case .OutId: return "outid";
        case .MemberId: return "memberid";
        }
    }
}

@objc public enum AuthType: Int {
    case Default = 0, Preview, Download, Upload
    public var description: String {
        switch self {
        case .Default: return "default";
        case .Preview: return "preview";
        case .Download: return "download";
        case .Upload: return "upload";
        }
    }

}

