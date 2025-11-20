//
//  ZFileDownloadManager.m
//  CIMKit
//
//  Created by cusPro on 2024/3/9.
//

#import "ZFileDownloadManager.h"
#import "ZFileOssInfoModel.h"

@interface ZFileDownloadManager ()

//任务缓存队列，存放 暂停，失败，完成的任务
@property (nonatomic, strong) NSMutableArray <ZFileDownloadTask *> * taskCache;

@end

@implementation ZFileDownloadManager

SharedInstance(ZFileDownloadManager)

- (void)addDownloadTask:(ZFileDownloadTask *)task {
    if(![self.operationQueue.operations containsObject:task]){
        [task addDelegate:self];
        [self.operationQueue addOperation:task];
    }
}

- (ZFileDownloadTask *)getTaskWithId:(NSString *)taskId{
    ZFileDownloadTask * downloadTask;
       for (ZFileDownloadTask * task in self.operationQueue.operations) {
           if ([task isKindOfClass:[ZFileDownloadTask class]] &&[task.taskId isEqualToString:taskId]) {
               downloadTask = task;
           }
       }
       if(downloadTask == nil){
           for (ZFileDownloadTask * task in self.taskCache) {
               if ([task isKindOfClass:[ZFileDownloadTask class]] &&[task.taskId isEqualToString:taskId]) {
                   downloadTask = task;
               }
           }
       }
       return downloadTask;
}

#pragma mark- --------<ZFileUploadTaskDelegate>--------
- (void)fileDownloadTask:(ZFileDownloadTask *)task didChangTaskProgress:(float)progress {
    
}

- (void)fileDownloadTask:(ZFileDownloadTask *)task didChangTaskStatus:(FileDownloadTaskStatus)status error:(NSError *)error {
    if((status == FileDownloadTaskStatus_Failed ||
        status == FileDownloadTaskStatus_Completed) &&
       ![self.taskCache containsObject:task]){
        [self.taskCache addObject:task];
    }
}

-(NSOperationQueue *)operationQueue{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 5; // Default value
    }
    return _operationQueue;
}

-(NSMutableArray<ZFileDownloadTask *> *)taskCache{
    if (_taskCache == nil) {
        _taskCache = [[NSMutableArray alloc] init];
    }
    return _taskCache;
}


@end
