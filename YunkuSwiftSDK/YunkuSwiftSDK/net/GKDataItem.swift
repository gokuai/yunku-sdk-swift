//
//  GKDataItem.swift
//  gknet
//
//  Created by wqc on 2017/7/24.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation
import gkutility

public class GKBaseDataItem : NSObject {
    
    public var rawJson: String?
    
    public override init() {
        super.init()
    }
    
    public init?(json: Any) {
        if let dic = gkutility.json2dic(obj: json) {
            super.init()
            self.setWithJsonDic(dic)
        } else {
            return nil
        }
    }
    
    public func setWithJsonDic(_ dic: [AnyHashable:Any]) {
        self.rawJson = gkutility.obj2str(obj: dic)
    }
}

public class GKRoleDataItem : GKBaseDataItem {
    
    public var ent_id = 0
    public var nid = 0
    public var name = ""
    public var admin = 0
    public var org_admin = 0
    public var member_type = 0
    public var permissions = [String]()
    
    public override func setWithJsonDic(_ dic: [AnyHashable : Any]) {
        ent_id = gkSafeInt(dic: dic, key: "ent_id")
        nid = gkSafeInt(dic: dic, key: "id")
        name = gkSafeString(dic: dic, key: "name")
        admin = gkSafeInt(dic: dic, key: "admin")
        org_admin = gkSafeInt(dic: dic, key: "org_admin")
        member_type = gkSafeInt(dic: dic, key: "member_type")
        if let p = (dic["permissions"] as? String) {
            permissions = p.components(separatedBy: ",")
        }
    }
    
}

public class GKEntDataItem : GKBaseDataItem {
    
    public var ent_id = 0
    public var ent_name = ""
    public var ent_admin = 0
    public var ent_super_admin = 0
    public var is_expired = 0
    public var trial = 0
    public var state = 0
    public var member_name: String? = ""
    public var member_count = 0
    public var super_member_id = 0
    public var add_dateline: Int64 = 0
    public var enable_create_org = 0
    public var enable_manage_groups = [Int]()
    public var enable_manage_member = 0
    public var enable_publish_notice = 0
    public var out_id: String?
    public var dingding_id: String?
    public var roles = [GKRoleDataItem]()
    public var property: String? = ""
    
    public override func setWithJsonDic(_ dic: [AnyHashable : Any]) {
        self.ent_id = gkSafeInt(dic: dic, key: "ent_id")
        self.ent_name = gkSafeString(dic: dic, key: "ent_name")
        self.ent_admin = gkSafeInt(dic: dic, key: "ent_admin")
        self.ent_super_admin = gkSafeInt(dic: dic, key: "ent_super_admin")
        self.is_expired = gkSafeInt(dic: dic, key: "is_expired")
        self.trial = gkSafeInt(dic: dic, key: "trial")
        self.state = gkSafeInt(dic: dic, key: "state")
        self.member_name = gkSafeString(dic: dic, key: "member_name")
        self.member_count = gkSafeInt(dic: dic, key: "member_count")
        self.super_member_id = gkSafeInt(dic: dic, key: "super_member_id")
        self.property = gkSafeString(dic: dic, key: "property")
        self.add_dateline = gkSafeLongLong(dic: dic, key: "add_dateline")
        self.enable_create_org = gkSafeInt(dic: dic, key: "enable_create_org")
        self.enable_manage_member = gkSafeInt(dic: dic, key: "enable_manage_member")
        self.enable_publish_notice = gkSafeInt(dic: dic, key: "enable_publish_notice")
        self.out_id = gkSafeString(dic: dic, key: "out_id")
        self.dingding_id = gkSafeString(dic: dic, key: "dingding_id")
        self.rawJson = gkutility.obj2str(obj: dic)
        
        let manager_groups = gkSafeString(dic: dic, key: "enable_manage_groups")
        if !manager_groups.isEmpty {
            let comps = manager_groups.components(separatedBy: "|")
            if !comps.isEmpty {
                for v in comps {
                    if let id = Int(v) {
                        self.enable_manage_groups.append(id)
                    }
                }
            }
        }
        
        if let rolearr = dic["roles"] as? Array<[AnyHashable:Any]> {
            var temp = [GKRoleDataItem]()
            for r in rolearr {
                let roleitem = GKRoleDataItem(json: r)
                if roleitem != nil {
                    temp.append(roleitem!)
                }
            }
            self.roles = temp
        }
        
    }
    
}


public class GKMountDataItem : GKBaseDataItem {
    
    public var mount_id = 0
    public var org_id = 0
    public var ent_id = 0
    public var state = 0
    public var owner_member_id = 0
    public var member_id = 0
    public var member_name = ""
    public var member_type = 0
    public var role_id = 0
    public var member_count = 0
    public var storage_point: String?
    public var storage_cahce = 0
    public var org_name = ""
    public var org_type = 0
    public var org_logo_url = ""
    public var size_org_total: Int64 = 0
    public var size_org_use: Int64 = 0
    public var compare = 0
    public var remain_days = 0
    public var property: String?
    public var add_dateline: Int64 = 0
    
    public var isPersonLib: Bool {
        return self.org_type == 20
    }
    
    public override func setWithJsonDic(_ dic: [AnyHashable : Any]) {
        mount_id = gkSafeInt(dic: dic, key: "mount_id")
        org_id = gkSafeInt(dic: dic, key: "org_id")
        ent_id = gkSafeInt(dic: dic, key: "ent_id")
        owner_member_id = gkSafeInt(dic: dic, key: "owner_member_id")
        state = gkSafeInt(dic: dic, key: "state")
        member_id = gkSafeInt(dic: dic, key: "member_id")
        member_name = gkSafeString(dic: dic, key: "member_name")
        member_type = gkSafeInt(dic: dic, key: "member_type")
        member_count = gkSafeInt(dic: dic, key: "member_count")
        role_id = gkSafeInt(dic: dic, key: "role_id")
        storage_point = gkSafeString(dic: dic, key: "storage_point")
        storage_cahce = gkSafeInt(dic: dic, key: "storage_cahce")
        org_name = gkSafeString(dic: dic, key: "org_name")
        org_type = gkSafeInt(dic: dic, key: "org_type")
        org_logo_url = gkSafeString(dic: dic, key: "org_logo_url")
        size_org_total = gkSafeLongLong(dic: dic, key: "size_org_total")
        size_org_use = gkSafeLongLong(dic: dic, key: "size_org_use")
        if size_org_total == 0 {
            size_org_total = gkSafeLongLong(dic: dic, key: "size_total")
        }
        if size_org_use == 0 {
            size_org_use = gkSafeLongLong(dic: dic, key: "size_use")
        }
        compare = gkSafeInt(dic: dic, key: "compare")
        remain_days = gkSafeInt(dic: dic, key: "remain_days")
        add_dateline = gkSafeLongLong(dic: dic, key: "add_dateline")
        property = gkSafeString(dic: dic, key: "property")
        rawJson = gkutility.obj2str(obj: dic)
    }
}




public class GKShortcutItem : GKBaseDataItem {
    
    @objc public enum GKShortcutType : Int {
        case Smart = 1
        case Mount
        case Folder
    }
    
    public var type: GKShortcutType = .Mount
    public var value = 0
    public var uuidhash = ""
    public var bremoved = false
    
    public override func setWithJsonDic(_ dic: [AnyHashable : Any]) {
        let ntype = gkSafeInt(dic: dic, key: "type")
        if let t = GKShortcutType(rawValue: ntype) {
            type = t
        }
        value = gkSafeInt(dic: dic, key: "value")
        uuidhash = gkSafeString(dic: dic, key: "hash")
    }
}


public class GKFileDataItem : GKBaseDataItem {
    
    public var mount_id = 0
    public var fullpath = ""
    public var uuidhash = ""
    public var filename = ""
    public var filehash = ""
    public var dir = false
    public var filesize: Int64 = 0
    public var create_member_name = ""
    public var create_dateline: Int64 = 0
    public var create_member_id = 0
    public var last_member_name = ""
    public var last_dateline: Int64 = 0
    public var last_member_id = 0
    public var lock = 0
    public var lock_member_id = 0
    public var lock_member_name = ""
    public var property = ""
    public var collection = ""
    
    public var bremoved = false
    
    public var hid = ""
    public var icon = ""
    
    public override func setWithJsonDic(_ dic: [AnyHashable : Any]) {
        self.mount_id = gkSafeInt(dic: dic, key: "mount_id")
        self.fullpath = gkSafeString(dic: dic, key: "fullpath")
        self.dir = (gkSafeInt(dic: dic, key: "dir") > 0)
        self.filename = gkSafeString(dic: dic, key: "filename")
        self.uuidhash = gkSafeString(dic: dic, key: "hash")
        self.filehash = gkSafeString(dic: dic, key: "filehash")
        self.filesize = gkSafeLongLong(dic: dic, key: "filesize")
        self.create_member_id = gkSafeInt(dic: dic, key: "create_member_id")
        self.create_member_name = gkSafeString(dic: dic, key: "create_member_name")
        self.create_dateline = gkSafeLongLong(dic: dic, key: "create_dateline")
        self.last_member_id = gkSafeInt(dic: dic, key: "last_member_id")
        self.last_member_name = gkSafeString(dic: dic, key: "last_member_name")
        self.last_dateline = gkSafeLongLong(dic: dic, key: "last_dateline")
        self.lock = gkSafeInt(dic: dic, key: "lock")
        self.lock_member_name = gkSafeString(dic: dic, key: "lock_member_name")
        self.lock_member_id = gkSafeInt(dic: dic, key: "lock_member_id")
        self.property = gkSafeString(dic: dic, key: "property")
        self.rawJson = gkutility.obj2str(obj: dic)
        
        self.setothers()
    }
    
    public func setothers() {
        self.icon = gkutility.getIconWithFileName(filename, dir)
        
        if let proDic = property.gkDic {
            self.collection = gkSafeString(dic: proDic, key: "collection_type")
        }
    }
    
    
    public func thumb(webhost: String, big: Bool = false) -> String {
        let ext = (self.filename as NSString).pathExtension
        let web = webhost.gkAddLastSlash
        let url = "\(web)index/thumb?hash=\(self.uuidhash)&filehash=\(self.filehash)&type=\(ext)&mount_id=\(self.mount_id)"
        if big {
            return url.appending("&big=1")
        }
        return url
    }
    
}


public class GKFileLinkItem : GKBaseDataItem {
    
    public var url = ""
    public var mount_id = 0
    public var ent_id = 0
    public var setting_url = ""
    public var code = ""
    public var member_id = 0
    public var member_name = ""
    public var deadline: Int64 = 0
    public var dateline: Int64 = 0
    
    public var scope = 0
    public var preview = 1
    public var download = 0
    public var upload = 0
    public var password = ""
    public var day = 0
    
    public override func setWithJsonDic(_ dic: [AnyHashable : Any]) {
        
        mount_id = gkSafeInt(dic: dic, key: "mount_id")
        ent_id = gkSafeInt(dic: dic, key: "ent_id")
        url = gkSafeString(dic: dic, key: "url")
        setting_url = gkSafeString(dic: dic, key: "setting_url")
        code = gkSafeString(dic: dic, key: "code")
        member_id = gkSafeInt(dic: dic, key: "member_id")
        member_name = gkSafeString(dic: dic, key: "member_name")
        deadline = gkSafeLongLong(dic: dic, key: "deadline")
        dateline = gkSafeLongLong(dic: dic, key: "dateline")
        
        if let property = gkSafeDic(dic: dic, key: "property") {
            scope = gkSafeInt(dic: property, key: "scope")
            preview = gkSafeInt(dic: property, key: "preview")
            download = gkSafeInt(dic: property, key: "download")
            upload = gkSafeInt(dic: property, key: "upload")
            password = gkSafeString(dic: property, key: "password")
            day = gkSafeInt(dic: property, key: "day")
        }
    }
}
