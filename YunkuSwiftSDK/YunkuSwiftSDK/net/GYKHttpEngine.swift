//
//  gkHttpEngine.swift
//  gknet
//
//  Created by wqc on 2017/7/24.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

fileprivate let kTokenInvalidCode = 40101
fileprivate let kTokenExpiredCode = 40102
fileprivate let kTryCount: Int = 2


public class GYKHttpEngine : GYKHttpRequest {
    
    var clientID = ""
    var clientSecret = ""
    var apiHost = ""
    
    private var bStop = false
    
    public init(host: String, clientID: String, clientSecret: String, errorLog: GYKRequestLogger?) {
        self.apiHost = host
        self.clientID = clientID
        self.clientSecret = clientSecret
        super.init()
        self.errorLog = errorLog
    }
    
    private func sign(_ param: [String:String]) -> String {
        return param.gyk_sign(key: self.clientSecret)
    }

    private func generateurl(_ url: String) -> String {
        return self.apiHost + url
    }
    
    private func refreshToken() -> Bool {
        return true
    }
    
    //MARK: ------企业操作------
    
    //MARK: 添加或修改同步成员
    public func addEntSyncMember(outID: String, memberName: String, account: String, memberEmail: String?, memberPhone: String?, password: String?, state: Int = 1) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["out_id"] = outID
            param["member_name"] = memberName
            param["account"] = account
            if memberEmail != nil {
                param["member_email"] = memberEmail!
            }
            if memberPhone != nil {
                param["member_phone"] = memberPhone!
            }
            if password != nil {
                param["password"] = password!
            }
            param["state"] = "\(state)"
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_ADD_SYNC_MEMBER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除同步成员
    public func delEntSyncMember(memberIDs: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["members"] = memberIDs
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_DEL_SYNC_MEMBER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 添加或修改同步成部门
    public func addEntSyncGroup(outID: String, name: String, parentID: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["out_id"] = outID
            param["name"] = name
            if parentID != nil {
                param["parent_out_id"] = parentID!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_ADD_SYNC_GROUP), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除同步部门
    public func delEntSyncGroup(groups: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["groups"] = groups
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_DEL_SYNC_GROUP), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 添加同步部门的成员
    public func addEntSyncGroupMember(groupOutID: String?, members: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["members"] = members
            if groupOutID != nil {
                param["group_out_id"] = groupOutID!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_ADD_GROUP_SYNC_MEMBER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除同步部门的成员
    public func delEntSyncGroupMember(groupOutID: String?, members: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["members"] = members
            if groupOutID != nil {
                param["group_out_id"] = groupOutID!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_DEL_GROUP_SYNC_MEMBER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除成员的所属部门
    public func delSyncGroupOfMember(members: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["members"] = members
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_DEL_MEMBER_GROUPS), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 添加管理员
    public func addEntSyncAdmin(outID: String, email: String?, type: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["out_id"] = outID
            if email != nil {
                param["member_email"] = email!
            }
            param["type"] = "\(type)"
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_ADD_MANAGER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    
    //MARK: 成员列表
    public func getEntMemberList(start: Int, size: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            if start > 0 {
                param["start"] = "\(start)"
            }
            if size > 0 {
                param["size"] = "\(size)"
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_MEMBER_LIST), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 成员信息
    public func getEntMember(memberID: String?, outID: String?, account: String?, showGroups: Bool = false) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            if memberID != nil {
                param["member_id"] = memberID!
            } else if outID != nil {
                param["out_id"] = outID!
            } else if account != nil {
                param["account"] = account!
            }
            param["show_groups"] = (showGroups ? "1" : "0")
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_MEMBER_INFO), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 通过外部帐号获取成员信息
    public func getEntMemberByOutID(outIDs: String?, userIDs: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            if outIDs != nil {
                param["out_ids"] = outIDs!
            } else if userIDs != nil {
                param["user_ids"] = userIDs!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_MEMBER_INFO_OUT), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 部门列表
    public func getEntGroups() -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_GROUPS), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取部门成员
    public func getGroupMembers(groupID: Int, showChild: Bool = false, start: Int = 0, size: Int = 0) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["group_id"] = "\(groupID)"
            param["show_child"] = (showChild ? "1" : "0")
            if start > 0 {
                param["start"] = "\(start)"
            }
            if size > 0 {
                param["size"] = "\(size)"
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_GROUP_MEMBER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取企业角色
    public func getEntRoles() -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ENT_ROLES), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    
    
    //MARK: ------库操作------
    
    //MARK: 创建库
    public func createOrg(name: String, logo: String? = nil, capacity: String? = nil, storagePoint: String? = nil) -> GYKResponse {

        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":clientID]
            param["org_name"] = name
            if logo != nil {
                param["org_logo"] = logo!
            }
            if capacity != nil {
                param["org_capacity"] = capacity!
            }
            if storagePoint != nil {
                param["storage_point_name"] = storagePoint!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)

            result = self.POST(url: generateurl(GYKAPI.CREATE_ORG), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }

        return result
    }
    
    //MARK: 修改库
    public func configOrg(orgID: Int, name: String? = nil, logo: String? = nil, capacity: String? = nil) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            if name != nil {
                param["org_name"] = name!
            }
            if logo != nil {
                param["org_logo"] = logo!
            }
            if capacity != nil {
                param["org_capacity"] = capacity!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.CONFIG_ORG), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取库信息
    public func getOrgInfo(orgID: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_INFO), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    
    //MARK: 拿库列表
    public func getOrgList(type: Int = 0, memberID: Int = 0) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["type"] = "\(type)"
            if memberID > 0 {
                param["member_id"] = "\(memberID)"
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_LIST), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取库授权
    public func bindOrg(orgID: Int, mountID: Int, title: String? = nil, url: String? = nil) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            if orgID > 0 {
                param["org_id"] = "\(orgID)"
            } else if mountID > 0 {
                param["mount_id"] = "\(mountID)"
            }
            if title != nil {
                param["title"] = title!
            }
            if url != nil {
                param["url"] = url!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_BIND), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 取消库授权
    public func unbindOrg(orgClientID: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_client_id"] = orgClientID
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_BIND), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取库成员
    public func getOrgMemberList(orgID: Int, start: Int, size: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            if start > 0 {
                param["start"] = "\(start)"
            }
            if size > 0 {
                param["size"] = "\(size)"
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_MEMBERS), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 查询库成员信息
    public func getOrgMemberInfo(orgID: Int, type: String, ids: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["type"] = type
            param["ids"] = ids
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_MEMBER_INFO), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 添加库成员
    public func addOrgMember(orgID: Int, roleID: Int, memberIDs: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            param["role_id"] = "\(roleID)"
            param["member_ids"] = memberIDs
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_ADDMEMBER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 修改库成员角色
    public func modifyOrgMemberRole(orgID: Int, roleID: Int, memberIDs: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            param["role_id"] = "\(roleID)"
            param["member_ids"] = memberIDs
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_SET_MEMBER_ROLE), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除库成员
    public func delOrgMember(orgID: Int, memberIDs: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            param["member_ids"] = memberIDs
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_DELMEMBER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取库部门
    public func getOrgGroupList(orgID: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_GROUP_LIST), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 添加库成部门
    public func addOrgGroup(orgID: Int, groupID: Int, roleID: Int, memberIDs: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            param["role_id"] = "\(roleID)"
            param["group_id"] = "\(groupID)"
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_ADD_GROUP), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除库部门
    public func delOrgGroup(orgID: Int, groupID: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            param["group_id"] = "\(groupID)"
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_DEL_GROUP), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 修改库部门角色
    public func modifyOrgGroupRole(orgID: Int, groupID: Int, roleID: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            param["org_id"] = "\(orgID)"
            param["role_id"] = "\(roleID)"
            param["group_id"] = "\(groupID)"
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_SET_GROUP_ROLE), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除库
    public func delOrg(orgID: Int, orgClientID: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            if orgClientID != nil {
                param["org_client_id"] = orgClientID!
            } else {
                param["org_id"] = "\(orgID)"
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_DELETE), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    
    //MARK: 库日志
    public func getOrgLog(orgID: Int, mountID: Int, act: String?, startDateline: Int64 = 0, size: Int = 0) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["client_id":self.clientID]
            if orgID > 0 {
                param["org_id"] = "\(orgID)"
            }
            if mountID > 0 {
                param["mount_id"] = "\(mountID)"
            }
            if act != nil {
                param["act"] = act!
            }
            if startDateline > 0 {
                param["start_dateline"] = "\(startDateline)"
            }
            if size > 0 {
                param["size"] = "\(size)"
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.ORG_LOG), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    
    
    
    //MARK: ------库文件操作------
    
    //MARK: 文件列表
    public func fetchFileList(fullpath: String,
                                    dir: Int = 0,
                                    hashs: String? = nil,
                                    start: Int = 0,
                                    size: Int = 10000) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpath"] = fullpath
            param["start"] = "\(start)"
            if size > 0 {
                param["size"] = "\(size)"
            }
            param["dir"] = "\(dir)"
            if hashs != nil {
                param["hashs"] = hashs!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_LIST), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 文件最近更新列表
    public func getFileUpdates(mode: String?,
                              fetch_dateline: Int64 = 0,
                              dir: String? = nil) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            if mode != nil {
                param["mode"] = mode!
            }
            param["fetch_dateline"] = "\(fetch_dateline)"
            if dir != nil {
                param["dir"] = dir!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_UPDATES), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 文件最近更新数量
    public func getFileUpdateCount(begin_dateline: Int64,
                                  end_dateline: Int64,
                                  showDelete: Bool) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["begin_dateline"] = "\(begin_dateline)"
            param["end_dateline"] = "\(end_dateline)"
            param["showdel"] = (showDelete ? "1" : "0")
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_UPDATE_COUNT), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    
    //MARK: 文件信息
    public func fetchFileInfo(fullPath: String?, pathHash: String?,attribute: Bool = false, net: String? = nil) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            if fullPath != nil {
                param["fullpath"] = fullPath!
            } else if pathHash != nil {
                param["hash"] = pathHash!
            }
            param["attribute"] = (attribute ? "1" : "0")
            if net != nil {
                param["net"] = net!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_INFO), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 搜索文件
    public func searchFile(keywords: String, path: String?, scope: String?, start: Int, size: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["keywords"] = keywords
            if path != nil {
                param["path"] = path!
            }
            if scope != nil {
                param["scope"] = scope!
            }
            if start > 0 {
                param["start"] = "\(start)"
            }
            if size > 0 {
                param["size"] = "\(size)"
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_SEARCH), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 创建文件夹
    public func createFolder(fullPath: String, op_id: String?,op_name: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpath"] = fullPath
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.CREATE_FOLDER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取文件下载链接
    public func getFileDownloadUrl(fullPath:String?, pathHash:String?, fileHash: String?, fileName: String?, net: String? = nil, open: Int = 0) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            if fullPath != nil {
                param["fullpath"] = fullPath!
            } else if pathHash != nil {
                param["hash"] = pathHash!
            }
            if fileHash != nil {
                param["filehash"] = fileHash!
            }
            if net != nil {
                param["net"] = net!
            }
            if fileName != nil {
                param["filename"] = fileName!
            }
            param["open"] = "\(open)"
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_DOWNLOAD_URL), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取文件预览地址
    public func getFilePreviewUrl(fullPath:String?, pathHash:String?, watermark: Bool, member_name: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            if fullPath != nil {
                param["fullpath"] = fullPath!
            } else if pathHash != nil {
                param["hash"] = pathHash!
            }
            param["watermark"] = (watermark ? "1" : "0")
            if member_name != nil {
                param["member_name"] = member_name!
            }

            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_PREVIEW_URL), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 复制文件
    public func copyFiles(sourcePaths: String, targetFullpath: String, op_id: String?,op_name: String?, copy_all: Bool = false) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["from_fullpath"] = sourcePaths
            param["fullpath"] = targetFullpath
            param["copy_all"] = (copy_all ? "1" : "0")
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_COPY), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 复制文件(高级)
    public func copyFilesEx(sourcePaths: String, targetFullpaths: String, copy_all: Bool, op_id: String?,op_name: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["from_fullpaths"] = sourcePaths
            param["paths"] = targetFullpaths
            param["copy_all"] = (copy_all ? "1" : "0")
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_COPYEX), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 移动文件
    public func moveFiles(fullpath: String, dest_fullpath: String, op_id: String?,op_name: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpath"] = fullpath
            param["dest_fullpath"] = dest_fullpath
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_MOVE), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除文件
    public func deleteFiles(fullpath: String?,
                           tag: String?,
                           path: String?,
                           op_id: String?,
                           op_name: String?,
                           destroy: Bool = false) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            if fullpath != nil {
                param["fullpath"] = fullpath!
            } else if tag != nil {
                param["tag"] = tag!
            }
            if path != nil {
                param["path"] = path!
            }
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["destroy"] = (destroy ? "1" : "0")
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_DELETE), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 彻底删除文件
    public func deleteCompleteFiles(fullpaths: String?, tag: String?, op_id: String?,op_name: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            if fullpaths != nil {
                param["fullpaths"] = fullpaths!
            } else if tag != nil {
                param["tag"] = tag!
            }
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_DELETE_COMPLETE), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取回收站文件
    public func getRecycleFiles(start: Int, size: Int) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            if start > 0 {
                param["start"] = "\(start)"
            }
            if size > 0 {
                param["size"] = "\(size)"
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_RECYCLE), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 恢复已删除的文件
    public func recoverFiles(fullpaths: String, op_id: String?,op_name: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpaths"] = fullpaths
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_RECOVER), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取文件外链
    public func getFileLink(fullpath: String, deadline: Int64, auth: String?, password: String?) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpath"] = fullpath
            if deadline > 0 {
                param["deadline"] = "\(deadline)"
            }
            if auth != nil {
                param["auth"] = auth!
            }
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_LINK), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 获取开启外链的文件列表
    public func getFileLinks(onlyFile: Bool = false) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["file"] = (onlyFile ? "1" : "0")
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_LINKS), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 添加标签
    public func addFileTag(fullpath: String, tag: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpath"] = fullpath
            param["tag"] = tag
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_ADD_TAG), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 删除标签
    public func delFileTag(fullpath: String, tag: String) -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpath"] = fullpath
            param["tag"] = tag
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_DEL_TAG), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    //MARK: 上传文件
    public func uploadFile(fullpath:String, op_id: String?, op_name: String?, overwrite: Bool, data: Data) -> GYKResponse {
        
        if data.count > 50*1024*1024 {
            let res = GYKResponse()
            res.errcode = 1
            res.errmsg = "The file more than 50 MB is not be allowed"
            return res
        }
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param: [String:String] = ["org_client_id":self.clientID]
            param["fullpath"] = fullpath
            
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["overwrite"] = (overwrite ? "1" : "0")
            param["filefield"] = "file"
            
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            let signStr = sign(param)
            
            let uniqueId = ProcessInfo.processInfo.globallyUniqueString
            
            let postBody: NSMutableData = NSMutableData()
            var postData: String = String()
            let boundary: String = "------WebKitFormBoundary\(uniqueId)"
            
            let filename = fullpath.gyk_fileName
            
            //添加参数
            postData += "--\(boundary)\r\n"
            for (key, value) in param {
                postData += "--\(boundary)\r\n"
                postData += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
                postData += "\(value)\r\n"
            }
            
            //添加签名
            postData += "--\(boundary)\r\n"
            postData += "Content-Disposition: form-data; name=\"sign\"\r\n\r\n"
            postData += "\(signStr)\r\n"
            
            //添加文件数据
            postData += "--\(boundary)\r\n"
            postData += "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename).jpg\"\r\n"
            postData += "Content-Type: image/png\r\n\r\n"
            postBody.append(postData.data(using: String.Encoding.utf8)!)
            postBody.append(data)
            postData = String()
            postData += "\r\n"
            postData += "\r\n--\(boundary)--\r\n"
            postBody.append(postData.data(using: String.Encoding.utf8)!)
            
            let contentType: String = "multipart/form-data; boundary=\(boundary)"
            let headers = ["Content-Type" : contentType,
                           "Content-Length" : "\(postBody.length)"]
            result = self.POST(url: generateurl(GYKAPI.FILE_CREATE), headers: headers, param: param, data: (postBody as Data), reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        return result
    }
    
    //MARK: 通过连接上传文件
    public func createFileByURL(fullpath:String, op_id: String?,op_name: String?, overwrite: Bool, url: String) -> GYKResponse {
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpath"] = fullpath
            
            if op_id != nil {
                param["op_id"] = op_id!
            } else if op_name != nil {
                param["op_name"] = op_name!
            }
            param["overwrite"] = (overwrite ? "1" : "0")
            param["url"] = url
            
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            
            result = self.POST(url: generateurl(GYKAPI.FILE_CREATE_URL), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        return result
    }
    
    //MARK: 获取上传服务器
    public func getUploadServers() -> GYKResponse {
        
        var result: GYKResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            param["sign"] = sign(param)
            
            result = self.POST(url: generateurl(GYKAPI.FILE_UPLOAD_SERVERS), headers: nil, param: param, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        
        return result
    }
    
    
    //MARK: #######分块上传
    
    //MARK: 请求上传文件
    func createFile(fullpath: String, filehash:String, filesize:Int64, overwrite: Bool, op_id: String?, op_name:String?) -> GYKCreateFileResponse {
        var result: GYKCreateFileResponse!
        for _ in 0..<kTryCount {
            var param = ["org_client_id":self.clientID]
            param["fullpath"] = fullpath
            param["dateline"] =  "\(Int64(Date().timeIntervalSince1970))"
            
            if op_id != nil {
                param["op_id"] = op_id!
            }
            if op_name != nil {
                param["op_name"] = op_name!
            }
            param["overwrite"] = (overwrite ? "1" : "0")
            param["sign"] = sign(param)
            param["filehash"] = filehash
            param["filesize"] = "\(filesize)"
            
            result = self.POST(url: generateurl(GYKAPI.FILE_CREATE), headers: nil, param: param, reqType: GYKCreateFileResponse.self) as! GYKCreateFileResponse
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        return result
    }
    
    
    private let HEADER_X_GK_UPLOAD_FILENAME =  "x-gk-upload-filename"
    private let HEADER_X_GK_UPLOAD_PATHHASH =	"x-gk-upload-pathhash"
    private let HEADER_X_GK_UPLOAD_FILEHASH =	"x-gk-upload-filehash"
    private let HEADER_X_GK_UPLOAD_FILESIZE =	"x-gk-upload-filesize"
    private let HEADER_X_GK_UPLOAD_MOUNTID  =   "x-gk-upload-mountid"
    private let HEADER_X_GK_TOKEN			=	"x-gk-token"
    
    //MARK: 初始化上传
    public func uploadFileInit(host:String,filename:String,uuidhash:String,filehash:String,filesize:Int64) -> GYKResponse {
        var result: GYKResponse!
        
        for _ in 0..<kTryCount {
            var header = [HEADER_X_GK_UPLOAD_FILENAME:filename]
            header[HEADER_X_GK_UPLOAD_PATHHASH] = uuidhash
            header[HEADER_X_GK_UPLOAD_FILEHASH] = filehash
            header[HEADER_X_GK_UPLOAD_FILESIZE] = "\(filesize)"
            
            let url = "\(host)/upload_init?org_client_id=\(self.clientID)"
            
            result = self.POST(url: url, headers: header, param: nil, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        return result
    }
    
    private let HEADER_X_GK_UPLOAD_SESSION = "x-gk-upload-session"
    private let HEADER_X_GK_UPLOAD_RANGE = "x-gk-upload-range"
    private let HEADER_CONTENT_LENGTH = "Content-Length"
    private let HEADER_X_GK_UPLOAD_PART_CRC = "x-gk-upload-crc"
    
    //MARK: 上传数据块
    public func uploadFilePart(host:String,session:String,start:Int64,end:Int64,data:Data,crc:String) -> GYKResponse {
        var result: GYKResponse!
        
        for _ in 0..<1 {
            
            var header = [HEADER_X_GK_UPLOAD_SESSION:session]
            header[HEADER_X_GK_UPLOAD_RANGE] = "\(start)-\(end)"
            header[HEADER_CONTENT_LENGTH] = "\(data.count)"
            header[HEADER_X_GK_UPLOAD_PART_CRC] = crc
            
            let url = "\(host)/upload_part"
            
            result = self.PUT(url: url, headers: header, param: nil, data: data, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        return result
    }
    
    //MARK: 完成上传
    public func uploadFileFinish(host:String,session:String,filesize:Int64) -> GYKResponse {
        var result: GYKResponse!
        
        for _ in 0..<kTryCount {
            
            var header = [HEADER_X_GK_UPLOAD_SESSION:session]
            header[HEADER_X_GK_UPLOAD_FILESIZE] = "\(filesize)"
            
            let url = "\(host)/upload_finish"
            
            result = self.POST(url: url, headers: header, param: nil, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        return result
    }
    
    //MARK: 取消上传
    public func uploadAbort(host:String,session:String,filesize:Int64) -> GYKResponse {
        var result: GYKResponse!
        
        for _ in 0..<kTryCount {
            
            let header = [HEADER_X_GK_UPLOAD_SESSION:session]
            
            let url = "\(host)/upload_abort"
            
            result = self.POST(url: url, headers: header, param: nil, reqType: GYKResponse.self)
            if result.statuscode == 200 {
                break
            } else if result.errcode == kTokenExpiredCode || result.errcode == kTokenInvalidCode {
                if bStop { break }
                let _ = self.refreshToken()
            }
        }
        return result
    }
    
}
