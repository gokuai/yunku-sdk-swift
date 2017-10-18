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

