//
//  ZFileUploadGetSTSTask.h
//  CIMKit
//
//  Created by cusPro on 2024/8/23.
//

#import <Foundation/Foundation.h>
#import "ZFileUploadTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFileUploadGetSTSTask : NSOperation

@property (nonatomic, strong) NSArray<ZFileUploadTask *> * uploadTask;

@end

NS_ASSUME_NONNULL_END
