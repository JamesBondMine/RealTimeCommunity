//
//  ZSafeCodeCloseViewController.h
//  CIMKit
//
//  Created by cusPro on 2025/1/2.
//

#import "BBBaseViewController.h"

@class NMSafeSettingViewController;

NS_ASSUME_NONNULL_BEGIN

//手势密码验证类型
typedef NS_ENUM(NSUInteger, SafeCodeOperatorType) {
    SafeCodeOperatorTypeClose = 1,       //关闭验证（验证原安全码）
    SafeCodeOperatorTypePassword = 2,    //关闭验证（验证登录密码）
};

@interface ZSafeCodeCloseViewController : BBBaseViewController

@property (nonatomic, assign) SafeCodeOperatorType operatorType;


@end

NS_ASSUME_NONNULL_END
