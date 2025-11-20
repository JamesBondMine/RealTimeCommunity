//
//  TeamTeamTotalNumberListVC.h
//  CIMKit
//
//  Created by cusPro on 2025/7/23.
//

#import <Foundation/Foundation.h>
#import "BBBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

/// 踢人后，在返回时需要记录下刷新记号
typedef void(^HadTickOutPeopleBlock)(void);
@interface TeamTeamTotalNumberListVC : BBBaseViewController

@property (nonatomic, copy) NSString *teamId;

@property (nonatomic, copy) HadTickOutPeopleBlock hadTickOutPeopleBlock;

@end

NS_ASSUME_NONNULL_END
