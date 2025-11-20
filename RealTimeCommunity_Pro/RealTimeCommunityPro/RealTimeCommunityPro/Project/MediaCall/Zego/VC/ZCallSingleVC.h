//
//  ZCallSingleVC.h
//  CIMKit
//
//  Created by cusPro on 2023/5/19.
//

// 即构 单聊 音视频通话 VC

#import "ZCallVC.h"
#import "ZMediaCallShimmerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCallSingleVC : ZCallVC

@property (nonatomic, strong) UILabel *lblTime;//会话进行的时间
@property (nonatomic, strong) BBBaseImageView *ivHeaderBg;//对方头像模糊背景
@property (nonatomic, strong) BBBaseImageView *ivHeader;//对方头像
@property (nonatomic, strong) UILabel *lblNickname;//对方昵称
@property (nonatomic, strong) UILabel *lblCallTip;//会话提示
@property (nonatomic, strong) ZMediaCallShimmerView *viewShimmer;//闪光效果

@end

NS_ASSUME_NONNULL_END
