//
//  ZCallMiniView.m
//  CIMKit
//
//  Created by cusPro on 2023/5/19.
//

#import "ZCallMiniView.h"
#import "BBBaseImageView.h"
#import "ZToolManager.h"
#import "ZCallManager.h"
#import "NTNavigationController.h"

#import "ZCallSingleVC.h"
#import "ZCallGroupVC.h"

@interface ZCallMiniView ()
@property (nonatomic, strong) BBBaseImageView *ivHeader;//头像
@property (nonatomic, strong) UILabel *lblNickname;//昵称
@property (nonatomic, strong) UILabel *lblCallTip;//提示
@property (nonatomic, strong) UIButton *btnAccept;//接收
@property (nonatomic, strong) UIButton *btnRefuse;//拒绝
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;//点击手势

@property (nonatomic, strong) ZUserModel *userModel;//对方用户信息

@property (nonatomic, strong) ZWindowFloatView *viewFloat;//浮窗
@end

@implementation ZCallMiniView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        
        //界面布局
        [self setupUI];
        //数据更新
        [self configCallInfo];
        
        //设置为不息屏
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
        //监听关闭UI
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaCallMiniViewDismiss) name:ZGCALLROOMEND object:nil];
        
        //销毁一下音视频通话计时器
        [[ZCallManager sharedManager] deallocCurrentCallDurationTimer];
        [[ZCallManager sharedManager] deallocCallHeartBeatTimer];
        
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    _viewFloat = [[ZWindowFloatView alloc] initWithFrame:CGRectMake(0, DNavStatusBarH + DWScale(10), DScreenWidth, 0)];
    _viewFloat.dragEnable = NO;
    [CurrentWindow addSubview:_viewFloat];
    
    self.frame = CGRectMake(0, 0, DScreenWidth, 0);
    self.backgroundColor = UIColor.clearColor;
    [_viewFloat addSubview:self];
    
    
    UIView *viewContent = [[UIView alloc] initWithFrame:CGRectMake(DWScale(8), 0, DScreenWidth - DWScale(16), DWScale(80))];
    viewContent.backgroundColor = UIColor.blackColor;
    viewContent.layer.cornerRadius = DWScale(16);
    viewContent.layer.masksToBounds = YES;
    [self addSubview:viewContent];
    
    _ivHeader = [[BBBaseImageView alloc] initWithFrame:CGRectMake(DWScale(15), DWScale(15), DWScale(50), DWScale(50))];
    _ivHeader.layer.cornerRadius = DWScale(25);
    _ivHeader.layer.masksToBounds = YES;
    [viewContent addSubview:_ivHeader];
    
    _lblNickname = [UILabel new];
    _lblNickname.textColor = UIColor.whiteColor;
    _lblNickname.font = FONTR(16);
    _lblNickname.preferredMaxLayoutWidth = DWScale(150);
    [viewContent addSubview:_lblNickname];
    [_lblNickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_ivHeader.mas_trailing).offset(DWScale(6));
        make.top.equalTo(_ivHeader);
    }];
    
    _lblCallTip = [UILabel new];
    _lblCallTip.textColor = UIColor.whiteColor;
    _lblCallTip.font = FONTR(14);
    _lblCallTip.preferredMaxLayoutWidth = DWScale(150);
    [viewContent addSubview:_lblCallTip];
    [_lblCallTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_lblNickname);
        make.bottom.equalTo(_ivHeader);
    }];
    
    _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [viewContent addGestureRecognizer:_tapGes];
    
    _btnAccept = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnAccept setImage:ImgNamed(@"ms_btn_accept") forState:UIControlStateNormal];
    [_btnAccept addTarget:self action:@selector(btnAcceptClick) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:_btnAccept];
    [_btnAccept mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewContent);
        make.trailing.equalTo(viewContent).offset(-DWScale(15));
        make.size.mas_equalTo(CGSizeMake(DWScale(40), DWScale(40)));
    }];
    
    _btnRefuse = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnRefuse setImage:ImgNamed(@"ms_btn_cancel") forState:UIControlStateNormal];
    [_btnRefuse addTarget:self action:@selector(btnRefuseClick) forControlEvents:UIControlEventTouchUpInside];
    [viewContent addSubview:_btnRefuse];
    [_btnRefuse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewContent);
        make.trailing.equalTo(_btnAccept.mas_leading).offset(-DWScale(20));
        make.size.mas_equalTo(CGSizeMake(DWScale(40), DWScale(40)));
    }];
    
}

#pragma mark - 界面更新
- (void)updateUI {
    //对方头像
    [_ivHeader sd_setImageWithURL:[_userModel.avatar getImageFullUrl] placeholderImage:DefaultAvatar options:SDWebImageAllowInvalidSSLCertificates];

    //对方昵称
    _lblNickname.text = _userModel.showName;
    
    //提示信息
    ZCallOptions *currentCallOptions = [ZCallManager sharedManager].currentCallOptions;
    NSString *tipStr = @"";
    if (currentCallOptions.zgCallOptions.callRoomType == LingIMCallRoomTypeSingle) {
        tipStr = currentCallOptions.zgCallOptions.callType == LingIMCallTypeAudio ? MultilingualTranslation(@"邀请你进行语音通话") : MultilingualTranslation(@"邀请你进行视频通话");
    }else if (currentCallOptions.zgCallOptions.callRoomType == LingIMCallRoomTypeGroup) {
        tipStr = currentCallOptions.zgCallOptions.callType == LingIMCallTypeAudio ? MultilingualTranslation(@"邀请你进行群语音通话") : MultilingualTranslation(@"邀请你进行群视频通话");
    }
    _lblCallTip.text = tipStr;
}
#pragma mark - 根据通话信息进行界面的赋值
- (void)configCallInfo {
    //此界面的出现，说明我一定是被邀请者
    ZCallOptions *currentCallOptions = [ZCallManager sharedManager].currentCallOptions;
    
    if (currentCallOptions.zgCallOptions.callRoomType == LingIMCallRoomTypeSingle) {
        //单聊音视频
        //获取对我发起邀请的好友信息
        [self getCallRequestFriendInfo];
        
    }else if (currentCallOptions.zgCallOptions.callRoomType == LingIMCallRoomTypeGroup) {
        //群聊音视频
        //获取发起邀请的群成员信息
        [self getCallRequestMemberInfo];
    }
}

#pragma mark - 数据请求，获取对方用户信息
//获取好友的信息
- (void)getCallRequestFriendInfo {
    
    NSString *friendUid = [ZCallManager sharedManager].currentCallOptions.inviterUserModel.userUid;
    
    LingIMFriendModel *friendModel = [IMSDKManager toolCheckMyFriendWith:friendUid];
    
    if (friendModel) {
        _userModel = [ZUserModel new];
        _userModel.showName = friendModel.showName;
        _userModel.avatar = friendModel.avatar;
        _userModel.userName = friendModel.userName;
        _userModel.nickname = friendModel.nickname;
        _userModel.userUID = friendModel.friendUserUID;
        _userModel.remarks = friendModel.remarks;
        _userModel.descRemark = friendModel.descRemark;
        [self updateUI];
    }else {
        [self requestUserInfoWith:friendUid];
    }
}
//获取某个群成员信息
- (void)getCallRequestMemberInfo {
    NSString *groupID = [ZCallManager sharedManager].currentCallOptions.groupID;
    NSString *groupMemberID = [ZCallManager sharedManager].currentCallOptions.inviterUserModel.userUid;
    LingIMGroupMemberModel *groupMemberModel =  [IMSDKManager imSdkCheckGroupMemberWith:groupMemberID groupID:groupID];
    if (groupMemberModel) {
        _userModel = [ZUserModel new];
        _userModel.showName = groupMemberModel.showName;
        _userModel.avatar = groupMemberModel.userAvatar;
        _userModel.userName = groupMemberModel.userName;
        _userModel.nickname = groupMemberModel.userNickname;
        _userModel.userUID = groupMemberModel.userUid;
        _userModel.remarks = groupMemberModel.remarks;
        _userModel.descRemark = groupMemberModel.descRemark;
        [self updateUI];
    }else {
        [self requestUserInfoWith:groupMemberID];
    }
}

//根据用户的Uid获取用户信息
- (void)requestUserInfoWith:(NSString *)userUid {

    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:userUid forKey:@"userUid"];
    [IMSDKManager getUserInfoWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userDict = (NSDictionary *)data;
            weakSelf.userModel = [ZUserModel mj_objectWithKeyValues:userDict];
            weakSelf.userModel.userUID = [NSString stringWithFormat:@"%@",[userDict objectForKeySafe:@"userUid"]];
            [weakSelf updateUI];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - 动画
- (void)mediaCallMiniViewShow {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = DWScale(80);
        weakSelf.viewFloat.height = DWScale(80);
    }];
    
    [ZCallManager sharedManager].callState = ZCallStateBegin;
}
- (void)mediaCallMiniViewDismiss {
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.height = 0;
        weakSelf.viewFloat.height = 0;
    } completion:^(BOOL finished) {
        [ZTOOL doInMain:^{
            [weakSelf.viewFloat removeFromSuperview];
            weakSelf.viewFloat = nil;
        }];
    }];
}
#pragma mark - 同意音视频邀请
//单人音视频
- (void)callAccept {
    ZCallOptions *currentCallOptions = [ZCallManager sharedManager].currentCallOptions;
    
    if (currentCallOptions) {
        WeakSelf
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:currentCallOptions.zgCallOptions.callID forKey:@"callId"];
        [[ZCallManager sharedManager] callAcceptWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            
            if (currentCallOptions.zgCallOptions.callRoomType == LingIMCallRoomTypeSingle) {
                //单人音视频
                //被邀请者，同意音视频通话请求后，先进入房间
                ZCallSingleVC *vc = [ZCallSingleVC new];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [vc callRoomJoin];
                [CurrentVC presentViewController:vc animated:YES completion:nil];
            }else if (currentCallOptions.zgCallOptions.callRoomType == LingIMCallRoomTypeGroup) {
                //多人音视频
                //被邀请者，同意音视频通话请求，邀请者已经在房间等候啦
                ZCallGroupVC *vc = [ZCallGroupVC new];
                [vc callRoomJoin];
                NTNavigationController *nav = [[NTNavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationFullScreen;
                [CurrentVC presentViewController:nav animated:YES completion:nil];
            }
            
            [weakSelf mediaCallMiniViewDismiss];
            
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            [HUD showMessageWithCode:code errorMsg:msg];
            weakSelf.tapGes.enabled = YES;
        }];
    }else {
        [HUD showMessage:MultilingualTranslation(@"操作失败")];
        self.tapGes.enabled = YES;
    }
    
}

#pragma mark - 交互事件
- (void)tapClick {
    
    //防止重复点击
    if (!_tapGes.isEnabled) return;
    
    ZCallOptions *currentCallOptions = [ZCallManager sharedManager].currentCallOptions;
    
    if (!currentCallOptions) return;
    
    _tapGes.enabled = NO;
    
    [self mediaCallMiniViewDismiss];
    
    if (currentCallOptions.zgCallOptions.callRoomType == LingIMCallRoomTypeSingle) {
        //单人音视频
        ZCallSingleVC *callVC = [ZCallSingleVC new];
        callVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [CurrentVC presentViewController:callVC animated:YES completion:nil];
    }else {
        ZCallGroupVC *vc = [ZCallGroupVC new];
        NTNavigationController *nav = [[NTNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [CurrentVC presentViewController:nav animated:YES completion:nil];
    }
    
}
- (void)btnAcceptClick {
    
    //防止重复点击
    if (!_tapGes.isEnabled) return;
    
    ZCallOptions *currentCallOptions = [ZCallManager sharedManager].currentCallOptions;
    
    if (!currentCallOptions) return;
    
    _tapGes.enabled = NO;
    
    WeakSelf
    if (currentCallOptions.zgCallOptions.callType == LingIMCallTypeAudio) {
        //音频
        [ZTOOL getMicrophoneAuth:^(BOOL granted) {
            DLog(@"麦克风权限:%d",granted);
            [weakSelf callAccept];
        }];
    }else {
        //视频
        [ZTOOL getMicrophoneAuth:^(BOOL granted) {
            DLog(@"麦克风权限:%d",granted);
            [ZTOOL getCameraAuth:^(BOOL granted) {
                DLog(@"相机权限:%d",granted);
                [weakSelf callAccept];
            }];
        }];
    }
    
    //取消消息提醒
    [IMSDKManager toolMessageReceiveRemindEndForMediaCall];
}

- (void)btnRefuseClick {
    
    //防止重复点击
    if (!_tapGes.isEnabled) return;
    
    ZCallOptions *currentCallOptions = [ZCallManager sharedManager].currentCallOptions;
    
    if (!currentCallOptions) return;
    
    _tapGes.enabled = NO;
    
    if (currentCallOptions) {
        WeakSelf
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"refuse" forKey:@"discardType"];//挂断类型 拒绝
        [dict setValue:currentCallOptions.zgCallOptions.callID forKey:@"callId"];
        [[ZCallManager sharedManager] callDiscardWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            [weakSelf mediaCallMiniViewDismiss];
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            [HUD showMessageWithCode:code errorMsg:msg];
            [weakSelf mediaCallMiniViewDismiss];
        }];
        
    } else {
        [self mediaCallMiniViewDismiss];
        
        [ZCallManager sharedManager].currentCallOptions = nil;
        [ZCallManager sharedManager].callState = ZCallStateEnd;
    };
    
    //取消消息提醒
    [IMSDKManager toolMessageReceiveRemindEndForMediaCall];
}

#pragma mark - 界面销毁
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"音视频通话-收到通话邀请弹窗-销毁");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
