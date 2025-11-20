//
//  LingIMSocketManagerTool+HandleReceiveTcpReplaceHttpMessage.h
//  NoaChatSDKCore
//
//  Created by phl on 2025/8/25.
//

#import "LingIMSocketManagerTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface LingIMSocketManagerTool (HandleReceiveTcpReplaceHttpMessage)

/// MARK: 接收消息处理
- (void)receiveTcpReplaceHttpMessageDealWith:(IMMessage *)receiveMessage;

@end

NS_ASSUME_NONNULL_END
