//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

@objc public class EntManager :NSObject {

    private var httpEngine: GYKHttpEngine!
    
    @objc public init(clientID: String, clientSecret: String) {
        self.httpEngine = GYKHttpEngine(host: GYKConfigHelper.shanreConfig.api_host, clientID: clientID, clientSecret: clientSecret, errorLog: nil)
    }

    //MARK:获取角色
    @objc public func getRoles() -> GYKResponse {
        return self.httpEngine.getEntRoles()
    }
    
    //MARK:获取成员
    @objc public func getMembers(start: Int, size: Int) -> GYKResponse {
        return self.httpEngine.getEntMemberList(start: start, size: size)
        
    }
   
    //MARK:获取分组
    @objc public func getGroups() -> GYKResponse {
        return self.httpEngine.getEntGroups()
    }

}
