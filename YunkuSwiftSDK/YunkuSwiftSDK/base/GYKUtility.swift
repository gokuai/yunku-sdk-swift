//
//  GYKUtility.swift
//  GYKUtility
//
//  Created by wqc on 2017/7/24.
//  Copyright © 2017年 wqc. All rights reserved.
//

import UIKit
import Foundation

public let GYKTimeFormatYMDHMS = "YYYY-MM-dd HH:mm:ss"
public let GYKTimeFormatYMDHM = "YYYY-MM-dd HH:mm"
public let GYKTimeFormatYMDHM2 = "YYYY/MM/dd HH:mm"
public let GYKTimeFormatYMD = "YYYY-MM-dd"
public let GYKTimeFormatYMD2 = "YY/MM/dd"
public let GYKTimeFormatMDHM = "MM-dd HH:mm"
public let GYKTimeFormatMD = "M/d"
public let GYKTimeFormatHS = "H:mm"


fileprivate let kIconImageNameIMFolder      = "icon_imfolder"
fileprivate let kIconImageNameFolder        = "icon_folder"
fileprivate let kIconImageNameImage         = "icon_image"
fileprivate let kIconImageNamePPT           = "icon_ppt"
fileprivate let kIconImageNameXls           = "icon_xls"
fileprivate let kIconImageNameDoc           = "icon_doc"
fileprivate let kIconImageNameVideo         = "icon_video"
fileprivate let kIconImageNameAudio         = "icon_audio"
fileprivate let kIconImageNameCompress      = "icon_compress"
fileprivate let kIconImageNameExecute       = "icon_execute"
fileprivate let kIconImageNamePDF           = "icon_pdf"
fileprivate let kIconImageNameDocument      = "icon_document"
fileprivate let kIconImageNameGKNote        = "icon_gknote"
fileprivate let kIconImageNameMD            = "icon_md"
fileprivate let kIconImageNameAI            = "icon_ai"
fileprivate let kIconImageNamePSD           = "icon_psd"
fileprivate let kIconImageNameApk           = "icon_apk"
fileprivate let kIconImageNameCDR           = "icon_cdr"
fileprivate let kIconImageNameColletion     = "icon_colletion"
fileprivate let kIconImageNameDmg           = "icon_dmg"
fileprivate let kIconImageNameDwg           = "icon_dwg"
fileprivate let kIconImageNameEps           = "icon_eps"
fileprivate let kIconImageNameIPA           = "icon_ipa"
fileprivate let kIconImageNameOther         = "icon_other"
fileprivate let kIconImageNameCode          = "icon_code"
fileprivate let kIconImageNameISO           = "icon_iso"
fileprivate let kIconImageNameDB            = "icon_db"

fileprivate let FileIcons: [String:String] = [
    ";png;jpeg;jpg;bmp;gif;tiff;":kIconImageNameImage,
    ";mp4;mov;3pg;avi;flv;m4v;mkv;mpeg;mpg;wmv;ts;":kIconImageNameVideo,
    ";mp3;wma;aac;ape;asf;wav;flac;m4a;ogg;caf;aif;":kIconImageNameAudio,
    ";doc;docx;":kIconImageNameDoc,";xls;xlsx;":kIconImageNameXls,
    ";ppt;pptx;":kIconImageNamePPT,
    ";7z;zip;cab;gz;iso;rar;tar;":kIconImageNameCompress,
    ";bat;exe;com;cmd;":kIconImageNameExecute,
    ";pdf;":kIconImageNamePDF,
    ";gknote;":kIconImageNameGKNote,
    ";psd;":kIconImageNamePSD,
    ";ai;":kIconImageNameAI,
    ";md;":kIconImageNameMD,
    ";txt;rtf;":kIconImageNameDocument,
    ";iso;":kIconImageNameISO,
    ";cdr;":kIconImageNameCDR,
    ";dwg;dxf;":kIconImageNameDwg,
    ";msi;dmg;pkg;":kIconImageNameDmg,
    ";eps;":kIconImageNameEps,
    ";db;sqlite;mdb;accdb;":kIconImageNameDB,
    ";h;m;jsp;js;cpp;mm;php;json;c;xml;html;css;json;":kIconImageNameCode];


@inline(__always) func gkSafeString(dic: [AnyHashable:Any], key: String, def: String = "") -> String {
    
    var strval = def
    if let tempstr = dic[key] as? String {
        strval = tempstr
    } else {
        if let tempint = dic[key] as? Int {
            strval = "\(tempint)"
        } else if let tempint = dic[key] as? Int64 {
            strval = "\(tempint)"
        }
    }
    return strval
}

@inline(__always) func gkSafeInt(dic: [AnyHashable:Any], key: String, def: Int = 0) -> Int {
    
    var intval = def
    if let tempint = dic[key] as? Int {
        intval = tempint
    } else {
        if let tempstr = dic[key] as? String {
            if let v = Int(tempstr) {
                intval = v
            }
        }
    }
    return intval
}

@inline(__always) func gkSafeLongLong(dic: [AnyHashable:Any], key: String, def: Int64 = 0) -> Int64 {
    let o = dic[key]
    if let i = o as? Int64 {
        return i
    } else if let s = o as? String {
        if let i =  Int64(s) {
            return i
        }
    }
    return def
}

@inline(__always) func gkSafeDic(dic: [AnyHashable:Any], key: String) -> [AnyHashable:Any]? {
    return (dic[key] as? [AnyHashable:Any])
}

fileprivate let kGB: Int64 = 1024 * 1024 * 1024
fileprivate let kMB: Int64 = 1024 * 1024
fileprivate let kKB: Int64 = 1024

fileprivate let kDefaultPathDecorate = "Gokuai"


public class GYKUtility : NSObject {
        
    private enum FolderType{
        case Document
        case Cache
        case Temp
    }

    
    private static let imageExts = ";jpg;jpeg;png;gif;bmp;webp;"
    
    private static let fileIconMap = [";jpg;png":"icon_png",
                                      ";tar;":"icon_zip"];
    
    
    //MARK: --------- System ---------
    
    @nonobjc private static func appFolderPath(type: FolderType, groupID: String?, decorate: String? = kDefaultPathDecorate) -> String {
        
        var pathUrl: URL? = nil
        
        switch type {
        case .Document:
            if groupID != nil {
                pathUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID!)
            } else {
                pathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            }
        case .Cache:
            pathUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        case .Temp:
            pathUrl = URL(fileURLWithPath: NSTemporaryDirectory())
        }
        
        if pathUrl == nil {
            return ""
        }
        
        if let d = decorate {
            if !d.isEmpty {
                pathUrl?.appendPathComponent(d)
            }
        }
        
        if !FileManager.default.fileExists(atPath: pathUrl!.path) {
            do {
                try FileManager.default.createDirectory(atPath: pathUrl!.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("failed to create dir")
            }
            
        }
        
        return pathUrl!.path
    }
    
    @objc static func docPath(decorate: String? = kDefaultPathDecorate) -> String {
        return self.appFolderPath(type: .Document,groupID: nil, decorate: decorate)
    }
    
    @objc static func docPath(groupID:String?,decorate: String? = kDefaultPathDecorate) -> String {
        return self.appFolderPath(type: .Document,groupID: groupID, decorate: decorate)
    }
    
    @objc static func cachePath(decorate: String? = kDefaultPathDecorate ) -> String {
        return self.appFolderPath(type: .Cache,groupID: nil, decorate: decorate)
    }
    
    @objc static func tempPath(decorate: String? = kDefaultPathDecorate ) -> String {
        return self.appFolderPath(type: .Temp,groupID: nil, decorate: decorate)
    }
    
    
    @objc static func localeLang() -> String {
        
        let langs = Locale.preferredLanguages
        if langs.isEmpty {
            return ""
        }
        return (langs.first ?? "")
    }
    
    @objc static func iosVersion() -> String {
        let info = ProcessInfo.processInfo.operatingSystemVersion
        return "\(info.majorVersion).\(info.minorVersion).\(info.patchVersion)"
    }
    
    @objc static func iosVersionValue() -> Float {
        let info = ProcessInfo.processInfo.operatingSystemVersion
        let s = "\(info.majorVersion).\(info.minorVersion)"
        return (Float(s) ?? 0)
    }
    
    
    @objc static func isPad() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
    
    
    @objc static func screenScale() -> Double {
        let s = UIScreen.main.scale
        return Double(s.native)
    }
    
    @objc static func diskTotalSpace() -> Int64 {
        let path = NSHomeDirectory()
        if let dic = try? FileManager.default.attributesOfFileSystem(forPath: path) {
            let n = dic[FileAttributeKey.systemSize] as? NSNumber
            if n != nil {
                return n!.int64Value
            }
        }
        return 0
    }
    
    @objc static func diskFreeSpace() -> Int64 {
        let path = NSHomeDirectory()
        if let dic = try? FileManager.default.attributesOfFileSystem(forPath: path) {
            let n = dic[FileAttributeKey.systemFreeSize] as? NSNumber
            if n != nil {
                return n!.int64Value
            }
        }
        return 0
    }
    
    @objc static func appVersion() -> String {
        if let str = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            return str
        }
        return ""
    }
    
    @objc static func appBuildVersion() -> String {
        if let str = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            return str
        }
        return ""
    }
    
    @objc static func clientInfo(clientID: String) -> String {
        let brand = UIDevice.current.model
        let version = UIDevice.current.systemName+UIDevice.current.systemVersion
        let display = UIDevice.current.name
        let info = ["BRAND":brand,
                    "VERSION":version,
                    "DISPLAY":display,
                    "CLIENT_ID":clientID]
        return info.gyk_str
    }
    
    @objc static func simpleEnvInfo() -> String {
        let total = GYKUtility.diskTotalSpace()
        let free = GYKUtility.diskFreeSpace()
        return (GYKUtility.isPad() ? "iPad" : "iPhone") + " \(GYKUtility.iosVersion()), lang:\(GYKUtility.localeLang()), screen:\(GYKUtility.screenScale()), \(free)(\(GYKUtility.formatSize(size: free)))/\(total)(\(GYKUtility.formatSize(size: total))), ver:\(GYKUtility.appVersion()), build:\(GYKUtility.appBuildVersion())"
    }
    
    //MARK: --------- File ---------
    
    @objc static func fileExist(path: String) -> Bool {
        if path.isEmpty { return false }
        return FileManager.default.fileExists(atPath:path)
    }
    
    @objc static func isDir(path: String) -> Bool {
        if path.isEmpty { return false }
        var bdir: ObjCBool = false
        let bexist = FileManager.default.fileExists(atPath: path, isDirectory: &bdir)
        if bexist && bdir.boolValue {
            return true
        }
        return false
    }
    
    @objc static func createDir(path: String, replace: Bool = false) -> Bool {
        if path.isEmpty { return false }
        var bdir: ObjCBool = false
        let bexist = FileManager.default.fileExists(atPath: path, isDirectory: &bdir)
        if bexist && bdir.boolValue {
            if !replace  {
                return true
            } else {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch  {
                    print("cannot delete exist dir")
                    return false
                }
            }
        }
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return false
        }
        return true
    }
    
    @objc static func createFile(path: String, data: Data?, replace: Bool = false) -> Bool {
        if path.isEmpty { return false }
        var bdir: ObjCBool = false
        let bexist = FileManager.default.fileExists(atPath: path, isDirectory: &bdir)
        if bexist && !bdir.boolValue {
            if !replace {
                return true;
            } else {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch  {
                    print("cannot delete exist file")
                    return false
                }
            }
        }
        return FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
    
    @objc static func fileSizeByPath(_ path: String) -> UInt64 {
        guard let f = FileHandle(forReadingAtPath: path) else {
            return 0
        }
        let ret = f.seekToEndOfFile()
        f.closeFile()
        return ret
    }
    
    @objc static func deleteFile(path: String) {
        if path.isEmpty { return }
        if !self.fileExist(path: path) { return }
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch  {
            assertionFailure("delete failed")
        }
    }
    
    @objc static func getfilehash(path: String) -> String {
        let s = gkobjassist.fileHash(withPath: path)
        return s
    }
    
    @objc static func fileModifyTime(path: String) -> TimeInterval {
        if let attr = try? FileManager.default.attributesOfItem(atPath: path) {
            
            if let date = attr[FileAttributeKey.modificationDate] as? Date {
                return date.timeIntervalSince1970
            }
        }
        return 0
    }
    
    @objc static func fileCreateTime(path: String) -> TimeInterval {
        if let attr = try? FileManager.default.attributesOfItem(atPath: path) {
            
            if let date = attr[FileAttributeKey.creationDate] as? Date {
                return date.timeIntervalSince1970
            }
        }
        return 0
    }
    
    @objc static func checkFileNameInDir(_ filename: String, dir: String) -> String {
        let parent = dir.gyk_addLastSlash
        var path = parent.appending(filename)
        let ext = (filename as NSString).pathExtension
        let rawname = filename.gyk_rawFileName
        let fm = FileManager.default
        var index = 2
        while fm.fileExists(atPath: path) {
            let newname = "\(rawname)(\(index)).\(ext)"
            path = parent.appending(newname)
            index += 1
        }
        return path
    }
    
    @objc class func getIconWithFileName(_ name: String, _ dir: Bool) -> String {
        
        if dir {
            return kIconImageNameFolder
        }
        
        let ext = (name as NSString).pathExtension
        if ext.isEmpty {
            return kIconImageNameOther
        }
        
        let key = ";\(ext);"
        
        for (k,v) in FileIcons {
            if k.contains(key) {
                return v
            }
        }
        
        return kIconImageNameOther
    }
    
    @objc func clearInboxFiles() {
        
        if let pathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dir = pathUrl.path.gyk_addLastSlash + "Inbox"
            if GYKUtility.isDir(path: dir) {
                if let files = try? FileManager.default.contentsOfDirectory(atPath: dir) {
                    for fname in files {
                        let p = dir.appending(fname)
                        let _ = GYKUtility.deleteFile(path: p)
                    }
                    
                }
            }
        }
    
    }
    
    
    //MARK: --------- Json ---------
    
    @objc static func str2data(str: String) -> Data? {
        return str.data(using: .utf8)
    }
    
    @objc static func data2str(data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }
    
    @objc static func josn2obj(obj: Any) -> Any? {
        var ret: Any? = nil
        if let d = obj as? [AnyHashable:Any] {
            ret = d
        } else if let a = obj as? [Any] {
            ret = a
        } else {
            var data: Data? = nil
            if let s = obj as? Data {
                data = s
            } else if let s = obj as? String {
                data = s.data(using: .utf8)
            }
            
            if data != nil && data!.count > 0 {
                ret = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            }
        }
        return ret
    }
    
    @objc static func json2dic(obj: Any) -> [AnyHashable:Any]? {
        let ret = self.josn2obj(obj: obj)
        if ret is [AnyHashable:Any] {
            return ret as? [AnyHashable:Any]
        }
        return nil
    }
    
    @objc static func json2arr(obj: Any) -> [Any]? {
        let ret = self.josn2obj(obj: obj)
        if ret is [Any] {
            return ret as? [Any]
        }
        return nil
    }
    
    @objc static func obj2str(obj: Any) -> String? {
        if obj is String {
            return obj as? String
        } else if obj is Data {
            return String(data: (obj as! Data), encoding: .utf8)
        } else if obj is [Any] || obj is [AnyHashable:Any] {
            guard JSONSerialization.isValidJSONObject(obj) else {
                return nil
            }
            let data = try? JSONSerialization.data(withJSONObject: obj, options: JSONSerialization.WritingOptions())
            if  data != nil {
                return String(data: data!, encoding: .utf8)
            }
        }
        return nil
    }
    
    //MARK: --------- Format ---------
    
    @objc static func createUUID()->String {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let cfstr: CFString! = CFUUIDCreateString(kCFAllocatorDefault, uuid)
        let s = cfstr as String
        return s
    }
    
    @objc static func formatSize(size: Int64,precision: UInt8 = 1, compact: Bool = false) -> String {
        
        let format: String = "%.\(precision)f"
        var strvalue,sufferfix: String
        
        switch size {
        case 0..<kKB:
            sufferfix = (compact ? "B" : " B")
            strvalue = String(format: format, Double(size))
        case kKB..<kMB:
            sufferfix = (compact ? "K" : " KB")
            strvalue = String(format: format, Double(size)/Double(kKB))
        case kMB..<kGB:
            sufferfix = (compact ? "M" : " MB")
            strvalue = String(format: format, Double(size)/Double(kMB))
        default:
            sufferfix = (compact ? "G" : " GB")
            strvalue = String(format: format, Double(size)/Double(kGB))
        }
        
        return (strvalue + sufferfix)
    }
    
    
    @objc class func formatDateline(_ dateline: TimeInterval, format: String) -> String {
        let date = Date(timeIntervalSince1970: dateline)
        let formatter = DateFormatter()
        //formatter.setLocalizedDateFormatFromTemplate(format)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    @objc class func genFileNameSuffixByDate() -> String {
        return formatDateline(Date().timeIntervalSince1970, format: "_YYYY_MM_dd_HH_mm_ss")
    }
    
    @objc static func getSignFromDic(_ dic: [String: String], key: String, urlencode: Bool = true) -> String {
        let sorted = dic.sorted { g1,g2 -> Bool in
            return g1.key < g2.key
        }
        var vals = [String]()
        sorted.forEach { (item: (key: String, value: String)) in
            vals.append(item.value)
        }
        let valstr = vals.joined(separator: "\n")
        if valstr.isEmpty {
            return ""
        }
        return valstr.gyk_sign(key: key, urlencode: urlencode)
    }
    
    
    @objc static func isSupportImage(name: String) -> Bool {
        let key = ";\(name);"
        return self.imageExts.contains(key)
    }
    
}


public class gklock : NSObject {
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    public func lock() {
        let _ = self.semaphore.wait(timeout: .distantFuture)
    }
    
    public func unlock() {
        self.semaphore.signal()
    }
}

