//
//  LingIMDBTool+Group.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2022/11/7.
//

#import "LingIMDBTool+Group.h"

//群组信息
#import "LingIMGroupModel+WCTTableCoding.h"

@implementation LingIMDBTool (Group)

#pragma mark - 获取我的群组列表数据
- (NSArray<LingIMGroupModel *> *)getMyGroupList {
    [DBTOOL isTableStateOkWithName:CIMDBGroupTableName model:LingIMGroupModel.class];
    //return [self.cimDB getAllObjectsOfClass:LingIMGroupModel.class fromTable:CIMDBGroupTableName];
    return [self.cimDB getObjectsOfClass:LingIMGroupModel.class fromTable:CIMDBGroupTableName where:LingIMGroupModel.groupStatus == 1];
}


#pragma mark - 根据群组ID查询群组信息
- (LingIMGroupModel *)checkMyGroupWith:(NSString *)groupID {
    [DBTOOL isTableStateOkWithName:CIMDBGroupTableName model:LingIMGroupModel.class];
    return [self.cimDB getObjectOfClass:LingIMGroupModel.class fromTable:CIMDBGroupTableName where:LingIMGroupModel.groupId == groupID];
}

#pragma mark - 根据群组ID删除数据库内容
- (BOOL)deleteMyGroupWith:(NSString *)groupID {
    if ([self checkMyGroupWith:groupID]) {
        return [self.cimDB deleteFromTable:CIMDBGroupTableName where:LingIMGroupModel.groupId == groupID];
    }else {
        return NO;
    }
}

#pragma mark - 更新或新增群组到表
- (BOOL)insertOrUpdateGroupModelWith:(LingIMGroupModel *)model {
    [DBTOOL isTableStateOkWithName:CIMDBGroupTableName model:LingIMGroupModel.class];
    return [DBTOOL insertModelToTable:CIMDBGroupTableName model:model];
}

#pragma mark - 批量 更新或新增群组到表
- (BOOL)batchInsertOrUpdateGroupModelWithList:(NSArray <LingIMGroupModel *> *)modelList {
    return [DBTOOL insertMulitModelToTable:CIMDBGroupTableName modelClass:LingIMGroupModel.class list:modelList];
}

#pragma mark - 根据搜索内容查询群组数据
- (NSArray <LingIMGroupModel *> *)searchMyGroupWith:(NSString *)searchStr {
    [DBTOOL isTableStateOkWithName:CIMDBGroupTableName model:LingIMGroupModel.class];
    //%搜索%，检索任意位置包含有 搜索 字段的内容
    searchStr = [[LingIMManagerTool sharedManager] stringReplaceSpecialCharacterWith:searchStr];
    if (searchStr.length > 0) {
        NSString *likeStr = [NSString stringWithFormat:@"%%%@%%",searchStr];
        return [self.cimDB getObjectsOfClass:LingIMGroupModel.class fromTable:CIMDBGroupTableName where:LingIMGroupModel.groupName.like(likeStr)];
    }else {
        return nil;
    }
}

@end
