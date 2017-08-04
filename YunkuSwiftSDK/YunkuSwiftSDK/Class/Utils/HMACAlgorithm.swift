//
// Created by Brandon on 15/6/2.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation
import CommonCrypto

public enum HMACAlgorithm: CustomStringConvertible {
    case md5, sha1, sha224, sha256, sha384, sha512
    
    func toCCEnum() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:
            result = kCCHmacAlgMD5
        case .sha1:
            result = kCCHmacAlgSHA1
        case .sha224:
            result = kCCHmacAlgSHA224
        case .sha256:
            result = kCCHmacAlgSHA256
        case .sha384:
            result = kCCHmacAlgSHA384
        case .sha512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .md5:
            result = CC_MD5_DIGEST_LENGTH
        case .sha1:
            result = CC_SHA1_DIGEST_LENGTH
        case .sha224:
            result = CC_SHA224_DIGEST_LENGTH
        case .sha256:
            result = CC_SHA256_DIGEST_LENGTH
        case .sha384:
            result = CC_SHA384_DIGEST_LENGTH
        case .sha512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
    
    public var description: String {
        get {
            switch self {
            case .md5:
                return "HMAC.MD5"
            case .sha1:
               return "HMAC.SHA1"
            case .sha224:
                return "HMAC.SHA224"
            case .sha256:
                return "HMAC.SHA256"
            case .sha384:
                return "HMAC.SHA384"
            case .sha512:
                return "HMAC.SHA512"
            }
        }
    }
}

extension String {
    public func sign(_ algorithm: HMACAlgorithm, key: String) -> String {
        let data = self.data(using: String.Encoding.utf8)
        return data!.sign(algorithm, key: key)
    }

    var md5: String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate(capacity: digestLen)

        return String(format: hash as String)
    }
}

extension Data {
    public func sign(_ algorithm: HMACAlgorithm, key: String) -> String {
        let string = (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)
        let stringLength = Int(self.count)
        let digestLength = algorithm.digestLength()
        let keyString = key.cString(using: String.Encoding.utf8)!
        let keyLength = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        var result = [UInt8](repeating: 0, count: digestLength)
        
        CCHmac(algorithm.toCCEnum(), keyString, keyLength, string, stringLength, &result)
 
    
        // 直接做签名处理
        return Utils.byteArrayToBase64(result).trimmingCharacters(in: CharacterSet.whitespaces)

//以下是第三方源码
//        var hash: String = ""
//        for i in 0..<digestLength {
//            hash += String(format: "%02x", result[i])
//        }
//        return hash
        
    }
    
//    public func sha1() -> Data {
//        let result = NSMutableData(length: Int(CC_SHA1_DIGEST_LENGTH))!
//        CC_SHA1(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(result.mutableBytes))
//        
//        return Data(data: result,resu)
//    }
    
    func toHexString() -> String {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        
        var s:String = "";
        for byte in bytesArray {
            s = s + String(format:"%02X", byte)
        }
        return s;
    }
    
    public func arrayOfBytes() -> [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
    
    static public func withBytes(_ bytes: [UInt8]) -> Data {
        return Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    }
    
    
}
