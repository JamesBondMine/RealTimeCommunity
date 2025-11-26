//
//  ZUserRoleAuthorityModel.h
//  CIMKit
//
//  Created by cusPro on 2023/11/9.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZUsereAuthModel : ZBaseModel

@property (nonatomic, copy) NSString *authorityKey; //权限key
@property (nonatomic, copy) NSString *configData;   //权限配置数据
@property (nonatomic, copy) NSString *configValue;  //权限配置内容

@end


@interface ZUserRoleAuthorityModel : ZBaseModel

@property (nonatomic, strong) ZUsereAuthModel *allowAddFriend;          //允许添加好友
@property (nonatomic, strong) ZUsereAuthModel *createGroup;             //创建群组
@property (nonatomic, strong) ZUsereAuthModel *deleteMessage;           //删除消息
@property (nonatomic, strong) ZUsereAuthModel *remoteDeleteMessage;     //远程销毁
@property (nonatomic, strong) ZUsereAuthModel *groupHairAssistant;      //群发助手
@property (nonatomic, strong) ZUsereAuthModel *groupSecurity;           //群私密
@property (nonatomic, strong) ZUsereAuthModel *showGroupPersonNum;      //查看群人数
@property (nonatomic, strong) ZUsereAuthModel *showHeadLogo;            //显示头像标识
@property (nonatomic, strong) ZUsereAuthModel *showRoleName;            //角色名称
@property (nonatomic, strong) ZUsereAuthModel *upFile;                  //是否可传输文件及传输最大值
@property (nonatomic, strong) ZUsereAuthModel *showTeam;                //是否显示 团队管理 和 分享邀请
@property (nonatomic, strong) ZUsereAuthModel *upImageVideoFile;        //是否可传输图片/视频及传输最大值
@property (nonatomic, strong) ZUsereAuthModel *showUserRead;            //聊天消息页面中 是否显示消息旁边的已读状态
@property (nonatomic, strong) ZUsereAuthModel *isShowFileAssistant;     //是否显示文件助手(会话列表、通讯录顶部)

/// 翻译设置总开关（后端字段：translation_switch）
@property (nonatomic, strong) ZUsereAuthModel *translationSwitch;

/// 群消息置顶开关（后端字段：group_msg_pinning）
@property (nonatomic, strong) ZUsereAuthModel *groupMsgPinning;

@end

NS_ASSUME_NONNULL_END
