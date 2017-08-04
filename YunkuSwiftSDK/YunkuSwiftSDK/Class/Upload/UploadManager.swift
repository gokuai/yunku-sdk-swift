//
//  Uploader.swift
//  YunkuSwiftSDK
//
//  Created by Brandon on 15/7/6.
//  Copyright (c) 2015年 goukuai. All rights reserved.
//

import Foundation
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


open class UploadManager: SignAbility {

    static let logTag = "UploadManager"

    let urlUploadInit = "/upload_init"
    let urlUploadPart = "/upload_part"
    let urlUploadAbort = "/upload_abort"
    let urlUploadFinish = "/upload_finish"
    let rangeSize = 65536
    // 上传分块大小-64K

    var _server = ""
    var _session = ""
    var _apiUrl = ""

    //    var _data:NSData?
    var _fullPath = ""
    var _orgClientId = ""
    var _dateline = 0
    var _opName = ""
    var _opId = 0

    var _data: Data?

    var _localPath = ""

    var _overWrite = false

    var delegate: UploadCallBack?


    init(apiUrl: String, localPath: String, fullPath: String, opName: String, opId: Int, orgClientId: String, dateline: Int, clientSecret: String, overWirte: Bool) {
        super.init()
        _apiUrl = apiUrl
        _localPath = localPath
        _fullPath = fullPath
        _opName = opName
        _opId = opId
        _dateline = dateline
        _orgClientId = orgClientId
        _clientSecret = clientSecret
        _overWrite = overWirte
    }

    func doUpload() {

        let checkValidation = FileManager.default
        if checkValidation.fileExists(atPath: _localPath) {
            startUpload()
        } else {
            if delegate != nil {
                DispatchQueue.main.async {
                   self.onUploadError("file not exist", errorCode: NetError.sdkInnerError.rawValue)
                }

            }

        }
    }


    //MARK:开始上传
    fileprivate func startUpload() -> Void {

        let handler = FileHandle(forReadingAtPath: _localPath)
        let filesize = handler?.seekToEndOfFile()
        handler?.seek(toFileOffset: 0)

        if self.delegate != nil {
            if filesize == nil {
                DispatchQueue.main.async {
                    self.onUploadError("this is error  file", errorCode: NetError.sdkInnerError.rawValue)
                }

            }
        }

        let fullPath = _fullPath
        let localPath = _localPath

        let filehash = Utils.getFileSha1(_localPath)
        let fileName = (_fullPath as NSString).lastPathComponent

        let returnResult = ReturnResult.create(addFile(filesize!, fileHash: filehash, fullPath: fullPath))
        let data = FileOperationData.create(returnResult.result!, code: returnResult.code)
        if data.code == HTTPStatusCode.ok.rawValue {

            if data.state != FileOperationData.stateNoupload {
                _server = data.server

                uploadInit(data.uuidHash, fileName: fileName, fullPath: fullPath, fileHash: filehash, fileSize: filesize!)

                var rangeIndex = 0
                var rangeEnd: UInt64 = 0
                var rangeStart: UInt64 = 0
                var range = ""

                while handler?.offsetInFile < filesize && !self.isStop {
                    let bufferData = handler?.readData(ofLength: rangeSize)

                    //获取crc校验值
                    let crc32 = CRC32.MPEG2.calculate(bufferData!)


                    //获取偏移量range值
                    rangeStart = UInt64(rangeIndex * rangeSize)
                    rangeEnd = rangeStart + UInt64((bufferData?.count)! - 1)
                    range = "\(rangeStart)-\(rangeEnd)"

                    if delegate != nil {
                        DispatchQueue.main.async {
                            self.delegate?.onProgress(Float(rangeStart) / Float(filesize!), fullPath: self._fullPath)
                        }

                    }

                    let returnResult = uploadPart(range, data: bufferData!, dataLength: bufferData!.count, crc32: crc32)

                    if returnResult.code == HTTPStatusCode.ok.rawValue {

                        rangeStart += UInt64(rangeSize)

                    } else if returnResult.code == HTTPStatusCode.accepted.rawValue {

                        break

                    } else if returnResult.code == HTTPStatusCode.internalServerError.rawValue {

                        reGetUploadServer(filesize!, fileHash: filehash, fullPath: fullPath)

                    } else if returnResult.code == HTTPStatusCode.unauthorized.rawValue {
                        //认证失败

                        let success = uploadInit(data.uuidHash, fileName: fileName, fullPath: fullPath, fileHash: filehash, fileSize: filesize!)

                        if !success {
                            onUploadError("upload Unauthorized", errorCode: NetError.sdkInnerError.rawValue)
                        }

                    } else if returnResult.code == HTTPStatusCode.conflict.rawValue {

                        var dic = returnResult.result
                        let partRangeStart = dic?["expect"] as! UInt64
                        rangeStart = partRangeStart

                    } else {
                        onUploadError(data.errorMsg, errorCode: NetError.sdkInnerError.rawValue)
                    }

                    rangeIndex += 1
                }

                let success = uploadCheck()

                if !success {
                    onUploadError("upload check fail", errorCode: NetError.sdkInnerError.rawValue)
                }

                if delegate != nil {
                    DispatchQueue.main.async {
                        self.delegate?.onProgress(1, fullPath:fullPath)
                        self.delegate?.onSuccess(filehash, fullPath: fullPath,localPath: localPath)
                    }
                }

            } else {

                if delegate != nil {
                    DispatchQueue.main.async {
                        self.delegate?.onSuccess(filehash, fullPath: fullPath,localPath: localPath)
                    }

                }

            }

        } else {
            if data.code == HTTPStatusCode.requestTimeout.rawValue {
                onUploadError("Time out", errorCode: data.code)
            } else {
                if data.errorCode != 0 {
                    onUploadError(data.errorMsg, errorCode: data.errorCode)
                } else {
                    onUploadError("Unknow network error,please see the output on console",
                            errorCode: NetError.unknowError.rawValue)
                }
            }
        }

    }

    //MARK: 上传失败
    fileprivate func onUploadError(_ errorString: String?, errorCode: Int) -> Void {
        LogPrint.error(UploadManager.logTag, msg: "onUploadError:\(errorCode):\(errorString)")
        if self.delegate != nil {
            self.delegate?.onFail(errorString, errorCode: errorCode,fullPath: _fullPath,localPath: self._localPath)
        }

    }

    //MARK:上传初始化
    fileprivate func uploadInit(_ hash: String, fileName: String, fullPath: String, fileHash: String, fileSize: UInt64) -> Bool {
        let url = _server + urlUploadInit + "?org_client_id=\(_orgClientId)"
        var params = Dictionary<String, String?>()
        params["x-gk-upload-pathhash"] = hash
        params["x-gk-upload-filename"] = fileName.urlEncode
        params["x-gk-upload-filehash"] = fileHash
        params["x-gk-upload-filesize"] = String(fileSize)
        let resultDic = NetConnection.sendRequest(url, method: "POST", params: nil, headParams: params)
        let retrunResult = ReturnResult.create(resultDic)
        var returnResultDic = retrunResult.result
        if retrunResult.code == HTTPStatusCode.ok.rawValue {
            _session = returnResultDic?["session"] as! String
        } else if retrunResult.code >= HTTPStatusCode.internalServerError.rawValue {
            reGetUploadServer(fileSize, fileHash: fileHash, fullPath: fullPath)
            return uploadInit(hash, fileName: fileName, fullPath: fullPath, fileHash: fileHash, fileSize: fileSize)

        } else {
            return false
        }
        return true
    }

    //MARK:分块传输
    fileprivate func uploadPart(_ range: String, data: Data, dataLength: Int, crc32: UInt32) -> ReturnResult {

        let url: URL = URL(string: _server + urlUploadPart)!
        let request = NSMutableURLRequest(url: url)

        request.addValue(Config.userAgent, forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = Config.connectTimeOut
        request.httpMethod = "PUT"
        request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.addValue(_session, forHTTPHeaderField: "x-gk-upload-session")
        request.addValue(range, forHTTPHeaderField: "x-gk-upload-range")
        request.addValue(String(crc32), forHTTPHeaderField: "x-gk-upload-crc")
        request.httpBody = data

        let result = NetConnection.sendRequest(request)
        return ReturnResult.create(result)


    }

    //MARK:分块传输
    fileprivate func uploadCheck() -> Bool {
        let result = ReturnResult.create(uploadFinish())
        return result.code == HTTPStatusCode.ok.rawValue
    }

    //MARK:分块传输
    fileprivate func uploadFinish() -> Dictionary<String, AnyObject> {
        let url = _server + urlUploadFinish
        var params = Dictionary<String, String?>()
        params["x-gk-upload-session"] = _session
        return NetConnection.sendRequest(url, method: "POST", params: nil, headParams: params)
    }

    //MARK:分块传输
    fileprivate func reGetUploadServer(_ fileSize: UInt64, fileHash: String, fullPath: String) {
        let returnResult = ReturnResult.create(addFile(fileSize, fileHash: fileHash, fullPath: fullPath))
        let data = FileOperationData.create(returnResult.result!, code: returnResult.code)
        _server = data.server
    }

    //MARK:分块传输
    fileprivate func uploadAbort() {
        let url = _server + urlUploadAbort
        var params = Dictionary<String, String?>()
        params["x-gk-upload-session"] = _session
        NetConnection.sendRequest(url, method: "POST", params: nil, headParams: params)
    }

    //MARK:添加文件
    fileprivate func addFile(_ fileSize: UInt64, fileHash: String, fullPath: String) -> Dictionary<String, AnyObject> {

        let method = "POST"
        let url = _apiUrl
        var params = Dictionary<String, String?>()
        params["org_client_id"] = _orgClientId
        params["dateline"] = String(_dateline)
        params["fullpath"] = fullPath

        if _opId > 0 {
            params["op_id"] = String(_opId)
        } else if (!_opName.isEmpty) {
            params["op_name"] = _opName
        }
        params["overwrite"] = String(_overWrite ? 1 : 0)
        params["op_name"] = _opName
        params["sign"] = self.generateSign(params)

        params["filesize"] = String(fileSize)
        params["filehash"] = fileHash

        return NetConnection.sendRequest(url, method: method, params: params, headParams: nil)
    }

    var isStop: Bool = false

    open func stop() {
        isStop = true
    }


}
