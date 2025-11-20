//
//  ZSafeCodeAuthViewController.h
//  CIMKit
//
//  Created by cusPro on 2024/12/30.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSafeCodeAuthViewController : BBBaseViewController

@property (nonatomic, copy)NSString *loginInfo;
@property (nonatomic, assign)int loginType;
@property (nonatomic, copy)NSString *scKey;

@end

NS_ASSUME_NONNULL_END
