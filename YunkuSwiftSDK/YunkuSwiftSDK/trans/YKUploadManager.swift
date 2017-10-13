//
//  YKUploadManager.swift
//  YunkuSDK
//
//  Created by wqc on 2017/8/22.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation
import gkutility

public class UploadManager : NSObject {
    
    struct TaskAddItem {
        var mount_id = 0
        var webpath = ""
        var localpath = ""
        var override = false
        var expand: YKTransExpand = .None
    }
    
    var taskLock = gklock()
    var tasks = [YKUploadTask]()
    let taskQueue = OperationQueue()
    var maxConcurrence = 5
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "gksw.test.back")
        let s = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        return s
    }()
    
    
    override init() {
        self.taskQueue.maxConcurrentOperationCount = maxConcurrence
        super.init()
    }
    
    
    func addTask(fullpath:Int, webpath:String,localpath:String, overwrite:Bool = false,expand: YKTransExpand = .None) -> YKUploadItemData {
        
        self.checkFinished()

        let uploadItem = YKTransfer.shanreInstance.transDB!.addUpload(mountid: mountid, webpath: webpath, localpath: localpath, overwrite: overwrite, expand: expand)
        if uploadItem.nID >= 0 {
            let task = YKUploadTask(uploadItem: uploadItem)
            taskLock.lock()
            tasks.append(task)
            taskQueue.addOperation(task)
            taskLock.unlock()
        }
        return uploadItem
    }
    
    
    func addTasks(_ tasks:[TaskAddItem]) -> [YKUploadItemData] {
        
        self.checkFinished()
        
        var result = [YKUploadItemData]()
        taskLock.lock()
        for item in tasks {
            let uploadItem = YKTransfer.shanreInstance.transDB!.addUpload(mountid: item.mount_id, webpath: item.webpath, localpath: item.localpath, overwrite: item.override, expand: item.expand)
            if uploadItem.nID >= 0 {
                let task = YKUploadTask(uploadItem: uploadItem)
                self.tasks.append(task)
                taskQueue.addOperation(task)
                result.append(uploadItem)
            }
        }
        taskLock.unlock()
        return result
    }
    
    func stopTask(id:Int) {
        taskLock.lock()
        for i in 0..<self.tasks.count {
            let task = self.tasks[i]
            if task.pItem.nID == id {
                task.cancel()
                if task.pItem.status == .Start {
                    task.stop()
                } else if task.pItem.status == .Normal {
                    task.stophandle(false)
                }
                self.tasks.remove(at: i)
                break
            }
        }
        taskLock.unlock()
    }
    
    func resumeTask(id:Int) {
        taskLock.lock()
        if let uploadItem = YKTransfer.shanreInstance.transDB?.getUploadItemBy(id: id) {
            YKTransfer.shanreInstance.transDB?.updateUploadStatus(taskID: id, status: .Normal, offset: nil)
            let task = YKUploadTask(uploadItem: uploadItem)
            self.tasks.append(task)
            taskQueue.addOperation(task)
        }
        taskLock.unlock()
    }
    
    func deleteTask(id:Int) {
        taskLock.lock()
        var bhave = false
        for i in 0..<tasks.count {
            let task = self.tasks[i]
            if task.pItem.nID == id {
                bhave = true
                task.cancel()
                if task.pItem.status == .Start {
                    task.delete()
                } else {
                    task.stophandle(true)
                }
                self.tasks.remove(at: i)
                break
            }
        }
        taskLock.unlock()
        
        if !bhave {
            if let uploaditem = YKTransfer.shanreInstance.transDB?.getUploadItemBy(id: id) {
                YKTransfer.shanreInstance.transDB?.deleteUpload(taskID: uploaditem.nID)
                uploaditem.status = .Removed
                gkutility.deleteFile(path: uploaditem.localpath)
                YKEventNotify.notify(uploaditem, type: .uploadFile)
            }
        }
    }
    
    func stopAll() {
        
        taskLock.lock()
        taskQueue.cancelAllOperations()
        YKTransfer.shanreInstance.transDB?.updateUploadsToStop()
        for t in tasks {
            if t.pItem.status == .Start {
                t.stop()
            }
        }
        self.tasks.removeAll()
        taskLock.unlock()
        
    }
    
    func resumeAll() {
        
        if let stoptasks = YKTransfer.shanreInstance.transDB?.getStopUploads() {
            taskLock.lock()
            for uploadItem in stoptasks {
                let task = YKUploadTask(uploadItem: uploadItem)
                self.tasks.append(task)
                taskQueue.addOperation(task)
            }
            taskLock.unlock()
        }
    }
    
    
    func deleteAll() {
        
        taskLock.lock()
        taskQueue.cancelAllOperations()
        YKTransfer.shanreInstance.transDB?.updateUploadsToStop()
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
                self.tasks.gkRemove(at: removes)
            }
            self.taskLock.unlock()
            
        }
    }

    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        
    }
    
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        
//    }
    

}
