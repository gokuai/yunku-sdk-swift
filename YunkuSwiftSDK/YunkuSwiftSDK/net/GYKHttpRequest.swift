//
//  GKHttpBaseSession.swift
//  gknet
//
//  Created by wqc on 2017/7/25.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

public typealias GYKRequestID = Int64
public typealias GYKRequestCallback = (GYKResponse)->Void
public typealias GYKRequestLogger = (GYKResponse)->Void

fileprivate let kGET = "GET"
fileprivate let kPOST = "POST"
fileprivate let kPUT = "PUT"

class GYKHttpTaskWrap {
    weak var session: GYKHttpRequest?
    var taskid: GYKRequestID = 0
    var responseData: GYKResponse
    let completion: GYKRequestCallback?
    let sync: Bool
    private var semaphore: DispatchSemaphore?
    
    required init(session: GYKHttpRequest, reqType: GYKResponse.Type?, sync: Bool, completion: GYKRequestCallback? ) {
        self.session = session
        self.sync = sync
        self.completion = completion
        let theType = reqType ?? GYKResponse.self
        self.responseData = GYKResponse.create(theType)
        if sync {
            self.semaphore = DispatchSemaphore.init(value: 0)
        }
    }
    
    func wait() {
        let _ = self.semaphore?.wait(timeout: .distantFuture)
    }
    
    func resume() {
        let _ = self.semaphore?.signal()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let localError = error {
            responseData.statuscode = 1
            let ne = error as NSError?
            if ne != nil {
                responseData.statuscode = ne!.code
            }
            responseData.errcode = responseData.statuscode
            responseData.errmsg = localError.localizedDescription
        } else {
            
            if let res = responseData.response {
                responseData.statuscode = res.statusCode
                if res.statusCode != 200 {
                    responseData.parseError()
                } else {
                    self.responseData.parse()
                }
            } else {
                responseData.statuscode = 1
                responseData.parseError()
            }
        }
        
        if responseData.statuscode != 200 {
            responseData.url = (task.currentRequest?.url?.absoluteString) ?? ""
            self.session?.errorLog?(responseData)
            if self.session?.errorLog == nil {
                print(responseData.errorLogInfo)
            }
        }
        
        if sync {
            self.resume()
        } else {
            completion?(self.responseData)
        }
    }
    
}

class GYKHttpRequest : NSObject,URLSessionDelegate,URLSessionDataDelegate {
    
    private lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: self.queue)
    }()
    private var queue: OperationQueue
    private let name: String?
    private var map: [String:Any]
    private let mapLock = gklock()
    private let timeout: Double
    
    var errorLog: GYKRequestLogger? = nil
    
    init(_ name: String? = nil, timeout: Double = 30.0) {
        self.name = name
        self.timeout = timeout
        self.queue = OperationQueue()
        self.map = [String:Any]()
        super.init()
    }
    
    func applyDefaultHeaders(req: URLRequest?) {
        if req == nil { return }
    }
    
    private func reqForMethod(url: String, method: String, headers: [String:String]?, params: [String:String]?,data: Data? = nil, reqType: GYKResponse.Type?) -> AnyObject {
        
        var formaturl = url
        
        var query: String = ""
        if let p = params {
            query = p.gyk_query()
        }
        
        if !query.isEmpty {
            if method == kGET {
                formaturl = "\(url)?\(query)"
            }
        }
        
        let u = URL(string:formaturl)
        if u == nil {
            
            var ret = GYKResponse()
            if reqType != nil {
                ret = GYKResponse.create(reqType!)
            }
            ret.errmsg = "invalid url"
            ret.errcode = 1
            ret.statuscode = 1
            ret.url = url
            self.errorLog?(ret)
            return ret
        } else {
            var req = URLRequest(url: u!)
            req.httpMethod = method
            req.timeoutInterval = self.timeout
            req.cachePolicy = .reloadIgnoringLocalCacheData
            req.httpShouldHandleCookies = false
            
            if !query.isEmpty {
                if method == kPOST || method == kPUT {
                    req.httpBody = query.data(using: .utf8)
                }
            }
            
            self.applyDefaultHeaders(req: req)
            
            if let h = headers {
                for (k,v) in h {
                    req.allHTTPHeaderFields?.updateValue(v, forKey: k)
                }
            }
            
            if data != nil {
                req.httpBody = data
            }
            
            return req as AnyObject;
        }
        
    }
    
    func taskWithRequest(req: URLRequest, reqType: GYKResponse.Type?, sync: Bool, completion: GYKRequestCallback?) -> GYKHttpTaskWrap {
        
        let task = self.session.dataTask(with: req)
        let proxy = GYKHttpTaskWrap(session: self, reqType: reqType, sync: sync, completion: completion)
        proxy.taskid = GYKRequestID(task.taskIdentifier)
        self.mapLock.lock()
        self.map["\(proxy.taskid)"] = proxy
        self.mapLock.unlock()
        task.resume()
        return proxy
    }
    
    
    func Fetch(method: String, url: String, headers: [String:String]?, param: [String:String]?, data: Data? = nil, reqType: GYKResponse.Type?) -> GYKResponse {
        
        let ret = reqForMethod(url: url, method: method, headers: headers, params: param, data:data, reqType: reqType)
        if ret is GYKResponse {
            
            let reqret = ret as! GYKResponse
            return reqret
            
        } else {
            
            let req = ret as! URLRequest
            let proxy = taskWithRequest(req: req, reqType: reqType, sync: true, completion: nil)
            
            proxy.wait()
            
            return proxy.responseData
        }
    }
    
    private func Fetch(method: String, url: String, headers: [String:String]?, param: [String:String]?, data: Data? = nil, completion: GYKRequestCallback?, reqType: GYKResponse.Type?) -> GYKRequestID {
        
        let ret = reqForMethod(url: url, method: kGET, headers: headers, params: param, data: data, reqType: reqType)
        if ret is GYKResponse {
            let reqret = ret as! GYKResponse
            completion?(reqret)
            return 0
        } else {
            let req = ret as! URLRequest
            let proxy = taskWithRequest(req: req, reqType: reqType, sync: false, completion: completion)
            
            return proxy.taskid
        }
        
    }
    
    
    func GET(url: String, headers: [String:String]?, param: [String:String]?, reqType: GYKResponse.Type?) -> GYKResponse {
        
        return Fetch(method: kGET, url: url, headers: headers, param: param, reqType: reqType)
    }
    
    func GET(url: String, headers: [String:String]?, param: [String:String]?, completion: GYKRequestCallback?, reqType: GYKResponse.Type?) -> GYKRequestID {
        
        return Fetch(method: kGET, url: url, headers: headers, param: param, completion: completion, reqType: reqType)
        
    }
    
    func POST(url: String, headers: [String:String]?, param: [String:String]?,reqType: GYKResponse.Type?) -> GYKResponse {
        
        return Fetch(method: kPOST, url: url, headers: headers, param: param, reqType: reqType)
    }
    
    func POST(url: String, headers: [String:String]?, param: [String:String]?, data: Data, reqType: GYKResponse.Type?) -> GYKResponse {
        
        return Fetch(method: kPOST, url: url, headers: headers, param: param, data: data, reqType: reqType)
    }
    
    func POST(url: String, headers: [String:String]?, param: [String:String]?, completion: GYKRequestCallback?, reqType: GYKResponse.Type?) -> GYKRequestID {
        
        return Fetch(method: kPOST, url: url, headers: headers, param: param, completion: completion, reqType: reqType)
    }
    
    
    func PUT(url: String, headers: [String:String]?, param: [String:String]?, data: Data? = nil ,reqType: GYKResponse.Type?) -> GYKResponse {
        
        return Fetch(method: kPUT, url: url, headers: headers, param: param, data: data, reqType: reqType)
    }
    
    func PUT(url: String, headers: [String:String]?, param: [String:String]?,data: Data? = nil, completion: GYKRequestCallback?, reqType: GYKResponse.Type?) -> GYKRequestID {
        
        return Fetch(method: kPUT, url: url, headers: headers, param: param, data: data, completion: completion, reqType: reqType)
    }
    
    
    func cancelTask(_ taskID: GYKRequestID) {
        if #available(iOS 9.0, *) {
            self.session.getAllTasks { (tasks: [URLSessionTask]) in
                for task in tasks {
                    if Int64(task.taskIdentifier) == taskID {
                        task.cancel()
                        break
                    }
                }
            }
        } else {
            self.session.getTasksWithCompletionHandler({ (dataTasks:[URLSessionDataTask], uploadTasks:[URLSessionUploadTask], downloadTasks: [URLSessionDownloadTask]) in
                for task in dataTasks {
                    if Int64(task.taskIdentifier) == taskID {
                        task.cancel()
                        break
                    }
                }
            })
        }
    }
    
    func cancelAll() {
        if #available(iOS 9.0, *) {
            self.session.getAllTasks(completionHandler: { (tasks: [URLSessionTask]) in
                for task in tasks {
                    task.cancel()
                }
            })
        } else {
            self.session.getTasksWithCompletionHandler({ (dataTasks:[URLSessionDataTask], uploadTasks:[URLSessionUploadTask], downloadTasks: [URLSessionDownloadTask]) in
                for task in dataTasks {
                    task.cancel()
                }
            })
        }
    }
    
    
    //MARK: 
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.mapLock.lock()
        if let proxy = self.map["\(task.taskIdentifier)"] as? GYKHttpTaskWrap {
            proxy.urlSession(session, task: task, didCompleteWithError: error)
        }
        self.map.removeValue(forKey: "\(task.taskIdentifier)")
        self.mapLock.unlock()
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.mapLock.lock()
        if let proxy = self.map["\(dataTask.taskIdentifier)"] as? GYKHttpTaskWrap {
            proxy.responseData.response = response as? HTTPURLResponse
        }
        self.mapLock.unlock()
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        self.mapLock.lock()
        if let proxy = self.map["\(dataTask.taskIdentifier)"] as? GYKHttpTaskWrap {
            proxy.responseData.data?.append(data)
        }
        self.mapLock.unlock()
    }
    
}
