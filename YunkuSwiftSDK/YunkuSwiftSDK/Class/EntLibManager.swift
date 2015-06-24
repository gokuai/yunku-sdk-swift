//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

public class EntLibManager: ParentEngine {

    let urlApiCreateLib = HostConfig.libHost + "/1/org/create"
    let urlApiGetLibList = HostConfig.libHost + "/1/org/ls"
    let urlApiBind = HostConfig.libHost + "/1/org/bind"
    let urlApiUnbind = HostConfig.libHost + "/1/org/unbind"
    let urlApiGetMembers = HostConfig.libHost + "/1/org/get_members"
    let urlApiAddMembers = HostConfig.libHost + "/1/org/add_member"
    let urlApiSetMemberRole = HostConfig.libHost + "/1/org/set_member_role"
    let urlApiDelMember = HostConfig.libHost + "/1/org/del_member"
    let urlApiGetGroups = HostConfig.libHost + "/1/org/get_groups"
    let urlApiAddGroup = HostConfig.libHost + "/1/org/add_group"
    let urlApiDelGroup = HostConfig.libHost + "/1/org/del_group"
    let urlApiSetGroupRole = HostConfig.libHost + "/1/org/set_group_role"
    let urlApiDestroy = HostConfig.libHost + "/1/org/destroy"
    let urlApiGetMember = HostConfig.libHost + "/1/org/get_member"
    let urlApiSet = HostConfig.libHost + "/1/org/set"
    let urlApiGetInfo = HostConfig.libHost + "/1/org/info"


    public init(username: String, password: String, clientId: String, clientSecret: String, token: String) {
        super.init(username: username, password: password, clientId: clientId, clientSecret: clientSecret)
        self._token = token

    }

    public override init(username: String, password: String, clientId: String, clientSecret: String) {
        super.init(username: username, password: password, clientId: clientId, clientSecret: clientSecret)
    }

    //MARK:创建库
    public func create(orgName: String, orgCapacity: String?, storagePointName: String?, orgDesc: String?, orgLogo: String?) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiCreateLib
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_name"] = orgName
        params["org_capacity"] = orgCapacity
        params["storage_point_name"] = storagePointName
        params["org_desc"] = orgDesc
        params["org_logo"] = orgLogo
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取库列表
    public func getLibList() -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetLibList
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:绑定库
    public func bindLib(orgId: Int, title: String?, linkUrl: String?) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiBind
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["title"] = title
        params["url"] = linkUrl
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)

    }

    //MARK: 取消绑定
    public func unbindLib(orgClientId: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiUnbind
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_client_id"] = orgClientId
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取库成员列表
    public func getMembers(start: Int, size: Int, orgId: Int) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetMembers
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["start"] = String(start)
        params["size"] = String(size)
        params["org_id"] = String(orgId)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:添加成员
    public func addMembers(orgId: Int, roleId: Int, memberIds: [String]) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiAddMembers
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["role_id"] = String(roleId)
        params["org_id"] = String(orgId)
        params["member_ids"] = ",".join(memberIds)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:修改库成员角色
    public func setMemberRole(orgId: Int, roleId: Int, memberIds: [String]) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiSetMemberRole
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["role_id"] = String(roleId)
        params["org_id"] = String(orgId)
        params["member_ids"] = ",".join(memberIds)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:删除库成员
    public func delMember(orgId: Int, memberIds: [String]) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiDelMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["member_ids"] = ",".join(memberIds)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取库分组列表
    public func getGroups(orgId: Int) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetGroups
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:库上添加分组
    public func addGroup(orgId: Int, groupId: Int, roleId: Int) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiAddGroup
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["group_id"] = String(groupId)
        params["role_id"] = String(roleId)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:删除库上的分组
    public func delGroup(orgId: Int, groupId: Int) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiDelGroup
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["group_id"] = String(groupId)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:修改库上分组的角色
    public func setGroupRole(orgId: Int, groupId: Int, roleId: Int) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiSetGroupRole
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["group_id"] = String(groupId)
        params["role_id"] = String(roleId)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }
    

    //MARK:删除库
    public func destroy(orgClientId: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiDestroy
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_client_id"] = String(orgClientId)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }


    //MARK:修改库信息
    public func set(orgId: Int, orgName: String?, orgCapacity: String?, orgDes: String?, orgLogo: String?) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiSet
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["org_name"] = orgName
        params["org_capacity"] = orgCapacity
        params["org_desc"] = orgDes
        params["org_logo"] = orgLogo
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:查询库成员信息
    public func getMember(orgId:Int,type:MemberType,ids:[String]) -> Dictionary<String, AnyObject>  {
        let method = "GET"
        let url = urlApiGetMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["type"] = type.description.lowercaseString
        params["ids"] = ",".join(ids)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取库信息
    public func getInfo(orgId:Int) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetInfo
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["org_id"] = String(orgId)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:复制一个 EntLibManager
    public func clone() -> EntLibManager {
        return EntLibManager(username: _username, password: _password, clientId: _clientId, clientSecret: _clientId)
    }

}
