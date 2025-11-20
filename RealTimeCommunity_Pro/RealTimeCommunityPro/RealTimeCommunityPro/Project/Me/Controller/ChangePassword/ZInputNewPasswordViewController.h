//
//  ZInputNewPasswordViewController.h
//  CIMKit
//
//  Created by cusPro on 2022/11/13.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZInputNewPasswordViewController : BBBaseViewController

@property (nonatomic, assign) BOOL isForcedReset; // 是否强制重置，控制返回按钮与手势

@end

NS_ASSUME_NONNULL_END
