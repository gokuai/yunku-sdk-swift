//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

@objc public class SignAbility: NSObject {

    var _clientSecret = ""

    func generateSign(dic: Dictionary<String, String?>) -> String {

        let removeEmptyDic = Utils.removeEmptyParmas(dic)

        let sortedDic = Array(removeEmptyDic).sort({ $0.0 < $1.0 })

        var generateString = ""

        for (index, value) in sortedDic.enumerate() {
            if value.1 != nil {
                generateString += value.1! + (index == (sortedDic.count - 1) ? "" : "\n")
            }
        }

        return generateString.sign(HMACAlgorithm.SHA1, key: _clientSecret).urlEncode
    }
    
    public class func generateSign(dic:Dictionary<String, String?>, clientSecret:String, encode:Bool ) ->String {
        let removeEmptyDic = Utils.removeEmptyParmas(dic)
        
        let sortedDic = Array(removeEmptyDic).sort({ $0.0 < $1.0 })
        
        var generateString = ""
        
        for (index, value) in sortedDic.enumerate() {
            if value.1 != nil {
                generateString += value.1! + (index == (sortedDic.count - 1) ? "" : "\n")
            }
        }
        
        return encode ? generateString.sign(HMACAlgorithm.SHA1, key: clientSecret).urlEncode: generateString.sign(HMACAlgorithm.SHA1, key: clientSecret)
    }

}
