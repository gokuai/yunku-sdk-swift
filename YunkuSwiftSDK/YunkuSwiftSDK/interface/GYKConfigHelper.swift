//
//  GKServerInfo.swift
//  gknet
//
//  Created by wqc on 2017/9/14.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

public class GYKConfigHelper : NSObject {
    
    @objc static public let shanreConfig = GYKConfigHelper()
    
    var https = false
    var oauth_host = ""
    var api_host = ""
    var upload_root_path: String?
    var userAgent: String?
    var language: String?
    
    @objc public func oauthHost(_ host: String) -> GYKConfigHelper {
        self.oauth_host = host
        return self
    }
    
    @objc public func apiHost(_ host: String) -> GYKConfigHelper {
        self.api_host = host
        return self
    }
    
    @objc public func uploadRootPath(_ path: String) -> GYKConfigHelper {
        self.upload_root_path = path
        return self
    }

}

