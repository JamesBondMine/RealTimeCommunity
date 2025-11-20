//
//  ZNMMyCollectionViewController.h
//  CIMKit
//
//  Created by cusPro on 2023/4/19.
//

#import "BBBaseViewController.h"
#import "ZMyCollectionItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZNMMyCollectionViewController : BBBaseViewController

@property (nonatomic, assign)BOOL isFromChat;
@property (nonatomic, copy) NSString *chatSession;
@property (nonatomic, assign)CIMChatType chatType;
//发送收藏的消息(转发)
@property (nonatomic, copy) void(^sendCollectionMsgBlock)(ZMyCollectionItemModel *collectionMsg);

@end

NS_ASSUME_NONNULL_END
