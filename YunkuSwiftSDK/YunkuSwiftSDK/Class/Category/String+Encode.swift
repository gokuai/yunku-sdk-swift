//
//  String+Encode.swift
//  YunkuSwiftSDK
//
//  Created by Brandon on 15/6/4.
//  Copyright (c) 2015年 goukuai. All rights reserved.
//

import Foundation
public extension String {
//    public var urlEncode :String! {
//        var customAllowedSet =  NSCharacterSet(charactersInString:" !*'();:@&=+$,/?%#[]^").invertedSet
//        return self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
//    }
    
    public var urlEncode: String! {
        return CFURLCreateStringByAddingPercentEscapes(
            nil,
            self as CFString,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString,
            CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}
