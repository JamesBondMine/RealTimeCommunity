//
//  LingIMSDKManager+Connect.h
//  NoaChatSDKCore
//
//  Created by cusPro on 2022/11/5.
//

#import "LingIMSDKManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LingIMSDKManager (Connect)

/// SDK连接状态
- (BOOL)connectState;

/// 退出账号
- (void)toolLogoutAccount;

/// 主动断开socket连接(会自动重连，主要用于账号退出后，主动断开socket连接，避免收到上一个账号的消息)
- (void)toolDisconnectCanReconnect;

/// 主动断开socket连接(不会自动重连，主要用于在企业号登录页面，主动断开socket连接，并且直到竞速后，重新连接)
- (void)toolDisconnectNoReconnect;

@end

NS_ASSUME_NONNULL_END
