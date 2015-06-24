//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

public class ParentEngine: SignAbility {
    let urlApiToken = HostConfig.oauthHost + "/oauth2/token"

    var _clientId = ""
    var _username = ""
    var _password = ""
    var _token = ""

    init(username: String, password: String, clientId: String, clientSecret: String) {
        super.init()
        _username = username
        _password = password
        _clientId = clientId
        _clientSecret = clientSecret;

    }

    public func accessToken(isEnt: Bool) -> Dictionary<String, AnyObject> {
        let url = urlApiToken;
        let methodString = "POST"
        var params = Dictionary<String, String?>()
        params["username"] = _username
        params["password"] = _password.md5
        params["client_id"] = _clientId
        params["client_secret"] = _clientSecret
        params["grant_type"] = isEnt ? "ent_password" : "password"

        var returnDiction = NetConnection.sendRequest(url, method: methodString, params: params, headParams: nil)
        var returnResult = ReturnResult.create(returnDiction)

        if returnResult.code == HTTPStatusCode.OK.rawValue {
            var data = OauthData.create(returnDiction);
            _token = data.accessToken
        }

        return returnDiction
    }
}
