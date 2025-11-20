//
//  ZUserManager.h
//  CIMKit
//
//  Created by cusPro on 2022/9/15.
//

#define UserManager ([ZUserManager sharedInstance])

#import <Foundation/Foundation.h>
#import "ZUserModel.h"
#import "ZUserRoleAuthorityModel.h"
#import "ZRoleConfigModel.h"
#import "GHomeActivityInfoModel.h"

// 翻译开关变化通知
FOUNDATION_EXPORT NSNotificationName const UserRoleAuthorityTranslateFlagDidChange;

NS_ASSUME_NONNULL_BEGIN

@interface ZUserManager : NSObject

#pragma mark - 单例实现
AS_SINGLETON(ZUserManager)

#pragma mark - 用户相关
//持久化的当前用户信息
@property (nonatomic, strong) ZUserModel   * _Nullable userInfo;
//持久化的当前用户权限
@property (nonatomic, strong) ZUserRoleAuthorityModel   * _Nullable userRoleAuthInfo;
//持久化群活跃配置信息
@property (nonatomic, strong) GHomeActivityInfoModel   * _Nullable activityConfigInfo;

//是否已登录
- (BOOL)isLogined;
//清除保存的信息
- (void)clearUserInfo;

// 翻译开关便捷读取（默认开启）
- (BOOL)isTranslateEnabled;

#pragma mark - 角色配置相关
//持久化的角色配置信息
@property (nonatomic, strong) NSDictionary * _Nullable roleConfigDict;

- (NSString *)matchUserRoleConfigInfo:(NSInteger)roleId disableStatus:(NSInteger)disableStatus;

@end

NS_ASSUME_NONNULL_END
