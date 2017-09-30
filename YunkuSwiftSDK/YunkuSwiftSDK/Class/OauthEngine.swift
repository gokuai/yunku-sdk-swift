//
//  OauthEngine.swift
//  YunkuSwiftSDK
//
//  Created by qp on 2017/9/25.
//  Copyright © 2017年 goukuai. All rights reserved.
//

import Foundation

open class OauthEngine : HttpEngine {
    
    let urlApiToken = HostConfig.oauthHost + "/oauth2/token2"
    
    var _token = ""
    var _tokenType = ""
    var _refreshToken = ""
    var _isEnt = false
    
    init(clientId: String, clientSecret: String, isEnt: Bool) {
        super.init(clientId: clientId, clientSecret: clientSecret)
        _tokenType = isEnt ? "ent":""
        _isEnt = isEnt
    }
    
    init(clientId: String, clientSecret: String, isEnt: Bool, token: String) {
        self.init(clientId: clientId, clientSecret: clientSecret, isEnt: isEnt)
        self._token = token
    }
    
    //MARK:使用账号用户名获取token
    open func accessToken(_ username:String, password:String) -> Dictionary<String, AnyObject> {
        let url = urlApiToken;
        let methodString = "POST"
        var params = Dictionary<String, String?>()
        params["username"] = username
        
        var passwordEncode:String;
        if username.range(of: "\\") != nil || username.range(of: "/") != nil{
            passwordEncode = Utils.byteArrayToBase64([UInt8](username.utf8))
        }else{
            passwordEncode = password.md5
        }
        
        params["password"] = passwordEncode
        params["client_id"] = _clientId
        params["grant_type"] = _isEnt ? "ent_password" : "password"
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)
        
        let returnDiction = NetConnection.sendRequest(url, method: methodString, params: params, headParams: nil)
        let returnResult = ReturnResult.create(returnDiction)
        
        if returnResult.code == HTTPStatusCode.ok.rawValue {
            let data = OauthData.create(returnDiction as NSDictionary);
            _token = data.accessToken
        }
        
        return returnDiction
    }
    
    //MARK:交换企业token
    open func exchangeEntToken(token: String){
        
        if !token.isEmpty {
            _token = token
        }
    }
    
    //MARK:添加认证参数
    func addAuthParams(params: inout Dictionary<String,String?>){
        if _token.isEmpty {
            params["client_id"] = _clientId
            params["dateline"] = String(Utils.getUnixDateline())
        }else{
            params["token"] = _token
            params["token_type"] = _tokenType
        }
    }
    
    //MARK:重新活的token
    func refreshToken() -> Bool {
        
        let methodString = "POST"
        if _refreshToken.isEmpty {
            return false
        }
        var params = Dictionary<String,String>()
        params["grant_type"] = "refresh_token"
        params["refresh_token"] = _refreshToken
        params["client_id"] = _clientId
        params["sign"] = generateSign(params)
        
        let returnDiction = NetConnection.sendRequest(urlApiToken, method: methodString, params: params, headParams: nil)
        let returnResult = ReturnResult.create(returnDiction)
        
        if returnResult.code == HTTPStatusCode.ok.rawValue {
            let data = OauthData.create(returnResult.result as NSDictionary)
            _token = data.accessToken
            _refreshToken = data.refreshToken
            return true
        }
        
        return false
    }
    
    //身边验证有问题，自动刷新token
    open func sendRequestWithAuth(url:String,method:String,params:inout Dictionary<String,String>,headParams:Dictionary<String,String>,ignoreKeys:Array<String>,postType:String) -> Dictionary<String,AnyObject> {
        var returnDiction = NetConnection.sendRequest(url,method:method,params:params,headParams:headParams)
        let returnResult = ReturnResult.create(returnDiction)
        if returnResult.code == HTTPStatusCode.unauthorized.rawValue{
            refreshToken()
            reSignParams(params: &params,ignoreKeys:ignoreKeys)
            returnDiction = NetConnection.sendRequest(url,method:method,params:params,headParams:headParams)
        }
        return returnDiction
    }
    
    //MARK:重新进行签名
    func reSignParams(params: inout Dictionary<String,String>, ignoreKeys:Array<String>) {
        reSignParams(params: &params, secret: _clientSecret, ignoreKeys: ignoreKeys)
    }
    
    //MARK:重新根据参数进行签名
    func reSignParams(params:inout Dictionary<String,String>,secret:String,ignoreKeys:Array<String>) {
        params.removeValue(forKey: "token")
        params.removeValue(forKey: "sign")
        params["token"] = _token
        params["sign"] = generateSign(params)
        
    }
    
    
}
