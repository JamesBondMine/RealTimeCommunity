//
//  ZMediaCallMoreInviteVC.h
//  CIMKit
//
//  Created by cusPro on 2023/2/6.
//

// 音视频通话 多人 邀请 VC

#import "BBBaseViewController.h"
#import "ZMediaCallManager.h"
#import "ZCallManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMediaCallMoreInviteVC : BBBaseViewController
@property (nonatomic, copy) NSString *groupID;//群ID
@property (nonatomic, assign) LingIMCallType callType;//视频 / 语音
@property (nonatomic, assign) NSInteger requestMore;//1发起多人音视频 2邀请加入多人音视频
@property (nonatomic, strong) NSArray *currentRoomUser;//当前房间里用户
@end

NS_ASSUME_NONNULL_END
