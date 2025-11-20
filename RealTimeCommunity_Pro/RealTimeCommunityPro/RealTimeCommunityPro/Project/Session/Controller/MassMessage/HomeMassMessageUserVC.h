//
//  HomeMassMessageUserVC.h
//  CIMKit
//
//  Created by cusPro on 2023/4/19.
//

// 群发助手-转发接收人展示列表(全部列表和失败列表)

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeMassMessageUserVC : BBBaseViewController
@property (nonatomic, assign) BOOL allUsers;
@property (nonatomic, strong) LIMMassMessageModel *messageModel;
@end

NS_ASSUME_NONNULL_END
