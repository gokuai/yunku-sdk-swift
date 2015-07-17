//
//  BaseData.swift
//  YunkuSwiftSDK
//
//  Created by Brandon on 15/6/16.
//  Copyright (c) 2015年 goukuai. All rights reserved.
//

import Foundation

@objc class BaseData : NSObject {
    var code: Int! = 0
    var errorMsg: String! = ""
    var errorCode :Int! = 0
    
    static let keyErrorcode = "error_code"
    static let keyErrormsg = "error_msg"

}
