//
//  NVSampleUserInfoView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/13.
//

#import "NVSampleUserInfoView.h"
#import "ZToolManager.h"
#import "NHChatViewController.h"
#import "ZToolManager.h"
@interface NVSampleUserInfoView ()
@property (nonatomic, strong) UIScrollView *bgScrollView;//背景滑动视图

@property (nonatomic, strong) BBBaseImageView *ivHeader;//头像
@property (nonatomic, strong) UILabel *lblUserRoleName;//用户角色名称
@property (nonatomic, strong) UILabel *lblNote;//备注
@property (nonatomic, strong) UILabel *lblNickname;//昵称
@property (nonatomic, strong) UILabel *lblAccount;//账号

@property (nonatomic, strong) UIView * remarkBgView;//备注背景视图
@property (nonatomic, strong) UILabel * remarkLabel;//底部显示备注label

@property (nonatomic, strong) UIView * desBgView;//描述背景视图
@property (nonatomic, strong) UILabel * desLabel;//底部显示描述

@property (nonatomic, strong) UIView * inGroupNickBgView;//在本群昵称视图
@property (nonatomic, strong) UILabel * groupNickLabel;//底部显示在本群昵称

@end

@implementation NVSampleUserInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
//    self = [[UIScrollView alloc] init];
//    [self addSubview:self];
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    
    _ivHeader = [[BBBaseImageView alloc] init];
    // 商务风格：更小的圆角，显得更专业
    _ivHeader.layer.cornerRadius = DWScale(8);
    _ivHeader.layer.masksToBounds = YES;
    // 添加边框，增加层次感
    _ivHeader.layer.borderWidth = 0.5;
    _ivHeader.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.08].CGColor;
    // 添加轻微阴影
    _ivHeader.layer.shadowColor = [UIColor blackColor].CGColor;
    _ivHeader.layer.shadowOffset = CGSizeMake(0, 2);
    _ivHeader.layer.shadowOpacity = 0.06;
    _ivHeader.layer.shadowRadius = 4;
    [self addSubview:_ivHeader];
    [_ivHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(DWScale(16));
        make.top.equalTo(self).offset(DWScale(10));
        make.height.width.mas_equalTo(DWScale(60));
//        make.bottom.mas_equalTo(self);
    }];
    
    _lblUserRoleName = [UILabel new];
   _lblUserRoleName.text = @"";
   _lblUserRoleName.tkThemetextColors = @[COLORWHITE, COLORWHITE];
   _lblUserRoleName.font = FONTB(9); // 商务风格：字体稍大一点，加粗更专业
   _lblUserRoleName.tkThemebackgroundColors = @[COLOR_EAB243, COLOR_EAB243_DARK];
   _lblUserRoleName.textAlignment = NSTextAlignmentCenter;
   [_lblUserRoleName rounded:DWScale(4)]; // 商务风格：更小的圆角
   _lblUserRoleName.hidden = YES;
   // 添加边框和阴影
   _lblUserRoleName.layer.borderWidth = 0.5;
   _lblUserRoleName.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
   [self addSubview:_lblUserRoleName];
   [_lblUserRoleName mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.equalTo(_ivHeader).offset(-DWScale(1));
       make.trailing.equalTo(_ivHeader).offset(DWScale(1));
       make.bottom.equalTo(_ivHeader);
       make.height.mas_equalTo(DWScale(22));
   }];

    
    _lblNote = [UILabel new];
//    _lblNote.text = MultilingualTranslation(@"备注");
    _lblNote.tkThemetextColors = @[COLOR_33, COLORWHITE];
    _lblNote.font = FONTB(DWScale(18)); // 商务风格：主标题更大更突出
    [self addSubview:_lblNote];
    [_lblNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_ivHeader.mas_trailing).offset(DWScale(12)); // 增加间距
        make.trailing.equalTo(self.mas_trailing).offset(DWScale(-16));
        make.top.equalTo(_ivHeader).offset(DWScale(2));
        make.height.mas_equalTo(DWScale(20));
    }];
    
    _lblNickname = [UILabel new];
//    _lblNickname.text = MultilingualTranslation(@"用户昵称");
    _lblNickname.tkThemetextColors = @[COLOR_66, COLOR_CCCCCC];
    _lblNickname.font = FONTR(DWScale(14));
    _lblNickname.numberOfLines = 2;
    _lblNickname.preferredMaxLayoutWidth = DScreenWidth - DWScale(96);
    [self addSubview:_lblNickname];
    [_lblNickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
        make.top.mas_equalTo(_lblNote.mas_bottom).offset(DWScale(8));
        make.height.mas_equalTo(DWScale(15));
    }];
    
    _lblAccount = [UILabel new];
//    _lblAccount.text = MultilingualTranslation(@"账号");
    _lblAccount.tkThemetextColors = @[COLOR_99, COLOR_99];
    _lblAccount.font = FONTR(12);
    [self addSubview:_lblAccount];
    [_lblAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
        make.top.mas_equalTo(_lblNickname.mas_bottom).offset(DWScale(8));
        make.height.mas_equalTo(DWScale(13));
    }];

    [self addSubview:self.remarkBgView];
    [self.remarkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(_ivHeader.mas_bottom).offset(DWScale(10));
        make.height.mas_equalTo(DWScale(0));
        make.width.mas_equalTo(DScreenWidth);
    }];
    
    [self addSubview:self.desBgView];
    [self.desBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(_remarkBgView.mas_bottom).offset(0);
        make.height.mas_equalTo(DWScale(0));
        make.width.mas_equalTo(DScreenWidth);
    }];
    
    [self addSubview:self.inGroupNickBgView];
    [self.inGroupNickBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.top.equalTo(_desBgView.mas_bottom).offset(0);
        make.height.mas_equalTo(DWScale(0));
        make.width.mas_equalTo(DScreenWidth);
    }];
    self.remarkBgView.hidden = YES;
    self.desBgView.hidden = YES;
    self.inGroupNickBgView.hidden = YES;
    
    _viewOnline = [UIView new];
    _viewOnline.tkThemebackgroundColors = @[HEXCOLOR(@"01BC46"), HEXCOLOR(@"01BC46")];
    _viewOnline.layer.cornerRadius = DWScale(5); // 商务风格：更小更精致
    _viewOnline.layer.masksToBounds = NO; // 允许显示阴影
    _viewOnline.layer.tkThemeborderColors = @[COLORWHITE, COLORWHITE_DARK];
    _viewOnline.layer.borderWidth = DWScale(2); // 边框加粗更明显
    // 添加发光效果
    _viewOnline.layer.shadowColor = [HEXCOLOR(@"01BC46") CGColor];
    _viewOnline.layer.shadowOffset = CGSizeMake(0, 0);
    _viewOnline.layer.shadowOpacity = 0.5;
    _viewOnline.layer.shadowRadius = 3;
    _viewOnline.hidden = YES;
    [self addSubview:_viewOnline];
    [_viewOnline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ivHeader).offset(DWScale(2));
        make.trailing.equalTo(_ivHeader).offset(-DWScale(2));
        make.size.mas_equalTo(CGSizeMake(DWScale(10), DWScale(10)));
    }];
}

#pragma mark - 界面赋值
- (void)configUserInfoWith:(NSString *)userUid groupId:(NSString *)groupId {

    //先获取是否是好友
    LingIMFriendModel *friendModel = [IMSDKManager toolCheckMyFriendWith:userUid];
    if (friendModel) {
        if (friendModel.disableStatus == 4) {
            //账号已注销
            _lblUserRoleName.hidden = YES;
            [_ivHeader setImage:DefaultAccountDelete];
            _lblNickname.text = MultilingualTranslation(@"已注销");
            _lblAccount.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"账号："), @"-"];
        }else {
            [_ivHeader sd_setImageWithURL:[friendModel.avatar getImageFullUrl] placeholderImage:DefaultAvatar options:SDWebImageAllowInvalidSSLCertificates];
            _lblAccount.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"账号："),friendModel.userName];
            //角色名称
            NSString *roleName = [UserManager matchUserRoleConfigInfo:friendModel.roleId disableStatus:friendModel.disableStatus];
            if ([NSString isNil:roleName]) {
                _lblUserRoleName.hidden = YES;
            } else {
                _lblUserRoleName.hidden = NO;
                _lblUserRoleName.text = roleName;
            }

            if (![NSString isNil:friendModel.remarks]) {
                _lblNote.hidden = NO;
                _lblNote.text = friendModel.remarks;
                
                _lblNickname.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"昵称："),friendModel.nickname];
                [_lblNickname mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                    make.top.mas_equalTo(_lblNote.mas_bottom).offset(DWScale(8));
                    make.height.mas_equalTo(DWScale(15));
                }];
                
                [_lblAccount mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                    make.top.mas_equalTo(_lblNickname.mas_bottom).offset(DWScale(8));
                    make.height.mas_equalTo(DWScale(13));
                }];
            }else {
                _lblNote.hidden = YES;
                
                _lblNickname.text = friendModel.nickname;
                [_lblNickname mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                    make.top.mas_equalTo(self).offset(DWScale(19));
                    make.height.mas_equalTo(DWScale(17));
                }];

                [_lblAccount mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                    make.top.mas_equalTo(_lblNickname.mas_bottom).offset(DWScale(11));
                    make.height.mas_equalTo(DWScale(13));
                }];
            }
        }
        
    }else {
        if (![NSString isNil:groupId]) {
            //获取群成员信息
            LingIMGroupMemberModel *groupMemberModel = [IMSDKManager imSdkCheckGroupMemberWith:userUid groupID:groupId];
            if (groupMemberModel) {
                if (groupMemberModel.disableStatus == 4) {
                    
                    //账号已注销
                    _lblUserRoleName.hidden = YES;
                    [_ivHeader setImage:DefaultAccountDelete];
                    _lblNickname.text = MultilingualTranslation(@"已注销");
                    _lblAccount.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"账号："), @"-"];
                    
                }else {
                    [_ivHeader sd_setImageWithURL:[groupMemberModel.userAvatar getImageFullUrl] placeholderImage:DefaultAvatar options:SDWebImageAllowInvalidSSLCertificates];
                    _lblAccount.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"账号："),groupMemberModel.userName];
                    //角色名称
                    NSString *roleName = [UserManager matchUserRoleConfigInfo:groupMemberModel.roleId disableStatus:groupMemberModel.disableStatus];
                    if ([NSString isNil:roleName]) {
                        _lblUserRoleName.hidden = YES;
                    } else {
                        _lblUserRoleName.hidden = NO;
                        _lblUserRoleName.text = roleName;
                    }
                    if (![NSString isNil:groupMemberModel.nicknameInGroup] && ![groupMemberModel.nicknameInGroup isEqualToString:groupMemberModel.userNickname]) {
                        _lblNote.hidden = NO;
                        _lblNote.text = groupMemberModel.nicknameInGroup;
                        
                        _lblNickname.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"昵称："),groupMemberModel.userNickname];
                        [_lblNickname mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                            make.top.mas_equalTo(_lblNote.mas_bottom).offset(DWScale(8));
                            make.height.mas_equalTo(DWScale(15));
                        }];
                        
                        [_lblAccount mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                            make.top.mas_equalTo(_lblNickname.mas_bottom).offset(DWScale(8));
                            make.height.mas_equalTo(DWScale(13));
                        }];
                        
                    }else {
                        _lblNote.hidden = YES;
                        
                        _lblNickname.text = groupMemberModel.userNickname;
                        [_lblNickname mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                            make.top.mas_equalTo(self).offset(DWScale(19));
                            make.height.mas_equalTo(DWScale(17));
                        }];
                        
                        [_lblAccount mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                            make.top.mas_equalTo(_lblNickname.mas_bottom).offset(DWScale(11));
                            make.height.mas_equalTo(DWScale(13));
                        }];
                    }
                    
                }
            }
            
        }
        
    }
    
}
//备注背景视图
- (UIView *)remarkBgView {
    if (!_remarkBgView) {
        _remarkBgView = [[UIView alloc] init];
        _remarkBgView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        // 商务风格：添加卡片式阴影效果
        _remarkBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        _remarkBgView.layer.shadowOffset = CGSizeMake(0, 1);
        _remarkBgView.layer.shadowOpacity = 0.04;
        _remarkBgView.layer.shadowRadius = 2;
        
        UIButton *setRemarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setRemarkBtn.tkThemebackgroundColors =  @[COLORWHITE, COLOR_33];
        [setRemarkBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateSelected];
        [setRemarkBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateHighlighted];
        
        [setRemarkBtn addTarget:self action:@selector(setRemarkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_remarkBgView addSubview:setRemarkBtn];
        [setRemarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(_remarkBgView);
        }];

        UIView * lineView = [UIView new];
        lineView.tkThemebackgroundColors = @[[UIColor colorWithWhite:0 alpha:0.06] ,[UIColor colorWithWhite:1 alpha:0.5]]; // 商务风格：更淡的分割线
        [_remarkBgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(DWScale(16));
            make.trailing.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel * remarkTipLabel = [UILabel new];
        remarkTipLabel.text = MultilingualTranslation(@"备注：");
        remarkTipLabel.tkThemetextColors = @[COLOR_33, COLORWHITE];
        remarkTipLabel.font = FONTR(16);
        [_remarkBgView addSubview:remarkTipLabel];
        CGFloat remarkTipLabelWidth = [remarkTipLabel.text widthForFont:remarkTipLabel.font];
        [remarkTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(DWScale(16));
            make.centerY.mas_equalTo(_remarkBgView);
            make.height.mas_equalTo(DWScale(22));
            make.width.mas_equalTo(remarkTipLabelWidth);
        }];

        UIImageView * ivArrow = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_arrow_right_gray")];
        [_remarkBgView addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_remarkBgView);
            make.trailing.equalTo(_remarkBgView).offset(-DWScale(16));
            make.size.mas_equalTo(CGSizeMake(DWScale(8), DWScale(16)));
        }];
        
        _remarkLabel = [UILabel new];
        _remarkLabel.text = MultilingualTranslation(@"未设置备注");
        _remarkLabel.tkThemetextColors = @[COLOR_99, COLOR_99];
        _remarkLabel.font = FONTR(14);
        _remarkLabel.textAlignment = NSTextAlignmentRight;
        [_remarkBgView addSubview:_remarkLabel];
        [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(remarkTipLabel.mas_trailing).offset(DWScale(10));
            make.trailing.mas_equalTo(ivArrow.mas_leading).offset(-DWScale(10));
            make.centerY.equalTo(_remarkBgView);
            make.height.mas_equalTo(DWScale(20));
        }];
    }
    return _remarkBgView;
}

//描述背景视图
- (UIView *)desBgView {
    if (!_desBgView) {
        _desBgView = [[UIView alloc] init];
        _desBgView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        // 商务风格：添加卡片式阴影效果
        _desBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        _desBgView.layer.shadowOffset = CGSizeMake(0, 1);
        _desBgView.layer.shadowOpacity = 0.04;
        _desBgView.layer.shadowRadius = 2;
        
        UIButton *setDesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setDesBtn.tkThemebackgroundColors =  @[COLORWHITE, COLOR_33];
        [setDesBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateSelected];
        [setDesBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_CCCCCC_DARK]] forState:UIControlStateHighlighted];
        [setDesBtn addTarget:self action:@selector(setDesBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_desBgView addSubview:setDesBtn];
        [setDesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(_desBgView);
        }];
        
        UIView * lineView = [UIView new];
        lineView.tkThemebackgroundColors = @[[UIColor colorWithWhite:0 alpha:0.06] ,[UIColor colorWithWhite:1 alpha:0.5]]; // 商务风格：更淡的分割线
        [_desBgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(DWScale(16));
            make.trailing.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel * remarkTipLabel = [UILabel new];
        remarkTipLabel.text = MultilingualTranslation(@"描述：");
        remarkTipLabel.tkThemetextColors = @[COLOR_33, COLORWHITE];
        remarkTipLabel.font = FONTR(16);
        [_desBgView addSubview:remarkTipLabel];
        [remarkTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(DWScale(16));
            make.top.mas_equalTo(DWScale(16));
            make.width.mas_equalTo(DWScale(50));
            make.height.mas_equalTo(DWScale(22));
        }];
        
        _desLabel = [UILabel new];
//        _desLabel.text = MultilingualTranslation(@"未设置备注");
        _desLabel.tkThemetextColors = @[COLOR_66, COLOR_66];
        _desLabel.font = FONTR(14);
        _desLabel.numberOfLines = 0;
        [_desBgView addSubview:_desLabel];
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(remarkTipLabel.mas_trailing);
            make.trailing.mas_equalTo(_desBgView).offset(-DWScale(16));
            make.centerY.equalTo(_desBgView);
            make.bottom.mas_equalTo(_desBgView.mas_bottom).offset(-DWScale(17));
        }];
    }
    return _desBgView;
}

//在本群昵称背景视图
- (UIView *)inGroupNickBgView {
    if (!_inGroupNickBgView) {
        _inGroupNickBgView = [[UIView alloc] init];
        _inGroupNickBgView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
        // 商务风格：添加卡片式阴影效果
        _inGroupNickBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        _inGroupNickBgView.layer.shadowOffset = CGSizeMake(0, 1);
        _inGroupNickBgView.layer.shadowOpacity = 0.04;
        _inGroupNickBgView.layer.shadowRadius = 2;
        
        UIView * lineView = [UIView new];
        lineView.tkThemebackgroundColors = @[[UIColor colorWithWhite:0 alpha:0.06] ,[UIColor colorWithWhite:1 alpha:0.5]]; // 商务风格：更淡的分割线
        [_inGroupNickBgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(DWScale(16));
            make.trailing.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel * remarkTipLabel = [UILabel new];
        remarkTipLabel.text = MultilingualTranslation(@"在本群的昵称：");
        remarkTipLabel.tkThemetextColors = @[COLOR_33, COLORWHITE];
        remarkTipLabel.font = FONTR(16);
        [_inGroupNickBgView addSubview:remarkTipLabel];
        CGFloat remarkTipLabelWidth = [remarkTipLabel.text widthForFont:remarkTipLabel.font];
        [remarkTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(DWScale(16));
            make.centerY.mas_equalTo(_inGroupNickBgView);
            make.height.mas_equalTo(DWScale(22));
            make.width.mas_equalTo(remarkTipLabelWidth);
        }];
        
        _groupNickLabel = [UILabel new];
        _groupNickLabel.text = MultilingualTranslation(@"未设置备注");
        _groupNickLabel.tkThemetextColors = @[COLOR_66, COLOR_66];
        _groupNickLabel.font = FONTR(14);
        _groupNickLabel.textAlignment = NSTextAlignmentRight;
        _groupNickLabel.numberOfLines = 0;
        [_inGroupNickBgView addSubview:_groupNickLabel];
        [_groupNickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(remarkTipLabel.mas_trailing);
            make.trailing.mas_equalTo(_inGroupNickBgView).offset(-DWScale(16));
            make.centerY.equalTo(_inGroupNickBgView);
            make.bottom.mas_equalTo(_inGroupNickBgView.mas_bottom).offset(-DWScale(17));
        }];
    }
    return _inGroupNickBgView;
}

- (void)setDesBtnClick{
    if(self.setDesBtnBlock){
        self.setDesBtnBlock();
    }
}

- (void)setRemarkBtnClick{
    if(self.setRemarkBtnBlock){
        self.setRemarkBtnBlock();
    }
}

- (void)updateUIWithUserModel:(ZUserModel *)userModel isMyFriend:(BOOL)isMyFriend inGroupUserName:(NSString *)inGroupUserName {
    if (userModel.disableStatus == 4) {
        //已注销
        _remarkBgView.hidden = YES;
        _desBgView.hidden = YES;
        _inGroupNickBgView.hidden = YES;
        
        [_ivHeader setImage:DefaultAccountDelete];
        _lblNickname.text = MultilingualTranslation(@"已注销");
        _lblAccount.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"账号："), @"-"];
    } else {
        _remarkBgView.hidden = NO;
        _desBgView.hidden = NO;
        _inGroupNickBgView.hidden = NO;
        
        
        //如果不是好友，备注、描述、在本群昵称都不显示
        if(!isMyFriend){
            [_remarkBgView removeFromSuperview];
            _remarkBgView = nil;
            [_desBgView removeFromSuperview];
            _desBgView = nil;
            [_inGroupNickBgView removeFromSuperview];
            _inGroupNickBgView = nil;
        }
        
        //inGroupUserName如果为空，则不是从群组查看好友信息
        if (![NSString isNil:inGroupUserName]) {
            if(!_inGroupNickBgView){
                [self addSubview:self.inGroupNickBgView];
            }
            _groupNickLabel.text = inGroupUserName;
        }else{
            [_inGroupNickBgView removeFromSuperview];
            _inGroupNickBgView = nil;
        }

        //根据结果判断是否显示描述
        if (![NSString isNil:userModel.descRemark]) {
            if(!_desBgView){
                [self addSubview:self.desBgView];
            }
            _desLabel.text = userModel.descRemark;
        }else{
            [_desBgView removeFromSuperview];
            _desBgView = nil;
        }
        
        //根据是否显示重新布局视图
        if(_remarkBgView){
            [self.remarkBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self);
                make.top.equalTo(_ivHeader.mas_bottom).offset(DWScale(10));
                make.height.mas_equalTo(DWScale(54));
                make.width.mas_equalTo(DScreenWidth);
            }];
        }
        
        if(_desBgView){
            [self.desBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self);
                make.top.equalTo(_remarkBgView.mas_bottom).offset(0);
                make.width.mas_equalTo(DScreenWidth);
                make.height.mas_greaterThanOrEqualTo(DWScale(54));
            }];
            if(_inGroupNickBgView){
                [self.inGroupNickBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self);
                    make.top.equalTo(_desBgView.mas_bottom).offset(0);
                    make.height.mas_equalTo(DWScale(54));
                    make.width.mas_equalTo(DScreenWidth);
                }];
            }
        }else{
            if(_inGroupNickBgView){
                [self.inGroupNickBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self);
                    if(_remarkBgView){
                        make.top.equalTo(_remarkBgView.mas_bottom).offset(0);
                    }else{
                        make.top.equalTo(_ivHeader.mas_bottom).offset(DWScale(10));
                    }
                    make.height.mas_equalTo(DWScale(54));
                    make.width.mas_equalTo(DScreenWidth);
                }];
            }
        }
        
        //头像赋值
        [_ivHeader sd_setImageWithURL:[userModel.avatar getImageFullUrl] placeholderImage:DefaultAvatar options:SDWebImageAllowInvalidSSLCertificates];
        
        if(![NSString isNil:userModel.remarks] || (![NSString isNil:inGroupUserName] && ![userModel.nickname isEqualToString:inGroupUserName])){
            _remarkLabel.tkThemetextColors = @[COLOR_66,COLOR_CCCCCC];
            _remarkLabel.text = [NSString stringWithFormat:@"%@",![NSString isNil:userModel.remarks] ? userModel.remarks : MultilingualTranslation(@"未设置备注")];
            _lblNote.hidden = NO;
            if (![NSString isNil:userModel.remarks]) {
                _lblNote.text = [NSString stringWithFormat:@"%@",userModel.remarks];
            } else if (![NSString isNil:inGroupUserName]) {
                _lblNote.text = [NSString stringWithFormat:@"%@",inGroupUserName];
            } else {
                _lblNote.text = [NSString stringWithFormat:@"%@",userModel.nickname];
            }
            
            [_lblNote mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                make.trailing.equalTo(self.mas_trailing).offset(DWScale(-10));
                make.top.equalTo(_ivHeader);
                make.height.mas_equalTo(DWScale(17));
            }];

            _lblNickname.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"昵称："),userModel.nickname];
            _lblNickname.tkThemetextColors = @[COLOR_66, COLOR_CCCCCC];
            _lblNickname.font = FONTR(DWScale(14));
            [_lblNickname mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                make.top.mas_equalTo(_lblNote.mas_bottom).offset(DWScale(8));
                make.height.mas_equalTo(DWScale(15));
            }];

            _lblAccount.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"账号："),userModel.userName];
            [_lblAccount mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                make.top.mas_equalTo(_lblNickname.mas_bottom).offset(DWScale(8));
                make.height.mas_equalTo(DWScale(13));
            }];
        }else{
            _remarkLabel.tkThemetextColors = @[COLOR_99, COLOR_99];
            _remarkLabel.text = MultilingualTranslation(@"未设置备注");
            _lblNote.hidden = YES;
            _lblNickname.text = [NSString stringWithFormat:@"%@",userModel.nickname];
            _lblNickname.tkThemetextColors = @[COLOR_33, COLORWHITE];
            _lblNickname.font = FONTR(DWScale(16));
            [_lblNickname mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                make.top.mas_equalTo(self).offset(DWScale(19));
                make.height.mas_equalTo(DWScale(17));
            }];

            _lblAccount.text = [NSString stringWithFormat:@"%@%@",MultilingualTranslation(@"账号："),userModel.userName];
            [_lblAccount mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(_ivHeader.mas_trailing).offset(DWScale(10));
                make.top.mas_equalTo(_lblNickname.mas_bottom).offset(DWScale(11));
                make.height.mas_equalTo(DWScale(13));
            }];
        }
        
        //更新数据库
        LingIMFriendModel *myFriend = [IMSDKManager toolCheckMyFriendWith:userModel.userUID];
        if (myFriend) {
            NSString *myFriendStr = [NSString stringWithFormat:@"%@-%@-%@-%@-%@", myFriend.avatar, myFriend.nickname, myFriend.userName, myFriend.remarks, myFriend.descRemark];
            NSString *userModelStr = [NSString stringWithFormat:@"%@-%@-%@-%@-%@", userModel.avatar, userModel.nickname, userModel.userName, userModel.remarks, userModel.descRemark];
            if (![myFriendStr isEqualToString:userModelStr]) {
                //需要更新好友信息，进行一次数据库的更新
                myFriend.avatar = userModel.avatar;//头像
                myFriend.nickname = userModel.nickname;//昵称
                myFriend.userName = userModel.userName;//账号
                myFriend.remarks = userModel.remarks;//备注
                myFriend.descRemark = userModel.descRemark;//描述
                if([userModel.remarks isEqualToString:@""] || !userModel.remarks){
                    myFriend.showName = userModel.nickname;
                }else{
                    myFriend.showName = userModel.remarks;
                }
                [IMSDKManager toolUpdateMyFriendWith:myFriend];
                
                //修改 会话 相关信息
                LingIMSessionModel *sessionModel = [IMSDKManager toolCheckMySessionWith:userModel.userUID];
                sessionModel.sessionName = myFriend.showName;
                sessionModel.sessionAvatar = myFriend.avatar;
                [IMSDKManager toolUpdateSessionWith:sessionModel];
            }
        }
        
        
        //更新名称显示
        //[ZTOOL reloadChatAndSessionVC];
        //刷新聊天和会话列表
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadChatAndSessionVC" object:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
