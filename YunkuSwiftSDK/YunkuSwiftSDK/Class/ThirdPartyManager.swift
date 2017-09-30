//
//  ThirdPartyManager.swift
//  YunkuSwiftSDK
//
//  Created by qp on 2017/9/26.
//  Copyright © 2017年 goukuai. All rights reserved.
//

import Foundation

open class ThirdPartyManager: HttpEngine {
    
    let urlApiCreateEnt = HostConfig.oauthHost + "/1/thirdparty/create_ent"
    let urlApiEntInfo = HostConfig.oauthHost + "/1/thirdparty/ent_info"
    let urlApiOrder = HostConfig.oauthHost + "/1/thirdparty/order"
    let urlApiGetToken = HostConfig.oauthHost + "/1/thirdparty/get_token"
    let urlApiSsoUrl = HostConfig.oauthHost + "/1/thirdparty/get_sso_url"
    
    let subscribe = "orderSubscribe"
    let renew = "orderRenew"
    let upgrade = "orderUpgrade"
    let unsubscribe = "orderUnsubscribe"
    var _outId = ""
    
    init(clientId: String, clientSecret: String, outId: String) {
        super.init(clientId: clientId, clientSecret: clientSecret)
        self._outId = outId
    }
    
    //MARK:开通企业
    func createEnt(_ entName: String, contactName: String, contactMobile: String, contactEmail: String, contactAddress: String) -> Dictionary<String, AnyObject> {
        return createEnt(nil, entName: entName, contactName: contactName, contactMobile: contactMobile, contactEmail: contactEmail, contactAddress: contactAddress)
    }
    
    //MARK:扩展参数
    func createEnt(_ map: Dictionary<String,String?>?,entName: String, contactName: String, contactMobile: String, contactEmail: String, contactAddress: String) -> Dictionary<String, AnyObject> {
        let url = urlApiCreateEnt
        let method = "POST"
        var params = Dictionary<String,String?>()
        params["client_id"] = _clientId
        params["out_id"] = _outId
        params["ent_name"] = entName
        params["contact_name"] = contactName
        params["contact_mobile"] = contactMobile
        params["contact_email"] = contactEmail
        params["contact_address"] = contactAddress
        params["dateline"] = String(Utils.getUnixDateline())
        if map != nil {
            params.merge(dictionaries: map!)
        }
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    func getEntInfo() -> Dictionary<String, AnyObject> {
        let url = urlApiEntInfo
        let method = "POST"
        var params = Dictionary<String,String?>()
        params["client_id"] = _clientId
        params["out_id"] = _outId
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:购买
    func orderSubscribe(memberCount: Int, space: Int, month: Int) -> Dictionary<String, AnyObject> {
        return order(subscribe, memberCount: memberCount, space: space, month: month)
    }
    
    //MARK:升级
    func orderUpgrade(memberCount: Int, space: Int) -> Dictionary<String, AnyObject> {
        return order(upgrade, memberCount: memberCount, space: space, month: 0)
    }
    
    //MARK:续费
    func orderRenew(month: Int) -> Dictionary<String, AnyObject> {
        return order(renew, memberCount: -1, space: 0, month: 0)
    }
    
    //MARK:退订
    func orderUnsubscribe() -> Dictionary<String, AnyObject> {
        return order(unsubscribe, memberCount: -1, space: 0, month: 0)
    }
    
    //MARK:订单处理
    func order(_ type: String, memberCount: Int, space: Int, month: Int) -> Dictionary<String, AnyObject> {
        let url = urlApiOrder
        let method = "POST"
        var params = Dictionary<String,String?>()
        params["client_id"] = _clientId
        params["out_id"] = _outId
        if !type.isEmpty {
            params["type"] = type
            switch type {
            case subscribe:
                params["member_count"] = String(memberCount)
                params["space"] = String(space)
                params["month"] = String(month)
            case upgrade:
                params["member_count"] = String(memberCount)
                params["space"] = String(space)
            case renew:
                params["month"] = String(month)
            default:
                print("")
            }
        }
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:获取企业token
    func getEntToken() -> Dictionary<String, AnyObject> {
        let url = urlApiGetToken
        let method = "POST"
        var params = Dictionary<String,String?>()
        params["client_id"] = _clientId
        params["out_id"] = _outId
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
    //MARK:获取单点登录地址
    func getSsoUrl(ticket: String) -> Dictionary<String, AnyObject> {
        let url = urlApiSsoUrl
        let method = "POST"
        var params = Dictionary<String,String?>()
        params["client_id"] = _clientId
        params["out_id"] = _outId
        params["ticket"] = ticket
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)
        return HttpEngine.RequestHelper().setParams(params: params).setUrl(url: url).setMethod(method: RequestMethod.POST.rawValue).executeSync()
    }
    
}

public extension Dictionary{
    
    mutating func merge<K, V>(dictionaries: Dictionary<K, V>...) {
        for dict in dictionaries {
            for (key, value) in dict {
                self.updateValue(value as! Value, forKey: key as! Key)
            }
        }
    }
}
