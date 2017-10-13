//
//  gkdic.swift
//  GYKUtility
//
//  Created by wqc on 2017/7/28.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation


extension Dictionary where Key == String, Value == String {
    
    func gyk_sign(key: String, urlencode: Bool = true) -> String {
        return GYKUtility.getSignFromDic(self, key: key, urlencode: urlencode)
    }
    
    var gyk_str: String {
        if let s = GYKUtility.obj2str(obj: self) {
            return s
        }
        return ""
    }
    
    func gyk_query(encode: Bool = true) -> String {
        let querys = self.map { (item: (key: String, value: String)) -> String in
            return item.key + "=" + (encode ? item.value.gyk_urlEncode : item.value)
        }
        return querys.joined(separator: "&")
    }
}

extension Array {
    mutating func gyk_remove(at indexes: [Int]) {
        for i in indexes.sorted(by: >) {
            self.remove(at: i)
        }
    }
}


#if GKObjcCompatibility
extension NSDictionary {
        func gyk_sign(key: NSString) -> NSString {
            let dic:[String:String] = self as! [String:String]
            return dic.gyk_sign(key: key as String) as NSString
        }
        
        func gyk_query(encode: Bool = true) -> NSString {
            let dic:[String:String] = self as! [String:String]
            return dic.gyk_query() as NSString
        }
        
        var gyk_str: NSString? {
            let dic:[AnyHashable:Any] = self as! [AnyHashable:Any]
            return GYKUtility.obj2str(obj: dic) as NSString?
        }
    }
#else

#endif
