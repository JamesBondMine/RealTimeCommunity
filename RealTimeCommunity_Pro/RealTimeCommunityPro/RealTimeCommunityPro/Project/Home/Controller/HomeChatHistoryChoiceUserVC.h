//
//  HomeChatHistoryChoiceUserVC.h
//  CIMKit
//
//  Created by cusPro on 2024/8/12.
//

#import "BBBaseViewController.h"
#import "ZBaseUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZChatHistoryChoiceUserDelegate <NSObject>

- (void)chatHistoryChoicedUserList:(NSArray<ZBaseUserModel *> *)selectedUserList;

@end

@interface HomeChatHistoryChoiceUserVC : BBBaseViewController

@property (nonatomic, assign) CIMChatType chatType;//会话类型
@property (nonatomic, copy) NSString *sessionID;//会话ID(单聊userUid 群聊groupID)
@property (nonatomic, weak) id <ZChatHistoryChoiceUserDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<ZBaseUserModel *> *choicedList;//选中的

@end

NS_ASSUME_NONNULL_END
