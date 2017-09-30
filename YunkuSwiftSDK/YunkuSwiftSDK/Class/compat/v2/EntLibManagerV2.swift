//
//  EntLibManager.swift
//  YunkuSwiftSDK
//
//  Created by qp on 2017/9/25.
//  Copyright © 2017年 goukuai. All rights reserved.
//

import Foundation

open class EntLibManagerV2: OauthEngineV2 {
    
    let urlApiCreateLib = HostConfigV2.libHostV2 + "/1/org/create"
    let urlApiGetLibList = HostConfigV2.libHostV2 + "/1/org/ls"
    let urlApiBind = HostConfigV2.libHostV2 + "/1/org/bind"
    let urlApiUnbind = HostConfigV2.libHostV2 + "/1/org/unbind"
    let urlApiGetMembers = HostConfigV2.libHostV2 + "/1/org/get_members"
    let urlApiAddMembers = HostConfigV2.libHostV2 + "/1/org/add_member"
    let urlApiSetMemberRole = HostConfigV2.libHostV2 + "/1/org/set_member_role"
    let urlApiDelMember = HostConfigV2.libHostV2 + "/1/org/del_member"
    let urlApiGetGroups = HostConfigV2.libHostV2 + "/1/org/get_groups"
    let urlApiAddGroup = HostConfigV2.libHostV2 + "/1/org/add_group"
    let urlApiDelGroup = HostConfigV2.libHostV2 + "/1/org/del_group"
    let urlApiSetGroupRole = HostConfigV2.libHostV2 + "/1/org/set_group_role"
    let urlApiDestroy = HostConfigV2.libHostV2 + "/1/org/destroy"
    let urlApiGetMember = HostConfigV2.libHostV2 + "/1/org/get_member"
    let urlApiSet = HostConfigV2.libHostV2 + "/1/org/set"
    let urlApiGetInfo = HostConfigV2.libHostV2 + "/1/org/info"
    
    public override init(clientId: String, clientSecret: String) {
        super.init(clientId: clientId, clientSecret: clientSecret, isEnt: true)
    }
    
    public init(clientId: String, clientSecret: String,isEnt: Bool, token: String){
        super.init(clientId: clientId, clientSecret: clientSecret, isEnt: isEnt, token: token)
    }
    
    
    //MARK:创建库
    open func create(_ orgName: String, orgCapacity: String?, storagePointName: String?, orgDesc: String?, orgLogo: String?) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiCreateLib
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_name"] = orgName
        params["org_capacity"] = orgCapacity
        params["storage_point_name"] = storagePointName
        params["org_desc"] = orgDesc
        params["org_logo"] = orgLogo
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:获取库列表
    open func getLibList() -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetLibList
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.GET.rawValue).executeSync()
    }
    
    //MARK:绑定库
    open func bindLib(_ orgId: Int, title: String?, linkUrl: String?) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiBind
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["title"] = title
        params["url"] = linkUrl
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
        
    }
    
    //MARK: 取消绑定
    open func unbindLib(_ orgClientId: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiUnbind
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_client_id"] = orgClientId
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:获取库成员列表
    open func getMembers(_ start: Int, size: Int, orgId: Int) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetMembers
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["start"] = String(start)
        params["size"] = String(size)
        params["org_id"] = String(orgId)
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.GET.rawValue).executeSync()
    }
    
    //MARK:添加成员
    open func addMembers(_ orgId: Int, roleId: Int, memberIds: [String]) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiAddMembers
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["role_id"] = String(roleId)
        params["org_id"] = String(orgId)
        params["member_ids"] = memberIds.joined(separator: ",")
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:修改库成员角色
    open func setMemberRole(_ orgId: Int, roleId: Int, memberIds: [String]) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiSetMemberRole
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["role_id"] = String(roleId)
        params["org_id"] = String(orgId)
        params["member_ids"] = memberIds.joined(separator: ",")
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:删除库成员
    open func delMember(_ orgId: Int, memberIds: [String]) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiDelMember
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["member_ids"] = memberIds.joined(separator: ",")
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:获取库分组列表
    open func getGroups(_ orgId: Int) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetGroups
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.GET.rawValue).executeSync()
    }
    
    //MARK:库上添加分组
    open func addGroup(_ orgId: Int, groupId: Int, roleId: Int) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiAddGroup
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["group_id"] = String(groupId)
        params["role_id"] = String(roleId)
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:删除库上的分组
    open func delGroup(_ orgId: Int, groupId: Int) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiDelGroup
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["group_id"] = String(groupId)
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:修改库上分组的角色
    open func setGroupRole(_ orgId: Int, groupId: Int, roleId: Int) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiSetGroupRole
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["group_id"] = String(groupId)
        params["role_id"] = String(roleId)
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    
    //MARK:删除库
    open func destroy(_ orgClientId: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiDestroy
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_client_id"] = String(orgClientId)
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    
    //MARK:修改库信息
    open func set(_ orgId: Int, orgName: String?, orgCapacity: String?, orgDes: String?, orgLogo: String?) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiSet
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["org_name"] = orgName
        params["org_capacity"] = orgCapacity
        params["org_desc"] = orgDes
        params["org_logo"] = orgLogo
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:查询库成员信息
    open func getMember(_ orgId:Int,type:MemberType,ids:[String]) -> Dictionary<String, AnyObject>  {
        let method = "GET"
        let url = urlApiGetMember
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["type"] = type.description.lowercased()
        params["ids"] = ids.joined(separator: ",")
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.GET.rawValue).executeSync()
    }
    
    //MARK:获取库信息
    open func getInfo(_ orgId:Int) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetInfo
        var params = Dictionary<String, String?>()
        addAuthParams(params: &params)
        params["org_id"] = String(orgId)
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.GET.rawValue).executeSync()
    }
    
    //MARK:复制一个 EntLibManager
    open func clone() -> EntLibManager {
        return EntLibManager(clientId: _clientId, clientSecret: _clientId,isEnt: _isEnt)
    }
    
}
