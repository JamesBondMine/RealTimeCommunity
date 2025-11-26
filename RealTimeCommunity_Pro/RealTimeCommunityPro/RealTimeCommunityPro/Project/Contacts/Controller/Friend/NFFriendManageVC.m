//
//  NFFriendManageVC.m
//  CIMKit
//
//  Created by cusPro on 2022/10/22.
//

#import "NFFriendManageVC.h"
#import "ZMessageAlertView.h"
#import "ZMessageTools.h"
#import "NotesSettingViewController.h"
#import "NHChatMultiSelectViewController.h"  //推荐给朋友选择转发对象
#import "ZComplainVC.h"//投诉与支持
#import "NFFriendGroupManagerVC.h"//好友分组管理

@interface NFFriendManageVC ()
@property (nonatomic, strong) UIButton *blackBtn;//加入黑名单
@property (nonatomic, strong) UILabel *lblFriendGroup;//好友分组
@property (nonatomic, strong) LingIMFriendGroupModel *currentFriendGroupModel;//当前好友所属好友分组信息
@end

@implementation NFFriendManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleStr = MultilingualTranslation(@"好友管理");
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    
    [self setupUI];
    [self requestGetBlackStatus];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    LingIMFriendModel *myFriendModel = [IMSDKManager toolCheckMyFriendWith:_friendUID];
    if (myFriendModel) {
        LingIMFriendGroupModel *friendGroupModel = [IMSDKManager toolCheckMyFriendGroupWith:myFriendModel.ugUuid];
        if (friendGroupModel) {
            _lblFriendGroup.text = ![NSString isNil:friendGroupModel.ugName] ? friendGroupModel.ugName : MultilingualTranslation(@"默认分组");
            _currentFriendGroupModel = friendGroupModel;
        }
    }
    
}
#pragma mark - 界面布局
- (void)setupUI {
    if (self.userModel.disableStatus == 4) {
        //已注销
        
        //删除好友
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [btnDelete setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateHighlighted];
        [btnDelete setTitle:MultilingualTranslation(@"删除好友") forState:UIControlStateNormal];
        [btnDelete setTitleColor:HEXCOLOR(@"FF3333") forState:UIControlStateNormal];
        btnDelete.titleLabel.font = FONTB(16); // 商务风格：加粗字体
        // 商务风格：更小圆角
        btnDelete.layer.cornerRadius = DWScale(6);
        btnDelete.layer.masksToBounds = NO; // 允许显示阴影
        // 添加卡片阴影
        btnDelete.layer.shadowColor = [UIColor blackColor].CGColor;
        btnDelete.layer.shadowOffset = CGSizeMake(0, 2);
        btnDelete.layer.shadowOpacity = 0.06;
        btnDelete.layer.shadowRadius = 4;
        [btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDelete];
        [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.navView.mas_bottom).offset(DWScale(20)); // 增加顶部间距
            make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(54)));
        }];
        
    } else {
        
        //设置备注
        UIView *setRemarkBgView = [[UIView alloc] init];
        setRemarkBgView.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [setRemarkBgView rounded:6]; // 商务风格：更小圆角
        setRemarkBgView.clipsToBounds = NO; // 允许显示阴影
        // 商务风格：添加卡片阴影
        setRemarkBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        setRemarkBgView.layer.shadowOffset = CGSizeMake(0, 2);
        setRemarkBgView.layer.shadowOpacity = 0.06;
        setRemarkBgView.layer.shadowRadius = 4;
        [self.view addSubview:setRemarkBgView];
        [setRemarkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navView.mas_bottom).offset(DWScale(20)); // 增加顶部间距
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(54)));
        }];
        
        UIButton *setRemarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setRemarkBtn.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [setRemarkBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateHighlighted];
        setRemarkBtn.layer.cornerRadius = DWScale(6);
        setRemarkBtn.layer.masksToBounds = YES;
        [setRemarkBtn addTarget:self action:@selector(setRemarkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [setRemarkBgView addSubview:setRemarkBtn];
        [setRemarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(setRemarkBgView);
        }];
        
        UILabel *setRemarkLabel = [[UILabel alloc] init];
        setRemarkLabel.text = MultilingualTranslation(@"设置备注");
        setRemarkLabel.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        setRemarkLabel.font = FONTN(16);
        [setRemarkBgView addSubview:setRemarkLabel];
        [setRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(setRemarkBgView);
            make.leading.equalTo(setRemarkBgView).offset(16);
            make.size.mas_equalTo(CGSizeMake(DWScale(100), DWScale(22)));
        }];
        
        UIImageView * ivArrow1 = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
        [setRemarkBgView addSubview:ivArrow1];
        [ivArrow1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(setRemarkBgView);
            make.trailing.equalTo(setRemarkBgView).offset(-DWScale(16));
            make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
        }];

        //分组
        UIView *viewFriendGroup = [[UIView alloc] init];
        viewFriendGroup.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [viewFriendGroup rounded:6]; // 商务风格：更小圆角
        viewFriendGroup.clipsToBounds = NO; // 允许显示阴影
        // 商务风格：添加卡片阴影
        viewFriendGroup.layer.shadowColor = [UIColor blackColor].CGColor;
        viewFriendGroup.layer.shadowOffset = CGSizeMake(0, 2);
        viewFriendGroup.layer.shadowOpacity = 0.06;
        viewFriendGroup.layer.shadowRadius = 4;
        [self.view addSubview:viewFriendGroup];
        [viewFriendGroup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(setRemarkBgView.mas_bottom).offset(DWScale(12)); // 卡片间距优化
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(54)));
        }];
        
        UIButton *btnFriendGroup = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFriendGroup.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [btnFriendGroup setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateHighlighted];
        btnFriendGroup.layer.cornerRadius = DWScale(6);
        btnFriendGroup.layer.masksToBounds = YES;
        [btnFriendGroup addTarget:self action:@selector(btnFriendGroupClick) forControlEvents:UIControlEventTouchUpInside];
        [viewFriendGroup addSubview:btnFriendGroup];
        [btnFriendGroup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(viewFriendGroup);
        }];
        
        UILabel *lblFriendGroupTip = [[UILabel alloc] init];
        lblFriendGroupTip.text = MultilingualTranslation(@"分组");
        lblFriendGroupTip.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        lblFriendGroupTip.font = FONTN(16);
        [viewFriendGroup addSubview:lblFriendGroupTip];
        [lblFriendGroupTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewFriendGroup);
            make.leading.equalTo(viewFriendGroup).offset(16);
            make.size.mas_equalTo(CGSizeMake(DWScale(100), DWScale(22)));
        }];
        
        UIImageView * ivArrowFriendGroup = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
        [viewFriendGroup addSubview:ivArrowFriendGroup];
        [ivArrowFriendGroup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewFriendGroup);
            make.trailing.equalTo(viewFriendGroup).offset(-DWScale(16));
            make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
        }];
        
        _lblFriendGroup = [UILabel new];
        _lblFriendGroup.tkThemetextColors = @[COLOR_99, COLOR_99_DARK];
        _lblFriendGroup.font = FONTR(12);
        [viewFriendGroup addSubview:_lblFriendGroup];
        [_lblFriendGroup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewFriendGroup);
            make.trailing.equalTo(ivArrowFriendGroup.mas_leading).offset(-DWScale(16));
        }];
        
        //推荐给朋友
        UIView *recommendBgView = [[UIView alloc] init];
        recommendBgView.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [recommendBgView rounded:6]; // 商务风格：更小圆角
        recommendBgView.clipsToBounds = NO; // 允许显示阴影
        // 商务风格：添加卡片阴影
        recommendBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        recommendBgView.layer.shadowOffset = CGSizeMake(0, 2);
        recommendBgView.layer.shadowOpacity = 0.06;
        recommendBgView.layer.shadowRadius = 4;
        [self.view addSubview:recommendBgView];
        [recommendBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewFriendGroup.mas_bottom).offset(DWScale(12)); // 卡片间距优化
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(54)));
        }];
        
        UIButton *recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recommendBtn.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [recommendBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateHighlighted];
        recommendBtn.layer.cornerRadius = DWScale(6);
        recommendBtn.layer.masksToBounds = YES;
        [recommendBtn addTarget:self action:@selector(recommendToFriendClick) forControlEvents:UIControlEventTouchUpInside];
        [recommendBgView addSubview:recommendBtn];
        [recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(recommendBgView);
        }];
        
        UILabel *recommendLabel = [[UILabel alloc] init];
        recommendLabel.text = MultilingualTranslation(@"推荐给朋友");
        recommendLabel.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        recommendLabel.font = FONTN(16);
        [recommendBgView addSubview:recommendLabel];
        [recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(recommendBgView);
            make.leading.equalTo(recommendBgView).offset(16);
            make.size.mas_equalTo(CGSizeMake(DWScale(200), DWScale(22)));
        }];
        
        UIImageView * ivArrow2 = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
        [recommendBgView addSubview:ivArrow2];
        [ivArrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(recommendBgView);
            make.trailing.equalTo(recommendBgView).offset(-DWScale(16));
            make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
        }];

        //黑名单
        UIView *blackBackView = [[UIView alloc] init];
        blackBackView.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [blackBackView rounded:6]; // 商务风格：更小圆角
        blackBackView.clipsToBounds = NO; // 允许显示阴影
        // 商务风格：添加卡片阴影
        blackBackView.layer.shadowColor = [UIColor blackColor].CGColor;
        blackBackView.layer.shadowOffset = CGSizeMake(0, 2);
        blackBackView.layer.shadowOpacity = 0.06;
        blackBackView.layer.shadowRadius = 4;
        [self.view addSubview:blackBackView];
        [blackBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recommendBgView.mas_bottom).offset(DWScale(12)); // 卡片间距优化
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(54)));
        }];
        
        UILabel *blackLbl = [[UILabel alloc] init];
        blackLbl.text = MultilingualTranslation(@"加入黑名单");
        blackLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        blackLbl.font = FONTN(16);
        [blackBackView addSubview:blackLbl];
        [blackLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(blackBackView);
            make.leading.equalTo(blackBackView).offset(16);
            make.trailing.equalTo(blackBackView).offset(-DWScale(70));
            make.height.mas_equalTo(DWScale(22));
        }];
        
        self.blackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.blackBtn setImage:ImgNamed(@"com_c_switch_off") forState:UIControlStateNormal];
        [self.blackBtn setImage:ImgNamed(@"com_c_switch_on") forState:UIControlStateSelected];
        [self.blackBtn addTarget:self action:@selector(btnBlackListClick) forControlEvents:UIControlEventTouchUpInside];
        [blackBackView addSubview:self.blackBtn];
        [self.blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(blackBackView);
            make.trailing.equalTo(blackBackView).offset(-16);
            make.size.mas_equalTo(CGSizeMake(DWScale(44), DWScale(44)));
        }];
        
        //投诉
        UIView *viewComplain = [[UIView alloc] init];
        viewComplain.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [viewComplain rounded:6]; // 商务风格：更小圆角
        viewComplain.clipsToBounds = NO; // 允许显示阴影
        // 商务风格：添加卡片阴影
        viewComplain.layer.shadowColor = [UIColor blackColor].CGColor;
        viewComplain.layer.shadowOffset = CGSizeMake(0, 2);
        viewComplain.layer.shadowOpacity = 0.06;
        viewComplain.layer.shadowRadius = 4;
        [self.view addSubview:viewComplain];
        [viewComplain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(blackBackView.mas_bottom).offset(DWScale(12)); // 卡片间距优化
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(54)));
        }];
        
        UIButton *btnComplain = [UIButton buttonWithType:UIButtonTypeCustom];
        btnComplain.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [btnComplain setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateHighlighted];
        btnComplain.layer.cornerRadius = DWScale(6);
        btnComplain.layer.masksToBounds = YES;
        [btnComplain addTarget:self action:@selector(btnComplainClick) forControlEvents:UIControlEventTouchUpInside];
        [viewComplain addSubview:btnComplain];
        [btnComplain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(viewComplain);
        }];
        
        UILabel *lblComplain = [[UILabel alloc] init];
        lblComplain.text = MultilingualTranslation(@"投诉与支持");
        lblComplain.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        lblComplain.font = FONTN(16);
        [viewComplain addSubview:lblComplain];
        [lblComplain mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewComplain);
            make.leading.equalTo(viewComplain).offset(16);
            make.size.mas_equalTo(CGSizeMake(DWScale(200), DWScale(22)));
        }];
        
        UIImageView * ivArrow3 = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
        [viewComplain addSubview:ivArrow3];
        [ivArrow3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewComplain);
            make.trailing.equalTo(viewComplain).offset(-DWScale(16));
            make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
        }];
        
        //删除好友
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
        [btnDelete setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateHighlighted];
        [btnDelete setTitle:MultilingualTranslation(@"删除好友") forState:UIControlStateNormal];
        [btnDelete setTitleColor:HEXCOLOR(@"FF3333") forState:UIControlStateNormal];
        btnDelete.titleLabel.font = FONTB(16); // 商务风格：加粗字体
        // 商务风格：更小圆角
        btnDelete.layer.cornerRadius = DWScale(6);
        btnDelete.layer.masksToBounds = NO; // 允许显示阴影
        // 添加卡片阴影
        btnDelete.layer.shadowColor = [UIColor blackColor].CGColor;
        btnDelete.layer.shadowOffset = CGSizeMake(0, 2);
        btnDelete.layer.shadowOpacity = 0.06;
        btnDelete.layer.shadowRadius = 4;
        [btnDelete addTarget:self action:@selector(btnDeleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDelete];
        [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(viewComplain.mas_bottom).offset(DWScale(20)); // 增加顶部间距，与其他卡片区分
            make.size.mas_equalTo(CGSizeMake(DWScale(343), DWScale(54)));
        }];
    }
}

#pragma mark - 交互事件
//设置备注
- (void)setRemarkBtnClick{
    NotesSettingViewController *vc = [[NotesSettingViewController alloc] initWithTitle:MultilingualTranslation(@"备注") 
                                                                                remark:self.userModel.remarks 
                                                                           description:self.userModel.descRemark];
    WeakSelf;
    vc.saveBtnBlock = ^(NSString * _Nonnull remarkStr, NSString * _Nonnull desStr) {
        [weakSelf requestSetRemarkAndDes:remarkStr desStr:desStr];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//好友分组
- (void)btnFriendGroupClick {
    NFFriendGroupManagerVC *vc = [NFFriendGroupManagerVC new];
    vc.friendGroupCanEdit = NO;
    vc.currentFriendGroupModel = _currentFriendGroupModel;
    vc.friendID = _friendUID;
    [self.navigationController pushViewController:vc animated:YES];
}

//推荐给朋友
- (void)recommendToFriendClick {
    NHChatMultiSelectViewController *vc = [NHChatMultiSelectViewController new];
    vc.multiSelectType = ZMultiSelectTypeRecommentCard;
    vc.cardFriendInfo = self.userModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnDeleteClick {
    WeakSelf
    ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeTitle supView:nil];
    msgAlertView.lblTitle.text = MultilingualTranslation(@"删除好友");
    msgAlertView.lblContent.text = MultilingualTranslation(@"删除后，同时删除与该好友的所有聊天记录，且不可撤回。");
    msgAlertView.lblContent.textAlignment = NSTextAlignmentLeft;
    [msgAlertView.btnSure setTitle:MultilingualTranslation(@"删除") forState:UIControlStateNormal];
//    [msgAlertView.btnSure setTkThemeTitleColor:@[COLOR_FF3333, COLOR_FF3333_DARK] forState:UIControlStateNormal];
//    msgAlertView.btnSure.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F5F6F9_DARK];
    [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
//    [msgAlertView.btnCancel setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
//    msgAlertView.btnCancel.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF_DARK];
    [msgAlertView alertShow];
    msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
        [weakSelf requestDeleteFriend];
    };
}

- (void)btnBlackListClick {
    if (self.blackBtn.selected == NO) {
        WeakSelf
        ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeTitle supView:nil];
        msgAlertView.lblTitle.text = MultilingualTranslation(@"加入黑名单");
        msgAlertView.lblContent.text = MultilingualTranslation(@"加入黑名单后，你将接收不到对方信息，如需接收，请关闭加入黑名单或在个人中心移出黑名单");
        msgAlertView.lblContent.textAlignment = NSTextAlignmentLeft;
        [msgAlertView.btnSure setTitle:MultilingualTranslation(@"确认") forState:UIControlStateNormal];
//        [msgAlertView.btnSure setTkThemeTitleColor:@[COLOR_FF3333, COLOR_FF3333_DARK] forState:UIControlStateNormal];
//        msgAlertView.btnSure.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F6F6F6_DARK];
        [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
//        [msgAlertView.btnCancel setTkThemeTitleColor:@[COLORWHITE, COLORWHITE_DARK] forState:UIControlStateNormal];
//        msgAlertView.btnCancel.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF_DARK];
        [msgAlertView alertShow];
        msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
            [weakSelf requestBlackFriend];
        };
    } else {
        [self requestBlackFriend];
    }
}

//投诉
- (void)btnComplainClick {
    ZComplainVC *vc = [ZComplainVC new];
    vc.complainID = self.friendUID;
    vc.complainType = CIMChatType_SingleChat;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络请求
//设置备注和描述
- (void)requestSetRemarkAndDes:(NSString *)remark desStr:(NSString *)desStr{
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.friendUID forKey:@"friendUserUid"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [dict setValue:remark forKey:@"remark"];
    [dict setValue:desStr forKey:@"descRemark"];
    
    [IMSDKManager friendSetFriendRemarkAndDesWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //请求更新试图
        [HUD showMessage:MultilingualTranslation(@"保存成功")];
        LingIMFriendModel *friendModel = [IMSDKManager toolCheckMyFriendWith:weakSelf.userModel.userUID];
        if (friendModel != nil) {
            friendModel.remarks = remark;
            if (![NSString isNil:remark]) {
                friendModel.showName = remark;
            } else {
                friendModel.showName = friendModel.nickname;
            }
            //更新好友信息
            [weakSelf requestPullFriendInfo:friendModel.friendUserUID];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//重新拉取好友信息
- (void)requestPullFriendInfo:(NSString *)friendUid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [params setValue:friendUid forKey:@"friendUserUid"];
    [IMSDKManager getFriendInfoWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        NSDictionary *friendDict = (NSDictionary *)data;
        LingIMFriendModel *friendModel = [LingIMFriendModel mj_objectWithKeyValues:friendDict];
        [IMSDKManager toolUpdateMyFriendWith:friendModel];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
    }];
}

//检查是否被拉黑
- (void)requestGetBlackStatus {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_friendUID forKey:@"friendUserUid"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    
    [IMSDKManager getUserBlackStateWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        BOOL checkResult = [data boolValue];
        weakSelf.blackBtn.selected = checkResult;
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
    }];
    
}

//删除好友
- (void)requestDeleteFriend {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_friendUID forKey:@"friendUserUid"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    
    [IMSDKManager deleteContactWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD showMessage:MultilingualTranslation(@"删除成功")];
        
        //清空本地数据，删除好友服务端会删除聊天记录
        [weakSelf deleteSessionAndChatHistory];
        
        //清空好友相关的缓存
        [ZMessageTools clearChatLocalImgAndVideoFromSessionId:weakSelf.friendUID];
        
        //返回到指定界面
        [weakSelf performSelector:@selector(navigationBackToVC) withObject:nil afterDelay:0.3];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        if(code == LingIMHttpResponseCodeExamineStatus){
            [HUD showMessage:MultilingualTranslation(@"提交成功，系统稍后处理")];
        }else if (code == LingIMHttpResponseCodeNoneExamineStatus){
            [HUD showMessage:MultilingualTranslation(@"您已经提交过申请，请耐心等待审核")];
        }else{
            [HUD showMessageWithCode:code errorMsg:msg];
        }
    }];
    
}
//删除会话和聊天数据
- (void)deleteSessionAndChatHistory {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_friendUID forKey:@"peerUid"];
    [dict setValue:@(0) forKey:@"dialogType"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    
    [IMSDKManager deleteServerConversation:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        //删除本地会话，同时删除本地聊天内容
        LingIMSessionModel *sessionModel = [IMSDKManager toolCheckMySessionWith:weakSelf.friendUID];
        [IMSDKManager toolDeleteSessionModelWith:sessionModel andDeleteAllChatModel:YES];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
    }];
    
}

// 移除/加入 黑名单
- (void)requestBlackFriend {
    
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [dict setValue:_friendUID forKey:@"friendUserUid"];
    
    if (self.blackBtn.selected) {
        //移出黑名单
        [dict setValue:@(0) forKey:@"status"];
        [IMSDKManager removeUserFromBlackListWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            BOOL blackAction = [data boolValue];
            weakSelf.blackBtn.selected = !blackAction;
            if (blackAction) {
                [HUD showMessage:MultilingualTranslation(@"解除黑名单成功")];
            }else {
                [HUD showMessage:MultilingualTranslation(@"解除黑名单失败")];
            }
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
        
    }else {
        //加入黑名单
        [dict setValue:@(1) forKey:@"status"];
        [IMSDKManager addUserToBlackListWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            BOOL blackAction = [data boolValue];
            weakSelf.blackBtn.selected = blackAction;
            if (blackAction) {
                [HUD showMessage:MultilingualTranslation(@"拉黑成功")];
            }else {
                [HUD showMessage:MultilingualTranslation(@"拉黑失败")];
            }
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            if(code == LingIMHttpResponseCodeExamineStatus){
                [HUD showMessage:MultilingualTranslation(@"提交成功，系统稍后处理")];
            }else if (code == LingIMHttpResponseCodeNoneExamineStatus){
                [HUD showMessage:MultilingualTranslation(@"您已经提交过申请，请耐心等待审核")];
            }else{
                [HUD showMessageWithCode:code errorMsg:msg];
            }
        }];
    }
}

//返回到指定vc
- (void)navigationBackToVC {
//    NSMutableArray *vcList = [self.navigationController.viewControllers mutableCopy];
//
//    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i++) {
//
//        UIViewController *vc = [self.navigationController.viewControllers objectAtIndexSafe:i];
//
//        if ([NSStringFromClass([vc class]) isEqualToString:@"NFUserHomePageVC"]) {
//            //用户主页
//            [vcList removeObjectAtIndexSafe:i];
//            self.navigationController.viewControllers = vcList;
//            [self.navigationController popViewControllerAnimated:YES];
//            return;
//        }
//
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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
