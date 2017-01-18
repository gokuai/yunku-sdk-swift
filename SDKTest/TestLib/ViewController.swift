//
//  ViewController.swift
//  TestLib
//
//  Created by Brandon on 15/6/1.
//  Copyright (c) 2015年 goukuai. All rights reserved.
//

import UIKit
import YunkuSwiftSDK

class ViewController: UIViewController,UploadCallBack{
    
    var _libManager:EntLibManager?
    var _fileManager:EntFileManager?
    var _entManager:EntManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置是否打印日志
        Config.logPrint = true
        //设置日志等级
        Config.logLevel = LogLevel.Info
        
        //=======库操作========//
        
        _libManager = EntLibManager(clientId: OauthConfig.clientId, clientSecret: OauthConfig.clientSecret, isEnt: true);
        
        //获取token 认证
//        deserializeReturn(_libManager!.accessToken(OauthConfig.username,password: OauthConfig.password))
        
        
        // 1T="1099511627776" 1G＝“1073741824”
        
        //创建库
        //        deserializeReturn(_libManager!.create("Test lib", orgCapacity: "1073741824", storagePointName: "test lib", orgDesc: "test lib", orgLogo: ""))
        
        //修改库信息
        //        deserializeReturn(_libManager!.set(177018, orgName: "destory", orgCapacity: "1073741824", orgDes: "test lib 2", orgLogo: ""))
        
        //获取库信息
        //        deserializeReturn(_libManager!.getInfo(177018))
        
        //获取库列表
        //        deserializeReturn(_libManager!.getLibList())
        
        //获取库授权
        //        deserializeReturn(_libManager!.bindLib(177018, title: "", linkUrl: ""))
        
        //取消库授权
        //        deserializeReturn(_libManager!.unbindLib("nXQOS6x5GxQ3zy8LkeNUKaaKY"))
        
        //添加库成员
        //        deserializeReturn(_libManager!.addMembers(379620, roleId: 2892, memberIds: ["125771"]))
        
        //获取某一个库的成员
        //        deserializeReturn(_libManager!.getMembers(0, size: 10, orgId: 379620))
        
        //查询库成员信息
        
        //        deserializeReturn(_libManager!.getMember(4405, type: MemberType.Account, ids: ["qwdqwdq1"]))
        
        //批量修改单库中成员角色
        //        deserializeReturn(_libManager!.setMemberRole(150998, roleId: 2894, memberIds: ["4"]))
        
        //从库中删除成员
        //        deserializeReturn(_libManager!.delMember(150998, memberIds: ["4"]))
        
        //获取某一个企业分组列表
        //        deserializeReturn(_libManager!.getGroups(32657))
        
        //库上添加分组
        //        deserializeReturn(_libManager!.addGroup(150998, groupId: 4448, roleId: 2892))
        
        //库上删除分组
        //        deserializeReturn(_libManager!.delGroup(150998, groupId: 4448))
        
        //设置分组上的角色
        //        deserializeReturn(_libManager!.setGroupRole(150998, groupId: 4448, roleId: 2894))
        
        //删除库
        //        deserializeReturn(_libManager!.destroy("b2013df96cbc23b4b0dd72f075e5cbf7"))
        
        //=======文件操作========//
        
        
        let orgClientId = "mYpSi5o79xUutZ2VS1Z0OCoKV8"
        let orgClientSecret = "zGzucwVeW4opK3GpHZW1fOQsFPw"
        
        
        _fileManager = EntFileManager(orgClientId: orgClientId, orgClientSecret: orgClientSecret)
        
        //获取文件列表
//        deserializeReturn( _fileManager!.getFileList(0, fullPath: ""))
        
        //获取更新列表
        //        deserializeReturn(_fileManager!.getUpdateList(false, fetchDateline: 0))
        
        //文件更新数量
        //        let calendar = NSCalendar.currentCalendar()
        //        let twoDaysAgo = calendar.dateByAddingUnit(.CalendarUnitDay, value: -2, toDate: NSDate(), options: nil)
        //        twoDaysAgo?.timeIntervalSinceNow
        //
        //        deserializeReturn(_fileManager!.getUpdateCounts(Int((twoDaysAgo?.timeIntervalSince1970)!*1000),
        //            endDateline: Int(NSDate.new().timeIntervalSince1970*1000) , showDelete: false))
        
        //获取文件(夹)信息
//                deserializeReturn(_fileManager!.getFileInfo("test.apk",type: NetType.Default))
        
        //创建文件夹
        //        deserializeReturn(_fileManager!.createFolder("test", opName: "Brandon"))
        
        //上传文件 文件不得超过50MB
        //        var data = NSData(contentsOfFile:"/Users/Brandon/Desktop/test.apk" )
        //        deserializeReturn(_fileManager!.createFile("test.apk", opName: "Brandon", data: data!))
        
        //删除文件
        //        deserializeReturn(_fileManager!.del("file.jpeg", opName: "Brandon"))
        
        //移动文件
        //        deserializeReturn(_fileManager!.move("test_image.png", destFullPath: "test/test_image.png", opName: "Brandon"))
        
        //文件连接
        //        deserializeReturn(_fileManager!.link("test/test_image.png", deadline: 0, authType: AuthType.Default, password: ""))
        
        
        //发送消息
        //        deserializeReturn(_fileManager!.sendmsg("msgTest", text: "msg", image: "", linkUrl: "", opName: "Brandon"))
        
        //获取当前库所有外链(new)
        //       deserializeReturn(_fileManager!.links(true))
        
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        print("documentsPath: \(documentsPath)")
        //文件分块上传
        _fileManager?.uploadByBlock("\(documentsPath)/各种定制版本说明.xlsx",
                fullPath: "test", opName: "Brandon", opId: 0, overwrite: true, delegate: self)
        //
         //通过链接上传文件
//        deserializeReturn(_fileManager!.createFileByUrl("中文.jpg", opId: 0, opName: "Brandon", overwrite: true, fileUrl: "http://www.sinaimg.cn/dy/slidenews/1_img/2015_27/2841_589214_521618.jpg"))
        
        //WEB直接上传文件 (支持50MB以上文件的上传)
//        deserializeReturn(_fileManager!.getUploadServers())
        
        //=======企业操作========//
        _entManager = EntManager(clientId: OauthConfig.clientId, clientSecret: OauthConfig.clientSecret,isEnt:true)
        
        //身份认证
//                deserializeReturn(_entManager!.accessToken(OauthConfig.username,OauthConfig.password))
        
        //获取角色
        //        deserializeReturn(_entManager!.getRoles())
        
        //获取分组
        //         deserializeReturn(_entManager!.getGroups())
        
        //获取成员
        //        deserializeReturn(_entManager!.getMembers(0, size: 99))
        
        //分组成员列表
        //        deserializeReturn(_entManager!.getGroupMembers(1086, start: 0, size: 3, showChild: true))
        
        //根据成员id获取成员个人库外链
        //        deserializeReturn(_entManager!.getMemberFileLink(52, fileOnly: true))
        
        //根据成员Id查询企业成员信息
//        deserializeReturn(_entManager!.getMemberById(42))
        
        //根据外部系统唯一id查询企业成员信息
//        deserializeReturn(_entManager!.getMemberByOutId("dqwdqw"))
        
        //根据外部系统登录帐号查询企业成员信息
//        deserializeReturn(_entManager!.getMemberByAccount("nishuonishuo"))
        
        //添加或修改同步成员
        //        deserializeReturn(_entManager!.addSyncMember("MemberTest1", memberName: "Member2", account: "Member1", memberEmail: "123@qq.com", memberPhone: "111", password: ""))
        
        //删除成员
        //        deserializeReturn(_entManager!.delSyncMember(["MemberTest"]))
        
        //添加或修改同步分组
        //        deserializeReturn(_entManager!.addSyncGroup("ParentGroup", name: "ParentGroup", parentOutId: ""))
        
        //删除同步分组
        //        deserializeReturn(_entManager!.delSyncGroup(["GroupTest"]))
        
        
        //添加同步分组的成员
        //        deserializeReturn(_entManager!.addSyncGroupMember("GroupTest", members: ["GroupTest"]))
        
        //删除同步分组的成员
        //        deserializeReturn(_entManager!.delSyncGroupMember("GroupTest", members: ["GroupTest"]))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func onFail(errorMsg: String?,errorCode:Int,fullPath:String,localPath:String) {
        
        print("onFail: \(errorMsg),\(errorCode),\(fullPath),\(localPath)")
        
    }
    
    func onSuccess(fileHash: String,fullPath:String,localPath:String) {
        
        deserializeReturn(_fileManager!.del("test", opName: "Brandon"))
        
        print("onSuccess: \(fileHash),\(fullPath),\(localPath)")
        
    }
    
    func onProgress(percent: Float,fullPath:String) {
        
        print("onProgress: \(percent)")
        
    }


    func deserializeReturn(result: Dictionary<String, AnyObject>) {
        let returnResult = ReturnResult.create(result)
        if returnResult.code == HTTPStatusCode.OK.rawValue {
            //请求成功
            print("return 200")

        } else {
            let baseData = BaseData.create(returnResult.result!)
            print("\(baseData.errorCode):\(baseData.errorMsg)")
        }

        print(returnResult.result)
    }
    

}

