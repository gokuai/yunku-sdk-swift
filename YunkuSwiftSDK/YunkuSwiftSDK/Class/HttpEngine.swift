//
//  HttpEngine.swift
//  YunkuSwiftSDK
//
//  Created by qp on 2017/9/25.
//  Copyright © 2017年 goukuai. All rights reserved.
//

import Foundation

open class HttpEngine: SignAbility {
    
    var _clientId = ""
    var _clientSecret = ""
    
    init(clientId :String, clientSecret :String) {
        super.init()
        self._clientId = clientId
        self._clientSecret = clientSecret
    }
    
    open func generateSign(_ params: Dictionary<String,String?>) -> String {
        return generateSign(params,secret: _clientSecret)
    }
    
    open struct RequestHelper{
        
        var params = Dictionary<String,String?>()
        var headParams = Dictionary<String,String?>()
        var ignoreKeys = Array<String?>()
        var method = ""
        var postType = ""
        var url = ""
        var checkAuth = false
        
        func setMethod(method:String) -> RequestHelper {
            self.method = method
            return self
        }
        
        func setParams(params: Dictionary<String,String?>) -> RequestHelper {
            self.params = params
            return self
        }
        
        func setHeadParams(headParams: Dictionary<String,String?>) -> RequestHelper {
            self.headParams = headParams
            return self
        }
        
        func setCheckAuth(checkAuth: Bool) -> RequestHelper {
            self.checkAuth = checkAuth
            return self
        }
        
        func setPostType(postType: String) -> RequestHelper {
            self.postType = postType
            return self
        }
        
        func setUrl(url: String) -> RequestHelper {
            self.url = url
            return self
        }
        
        func setIgnoreKeys(ignoreKeys: Array<String>) -> RequestHelper {
            self.ignoreKeys = ignoreKeys
            return self
        }
        
        func executeSync() -> Dictionary<String,AnyObject> {
            checkNecessary(url: url,method:_method)
            
            return NetConnection.sendRequest(url, method: _method, params: params, headParams: headParams)
        }
        
        func checkNecessary(url: String,method: String) {
            if url.isEmpty {
                throw EmptyError.url(ErrorMsg: "url must not be null")
            }
            
            if _method == nil {
                throw EmptyError.method(ErrorMsg: "method must not be null")
            }
        }
    }
}
enum EmptyError: Error {
    case url(ErrorMsg: String)
    case method(ErrorMsg: String)
}
