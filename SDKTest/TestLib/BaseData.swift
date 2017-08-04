//
//  BaseData.swift
//  TestLib
//
//  Created by Brandon on 15/6/3.
//  Copyright (c) 2015年 goukuai. All rights reserved.
//

import Foundation

class BaseData: NSObject {

    static let keyErrorCode = "error_code"
    static let keyErrorMsg = "error_msg"
    
    var errorCode: Int! = 0
    var errorMsg: String! = ""
    
    class func create(_ dic: Dictionary<String, AnyObject>) -> BaseData {
        let baseData = BaseData()
        if let errorMsg = dic[keyErrorMsg] as? String {
            baseData.errorMsg = errorMsg
        }
        
        if let errorcode = dic[keyErrorCode] as? Int {
            baseData.errorCode = errorcode
        }
        return baseData
    }

}
