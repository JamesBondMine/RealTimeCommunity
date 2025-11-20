//
//  ZMessageSendTask.h
//  CIMKit
//
//  Created by cusPro on 2024/3/8.
//

#import <Foundation/Foundation.h>
#import "ZFileUploadTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMessageSendTask : NSOperation

//要发送的消息
@property (nonatomic, strong) NSArray<ZFileUploadTask *> * uploadTask;

@end

NS_ASSUME_NONNULL_END
