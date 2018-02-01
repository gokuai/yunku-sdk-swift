//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation
import CryptoSwift

@objc open class SignAbility: NSObject {
    let logTag = "SignAbility"

    var _clientSecret = ""

    func generateSign(_ dic: Dictionary<String, String?>) -> String {

        let removeEmptyDic = Utils.removeEmptyParmas(dic)

        let sortedDic = Array(removeEmptyDic).sorted(by: { $0.0 < $1.0 })

        var generateString = ""

        for (index, value) in sortedDic.enumerated() {
            if value.1 != nil {
                generateString += value.1! + (index == (sortedDic.count - 1) ? "" : "\n")
            }
        }
        do {
            let bytes:Array<UInt8> = try HMAC(key: _clientSecret.bytes, variant: .sha1).authenticate(generateString.bytes)
            let result:String! = Utils.byteArrayToBase64(bytes)

            if(result == nil){
                return ""
            }
            return result
        } catch(let e){
            LogPrint.error(logTag,msg:e)
        }
        
        return ""
    }
    

}
