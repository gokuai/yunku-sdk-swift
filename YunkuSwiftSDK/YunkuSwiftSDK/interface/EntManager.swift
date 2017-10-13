//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

open class EntManager :NSObject {

    private var httpEngine: GYKHttpEngine!
    
    @objc public init(clientID: String, clientSecret: String) {
        self.httpEngine = GYKHttpEngine(clientID: clientID, clientSecret: clientSecret, errorLog: nil)
    }

    //MARK:获取角色
    open func getRoles() -> GYKResponse {
        return self.httpEngine.getEntRoles()
    }
    
    //MARK:获取成员
    open func getMembers(start: Int,
                         size: Int) -> GYKResponse {
        return self.httpEngine.getEntMembers(start: start, size: size)
        
    }
   
    //MARK:获取分组
    open func getGroups() -> GYKResponse {
        return self.httpEngine.getEntGroups()
    }

}
