//
//  ZComplainVC.h
//  CIMKit
//
//  Created by cusPro on 2023/6/19.
//

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZComplainVC : BBBaseViewController
@property (nonatomic, copy) NSString *complainID;//投诉ID
@property (nonatomic, assign) CIMChatType complainType;//投诉类型 群聊 好友
@end

NS_ASSUME_NONNULL_END
