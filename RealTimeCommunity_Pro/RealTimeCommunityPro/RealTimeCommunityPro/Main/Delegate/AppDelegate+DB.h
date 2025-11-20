//
//  AppDelegate+DB.h
//  CIMKit
//
//  Created by cusPro on 2022/10/26.
//

#import "AppDelegate.h"
#import "NTTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (DB)
<
CIMToolUserDelegate,
CIMToolConnectDelegate,
CIMToolMessageDelegate,
CIMToolSessionDelegate
>

//配置SDK
- (void)configDB;

@end

NS_ASSUME_NONNULL_END
