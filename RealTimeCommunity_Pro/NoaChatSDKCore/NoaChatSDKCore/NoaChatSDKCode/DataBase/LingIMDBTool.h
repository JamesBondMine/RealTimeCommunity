//
//  LingIMDBTool.h
//  NoaChatSDKCore
//
//  Created by cusPro on 2022/10/21.
//

// 数据库处理单例
#define DBTOOL  [LingIMDBTool sharedTool]

#import <Foundation/Foundation.h>

#import "LingIMSDK.h"

//用户信息
#import "LingIMUserModel.h"
//好友信息
#import "LingIMFriendModel.h"
//群组信息
#import "LingIMGroupModel.h"
//最近使用Emoji表情
#import "RecentsEmojiModel.h"
//表情包中表情/收藏的表情
#import "LingIMStickersModel.h"
//表情包
#import "LingIMStickersPackageModel.h"


//群组成员信息
//#import "NoaChatSDKCore/LingIMGroupMemberModel.h"
//会话信息
#import "LingIMSessionModel.h"
//好友分组信息
#import "LingIMFriendGroupModel.h"
#import "LingIMMiniAppModel.h"
#import "LingFloatMiniAppModel.h"

@class WCTDatabase;

//数据库名称
static NSString * _Nullable const CIMDBName = @"CIMSDKDB_VERSION2.sqlite";

//数据库-用户信息列表(用于缓存用户的昵称备注头像等信息)
static NSString * _Nullable const CIMDBUserInfoTableName = @"CIMSDKDB_UserInfo_Table";
//数据库-好友列表
static NSString * _Nullable const CIMDBFriendTableName = @"CIMSDKDB_Friend_Table";
//数据库-群组列表
static NSString * _Nullable const CIMDBGroupTableName = @"CIMSDKDB_Group_Table";
//数据库-会话列表
static NSString * _Nullable const CIMDBSessionTableName = @"CIMSDKDB_Session_Table";
//数据库-好友分组列表
static NSString * _Nullable const CIMDBFriendGroupTableName = @"CIMSDKDB_FriendGroup_Table";
//数据库-小程序快应用列表
static NSString * _Nullable const CIMDBFloatMiniAppTableName = @"CIMSDKDB_FloatMiniApp_Table";
//数据库-Emoji表情 最近使用 列表
static NSString * _Nullable const CIMDBRecentsEmojiTableName = @"CIMDB_Emoji_Recents_Table";
//数据库-收藏的表情 列表
static NSString * _Nullable const CIMDBCollectionStickersTableName = @"CIMDB_Collection_Stickers_TableName";
//数据库-表情包 列表
static NSString * _Nullable const CIMDBPackageStickersTableName = @"CIMDB_Package_Stickers_TableName";

//数据库-某一会话列表 CIMDB_myUserID_toUserID_Table

NS_ASSUME_NONNULL_BEGIN

@interface LingIMDBTool : NSObject

@property (nonatomic, strong) dispatch_queue_t groupMemberUpdateQueue;

#pragma mark - 单例
+ (instancetype)sharedTool;
//单例一般不需要清空，但是在执行某些功能的时候，防止数据更换不及时，可以清空一下
- (void)clearTool;

#pragma mark - 业务
//数据库
@property (nonatomic, strong) WCTDatabase *cimDB;

/// 数据库绑定用户信息
/// @param userToken 用户的token
/// @param userID 用户的id
- (BOOL)configDBWith:(NSString *)userToken userID:(NSString *)userID;

/// 获得我的ID
- (NSString *)myUserID;
/// 获得我的token
- (NSString *)myUserToken;

/// 创建数据库
- (BOOL)createDB;

/// 关闭数据库
- (void)closeDB;

/// 创建数据库的 某一表
/// @param tableName 表名称
/// @param model 存储在数据库的model
- (BOOL)createTableWithName:(NSString *)tableName model:(id)model;

/// 判断某数据库表是否正常(用于自检数据表)
/// @param tableName 表名称
/// @param model 存储在数据库的model
- (BOOL)isTableStateOkWithName:(NSString *)tableName model:(Class)model;


/// 新增/更新数据到 某一表
/// @param tableName 表名称
/// @param model 新增数据model
- (BOOL)insertModelToTable:(NSString *)tableName model:(id)model;

/// 批量】 新增/更新数据到 某一表
/// @param tableName 表名称
/// @param modelClass 新增数据model class
/// @param list 需要新增/更新的批量数据
- (BOOL)insertMulitModelToTable:(NSString *)tableName modelClass:(id)modelClass list:(NSArray *)list;

/// 删除某个表
/// @param tableName 表名称
- (BOOL)dropTableWithName:(NSString *)tableName;

/// 删除某个表的全部数据
/// @param tableName 表名称
- (BOOL)deleteAllObjectWithName:(NSString *)tableName;


@end

NS_ASSUME_NONNULL_END
