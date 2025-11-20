//
//  LingIMSDKManager+Logan.h
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/5/17.
//

// 日志模块

#import "LingIMSDKManager.h"
#import "LingIMLoganHeader.h"

NS_ASSUME_NONNULL_BEGIN

//日志上传服务器回调
typedef void (^LingIMSDKLoganUpload)(NSError * _Nullable error);

@interface LingIMSDKManager (Logan)
//开启日志
- (void)imSdkOpenLoganWith:(LingIMLoganOption *)loganOption;

//传入liceseID
- (void)configLoganLiceseId:(NSString *)loganLiceseId;

// 写入日志
// loganType: 日志类型
// loganContent: 日志信息
- (void)imSdkWriteLoganWith:(LingIMLoganType)loganType loganContent:(NSString * _Nullable)loganContent;

// 上传日志到服务器
- (void)imSdkUploadLoganWith:(NSString *)loganDate complete:(LingIMSDKLoganUpload)aComplete;

// 清空日志模块用户信息
- (void)imSdkClearLoganOption;

@end

NS_ASSUME_NONNULL_END
