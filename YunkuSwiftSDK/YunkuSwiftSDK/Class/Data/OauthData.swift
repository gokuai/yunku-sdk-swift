//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

class OauthData: BaseData {
    static let keyAccessToken = "access_token"
    static let keyExpiresIn = "expires_in"
    static let keyError = "error"

    var accessToken: String = ""
    var expiresIn: Int = 0
    
    class func create(dic: NSDictionary) -> OauthData {
        let data = OauthData()
        data.code = (dic[ReturnResult.keyCode] as? Int)!
        var returnResult = dic[ReturnResult.keyResult] as? Dictionary<String, AnyObject>;
        if data.code == HTTPStatusCode.OK.rawValue {
            data.accessToken = (returnResult?[keyAccessToken] as? String)!
            data.expiresIn = (returnResult?[keyExpiresIn] as? Int)!
        } else {
            data.errorMsg = (returnResult?[keyError] as? String)!
        }
        return data
    }

}
