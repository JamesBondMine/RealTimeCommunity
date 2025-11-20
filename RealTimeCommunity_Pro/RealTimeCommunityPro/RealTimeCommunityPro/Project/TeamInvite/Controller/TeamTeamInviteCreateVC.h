//
//  TeamTeamInviteCreateVC.h
//  CIMKit
//
//  Created by phl on 2025/7/22.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CreateGroupSuccessHandle)(void);
@interface TeamTeamInviteCreateVC : BBBaseViewController

/// 创建团队成功，返回刷新页面
@property (nonatomic, copy) CreateGroupSuccessHandle createGroupSuccessHandle;

@end

NS_ASSUME_NONNULL_END
