//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

open class EntFileManager: SignAbility {

    let uploadLimitSize = 52428800
    var urlApiFilelist = ""
    var urlApiUpdateList = ""
    var urlApiFileInfo = ""
    var urlApiCreateFolder = ""
    var urlApiCreateFile = ""
    var urlApiDelFile = ""
    var urlApiMoveFile = ""
    var urlApiLinkFile = ""
    var urlApiSendmsg = ""
    var urlApiGetLink = ""
    var urlApiUpdateCount = ""
    var urlApiGetServerSite = ""
    var urlApiCreateFileByUrl = ""
    var urlApiUploadSevers = ""

    var _orgClientId = ""
    let queue = DispatchQueue(label: "YunkuSwiftSDKQueue", attributes: [])

    public init(orgClientId: String, orgClientSecret: String) {
        super.init()
        _orgClientId = orgClientId
        _clientSecret = orgClientSecret
        
        urlApiFilelist = HostConfig.libHost + "/1/file/ls"
        urlApiUpdateList = HostConfig.libHost + "/1/file/updates"
        urlApiFileInfo = HostConfig.libHost + "/1/file/info"
        urlApiCreateFolder = HostConfig.libHost + "/1/file/create_folder"
        urlApiCreateFile = HostConfig.libHost + "/1/file/create_file"
        urlApiDelFile = HostConfig.libHost + "/1/file/del"
        urlApiMoveFile = HostConfig.libHost + "/1/file/move"
        urlApiLinkFile = HostConfig.libHost + "/1/file/link"
        urlApiSendmsg = HostConfig.libHost + "/1/file/sendmsg"
        urlApiGetLink = HostConfig.libHost + "/1/file/links"
        urlApiUpdateCount = HostConfig.libHost + "/1/file/updates_count"
        urlApiGetServerSite = HostConfig.libHost + "/1/file/servers"
        urlApiCreateFileByUrl = HostConfig.libHost + "/1/file/create_file_by_url"
        urlApiUploadSevers = HostConfig.libHost + "/1/file/upload_servers"
    }

    //MARK:获取文件列表
    open func getFileList(_ start: Int, fullPath: String) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiFilelist
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["start"] = String(start)
        params["fullpath"] = fullPath
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取更新列表
    open func getUpdateList(_ isCompare: Bool, fetchDateline: Int) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiUpdateCount
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        if isCompare {
            params["mode"] = "compare"
        }
        params["fetch_dateline"] = String(fetchDateline)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取文件信息
    open func getFileInfo(_ fullPath: String, type: NetType) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiFileInfo
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["fullpath"] = fullPath

        switch (type) {
        case .default:
            ()
        case .in:
            params["net"] = type.description

        }
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:创建文件夹
    open func createFolder(_ fullPath: String, opName: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiCreateFolder
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["fullpath"] = fullPath
        params["op_name"] = opName
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:文件分块上传
    open func uploadByBlock(_ localPath: String, fullPath: String, opName: String, opId: Int, overwrite: Bool, delegate: UploadCallBack) -> UploadManager {

        let uploadManager = UploadManager(apiUrl: self.urlApiCreateFile, localPath: localPath, fullPath: fullPath, opName: opName, opId: opId, orgClientId: self._orgClientId, dateline: Utils.getUnixDateline(), clientSecret: self._clientSecret, overWirte: overwrite)

        uploadManager.delegate = delegate
        
        self.queue.async(execute: { () -> Void in
             uploadManager.doUpload()
        })
        return uploadManager

    }

    //MARK:将文件数据上传至
    open func createFile(_ fullPath: String, opName: String, data: Data) -> Dictionary<String, AnyObject> {
        if data.count > uploadLimitSize {
            LogPrint.error("The file more than 50 MB is not be allowed")
            return Dictionary<String, AnyObject>()
        }

        var parameters = Dictionary<String, String?>();
        parameters["org_client_id"] = _orgClientId
        parameters["dateline"] = String(Utils.getUnixDateline())
        parameters["fullpath"] = fullPath
        parameters["op_name"] = opName
        parameters["filefield"] = "file"

        let uniqueId = ProcessInfo.processInfo.globallyUniqueString

        let postBody: NSMutableData = NSMutableData()
        var postData: String = String()
        let boundary: String = "------WebKitFormBoundary\(uniqueId)"

        let filename = (fullPath as NSString).lastPathComponent

        //添加参数
        postData += "--\(boundary)\r\n"
        for (key, value) in parameters {

            postData += "--\(boundary)\r\n"
            postData += "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            postData += "\(value!)\r\n"
        }

        //添加签名
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition: form-data; name=\"sign\"\r\n\r\n"
        postData += "\(generateSign(parameters))\r\n"

        //添加文件数据
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename).jpg\"\r\n"
        postData += "Content-Type: image/png\r\n\r\n"
        postBody.append(postData.data(using: String.Encoding.utf8)!)
        postBody.append(data)
        postData = String()
        postData += "\r\n"
        postData += "\r\n--\(boundary)--\r\n"
        postBody.append(postData.data(using: String.Encoding.utf8)!)

        let url = URL(string: urlApiCreateFile)
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 10)

        let content: String = "multipart/form-data; boundary=\(boundary)"
        request.setValue(content, forHTTPHeaderField: "Content-Type")
        request.setValue("\(postBody.length)", forHTTPHeaderField: "Content-Length")
        request.httpBody = postBody as Data
        request.httpMethod = "POST"
        return NetConnection.sendRequest(request)

    }

    //MARK: 删除文件
    open func del(_ fullPaths: String, opName: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiDelFile
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["fullpaths"] = fullPaths
        params["op_name"] = opName
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:移动文件
    open func move(_ fullPath: String, destFullPath: String, opName: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiMoveFile
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["fullpath"] = fullPath
        params["dest_fullpath"] = destFullPath
        params["op_name"] = opName
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取文件链接
    open func link(_ fullPath: String, deadline: Int, authType: AuthType, password: String?) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiLinkFile
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["fullpath"] = fullPath

        if deadline != 0 {
            params["deadline"] = String(deadline)
        }

        if authType != AuthType.default {
            params["auth"] = authType.description
        }

        params["password"] = password
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:发送消息
    open func sendmsg(_ title: String, text: String, image: String?, linkUrl: String?, opName: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiSendmsg
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["title"] = title
        params["text"] = text
        params["image"] = image
        params["url"] = linkUrl
        params["op_name"] = opName
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取当前库所有外链
    open func links(_ fileOnly: Bool) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiGetLink
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        if fileOnly {
            params["file"] = "1"
        }
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)

    }

    //MARK:文件更新数量
    open func getUpdateCounts(_ beginDateline: Int, endDateline: Int, showDelete: Bool) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiUpdateCount
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["begin_dateline"] = String(beginDateline)
        params["end_dateline"] = String(endDateline)
        params["showdel"] = String(showDelete ? 1 : 0)
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:通过链接上传文件
    open func createFileByUrl(_ fullPath: String, opId: Int, opName: String!, overwrite: Bool, fileUrl: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiCreateFileByUrl
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["fullpath"] = fullPath
        params["dateline"] = String(Utils.getUnixDateline())
        if opId > 0 {
            params["op_id"] = String(opId)
        } else {
            params["op_name"] = opName
        }
        params["overwrite"] = String(overwrite ? 1 : 0)
        params["url"] = fileUrl
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:获取上传地址
    open func getUploadServers() -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiUploadSevers
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }


    open func getServerSite(_ type: String) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiUpdateCount
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["type"] = type
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:复制一个EntFileManager
    open func clone() -> EntFileManager {
        return EntFileManager(orgClientId: _orgClientId, orgClientSecret: _clientSecret)
    }


}
