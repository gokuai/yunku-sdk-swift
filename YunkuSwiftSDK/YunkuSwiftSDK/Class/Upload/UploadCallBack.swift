//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

@objc public protocol UploadCallBack {

    func onSuccess(fileHash: String, fullPath: String ,localPath:String)

    func onFail(errorMsg: String?, errorCode: Int, fullPath: String , localPath:String)

    func onProgress(percent: Float, fullPath: String)

}
