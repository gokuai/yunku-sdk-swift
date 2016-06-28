//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

public class EntFileManager: SignAbility {

    let uploadLimitSize = 52428800
    let urlApiFilelist = HostConfig.libHost + "/1/file/ls"
    let urlApiUpdateList = HostConfig.libHost + "/1/file/updates"
    let urlApiFileInfo = HostConfig.libHost + "/1/file/info"
    let urlApiCreateFolder = HostConfig.libHost + "/1/file/create_folder"
    let urlApiCreateFile = HostConfig.libHost + "/1/file/create_file"
    let urlApiDelFile = HostConfig.libHost + "/1/file/del"
    let urlApiMoveFile = HostConfig.libHost + "/1/file/move"
    let urlApiLinkFile = HostConfig.libHost + "/1/file/link"
    let urlApiSendmsg = HostConfig.libHost + "/1/file/sendmsg"
    let urlApiGetLink = HostConfig.libHost + "/1/file/links"
    let urlApiUpdateCount = HostConfig.libHost + "/1/file/updates_count"
    let urlApiGetServerSite = HostConfig.libHost + "/1/file/servers"
    let urlApiCreateFileByUrl = HostConfig.libHost + "/1/file/create_file_by_url"
    let urlApiUploadSevers = HostConfig.libHost + "/1/file/upload_servers"

    var _orgClientId = ""

    public init(orgClientId: String, orgClientSecret: String) {
        super.init()
        _orgClientId = orgClientId
        _clientSecret = orgClientSecret
    }

    //MARK:获取文件列表
    public func getFileList(start: Int, fullPath: String) -> Dictionary<String, AnyObject> {
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
    public func getUpdateList(isCompare: Bool, fetchDateline: Int) -> Dictionary<String, AnyObject> {
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
    public func getFileInfo(fullPath: String, type: NetType) -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiFileInfo
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["fullpath"] = fullPath

        switch (type) {
        case .Default:
            ()
        case .In:
            params["net"] = type.description

        }
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:创建文件夹
    public func createFolder(fullPath: String, opName: String) -> Dictionary<String, AnyObject> {
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
    public func uploadByBlock(localPath: String, fullPath: String, opName: String, opId: Int, overwrite: Bool, delegate: UploadCallBack) -> UploadManager {

        let uploadManager = UploadManager(apiUrl: self.urlApiCreateFile, localPath: localPath, fullPath: fullPath, opName: opName, opId: opId, orgClientId: self._orgClientId, dateline: Utils.getUnixDateline(), clientSecret: self._clientSecret, overWirte: overwrite)

        uploadManager.delegate = delegate

        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {

            uploadManager.doUpload()

            dispatch_async(dispatch_get_main_queue()) {

            }
        }


        return uploadManager

    }

    //MARK:将文件数据上传至
    public func createFile(fullPath: String, opName: String, data: NSData) -> Dictionary<String, AnyObject> {
        if data.length > uploadLimitSize {
            LogPrint.error("The file more than 50 MB is not be allowed")
            return Dictionary<String, AnyObject>()
        }

        var parameters = Dictionary<String, String?>();
        parameters["org_client_id"] = _orgClientId
        parameters["dateline"] = String(Utils.getUnixDateline())
        parameters["fullpath"] = fullPath
        parameters["op_name"] = opName
        parameters["filefield"] = "file"

        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString

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
        postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)
        postBody.appendData(data)
        postData = String()
        postData += "\r\n"
        postData += "\r\n--\(boundary)--\r\n"
        postBody.appendData(postData.dataUsingEncoding(NSUTF8StringEncoding)!)

        let url = NSURL(string: urlApiCreateFile)
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10)

        let content: String = "multipart/form-data; boundary=\(boundary)"
        request.setValue(content, forHTTPHeaderField: "Content-Type")
        request.setValue("\(postBody.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postBody
        request.HTTPMethod = "POST"

        var response: NSURLResponse?

        let dataVal: NSData = try! NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)

        //输出返回
        LogPrint.info(NSString(data: dataVal, encoding: NSUTF8StringEncoding))
        var jsonResult:Dictionary<String, AnyObject>!
        do{
            jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers) as? Dictionary<String, AnyObject>
        }catch{
            jsonResult = Dictionary<String, AnyObject>()
        }

        var httpcode: Int = 0
        if let httpResponse = response as? NSHTTPURLResponse {
            httpcode = httpResponse.statusCode
        }

        var returnResult = Dictionary<String, AnyObject>()
        returnResult[ReturnResult.keyCode] = httpcode
        returnResult[ReturnResult.keyResult] = jsonResult
        return returnResult

    }

    //MARK: 删除文件
    public func del(fullPaths: String, opName: String) -> Dictionary<String, AnyObject> {
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
    public func move(fullPath: String, destFullPath: String, opName: String) -> Dictionary<String, AnyObject> {
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
    public func link(fullPath: String, deadline: Int, authType: AuthType, password: String?) -> Dictionary<String, AnyObject> {
        let method = "POST"
        let url = urlApiLinkFile
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["fullpath"] = fullPath

        if deadline != 0 {
            params["deadline"] = String(deadline)
        }

        if authType != AuthType.Default {
            params["auth"] = authType.description
        }

        params["password"] = password
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    //MARK:发送消息
    public func sendmsg(title: String, text: String, image: String?, linkUrl: String?, opName: String) -> Dictionary<String, AnyObject> {
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
    public func links(fileOnly: Bool) -> Dictionary<String, AnyObject> {
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
    public func getUpdateCounts(beginDateline: Int, endDateline: Int, showDelete: Bool) -> Dictionary<String, AnyObject> {
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
    public func createFileByUrl(fullPath: String, opId: Int, opName: String!, overwrite: Bool, fileUrl: String) -> Dictionary<String, AnyObject> {
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
    public func getUploadServers() -> Dictionary<String, AnyObject> {
        let method = "GET"
        let url = urlApiUploadSevers
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(Utils.getUnixDateline())
        params["sign"] = generateSign(params)
        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }


    public func getServerSite(type: String) -> Dictionary<String, AnyObject> {
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
    public func clone() -> EntFileManager {
        return EntFileManager(orgClientId: _orgClientId, orgClientSecret: _clientSecret)
    }


}
