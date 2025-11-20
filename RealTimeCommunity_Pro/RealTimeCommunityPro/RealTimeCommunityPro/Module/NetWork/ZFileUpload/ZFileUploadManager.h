//
//  ZFileUploadManager.h
//  CIMKit
//
//  Created by cusPro on 2024/3/9.
//

#import <Foundation/Foundation.h>
#import "ZFileUploadTask.h"
#import "ModuleProtocol.h"
#import "ZFileOssInfoModel.h"
#import "ZFileUploadGetSTSTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFileUploadManager : NSObject<ModuleProtocol,ZFileUploadTaskDelegate>

//需要执行的任务队列
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, assign) NSInteger maxConcurrentUploads;

//STSInfo
@property (nonatomic, strong) ZFileOssInfoModel * stsInfo;

- (void)addUploadTask:(ZFileUploadTask *)task;

- (ZFileUploadTask *)getTaskWithId:(NSString *)taskId;


@end

NS_ASSUME_NONNULL_END
