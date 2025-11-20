//
//  LingIMDBTool+Friend.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2022/10/25.
//

#import "LingIMDBTool+Friend.h"
#import <WCDBObjc/WCDBObjc.h>

//好友信息
#import "LingIMFriendModel+WCTTableCoding.h"
//好友分组信息
#import "LingIMFriendGroupModel+WCTTableCoding.h"
#import <MMKV/MMKV.h>

@implementation LingIMDBTool (Friend)

#pragma mark - 获取我的好友列表数据(所有的，包含已注销账号)
- (NSArray<LingIMFriendModel *> *)getMyFriendList {
    return [self.cimDB getObjectsOfClass:LingIMFriendModel.class fromTable:CIMDBFriendTableName];
}

#pragma mark - 获取我的好友列表数据(所有的，不包含已注销账号)
- (NSArray<LingIMFriendModel *> *)getMyFriendListOffLogout {
    return [self.cimDB getObjectsOfClass:LingIMFriendModel.class fromTable:CIMDBFriendTableName where: LingIMFriendModel.disableStatus != 4];
}

#pragma mark - 根据用的ID查询是否是我的好友
- (LingIMFriendModel *)checkMyFriendWith:(NSString *)userID {
    return [self.cimDB getObjectOfClass:LingIMFriendModel.class fromTable:CIMDBFriendTableName where:LingIMFriendModel.friendUserUID == userID];
}

#pragma mark - 根据用的ID查询是否是我的好友(不包含已注销账号)
- (LingIMFriendModel *)checkMyFriendWithOffLogout:(NSString *)userID {
    return [self.cimDB getObjectOfClass:LingIMFriendModel.class fromTable:CIMDBFriendTableName where:LingIMFriendModel.friendUserUID == userID && LingIMFriendModel.disableStatus != 4];
}

#pragma mark - 根据好友ID删除数据库内容
- (BOOL)deleteMyFriendWith:(NSString *)myFriendID {
    if ([self checkMyFriendWith:myFriendID]) {
        return [self.cimDB deleteFromTable:CIMDBFriendTableName where:LingIMFriendModel.friendUserUID == myFriendID];
    }else {
        return NO;
    }
}
#pragma mark - 根据搜索内容查询好友数据
- (NSArray<LingIMFriendModel *> *)searchMyFriendWith:(NSString *)searchStr {
    //%搜索%，检索任意位置包含有 搜索 字段的内容
    searchStr = [[LingIMManagerTool sharedManager] stringReplaceSpecialCharacterWith:searchStr];
    if (searchStr.length > 0) {
        NSString *likeStr = [NSString stringWithFormat:@"%%%@%%",searchStr];
        return [self.cimDB getObjectsOfClass:LingIMFriendModel.class fromTable:CIMDBFriendTableName where:(LingIMFriendModel.showName.like(likeStr) || LingIMFriendModel.userName.like(likeStr) || LingIMFriendModel.nickname.like(likeStr) || LingIMFriendModel.nicknamePinyin.like(likeStr) || LingIMFriendModel.remarks.like(likeStr) || LingIMFriendModel.remarksPinyin.like(likeStr)) && (LingIMFriendModel.disableStatus != 4)];
    }else {
        return nil;
    }
}

#pragma mark - 更新好友申请红点个数
- (void)updateFriendApplyCount:(NSInteger)friendApplyCount {
    NSString *friendApplyStr = [NSString stringWithFormat:@"%@_FriendApplyCount",[DBTOOL myUserID]];
    [[MMKV defaultMMKV] setInt32:(int)friendApplyCount forKey:friendApplyStr];
}

#pragma mark - 获取好友申请红点个数
- (NSInteger)friendApplyCount {
    NSString *friendApplyStr = [NSString stringWithFormat:@"%@_FriendApplyCount",[DBTOOL myUserID]];
    return [[MMKV defaultMMKV] getInt32ForKey:friendApplyStr];
}

#pragma mark - <<<<<<好友分组模块>>>>>>
#pragma mark - 好友分组数据 新增/更新
- (BOOL)insertFriendGroupWith:(LingIMFriendGroupModel *)friendGroupModel {
    return [self insertModelToTable:CIMDBFriendGroupTableName model:friendGroupModel];
}

#pragma mark - 删除好友分组
- (BOOL)deleteMyFriendGroupWith:(NSString *)friendGroupID {
    [self isTableStateOkWithName:CIMDBFriendGroupTableName model:LingIMFriendGroupModel.class];
    
    if ([self checkMyFriendGroupWith:friendGroupID]) {
        return [self.cimDB deleteFromTable:CIMDBFriendGroupTableName where:LingIMFriendGroupModel.ugUuid == friendGroupID];
    }else {
        return NO;
    }
}

#pragma mark - 获取某个好友分组信息
- (LingIMFriendGroupModel *)checkMyFriendGroupWith:(NSString *)friendGroupID {
    [self isTableStateOkWithName:CIMDBFriendGroupTableName model:LingIMFriendGroupModel.class];
    
    return [self.cimDB getObjectOfClass:LingIMFriendGroupModel.class fromTable:CIMDBFriendGroupTableName where:LingIMFriendGroupModel.ugUuid == friendGroupID];
}

#pragma mark - 获取我的 好友分组 列表
- (NSArray <LingIMFriendGroupModel *> *)getMyFriendGroupList {
    [self isTableStateOkWithName:CIMDBFriendGroupTableName model:LingIMFriendGroupModel.class];
    return [self.cimDB getObjectsOfClass:LingIMFriendGroupModel.class fromTable:CIMDBFriendGroupTableName orders:LingIMFriendGroupModel.ugOrder.asOrder(WCTOrderedAscending)];
}

#pragma mark - 获取我的 某个好友分组类型的 好友分组 列表
- (NSArray <LingIMFriendGroupModel *> *)getMyFriendGroupTypeList:(NSInteger)friendGroupType {
    [self isTableStateOkWithName:CIMDBFriendGroupTableName model:LingIMFriendGroupModel.class];
    
    return [self.cimDB getObjectsOfClass:LingIMFriendGroupModel.class fromTable:CIMDBFriendGroupTableName where:LingIMFriendGroupModel.ugType == friendGroupType];
}

#pragma mark - 获取某个 好友分组 下的 好友列表(所有的，包含已注销账号)
- (NSArray<LingIMFriendModel *> *)getMyFriendGroupFriendsWith:(NSString *)friendGroupID {
    
    [self isTableStateOkWithName:CIMDBFriendTableName model:LingIMFriendModel.class];
    if (friendGroupID.length > 0) {
        return [self.cimDB getObjectsOfClass:LingIMFriendModel.class fromTable:CIMDBFriendTableName where: LingIMFriendModel.ugUuid == friendGroupID];
    }else {
        return [self.cimDB getObjectsOfClass:LingIMFriendModel.class fromTable:CIMDBFriendTableName where: LingIMFriendModel.ugUuid.isNull()];
    }
}

#pragma mark - 获取某个 好友分组 下的 好友列表(所有的，不包含已注销账号)
- (NSArray<LingIMFriendModel *> *)getMyFriendGroupFriendsOffLogoutWith:(NSString *)friendGroupID {
    [self isTableStateOkWithName:CIMDBFriendTableName model:LingIMFriendModel.class];
    
    return [self.cimDB getObjectsOfClass:LingIMFriendModel.class fromTable:CIMDBFriendTableName where: LingIMFriendModel.disableStatus != 4 && LingIMFriendModel.ugUuid == friendGroupID];
}

@end
