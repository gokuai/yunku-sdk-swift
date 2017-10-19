//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

@objc public class EntFileManager: NSObject {
    
    private func fullUploadPath(path: String) -> String {
        var parent = GYKConfigHelper.shanreConfig.upload_root_path
        if !parent.isEmpty {
            parent = parent.gyk_addLastSlash
        }
        return parent + path
    }

    public var httpEngine: GYKHttpEngine!
    
    var taskLock = gklock()
    var tasks = [YKUploadTask]()
    let taskQueue = OperationQueue()
    
    @objc public init(clientID: String, clientSecret: String) {
        self.httpEngine = GYKHttpEngine(host: GYKConfigHelper.shanreConfig.api_host, clientID: clientID, clientSecret: clientSecret, errorLog: nil)
    }

    //MARK:获取文件列表
    @objc public func getFileList(fullPath: String, start: Int, size: Int, order: String?) -> GYKResponse {
        return self.httpEngine.fetchFileList(fullpath: fullPath, dir: 0, hashs: nil, start: start, size: size, order: order)
    }

    //MARK:获取更新列表
    @objc public func getUpdateList(isCompare: Bool = false, fetchDateline: Int64 = 0) -> GYKResponse {
        var mode: String?
        if isCompare {
            mode = "compare"
        }
        return self.httpEngine.getFileUpdates(mode: mode, fetch_dateline: fetchDateline, dir: nil)
    }
    
    //MARK:文件更新数量
    @objc public func getUpdateCounts(beginDateline: Int64, endDateline: Int64, showDelete: Bool) -> GYKResponse {
        return self.httpEngine.getFileUpdateCount(begin_dateline: beginDateline, end_dateline: endDateline, showDelete: showDelete)
    }

    //MARK:获取文件信息
    @objc public func getFileInfo(fullPath: String) -> GYKResponse {
        return self.httpEngine.fetchFileInfo(fullPath: fullPath, pathHash: nil)
    }

    //MARK:创建文件夹
    @objc public func createFolder(fullPath: String,userID: String, userName: String) -> GYKResponse {
        let ret = self.httpEngine.createFolder(fullPath: fullPath, op_id: nil, op_name: userName)
        return ret
    }

    //MARK: 复制文件
    @objc public func copyFiles(sourcePaths: String, targetFullpaths: String, copy_all: Bool, op_id: String?,op_name: String?) -> GYKResponse {
        return self.httpEngine.copyFilesEx(sourcePaths:sourcePaths, targetFullpaths:targetFullpaths, copy_all:copy_all, op_id:op_id, op_name:op_name )
    }

    //MARK: 移动文件
    @objc public func moveFile(fullpath: String, dest_fullpath: String) -> GYKResponse {
        return self.httpEngine.moveFiles(fullpath:fullpath, dest_fullpath:dest_fullpath, op_id:nil, op_name:nil)
    }
    
    //MARK: 删除文件
    @objc public func deleteFiles(fullpath: String?,
                            tag: String?,
                            path: String?,
                            op_id: String?,
                            op_name: String?,
                            destroy: Bool = false) -> GYKResponse {
        return self.httpEngine.deleteFiles(fullpath:fullpath, tag:tag, path:path, op_id:op_id, op_name:op_name, destroy:destroy)
    }
    
    //MARK: 获取文件下载链接
    @objc public func getFileDownloadUrl(fullPath:String) -> GYKResponse {
        return self.httpEngine.getFileDownloadUrl(fullPath: fullPath, pathHash: nil, fileHash: nil, fileName: nil)
    }
    
    //MARK: 获取文件预览地址
    @objc public func getFilePreviewUrl(fullPath:String, watermark: Bool, member_name: String?) -> GYKResponse {
        return self.httpEngine.getFilePreviewUrl(fullPath: fullPath, pathHash: nil, watermark: watermark, member_name: member_name)
    }

    //MARK:获取文件外链
    @objc public func link(fullPath: String, deadline: Int64, authType: AuthType, password: String?) -> GYKResponse {
        return self.httpEngine.getFileLink(fullpath: fullPath, deadline: deadline, auth: authType.description, password: password)
    }

    //MARK:获取当前库所有外链
    @objc public func links(fileOnly: Bool) -> GYKResponse {
        return self.httpEngine.getFileLinks(onlyFile:fileOnly)
    }
    
    //MARK: 添加标签
    @objc public func addFileTag(fullpath: String, tag: String) -> GYKResponse  {
        return self.httpEngine.addFileTag(fullpath:fullpath, tag:tag)
    }
    
    //MARK: 删除标签
    @objc public func delFileTag(fullpath: String, tag: String) -> GYKResponse  {
        return self.httpEngine.delFileTag(fullpath:fullpath, tag: tag)
    }
    
    //MARK: 获取回收站文件
    @objc public func getRecycleFiles(start: Int, size: Int) -> GYKResponse {
        return self.httpEngine.getRecycleFiles(start:start, size:size)
    }
    
    //MARK: 恢复删除的文件
    @objc public func recoverFiles(fullpaths: String) -> GYKResponse {
        return self.httpEngine.recoverFiles(fullpaths:fullpaths, op_id:nil, op_name:nil)
    }
    
    //MARK: 搜索文件
    @objc public func searchFile(keywords: String, path: String?, scope: String?, start: Int, size: Int) -> GYKResponse {
        return self.httpEngine.searchFile(keywords:keywords, path:path, scope:scope, start: start, size: size)
    }

    //MARK:获取上传地址
    @objc public func getUploadServers() -> GYKResponse {
        return self.httpEngine.getUploadServers()
    }
    
    //MARK:将文件数据上传至
    @objc public func uploadFile(fullPath: String, data: Data, opID: String?, opName: String?, overwrite: Bool) -> GYKResponse {
        let res = self.httpEngine.uploadFile(fullpath: self.fullUploadPath(path: fullPath) , op_id: opID, op_name: opName, overwrite: overwrite, data: data)
        
        return res
    }
    
    //MARK:通过链接上传文件
    @objc public func uploadFileByUrl(fullPath: String, opID: String?, opName: String?, overwrite: Bool, fileUrl: String) -> GYKResponse {
        let ret = self.httpEngine.createFileByURL(fullpath: self.fullUploadPath(path: fullPath), op_id: opID, op_name: opName, overwrite: overwrite, url: fileUrl)
        return ret
    }

    //MARK: 分块上传
    @objc public func uploadChunk(fullpath:String, localpath:String, overwrite:Bool, opID: String?, opName: String?, tags: String? = nil) {
        
        self.checkFinished()
        
        let uploadItem  = YKUploadItemData()
        let nid = UserDefaults.standard.integer(forKey: "gokuaiUploadIndex") + 1
        UserDefaults.standard.set(nid, forKey: "gokuaiUploadIndex")
        UserDefaults.standard.synchronize()
        uploadItem.nID = nid
        uploadItem.webpath = self.fullUploadPath(path: fullpath)
        uploadItem.filename = fullpath.gyk_fileName
        uploadItem.parent = fullpath.gyk_parentPath
        uploadItem.localpath = localpath
        uploadItem.opID = opID
        uploadItem.opName = opName
        uploadItem.status = .Normal
        uploadItem.overwrite = overwrite
        uploadItem.tags = tags
        
        if uploadItem.nID >= 0 {
            let task = YKUploadTask(uploadItem: uploadItem)
            task.httpEngine = self.httpEngine
            taskLock.lock()
            tasks.append(task)
            taskQueue.addOperation(task)
            taskLock.unlock()
        }
    }
    
    @objc public func deleteTaskByID(_ taskID:Int) {
        taskLock.lock()
        for i in 0..<tasks.count {
            let task = self.tasks[i]
            if task.pItem.nID == taskID {
                task.cancel()
                if task.pItem.status == .Start {
                    task.delete()
                } else {
                    task.stophandle(true)
                }
                self.tasks.remove(at: i)
                YKEventNotify.notify(task.pItem, type: .uploadFile)
                break
            }
        }
        taskLock.unlock()
    }
    
    @objc public func deleteAllTask() {
        
        taskLock.lock()
        taskQueue.cancelAllOperations()
        for t in tasks {
            if t.pItem.status == .Finish {
                continue
            }
            if t.pItem.status == .Start {
                t.delete()
            } else {
                t.stophandle(true)
            }
        }
        self.tasks.removeAll()
        taskLock.unlock()
        
    }
    
    func checkFinished() {
        
        if !tasks.isEmpty {
            self.taskLock.lock()
            var removes = [Int]()
            for index in 0..<tasks.count {
                let task = tasks[index]
                if task.pItem.status == .Finish {
                    removes.append(index)
                }
            }
            if !removes.isEmpty {
                self.tasks.gyk_remove(at: removes)
            }
            self.taskLock.unlock()
            
        }
    }
    
    
    //MARK: 海航
    func hnafullpath(userID: String, path: String) -> String {
        return "\(userID)/huiyijiyao/" + path
    }
    
    //MARK: 分享文件(支持批量)
    @objc public func share(userids: [String], paths: [String]) -> GYKResponse {
        var sources = [String]()
        for p in paths {
            let strpath = p
            sources.append(strpath)
        }
        
        var dests = [String]()
        for uid in userids {
            let path = self.hnafullpath(userID: uid, path: "")
            dests.append(path)
            let _ = self.httpEngine.createFolder(fullPath: path, op_id: nil, op_name: nil)
        }
        return self.httpEngine.copyFilesEx(sourcePaths: sources.joined(separator: "|"), targetFullpaths: dests.joined(separator: "|"), copy_all: true, op_id: nil, op_name: nil, sp: "share")
    }
    
    //MARK: 取消分享给某个成员
    @objc public func deleteShare(userID: String, guids: [String], opName: String?) -> GYKResponse {
        
        return self.httpEngine.deleteFiles(fullpath:nil, tag:guids.joined(separator: ";"), path:self.hnafullpath(userID: userID, path: ""), op_id:nil, op_name:opName, destroy: true)
    }
    
    //MARK: 创建者删除
    @objc public func delteSelfFile(guids: [String], opName: String?) -> GYKResponse {
        
        return self.httpEngine.deleteFiles(fullpath:nil, tag:guids.joined(separator: ";"), path:nil, op_id:nil, op_name:opName, destroy: true)
    }
    
    
    //MARK: 获取共享成员列表
    @objc public func getSharedUsers(guid: String, start: Int, size: Int) -> GYKResponse {
        let ret = self.httpEngine.searchFile(keywords: guid, path: nil, scope: "[\"tag\"]", start: start, size: size)
        var userIDs = [String]()
        if ret.statuscode == 200 {
            if let dic = GYKUtility.josn2obj(obj: ret.data as Any) as? [String:AnyHashable] {
                if let list = dic["list"] as? Array<Any> {
                    for item in list {
                        if let d = item as? Dictionary<AnyHashable,Any> {
                            let fullpath = gkSafeString(dic: d, key: "fullpath") as NSString
                            let r = fullpath.range(of: "/")
                            if r.location != NSNotFound {
                                let userid = fullpath.substring(to: r.location)
                                if !userid.isEmpty {
                                    if !userIDs.contains(userid) {
                                        userIDs.append(userid)
                                    }
                                }
                            }
                        }
                    }
                    if let tempstr = GYKUtility.obj2str(obj: userIDs) {
                        ret.data = GYKUtility.str2data(str: tempstr)
                    }
                }
            }
        }
        return ret
    }
    
    //MARK:将文件数据上传至
    @objc public func uploadFile(fullPath: String, data: Data, userID: String, userName: String, overwrite: Bool) -> GYKResponse {
        let res = self.uploadFile(fullPath: fullPath, data: data, opID: nil, opName: userName, overwrite: overwrite)
        
        if res.statuscode == 200 {
            let tag1 = GYKUtility.createUUID()
            let tag2 = userID
            let _ = self.httpEngine.addFileTag(fullpath: self.hnafullpath(userID: userID, path: fullPath), tag:"\(tag1);\(tag2)")
        }
        
        return res
    }
    
    //MARK: 分块上传
    @objc public func uploadByBlock(fullpath:String, localpath:String, overwrite:Bool, userID: String, userName: String) {
        let tag1 = GYKUtility.createUUID()
        let tag2 = userID
        self.uploadChunk(fullpath: fullpath, localpath: localpath, overwrite: overwrite, opID: nil, opName: userName, tags: "\(tag1);\(tag2)")
    }
    
}
