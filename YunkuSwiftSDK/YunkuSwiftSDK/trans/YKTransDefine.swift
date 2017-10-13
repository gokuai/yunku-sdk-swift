//
//  YKTransDefine.swift
//  YunkuSDK
//
//  Created by wqc on 2017/8/14.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

enum YKTransStatus : Int {
    case None = 0
    case Normal
    case Start
    case Finish
    case Stop
    case Error
    case Removed
}


enum YKTransExpand : Int {
    case None = 0
    case Cache
    case Open
    case Out
    case EditUpload
}

class YKUploadItemData {
    
    var nID = 0
    var opID: String?
    var opName: String?
    var webpath = ""
    var parent = ""
    var filename = ""
    var dir = false
    var filehash = ""
    var uuidhash = ""
    var localpath = ""
    var filesize: Int64 = 0
    var offset: Int64 = 0
    var status: YKTransStatus = .None
    var expand: YKTransExpand = .None
    var errcode = 0
    var errmsg = ""
    var errcount = 0
    var overwrite = false
    
    var notifyInfo: String {
        
        let dic: [String:Any] = [
            "id":nID,
            "webpath":webpath,
            "dir":(dir ? 1 : 0),
            "filename":filename,
            "filehash":filehash,
            "uuidhash":uuidhash,
            "filesize":filesize,
            "offset":offset,
            "status":status.rawValue,
            "errcode":errcode,
            "errmsg":errmsg,
            "overwrite":(overwrite ? 1 : 0)
        ]
        
        return (GYKUtility.obj2str(obj: dic) ?? "")
    }
    
    init() {
        
    }
    
    init(byNotify jsonDic: [AnyHashable:Any]) {
        self.nID = gkSafeInt(dic: jsonDic, key: "id")
        self.webpath = gkSafeString(dic: jsonDic, key: "webpath")
        self.dir = (gkSafeInt(dic: jsonDic, key: "dir") > 0)
        self.filename = gkSafeString(dic: jsonDic, key: "filename")
        self.uuidhash = gkSafeString(dic: jsonDic, key: "uuidhash")
        self.filehash = gkSafeString(dic: jsonDic, key: "filehash")
        self.filesize = gkSafeLongLong(dic: jsonDic, key: "filesize")
        self.status = (YKTransStatus(rawValue: gkSafeInt(dic: jsonDic, key: "status")) ?? status)
        self.offset = gkSafeLongLong(dic: jsonDic, key: "offset")
        self.errcode = gkSafeInt(dic: jsonDic, key: "errcode")
        self.errmsg = gkSafeString(dic: jsonDic, key: "errmsg")
        self.overwrite = (gkSafeInt(dic: jsonDic, key: "overwrite") > 0)
    }
}

