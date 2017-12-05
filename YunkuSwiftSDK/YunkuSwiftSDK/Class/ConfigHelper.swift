//
//  ConfigHelper.swift
//  YunkuSwiftSDK
//
//  Created by Brandon on 2017/12/5.
//  Copyright © 2017年 goukuai. All rights reserved.
//

import Foundation

@objc open class ConfigHelper:NSObject {
    
    var _apiHost = ""
    var _apiLibHost = ""
    
    @objc public func apihost(apiHost:String) -> ConfigHelper{
        _apiHost = apiHost
        return self
    }
    
    @objc public func apiLibHost(apiLibHost:String) -> ConfigHelper {
        _apiLibHost = apiLibHost
        return self
    }
    
   @objc public func config() ->  Void {
        HostConfig.libHost = _apiLibHost
        HostConfig.oauthHost = _apiHost
    }
    
}
