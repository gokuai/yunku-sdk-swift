//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

open class EntManager :ParentEngine {

    var urlApiGetGroups =  ""
    var urlApiGetMembers =  ""
    var urlApiGetMember =  ""
    var urlApiGetRoles =  ""
    var urlApiSyncMember =  ""
    var urlApiGetMemberFileLink =  ""
//    let urlApiGetMemberByOutId =  HostConfig.libHost + "/1/ent/get_member_by_out_id"

    var urlApiAddSyncMember =  ""
    var urlApiDelSyncMember =  ""
    var urlApiAddSyncGroup =  ""
    var urlApiDelSyncGroup =  ""
    var urlApiAddSyncGroupMember =  ""
    var urlApiDelSyncGroupMember =  ""
    var urlApiGetGroupMembers =  ""

    @objc public override init(clientId: String, clientSecret: String,isEnt:Bool) {
        super.init(clientId:clientId,clientSecret:clientSecret,isEnt:isEnt)
        urlApiGetGroups =  HostConfig.libHost + "/1/ent/get_groups"
        urlApiGetMembers =  HostConfig.libHost + "/1/ent/get_members"
        urlApiGetMember =  HostConfig.libHost + "/1/ent/get_member"
        urlApiGetRoles =  HostConfig.libHost + "/1/ent/get_roles"
        urlApiSyncMember =  HostConfig.libHost + "/1/ent/sync_member"
        urlApiGetMemberFileLink =  HostConfig.libHost + "/1/ent/get_member_file_link"
        urlApiAddSyncMember =  HostConfig.libHost + "/1/ent/add_sync_member"
        urlApiDelSyncMember =  HostConfig.libHost + "/1/ent/del_sync_member"
        urlApiAddSyncGroup =  HostConfig.libHost + "/1/ent/add_sync_group"
        urlApiDelSyncGroup =  HostConfig.libHost + "/1/ent/del_sync_group"
        urlApiAddSyncGroupMember =  HostConfig.libHost + "/1/ent/add_sync_group_member"
        urlApiDelSyncGroupMember =  HostConfig.libHost + "/1/ent/del_sync_group_member"
        urlApiGetGroupMembers =  HostConfig.libHost + "/1/ent/get_group_members"
    }
    
    @objc public init(clientId: String, clientSecret: String,isEnt:Bool,token:String) {
        super.init(clientId:clientId,clientSecret:clientSecret,isEnt:isEnt)
        _token = token
    }

    //MARK:获取角色
    @objc open func getRoles() -> Dictionary<String, AnyObject>{
        let method = "GET"
        let url = urlApiGetRoles
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }
    
    //MARK:获取成员
    @objc open func getMembers(_ start:Int,size:Int) -> Dictionary<String, AnyObject>{
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
    @objc open func getGroups() -> Dictionary<String, AnyObject>{
        let method = "GET"
        let url = urlApiGetGroups
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
    
    //MARK:根据成员id获取成员个人库外链
    @objc open func getMemberFileLink(_ memberId:Int,fileOnly:Bool)-> Dictionary<String, AnyObject>{
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
    @objc open func getMemberById(_ memberId:Int) -> Dictionary<String, AnyObject>{
        return getMember(memberId, outId: nil, account: nil)
    }
    
    //MARK:根据外部成员id获取企业成员信息
   @objc open func getMemberByOutId(_ outId:String) -> Dictionary<String, AnyObject>{
        return getMember(0, outId: outId, account: nil)
    }
    
    //MARK:根据帐号获取企业成员信息
    @objc open func getMemberByAccount(_ account:String) -> Dictionary<String, AnyObject>{
        return getMember(0, outId: nil, account: account)
    }
    
    fileprivate func getMember(_ memberId:Int,outId:String!,account:String!) -> Dictionary<String, AnyObject>{
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
    @objc open func addSyncMember(_ oudId:String,memberName:String,account:String,memberEmail:String?,memberPhone:String?,password:String?)-> Dictionary<String, AnyObject>{
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
    @objc open func delSyncMember(_ members:[String])-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiDelSyncMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["members"] = members.joined(separator: ",")
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
    
    //MARK:添加同步分组的成员
    @objc  open func addSyncGroup(_ outId:String,name:String,parentOutId:String?)-> Dictionary<String, AnyObject>{
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
    @objc open func delSyncGroup(_ groups:[String])-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiDelSyncGroup
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["groups"] = groups.joined(separator: ",")
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
   
    //MARK:添加同步分组成员
    @objc open func addSyncGroupMember(_ groupOutId:String,members:[String])-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiAddSyncGroupMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["group_out_id"] = groupOutId
        params["members"] = members.joined(separator: ",")
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
        
    }
    
    //MARK:删除同步分组成员
   @objc open func delSyncGroupMember(_ groupOutId:String,members:[String])-> Dictionary<String, AnyObject>{
        let method = "POST"
        let url = urlApiDelSyncGroupMember
        var params = Dictionary<String, String?>()
        params["token"] = _token
        params["token_type"] = "ent"
        params["group_out_id"] = groupOutId
        params["members"] = members.joined(separator: ",")
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }
    
    //MARK:获得分组成员
    @objc open func getGroupMembers(_ groupId:Int,start:Int,size:Int, showChild:Bool)-> Dictionary<String, AnyObject>{
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
    @objc open func clone() -> EntManager {
        return EntManager(clientId: _clientId, clientSecret: _clientId, isEnt: _isEnt)
    }
    

}
