//
//  ZMessageTools.h
//  CIMKit
//
//  Created by cusPro on 2022/10/23.
//

#import <Foundation/Foundation.h>
#import "ZMyCollectionItemModel.h"
#import "LingIMGroup.h"
#import "ZBaseUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMessageTools : NSObject

/** 获得消息的唯一标识 */
+ (NSString *)getMessageID;

/** 将数据库存储的LingIMChatMessageModel 转换为 IMMessage 不改变任何数据，用户消息多选-合并转发*/
+ (IMChatMessage *)getIMChatMessageFromLingIMChatMessageModelToMergeForward:(LingIMChatMessageModel *)message;

/** 将数据库存储的LingIMChatMessageModel 转换为 IMMessage*/
+ (IMMessage *)getIMMessageFromLingIMChatMessageModel:(LingIMChatMessageModel *)message withChatObject:(ZBaseUserModel *)chatObject index:(int)index;

/** 将数据库存储的LingIMChatMessageModel 转换为 IMMessage*/
+ (IMMessage *)getIMMessageFromCollection:(ZMyCollectionItemModel *)collectionMsg withChatType:(CIMChatType)chatType chatSessionId:(NSString *)chatSession;

/** 清除某个会话本地缓存的图片和视频 */
+ (void)clearChatLocalImgAndVideoFromSessionId:(NSString *)sessionID;


/** 将 at消息里的 \vuid\v 转换成 @nickName */
+ (NSString *)atContenTranslateToShowContent:(NSString *)atContentStr atUsersDictList:(NSArray *)atUsersDictList withMessage:(LingIMChatMessageModel *)chatMessage  isGetShowName:(BOOL)isGetShowName;

/** 将 at消息里的 \vuid\v 转换成 @nickName   只用于转发消息*/
+ (NSString *)forwardMessageAtContenTranslateToShowContent:(NSString *)atContentStr atUsersDictList:(NSArray *)atUsersDictList;

/** 语音的音频文件下载缓存到本地 */
+ (void)downloadAudioWith:(NSString *)audioUrlStr AudioCachePath:(NSString *)audioCachePath completion:(void (^)(BOOL, NSString * _Nonnull))completion;

//将内容 拆分为 翻译内容  + at字符串 + 表情字符串 三部分
+ (void)translationSplit:(NSString *)messageStr
              atUserList:(NSArray *)atUserList
                  finish:(void(^)(NSString * translationString,
                                  NSString * atString,
                                  NSString * emojiString))finish;

//将接口返回的群信息转换成数据库存储的数据类型
+ (LingIMGroupModel *)netWorkGroupModelToDBGroupModel:(LingIMGroup *)groupModel;

//将数据库存储的数据类型转换成接口返回的群信息
+ (LingIMGroup *)DBGroupModelToNetWorkGroupModel:(LingIMGroupModel *)groupModel;

@end

NS_ASSUME_NONNULL_END
