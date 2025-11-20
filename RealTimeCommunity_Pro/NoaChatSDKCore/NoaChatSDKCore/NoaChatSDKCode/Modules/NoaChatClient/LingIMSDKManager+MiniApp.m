//
//  LingIMSDKManager+MiniApp.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/7/21.
//

#import "LingIMSDKManager+MiniApp.h"
#import "LingIMHttpManager+MiniApp.h"

@implementation LingIMSDKManager (MiniApp)

#pragma mark - 获取我的 浮窗小程序 列表
- (NSArray <LingFloatMiniAppModel *> *)imSdkGetMyFloatMiniAppList {
    return [DBTOOL getMyFloatMiniAppList];
}

#pragma mark - 浮窗小程序 新增/更新
- (BOOL)imSdkInsertFloatMiniAppWith:(LingFloatMiniAppModel *)miniAppModel {
    return [DBTOOL insertFloatMiniAppWith:miniAppModel];
}

#pragma mark - 删除浮窗小程序
- (BOOL)imSdkDeleteFloatMiniAppWith:(NSString *)miniAppID {
    return [DBTOOL deleteFloatMiniAppWith:miniAppID];
}

#pragma mark - 删除全部浮窗小程序
- (BOOL)imSdkDeleteAllFloatMiniApp {
    //清空某个表里的全部数据
    return [DBTOOL deleteAllObjectWithName:CIMDBFloatMiniAppTableName];
    //删除某个表
    //return [DBTOOL dropTableWithName:CIMDBMiniAppTableName];
}

/******* 相关接口 *******/
#pragma mark - 获取快应用列表
- (void)imMiniAppListWith:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] miniAppListWith:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 创建快应用
- (void)imMiniAppCreateWith:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] miniAppCreateWith:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 编辑快应用
- (void)imMiniAppEditWith:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] miniAppEditWith:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 删除快应用
- (void)imMiniAppDeleteWith:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] miniAppDeleteWith:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 获取快应用详情
- (void)imMiniAppDetailWith:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] miniAppDetailWith:params onSuccess:onSuccess onFailure:onFailure];
}

#pragma mark - 验证快应用访问密码
- (void)imMiniAppPasswordVerifyWith:(NSMutableDictionary * _Nullable)params onSuccess:(LingIMSuccessCallback)onSuccess onFailure:(LingIMFailureCallback)onFailure {
    
    [[LingIMHttpManager sharedManager] miniAppPasswordVerifyWith:params onSuccess:onSuccess onFailure:onFailure];
}

@end
