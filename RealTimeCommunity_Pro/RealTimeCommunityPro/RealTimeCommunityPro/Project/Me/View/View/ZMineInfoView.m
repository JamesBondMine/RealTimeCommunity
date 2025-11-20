//
//  ZMineInfoView.m
//  CIMKit
//
//  Created by cusPro on 2023/6/26.
//

#import "ZMineInfoView.h"

@interface ZMineInfoView ()
@property (nonatomic, strong) UIImageView *ivHeaderBg;//背景图片
@property (nonatomic, strong) UIImageView *ivHeader;//头像
@property (nonatomic, strong) UILabel *ivUserRoleName;//用户角色名称
@property (nonatomic, strong) UILabel *lblNickname;//昵称
@property (nonatomic, strong) UILabel *lblAccount;//账号
@property (nonatomic, strong) UIButton *btnCopy;//复制
@property (nonatomic, strong) UIButton *btnCodeQR;//二维码
@end

@implementation ZMineInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 界面布局
- (void)setupUI {
    _ivHeaderBg = [[UIImageView alloc] initWithImage:ImgNamed(@"remi_mine_header_bg")];
    _ivHeaderBg.userInteractionEnabled = YES;
    [self addSubview:_ivHeaderBg];
    [_ivHeaderBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _ivHeader = [[UIImageView alloc] initWithImage:DefaultAvatar];
    _ivHeader.layer.cornerRadius = DWScale(30);
    _ivHeader.layer.masksToBounds = YES;
    _ivHeader.layer.tkThemeborderColors = @[COLORWHITE, COLORWHITE_DARK];
    _ivHeader.layer.borderWidth = DWScale(1);
    [self addSubview:_ivHeader];
    [_ivHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(DWScale(32));
        make.bottom.equalTo(self).offset(-DWScale(36));
        make.size.mas_equalTo(CGSizeMake(DWScale(60), DWScale(60)));
    }];
    
    _ivUserRoleName = [UILabel new];
    _ivUserRoleName.text = @"";
    _ivUserRoleName.tkThemetextColors = @[COLORWHITE, COLORWHITE];
    _ivUserRoleName.font = FONTN(9);
    _ivUserRoleName.tkThemebackgroundColors = @[COLOR_EAB243, COLOR_EAB243_DARK];
    _ivUserRoleName.textAlignment = NSTextAlignmentCenter;
    [_ivUserRoleName rounded:DWScale(21)/2];
    _ivUserRoleName.hidden = YES;
    [self addSubview:_ivUserRoleName];
    [_ivUserRoleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_ivHeader).offset(-DWScale(1));
        make.trailing.equalTo(_ivHeader).offset(DWScale(1));
        make.bottom.equalTo(_ivHeader);
        make.height.mas_equalTo(DWScale(21));
    }];
    
    UIButton *btnHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHeader addTarget:self action:@selector(btnHeaderClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnHeader];
    [btnHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_ivHeader);
    }];
    
    _lblNickname = [UILabel new];
    _lblNickname.tkThemetextColors = @[COLORWHITE, COLORWHITE];
    _lblNickname.font = FONTR(18);
    [self addSubview:_lblNickname];
   
    
    _lblAccount = [UILabel new];
    _lblAccount.tkThemetextColors = @[HEXACOLOR(@"FFFFFF", 0.5), HEXACOLOR(@"FFFFFF", 0.5)];
    _lblAccount.font = FONTR(14);
    [self addSubview:_lblAccount];
    [_lblAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_ivHeader.mas_trailing).offset(DWScale(12));
        make.top.equalTo(_lblNickname.mas_bottom).offset(DWScale(10));
        make.height.mas_equalTo(DWScale(20));
    }];
    
    _btnCopy = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCopy setImage:ImgNamed(@"remi_mine_btn_copy") forState:UIControlStateNormal];
    [_btnCopy addTarget:self action:@selector(btnCopyClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnCopy];
    [_btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lblAccount);
        make.leading.equalTo(_lblAccount.mas_trailing).offset(DWScale(5));
        make.size.mas_equalTo(CGSizeMake(DWScale(15), DWScale(15)));
    }];
    
    _btnCodeQR = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCodeQR setImage:ImgNamed(@"remi_mine_qr_white") forState:UIControlStateNormal];
    [_btnCodeQR addTarget:self action:@selector(btnCodeQRClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnCodeQR];
    [_btnCodeQR mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ivHeader);
        make.trailing.equalTo(self).offset(-DWScale(32));
        make.size.mas_equalTo(CGSizeMake(DWScale(28), DWScale(28)));
    }];
    
    //1.0.9签到功能
    UIButton * signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInButton setTitle:MultilingualTranslation(@"签到") forState:UIControlStateNormal];
    [signInButton setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
    [signInButton setBackgroundImage:ImgNamed(@"icon_mine_signin_bg") forState:UIControlStateNormal];
    signInButton.titleLabel.font = FONTR(10);
//    signInButton.hidden = YES;
    [signInButton addTarget:self action:@selector(SignInAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:signInButton];
    [signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_ivHeader.mas_top);
        make.trailing.mas_equalTo(self).offset(DWScale(-19));
        make.size.mas_equalTo(CGSizeMake(DWScale(64), DWScale(24)));
    }];
    
    [_lblNickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_ivHeader.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(_btnCodeQR.mas_leading).offset(DWScale(-12));
        make.top.equalTo(_ivHeader.mas_top);
        make.height.mas_equalTo(DWScale(25));
    }];
}
//跳转签到页面
-(void)SignInAction{
    if (_delegate && [_delegate respondsToSelector:@selector(mineInfoAction:)]) {
        [_delegate mineInfoAction:202];
    }
}
#pragma mark - 界面赋值
- (void)setMineModel:(ZUserModel *)mineModel {
    _mineModel = mineModel;
    [_ivHeader sd_setImageWithURL:[mineModel.avatar getImageFullUrl] placeholderImage:DefaultAvatar options:SDWebImageAllowInvalidSSLCertificates];
    _lblNickname.text = mineModel.nickname;
    _lblAccount.text = mineModel.userName;
    //角色名称
    NSString *roleName = [UserManager matchUserRoleConfigInfo:mineModel.roleId disableStatus:mineModel.disableStatus];
    if ([NSString isNil:roleName]) {
        _ivUserRoleName.hidden = YES;
    } else {
        _ivUserRoleName.hidden = NO;
        _ivUserRoleName.text = roleName;
    }
}
#pragma mark - 交互事件
- (void)btnHeaderClick {
    if (_delegate && [_delegate respondsToSelector:@selector(mineInfoAction:)]) {
        [_delegate mineInfoAction:200];
    }
}

- (void)btnCopyClick {
    if (![NSString isNil:_lblAccount.text]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _lblAccount.text;
        [HUD showMessage:MultilingualTranslation(@"复制成功")];
    }
}

- (void)btnCodeQRClick {
    if (_delegate && [_delegate respondsToSelector:@selector(mineInfoAction:)]) {
        [_delegate mineInfoAction:201];
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
