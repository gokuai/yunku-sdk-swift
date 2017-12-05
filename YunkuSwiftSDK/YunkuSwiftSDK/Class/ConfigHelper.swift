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
    
    func apihost(apiHost:String) -> ConfigHelper{
        _apiHost = apiHost
        return self
    }
    
    func apiLibHost(apiLibHost:String) -> ConfigHelper {
        _apiLibHost = apiLibHost
        return self
    }
    
    func config() ->  Void {
        HostConfig.libHost = _apiLibHost
        HostConfig.oauthHost = _apiHost
    }
    
}
