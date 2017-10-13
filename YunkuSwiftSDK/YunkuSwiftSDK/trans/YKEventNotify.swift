//
//  YKUINotify.swift
//  YunkuSDK
//
//  Created by wqc on 2017/8/7.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

public let YKNotification_UploadFile = "YKNotification_UploadFile"
public let YKNotification_DownloadFile = "YKNotification_DownloadFile"

class YKEventNotify {
    
    enum EventType : Int {
        case uploadFile = 1
        case downloadFile
    }
    
    class func notify(_ param: Any?, type: EventType) {
        
        DispatchQueue.main.async {
            let center = NotificationCenter.default
            var postname = ""
            var json = ""
            switch type {
            case .uploadFile:
                postname = YKNotification_UploadFile
                if param is YKUploadItemData {
                    json = (param as! YKUploadItemData).notifyInfo
                }
            case .downloadFile:
                break
            }
            
            center.post(name: NSNotification.Name(postname), object: json, userInfo: nil)

        }
    }
    
}
