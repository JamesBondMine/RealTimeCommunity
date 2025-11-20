//
//  NSSessionReadTool.h
//  CIMKit
//
//  Created by cusPro on 2024/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSessionReadTool : NSObject

+ (void)updateSessionReadNumSMsgIdWithSessionId:(NSString *)sessionId lastSMsgId:(NSString *)lastSMsgId;

+ (void)updateAllSessionReadNumSMsgIdLastSMsgId:(NSString *)lastSMsgId;

+ (NSString *)getLastSMsgIdWithSessionId:(NSString *)sessionId;

@end

NS_ASSUME_NONNULL_END
