//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

@objc open class SignAbility: NSObject {

    func generateSign(_ dic: Dictionary<String, String?>, secret: String) -> String {
        
        let removeEmptyDic = Utils.removeEmptyParmas(dic)
        
        let sortedDic = Array(removeEmptyDic).sorted(by: { $0.0 < $1.0 })
        
        var generateString = ""
        
        for (index, value) in sortedDic.enumerated() {
            if value.1 != nil {
                generateString += value.1! + (index == (sortedDic.count - 1) ? "" : "\n")
            }
        }
        
        return generateString.sign(HMACAlgorithm.sha1, key: secret)
    }
    
    func generateSign(_ params: Dictionary<String,String?>,secret: String,ignoreKeys: Array<String>?) -> String {
        
        let removeEmptyDic = Utils.removeEmptyParmas(params)
        
        let sortedDic = Array(removeEmptyDic).sorted(by: { $0.0 < $1.0 })
        
        var generateString = ""
        
        for (index, value) in sortedDic.enumerated() {
            if value.1 != nil {
                if ignoreKeys != nil && (ignoreKeys?.contains(value.key))! {
                    continue
                }
                generateString += value.1! + (index == (sortedDic.count - 1) ? "" : "\n")
            }
        }
        
        return generateString.sign(HMACAlgorithm.sha1, key: secret)
        
    }
}
