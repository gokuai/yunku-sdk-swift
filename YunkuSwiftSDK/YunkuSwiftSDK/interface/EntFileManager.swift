//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

@objc public class EntFileManager: NSObject {

    private var httpEngine: GYKHttpEngine!
    
    var taskLock = gklock()
    var tasks = [YKUploadTask]()
    let taskQueue = OperationQueue()
    
    @objc public init(clientID: String, clientSecret: String) {
        self.httpEngine = GYKHttpEngine(clientID: clientID, clientSecret: clientSecret, errorLog: nil)
    }

    //MARK:获取文件列表
    @objc public func getFileList(fullPath: String,
                                  start: Int,
                                  size: Int) -> GYKResponse {
        return self.httpEngine.fetchFileList(fullpath: fullPath.haihangfullPathUpload, dir: 0, hashs: nil, start: start, size: size)
    }

    //MARK:获取更新列表
    @objc public func getUpdateList(isCompare: Bool = false,
                            fetchDateline: Int64 = 0) -> GYKResponse {
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
        return self.httpEngine.fetchFileInfo(fullPath: fullPath.haihangfullPathUpload, pathHash: nil)
    }

    //MARK:创建文件夹
    @objc public func createFolder(fullPath: String,
                           opName: String) -> GYKResponse {
        return self.httpEngine.createFolder(fullPath: fullPath.haihangfullPathUpload, op_id: nil, op_name: opName)
    }

    //MARK:将文件数据上传至
    @objc public func uploadFile(fullPath: String, overwrite: Bool, opName: String, data: Data) -> GYKResponse {
        let res = self.httpEngine.uploadFile(fullpath: fullPath.haihangfullPathUpload, op_id: nil, op_name: opName, overwrite: overwrite, data: data)
        return res
    }

    //MARK: 删除文件
    ///tag: 通过标签删除, 多个使用分号;分隔, fullpath和tag只需传其中一个
    ///path: 路径, 当使用tag方式删除时, 可以指定路径进行删除, 默认空, 不指定
    ///op_name: 创建人名称, 如果指定了op_id, 就不需要op_name
    ///destroy: 1彻底删除文件, 不进回收站, 默认0删除文件进入回收站
    @objc public func del(fullpath: String?,
                           tag: String?,
                           path: String?,
                           op_id: String?,
                           op_name: String?,
                           destroy: Bool = false) -> GYKResponse {
        return self.httpEngine.deleteFiles(fullpath:fullpath?.haihangfullPathUpload, tag:tag, path:path, op_id:op_id, op_name:op_name, destroy: destroy)
    }
    
    //MARK: 复制文件(高级)
    @objc public func copy(sourcePaths: [String], targetFullpaths: [String], copy_all: Bool, op_id: String?,op_name: String?) -> GYKResponse {
        var sources = [String]()
        for p in sourcePaths {
            let strpath = p.haihangfullPathUpload
            sources.append(strpath)
        }
        var dests = [String]()
        for p in targetFullpaths {
            let strpath = p.haihangfullPathUpload
            dests.append(strpath)
        }
        return self.httpEngine.copyFilesEx(sourcePaths: sources.joined(separator: "|"), targetFullpaths: dests.joined(separator: "|"), copy_all: copy_all, op_id: op_id, op_name: op_name)
    }
    
    //MARK: 分享文件
    @objc public func share(sourcePaths: [String], userids: [String]) -> GYKResponse {
        var sources = [String]()
        for p in sourcePaths {
            let strpath = p.haihangfullPathUpload
            sources.append(strpath)
        }
        var dests = [String]()
        for uid in userids {
            let path = "/\(uid)/huiyijiyao/"
            dests.append(path)
        }
        return self.httpEngine.copyFilesEx(sourcePaths: sources.joined(separator: "|"), targetFullpaths: dests.joined(separator: "|"), copy_all: true, op_id: nil, op_name: nil)
    }
    
    //MARK: 取消分享
    @objc public func deleteShare(userid: String, guid: String) -> GYKResponse {
        let path = "\(userid)/huiyijiyao/"
        return self.httpEngine.deleteFiles(fullpath: nil, tag: guid, path: path, op_id: nil, op_name: nil)
    }

    //MARK: 移动文件
    @objc public func move(fullpath: String, dest_fullpath: String, op_id: String?,op_name: String?) -> GYKResponse {
        return self.httpEngine.moveFiles(fullpath:fullpath.haihangfullPathUpload, dest_fullpath:dest_fullpath.haihangfullPathUpload, op_id:op_id, op_name:op_name)
    }
    
    //MARK: 获取文件下载链接
    @objc public func getFileDownloadUrl(fullPath:String) -> GYKResponse {
        return self.httpEngine.getFileDownloadUrl(fullPath: fullPath, pathHash: nil, fileHash: nil, fileName: nil)
    }
    
    //MARK: 获取文件预览地址
    @objc public func getFilePreviewUrl(fullPath:String, watermark: Bool, member_name: String?) -> GYKResponse {
        return self.httpEngine.getFilePreviewUrl(fullPath: fullPath, pathHash: nil, watermark: watermark, member_name: member_name)
    }

    //MARK:获取文件链接
    @objc public func link(fullPath: String,
                   deadline: Int64,
                   authType: AuthType,
                   password: String?) -> GYKResponse {
        return self.httpEngine.getFileLink(fullpath: fullPath.haihangfullPathUpload, deadline: deadline, auth: authType.description, password: password)
    }

    //MARK:获取当前库所有外链
    @objc public func links(fileOnly: Bool) -> GYKResponse {
        return self.httpEngine.getFileLinks(onlyFile:fileOnly)
    }

    
    //MARK:通过链接上传文件
    @objc public func createFileByUrl(fullPath: String, opId: String?, opName: String?, overwrite: Bool, fileUrl: String) -> GYKResponse {
        return self.httpEngine.createFileByURL(fullpath: fullPath.haihangfullPathUpload, op_id: opId, op_name: opName, overwrite: overwrite, url: fileUrl)
    }
    
    //MARK: 添加标签
    @objc public func addFileTag(fullpath: String, tag: String) -> GYKResponse  {
        return self.httpEngine.addFileTag(fullpath:fullpath.haihangfullPathUpload, tag:tag)
    }
    
    //MARK: 删除标签
    @objc public func delFileTag(fullpath: String, tag: String) -> GYKResponse  {
        return self.httpEngine.delFileTag(fullpath:fullpath.haihangfullPathUpload, tag: tag)
    }
    
    //MARK: 获取回收站文件
    @objc public func getRecycleFiles(start: Int, size: Int) -> GYKResponse {
        return self.httpEngine.getRecycleFiles(start:start, size:size)
    }
    
    //MARK: 恢复删除的文件
    @objc public func recoverFiles(fullpaths: String, op_id: String?,op_name: String?) -> GYKResponse {
        return self.httpEngine.recoverFiles(fullpaths:fullpaths, op_id:op_id, op_name:op_name)
    }
    
    //MARK: 搜索文件
    @objc public func searchFile(keywords: String, path: String?, scope: String?, start: Int, size: Int) -> GYKResponse {
        return self.httpEngine.searchFile(keywords:keywords, path:path, scope:scope, start: start, size: size)
    }

    //MARK:获取上传地址
    @objc public func getUploadServers() -> GYKResponse {
        return self.httpEngine.getUploadServers()
    }

    @objc public func uploadByBlock(fullpath:String, localpath:String, overwrite:Bool, opID: String?, opName: String?) {
        
        self.checkFinished()
        
        let uploadItem  = YKUploadItemData()
        let nid = UserDefaults.standard.integer(forKey: "gokuaiUploadIndex") + 1
        UserDefaults.standard.set(nid, forKey: "gokuaiUploadIndex")
        UserDefaults.standard.synchronize()
        uploadItem.nID = nid
        uploadItem.webpath = fullpath.haihangfullPathUpload
        uploadItem.filename = fullpath.gyk_fileName
        uploadItem.parent = fullpath.gyk_parentPath
        uploadItem.localpath = localpath
        uploadItem.opID = opID
        uploadItem.opName = opName
        uploadItem.status = .Normal
        uploadItem.overwrite = overwrite
        
        if uploadItem.nID >= 0 {
            let task = YKUploadTask(uploadItem: uploadItem)
            task.httpEngine = self.httpEngine
            taskLock.lock()
            tasks.append(task)
            taskQueue.addOperation(task)
            taskLock.unlock()
        }
    }
    
    func deleteTask(id:Int) {
        taskLock.lock()
        for i in 0..<tasks.count {
            let task = self.tasks[i]
            if task.pItem.nID == id {
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
    
    func deleteAll() {
        
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
}
