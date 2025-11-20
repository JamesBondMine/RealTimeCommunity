//
//  LingIMSDKManager+Stickers.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/10/27.
//

#import "LingIMSDKManager+Stickers.h"
#import "LingIMHttpManager+Stickers.h"

@implementation LingIMSDKManager (Stickers)

/// 接口
#pragma mark - 获取收藏表情列表
- (void)imSdkUserGetCollectStickersList:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userGetCollectStickersList:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 添加表情到收藏列表
- (void)imSdkUserAddStickersToCollectList:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userAddStickersToCollectList:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 从收藏列表移除表情
- (void)imSdkUserRemoveStickersFromCollectList:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userRemoveStickersFromCollectList:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 根据表情名称获取表情列表
- (void)imSdkUserFindStickersForName:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userFindStickersForName:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 添加表情包
- (void)imSdkUserAddStickersPackage:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userAddStickersPackage:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 获取表情包列表 - 用户未下载的表情包
- (void)imSdkUserFindUnUsedStickersPackageList:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userFindUnUsedStickersPackageList:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 获取表情包列表 - 用户正在使用的表情包列表
- (void)imSdkUserFindUsedStickersPackageList:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userFindUsedStickersPackageList:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 获取表情包表情详情
- (void)imSdkUserGetStickersPackageDetail:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userGetStickersPackageDetail:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 根据表情ID查询表情包 - 当前有效的唯一表情包
- (void)imSdkUserGetPackageFromStickersId:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] userGetPackageFromStickersId:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 移除表情包
- (void)imSdkUserRemoveusedStickersPackage:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
 
    [[LingIMHttpManager sharedManager] userRemoveusedStickersPackage:params onSuccess:onSuccess onFailure:onFailure];
}

@end
