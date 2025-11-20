//
//  LingIMDBTool+Stickers.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2023/10/30.
//

#import "LingIMDBTool+Stickers.h"
#import "RecentsEmojiModel+WCTTableCoding.h"
#import "LingIMStickersModel+WCTTableCoding.h"
#import "LingIMStickersPackageModel+WCTTableCoding.h"


@implementation LingIMDBTool (Stickers)

#pragma mark - 最近使用Emoji
/// 获取Emoji表情中 最近使用
- (NSArray<RecentsEmojiModel *> *)getMyRecentsEmojiList {
    [DBTOOL isTableStateOkWithName:CIMDBRecentsEmojiTableName model:RecentsEmojiModel.class];
    return [self.cimDB getObjectsOfClass:RecentsEmojiModel.class fromTable:CIMDBRecentsEmojiTableName];
}

/// 更新或新增 Emoji表情中 最近使用
/// @param model 最新使用Emoji表情
- (BOOL)insertOrUpdateRecentsEmojiModelWith:(RecentsEmojiModel *)model {
    [DBTOOL isTableStateOkWithName:CIMDBRecentsEmojiTableName model:RecentsEmojiModel.class];
    NSMutableArray *allRecentsEmojiList = [[DBTOOL getMyRecentsEmojiList] mutableCopy];
    NSMutableArray *tempAllRecentsEmojiList = [NSMutableArray arrayWithArray:allRecentsEmojiList];
    BOOL ishas = NO;
    NSInteger oldIndex = 0;
    for (NSInteger i = 0; i < tempAllRecentsEmojiList.count; i++) {
        RecentsEmojiModel *tempEmoji = (RecentsEmojiModel *)[tempAllRecentsEmojiList objectAtIndex:i];
        if ([model.emojiName isEqualToString:tempEmoji.emojiName]) {
            ishas = YES;
            oldIndex = i;
        }
    }
    if (ishas) {
        [allRecentsEmojiList removeObjectAtIndex:oldIndex];
        [allRecentsEmojiList insertObject:model atIndex:0];
    } else {
        [allRecentsEmojiList removeObjectAtIndex:tempAllRecentsEmojiList.count - 1];
        [allRecentsEmojiList insertObject:model atIndex:0];
    }
    
    return [DBTOOL batchInsertRecentsEmojiModelWith:allRecentsEmojiList];
}

/// 批量新增 Emoji表情中 最近使用
/// @param list 最近使用Emoji的数组
- (BOOL)batchInsertRecentsEmojiModelWith:(NSArray<RecentsEmojiModel *> *)list {
    [DBTOOL isTableStateOkWithName:CIMDBRecentsEmojiTableName model:RecentsEmojiModel.class];
    [DBTOOL deleteAllObjectWithName:CIMDBRecentsEmojiTableName];
    return [DBTOOL insertMulitModelToTable:CIMDBRecentsEmojiTableName modelClass:RecentsEmojiModel.class list:list];
}

#pragma mark - 收藏的表情
/// 获取收藏的表情中的所有表情
- (NSArray<LingIMStickersModel *> *)getMyCollectionStickersList {
    [DBTOOL isTableStateOkWithName:CIMDBCollectionStickersTableName model:LingIMStickersModel.class];
    return [self.cimDB getObjectsOfClass:LingIMStickersModel.class fromTable:CIMDBCollectionStickersTableName];
}

/// 单个 更新或新增 收藏的表情
/// @param model 收藏的表情
- (BOOL)insertOrUpdateCollectionStickersModelWith:(LingIMStickersModel *)model {
    return [DBTOOL insertModelToTable:CIMDBCollectionStickersTableName model:model];
}

/// 单个 删除 收藏的表情
/// @param stickersId 收藏的表情Id
- (BOOL)deleteCollectionStickersModelWith:(NSString *)stickersId {
    [DBTOOL isTableStateOkWithName:CIMDBCollectionStickersTableName model:LingIMStickersModel.class];
    return [self.cimDB deleteFromTable:CIMDBCollectionStickersTableName where:LingIMStickersModel.stickersId == stickersId];
}

/// 批量新增 收藏的表情
/// @param list 收藏的表情列表
- (BOOL)batchInsertCollectionStickersModelWith:(NSArray<LingIMStickersModel *> *)list {
    [DBTOOL isTableStateOkWithName:CIMDBCollectionStickersTableName model:LingIMStickersModel.class];
    return [DBTOOL insertMulitModelToTable:CIMDBCollectionStickersTableName modelClass:LingIMStickersModel.class list:list];
}

/// 清空 收藏的表情
- (BOOL)deleteAllCollectionStickersModels {
    [DBTOOL isTableStateOkWithName:CIMDBCollectionStickersTableName model:LingIMStickersModel.class];
    return [DBTOOL deleteAllObjectWithName:CIMDBCollectionStickersTableName];
}

#pragma mark - 已使用的表情包
/// 获取已使用的表情包中
- (NSArray<LingIMStickersPackageModel *> *)getMyStickersPackageList {
    [DBTOOL isTableStateOkWithName:CIMDBPackageStickersTableName model:LingIMStickersPackageModel.class];
    return [self.cimDB getObjectsOfClass:LingIMStickersPackageModel.class fromTable:CIMDBPackageStickersTableName];
}

/// 单个 删除 已使用的表情包
/// @param packageId 表情包Id
- (BOOL)deleteStickersPackageModelWith:(NSString *)packageId {
    [DBTOOL isTableStateOkWithName:CIMDBPackageStickersTableName model:LingIMStickersPackageModel.class];
    return [self.cimDB deleteFromTable:CIMDBPackageStickersTableName where:LingIMStickersPackageModel.packageId == packageId];
}

/// 批量新增 表情包
/// @param list 表情包列表
- (BOOL)batchInsertStickersPackageModelWith:(NSArray *)list {
    [DBTOOL isTableStateOkWithName:CIMDBPackageStickersTableName model:LingIMStickersPackageModel.class];
    return [DBTOOL insertMulitModelToTable:CIMDBPackageStickersTableName modelClass:LingIMStickersPackageModel.class list:list];
}

/// 清空 已使用的表情包
- (BOOL)deleteAllStickersPackageModels {
    [DBTOOL isTableStateOkWithName:CIMDBPackageStickersTableName model:LingIMStickersPackageModel.class];
    return [DBTOOL deleteAllObjectWithName:CIMDBPackageStickersTableName];
}

@end
