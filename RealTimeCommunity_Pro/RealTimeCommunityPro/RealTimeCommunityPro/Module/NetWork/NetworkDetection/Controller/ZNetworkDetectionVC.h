//
//  ZNetworkDetectionVC.h
//  RealTimeCommunityPro
//
//  Created by phl on 2025/10/15.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZNetworkDetectionVC : BBBaseViewController

/// 当前企业号(未登录时可为空)
@property (nonatomic, copy, nullable) NSString *currentSsoNumber;

@end

NS_ASSUME_NONNULL_END
