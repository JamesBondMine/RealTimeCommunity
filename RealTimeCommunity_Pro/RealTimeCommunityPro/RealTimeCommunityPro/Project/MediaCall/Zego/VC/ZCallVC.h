//
//  ZCallVC.h
//  CIMKit
//
//  Created by cusPro on 2023/5/19.
//

#import "BBBaseViewController.h"
#import "ZCallManager.h"//即构音视频单例

#import "BBBaseImageView.h"//图片基类
#import "ZToolManager.h"//工具类
//浮窗控件
#import "AppDelegate.h"
#import "ZWindowFloatView.h"
#import "ZCallFloatView.h"//单人音视频浮窗UI
//#import "ZMediaCallMoreFloatView.h"//多人音视频浮窗UI
#import "MediaZZCallVideoView.h"//视频渲染控件

NS_ASSUME_NONNULL_BEGIN

@interface ZCallVC : BBBaseViewController
<ZCallManagerDelegate>

//功能按钮
@property (nonatomic, strong) UIButton *btnMini;//最小化
@property (nonatomic, strong) UIButton *btnAccept;//被邀请者接听通话
@property (nonatomic, strong) UIButton *btnRefuse;//被邀请者拒绝通话
@property (nonatomic, strong) UIButton *btnEnd;//挂断通话(邀请者取消，邀请者挂断，被邀请者挂断)
@property (nonatomic, strong) UIButton *btnMutedAudio;//音频静默
@property (nonatomic, strong) UIButton *btnMutedVideo;//视频静默
@property (nonatomic, strong) UIButton *btnExternal;//免提
@property (nonatomic, strong) UIButton *btnCameraSwitch;//切换摄像头

//音视频房间加入
- (void)callRoomJoin;
//摄像头静默状态改变
- (void)callRoomCameraMute:(NSNotification *)notification;

//按钮显示动画
- (void)btnShowAnimationWith:(UIButton *)sender;
//按钮隐藏动画
- (void)btnHiddenAnimationWith:(UIButton *)sender;

//最小化
- (void)btnMiniClick;
//接听电话
- (void)btnAcceptClick;
//挂断电话
- (void)btnEndClick;
//音频静默
- (void)btnMutedAudioClick;
//视频静默
- (void)btnMutedVideoClick;
//免提
- (void)btnExternalClick;
//摄像头切换
- (void)btnCameraSwitchClick;

-(void)layoutBtn;
@end

NS_ASSUME_NONNULL_END
