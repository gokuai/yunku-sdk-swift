//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

public class EntManager :ParentEngine {

    let urlApiGetGroups =  HostConfig.libHost + "/1/ent/get_groups"
    let urlApiGetMembers =  HostConfig.libHost + "/1/ent/get_members"
    let urlApiGetMember =  HostConfig.libHost + "/1/ent/get_member"
    let urlApiGetRoles =  HostConfig.libHost + "/1/ent/get_roles"
    let urlApiSyncMember =  HostConfig.libHost + "/1/ent/sync_member"
    let urlApiGetMemberFileLink =  HostConfig.libHost + "/1/ent/get_member_file_link"
//    let urlApiGetMemberByOutId =  HostConfig.libHost + "/1/ent/get_member_by_out_id"

    let urlApiAddSyncMember =  HostConfig.libHost + "/1/ent/add_sync_member"
    let urlApiDelSyncMember =  HostConfig.libHost + "/1/ent/del_sync_member"
    let urlApiAddSyncGroup =  HostConfig.libHost + "/1/ent/add_sync_group"
    let urlApiDelSyncGroup =  HostConfig.libHost + "/1/ent/del_sync_group"
    let urlApiAddSyncGroupMember =  HostConfig.libHost + "/1/ent/add_sync_group_member"
    let urlApiDelSyncGroupMember =  HostConfig.libHost + "/1/ent/del_sync_group_member"
    let urlApiGetGroupMembers =  HostConfig.libHost + "/1/ent/get_group_members"
    
    public override init(clientId: String, clientSecret: String,isEnt:Bool) {
        super.init(clientId:clientId,clientSecret:clientSecret,isEnt:isEnt)
    }
    
    public init(clientId: String, clientSecret: String,isEnt:Bool,token:String) {
        super.init(clientId:clientId,clientSecret:clientSecret,isEnt:isEnt)
        _token = token
    }

    //MARK:获取角色
    public func getRoles() -> Dictionary<String, AnyObject>{
        let method = "GET"
        let url = urlApiGetRoles
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }
    
    //MARK:获取成员
    public func getMembers(start:Int,size:Int) -> Dictionary<String, AnyObject>{
        let method = "GET"
        let url = urlApiGetMembers
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["start"] = String(start)
        params["size"] = String(size)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
   
    //MARK:获取分组
    public func getGroups() -> Dictionary<String, AnyObject>{
        let method = "GET"
        let url = urlApiGetGroups
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
    
    //MARK:根据成员id获取成员个人库外链
    public func getMemberFileLink(memberId:Int,fileOnly:Bool)-> Dictionary<String, AnyObject>{
        let method = "GET"
        let url = urlApiGetMemberFileLink
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["member_id"] = String(memberId)
        if fileOnly{
            params["file"] = "1"
        }
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }
    
//    //MARK:根据外部成员id获取成员信息
//    public func getMemberByOutid(outIds:[String])-> Dictionary<String, AnyObject>{
//        return getMemberByIds(nil,outIds: outIds)
//    }
//    
//    //MARK:根据外部成员登录帐号获取成员信息
//    public func getMemberByUserId(userIds:[String])-> Dictionary<String, AnyObject>{
//        return getMemberByIds(userIds,outIds: nil)
//    }
//    
//    //MARK:添加或修改同步成员
//    private func getMemberByIds(userIds:[String]?,outIds:[String]?)-> Dictionary<String, AnyObject>{
//        let method = "GET"
//        let url = urlApiGetMemberByOutId
//        var params = Dictionary<String, String?>()
//        params["token"] = _token
//        params["token_type"] = "ent"
//        if outIds != nil {
//          params["out_ids"] = ",".join(outIds!)
//        }else {
//            params["user_ids"] = ",".join(userIds!)
//        }
//        params["sign"] = generateSign(params)
//        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
//    }
    
    //MARK:根据成员id获取企业成员信息
    public func getMemberById(memberId:Int) -> Dictionary<String, AnyObject>{
        return getMember(memberId, outId: nil, account: nil)
    }
    
    //MARK:根据外部成员id获取企业成员信息
    public func getMemberByOutId(outId:String) -> Dictionary<String, AnyObject>{
        return getMember(0, outId: outId, account: nil)
    }
    
    //MARK:根据帐号获取企业成员信息
    public func getMemberByAccount(account:String) -> Dictionary<String, AnyObject>{
        return getMember(0, outId: nil, account: account)
    }
    
    private func getMember(memberId:Int,outId:String!,account:String!) -> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiGetMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = _tokenType
        if memberId > 0{
            params["member_id"] = String(memberId)
        }
        params["out_id"] = outId
        params["account"] = account
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
    
   
    //MARK:删除同步成员
    public func addSyncMember(oudId:String,memberName:String,account:String,memberEmail:String?,memberPhone:String?,password:String?)-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiAddSyncMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = _tokenType
        params["out_id"] = oudId
        params["member_name"] = memberName
        params["account"] = account
        params["member_email"] = memberEmail
        params["member_phone"] = memberPhone
        params["password"] = password
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }
  
    //MARK:删除同步分组
    public func delSyncMember(members:[String])-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiDelSyncMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["members"] = ",".join(members)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
    
    //MARK:添加同步分组的成员
    public func addSyncGroup(outId:String,name:String,parentOutId:String?)-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiAddSyncGroup
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["out_id"] = outId
        params["name"] = name
        params["parent_out_id"] = parentOutId
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
   
    //MARK:删除同步分组
    public func delSyncGroup(groups:[String])-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiDelSyncGroup
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["groups"] = ",".join(groups)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
   
    //MARK:添加同步分组成员
    public func addSyncGroupMember(groupOutId:String,members:[String])-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiAddSyncGroupMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["group_out_id"] = groupOutId
        params["members"] = ",".join(members)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
    
    //MARK:删除同步分组成员
    public func delSyncGroupMember(groupOutId:String,members:[String])-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiDelSyncGroupMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["group_out_id"] = groupOutId
        params["members"] = ",".join(members)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }
    
    //MARK:获得分组成员
    public func getGroupMembers(groupId:Int,start:Int,size:Int, showChild:Bool)-> Dictionary<String, AnyObject>{
        let method = "GET"
        let url = urlApiGetGroupMembers
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["group_id"] = String(groupId)
        params["start"] = String(start)
        params["size"] = String(size)
        params["show_child"] = String(showChild ? 1:0)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }
   
    //MARK:复制一个 EntManager
    public func clone() -> EntManager {
        return EntManager(clientId: _clientId, clientSecret: _clientId, isEnt: _isEnt)
    }
    

}
