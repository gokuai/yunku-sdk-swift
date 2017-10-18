//
//  gkapis.swift
//  gknet
//
//  Created by wqc on 2017/7/28.
//  Copyright © 2017年 wqc. All rights reserved.
//

import Foundation

struct GYKAPI {
    
    static let OAUTH_TOKEN          = "/oauth2/token2"
    static let SOURCE_INFO          = "/1/config/source"
    static let ACCOUNT_INFO         = "/1/account/info"
    static let ENTS                 = "/1/account/ent"
    static let MOUNTS               = "/1/account/mount"
    static let SHORTCUTS            = "/1/member/get_shortcuts"
    
    static let MOUNT_INFO           = "/library/info"
    
    static let FAVORITE_FILES       = "/1/file/favorites"
    static let CREATE_FOLDER        = "/1/file/create_folder"
    static let CREATE_FILE          = "/2/file/create_file"
    static let GET_DOWNLOAD_URL     = "/1/file/download_url"
    static let GET_SERVER_SITE      = "/1/account/servers"
    static let FILE_LOCK            = "/1/file/lock"
    
    
    static let ENT_MEMBER_LIST      = "/1/ent/get_members"
    static let ENT_MEMBER_INFO      = "/1/ent/get_member"
    static let ENT_MEMBER_INFO_OUT  = "/1/ent/get_member_by_out_id"
    static let ENT_ROLES            = "/1/ent/get_roles"
    static let ENT_GROUPS           = "/1/ent/get_groups"
    static let ENT_GROUP_MEMBER     = "/1/ent/get_group_members"
    static let ENT_ADD_SYNC_MEMBER  = "/1/ent/add_sync_member"
    static let ENT_DEL_SYNC_MEMBER  = "/1/ent/del_sync_member"
    static let ENT_ADD_SYNC_GROUP   = "/1/ent/add_sync_group"
    static let ENT_DEL_SYNC_GROUP   = "/1/ent/del_sync_group"
    static let ENT_ADD_GROUP_SYNC_MEMBER   = "/1/ent/add_sync_group_member"
    static let ENT_DEL_GROUP_SYNC_MEMBER   = "/1/ent/del_sync_group_member"
    static let ENT_DEL_MEMBER_GROUPS   = "/1/ent/del_sync_member_group"
    static let ENT_ADD_MANAGER      = "/1/ent/add_sync_admin"
    
    
    static let CREATE_ORG           = "/1/org/create"
    static let CONFIG_ORG           = "/1/org/set"
    static let ORG_INFO             = "/1/org/info"
    static let ORG_LIST             = "/1/org/ls"
    static let ORG_BIND             = "/1/org/bind"
    static let ORG_MEMBERS          = "/1/org/get_members"
    static let ORG_MEMBER_INFO      = "/1/org/get_member"
    static let ORG_ADDMEMBER        = "/1/org/add_member"
    static let ORG_SET_MEMBER_ROLE  = "/1/org/set_member_role"
    static let ORG_DELMEMBER        = "/1/org/del_member"
    static let ORG_GROUP_LIST       = "/1/org/get_groups"
    static let ORG_ADD_GROUP        = "/1/org/add_group"
    static let ORG_DEL_GROUP        = "/1/org/del_group"
    static let ORG_SET_GROUP_ROLE   = "/1/org/set_group_role"
    static let ORG_DELETE           = "/1/org/destroy"
    static let ORG_LOG              = "/1/org/log"
    
    static let FILE_LIST            = "/1/file/ls"
    static let FILE_UPDATES         = "/1/file/updates"
    static let FILE_UPDATE_COUNT    = "/1/file/updates_count"
    static let FILE_INFO            = "/1/file/info"
    static let FILE_SEARCH          = "/1/file/search"
    static let FILE_DOWNLOAD_URL    = "/1/file/download_url"
    static let FILE_PREVIEW_URL     = "/1/file/preview_url"
    static let FILE_COPY            = "/1/file/copy"
    static let FILE_COPYEX          = "/1/file/mcopy"
    static let FILE_MOVE            = "/1/file/move"
    static let FILE_SAVE            = "/2/file/save"
    static let FILE_RENAME          = "/1/file/rename"
    static let FILE_DELETE          = "/1/file/del"
    static let FILE_DELETE_COMPLETE = "/1/file/del_completely"
    static let FILE_RECYCLE         = "/1/file/recycle"
    static let FILE_RECOVER         = "/1/file/recover"
    static let FILE_LINK            = "/1/file/link"
    static let FILE_LINKS           = "/1/file/links"
    static let FILE_UPDATE_LINK     = "/1/file/update_file_link"
    static let FILE_CLOSE_LINK      = "/1/file/close_file_link"
    static let FILE_ADD_TAG         = "/1/file/add_tag"
    static let FILE_DEL_TAG         = "/1/file/del_tag"
    static let FILE_CREATE          = "/1/file/create_file"
    static let FILE_CREATE_URL      = "/1/file/create_file_by_url"
    static let FILE_UPLOAD_SERVERS  = "/1/file/upload_servers"
}
