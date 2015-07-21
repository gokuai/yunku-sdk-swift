//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

public class ParentEngine: SignAbility {
    let urlApiToken = HostConfig.oauthHost + "/oauth2/token2"

    var _clientId = ""
    var _token = ""
    var _tokenType = ""
    var _isEnt = false

    init(clientId: String, clientSecret: String,isEnt:Bool) {
        super.init()
        _clientId = clientId
        _clientSecret = clientSecret;
        _isEnt = isEnt
        _tokenType = isEnt ? "ent":""
    }

    public func accessToken(username:String, password:String) -> Dictionary<String, AnyObject> {
        let url = urlApiToken;
        let methodString = "POST"
        var params = Dictionary<String, String?>()
        params["username"] = username
        
        var passwordEncode:String;
        if username.rangeOfString("\\") != nil || username.rangeOfString("/") != nil{
            passwordEncode = Utils.byteArrayToBase64([UInt8](username.utf8))
        }else{
            passwordEncode = password.md5
        }
        
        params["password"] = passwordEncode
        params["client_id"] = _clientId
        params["grant_type"] = _isEnt ? "ent_password" : "password"
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)

        var returnDiction = NetConnection.sendRequest(url, method: methodString, params: params, headParams: nil)
        var returnResult = ReturnResult.create(returnDiction)

        if returnResult.code == HTTPStatusCode.OK.rawValue {
            var data = OauthData.create(returnDiction);
            _token = data.accessToken
        }

        return returnDiction
    }
}
