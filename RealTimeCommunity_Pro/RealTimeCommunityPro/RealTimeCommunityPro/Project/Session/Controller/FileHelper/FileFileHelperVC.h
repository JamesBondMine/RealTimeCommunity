//
//  FileFileHelperVC.h
//  CIMKit
//
//  Created by cusPro on 2023/6/6.
//

// 文件助手VC

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileFileHelperVC : BBBaseViewController
@property (nonatomic, copy) NSString *sessionID;

//通过点击全局搜索结果进入聊天界面
- (void)clickSearchResultInChatRoomWithMessage:(LingIMChatMessageModel *)messageModel;
@end

NS_ASSUME_NONNULL_END
