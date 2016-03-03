//
// Created by Brandon on 15/6/2.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation
import CommonCrypto

public enum HMACAlgorithm: CustomStringConvertible {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCEnum() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    public var description: String {
        get {
            switch self {
            case .MD5:
                return "HMAC.MD5"
            case .SHA1:
               return "HMAC.SHA1"
            case .SHA224:
                return "HMAC.SHA224"
            case .SHA256:
                return "HMAC.SHA256"
            case .SHA384:
                return "HMAC.SHA384"
            case .SHA512:
                return "HMAC.SHA512"
            }
        }
    }
}

extension String {
    public func sign(algorithm: HMACAlgorithm, key: String) -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)
        return data!.sign(algorithm, key: key)
    }

    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)

        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.dealloc(digestLen)

        return String(format: hash as String)
    }
}

extension NSData {
    public func sign(algorithm: HMACAlgorithm, key: String) -> String {
        let string = UnsafePointer<UInt8>(self.bytes)
        let stringLength = Int(self.length)
        let digestLength = algorithm.digestLength()
        let keyString = key.cStringUsingEncoding(NSUTF8StringEncoding)!
        let keyLength = Int(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        var result = [UInt8](count: digestLength, repeatedValue: 0)
        
        CCHmac(algorithm.toCCEnum(), keyString, keyLength, string, stringLength, &result)
 
    
        // 直接做签名处理
        return Utils.byteArrayToBase64(result).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

//以下是第三方源码
//        var hash: String = ""
//        for i in 0..<digestLength {
//            hash += String(format: "%02x", result[i])
//        }
//        return hash
        
    }
    
    public func sha1() -> NSData {
        let result = NSMutableData(length: Int(CC_SHA1_DIGEST_LENGTH))!
        CC_SHA1(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(result.mutableBytes))
        
        return NSData(data: result)
    }
    
    func toHexString() -> String {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        
        var s:String = "";
        for byte in bytesArray {
            s = s + String(format:"%02X", byte)
        }
        return s;
    }
    
    public func arrayOfBytes() -> [UInt8] {
        let count = self.length / sizeof(UInt8)
        var bytesArray = [UInt8](count: count, repeatedValue: 0)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }
    
    class public func withBytes(bytes: [UInt8]) -> NSData {
        return NSData(bytes: bytes, length: bytes.count)
    }
    
    
}
