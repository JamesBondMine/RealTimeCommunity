//
//  NFFriendManageVC.h
//  CIMKit
//
//  Created by cusPro on 2022/10/22.
//

// 好友管理VC

#import "BBBaseViewController.h"
#import "ZUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NFFriendManageVC : BBBaseViewController
@property (nonatomic, strong) ZUserModel *userModel;
@property (nonatomic, copy) NSString *friendUID;
@end

NS_ASSUME_NONNULL_END
