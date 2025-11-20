//
//  AppDelegate+MediaCall.h
//  CIMKit
//
//  Created by cusPro on 2023/5/29.
//

// 音视频通话 相关处理

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (MediaCall)
<LingIMMediaCallDelegate>

- (void)configMediaCall;
@end

NS_ASSUME_NONNULL_END
