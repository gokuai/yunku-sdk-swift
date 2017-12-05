//
// Created by Brandon on 15/6/1.
// Copyright (c) 2015 goukuai. All rights reserved.
//

import Foundation

@objc public protocol UploadCallBack {

    @objc func onSuccess(_ fileHash: String, fullPath: String ,localPath:String)

    @objc func onFail(_ errorMsg: String?, errorCode: Int, fullPath: String , localPath:String)

    @objc func onProgress(_ percent: Float, fullPath: String)

}
