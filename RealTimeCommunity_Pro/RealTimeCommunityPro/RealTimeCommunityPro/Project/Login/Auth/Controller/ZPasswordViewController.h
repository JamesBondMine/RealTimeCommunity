//
//  ZPasswordViewController.h
//  CIMKit
//
//  Created by cusPro on 2022/9/19.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZPasswordViewController : BBBaseViewController

@property (nonatomic, strong)NSString *areaCode;
@property (nonatomic, strong)NSString *loginInfo;

//这里改成枚举
@property (nonatomic, assign)int loginType;
@property (nonatomic, assign)BOOL pwdExit;

@end

NS_ASSUME_NONNULL_END
