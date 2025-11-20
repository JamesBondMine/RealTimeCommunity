//
//  TeamTeamInviteDetailVC.h
//  CIMKit
//
//  Created by phl on 2025/7/24.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class NTMTeamModel;

typedef void(^ReloadDataBlock)(void);
@interface TeamTeamInviteDetailVC : BBBaseViewController

/// 从上个页面传入的团队信息
@property (nonatomic, strong, readwrite) NTMTeamModel *currentTeamModel;

/// 从上个页面传入的团队信息
@property (nonatomic, copy) ReloadDataBlock reloadDataBlock;

@end

NS_ASSUME_NONNULL_END
