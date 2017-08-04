//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

class FileOperationData :BaseData {
    
    static let stateNoupload = 1
    
    static let keyState = "state"
    static let keyHash = "hash"
    static let keyVersion = "version"
    static let keyServer = "server"

    var state:Int! = 0
    var uuidHash:String! = ""
    var version:String! = ""
    var server:String! = ""

    class func create (_ dic:Dictionary<String,AnyObject>,code:Int) -> FileOperationData {
        let data = FileOperationData()
        data.code = code
        if code == HTTPStatusCode.ok.rawValue {
            data.state = dic[keyState] as? Int
            data.uuidHash = dic[keyHash] as? String
            data.server = dic[keyServer] as? String
        }else {
            
            if let errorMsg = dic[keyErrormsg] as? String {
                data.errorMsg = errorMsg
            }
            if let errorcode = dic[keyErrorcode] as? Int {
                data.errorCode = errorcode
            }
            
        }
        return data
    }

    
}
