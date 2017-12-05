//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 Brandon. All rights reserved.
//

import Foundation

@objc open class Config:NSObject  {
    static let userAgent = "YunkuSwiftSDK"
    static let connectTimeOut: TimeInterval = 30

    //如果想打印日志，则在外部调用设置为true
    @objc open static var logPrint = true
    //设定输入日志的等级
    @objc open static var logLevel = LogLevel.error
}

//MARK:日志等级

@objc public enum LogLevel: Int {
    case info = 0, warning, error

    var description: String {
        switch self {
        case .info: return "info";
        case .warning: return "warning";
        case .error: return "error";
        }
    }

}

//MARK:成员类型

@objc public enum MemberType: Int {
    case  account = 0, outId, memberId

    public var description: String {
        switch self {
        case .account: return "account";
        case .outId: return "outid";
        case .memberId: return "memberid";
        }
    }
}

@objc public enum AuthType: Int {
    case `default` = 0, preview, download, upload
    public var description: String {
        switch self {
        case .default: return "default";
        case .preview: return "preview";
        case .download: return "download";
        case .upload: return "upload";
        }
    }

}

//MARK:文件网络类型
@objc public enum NetType:Int{
    
    case `default` = 0, `in`
    public var description: String {
        switch self {
        case .default: return "";//外网
        case .in: return "in";//内网
        }
    }

}

