//
//  NFFriendApplyPassVC.m
//  CIMKit
//
//  Created by cusPro on 2022/10/21.
//

#import "NFFriendApplyPassVC.h"
#import "NVSampleUserInfoView.h"

#import "NHChatViewController.h"//聊天
#import "ZKnownTipView.h"
#import "NFUserHomePageVC.h"
@interface NFFriendApplyPassVC ()
@property (nonatomic, strong) NVSampleUserInfoView *viewHeader;
@property (nonatomic, strong) UIButton *btnMessage;//发消息
@property (nonatomic, strong) UILabel *lblMessageTip;
@property (nonatomic, strong) UIButton *btnPass;//通过验证
@property (nonatomic, strong) UIButton *btnAdd;//添加好友

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) ZUserModel *userModel;
@end

@implementation NFFriendApplyPassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_applyModel.fromUserUid isEqualToString:UserManager.userInfo.userUID]) {
        //我发起的好友申请
        _userID = _applyModel.beUserUid;
    }else {
        //对方发起的好友申请
        _userID = _applyModel.fromUserUid;
    }
    
    [self setupUI];
    [self requestUserInfo];
    [self requestCheckFriend];
}
#pragma mark - 界面布局
- (void)setupUI {
    
    [self defaultTableViewUI];
    
//    _viewHeader = [[NVSampleUserInfoView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DWScale(90))];
//    self.baseTableView.tableHeaderView = _viewHeader;
    _viewHeader = [[NVSampleUserInfoView alloc] init];
    [self.view addSubview:_viewHeader];
    
    [_viewHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.leading.mas_equalTo(0);
        make.width.mas_equalTo(DScreenWidth);
        make.bottom.mas_equalTo(-DHomeBarH - DWScale(58));
    }];
    
    _btnMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMessage.hidden = YES;
    [_btnMessage setImage:ImgNamed(@"recon_call_text") forState:UIControlStateNormal];
    [_btnMessage addTarget:self action:@selector(btnMessageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnMessage];
    [_btnMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-DHomeBarH - DWScale(58));
        make.size.mas_equalTo(CGSizeMake(DWScale(56), DWScale(56)));
    }];
    
    _lblMessageTip = [UILabel new];
    _lblMessageTip.hidden = YES;
    _lblMessageTip.text = MultilingualTranslation(@"发消息");
    _lblMessageTip.tkThemetextColors = @[COLOR_81D8CF, COLOR_81D8CF_DARK];
    _lblMessageTip.font = FONTR(14);
    [self.view addSubview:_lblMessageTip];
    [_lblMessageTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_btnMessage);
        make.top.equalTo(_btnMessage.mas_bottom).offset(DWScale(10));
    }];
    
    _btnPass = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnPass.hidden = YES;
    [_btnPass setBackgroundColor:COLOR_81D8CF];
    [_btnPass setTitle:MultilingualTranslation(@"通过验证") forState:UIControlStateNormal];
    [_btnPass setTitleColor:COLORWHITE forState:UIControlStateNormal];
    _btnPass.titleLabel.font = FONTR(16);
    [_btnPass addTarget:self action:@selector(btnPassClick) forControlEvents:UIControlEventTouchUpInside];
    _btnPass.layer.cornerRadius = DWScale(14);
    _btnPass.layer.masksToBounds = YES;
    [self.view addSubview:_btnPass];
    [_btnPass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH - DWScale(316));
        make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(50)));
    }];
    
    _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnAdd.hidden = YES;
    _btnAdd.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF];
    [_btnAdd setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
    [_btnAdd setTitle:MultilingualTranslation(@"添加好友") forState:UIControlStateNormal];
    [_btnAdd setTitleColor:COLORWHITE forState:UIControlStateNormal];
    _btnAdd.titleLabel.font = FONTR(16);
    [_btnAdd addTarget:self action:@selector(btnAddClick) forControlEvents:UIControlEventTouchUpInside];
    _btnAdd.layer.cornerRadius = DWScale(14);
    _btnAdd.layer.masksToBounds = YES;
    [self.view addSubview:_btnAdd];
    [_btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH - DWScale(316));
        make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(50)));
    }];
    
}
#pragma mark - 数据请求
//获取用户信息
- (void)requestUserInfo {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_userID forKey:@"userUid"];
    [IMSDKManager getUserInfoWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userDict = (NSDictionary *)data;
            weakSelf.userModel = [ZUserModel mj_objectWithKeyValues:userDict];
            weakSelf.userModel.userUID = [NSString stringWithFormat:@"%@",[userDict objectForKeySafe:@"userUid"]];
            [weakSelf.viewHeader updateUIWithUserModel:weakSelf.userModel isMyFriend:NO inGroupUserName:@""];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}
//判断是否为好友
- (void)requestCheckFriend {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_userID forKey:@"friendUserUid"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    
    [IMSDKManager checkMyFriendWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        BOOL isMyFriend = [data boolValue];
        [weakSelf updateBtnUI:isMyFriend];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
    }];
    
}
- (void)updateBtnUI:(BOOL)isMyFriend {
    if (isMyFriend) {
        //好友关系
        _btnMessage.hidden = NO;
        _lblMessageTip.hidden = NO;
        _btnAdd.hidden = YES;
        _btnPass.hidden = YES;
    }else {
        //不是好友关系
        if ([_applyModel.fromUserUid isEqualToString:UserManager.userInfo.userUID]) {
            //我发起的好友申请
            if (_applyModel.beStatus != 0) {
                //重新发送好友申请
                _btnAdd.hidden = NO;
                _btnPass.hidden = YES;
                _btnMessage.hidden = YES;
                _lblMessageTip.hidden = YES;
            }
        }else {
            //对方发起的好友申请
            if (_applyModel.beStatus == 0) {
                //申请中
                _btnPass.hidden = NO;
                _btnAdd.hidden = YES;
                _btnMessage.hidden = YES;
                _lblMessageTip.hidden = YES;
            }
        }
    }
}
#pragma mark - 交互事件
//添加好友
- (void)btnAddClick {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_userID forKey:@"friendUserUid"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [IMSDKManager addContactWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD showMessage:MultilingualTranslation(@"已发送")];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        ZKnownTipView *viewTip = [ZKnownTipView new];
        viewTip.lblTip.text = MultilingualTranslation(msg);
        [viewTip knownTipViewSHow];
    }];
    
}
//发消息
- (void)btnMessageClick {
    NHChatViewController *vc = [NHChatViewController new];
    vc.sessionID = _userID;
    vc.chatName = _userModel.nickname;
    vc.chatType = CIMChatType_SingleChat;
    [self.navigationController pushViewController:vc animated:YES];
}
//通过验证
- (void)btnPassClick {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_userID forKey:@"friendUserUid"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [IMSDKManager confirmFriendApplyWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD showMessage:MultilingualTranslation(@"添加成功")];
        weakSelf.btnPass.hidden = YES;
        weakSelf.btnMessage.hidden = NO;
        weakSelf.applyModel.beStatus = 1;
        [weakSelf postNotification];
        
        
        NFUserHomePageVC *vc = [NFUserHomePageVC new];
        vc.userUID = self->_userID;
        vc.groupID = @"";
        [weakSelf.navigationController pushViewController:vc animated:NO];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}
//发送好友添加成功的通知
- (void)postNotification {
    
    LingIMFriendModel *friendModel = [LingIMFriendModel new];
    friendModel.nickname = _userModel.nickname;
    friendModel.friendUserUID = _userID;
    friendModel.avatar = _userModel.avatar;
    [IMSDKManager toolAddMyFriendWith:friendModel];
    
    //好友新增 走代理了
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:_userID forKey:@"friendUid"];//好友id
//    [dict setValue:@"add" forKey:@"changeType"];//改变类型
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"FriendListChange" object:nil userInfo:dict];
    
    //通讯录好友申请，红点更新(修改为，看后，红点就消失)
//    NSInteger friendApplyCount = [IMSDKManager toolFriendApplyCount];
//    friendApplyCount--;
//    [IMSDKManager toolUpdateFriendApplyCount:friendApplyCount];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"FriendApplyCountChange" object:nil];
    
    //从已读列表里删除
    NSString *hashKeyStr = [[MMKV defaultMMKV] getStringForKey:@"ReadFriendApply"];
    NSArray *readArr = [hashKeyStr componentsSeparatedByString:@","];
    NSMutableArray *readApply = [NSMutableArray arrayWithArray:readArr];
    
    if ([readApply containsObject:[NSString stringWithFormat:@"%@-%@",_applyModel.hashKey,_applyModel.sendTime]]) {
        
        [readApply removeObject:[NSString stringWithFormat:@"%@-%@",_applyModel.hashKey,_applyModel.sendTime]];
        NSString *hiddenStr = [readApply componentsJoinedByString:@","];
        [[MMKV defaultMMKV] setString:hiddenStr forKey:@"ReadFriendApply"];
        
        
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
