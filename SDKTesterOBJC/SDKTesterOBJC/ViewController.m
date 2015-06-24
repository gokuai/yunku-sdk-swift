//
//  ViewController.m
//  SDKTesterOBJC
//
//  Created by Brandon on 15/6/23.
//  Copyright (c) 2015年 goukuai. All rights reserved.
//

#import "ViewController.h"
#import <YunkuSwiftSDK/YunkuSwiftSDK-Swift.h>
//#import "SDKTesterOBJC-Swift.h"
#import "Constant.h"

#define ORG_CLIENTID @"FkxXDGumDS8qfmAKYjd7tVOYps"  //EntLibManager bindLib 获取到的 org_clientid
#define ORG_CLIENTSECRET @"9jXXWx2a8mn9vX9bC10UbaOOh70" // EntLibManager bindLib 获取到的 org_clientsecret


@interface ViewController ()
@property(nonatomic, strong) EntLibManager *entLibManager;
@property(nonatomic, strong) EntFileManager *entFileManager;
@property(nonatomic, strong) EntManager *entManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    //设置是否打印日志
    [Config setLogPrint:YES];

    //设置日志等级

    [Config setLogLevel:LogLevelInfo];

    _entLibManager = [[EntLibManager alloc] initWithUsername:USERNAME password:PASSWORD clientId:CLIENTID clientSecret:CLIENTSECRET];

    [self deserializeReturn:[_entLibManager accessToken:true]];

    // 1T="1099511627776" 1G＝“1073741824”
    //创建库

//    [self deserializeReturn:[_entLibManager create:@"Test lib" orgCapacity:@"1073741824" storagePointName:@"test lib" orgDesc:@"test lib" orgLogo:@""]];

    //修改库信息

//    [self deserializeReturn:[_entLibManager set:177018 orgName:@"destory" orgCapacity:@"1073741824" orgDes:@"test lib 2" orgLogo:@""]];

    //获取库信息
//    [self deserializeReturn:[_entLibManager getInfo:177018]];

    //获取库列表
//    [self deserializeReturn:[_entLibManager getLibList]];

    //获取库授权
//    [self deserializeReturn:[_entLibManager bindLib:177018 title:@"" linkUrl:@""]];

    //取消库授权
//    [self deserializeReturn:[_entLibManager unbindLib:@"nXQOS6x5GxQ3zy8LkeNUKaaKY"]];

    //添加库成员
//    [self deserializeReturn:[_entLibManager addMembers:379620 roleId:2892 memberIds:@[@"125771"]]];

    //获取某一个库的成员

//    [self deserializeReturn:[_entLibManager getMembers:0 size:10 orgId:379620]];

    //查询库成员信息

//    [self deserializeReturn:[_entLibManager getMember:4405 type:MemberTypeAccount ids:@[@"qwdqwdq1"]]];

    //批量修改单库中成员角色

//    [self deserializeReturn:[_entLibManager setMemberRole:150998 roleId:2894 memberIds:@[@"4"]]];

    //从库中删除成员
//    [self deserializeReturn:[_entLibManager delMember:150998 memberIds:@[@"4"]]];

    //获取某一个企业分组列表
//    [self deserializeReturn:[_entLibManager getGroups:32657]];

    //库上添加分组
//    [self deserializeReturn:[_entLibManager addGroup:150998 groupId:4448 roleId:2892]];

    //库上删除分组
//    [self deserializeReturn:[_entLibManager delGroup:150998 groupId:4448]];

    //设置分组上的角色

//    [self deserializeReturn:[_entLibManager setGroupRole:150998 groupId:4448 roleId:2894]];

    //删除库
//    [self deserializeReturn:[_entLibManager destroy:@"b2013df96cbc23b4b0dd72f075e5cbf7"]];

    //=======文件操作========//



    _entFileManager = [[EntFileManager alloc] initWithOrgClientId:ORG_CLIENTID orgClientSecret:ORG_CLIENTSECRET];

    //获取文件列表
//    [self deserializeReturn:[_entFileManager getFileList:0 fullPath:@"testPath"]];

    //获取更新列表
//    [self deserializeReturn:[_entFileManager getUpdateList:NO fetchDateline:0]];

    //文件更新数量

//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *twoDaysAgo= [calendar dateBySettingUnit:NSCalendarUnitDay value:-2 ofDate:[[NSDate alloc] init] options:nil];
//
//    [self deserializeReturn:[_entFileManager getUpdateCounts:(NSInteger) twoDaysAgo.timeIntervalSince1970 endDateline:(NSInteger) [NSDate new].timeIntervalSince1970 showDelete:NO]];

    //获取文件(夹)信息
//    [self deserializeReturn:[_entFileManager getFileInfo:@"test.apk"]];

    //创建文件夹
//    [self deserializeReturn:[_entFileManager createFolder:@"test" opName:@"Brandon"]];

    //上传文件 文件不得超过50MB
//    NSData *data = [NSData dataWithContentsOfFile:@"/Users/Brandon/Desktop/test.apk"];
//    [self deserializeReturn:[_entFileManager createFile:@"test.apk" opName:@"Brandon" data:data]];

    //删除文件
//    [self deserializeReturn:[_entFileManager del:@"file.jpeg" opName:@"Brandon"]];

    //移动文件
//    [self deserializeReturn:[_entFileManager move:@"test_image.png" destFullPath:@"test/test_image.png" opName:@"Brandon"]];

    //文件连接
//    [self deserializeReturn:[_entFileManager link:@"test/test_image.png" deadline:0 authType:AuthTypeDefault password:@""]];


    //发送消息
//    [self deserializeReturn:[_entFileManager sendmsg:@"msgTest" text:@"msg" image:@"" linkUrl:@"" opName:@"Brandon"]];

    //获取当前库所有外链(new)
//    [self deserializeReturn:[_entFileManager links:YES]];


    //文件分块上传
//    [_entFileManager uploadByBlock:@"/Users/Brandon/Desktop/gugepinyinshurufa_427.apk" fullPath:@"test.apk"
//                            opName:@"Brandon" opId:0 overwrite:YES delegate:self];

    //=======企业操作========//
    _entManager = [[EntManager alloc] initWithUsername:USERNAME password:PASSWORD clientId:CLIENTID clientSecret:CLIENTSECRET];

    //身份认证
    [self deserializeReturn:[_entManager accessToken:YES]];

    //获取角色
//    [self deserializeReturn:[_entManager getRoles]];

    //获取分组
//    [self deserializeReturn:[_entManager getGroups]];

    //获取成员
//    [self deserializeReturn:[_entManager getMembers:0 size:99]];

    //分组成员列表
//    [self deserializeReturn:[_entManager getGroupMembers:1086 start:0 size:3 showChild:YES]];

    //根据成员id获取成员个人库外链

//    [self deserializeReturn:[_entManager getMemberFileLink:52 fileOnly:YES]];

    //根据外部成员id获取成员信息
//    [self deserializeReturn:[_entManager getMemberByOutid:@[@"nishuonishuo"]]];

    //根据外部成员登录帐号获取成员信息（new）
//    [self deserializeReturn:[_entManager getMemberByUserId:@[@"shipeng3"]]];

    //添加或修改同步成员
//    [self deserializeReturn:[_entManager addSyncMember:@"MemberTest1" memberName:@"Member2"
//                                               account:@"Member1" memberEmail:@"123@qq.com" memberPhone:@"111" password:@""]];

    //删除成员
//    [self deserializeReturn:[_entManager delSyncMember:@[@"MemberTest"]]];

    //添加或修改同步分组
//    [self deserializeReturn:[_entManager addSyncGroup:@"ParentGroup" name:@"ParentGroup" parentOutId:@""]];

    //删除同步分组
//    [self deserializeReturn:[_entManager delSyncGroup:@[@"GroupTest"]]];


    //添加同步分组的成员
//    [self deserializeReturn:[_entManager addSyncGroupMember:@"GroupTest" members:@[@"GroupTest"]]];

    //删除同步分组的成员
//    [_entManager delSyncGroupMember:@"GroupTest" members:@[@"GroupTest"]];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.


}

- (void)deserializeReturn:(NSDictionary *)result {

    ReturnResult *returnResult = [ReturnResult create:result];

    if (returnResult.code == HTTPStatusCodeOK) {
        NSLog(@"return 200");
        //请求成功

    } else {
        //在这个位置解析错误

    }

    NSLog(@"result:%@", result);

}

- (void)onSuccess:(NSString *)fileHash {

}

- (void)onFail:(NSString *)errorMsg {

}

- (void)onProgress:(float)percent {

}


@end
