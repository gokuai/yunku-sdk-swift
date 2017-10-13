//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

public class EntLibManager: NSObject {
    
    var httpEngine: GYKHttpEngine!
    
    @objc public init(clientID: String, clientSecret: String) {
        self.httpEngine = GYKHttpEngine(clientID: clientID, clientSecret: clientSecret, errorLog: nil)
    }
    
    //MARK: 创建库
    @objc public func create(orgName:String,
                             orgCapacity:Int64,
                             orgLogo: String? = nil,
                             storagePointName: String? = nil) -> GYKResponse {
        var cap: String? = nil
        if orgCapacity > 0 {
            cap = "\(orgCapacity)"
        }
        return self.httpEngine.createOrg(name: orgName, logo: orgLogo, capacity: cap, storage_point_name: storagePointName)
    }
    
    //MARK:获取库列表
    @objc public func getLibList() -> GYKResponse {
        return self.httpEngine.getOrgList()
    }
    
    //MARK:修改库信息
    @objc public func config(orgId: Int,
                             orgName: String?,
                             orgCapacity: Int64,
                             orgLogo: String?) -> GYKResponse {
        var cap: String? = nil
        if orgCapacity > 0 {
            cap = "\(orgCapacity)"
        }
        return self.httpEngine.configOrg(orgID: orgId, name: orgName, logo: orgLogo, capacity: cap)
    }
    
    //MARK:获取库信息
    @objc public func getInfo(orgID: Int) -> GYKResponse {
        return self.httpEngine.getOrgInfo(orgID:orgID)
    }
    

    //MARK:获取库授权
    @objc public func bindLib(orgId: Int,
                              title: String? = nil,
                              linkUrl: String? = nil) -> GYKResponse {
        return self.httpEngine.bindOrg(orgID: orgId, mountID: 0)
    }

    //MARK: 取消库授权
    @objc public func unbindLib(orgClientId: String) -> GYKResponse {
        return self.httpEngine.unbindOrg(org_client_id:orgClientId)
    }

    //MARK:获取库成员列表
    @objc public func getMembers(_ start: Int,
                         size: Int,
                         orgId: Int) -> GYKResponse {
        return self.httpEngine.getOrgMember(org_id: orgId, start: start, size: size)
    }

    //MARK:添加成员
    @objc public func addMembers(orgId: Int,
                                 roleId: Int,
                                 memberIds: String) -> GYKResponse {
        return self.httpEngine.addOrgMember(org_id: orgId, role_id: roleId, member_ids: memberIds)
    }

    //MARK:删除库成员
    @objc public func delMember(orgId: Int,
                                memberIds: String) -> GYKResponse {
        return self.httpEngine.delOrgMember(org_id: orgId, member_ids: memberIds)
    }
    
    //MARK:删除库
    @objc public func destroy(orgClientId: String) -> GYKResponse {
        return self.httpEngine.delOrg(org_id: 0, org_client_id: orgClientId)
    }

}
