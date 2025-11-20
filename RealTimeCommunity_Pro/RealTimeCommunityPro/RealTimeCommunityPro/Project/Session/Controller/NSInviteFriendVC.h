//
//  NSInviteFriendVC.h
//  CIMKit
//
//  Created by cusPro on 2022/9/22.
//

// 创建群聊 邀请好友 VC

#import "BBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSInviteFriendVC : BBBaseViewController
//最多选择几人
@property (nonatomic, assign) NSInteger maxNum;
//至少选择几人
@property (nonatomic, assign) NSInteger minNum;

//单聊详情创建群聊
@property (nonatomic, copy) NSString *friendUid;
@property (nonatomic, copy) NSString *friendNickname;
@end

NS_ASSUME_NONNULL_END
