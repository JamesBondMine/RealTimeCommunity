//
//  LingIMSDKManager+Logan.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/5/17.
//

#import "LingIMSDKManager+Logan.h"

@implementation LingIMSDKManager (Logan)

#pragma mark - 配置日志信息
- (void)imSdkOpenLoganWith:(LingIMLoganOption *)loganOption {
    if (loganOption) {
        [[LingIMLoganManager sharedManager] configLoganOption:loganOption];
        [LingIMUncaughtExceptionHandler setUncaughtExceptionHandler];
        [LingIMSignalExceptionHandler setSignalExceptionHandler];
    }
}

- (void)configLoganLiceseId:(NSString *)loganLiceseId {
    [[LingIMLoganManager sharedManager] configLoganLiceseId:loganLiceseId];
}

#pragma mark - 写入日志
- (void)imSdkWriteLoganWith:(LingIMLoganType)loganType loganContent:(NSString *)loganContent {
    [[LingIMLoganManager sharedManager] writeLoganWith:loganType loganContent:loganContent];
}

#pragma mark - 上传日志
- (void)imSdkUploadLoganWith:(NSString *)loganDate complete:(LingIMSDKLoganUpload)aComplete {
    [[LingIMLoganManager sharedManager] loganUploadWith:loganDate complete:aComplete];
}

#pragma mark - 清空日志模块用户信息
- (void)imSdkClearLoganOption {
    [[LingIMLoganManager sharedManager] clearLoganUserInfo];
}

@end

