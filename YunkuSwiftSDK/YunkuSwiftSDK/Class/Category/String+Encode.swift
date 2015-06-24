//
//  String+Encode.swift
//  YunkuSwiftSDK
//
//  Created by Brandon on 15/6/4.
//  Copyright (c) 2015年 goukuai. All rights reserved.
//

import Foundation
extension String {
    var urlEncode :String! {
        var customAllowedSet =  NSCharacterSet(charactersInString:"!*'();:@&=+$,/?%#[]").invertedSet
        return self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
    }
}
