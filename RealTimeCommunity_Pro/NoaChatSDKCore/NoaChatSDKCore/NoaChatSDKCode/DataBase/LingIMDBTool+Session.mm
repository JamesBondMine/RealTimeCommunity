//
//  LingIMDBTool+Session.m
//  NoaChatSDKCore
//
//  Created by cusPro on 2022/10/26.
//

#import "LingIMDBTool+Session.h"
#import <WCDBObjc/WCDBObjc.h>

//好友信息
#import "LingIMSessionModel+WCTTableCoding.h"
#import "LingIMDBTool+Friend.h"
//聊天信息
#import "LingIMChatMessageModel+WCTTableCoding.h"
#import "LingIMDBTool+ChatMessage.h"

@implementation LingIMDBTool (Session)

#pragma mark - 获取我的 会话列表 数据
- (NSArray<LingIMSessionModel *> *)getMySessionListExcept:(NSString *)sessionId {
    if (sessionId.length > 0) {
        NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionID != sessionId orders:{LingIMSessionModel.sessionLatestTime.asOrder(WCTOrderedDescending)}];
        return sessionList;
    } else {
        NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName orders:{LingIMSessionModel.sessionLatestTime.asOrder(WCTOrderedDescending)}];
        return sessionList;
    }
}

#pragma mark - 获取我的 会话列表中前50条单聊 数据
- (NSArray<LingIMSessionModel *> *)getMySessionListFromSignlChat {
    NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionType == CIMSessionTypeSingle orders:{LingIMSessionModel.sessionLatestTime.asOrder(WCTOrderedDescending)} limit:50 offset:0];
    return sessionList;
}

#pragma mark - 获取我的会话列表单聊数据50条，剔除掉 群、群助手、群发助手、系统通知等
- (NSArray<LingIMSessionModel *> *)getMySessionListFromSignlChatWithOffServer {
    NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where: {LingIMSessionModel.sessionType == CIMSessionTypeSingle } orders:{LingIMSessionModel.sessionLatestTime.asOrder(WCTOrderedDescending),LingIMSessionModel.sessionTop.asOrder(WCTOrderedDescending)}];
    
    return sessionList;
}

#pragma mark - 获取我的会话列表数据，剔除掉 群助手、群发助手、系统通知等
- (NSArray<LingIMSessionModel *> *)getMySessionListWithOffServer {
    NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where: {LingIMSessionModel.sessionType == CIMSessionTypeSingle || LingIMSessionModel.sessionType == CIMSessionTypeGroup } orders:{LingIMSessionModel.sessionLatestTime.asOrder(WCTOrderedDescending),LingIMSessionModel.sessionTop.asOrder(WCTOrderedDescending)}];
    
    return sessionList;
}

#pragma mark - #pragma mark - 获取我的 置顶会话列表 数据
- (NSArray<LingIMSessionModel *> *)getMyTopSessionListExcept:(NSString *)sessionId {
    if (sessionId.length > 0) {
        NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionTop == YES && LingIMSessionModel.sessionID != sessionId orders:LingIMSessionModel.sessionTopTime.asOrder(WCTOrderedAscending)];
        return sessionList;
    } else {
        NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionTop == YES orders:LingIMSessionModel.sessionTopTime.asOrder(WCTOrderedAscending)];
        return sessionList;
    }
}

#pragma mark - 获取我的会话列表置顶会话 分页数据
- (NSArray<LingIMSessionModel *> *)getMyTopSessionListWithOffset:(NSInteger)offset limit:(NSInteger)limit {
    NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionTop == YES orders:LingIMSessionModel.sessionTopTime.asOrder(WCTOrderedAscending) limit:limit offset:offset];
    
    [sessionList enumerateObjectsUsingBlock:^(LingIMSessionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sessionTableName = obj.sessionTableName;
        LingIMChatMessageModel *latestMessage = [DBTOOL getLatestChatMessageWithTableName:sessionTableName];
        obj.sessionLatestMessage = latestMessage;//用于和服务端数据对比
    }];
    
    return sessionList;
}

#pragma mark - 获取会话列表中全部未读会话
- (NSArray<LingIMSessionModel *> *)getAllSessionUnreadList{
    NSArray *sessionList = [self.cimDB getObjectsOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionUnreadCount > 0 || LingIMSessionModel.readTag > 0];
    return sessionList;
}

#pragma mark - 根据会话ID查询是否存在该会话

- (LingIMSessionModel *)checkMySessionWith:(NSString *)sessionID {
    return [self.cimDB getObjectOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionID == sessionID];

}


#pragma mark - 根据会话类型查询是否存在该会话
- (LingIMSessionModel *)checkMySessionWithType:(CIMSessionType)sessionType {
    return [self.cimDB getObjectOfClass:LingIMSessionModel.class fromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionType == CIMSessionTypeSystemMessage];

}

#pragma mark - 更新或新增会话到表
- (BOOL)insertOrUpdateSessionModelWith:(LingIMSessionModel *)model {
    return [DBTOOL insertModelToTable:CIMDBSessionTableName model:model];
}

#pragma mark - 批量-更新或新增会话到表
- (BOOL)insertOrUpdateSessionModelListWith:(NSArray<LingIMSessionModel *> *)list {
    return [DBTOOL insertMulitModelToTable:CIMDBSessionTableName modelClass:LingIMSessionModel.class list:list];
}

#pragma mark - 获取会话全部未读消息数量
- (NSInteger)getAllSessionUnreadCount {
    //真实未读总数
    NSNumber *totalUnreadCountNum = [[self.cimDB getValueOnResultColumn:LingIMSessionModel.sessionUnreadCount.sum()
                                                              fromTable:CIMDBSessionTableName
                                                                 where:LingIMSessionModel.sessionNoDisturb == NO] numberValue];
    
    NSInteger totalUnreadCount = totalUnreadCountNum.integerValue;
    
    //真实标记未读总数
    NSNumber *totalReadTagCountNum = [[self.cimDB getValueOnResultColumn:LingIMSessionModel.readTag.sum()
                                                               fromTable:CIMDBSessionTableName
                                                                  where:LingIMSessionModel.sessionNoDisturb == NO] numberValue];
    
    NSInteger totalReadTagCount = totalReadTagCountNum.integerValue;
    
    NSInteger total = totalUnreadCount + totalReadTagCount;
    return total > 0 ? total : 0;
}


#pragma mark - 获取某个会话的全部未读消息数量
- (NSInteger)getOneSessionUnreadCountWith:(NSString *)sessionTableName {
    return [[[self.cimDB getValueOnResultColumn:LingIMChatMessageModel.chatMessageReaded.count() fromTable:sessionTableName where:LingIMChatMessageModel.chatMessageReaded == NO] numberValue] integerValue];
}

#pragma mark - 根据聊天消息，获取存储消息的回话表名称
- (NSString *)getSessionTableNameWith:(LingIMChatMessageModel *)message {
    NSString *sessionID;//会话ID
    if (message.chatType == CIMChatType_NetCallChat) {
        //音视频 消息
        if (message.netCallChatType == 1) {
            //单聊音视频
            if ([message.fromID isEqualToString:[DBTOOL myUserID]]) {
                //我发的消息
                LingIMFriendModel *friendModel = [DBTOOL checkMyFriendWith:message.toID];
                sessionID = friendModel.friendUserUID;
            }else {
                //对方发的消息
                sessionID = message.fromID;
            }
        } else {
            //群聊音视频
            sessionID = message.toID;
        }
    } else if (message.chatType == CIMChatType_SingleChat) {
        //单聊消息
        if ([message.fromID isEqualToString:[DBTOOL myUserID]]) {
            //我发的消息
            sessionID = message.toID;
        }else {
            //对方发的消息
            sessionID = message.fromID;
        }
    } else if (message.chatType == CIMChatType_GroupChat) {
        //群聊消息
        sessionID = message.toID;
    } else {
        CIMLog(@"GGG消息解析未实现的chatType类型:%ld",message.chatType);
    }
    
    NSString *sessionTableName = [NSString stringWithFormat:@"CIMDB_%@_%@_Table",[DBTOOL myUserID],sessionID];
    
    CIMLog(@"sessionTableName = %@",sessionTableName);
    return sessionTableName;
}

#pragma mark - 根据聊天消息，获取会话ID
- (NSString *)getSessionIDWith:(LingIMChatMessageModel *)message {
    NSString *sessionID;//会话ID
    if (message.chatType == CIMChatType_SingleChat) {
        //单聊消息
        if ([message.fromID isEqualToString:[DBTOOL myUserID]]) {
            //我发的消息
            LingIMFriendModel *friendModel = [DBTOOL checkMyFriendWith:message.toID];
            sessionID = friendModel.friendUserUID;
        }else {
            //对方发的消息
            sessionID = message.fromID;
        }
    } else if (message.chatType == CIMChatType_GroupChat) {
        //群聊消息
        sessionID = message.toID;
    } else {
        CIMLog(@"HHH消息解析未实现的chatType类型:%ld",message.chatType);
    }
    
    return sessionID;
}

#pragma mark - 删除会话model，以及是否清空会话内容
- (BOOL)deleteSessionModelWith:(NSString *)sessionID sessionTableName:(NSString * _Nullable)sessionTableName {
    if (sessionTableName.length > 0) {
        // 删除会话
        
        BOOL success = [self.cimDB deleteFromTable:CIMDBSessionTableName
                                                     where:LingIMSessionModel.sessionID == sessionID];
        
        // 清空本地和该会话相关的聊天信息
        BOOL deleteChatSuccess = [DBTOOL deleteAllObjectWithName:sessionTableName];
        return success && deleteChatSuccess;
        
    } else {
        // 删除会话
        return [self.cimDB deleteFromTable:CIMDBSessionTableName
                                            where:LingIMSessionModel.sessionID == sessionID];
    }
}

#pragma mark - 更新会话列表的全部sessionStatus值
- (BOOL)updateAllSessionStatusWith:(NSInteger)sessionStatus {
    return [self.cimDB updateTable:CIMDBSessionTableName setProperty:LingIMSessionModel.sessionStatus toValue:@(sessionStatus) where:LingIMSessionModel.sessionType != CIMSessionTypeSignInReminder];
    
}


#pragma mark - 更新会话列表中某个会话的头像
- (BOOL)updateSessionAvatarWithSessionId:(NSString *)sessionId withAvatar:(NSString *)avatar {
    return [self.cimDB updateTable:CIMDBSessionTableName setProperty:LingIMSessionModel.sessionAvatar toValue:avatar where:LingIMSessionModel.sessionID == sessionId];
}


#pragma mark - 删除会话列表里某个状态的全部数据
- (BOOL)deleteAllSessionStatusWith:(NSInteger)sessionStatus {
    return [self.cimDB deleteFromTable:CIMDBSessionTableName where:LingIMSessionModel.sessionStatus == sessionStatus];
}
@end
