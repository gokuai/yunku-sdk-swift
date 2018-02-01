//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation
import CryptoSwift
//import CommonCrypto
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


open class Utils {
    
    //MARK:移除空参数，FIXME:可以考虑优化为指针的方式
    class func removeEmptyParmas(_ dic: Dictionary<String, String?>?)->Dictionary<String, String?>{
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
    class func byteArrayToBase64(_ bytes: [UInt8]) -> String {
        let nsdata = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        let base64Encoded = nsdata.base64EncodedString(options: []);
        return base64Encoded;
    }
    
    //MARK: Base64String to Array
    class func base64ToByteArray(_ base64String: String) -> [UInt8]? {
        if let nsdata = Data(base64Encoded: base64String, options: []) {
            var bytes = [UInt8](repeating: 0, count: nsdata.count)
            (nsdata as NSData).getBytes(&bytes, length: bytes.count)
            return bytes
        }
        return nil // Invalid input
    }
    
    //MARK:获取Unix时间
    class func getUnixDateline()->Int {
      return Int(Date().timeIntervalSince1970)
    }
    
    //MARK: 获取文件
    open class func getFileSha1(_ path:String)->String {
        
        let handler = FileHandle(forReadingAtPath: path)
        let fileSize = handler?.seekToEndOfFile()
        handler?.seek(toFileOffset: 0)
        let partSize = 65536
        
        var sha1 = SHA1()
        
        while handler?.offsetInFile < fileSize{
            let readData = handler?.readData(ofLength: partSize)
//            let ptr = (readData! as NSData).bytes.bindMemory(to: UInt8.self, capacity: readData!.count)
            var buffer = [UInt8](repeating:0,count: readData!.count)
            (readData! as NSData).getBytes(&buffer, length: readData!.count)
            
            do{
                try sha1.update(withBytes: buffer)
            }catch(let e){
                LogPrint.error(NetConnection.logTag,msg:e)
            }
            
        }
    
        var s:String = "";
        
        var  bytesArray = [UInt8]()
        
        do{
            bytesArray = try sha1.finish()
            
        }catch(let e){
            LogPrint.error(NetConnection.logTag,msg:e)
        }
        
        for byte in bytesArray {
            s = s + String(format:"%02x", byte)
        }
        return s;
        
    }
    
}
