//
//  LingIMSocketManagerTool.h
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/5/22.
//

// Socket消息业务管理类

#define SOCKETMANAGERTOOL [LingIMSocketManagerTool sharedManager]

#import <Foundation/Foundation.h>

#import "LingIMProtocol.h"//代理

NS_ASSUME_NONNULL_BEGIN


@interface LingIMSocketManagerTool : NSObject

//连接代理
@property (nonatomic, weak) id <CIMConnectDelegate> connectDelegate;
//消息代理
@property (nonatomic, weak) id <CIMMessageDelegate> messageDelegate;
//用户代理
@property (nonatomic, weak) id <CIMUserDelegate> userDelegate;
//群组代理
@property (nonatomic, weak) id <CIMGroupDelegate> groupDelegate;
//本次长连接，用户鉴权成功后，socket的唯一标识
@property (nonatomic, copy) NSString *socketUUID;
//app的Build ID
@property (nonatomic, copy) NSString *appBuildIdStr;

#pragma mark - <<<<<<单例>>>>>>
+ (instancetype)sharedManager;


/// 正在连接服务器
- (void)cimConnecting;

/// 连接服务器成功
- (void)cimConnectSuccess;

/// 重连服务器成功
- (void)cimReConnectSuccess;

/// 连接成功后，拿到了session_id，认为才是真正的成功
- (void)cimGetSessionIdSuccess;

/// 连接服务器失败
/// @param error 错误信息
- (void)cimConnectFailWithError:(NSError * _Nullable)error;

/// 断开服务器连接(告知需要竞速)
- (void)cimDisconnect;

/// ECDH 密钥交换完成
/// @param sessionKey 会话密钥
- (void)ecdhKeyExchangeCompleted:(NSData *)sessionKey;

/// ECDH 密钥交换失败
/// @param error 错误信息
- (void)ecdhKeyExchangeFailed:(NSError *)error;


#pragma mark - <<<<<<业务>>>>>>
/// 发送消息处理
/// - Parameter sendMessage: 发送的消息
- (void)sendMessageDealWith:(IMMessage *)sendMessage;

/// 接收消息处理
/// - Parameter receiveMessage: 接收的消息
- (void)receiveMessageDealWith:(IMMessage *)receiveMessage;

@end

NS_ASSUME_NONNULL_END
