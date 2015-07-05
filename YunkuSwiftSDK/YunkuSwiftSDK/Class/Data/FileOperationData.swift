//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

public class FileOperationData :BaseData {
    
    static let stateNoupload = 1
    
    static let keyState = "state"
    static let keyHash = "hash"
    static let keyVersion = "version"
    static let keyServer = "server"

    var state:Int! = 0
    var uuidHash:String! = ""
    var version:String! = ""
    var server:String! = ""

    class func create (dic:Dictionary<String,AnyObject>,code:Int) -> FileOperationData {
        var data = FileOperationData()
        data.code = code
        if code == HTTPStatusCode.OK.rawValue {
            data.state = dic[keyState] as? Int
            data.uuidHash = dic[keyHash] as? String
            data.server = dic[keyServer] as? String
        }else {
            data.errorCode = dic[keyErrorcode] as? Int
            data.errorMsg = dic[keyErrormsg] as? String
        }
        return data
    }

    
}
