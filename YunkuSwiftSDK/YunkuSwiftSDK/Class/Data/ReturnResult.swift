//
// Created by Brandon on 15/5/29.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

@objc open class ReturnResult: NSObject {

    internal static let keyCode = "code"
    internal static let keyResult = "return_result"

    @objc open var result: Dictionary<String, AnyObject>!
    @objc open var code = 0

    override init() {
    }

    public init(code: Int?, result: Dictionary<String, AnyObject>?) {
        self.code = code!
        self.result = result
    }

    @objc open class func create(_ dic: Dictionary<String, AnyObject>) -> ReturnResult {
        let code = dic[keyCode] as? Int
        var result = dic[keyResult] as? Dictionary<String, AnyObject>

        if result == nil {
            result = Dictionary<String, AnyObject>()
        }

        return ReturnResult(code: code, result: result);
    }

}
