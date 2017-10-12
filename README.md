/*
Title:够快云库Swift SDK使用说明
Description:
Author: Brandon
Date: 2016/03/03
Robots: noindex,nofollow
*/

# 够快云库Swift SDK使用说明

版本：1.0.1

创建：2015-06-23
修改时间：2016-03-03

## 引用 
建议将项目build产生的**YunkuSwiftSDK.framework**文件引用进项目，或者将项目作为Library Project 引入,如果是 iOS Application，使用 Headers/iOS 文件夹下的头文件，如果是 OSX Application
则使用Headers/OSX的头文件

### Swift
*Framework*

* 将YunkuSwiftSDK.framework,CommonCrypto.framework 拖至 ［Your Project］之下
* 确认Project－> Build Phases, 确认 Link Binary With Libraries 已添加 YunkuSwiftSDK.framework
* 在 Build Phases 中添加一项 New Copy Files Phrase，选择 Destination 为 Frameworks，将项目中的 YunkuSwiftSDK.framework，CommonCrypto.framework 拖曳进去
* 在使用SDK的类的顶部添加 import YunkuSwiftSDK

*Library Project*

* 将YunkuSwiftSDK.xcodeproj 拖至 ［Your Project］之下
* 确认Project－> Build Phases, Target Dependencies 和 Link Binary With Libraries 已添加 YunkuSwiftSDK.framework
* 在 Build Phases 中添加一项 New Copy Files Phrase，选择 Destination 为 Frameworks，将项目中的 YunkuSwiftSDK.framework，CommonCrypto.framework 拖曳进去
* 在使用SDK的类的顶部添加 import YunkuSwiftSDK

### Object-C
*Framework*

* 将YunkuSwiftSDK.framework 拖至 ［Your Project］之下
* 确认Project－> Build Phases, 确认 Link Binary With Libraries 已添加 YunkuSwiftSDK.framework,
* 在 Build Phases 中添加一项 New Copy Files Phrase，选择 Destination 为 Frameworks，将项目中的 YunkuSwiftSDK.framework,CommonCrypto.framework 拖曳进去
* 在 Build Setting 中, Embeded Content Contains Swift Code 设置为 YES
* 在使用SDK的类的顶部添加 #import <YunkuSwiftSDK/YunkuSwiftSDK-Swift.h>

*Library Project*

* 将YunkuSwiftSDK.xcodeproj 拖至 ［Your Project］之下
* 确认Project－> Build Phases, Target Dependencies 和 Link Binary With Libraries 已添加 YunkuSwiftSDK.framework
* 在 Build Phases 中添加一项 New Copy Files Phrase，选择 Destination 为 Frameworks，按＋号键，选择 YunkuSwiftSDK.framework,CommonCrypto.framework
* 在 Build Setting 中, Embeded Content Contains Swift Code 设置为 YES
* 在使用SDK的类的顶部添加 #import <YunkuSwiftSDK/YunkuSwiftSDK-Swift.h>

## 初始化
要使用云库api，您需要有效的CLIENT_ID和CLIENT_SECRET,和获得云库后台管理账号。

## 参数使用
以下使用到的方法中，如果是string类型的非必要参数，如果是不传，则传null

## 企业库管理（ **EntLibManager.swift** ）

###构造方法
**swift**

	EntLibManager（clientId:String,clientSecret:String,isEnt:Bool）

**objc**

	[[EntLibManager alloc]initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret inEnt:BOOL] 


#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| clientId | 是 | string | 申请应用时分配的AppKey |
| clientSecret | 是 | string | 申请应用时分配的AppSecret |
| isEnt | 是 | boolean | 是否是企业帐号登录|

---

### 授权
**swift**

	accessToken(username:String,password:String)
**objc**
	
	[accessToken:(NSString*)username password:password]
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| username | 是 | string | 用户名 |
| password | 是 | string | 密码|


#### 返回结果

	{
		access_token:
		expires_in:
		refresh_token:c
	}

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| access_token | string | 用于调用access_token，接口获取授权后的access token |
| expires_in |int | access_token的有效期，unix时间戳 |
| refresh_token | string | 用于刷新access_token 的 refresh_token，有效期1个月 |

---
### 创建库
**swift**

	create(orgName:String, orgCapacity:Int, 
	storagePointName:String,  orgDesc:String) 
	
**objc**

	create:(NSString *)orgName orgCapacity:(NSString *)orgCapacity storagePointName:(NSString *)storagePointName orgDesc:(NSString *)orgDesc orgLogo:(NSString *)orgLogo

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgName | 是 | string | 库名称|
| orgCapacity | 否 | int | 库容量上限, 单位字节, 默认无上限|
| storagePointName | 否 | string | 库归属存储点名称, 默认使用够快存储|
| orgDesc | 否 | string | 库描述|
| orgLogo | 否 | string | 库logo |

####数值参考
1T="1099511627776" 
1G＝“1073741824”；

#### 返回结果

    {
    	org_id:    
    	mount_id:
    }

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| org_id | int | 库ID |
| mount_id | int | 库空间id |

---

### 获取库列表
	getLibList()
#### 参数 
(无)
#### 返回结果

    {
    'list':
        [
        	{
        		org_id : 库ID
        		org_name : 库名称
        		org_logo_url : 库图标url
        		size_org_total : 库空间总大小, 单位字节, -1表示空间不限制
        		size_org_use: 库已使用空间大小, 单位字节
        		mount_id: 库空间id
        	},
        	...
        ]
    }

---

### 修改库信息

**swift**
	
	set(orgId:Int,orgName:String, orgCapacity:String, orgDesc: String, orgLogo:String) 

**objc**

	set:(NSInteger)orgId orgName:(NSString *)orgName orgCapacity:(NSString *)orgCapacity orgDes:(NSString *)orgDes orgLogo:(NSString *)orgLogo
	
#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
| orgName | 否 | string | 库名称 |
| orgCapacity | 否 | string | 库容量限制，单位B |
| orgDesc | 否 | string | 库描述 |
| orgLogo | 否 | string | 库logo |

#### 返回结果 
   正常返回 HTTP 200 

#### 数值参考
1T="1099511627776" 
1G＝“1073741824”；

---

### 获取库信息

**swift**

	getInfo(orgId:Int)

**objc**

	getInfo:(NSInteger)orgId

#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |


#### 返回结果 
	{
      info:
      {
        org_id : 库ID
        org_name : 库名称
        org_desc : 库描述
        org_logo_url : 库图标url
        size_org_total : 库空间总大小, 单位字节, -1表示空间不限制
        size_org_use: 库已使用空间大小, 单位字节
        mount_id: 库空间id
      }
	} 
   
---


### 获取库授权
**swift**

	bindLib(orgId:Int, title:String , linkUrl:String)
	
**objc**

	bindLib:(NSInteger)orgId title:(NSString *)title linkUrl:(NSString *)linkUrl
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库ID |
| title | 否 | string | 标题(预留参数) |
| linkUrl | 否 | string | 链接(预留参数) |

#### 返回结果

	{
		org_client_id:
		org_client_secret:
	}

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| org_client_id | string | 库授权client_id |
| org_client_secret | string | 库授权client_secret |

org_client_secret用于调用库文件相关API签名时的密钥

---


### 取消库授权
**swift**

	unbindLib(orgClientId: String) 

**objc**

	unbindLib:(NSString *)orgClientId;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgClientId | 是 | string | 库授权client_id |

#### 返回结果

	正常返回 HTTP 200

---

### 获取库成员列表

**swift**

	getMembers(start:Int, size:Int, orgId:Int)

**objc**

	getMembers:(NSInteger)start size:(NSInteger)size orgId:(NSInteger)orgId;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
| start | 否 | int | 分页开始位置，默认0 |
| size | 否 | int | 分页个数，默认20 |
#### 返回结果
	
	{
		list:
		[
			{
				"member_id": 成员id,
				"out_id": 成员外部id,
				"account": 外部账号,
				"member_name": 成员显示名,
				"member_email": 成员邮箱,
				"state": 成员状态。1：已接受，2：未接受,
			},
			...
		],
		count: 成员总数
	}

---
### 添加库成员

**swift**

	addMembers(int orgId, int roleId, int[] memberIds) 
	
**objc**

	addMembers:(NSInteger)orgId roleId:(NSInteger)roleId memberIds:(NSArray *)memberIds

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
| roleId | 是 | int | 角色id |
| memberIds | 是 | array | 需要添加的成员id数组 |
#### 返回结果
	
	正常返回 HTTP 200

---

### 修改库成员角色

**swift**

	setMemberRole(orgId:Int, roleId:Int, memberIds:[Int]) 

**objc**

	setMemberRole:(NSInteger)orgId roleId:(NSInteger)roleId memberIds:(NSArray *)memberIds

	
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
| roleId | 是 | int | 角色id |
| memberIds | 是 | array | 需要修改的成员id数组 |

#### 返回结果
	
	正常返回 HTTP 200

---
### 删除库成员

**swift**

	delMember(orgId:Int, memberIds:[Int])
	
**objc**
	
	delMember:(NSInteger)orgId memberIds:(NSArray *)memberIds

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
| memberIds | 是 | array | 成员id数组|
#### 返回结果
	
	正常返回 HTTP 200

---
### 获取库分组列表
	getGroups(int orgId)
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
#### 返回结果
	{
		{
			"id": 分组id
			"name": 分组名称
			"role_id": 分组角色id, 如果是0 表示分组中的成员使用在该分组上的角色
		},
		...
	}

---
### 库上添加分组

**swift**

	addGroup(int orgId, int groupId, int roleId)
	
**objc**

	addGroup:(NSInteger)orgId groupId:(NSInteger)groupId roleId:(NSInteger)roleId;
	
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
| groupId | 是 | int | 分组id|
| roleId | 否 | int | 角色id,  默认0：分组中的成员使用在该分组上的角色 |
#### 返回结果
	
	正常返回 HTTP 200

---
### 删除库上的分组
	delGroup(int orgId, int groupId)
#### 参数 
 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
| groupId | 是 | int | 分组id |
#### 返回结果
	
	正常返回 HTTP 200

---


### 修改库上分组的角色

**swift**

	setGroupRole(int orgId, int groupId, int roleId)
	
**objc**

	setGroupRole:(NSInteger)orgId groupId:(NSInteger)groupId roleId:(NSInteger)roleId;
	
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgId | 是 | int | 库id |
| groupId | 是 | int | 分组id |
| roleId | 否 | int | 角色id,  默认0：分组中的成员使用在该分组上的角色 |
#### 返回结果
	
	正常返回 HTTP 200

---

### 删除库

**swift**

	destroy(String orgClientId)

**objc**

	destroy:(NSString *)orgClientId;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| orgClientId | 是 | string | 库授权client_id|
#### 返回结果
	
	正常返回 HTTP 200

---




## 企业管理（**EntManager.swift** ）
### 构造方法

**swift**

	EntManager（Username:String，Password:String, ClientId:String, ClientSecret:String）
	
**objc**
	[[EntManager alloc]initWithUsername:(NSString *)username password:(NSString *)password clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret]

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| Username | 是 | string | 用户名 |
| Password | 是 | string | 密码|
| ClientId | 是 | string | 申请应用时分配的AppKey |
| ClientSecret | 是 | string | 申请应用时分配的AppSecret |

---

### 授权

**swift**

	accessToken(isEnt:BOOL)

**objc**

	accessToken:(BOOL)isEnt


#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| isEnt | 是 | boolean | 是否是企业帐号登录|


#### 返回结果

	{
		access_token:
		expires_in:
		refresh_token:
	}

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| access_token | string | 用于调用access_token，接口获取授权后的access token |
| expires_in |int | access_token的有效期，unix时间戳 |
| refresh_token | string | 用于刷新access_token 的 refresh_token，有效期1个月 |

---
### 获取角色

**swift**

	getRoles() 

**objc**

	getRoles

#### 参数
（无） 
#### 返回结果
	[
		{
			"id": 角色id,
			"name": 角色名称,
			},
		...
	]

---

###获取成员

**swift**

	getMembers(start:Int, size:Int)
	
**objc**

	getMembers:(NSInteger)start size:(NSInteger)size orgId:(NSInteger)orgId;
	
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| start | 否 | int | 记录开始位置, 默认0 |
| size | 否 | int | 返回条数, 默认20 |
#### 返回结果
	{
		list:
		[
			{
				"member_id": 成员id,
				"out_id": 成员外部id,
				"account": 外部账号,
				"member_name": 成员显示名,
				"member_email": 成员邮箱,
				"state": 成员状态。1：已接受，2：未接受,
			},
			...
		],
		count: 成员总数
	}

---
### 根据成员Id查询企业成员信息
	getMemberById(int memberId)

#### 参数 
	
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| memberId | 是 | int | 成员id |


#### 返回结果

	{
      "member_id": 成员id,
      "member_name": 成员显示名,
      "member_email": 成员邮箱,
      "out_id": 外部系统唯一id,
      "account": 外部系统登录帐号,
      "state": 成员状态。1：已接受，2：未接受
	}

---

### 根据外部系统唯一id查询企业成员信息
	getMemberByOutId(String outId)

#### 参数 
	
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| outId | 是 | String | 外部系统唯一id|


#### 返回结果

	{
      "member_id": 成员id,
      "member_name": 成员显示名,
      "member_email": 成员邮箱,
      "out_id": 外部系统唯一id,
      "account": 外部系统登录帐号,
      "state": 成员状态。1：已接受，2：未接受
	}

---
### 根据外部系统登录帐号查询企业成员信息
	String getMemberByAccount(String account)

#### 参数 
	
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| account | 是 | String | 外部系统登录帐号 |


#### 返回结果

	{
      "member_id": 成员id,
      "member_name": 成员显示名,
      "member_email": 成员邮箱,
      "out_id": 外部系统唯一id,
      "account": 外部系统登录帐号,
      "state": 成员状态。1：已接受，2：未接受
	}

---


### 查询库成员信息
**swift**
	getMember(orgid:Int, type:MemberType, ids:[String])

**objc**
	getMember:(NSInteger)orgId type:(enum MemberType)type ids:(NSArray *)ids;


#### 参数 
	
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgid | 是 | int | 库id |
| type | 是 | enum | ACCOUNT,OUT_ID,MEMBER_ID |
| ids | 是 | array | 多个id数组 |

#### 返回结果
		
		{
			"id(传入时的id))":{
				"member_id": 成员id,
				"out_id": 成员外部id,
				"account": 外部账号,
				"member_name": 成员显示名,
				"member_email": 成员邮箱
			},
			...
		}

---

### 根据成员Id查询企业成员信息
**swift**

	getMemberById(memberId:Int)
	
**objc**

	getMemberById:(NSInteger)memberId;

#### 参数 
	
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| memberId | 是 | int | 成员id |


#### 返回结果

	{
      "member_id": 成员id,
      "member_name": 成员显示名,
      "member_email": 成员邮箱,
      "out_id": 外部系统唯一id,
      "account": 外部系统登录帐号,
      "state": 成员状态。1：已接受，2：未接受
	}

---

### 根据外部系统唯一id查询企业成员信息

**swift**

	getMemberByOutId(outId:String)
	
**objc**

	getMemberByOutId:(NSString *)outId;
	

#### 参数 
	
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| outId | 是 | String | 外部系统唯一id|


#### 返回结果

	{
      "member_id": 成员id,
      "member_name": 成员显示名,
      "member_email": 成员邮箱,
      "out_id": 外部系统唯一id,
      "account": 外部系统登录帐号,
      "state": 成员状态。1：已接受，2：未接受
	}

---
### 根据外部系统登录帐号查询企业成员信息

**swift**

	getMemberByAccount(account:String)
	
**objc**

	getMemberByAccount:(NSString *)account;
	

#### 参数 
	
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| account | 是 | String | 外部系统登录帐号 |


#### 返回结果

	{
      "member_id": 成员id,
      "member_name": 成员显示名,
      "member_email": 成员邮箱,
      "out_id": 外部系统唯一id,
      "account": 外部系统登录帐号,
      "state": 成员状态。1：已接受，2：未接受
	}

---

### 获取分组

**swift**

	getGroups() 

**objc**

	getGroups
	
#### 参数 
（无）
#### 返回结果
	{
		"list":
		[
			{
				"id": 分组id,
				"name": 分组名称,
				"out_id": 外部唯一id,
				"parent_id": 上级分组id, 0为顶级分组
			}
		]
	}	

---
### 分组成员列表
**swift**

	getGroupMembers(int groupId, int start, int size, boolean showChild) 


**objc**

	getGroupMembers:(NSInteger)groupId start:(NSInteger)start size:(NSInteger)size showChild:(BOOL)showChild;
	
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| groupId | 是 | int | 分组id |
| start | 是 | int | 记录开始位置 |
| size | 是 | int | 返回条数 |
| showChild | 是 | boolean | [0,1] 是否显示子分组内的成员 |
#### 返回结果
	
	
	{
		list:
		[
			{
				"member_id": 成员id,
				"out_id": 成员外部id,
				"account": 外部账号,
				"member_name": 成员显示名,
				"member_email": 成员邮箱,
				"state": 成员状态。1：已接受，2：未接受,
			},
			...
		],
		count: 成员总数
	}

---
### 根据成员id获取成员个人库外链

**swift**

	getMemberFileLink(memberId:Int, fileOnly:BOOL)
	
**objc**

	getMemberFileLink:(NSInteger)memberId fileOnly:(BOOL)fileOnly;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| memberId | 是 | int | 成员id |
| fileOnly | 是 | boolean | 是否只返回文件, 1只返回文件 |
#### 返回结果
	[
		{
		    "filename": 文件名或文件夹名,
		    "filesize": 文件大小,
    		"link": 链接地址,
    		"deadline": 到期时间戳 -1表示永久有效,
    		"password": 是否加密, 1加密, 0无
    	},
    	...
	]

---

### 添加或修改同步成员

**swift**

	addSyncMember(oudId:String, memberName:String, account:String, memberEmail:String, memberPhone:String, password:String)

**objc**

	addSyncMember:(NSString *)oudId memberName:(NSString *)memberName account:(NSString *)account memberEmail:(NSString *)memberEmail memberPhone:(NSString *)memberPhone password:(NSString *)password;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| oudId | 是 | string | 成员在外部系统的唯一id |
| memberName | 是 | string | 显示名称 |
| account | 是 | string | 成员在外部系统的登录帐号 |
| memberEmail | 否 | string | 邮箱 |
| memberPhone | 否 | string | 联系电话 |
| password | 否 | string | 如果需要由够快验证帐号密码,密码为必须参数 |

#### 返回结果

    HTTP 200

---

### 删除同步成员
**swift**

	delSyncMember( members:[String])

**objc**
	
	delSyncMember:(NSArray *)members;
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| members | 是 | array | 成员在外部系统的唯一id数组|

#### 返回结果

    HTTP 200

---

### 添加或修改同步分组
**swift**

	addSyncGroup(outId:String, name:Sting, parentOutId:String)
	
**objc**

	addSyncGroup:(NSString *)outId name:(NSString *)name parentOutId:(NSString *)parentOutId;
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| outId | 是 | string | 分组在外部系统的唯一id |
| name | 是 | string | 显示名称 |
| parentOutId | 否 | string | 如果分组在另一个分组的下级, 需要指定上级分组唯一id, 不传表示在顶层, 修改分组时该字段无效 |

#### 返回结果

    HTTP 200

---
### 删除同步分组
**swift**

	delSyncGroup(groups:[String])

**objc**

	delSyncGroup:(NSArray *)groups;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| groups | 是 | string | 分组在外部系统的唯一id数组|

#### 返回结果

    HTTP 200
---
### 添加同步分组的成员

**swift**

	addSyncGroupMember(groupOutId:[String],  members:[String])
	
**objc**
	
	addSyncGroupMember:(NSString *)groupOutId members:(NSArray *)members;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| groupOutId | 否 | string | 外部分组的唯一id, 不传表示顶层 |
| members | 是 | array | 成员在外部系统的唯一id数组 |
#### 返回结果

    HTTP 200
---
### 删除同步分组的成员
**swift**

	delSyncGroupMember(groupOutId: String, members:[String])
	
**objc**

	delSyncGroupMember:(NSString *)groupOutId members:(NSArray *)members;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| groupOutId | 否 | string | 外部分组的唯一id, 不传表示顶层 |
| members | 是 | string | 成员在外部系统的唯一id数组 |
#### 返回结果

    HTTP 200
---


## 企业文件管理（**EntFileManager.swift** ）
###构造方法

**swift**

	EntFileManager(orgClientId: String, orgClientSecret: String);

**objc**

	[[EntFileManager alloc]initWithOrgClientId:(NSString *)orgClientId orgClientSecret:(NSString *)orgClientSecret]
	
#### 参数 
| 参数 | 必须 | 类型 | 说明 |
| --- | --- | --- | --- |
| orgClientId | 是 | string | 库授权client_id  |
| orgClientSecret | 是 | string | 库授权client_secret  |

---
###获取文件列表

**swift**

	getFileList( start:Int, fullPath:String)

**objc**

	getFileList:(NSInteger)start fullPath:(NSString *)fullPath;

#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| start | 是 | int | 开始位置(每次返回100条数据) |
| fullPath | 是 | string | 文件的路径 |

#### 返回结果
	{
		count:
		list:
		[
			{
				hash:
				dir:
				fullpath:
				filename:
				filehash:
				filesize:
				create_member_name:
				create_dateline:
				last_member_name:
				last_dateline:
			},
			...
		]
	}
	
| 字段 | 类型 | 说明 |
| --- | --- | --- |
| count | int | 文件总数 |
| list | Array | 格式见下 |
| 字段 | 类型 | 说明 |
| --- | --- | --- |
| hash | string | 文件唯一标识 |
| dir | int | 是否文件夹, 1是, 0否 |
| fullpath | string | 文件路径 |
| filename | string | 文件名称 |
| filehash | string | 文件内容hash, 如果是文件夹, 则为空 |
| filesize | long | 文件大小, 如果是文件夹, 则为0 |
| create_member_name | string | 文件创建人名称 |
| create_dateline | int | 文件创建时间戳 |
| last_member_name | string | 文件最后修改人名称 |
| last_dateline | int | 文件最后修改时间戳 |

---
### 获取更新列表

**swift**

	getUpdateList( isCompare:BOOL, fetchDateline:Int64)
	
**objc**

	getUpdateList:(BOOL)isCompare fetchDateline:(NSInteger)fetchDateline;

#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| mode | 否 | string | 更新模式, 可不传, 当需要返回已删除的文件时使用compare |
| fetchDateline | 是 | int | 13位时间戳, 获取该时间后的数据, 第一次获取用0 |
#### 返回结果
| 字段 | 类型 | 说明 |
| --- | --- | --- |
| fetch_dateline | int | 当前返回数据的最大时间戳（13位精确到毫秒） |
| list | Array | 格式见下 |

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| cmd | int | 当mode=compare 时才会返回cmd字段, 0表示删除, 1表示未删除 |
| hash | string | 文件唯一标识 |
| dir | int | 是否文件夹, 1是, 0否 |
| fullpath | string | 文件路径 |
| filename | string | 文件名称 |
| filehash | string | 文件内容hash, 如果是文件夹, 则为空 |
| filesize | long | 文件大小, 如果是文件夹, 则为0 |
| create_member_name | string | 文件创建人名称 |
| create_dateline | int | 文件创建时间戳 |
| last_member_name | string | 文件最后修改人名称 |
| last_dateline | int | 文件最后修改时间戳 |

---

###文件更新数量

**swift**

	getUpdateCounts( beginDateline:Int64, endDateline:Int64, showDelete:BOOL)
	
**objc**
	
	getUpdateCounts:(NSInteger)beginDateline endDateline:(NSInteger)endDateline showDelete:(BOOL)showDelete;
	
#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| beginDateline | 是 | long | 13位时间戳, 开始时间 |
| endDateline | 是 | long | 13位时间戳, 结束时间 |
| showDelete | 是 | boolean |是否返回删除文件 |

#### 返回结果

	{
		count: 更新数量
	}
---

### 获取文件信息

**swift**

	getFileInfo( fullPath: String,type:NetType)

**objc**

	getFileInfo:(NSString *)fullPath type:NetType;
#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |

| fullPath | 是 | string | 文件路径 |
| type | 是 | NetType | 网络类型 Default为外网，In为内容 |


#### 返回结果

	{
		hash:
		dir:
		fullpath:
		filename:
		filesize:
		create_member_name:
		create_dateline:
		last_member_name:
		last_dateline:
		uri:
	}

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| hash | string | 文件唯一标识 |
| dir | int | 是否文件夹 |
| fullpath | string | 文件路径 |
| filename | string | 文件名称 |
| filehash | string | 文件内容hash |
| filesize | long | 文件大小 |
| create_member_name | string | 文件创建人 |
| create_dateline | int | 文件创建时间戳(10位精确到秒)|
| last_member_name | string | 文件最后修改人 |
| last_dateline | int | 文件最后修改时间戳(10位精确到秒) |
| uri | string | 文件下载地址 |

---
### 创建文件夹
**swift**

	createFolder( fullPath:String,opName:String)

**objc**

	createFolder:(NSString *)fullPath opName:(NSString *)opName;
	
#### 参数 

| 参数 | 必须 | 类型 | 说明 |
|------|------|------|------|
| fullPath | 是 |string| 文件夹路径 |
| opName | 是 | string | 用户名称 |
#### 返回结果

| 字段 | 类型 | 说明 |
|------|------|------|
| hash | string | 文件唯一标识 |
| fullpath | string | 文件夹的路径 |

---
### 通过数据上传（50M以内文件）

**swift**

	createFile(fullPath:String,
	opName: String, data: NSData) 
	
**objc**
	
	createFile:(NSString *)fullPath opName:(NSString *)opName data:(NSData *)data;

#### 参数 
| 参数 | 必须 | 类型 | 说明 |
|------|------|------|------|
| fullPath | 是 | string | 文件路径 |
| opName | 是 | string | 用户名称 |
| data | 是 | NSData | 文件流 |

#### 返回结果
| 字段 | 类型 | 说明 |
|------|------|------|
| hash | string | 文件唯一标识 |
| fullpath | string | 文件路径 |
| filehash | string | 文件内容hash |
| filesize | long | 文件大小 |



---
### 文件分块上传

**swift**
	
	uploadByBlock(localPath:String,fullPath:String,opName:String,opId:Int,overWrite:BOOL,delegate: UploadCallBack)

**objc**

	uploadByBlock:(NSString *)localPath fullPath:(NSString *)fullPath opName:(NSString *)opName opId:(NSInteger)opId overwrite:(BOOL)overwrite delegate:(id <UploadCallBack>)delegate;
#### 参数 
| 参数 | 必须 | 类型 | 说明 |	
|------|------|------|------|
| fullpath | 是 | string | 文件路径 |
| opName | 否 | string |  创建人名称, 如果指定了op_id, 就不需要op_name， |
| opId | 否 | int | 创建人id, 个人库默认是库拥有人id, 如果创建人不是云库用户, 可以用op_name代替,|
| localFilePath | 是 | string | 文件本地路径 |	
| overWrite | 是 | boolean | 是否覆盖同名文件，true为覆盖 |
| callBack | 否 | UploadCallBack | 文件上传回调 |

---
	
### 删除文件

**swift**
	
	del( fullPaths: String, opName: String)

**objc**

	del:(NSString *)fullPaths opName:(NSString *)opName;
	
#### 参数 
| 参数 | 必需 | 类型 | 说明 |
|------|------|------|------|
| fullPaths| 是 |string| 文件路径，如果是多个文件用“｜”符号隔开 |
| opName | 是 | string | 用户名称 |
#### 返回结果
	正常返回 HTTP 200
---

### 根据 Tag 删除文件
**swift**
	
	delByTag( tag: String, opName: String)

**objc**

	delByTag:(NSString *)tag opName:(NSString *)opName;
	
#### 参数 
| 参数 | 必需 | 类型 | 说明 |
|------|------|------|------|
| opName | 否 | string | 操作人名称|
| tag | 是 | string | 根据 tag 删除对应的文件|
#### 返回结果
	正常返回 HTTP 200
---
### 移动文件
**swift**

	move( fullPath: String, destFullPath: String, opName: String)

**objc**

	move:(NSString *)fullPath destFullPath:(NSString *)destFullPath opName:(NSString *)opName;

#### 参数 

| 参数 | 必需 | 类型 | 说明 |
|------|------|------|------|
| fullPath | 是 | string | 要移动文件的路径 |
| destFullPath | 是 | string | 移动后的路径 |
| opName | 是 | string | 用户名称 |

#### 返回结果
	正常返回 HTTP 200
---

### 复制文件
**swift**

	copy( fullPaths: String, destFullPath: String, opName: String)

**objc**

	copy:(NSString *)fullPaths destFullPath:(NSString *)destFullPath opName:(NSString *)opName;

#### 参数 

| 参数 | 必需 | 类型 | 说明 |
|------|------|------|------|
| fullPaths | 是 | string | 源文件路径,如果是多个文件用“｜”符号隔开 |
| destFullPath | 是 | string | 目标文件路径(不含文件名称)|
| opName | 是 | string | 用户名称 |

#### 返回结果
	正常返回 HTTP 200
---

### 复制文件(拷贝 tag 与操作人属性)
**swift**

	copyAll( fullPaths: String, destFullPath: String, opName: String)

**objc**

	copyAll:(NSString *)fullPaths destFullPath:(NSString *)destFullPath;

#### 参数 

| 参数 | 必需 | 类型 | 说明 |
|------|------|------|------|
| fullPaths | 是 | string | 源文件路径,如果是多个文件用“｜”符号隔开 |
| destFullPath | 是 | string | 目标文件路径(不含文件名称)|

#### 返回结果
	正常返回 HTTP 200
---


### 获取文件链接
**swift**

	link( fullPath: String, deadline:Int, authType: AuthType, password: String)
	
**objc**

	link:(NSString *)fullPath deadline:(NSInteger)deadline authType:(enum AuthType)authType password:(NSString *)password;

#### 参数 
| 参数 | 必需 | 类型 | 说明 |
|------|------|------|------|
| fullPath | 是 | string | 文件路径 |	
| deadline | 否 | int | 10位链接失效的时间戳 ，永久传－1 |
| authtype | 是 | enum | 文件访问权限DEFAULT默认为预览，PREVIEW：预览，DOWNLOAD：下载、预览，UPLOAD：上传、下载、预览｜	
| password | 否 | string | 密码，不过不设置密码，传null |


#### 返回结果

    {
    "link": "外链地址"
    }


### 发送消息
**swift**

	sendmsg( title: String,
	text: String, image: String, linkUrl: String, opName: String) 

**objc**
	
	sendmsg:(NSString *)title text:(NSString *)text image:(NSString *)image linkUrl:(NSString *)linkUrl opName:(NSString *)opName;

#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| title | 是 | string | 消息标题 |
| text | 是 | string | 消息正文 |
| image | 否 | string | 图片url |
| linkUrl | 否 | string | 链接 |
| opName | 是 | string | 用户名称 |
#### 返回结果
	正常返回 HTTP 200 
---

### 获取当前库所有外链

**swift**

	links( boolean fileOnly)
	
**objc**

	links:(BOOL)fileOnly;
#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| fileOnly | 是 | boolean | 是否只返回文件, 1只返回文件 |
#### 返回结果
	[
		{
		    "filename": 文件名或文件夹名,
		    "filesize": 文件大小,
    		"link": 文件外链地址,
    		"deadline": 到期时间戳 -1表示永久有效,
    		"password": 是否加密, 1加密, 0无
    	},
    	...
	]

---

### 通过链接上传文件

**swift**

	createFileByUrl(fullpath:String, opId:Int, opName:String, overwrite:Bool, url: String)
	
**objc**
	
	createFileByUrl:(NSString *)fullPath opId:(NSInteger)opId opName:(NSString *)opName overwrite:(BOOL)overwrite fileUrl:(NSString *)fileUrl;

#### 参数 
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| fullpath | 是 | string | 文件路径 |
| opId | 否 | int | 创建人id, 个人库默认是库拥有人id, 如果创建人不是云库用户, 可以用op_name代替|
| opName | 否 | string | 创建人名称, 如果指定了opId, 就不需要opName|
| overwrite | 是 | boolean | 是否覆盖同名文件, true覆盖(默认) false不覆盖,文件名后增加数字标识|
| url | 是 | string | 需要服务端获取的文件url|

#### 返回结果
	正常返回 HTTP 200 

---

###WEB直接上传文件

**swift**

	getUploadServers()

**objc**
	
	getUploadServers

#### 参数 

(无)

#### 返回结果
	{
       "upload":
       [
          上传服务器地址 如:http://upload.domain.com,
         ...
       ]
	}

---

## 条件配置(ConfigHelper.swift)
###构造方法
**swift**

	ConfigHelper()

**objc**

	[[ConfigHelper alloc]init]

### 修改认证地址
**swift**

	oauthHost(oauthHost:String)

**objc**

	oauthHost:(NSString *) oauthHost
#### 参数
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| authHost | 是 | string | 认证使用的地址 |

### 修改 API 地址
**swift**

	apiHost(apiHost:String)

**objc**

	apiHost:(NSString *) apiHost
#### 参数
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| authHost | 是 | string | API 使用的地址 |

---
### 设置上传根目录
**swift**

	uploadRootPath(rootPath:String)

**objc**

	uploadRootPath:(NSString *) rootPath
#### 参数
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| rootPath | 是 | string | 上传默认路径，在原有上传路径上添加上传前缀，例如上传路径为 uploadPath，则路径变为 "rootPath/uploadPath"|

---


### 设置默认上传文件标签
**swift**

	uploadFileTags(tags:String)

**objc**

	uploadFileTags:(NSString *) tags
#### 参数
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| tags | 是 | string| 设置上传时，默认使用的 tag,如果是多个文件用“｜”符号隔开 |
---
### 设置默认上传操作人
**swift**

	uploadOpName(opName:String)

**objc**

	uploadOpName:(NSString *) opName
	
#### 参数
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| opName | 是 | string| 设置默认上传时操作人的名字 |
---
### 设置代理方法
>未实现

### 修改 USERAGENT
**swift**

	userAgent(userAgent:String)

**objc**

	userAgent:(NSString *) userAgent
#### 参数
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| userAgent | 是 | string| 更改使用的 UserAgent 值 |
---

### 修改接口语言环境
**swift**

	language(language:String)

**objc**

	language:(NSString *) language
	
#### 参数
| 名称 | 必需 | 类型 | 说明 |
| --- | --- | --- | --- |
| language | 是 | string| 修改接口语言环境，默认获取系统的语言环境, 现只支持 ZH 和 US 两种语言 |
---



## SDK日志（Config.swift）

### 设置是否打印SDK日志
**swift**
  
	static logPrint

**objc**

	setLogPrint:(BOOL)value;

### 设置打印日志的级别

**swift**
  
	static logPrint
	
	LogLevel.Info
	LogLevel.Warning
	LogLevel.Error
	
**objc**
  
	setLogLevel:(enum LogLevel)value;
	
	LogLevelInfo //info级别以上的所有日志
	LogLevelWarning //warning级别以上的所有日志
	LogLevelError //error级别的日志
	
## 常见错误

>header '/usr/include/CommonCrypto/CommonCrypto.h' not found

这个有可能是本地没有这个文件，可以尝试更换成类似 “/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS8.0.sdk/usr/include/CommonCrypto/CommonCrypto.h” ，这个路径会根据不同环境变化，需要先确保能在机子这个路径上找到这个文件，然后将路径替换成你的本地 CommonCrypto.h 这个文件的全路径
