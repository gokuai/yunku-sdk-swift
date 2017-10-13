//
//  gkstring.swift
//  GYKUtility
//
//  Created by wqc on 2017/7/27.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

extension String {
    
    var gyk_urlEncode: String {
        let charactersGeneralDelimitersToEncode = ":#[]@/?"
        let charactersSubDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: charactersGeneralDelimitersToEncode.appending(charactersSubDelimitersToEncode))
        
        
        if let s = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            return s
        }
        return self
    }
    
    var gyk_parentPath: String {
        if let r = self.range(of: "/", options: .backwards, range: nil, locale: nil) {
            let s = String(self.characters.prefix(upTo: r.lowerBound))
            return s
        }
        return ""
    }
    
    var gyk_fileName: String {
        if let r = self.range(of: "/", options: .backwards, range: nil, locale: nil) {
            let pos = self.characters.index(after: r.lowerBound)
            let s = String(self.characters.suffix(from: pos))
            return s
        }
        
        return self
    }
    
    var gyk_ext: String {
        let s = (self as NSString).pathExtension
        return s
    }
    
    var gyk_rawFileName: String {
        if let r = self.range(of: ".", options: .backwards, range: nil, locale: nil) {
            let s = String(self.characters.prefix(upTo: r.lowerBound))
            return s
        }
        return self
    }
    
    var gyk_trimSlash: String {
        let set = CharacterSet(charactersIn: "/")
        return self.trimmingCharacters(in: set)
    }
    
    var gyk_trimSpace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var gyk_addLastSlash: String {
        if self.isEmpty {
            return self
        }
        let c = self.characters.last
        if c! == "/" {
            return self
        }
        return self.appending("/")
    }
    
    var gyk_removeLastSlash: String {
        
        if self.isEmpty {
            return self
        }
        let c = self.characters.last
        if c! != "/" {
            return self
        }
        return self.substring(to:  self.characters.index(before: self.characters.endIndex))
    }
    
    var gyk_replaceToSQL: String {
        return self.replacingOccurrences(of: "'", with: "''")
    }
    
    
    var gyk_MD5: String {
        
        let s = gkobjassist.md5(self)
        return s
    }
    
    var gyk_Sha1: String {
        return gkobjassist.sha1(self)
    }
    
    func gyk_sign(key: String, urlencode: Bool = true) -> String {
        
        let s = gkobjassist.generateSign(self, key: key)
        return (urlencode ? s.gyk_urlEncode : s)
    }
    
    var gyk_dic: [AnyHashable:Any]? {
        return GYKUtility.json2dic(obj:self)
    }
    
    var gyk_arr: [Any]? {
        return GYKUtility.json2arr(obj:self)
    }
    
    var gyk_base64: String {
        if let d = GYKUtility.str2data(str: self) {
            return d.base64EncodedString()
        }
        return ""
    }
    
//    func gyk_size(maxWidth:CGFloat,font:UIFont) -> CGSize {
//        let s = self as NSString
//
//        return s.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName:font], context: nil).size
//    }
    
}

//
//#if GKObjcCompatibility
//     extension NSString {
//
//         func gyk_urlEncode() -> NSString {
//            let s: String = String(self)
//            return s.gyk_urlEncode as NSString
//        }
//
//         func gyk_parentPath() -> NSString {
//            let s: String = String(self)
//            return s.gyk_parentPath as NSString
//        }
//
//         func gyk_fileName() -> NSString {
//            let s: String = String(self)
//            return s.gyk_fileName as NSString
//        }
//
//         func gyk_trimSlash() -> NSString {
//            let s: String = String(self)
//            return s.gyk_trimSlash as NSString
//        }
//
//         func gyk_trimSpace() -> NSString {
//            let s: String = String(self)
//            return s.gyk_trimSpace as NSString
//        }
//
//         func gyk_addLastSlash() -> NSString {
//            let s: String = String(self)
//            return s.gyk_addLastSlash as NSString
//        }
//
//         func gyk_removeLastSlash() -> NSString {
//            let s: String = String(self)
//            return s.gyk_removeLastSlash as NSString
//        }
//
//         func gyk_replaceToSQL() -> NSString {
//            let s: String = String(self)
//            return s.gyk_replaceToSQL as NSString
//        }
//
//         func gyk_MD5() -> NSString {
//            let s: String = String(self)
//            return s.gyk_MD5 as NSString
//        }
//
//         func gyk_Sha1() -> NSString {
//            let s: String = String(self)
//            return s.gyk_Sha1 as NSString
//        }
//
//         func gyk_base64() -> NSString {
//            let s: String = String(self)
//            return s.gyk_base64 as NSString
//        }
//
//         func gyk_dic() -> NSDictionary? {
//            let s: String = String(self)
//            return s.gkDic as NSDictionary?
//        }
//
//         func gyk_arr() -> NSArray? {
//            let s: String = String(self)
//            return s.gkArr as NSArray?
//        }
//
//        func gyk_sign(key: String, urlencode: Bool = true) -> NSString {
//
//            let s: String = String(self)
//            return s.gkSign(key:key,urlencode: urlencode) as NSString
//        }
//
//        func gyk_size(maxWidth:CGFloat,font:UIFont) -> CGSize {
//            return self.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName:font], context: nil).size
//        }
//
//    }
//
//#else
//
//
//
//#endif

