//
//  gkdata.swift
//  GYKUtility
//
//  Created by wqc on 2017/7/28.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

private let  DEFAULT_POLYNOMIAL: UInt32 = 0xEDB88320
private let  DEFAULT_SEED: UInt32 = 0xFFFFFFFF


extension Data {
    
    var gyk_dic: [AnyHashable:Any]? {
        return GYKUtility.json2dic(obj:self)
    }
    
    var gyk_arr: [Any]? {
        return GYKUtility.json2arr(obj:self)
    }
    
    var gyk_str: String? {
        return GYKUtility.data2str(data: self)
    }
    
    var gyk_crc32: UInt32 {
        return gkobjassist.crc32(of: self, seed: DEFAULT_SEED, usingPolynomial: DEFAULT_POLYNOMIAL)
    }
}

#if GKObjcCompatibility
 extension NSData {
        var gyk_dic: NSDictionary? {
            let d: Data = self as Data
            return d.gyk_dic as NSDictionary?
        }
        
        var gyk_arr: NSArray? {
            let d: Data = self as Data
            return d.gyk_arr as NSArray?
        }
        
        var gyk_str: NSString? {
            let d: Data = self as Data
            return d.gyk_str as NSString?
        }
        
        var gyk_crc32: UInt32 {
            let d: Data = self as Data
            return d.gyk_crc32
        }
    }
#else

#endif
