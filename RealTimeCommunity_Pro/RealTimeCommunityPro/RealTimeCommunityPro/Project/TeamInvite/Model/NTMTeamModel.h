//
//  NTMTeamModel.h
//  CIMKit
//
//  Created by cusPro on 2023/7/24.
//

#import "ZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NTMTeamModel : ZBaseModel
/// 团队ID
@property (nonatomic, copy) NSString *teamId;

/// 团队名称
@property (nonatomic, copy) NSString *teamName;

/// 邀请码
@property (nonatomic, copy) NSString *inviteCode;

/// 下载链接
@property (nonatomic, copy) NSString *registerHtml;

/// 是否是默认团队(0否1是)
@property (nonatomic, assign) NSInteger isDefaultTeam;

/// 团队总人数
@property (nonatomic, assign) NSInteger totalInviteNum;

/// 今日邀请
@property (nonatomic, assign) NSInteger todayInviteNum;

/// 昨日邀请
@property (nonatomic, assign) NSInteger yesterdayInviteNum;

/// 本月邀请
@property (nonatomic, assign) NSInteger mouthInviteCount;

/// 团队关联群聊数
@property (nonatomic, assign) NSInteger groupNum;

/// 是否是系统创建团队(0否1是)
@property (nonatomic, assign) NSInteger isSystemCreate;

/// 是否选中
@property (nonatomic, assign) BOOL selectedModel;

@end

NS_ASSUME_NONNULL_END
