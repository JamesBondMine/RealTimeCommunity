//
//  ZUserManager.m
//  CIMKit
//
//  Created by cusPro on 2022/9/15.
//

#import "ZUserManager.h"

NSNotificationName const UserRoleAuthorityTranslateFlagDidChange = @"UserRoleAuthorityTranslateFlagDidChange";

// Forward declaration for private class method used before category implementation
@interface ZUserManager (UserRoleAuthPersist)
+ (NSString *)userRoleAuthStorageKeyForUID:(NSString *)uid;
@end

@implementation ZUserManager

#pragma mark - 单例实现
DEF_SINGLETON(ZUserManager)

- (instancetype)init{
    self = [super init];
    if (self) {
        _userInfo = [ZUserModel getUserInfo];
        _roleConfigDict = [ZRoleConfigModel getRoleConfigInfo];
        // 尝试加载当前用户持久化的权限模型
        if (_userInfo && ![NSString isNil:_userInfo.userUID]) {
            NSString *storageKey = [ZUserManager userRoleAuthStorageKeyForUID:_userInfo.userUID];
            NSData *data = [[MMKV defaultMMKV] getDataForKey:storageKey];
            if (data) {
                NSError *unarchiveError = nil;
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&unarchiveError];
                if (unarchiver) {
                    unarchiver.requiresSecureCoding = NO;
                    id obj = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
                    [unarchiver finishDecoding];
                    if ([obj isKindOfClass:[ZUserRoleAuthorityModel class]]) {
                        _userRoleAuthInfo = (ZUserRoleAuthorityModel *)obj;
                    }
                }
            }
        }

    }
    return self;
}

#pragma mark - 用户相关
- (void)setUserInfo:(ZUserModel *)userInfo {
    if (userInfo) {
        _userInfo = userInfo;
        [_userInfo saveUserInfo];
        
        // 🔧 修复：设置新用户时，尝试加载该用户对应的权限缓存
        // 如果该用户之前登录过并有权限缓存，可以立即加载，不需要等网络请求
        if (![NSString isNil:_userInfo.userUID]) {
            NSString *storageKey = [ZUserManager userRoleAuthStorageKeyForUID:_userInfo.userUID];
            NSData *data = [[MMKV defaultMMKV] getDataForKey:storageKey];
            if (data) {
                NSError *unarchiveError = nil;
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&unarchiveError];
                if (unarchiver) {
                    unarchiver.requiresSecureCoding = NO;
                    id obj = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
                    [unarchiver finishDecoding];
                    if ([obj isKindOfClass:[ZUserRoleAuthorityModel class]]) {
                        _userRoleAuthInfo = (ZUserRoleAuthorityModel *)obj;
                    }
                }
            }
        }
    }else {
        _userInfo = nil;
        [ZUserModel clearUserInfo];
    }
}

- (BOOL)isLogined{
    return ![NSString isNil:UserManager.userInfo.token];
}

//清除保存的信息
- (void)clearUserInfo {
    // 先清理角色权限，再清理用户信息
    if (_userInfo && ![NSString isNil:_userInfo.userUID]) {
        NSString *storageKey = [ZUserManager userRoleAuthStorageKeyForUID:_userInfo.userUID];
        [[MMKV defaultMMKV] removeValueForKey:storageKey];
    }
    _userRoleAuthInfo = nil;
    _userInfo = nil;
}

- (BOOL)isTranslateEnabled {
    // 默认开启
    if (!self.userRoleAuthInfo || !self.userRoleAuthInfo.translationSwitch || [NSString isNil:self.userRoleAuthInfo.translationSwitch.configValue]) {
        return YES;
    }
    return [self.userRoleAuthInfo.translationSwitch.configValue isEqualToString:@"true"];
}

#pragma mark - 角色配置相关
- (void)setRoleConfigInfo:(NSDictionary *)roleConfigDict {
    if (roleConfigDict) {
        _roleConfigDict = roleConfigDict;
        [ZRoleConfigModel saveRoleConfigInfoWithDict:_roleConfigDict];
    }
}

- (NSString *)matchUserRoleConfigInfo:(NSInteger)roleId disableStatus:(NSInteger)disableStatus {
    NSString *realRoleName = @"";
    if (disableStatus == 4) {
        //已注销的账号
        return realRoleName;
    }
    if (_roleConfigDict == nil || _roleConfigDict.count < 0) {
        return realRoleName;
    } else {
        ZRoleConfigModel *currentRoleModel = (ZRoleConfigModel *)[_roleConfigDict objectForKeySafe:[NSNumber numberWithInteger:roleId]];
        if (currentRoleModel.showRoleName) {
            if ([ZLanguageTOOL.currentLanguage.languageAbbr isEqualToString:@"zh-Hans"] || [ZLanguageTOOL.currentLanguage.languageAbbr isEqualToString:@"zh-Hant"]) {
                realRoleName = currentRoleModel.roleName;
            } else {
                realRoleName = currentRoleModel.enName;
            }
        } else {
            realRoleName = @"";
        }
        return realRoleName;
    }
}

@end
@implementation ZUserManager (UserRoleAuthPersist)

+ (NSString *)userRoleAuthStorageKeyForUID:(NSString *)uid {
    NSString *user = (![NSString isNil:uid] ? uid : @"");
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([ZUserRoleAuthorityModel class]), user];
}

- (void)setUserRoleAuthInfo:(ZUserRoleAuthorityModel *)userRoleAuthInfo {
    _userRoleAuthInfo = userRoleAuthInfo;
    NSString *uid = self.userInfo.userUID;
    if ([NSString isNil:uid]) {
        return;
    }
    NSString *storageKey = [ZUserManager userRoleAuthStorageKeyForUID:uid];
    if (userRoleAuthInfo) {
        NSError *archiveError = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userRoleAuthInfo requiringSecureCoding:NO error:&archiveError];
        if (data) {
            [[MMKV defaultMMKV] setData:data forKey:storageKey];
        }
    } else {
        [[MMKV defaultMMKV] removeValueForKey:storageKey];
    }
}

@end
