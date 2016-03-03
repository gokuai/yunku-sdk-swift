//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation
import CommonCrypto

public class Utils {
    
    //MARK:移除空参数，FIXME:可以考虑优化为指针的方式
    class func removeEmptyParmas(dic: Dictionary<String, String?>?)->Dictionary<String, String?>{
        if dic != nil {
            return dic!.filter {
                (key, value) -> Bool in
                if value == nil{
                    return false
                } else {
                    return true
                }
            }
        }else{
            return Dictionary<String, String?>()
        }
    }
    
    //MARK: Base64 byte array to String
    class func byteArrayToBase64(bytes: [UInt8]) -> String {
        let nsdata = NSData(bytes: bytes, length: bytes.count)
        let base64Encoded = nsdata.base64EncodedStringWithOptions([]);
        return base64Encoded;
    }
    
    //MARK: Base64String to Array
    class func base64ToByteArray(base64String: String) -> [UInt8]? {
        if let nsdata = NSData(base64EncodedString: base64String, options: []) {
            var bytes = [UInt8](count: nsdata.length, repeatedValue: 0)
            nsdata.getBytes(&bytes, length: bytes.count)
            return bytes
        }
        return nil // Invalid input
    }
    
    //MARK:获取Unix时间
    class func getUnixDateline()->Int {
      return Int(NSDate().timeIntervalSince1970)
    }
    
    //MARK: 获取文件
    public class func getFileSha1(path:String)->String {
        
        let handler = NSFileHandle(forReadingAtPath: path)
        let fileSize = handler?.seekToEndOfFile()
        handler?.seekToFileOffset(0)
        let partSize = 65536
        
        var sha1 = SHA1()
        
        while handler?.offsetInFile < fileSize{
            let readData = handler?.readDataOfLength(partSize)

            let ptr = UnsafePointer<UInt8>(readData!.bytes)
             let bytes = UnsafeBufferPointer<UInt8>(start: ptr, count: (readData?.length)!)
            sha1.append(bytes)
        }
        
        var s:String = "";
        let  bytesArray = sha1.finish()
        for byte in bytesArray {
            s = s + String(format:"%02x", byte)
        }
        return s;
        
    }
    
}
