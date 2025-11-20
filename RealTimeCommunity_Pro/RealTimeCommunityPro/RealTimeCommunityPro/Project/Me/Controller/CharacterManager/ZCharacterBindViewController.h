//
//  ZCharacterBindViewController.h
//  CIMKit
//
//  Created by cusPro on 2023/9/15.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCharacterBindViewController : BBBaseViewController

//绑定结果
@property (nonatomic, copy) void(^chartManageBindResult)(BOOL result);
//yuuee账号
@property (nonatomic, copy) NSString *account;

@property (nonatomic, assign) BOOL isBinded;

@end

NS_ASSUME_NONNULL_END
