//
//  LoginProxyInputViewViewController.h
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/11/8.
//

#import "BBBaseViewController.h"
#import "ZProxySettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginProxyInputViewViewController : BBBaseViewController

/// 初始化方法
/// @param proxyType 代理类型（HTTP 或 SOCKS5）
- (instancetype)initWithProxyType:(ProxyType)proxyType;

/// 取消回调（返回上一页时执行）
@property (nonatomic, copy) void(^cancleCallback)(void);

@end

NS_ASSUME_NONNULL_END
