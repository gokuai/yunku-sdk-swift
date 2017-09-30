//
//  OauthEngine.swift
//  YunkuSwiftSDK
//
//  Created by qp on 2017/9/25.
//  Copyright © 2017年 goukuai. All rights reserved.
//

import Foundation

open class OauthEngineV2: HttpEngine{
    
    let urlApiToken = HostConfig.oauthHostV2 + "/oauth2/token2"
    
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
    
    //MARK:添加认证参数
    open func addAuthParams(params: inout Dictionary<String,String?>){
        
            params["token"] = _token
            params["token_type"] = _tokenType
        }
    
}
