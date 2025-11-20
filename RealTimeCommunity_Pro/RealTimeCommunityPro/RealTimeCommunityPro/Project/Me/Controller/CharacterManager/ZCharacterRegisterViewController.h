//
//  ZCharacterRegisterViewController.h
//  CIMKit
//
//  Created by cusPro on 2023/9/15.
//

#import "BBBaseViewController.h"

@class ZCharacterManagerViewController;

NS_ASSUME_NONNULL_BEGIN

@interface ZCharacterRegisterViewController : BBBaseViewController

@property (nonatomic, assign) BOOL isFromBind;
@property (nonatomic, assign) BOOL isBinded;
//注册登录绑定结果
@property (nonatomic, copy) void(^chartManageBindResult)(BOOL result);

@end

NS_ASSUME_NONNULL_END
