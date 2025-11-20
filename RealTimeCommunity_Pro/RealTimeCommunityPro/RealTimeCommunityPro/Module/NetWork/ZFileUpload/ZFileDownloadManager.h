//
//  ZFileDownloadManager.h
//  CIMKit
//
//  Created by cusPro on 2024/3/9.
//

#import <Foundation/Foundation.h>
#import "ZFileDownloadTask.h"
#import "ModuleProtocol.h"

@interface ZFileDownloadManager : NSObject<ModuleProtocol, ZFileDownloadTaskDelegate>

//需要执行的任务队列
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, assign) NSInteger maxConcurrentUploads;

- (void)addDownloadTask:(ZFileDownloadTask *)task;

- (ZFileDownloadTask *)getTaskWithId:(NSString *)taskId;


@end

