//
//  RegisterCusViewController.h
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/10/29.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterCusViewController : BBBaseViewController

// 注册方式数组（从登录页面传递过来）
@property (nonatomic, strong) NSMutableArray<NSNumber *> *registerArr;

@end

NS_ASSUME_NONNULL_END
