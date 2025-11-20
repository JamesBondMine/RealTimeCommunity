//
//  NHChatFileDetailViewController.h
//  CIMKit
//
//  Created by cusPro on 2023/4/11.
//

#import "BBBaseViewController.h"
#import "ZMessageModel.h"
#import "ZMyCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NHChatFileDetailViewController : BBBaseViewController

@property (nonatomic, strong)ZMessageModel *fileMsgModel;
@property (nonatomic, copy)NSString *localFilePath;
@property (nonatomic, copy)NSString *fromSessionId;
@property (nonatomic, assign)BOOL isShowRightBtn;

@property (nonatomic, assign)BOOL isFromCollcet;//是否从收藏列表进入的
@property (nonatomic, strong)ZMyCollectionModel *collectionMsgModel;//收藏消息的model

@end

NS_ASSUME_NONNULL_END
