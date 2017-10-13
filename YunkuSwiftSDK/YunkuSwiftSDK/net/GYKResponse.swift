//
//  GKRequestRet.swift
//  gknet
//
//  Created by wqc on 2017/7/28.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

public class GYKResponse : NSObject {
    var response: HTTPURLResponse?
    @objc public var data: Data?
    @objc public var statuscode = 0
    @objc public var errcode = 0
    @objc public var errmsg = ""
    var url = ""
    
    @objc public var json: String {
        return data?.gyk_str ?? ""
    }

    @objc public var errorLogInfo: String {
        
        var s = url + "; "
        if response != nil {
            s.append(response!.debugDescription)
            s.append("; ")
        }
        if data != nil {
            s.append((data!.gyk_str ?? ""))
            s.append("; ")
        }
        s.append("\(self.errcode)")
        s.append(":\(errmsg)")
        return s
    }
    
    required public override init() {
        super.init()
        data = Data()
    }
    
    
    class func create(_ type: GYKResponse.Type) -> GYKResponse {
        return type.init()
    }
    
    func parse() {
        
    }
    
    func parseError() {
        
        if self.data == nil || self.data!.isEmpty {
            self.errcode = 1
            self.errmsg = "no error return"
            return
        }
        
        let kResponseErrorKeyMsg = "error_msg"
        let kResponseErrorKeyDesc = "error_description"
        let kResponseErrorKeyCode = "error_code"
        
        if let dataDic = data!.gyk_dic {
            errcode = (dataDic[kResponseErrorKeyCode] as? Int) ?? 1
            var emsg = ((dataDic[kResponseErrorKeyMsg] as? String) ?? "")
            if emsg.isEmpty {
                emsg = ((dataDic[kResponseErrorKeyDesc] as? String) ?? "")
            }
            if emsg.isEmpty {
                emsg = "some unknown error"
            }
            errmsg = emsg
        } else {
            errcode = 1
            errmsg = (data!.gyk_str ?? "")
        }
    }
}

class GYKTokenResponse : GYKResponse {
    var accessToken = ""
    var refreshToken = ""

    override func parse() {
        if let dic = self.data?.gyk_dic {
            self.accessToken = (dic["access_token"] as? String) ?? ""
            self.refreshToken = (dic["refresh_token"] as? String) ?? ""
        }
    }

}
//
//class GYKFavoriteItem : NSObject {
//
//    public var favid = 0
//    public var name = ""
//}
//
//class GYKAccountInfoResponse : GYKResponse {
//
//    var member_id = 0
//    var member_name = ""
//    var member_email = ""
//    var member_phone = ""
//    var member_account = ""
//    var avatar = ""
//    var language = "zh_CN"
//    var validate = 1
//    var uuid = ""
//    var product_name = ""
//    var product_id = 0
//    var yunku_count = 0
//    var isvip = 0
//    var edit_password = 0
//    var disable_new_device = 0
//    var favorites = [GYKFavoriteItem]()
//
//    override func parse() {
//        if let dic = self.data?.gyk_dic {
//            self.parseFromDic(dic: dic)
//        }
//    }
//
//    public func parseFromDic(dic: [AnyHashable:Any]) {
//        self.member_id = gkSafeInt(dic: dic, key: "member_id")
//        self.member_name = gkSafeString(dic: dic, key: "member_name")
//        self.member_email = gkSafeString(dic: dic, key: "member_email")
//        self.member_phone = gkSafeString(dic: dic, key: "member_phone")
//        self.member_account = gkSafeString(dic: dic, key: "member_account")
//        self.avatar = gkSafeString(dic: dic, key: "avatar")
//        self.language = gkSafeString(dic: dic, key: "language", def: "zh_CN")
//        self.uuid = gkSafeString(dic: dic, key: "uuid")
//        self.product_id = gkSafeInt(dic: dic, key: "product_id")
//        self.product_name = gkSafeString(dic: dic, key: "product_name")
//        self.yunku_count = gkSafeInt(dic: dic, key: "yunku_count")
//        self.isvip = gkSafeInt(dic: dic, key: "isvip")
//        self.validate = gkSafeInt(dic: dic, key: "validate")
//
//        if let favorite_names = gkSafeDic(dic: dic, key: "favorite_names") {
//            for (k,v) in favorite_names {
//                let favid = Int((k as? String) ?? "0")
//                let name = v as? String
//                if favid != nil && name != nil {
//                    let item = GYKFavoriteItem()
//                    item.favid = favid!
//                    item.name = name!
//                    favorites.append(item)
//                }
//            }
//        }
//
//        if let property = gkSafeDic(dic: dic, key: "property") {
//            if let temp = property["edit_password"] as? Int {
//                self.edit_password = temp
//            }
//        }
//
//        if let settings = gkSafeDic(dic: dic, key: "settings") {
//            if let temp = settings["disable_new_device"] as? Int {
//                self.disable_new_device = temp
//            }
//        }
//    }
//
//}

//public class GYKEntsResponse : GYKResponse {
//
//    public var ents = [GYKEntDataItem]()
//
//    override func parse() {
//        if let dic = self.data?.gyk_dic {
//            if let list = dic["list"] as? Array<Any> {
//                var temparr = [GKEntDataItem]()
//                for entdic in list {
//                    let item = GKEntDataItem(json: entdic)
//                    if item != nil {
//                        temparr.append(item!)
//                    }
//                }
//                self.ents = temparr
//            }
//        }
//    }
//
//}
//
//public class GYKMountsResponse : GYKResponse {
//
//    public var mounts = [GKMountDataItem]()
//
//    override func parse() {
//        if let dic = self.data?.gyk_dic {
//            if let list = dic["list"] as? Array<Any> {
//                var temparr = [GKMountDataItem]()
//                for entdic in list {
//                    let item = GKMountDataItem(json: entdic)
//                    if item != nil {
//                        temparr.append(item!)
//                    }
//                }
//                self.mounts = temparr
//            }
//        }
//    }
//
//}
//
//public class GYKShortcutsResponse : GYKResponse {
//
//    public var shortcuts = [GKShortcutItem]()
//
//    override func parse() {
//        if let dic = self.data?.gyk_dic {
//            if let list = dic["list"] as? Array<Any> {
//                var temparr = [GKShortcutItem]()
//                for entdic in list {
//                    let item = GKShortcutItem(json: entdic)
//                    if item != nil {
//                        temparr.append(item!)
//                    }
//                }
//                self.shortcuts = temparr
//            }
//        }
//    }
//
//}
//
//public class GYKFileListResponse : GYKResponse {
//
//    public var files = [GKFileDataItem]()
//
//    override func parse() {
//        if let dic = self.data?.gyk_dic {
//            if let list = dic["list"] as? Array<Any> {
//                var temparr = [GKFileDataItem]()
//                for d in list {
//                    let item = GKFileDataItem(json: d)
//                    if item != nil {
//                        temparr.append(item!)
//                    }
//                }
//                self.files = temparr
//            }
//        }
//    }
//}
//
//public class GYKSourceResponse : GYKResponse {
//
//    public var id = ""
//    public var source = ""
//
//    override func parse() {
//
//    }
//
//}


class GYKHostItem : NSObject {
    var hostname = ""
    var hostnamein = ""
    var port = ""
    public var path = ""
    public var sign = ""
    var https = 0

    init(jsonDic: [AnyHashable:Any]) {
        self.hostname = gkSafeString(dic: jsonDic, key: "hostname")
        self.hostnamein = gkSafeString(dic: jsonDic, key: "hostname-in")
        self.port = gkSafeString(dic: jsonDic, key: "port")
        self.https = gkSafeInt(dic: jsonDic, key: "https")
        self.sign = gkSafeString(dic: jsonDic, key: "sign")
        self.path = gkSafeString(dic: jsonDic, key: "path")
    }

    public func fullurl(usehttps:Bool,hostin:Bool, withpath: Bool = true) -> String {
        var host = hostname
        let proto = (usehttps ? "https://" : "http://")
        if hostin {
            host = hostnamein
        }
        host = "\(proto)" + host

        if usehttps {
            if self.https != 443 {
                host.append(":\(self.https)")
            }
        } else {
            if self.port != "80" {
                host.append(":\(self.port)")
            }
        }

        if withpath && !self.path.isEmpty {
            host.append("/\(self.path)")
        }

        return host
    }
}

class GYKCreateFileResponse : GYKResponse {

    public var uuidhash = ""
    public var fullpath = ""
    public var state = 0
    public var filehash = ""
    public var filesize: Int64 = 0
    public var uploads = [GYKHostItem]()
    public var cache_uploads = [GYKHostItem]()
    public var server = ""

    override func parse() {
        if let dic = self.data?.gyk_dic {
            self.uuidhash = gkSafeString(dic: dic, key: "hash")
            self.fullpath = gkSafeString(dic: dic, key: "fullpath")
            self.filehash = gkSafeString(dic: dic, key: "filehash")
            self.state = gkSafeInt(dic: dic, key: "state")

            if let a = dic["uploads"] {
                if let arr = a as? [Any] {
                    for item in arr {
                        if let dic = item as? [AnyHashable:Any] {
                            let hostitem = GYKHostItem(jsonDic: dic)
                            self.uploads.append(hostitem)
                        }
                    }
                }
            }

            if let a = dic["cache_uploads"] {
                if let arr = a as? [Any] {
                    for item in arr {
                        if let dic = item as? [AnyHashable:Any] {
                            let hostitem = GYKHostItem(jsonDic: dic)
                            self.cache_uploads.append(hostitem)
                        }
                    }
                }
            }
            
            self.server = gkSafeString(dic: dic, key: "server")
        }
    }
}
//
//public class GYKDownloadURLResponse : GYKResponse {
//
//    public var filesize: Int64 = 0
//    public var urls = [String]()
//
//    override func parse() {
//        if let dic = self.data?.gyk_dic {
//            self.filesize = gkSafeLongLong(dic: dic, key: "filesize")
//            if let arr = dic["urls"] as? Array<Any> {
//                for item in arr {
//                    if item is String {
//                        self.urls.append(item as! String)
//                    }
//                }
//            }
//
//        }
//    }
//
//}
//
//public class GKRequestRetGetServerSite : GYKResponse {
//
//    public var servers = [GKHostItem]()
//
//    override func parse() {
//        if let arr = self.data?.gkArr {
//
//            for item in arr {
//                if let dic = item as? [AnyHashable:Any] {
//                    let hostitem = GKHostItem(jsonDic: dic)
//                    self.servers.append(hostitem)
//                }
//            }
//        }
//    }
//}
//
//public class GKRequestRetFileLinkList : GYKResponse {
//
//    public var owner = [GKFileLinkItem]()
//    public var other = [GKFileLinkItem]()
//
//    override func parse() {
//        if let dic = self.data?.gyk_dic {
//            if let arr = dic["owner"] as? Array<Any> {
//                for item in arr {
//                    if let itemdic = item as? [AnyHashable:Any] {
//                        if let link = GKFileLinkItem(json: itemdic) {
//                            owner.append(link)
//                        }
//                    }
//                }
//            }
//
//            if let arr = dic["other"] as? Array<Any> {
//                for item in arr {
//                    if let itemdic = item as? [AnyHashable:Any] {
//                        if let link = GKFileLinkItem(json: itemdic) {
//                            other.append(link)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//public class GKRequestRetCreateFileLink : GKRequestBaseRet {
//
//    public var code = ""
//    public var link = ""
//    public var qr_url = ""
//
//    override func parse() {
//        if let dic = self.data?.gyk_dic {
//            self.code = gkSafeString(dic: dic, key: "code")
//            self.link = gkSafeString(dic: dic, key: "link")
//            self.qr_url = gkSafeString(dic: dic, key: "qr_url")
//        }
//    }
//
//}

