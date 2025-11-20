//
//  RegisterCusViewController.m
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/10/29.
//

#import "RegisterCusViewController.h"
#import "JXCategoryView.h"

#import "NJSelectCategoryIndicatorBackgroundView.h"

#import "LoginServerConfigView.h"
#import "ZCountryCodeViewController.h"
#import "FMDB.h"
#import "ProtocolPolicyView.h"
#import "ZToolManager.h"
#import "LXChatEncrypt.h"
#import "ZEncryptKeyGuard.h"
#import "ZWeakPwdCheckTool.h"
#import "AppDelegate.h"
#import "AppDelegate+DB.h"
#import "AppDelegate+MediaCall.h"
#import "AppDelegate+MiniApp.h"
#import "AppDelegate+ThirdSDK.h"
#import "ZAuthInputTools.h"
#import "ZImgVerCodeView.h"
#import "ZCaptchaCodeTools.h"
#import "ZAlertTipView.h"

@interface RegisterCusViewController () <NJSelectCategoryViewDelegate>

// UI组件
@property (nonatomic, strong) CAGradientLayer *gradientLayer; // 渐变背景
@property (nonatomic, strong) LJCategoryTitleView *categoryView; // 切换视图
@property (nonatomic, strong) UIScrollView *contentScrollView; // 内容滚动视图
@property (nonatomic, assign) NSInteger currentSelectedIndex; // 当前选中的索引

// 顶部按钮
@property (nonatomic, strong) UIButton *backBtn; // 返回按钮
@property (nonatomic, strong) UIButton *companyIdBtn; // 企业号设置

// 手机号注册
@property (nonatomic, strong) UIView *phoneContainerView;
@property (nonatomic, strong) UIButton *phoneAreaCodeBtn;
@property (nonatomic, strong) UIView *phoneLineView;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *phonePasswordField;
@property (nonatomic, strong) UITextField *phoneConfirmPasswordField;
@property (nonatomic, strong) UITextField *phoneInviteCodeField;
@property (nonatomic, strong) NSString *phoneCountryCode; // 手机号区号
@property (nonatomic, assign) BOOL phonePasswordShown;
@property (nonatomic, assign) BOOL phoneConfirmPasswordShown;

// 邮箱注册
@property (nonatomic, strong) UIView *emailContainerView;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *emailPasswordField;
@property (nonatomic, strong) UITextField *emailConfirmPasswordField;
@property (nonatomic, strong) UITextField *emailInviteCodeField;
@property (nonatomic, assign) BOOL emailPasswordShown;
@property (nonatomic, assign) BOOL emailConfirmPasswordShown;

// 账号注册
@property (nonatomic, strong) UIView *accountContainerView;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *accountPasswordField;
@property (nonatomic, strong) UITextField *accountConfirmPasswordField;
@property (nonatomic, strong) UITextField *accountInviteCodeField;
@property (nonatomic, assign) BOOL accountPasswordShown;
@property (nonatomic, assign) BOOL accountConfirmPasswordShown;

// 动态提示标签
@property (nonatomic, strong) UILabel *accountDynamicTipLbl;  // 账号提示
@property (nonatomic, strong) UILabel *pwdDynamicTipLbl;      // 密码提示

// 注册按钮
@property (nonatomic, strong) UIButton *registerBtn;

// 已有账号登录
@property (nonatomic, strong) UIButton *toLoginBtn;

// 服务协议
@property (nonatomic, strong) ProtocolPolicyView *policyView;

// 企业号配置
@property (nonatomic, strong) NSString *presetCompanyId;
@property (nonatomic, strong) NSString *presetIpDomain;

// 验证码工具
@property (nonatomic, strong) ZCaptchaCodeTools *captchaTools;

// 验证码输入框
@property (nonatomic, strong) UIView *phoneVercodeContainer;
@property (nonatomic, strong) UITextField *phoneVercodeField;
@property (nonatomic, strong) UIButton *phoneGetVercodeBtn;
@property (nonatomic, strong) NSTimer *phoneVercodeTimer;
@property (nonatomic, assign) NSInteger phoneVercodeCountdown;

@property (nonatomic, strong) UIView *emailVercodeContainer;
@property (nonatomic, strong) UITextField *emailVercodeField;
@property (nonatomic, strong) UIButton *emailGetVercodeBtn;
@property (nonatomic, strong) NSTimer *emailVercodeTimer;
@property (nonatomic, assign) NSInteger emailVercodeCountdown;

@end

@implementation RegisterCusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_FAFAFA;
    
    // 隐藏导航栏
    self.navView.hidden = YES;
    
    // 加载保存的企业号配置
    [self loadSavedCompanyIdConfig];
    
    // 设置默认国家区号
    [self setupDefaultCountryCode];
    
    // 设置渐变背景
    [self setupGradientBackground];
    
    // 设置顶部按钮
    [self setupTopButtons];
    
    // 设置切换视图
    [self setupCategoryView];
    
    // 设置内容视图
    [self setupContentViews];
    
    // 设置服务协议
    [self setupPolicyView];
    
    // 设置输入框监听
    [self setupTextFieldListeners];
    
    // 默认选中第一个（手机号）
    self.currentSelectedIndex = 0;
    [self.categoryView selectItemAtIndex:0];
}

#pragma mark - Setup Methods

// 设置渐变背景
- (void)setupGradientBackground {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , DWScale(200));
    
    // 三个渐变色
    self.gradientLayer.colors = @[
        (id)[UIColor colorWithRed:0.51 green:0.85 blue:0.81 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.45 green:0.78 blue:0.88 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.40 green:0.71 blue:0.95 alpha:1.0].CGColor
    ];
    
    // 对角线渐变
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
}

// 设置顶部按钮
- (void)setupTopButtons {
    // 返回按钮（左上角）
    [self setupBackButton];
    
    // 企业号设置按钮（返回按钮右侧）
    [self setupCompanyIdButton];
    
    // 更新企业号按钮显示
    [self updateCompanyIdButtonDisplay];
}

// 设置返回按钮
- (void)setupBackButton {
    _backBtn = [[UIButton alloc] init];
    [_backBtn setImage:ImgNamed(@"registerfanhui") forState:UIControlStateNormal];
    _backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _backBtn.imageView.frame = CGRectMake(_backBtn.imageView.frame.origin.x, _backBtn.imageView.frame.origin.y, _backBtn.imageView.frame.size.width, _backBtn.imageView.frame.size.height*2/3);
    [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DStatusBarH + DWScale(16));
        make.leading.equalTo(self.view).offset(DWScale(20));
        make.width.mas_equalTo(DWScale(32));
        make.height.mas_equalTo(28);
    }];
}

// 设置企业号按钮
- (void)setupCompanyIdButton {
    _companyIdBtn = [[UIButton alloc] init];
    _companyIdBtn.titleLabel.font = FONTN(13);
    [_companyIdBtn setTitleColor:COLOR_FAFAFA forState:UIControlStateNormal];
    [_companyIdBtn addTarget:self action:@selector(companyIdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加图标
    UIImage *icon = [self resizeImage:ImgNamed(@"gl_qiye") toSize:CGSizeMake(DWScale(20), DWScale(20))];
    [_companyIdBtn setImage:icon forState:UIControlStateNormal];
    
    // 设置图标在左，文字在右
    _companyIdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _companyIdBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _companyIdBtn.titleEdgeInsets = UIEdgeInsetsMake(0, DWScale(8), 0, 0);
    _companyIdBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    _companyIdBtn.layer.cornerRadius = DWScale(14);
    _companyIdBtn.layer.borderWidth = 0.5;
    _companyIdBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    [_companyIdBtn setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:4];
    _companyIdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, DWScale(12), 0, DWScale(12));
    [self.view addSubview:_companyIdBtn];
    [_companyIdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DStatusBarH + DWScale(16));
        make.leading.equalTo(_backBtn.mas_trailing).offset(DWScale(8));
        make.height.mas_equalTo(DWScale(28));
        make.width.mas_equalTo(DWScale(124));
    }];
}

// 设置切换视图
- (void)setupCategoryView {
    NSArray *titles = @[MultilingualTranslation(@"手机号"), MultilingualTranslation(@"邮箱"), MultilingualTranslation(@"账号")];
    
    _categoryView = [[LJCategoryTitleView alloc] init];
    _categoryView.backgroundColor = [UIColor clearColor];
    _categoryView.delegate = self;
    _categoryView.titles = titles;
    _categoryView.titleFont = FONTN(15);
    _categoryView.titleSelectedFont = FONTN(15);
    _categoryView.titleColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    _categoryView.titleSelectedColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    
    // 使用平均分布，确保每个选项都居中显示
    _categoryView.averageCellSpacingEnabled = YES;
    _categoryView.cellSpacing = DWScale(8);
    _categoryView.cellWidth = DWScale(92);
    _categoryView.cellWidthIncrement = 0;
    
    // 背景指示器
    NJSelectCategoryIndicatorBackgroundView *backgroundView = [[NJSelectCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = DWScale(36);
    backgroundView.indicatorWidth = DWScale(92);
    backgroundView.indicatorCornerRadius = DWScale(18);
    backgroundView.indicatorColor = COLORWHITE;
    _categoryView.indicators = @[backgroundView];
    
    // 容器背景
    UIView *categoryContainerView = [[UIView alloc] init];
    categoryContainerView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.15];
    categoryContainerView.layer.cornerRadius = DWScale(20);
    
    [self.view addSubview:categoryContainerView];
    [categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_companyIdBtn.mas_bottom).offset(DWScale(52));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(DWScale(300));
        make.height.mas_equalTo(DWScale(40));
    }];
    
    [categoryContainerView addSubview:_categoryView];
    [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(categoryContainerView).insets(UIEdgeInsetsMake(DWScale(2), DWScale(2), DWScale(2), DWScale(2)));
    }];
}

// 设置内容视图
- (void)setupContentViews {
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_categoryView.superview.mas_bottom).offset(DWScale(40));
        make.leading.trailing.bottom.equalTo(self.view);
    }];
    
    // 设置手机号注册
    [self setupPhoneRegisterUI];
    
    // 设置邮箱注册
    [self setupEmailRegisterUI];
    
    // 设置账号注册
    [self setupAccountRegisterUI];
    
    // 设置注册按钮
    [self setupRegisterButton];
    
    // 设置已有账号登录
//    [self setupToLoginButton];
}

// 设置手机号注册UI
- (void)setupPhoneRegisterUI {
    UIView *containerView = [[UIView alloc] init];
    containerView.hidden = NO;
    [_contentScrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentScrollView);
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(32));
    }];
    _phoneContainerView = containerView;
    
    // 手机号输入框
    UIView *phoneInputBg = [[UIView alloc] init];
    phoneInputBg.backgroundColor = COLORWHITE;
    phoneInputBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:phoneInputBg];
    [phoneInputBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView);
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 手机图标
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_account_input_tip_reb")];
    phoneIcon.contentMode = UIViewContentModeScaleAspectFit;
    [phoneInputBg addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phoneInputBg).offset(DWScale(16));
        make.centerY.equalTo(phoneInputBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 区号按钮
    _phoneAreaCodeBtn = [[UIButton alloc] init];
    [_phoneAreaCodeBtn setTitle:self.phoneCountryCode forState:UIControlStateNormal];
    [_phoneAreaCodeBtn setTitleColor:COLOR_33 forState:UIControlStateNormal];
    _phoneAreaCodeBtn.titleLabel.font = FONTN(15);
    [_phoneAreaCodeBtn addTarget:self action:@selector(selectPhoneCountryCode) forControlEvents:UIControlEventTouchUpInside];
    [phoneInputBg addSubview:_phoneAreaCodeBtn];
    [_phoneAreaCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phoneIcon.mas_trailing).offset(DWScale(8));
        make.centerY.equalTo(phoneInputBg);
        make.width.mas_equalTo(DWScale(60));
    }];
    
    // 分隔线
    _phoneLineView = [[UIView alloc] init];
    _phoneLineView.backgroundColor = COLOR_E6E6E6;
    [phoneInputBg addSubview:_phoneLineView];
    [_phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_phoneAreaCodeBtn.mas_trailing).offset(DWScale(8));
        make.centerY.equalTo(phoneInputBg);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(DWScale(20));
    }];
    
    // 手机号输入框
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.placeholder = MultilingualTranslation(@"请输入手机号");
    _phoneTextField.font = FONTN(15);
    _phoneTextField.textColor = COLOR_33;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneInputBg addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_phoneLineView.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(phoneInputBg).offset(-DWScale(16));
        make.centerY.equalTo(phoneInputBg);
    }];
    
    // 验证码输入框
    UIView *phoneVercodeBg = [[UIView alloc] init];
    phoneVercodeBg.backgroundColor = COLORWHITE;
    phoneVercodeBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:phoneVercodeBg];
    [phoneVercodeBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneInputBg.mas_bottom).offset(DWScale(16));
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    _phoneVercodeContainer = phoneVercodeBg;
    
    // 验证码图标
    UIImageView *vercodeIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_password_input_tip_reb")];
    vercodeIcon.contentMode = UIViewContentModeScaleAspectFit;
    [phoneVercodeBg addSubview:vercodeIcon];
    [vercodeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phoneVercodeBg).offset(DWScale(16));
        make.centerY.equalTo(phoneVercodeBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 获取验证码按钮
    _phoneGetVercodeBtn = [[UIButton alloc] init];
    [_phoneGetVercodeBtn setTitle:MultilingualTranslation(@"获取验证码") forState:UIControlStateNormal];
    [_phoneGetVercodeBtn setTitleColor:COLOR_81D8CF forState:UIControlStateNormal];
    _phoneGetVercodeBtn.titleLabel.font = FONTN(13);
    [_phoneGetVercodeBtn addTarget:self action:@selector(phoneGetVercodeAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneVercodeBg addSubview:_phoneGetVercodeBtn];
    [_phoneGetVercodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(phoneVercodeBg).offset(-DWScale(16));
        make.centerY.equalTo(phoneVercodeBg);
        make.width.mas_equalTo(DWScale(90));
    }];
    
    // 验证码输入框
    _phoneVercodeField = [[UITextField alloc] init];
    _phoneVercodeField.placeholder = MultilingualTranslation(@"请输入验证码");
    _phoneVercodeField.font = FONTN(15);
    _phoneVercodeField.textColor = COLOR_33;
    _phoneVercodeField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneVercodeBg addSubview:_phoneVercodeField];
    [_phoneVercodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(vercodeIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(_phoneGetVercodeBtn.mas_leading).offset(-DWScale(8));
        make.centerY.equalTo(phoneVercodeBg);
    }];
    
    // 密码输入框（初始隐藏）
    UIView *phonePasswordBg = [[UIView alloc] init];
    phonePasswordBg.backgroundColor = COLORWHITE;
    phonePasswordBg.layer.cornerRadius = DWScale(8);
    phonePasswordBg.hidden = NO;
    [containerView addSubview:phonePasswordBg];
    [phonePasswordBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneVercodeBg.mas_bottom).offset(DWScale(16));
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 锁图标
    UIImageView *lockIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_password_input_tip_reb")];
    lockIcon.contentMode = UIViewContentModeScaleAspectFit;
    [phonePasswordBg addSubview:lockIcon];
    [lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phonePasswordBg).offset(DWScale(16));
        make.centerY.equalTo(phonePasswordBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 密码输入框
    _phonePasswordField = [[UITextField alloc] init];
    _phonePasswordField.placeholder = MultilingualTranslation(@"请输入密码");
    _phonePasswordField.font = FONTN(15);
    _phonePasswordField.textColor = COLOR_33;
    _phonePasswordField.secureTextEntry = YES;
    [phonePasswordBg addSubview:_phonePasswordField];
    [_phonePasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(phonePasswordBg).offset(-DWScale(16));
        make.centerY.equalTo(phonePasswordBg);
    }];
    
    // 确认密码输入框
    UIView *phoneConfirmPasswordBg = [[UIView alloc] init];
    phoneConfirmPasswordBg.backgroundColor = COLORWHITE;
    phoneConfirmPasswordBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:phoneConfirmPasswordBg];
    [phoneConfirmPasswordBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phonePasswordBg.mas_bottom).offset(DWScale(16));
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 锁图标
    UIImageView *confirmLockIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_password_input_tip_reb")];
    confirmLockIcon.contentMode = UIViewContentModeScaleAspectFit;
    [phoneConfirmPasswordBg addSubview:confirmLockIcon];
    [confirmLockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phoneConfirmPasswordBg).offset(DWScale(16));
        make.centerY.equalTo(phoneConfirmPasswordBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 确认密码输入框
    _phoneConfirmPasswordField = [[UITextField alloc] init];
    _phoneConfirmPasswordField.placeholder = MultilingualTranslation(@"请再次输入密码");
    _phoneConfirmPasswordField.font = FONTN(15);
    _phoneConfirmPasswordField.textColor = COLOR_33;
    _phoneConfirmPasswordField.secureTextEntry = YES;
    [phoneConfirmPasswordBg addSubview:_phoneConfirmPasswordField];
    [_phoneConfirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(confirmLockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(phoneConfirmPasswordBg).offset(-DWScale(16));
        make.centerY.equalTo(phoneConfirmPasswordBg);
    }];
    
    // 邀请码输入框
    UIView *phoneInviteCodeBg = [[UIView alloc] init];
    phoneInviteCodeBg.backgroundColor = COLORWHITE;
    phoneInviteCodeBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:phoneInviteCodeBg];
    
    // 根据配置决定是否显示邀请码
    BOOL isMustInviteCode = [ZHostTool.appSysSetModel.isMustInviteCode isEqualToString:@"1"];
    if (!isMustInviteCode) {
        phoneInviteCodeBg.hidden = YES;
        [phoneInviteCodeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneConfirmPasswordBg.mas_bottom);
            make.leading.trailing.equalTo(containerView);
            make.height.mas_equalTo(0);
            make.bottom.equalTo(containerView);
        }];
    } else {
        [phoneInviteCodeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneConfirmPasswordBg.mas_bottom).offset(DWScale(16));
            make.leading.trailing.equalTo(containerView);
            make.height.mas_equalTo(DWScale(50));
            make.bottom.equalTo(containerView);
        }];
    }
    
    // 邀请码图标
    UIImageView *inviteIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_account_input_tip_reb")];
    inviteIcon.contentMode = UIViewContentModeScaleAspectFit;
    [phoneInviteCodeBg addSubview:inviteIcon];
    [inviteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(phoneInviteCodeBg).offset(DWScale(16));
        make.centerY.equalTo(phoneInviteCodeBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 邀请码输入框
    _phoneInviteCodeField = [[UITextField alloc] init];
    _phoneInviteCodeField.placeholder = isMustInviteCode ? MultilingualTranslation(@"请输入邀请码") : MultilingualTranslation(@"邀请码(选填)");
    _phoneInviteCodeField.font = FONTN(15);
    _phoneInviteCodeField.textColor = COLOR_33;
    [phoneInviteCodeBg addSubview:_phoneInviteCodeField];
    [_phoneInviteCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(inviteIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(phoneInviteCodeBg).offset(-DWScale(16));
        make.centerY.equalTo(phoneInviteCodeBg);
    }];
}

// 设置邮箱注册UI
- (void)setupEmailRegisterUI {
    UIView *containerView = [[UIView alloc] init];
    containerView.hidden = YES;
    [_contentScrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentScrollView);
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(32));
    }];
    _emailContainerView = containerView;
    
    // 邮箱输入框
    UIView *emailInputBg = [[UIView alloc] init];
    emailInputBg.backgroundColor = COLORWHITE;
    emailInputBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:emailInputBg];
    [emailInputBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView);
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 邮箱图标
    UIImageView *emailIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_email_input_tip_reb")];
    emailIcon.contentMode = UIViewContentModeScaleAspectFit;
    [emailInputBg addSubview:emailIcon];
    [emailIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailInputBg).offset(DWScale(16));
        make.centerY.equalTo(emailInputBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 邮箱输入框
    _emailTextField = [[UITextField alloc] init];
    _emailTextField.placeholder = MultilingualTranslation(@"请输入邮箱");
    _emailTextField.font = FONTN(15);
    _emailTextField.textColor = COLOR_33;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailInputBg addSubview:_emailTextField];
    [_emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(emailInputBg).offset(-DWScale(16));
        make.centerY.equalTo(emailInputBg);
    }];
    
    // 验证码输入框
    UIView *emailVercodeBg = [[UIView alloc] init];
    emailVercodeBg.backgroundColor = COLORWHITE;
    emailVercodeBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:emailVercodeBg];
    [emailVercodeBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailInputBg.mas_bottom).offset(DWScale(16));
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    _emailVercodeContainer = emailVercodeBg;
    
    // 验证码图标
    UIImageView *emailVercodeIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_password_input_tip_reb")];
    emailVercodeIcon.contentMode = UIViewContentModeScaleAspectFit;
    [emailVercodeBg addSubview:emailVercodeIcon];
    [emailVercodeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailVercodeBg).offset(DWScale(16));
        make.centerY.equalTo(emailVercodeBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 获取验证码按钮
    _emailGetVercodeBtn = [[UIButton alloc] init];
    [_emailGetVercodeBtn setTitle:MultilingualTranslation(@"获取验证码") forState:UIControlStateNormal];
    [_emailGetVercodeBtn setTitleColor:COLOR_81D8CF forState:UIControlStateNormal];
    _emailGetVercodeBtn.titleLabel.font = FONTN(13);
    [_emailGetVercodeBtn addTarget:self action:@selector(emailGetVercodeAction) forControlEvents:UIControlEventTouchUpInside];
    [emailVercodeBg addSubview:_emailGetVercodeBtn];
    [_emailGetVercodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(emailVercodeBg).offset(-DWScale(16));
        make.centerY.equalTo(emailVercodeBg);
        make.width.mas_equalTo(DWScale(90));
    }];
    
    // 验证码输入框
    _emailVercodeField = [[UITextField alloc] init];
    _emailVercodeField.placeholder = MultilingualTranslation(@"请输入验证码");
    _emailVercodeField.font = FONTN(15);
    _emailVercodeField.textColor = COLOR_33;
    _emailVercodeField.keyboardType = UIKeyboardTypeNumberPad;
    [emailVercodeBg addSubview:_emailVercodeField];
    [_emailVercodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailVercodeIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(_emailGetVercodeBtn.mas_leading).offset(-DWScale(8));
        make.centerY.equalTo(emailVercodeBg);
    }];
    
    // 密码输入框（初始隐藏）
    UIView *emailPasswordBg = [[UIView alloc] init];
    emailPasswordBg.backgroundColor = COLORWHITE;
    emailPasswordBg.layer.cornerRadius = DWScale(8);
    emailPasswordBg.hidden = NO;
    [containerView addSubview:emailPasswordBg];
    [emailPasswordBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailVercodeBg.mas_bottom).offset(DWScale(16));
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 锁图标
    UIImageView *lockIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_password_input_tip_reb")];
    lockIcon.contentMode = UIViewContentModeScaleAspectFit;
    [emailPasswordBg addSubview:lockIcon];
    [lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailPasswordBg).offset(DWScale(16));
        make.centerY.equalTo(emailPasswordBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 密码输入框
    _emailPasswordField = [[UITextField alloc] init];
    _emailPasswordField.placeholder = MultilingualTranslation(@"请输入密码");
    _emailPasswordField.font = FONTN(15);
    _emailPasswordField.textColor = COLOR_33;
    _emailPasswordField.secureTextEntry = YES;
    [emailPasswordBg addSubview:_emailPasswordField];
    [_emailPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(emailPasswordBg).offset(-DWScale(16));
        make.centerY.equalTo(emailPasswordBg);
    }];
    
    // 确认密码输入框
    UIView *emailConfirmPasswordBg = [[UIView alloc] init];
    emailConfirmPasswordBg.backgroundColor = COLORWHITE;
    emailConfirmPasswordBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:emailConfirmPasswordBg];
    [emailConfirmPasswordBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(emailPasswordBg.mas_bottom).offset(DWScale(16));
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 锁图标
    UIImageView *confirmLockIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_password_input_tip_reb")];
    confirmLockIcon.contentMode = UIViewContentModeScaleAspectFit;
    [emailConfirmPasswordBg addSubview:confirmLockIcon];
    [confirmLockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailConfirmPasswordBg).offset(DWScale(16));
        make.centerY.equalTo(emailConfirmPasswordBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 确认密码输入框
    _emailConfirmPasswordField = [[UITextField alloc] init];
    _emailConfirmPasswordField.placeholder = MultilingualTranslation(@"请再次输入密码");
    _emailConfirmPasswordField.font = FONTN(15);
    _emailConfirmPasswordField.textColor = COLOR_33;
    _emailConfirmPasswordField.secureTextEntry = YES;
    [emailConfirmPasswordBg addSubview:_emailConfirmPasswordField];
    [_emailConfirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(confirmLockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(emailConfirmPasswordBg).offset(-DWScale(16));
        make.centerY.equalTo(emailConfirmPasswordBg);
    }];
    
    // 邀请码输入框
    UIView *emailInviteCodeBg = [[UIView alloc] init];
    emailInviteCodeBg.backgroundColor = COLORWHITE;
    emailInviteCodeBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:emailInviteCodeBg];
    
    // 根据配置决定是否显示邀请码
    BOOL isMustInviteCode = [ZHostTool.appSysSetModel.isMustInviteCode isEqualToString:@"1"];
    if (!isMustInviteCode) {
        emailInviteCodeBg.hidden = YES;
        [emailInviteCodeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(emailConfirmPasswordBg.mas_bottom);
            make.leading.trailing.equalTo(containerView);
            make.height.mas_equalTo(0);
            make.bottom.equalTo(containerView);
        }];
    } else {
        [emailInviteCodeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(emailConfirmPasswordBg.mas_bottom).offset(DWScale(16));
            make.leading.trailing.equalTo(containerView);
            make.height.mas_equalTo(DWScale(50));
            make.bottom.equalTo(containerView);
        }];
    }
    
    // 邀请码图标
    UIImageView *inviteIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_account_input_tip_reb")];
    inviteIcon.contentMode = UIViewContentModeScaleAspectFit;
    [emailInviteCodeBg addSubview:inviteIcon];
    [inviteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailInviteCodeBg).offset(DWScale(16));
        make.centerY.equalTo(emailInviteCodeBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 邀请码输入框
    _emailInviteCodeField = [[UITextField alloc] init];
    _emailInviteCodeField.placeholder = isMustInviteCode ? MultilingualTranslation(@"请输入邀请码") : MultilingualTranslation(@"邀请码(选填)");
    _emailInviteCodeField.font = FONTN(15);
    _emailInviteCodeField.textColor = COLOR_33;
    [emailInviteCodeBg addSubview:_emailInviteCodeField];
    [_emailInviteCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(inviteIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(emailInviteCodeBg).offset(-DWScale(16));
        make.centerY.equalTo(emailInviteCodeBg);
    }];
}

// 设置账号注册UI
- (void)setupAccountRegisterUI {
    UIView *containerView = [[UIView alloc] init];
    containerView.hidden = YES;
    [_contentScrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentScrollView);
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(32));
    }];
    _accountContainerView = containerView;
    
    // 账号输入框
    UIView *accountInputBg = [[UIView alloc] init];
    accountInputBg.backgroundColor = COLORWHITE;
    accountInputBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:accountInputBg];
    [accountInputBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView);
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 账号图标
    UIImageView *accountIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_account_input_tip_reb")];
    accountIcon.contentMode = UIViewContentModeScaleAspectFit;
    [accountInputBg addSubview:accountIcon];
    [accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(accountInputBg).offset(DWScale(16));
        make.centerY.equalTo(accountInputBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 账号输入框
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.placeholder = MultilingualTranslation(@"请输入账号");
    _accountTextField.font = FONTN(15);
    _accountTextField.textColor = COLOR_33;
    [accountInputBg addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(accountIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(accountInputBg).offset(-DWScale(16));
        make.centerY.equalTo(accountInputBg);
    }];
    
    // 密码输入框
    UIView *accountPasswordBg = [[UIView alloc] init];
    accountPasswordBg.backgroundColor = COLORWHITE;
    accountPasswordBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:accountPasswordBg];
    [accountPasswordBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountInputBg.mas_bottom).offset(DWScale(16));
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 锁图标
    UIImageView *lockIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_password_input_tip_reb")];
    lockIcon.contentMode = UIViewContentModeScaleAspectFit;
    [accountPasswordBg addSubview:lockIcon];
    [lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(accountPasswordBg).offset(DWScale(16));
        make.centerY.equalTo(accountPasswordBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 密码输入框
    _accountPasswordField = [[UITextField alloc] init];
    _accountPasswordField.placeholder = MultilingualTranslation(@"请输入密码");
    _accountPasswordField.font = FONTN(15);
    _accountPasswordField.textColor = COLOR_33;
    _accountPasswordField.secureTextEntry = YES;
    [accountPasswordBg addSubview:_accountPasswordField];
    [_accountPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(accountPasswordBg).offset(-DWScale(16));
        make.centerY.equalTo(accountPasswordBg);
    }];
    
    // 确认密码输入框
    UIView *accountConfirmPasswordBg = [[UIView alloc] init];
    accountConfirmPasswordBg.backgroundColor = COLORWHITE;
    accountConfirmPasswordBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:accountConfirmPasswordBg];
    [accountConfirmPasswordBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountPasswordBg.mas_bottom).offset(DWScale(16));
        make.leading.trailing.equalTo(containerView);
        make.height.mas_equalTo(DWScale(50));
    }];
    
    // 锁图标
    UIImageView *confirmLockIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_password_input_tip_reb")];
    confirmLockIcon.contentMode = UIViewContentModeScaleAspectFit;
    [accountConfirmPasswordBg addSubview:confirmLockIcon];
    [confirmLockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(accountConfirmPasswordBg).offset(DWScale(16));
        make.centerY.equalTo(accountConfirmPasswordBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 确认密码输入框
    _accountConfirmPasswordField = [[UITextField alloc] init];
    _accountConfirmPasswordField.placeholder = MultilingualTranslation(@"请再次输入密码");
    _accountConfirmPasswordField.font = FONTN(15);
    _accountConfirmPasswordField.textColor = COLOR_33;
    _accountConfirmPasswordField.secureTextEntry = YES;
    [accountConfirmPasswordBg addSubview:_accountConfirmPasswordField];
    [_accountConfirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(confirmLockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(accountConfirmPasswordBg).offset(-DWScale(16));
        make.centerY.equalTo(accountConfirmPasswordBg);
    }];
    
    // 邀请码输入框
    UIView *accountInviteCodeBg = [[UIView alloc] init];
    accountInviteCodeBg.backgroundColor = COLORWHITE;
    accountInviteCodeBg.layer.cornerRadius = DWScale(8);
    [containerView addSubview:accountInviteCodeBg];
    
    // 根据配置决定是否显示邀请码
    BOOL isMustInviteCode = [ZHostTool.appSysSetModel.isMustInviteCode isEqualToString:@"1"];
    if (!isMustInviteCode) {
        accountInviteCodeBg.hidden = YES;
        [accountInviteCodeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountConfirmPasswordBg.mas_bottom);
            make.leading.trailing.equalTo(containerView);
            make.height.mas_equalTo(0);
            make.bottom.equalTo(containerView);
        }];
    } else {
        [accountInviteCodeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountConfirmPasswordBg.mas_bottom).offset(DWScale(16));
            make.leading.trailing.equalTo(containerView);
            make.height.mas_equalTo(DWScale(50));
            make.bottom.equalTo(containerView);
        }];
    }
    
    // 邀请码图标
    UIImageView *inviteIcon = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_account_input_tip_reb")];
    inviteIcon.contentMode = UIViewContentModeScaleAspectFit;
    [accountInviteCodeBg addSubview:inviteIcon];
    [inviteIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(accountInviteCodeBg).offset(DWScale(16));
        make.centerY.equalTo(accountInviteCodeBg);
        make.width.height.mas_equalTo(DWScale(20));
    }];
    
    // 邀请码输入框
    _accountInviteCodeField = [[UITextField alloc] init];
    _accountInviteCodeField.placeholder = isMustInviteCode ? MultilingualTranslation(@"请输入邀请码") : MultilingualTranslation(@"邀请码(选填)");
    _accountInviteCodeField.font = FONTN(15);
    _accountInviteCodeField.textColor = COLOR_33;
    [accountInviteCodeBg addSubview:_accountInviteCodeField];
    [_accountInviteCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(inviteIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(accountInviteCodeBg).offset(-DWScale(16));
        make.centerY.equalTo(accountInviteCodeBg);
    }];
}

// 设置注册按钮
- (void)setupRegisterButton {
    _registerBtn = [[UIButton alloc] init];
    [_registerBtn setTitle:MultilingualTranslation(@"注册账号") forState:UIControlStateNormal];
    [_registerBtn setTitleColor:COLORWHITE forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = FONTB(17);
    _registerBtn.backgroundColor = COLOR_81D8CF;
    _registerBtn.layer.cornerRadius = DWScale(25);
    [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [_registerBtn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_registerBtn addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_contentScrollView addSubview:_registerBtn];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneContainerView.mas_bottom).offset(DWScale(32));
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(32));
        make.height.mas_equalTo(DWScale(50));
    }];
}

// 设置服务协议
- (void)setupPolicyView {
    _policyView = [[ProtocolPolicyView alloc] init];
    [_contentScrollView addSubview:_policyView];
    [_policyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registerBtn.mas_bottom).offset(DWScale(16));
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(16));
        make.height.mas_equalTo(DWScale(40));
    }];
}

// 设置已有账号登录
- (void)setupToLoginButton {
//    _toLoginBtn = [[UIButton alloc] init];
//    [_toLoginBtn setTitle:MultilingualTranslation(@"已有账号？去登录") forState:UIControlStateNormal];
//    [_toLoginBtn setTitleColor:COLOR_81D8CF forState:UIControlStateNormal];
//    _toLoginBtn.titleLabel.font = FONTN(14);
//    [_toLoginBtn addTarget:self action:@selector(toLoginAction) forControlEvents:UIControlEventTouchUpInside];
//    [_contentScrollView addSubview:_toLoginBtn];
//    [_toLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_policyView.mas_bottom).offset(DWScale(20));
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(DWScale(32));
//        make.bottom.equalTo(_contentScrollView).offset(-DWScale(40));
//    }];
}

#pragma mark - TextField Listeners

// 设置输入框监听
- (void)setupTextFieldListeners {
    // 手机号输入框
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phonePasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneConfirmPasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneVercodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_phoneInviteCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 邮箱输入框
    [_emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_emailPasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_emailConfirmPasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_emailVercodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_emailInviteCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 账号输入框
    [_accountTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_accountPasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_accountConfirmPasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_accountInviteCodeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 输入结束监听（用于显示错误提示）
    [_phoneTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_phonePasswordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_phoneConfirmPasswordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_emailTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_emailPasswordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_emailConfirmPasswordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [_accountTextField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_accountPasswordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    [_accountConfirmPasswordField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
}

// 输入框内容改变
- (void)textFieldDidChange:(UITextField *)textField {
    [self checkRegisterButtonAvailable];
}

// 输入框结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.currentSelectedIndex == 0) {
        // 手机号注册
        if (textField == _phoneTextField) {
            [ZAuthInputTools registerCheckPhoneWithText:textField.text];
        } else if (textField == _phonePasswordField) {
            [self validatePassword:textField.text];
        } else if (textField == _phoneConfirmPasswordField) {
            if (![_phonePasswordField.text isEqualToString:textField.text]) {
                [HUD showMessage:MultilingualTranslation(@"密码不一致") inView:self.view];
            }
        }
    } else if (self.currentSelectedIndex == 1) {
        // 邮箱注册
        if (textField == _emailTextField) {
            [ZAuthInputTools registerCheckEmailWithText:textField.text];
        } else if (textField == _emailPasswordField) {
            [self validatePassword:textField.text];
        } else if (textField == _emailConfirmPasswordField) {
            if (![_emailPasswordField.text isEqualToString:textField.text]) {
                [HUD showMessage:MultilingualTranslation(@"密码不一致") inView:self.view];
            }
        }
    } else {
        // 账号注册
        if (textField == _accountTextField) {
            [self validateAccountFormat:textField.text];
        } else if (textField == _accountPasswordField) {
            [self validatePassword:textField.text];
        } else if (textField == _accountConfirmPasswordField) {
            if (![_accountPasswordField.text isEqualToString:textField.text]) {
                [HUD showMessage:MultilingualTranslation(@"密码不一致") inView:self.view];
            }
        }
    }
}

// 验证账号格式
- (void)validateAccountFormat:(NSString *)account {
    if ([NSString isNil:account]) {
        return;
    }
    
    if ([ZAuthInputTools registerCheckInputAccountEndWithTextFormat:account] == NO) {
        [HUD showMessage:MultilingualTranslation(@"帐号前两位必须为英文，只支持英文或数字") inView:self.view];
    } else if ([ZAuthInputTools registerCheckInputAccountEndWithTextLength:account] == NO) {
        [HUD showMessage:MultilingualTranslation(@"帐号长度6～16位") inView:self.view];
    }
}

// 验证密码格式
- (void)validatePassword:(NSString *)password {
    if ([NSString isNil:password]) {
        return;
    }
    
    if ([ZAuthInputTools checkCreatPasswordEndWithTextLength:password] == NO) {
        [HUD showMessage:MultilingualTranslation(@"密码长度6-16") inView:self.view];
    } else if ([ZAuthInputTools checkCreatPasswordEndWithTextFormat:password] == NO) {
        [HUD showMessage:MultilingualTranslation(@"密码须包含字母、数字") inView:self.view];
    }
}

// 检查注册按钮是否可用
- (void)checkRegisterButtonAvailable {
    BOOL enabled = NO;
    
    if (self.currentSelectedIndex == 0) {
        // 手机号注册
        BOOL isMustInviteCode = [ZHostTool.appSysSetModel.isMustInviteCode isEqualToString:@"1"];
        if (isMustInviteCode) {
            enabled = _phoneTextField.text.length > 0 && 
                     _phoneVercodeField.text.length > 0 && 
                     _phonePasswordField.text.length > 0 && 
                     _phoneConfirmPasswordField.text.length > 0 &&
                     _phoneInviteCodeField.text.length > 0;
        } else {
            enabled = _phoneTextField.text.length > 0 && 
                     _phoneVercodeField.text.length > 0 && 
                     _phonePasswordField.text.length > 0 && 
                     _phoneConfirmPasswordField.text.length > 0;
        }
    } else if (self.currentSelectedIndex == 1) {
        // 邮箱注册
        BOOL isMustInviteCode = [ZHostTool.appSysSetModel.isMustInviteCode isEqualToString:@"1"];
        if (isMustInviteCode) {
            enabled = _emailTextField.text.length > 0 && 
                     _emailVercodeField.text.length > 0 && 
                     _emailPasswordField.text.length > 0 && 
                     _emailConfirmPasswordField.text.length > 0 &&
                     _emailInviteCodeField.text.length > 0;
        } else {
            enabled = _emailTextField.text.length > 0 && 
                     _emailVercodeField.text.length > 0 && 
                     _emailPasswordField.text.length > 0 && 
                     _emailConfirmPasswordField.text.length > 0;
        }
    } else {
        // 账号注册
        BOOL isMustInviteCode = [ZHostTool.appSysSetModel.isMustInviteCode isEqualToString:@"1"];
        if (isMustInviteCode) {
            enabled = _accountTextField.text.length > 0 && 
                     _accountPasswordField.text.length > 0 && 
                     _accountConfirmPasswordField.text.length > 0 &&
                     _accountInviteCodeField.text.length > 0;
        } else {
            enabled = _accountTextField.text.length > 0 && 
                     _accountPasswordField.text.length > 0 && 
                     _accountConfirmPasswordField.text.length > 0;
        }
    }
    
    _registerBtn.enabled = enabled;
    if (enabled) {
        _registerBtn.backgroundColor = COLOR_81D8CF;
    } else {
        _registerBtn.backgroundColor = [COLOR_81D8CF colorWithAlphaComponent:0.3];
    }
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(NJCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.currentSelectedIndex = index;
    
    // 隐藏所有容器
    _phoneContainerView.hidden = YES;
    _emailContainerView.hidden = YES;
    _accountContainerView.hidden = YES;
    
    // 显示当前选中的容器
    if (index == 0) {
        _phoneContainerView.hidden = NO;
    } else if (index == 1) {
        _emailContainerView.hidden = NO;
    } else {
        _accountContainerView.hidden = NO;
    }
    
    // 切换tab时检查按钮状态
    [self checkRegisterButtonAvailable];
}

#pragma mark - Actions

// 返回按钮点击
- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

// 企业号设置
- (void)companyIdBtnClick {
    LoginServerConfigView *configView = [[LoginServerConfigView alloc] initWithFrame:self.view.bounds];
    WeakSelf
    configView.configCompleteBlock = ^(NSString * _Nullable companyId, NSString * _Nullable ipDomain) {
        if (![NSString isNil:companyId]) {
            weakSelf.presetCompanyId = companyId;
            weakSelf.presetIpDomain = nil;
        } else if (![NSString isNil:ipDomain]) {
            weakSelf.presetIpDomain = ipDomain;
            weakSelf.presetCompanyId = nil;
        }
        
        // 持久化保存
        [weakSelf saveCompanyIdConfig];
        
        // 更新按钮显示
        [weakSelf updateCompanyIdButtonDisplay];
    };
    [configView show];
}

// 选择手机号国家区号
- (void)selectPhoneCountryCode {
    ZCountryCodeViewController *countryCodeVC = [[ZCountryCodeViewController alloc] init];
    [self.navigationController pushViewController:countryCodeVC animated:YES];
    
    WeakSelf
    [countryCodeVC setSelecgCountryCodeBlock:^(NSDictionary * _Nonnull dic) {
        NSString *prefix = [dic objectForKey:@"prefix"];
        if (![NSString isNil:prefix]) {
            weakSelf.phoneCountryCode = [NSString stringWithFormat:@"+%@", prefix];
            [weakSelf.phoneAreaCodeBtn setTitle:weakSelf.phoneCountryCode forState:UIControlStateNormal];
        }
    }];
}

// 注册按钮点击
- (void)registerAction {
    // 关闭键盘
    [self.view endEditing:YES];
    
    // 判断是否已经预设了企业号
    if (![NSString isNil:self.presetCompanyId] || ![NSString isNil:self.presetIpDomain]) {
        // 已预设，继续注册流程
        [self continueRegisterProcess];
    } else {
        // 未预设，弹出配置弹窗
        [self showServerConfigViewForRegister];
    }
}

// 显示服务器配置弹窗（用于注册流程）
- (void)showServerConfigViewForRegister {
    LoginServerConfigView *configView = [[LoginServerConfigView alloc] init];
    WeakSelf
    [configView setConfigCompleteBlock:^(NSString * _Nullable companyId, NSString * _Nullable ipDomain) {
        // 保存配置信息
        if (![NSString isNil:companyId]) {
            weakSelf.presetCompanyId = companyId;
            weakSelf.presetIpDomain = nil;
        } else if (![NSString isNil:ipDomain]) {
            weakSelf.presetIpDomain = ipDomain;
            weakSelf.presetCompanyId = nil;
        }
        
        // 持久化保存
        [weakSelf saveCompanyIdConfig];
        
        // 更新按钮显示
        [weakSelf updateCompanyIdButtonDisplay];
        
        // 配置完成后继续注册流程
        NSLog(@"服务器配置完成，继续注册流程");
        NSLog(@"企业号: %@, IP/域名: %@", companyId, ipDomain);
        [HUD showMessage:MultilingualTranslation(@"企业号设置成功")];
        
        // 继续注册流程
        [weakSelf continueRegisterProcess];
    }];
    [configView show];
}

// 继续注册流程
- (void)continueRegisterProcess {
    // 获取当前注册方式
    int registerWay = UserAuthTypePhone;
    if (self.currentSelectedIndex == 0) {
        registerWay = UserAuthTypePhone;
    } else if (self.currentSelectedIndex == 1) {
        registerWay = UserAuthTypeEmail;
    } else {
        registerWay = UserAuthTypeAccount;
    }
    
    // 账号注册时先验证账号是否存在
    if (registerWay == UserAuthTypeAccount) {
        [self requestUserExistWithRegisterWay:registerWay];
    } else {
        [self checkInputContentWithRegisterWay:registerWay];
    }
}

// 检查输入内容
- (void)checkInputContentWithRegisterWay:(int)registerWay {
    NSString *account = @"";
    NSString *vercode = @"";
    NSString *password = @"";
    NSString *confirmPassword = @"";
    NSString *inviteCode = @"";
    NSString *areaCode = @"";
    
    // 获取输入内容
    if (registerWay == UserAuthTypePhone) {
        account = self.phoneTextField.text;
        vercode = self.phoneVercodeField.text;
        password = self.phonePasswordField.text;
        confirmPassword = self.phoneConfirmPasswordField.text;
        inviteCode = self.phoneInviteCodeField.text;
        areaCode = self.phoneCountryCode;
        
        // 验证手机号
        if ([ZAuthInputTools registerCheckPhoneWithText:account] == NO) {
            return;
        }
        // 验证验证码
        if ([ZAuthInputTools checkVerCodeWithText:vercode] == NO) {
            return;
        }
    } else if (registerWay == UserAuthTypeEmail) {
        account = self.emailTextField.text;
        vercode = self.emailVercodeField.text;
        password = self.emailPasswordField.text;
        confirmPassword = self.emailConfirmPasswordField.text;
        inviteCode = self.emailInviteCodeField.text;
        
        // 验证邮箱
        if ([ZAuthInputTools registerCheckEmailWithText:account] == NO) {
            return;
        }
        // 验证验证码
        if ([ZAuthInputTools checkVerCodeWithText:vercode] == NO) {
            return;
        }
    } else {
        account = self.accountTextField.text;
        password = self.accountPasswordField.text;
        confirmPassword = self.accountConfirmPasswordField.text;
        inviteCode = self.accountInviteCodeField.text;
        
        // 验证账号格式
        if ([ZAuthInputTools registerCheckInputAccountEndWithTextFormat:account] == NO) {
            [HUD showMessage:MultilingualTranslation(@"帐号前两位必须为英文，只支持英文或数字")];
            return;
        }
        // 验证账号长度
        if ([ZAuthInputTools registerCheckInputAccountEndWithTextLength:account] == NO) {
            [HUD showMessage:MultilingualTranslation(@"帐号长度6～16位")];
            return;
        }
    }
    
    // 验证密码
    if ([ZAuthInputTools checkCreatPasswordEndWithTextLength:password] == NO ||
        [ZAuthInputTools checkCreatPasswordEndWithTextFormat:password] == NO) {
        [HUD showMessage:MultilingualTranslation(@"密码长度6-16位，须包含字母、数字")];
        return;
    }
    
    // 验证确认密码
    if (![password isEqualToString:confirmPassword]) {
        [HUD showMessage:MultilingualTranslation(@"密码不一致")];
        return;
    }
    
    // 验证邀请码（如果必填）
    if ([ZHostTool.appSysSetModel.isMustInviteCode isEqualToString:@"1"]) {
        if ([NSString isNil:inviteCode]) {
            [HUD showMessage:MultilingualTranslation(@"请输入邀请码")];
            return;
        }
        if (![ZAuthInputTools checkInviteCodeWithText:inviteCode]) {
            return;
        }
    }
    
    // 检查服务协议
    if (!self.policyView.checkBoxBtn.selected) {
        NSString *serveText = MultilingualTranslation(@"《服务协议》");
        NSString *privateText = MultilingualTranslation(@"《隐私政策》");
        NSString *contentText = [NSString stringWithFormat:MultilingualTranslation(@"请阅读并同意%@和%@"), serveText, privateText];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:contentText];
        [attText addAttribute:NSForegroundColorAttributeName value:COLOR_81D8CF range:[contentText rangeOfString:serveText]];
        [attText addAttribute:NSForegroundColorAttributeName value:COLOR_81D8CF range:[contentText rangeOfString:privateText]];
        
        ZAlertTipView *alertView = [ZAlertTipView new];
        alertView.lblTitle.text = MultilingualTranslation(@"提示");
        alertView.lblContent.attributedText = attText;
        [alertView.btnSure setTitle:MultilingualTranslation(@"同意并继续") forState:UIControlStateNormal];
        [alertView alertTipViewSHow];
        
        WeakSelf
        alertView.sureBtnBlock = ^{
            weakSelf.policyView.checkBoxBtn.selected = YES;
            [weakSelf registerAction];
        };
        return;
    }
    
    // 获取加密密钥
    [self requestGetEncryptKey];
}

// 检查账号是否存在
- (void)requestUserExistWithRegisterWay:(int)registerWay {
    NSString *inputText = @"";
    NSString *areaCode = @"";
    
    if (registerWay == UserAuthTypePhone) {
        inputText = self.phoneTextField.text;
        areaCode = self.phoneCountryCode;
        if ([ZAuthInputTools registerCheckPhoneWithText:inputText] == NO) {
            return;
        }
    } else if (registerWay == UserAuthTypeEmail) {
        inputText = self.emailTextField.text;
        if ([ZAuthInputTools registerCheckEmailWithText:inputText] == NO) {
            return;
        }
    } else {
        inputText = self.accountTextField.text;
        if ([ZAuthInputTools registerCheckInputAccountEndWithTextFormat:inputText] == NO ||
            [ZAuthInputTools registerCheckInputAccountEndWithTextLength:inputText] == NO) {
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:inputText forKey:@"loginInfo"];
    [params setObjectSafe:areaCode forKey:@"areaCode"];
    [params setObjectSafe:[NSNumber numberWithInt:registerWay] forKey:@"loginType"];
    
    [HUD showActivityMessage:@""];
    
    WeakSelf
    [IMSDKManager authUserExistWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            
            BOOL exist = [data boolValue];
            if (!exist) {
                // 账号不存在，可以注册
                if (registerWay == UserAuthTypePhone || registerWay == UserAuthTypeEmail) {
                    // 手机号或邮箱需要获取验证码
                    [weakSelf showGetVercodeForRegisterWay:registerWay];
                } else {
                    // 账号注册直接进行下一步
                    [weakSelf checkInputContentWithRegisterWay:registerWay];
                }
            } else {
                // 账号已存在
                if (registerWay == UserAuthTypePhone) {
                    [HUD showMessage:MultilingualTranslation(@"该手机号已被注册")];
                } else if (registerWay == UserAuthTypeEmail) {
                    [HUD showMessage:MultilingualTranslation(@"该邮箱已被注册")];
                } else {
                    [HUD showMessage:MultilingualTranslation(@"该账号已被注册")];
                }
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
    }];
}

// 显示获取验证码提示（注册时）
- (void)showGetVercodeForRegisterWay:(int)registerWay {
    // 手机号或邮箱注册时，账号不存在才能获取验证码
    // 这里已经验证过账号不存在，可以提示用户点击获取验证码按钮
    if (registerWay == UserAuthTypePhone) {
        [HUD showMessage:MultilingualTranslation(@"请获取验证码")];
    } else if (registerWay == UserAuthTypeEmail) {
        [HUD showMessage:MultilingualTranslation(@"请获取验证码")];
    }
}

// 手机号获取验证码
- (void)phoneGetVercodeAction {
    NSString *phone = self.phoneTextField.text;
    if ([ZAuthInputTools registerCheckPhoneWithText:phone] == NO) {
        return;
    }
    
    // 先检查账号是否存在
    [self checkAccountExistBeforeGetVercode:UserAuthTypePhone account:phone];
}

// 邮箱获取验证码
- (void)emailGetVercodeAction {
    NSString *email = self.emailTextField.text;
    if ([ZAuthInputTools registerCheckEmailWithText:email] == NO) {
        return;
    }
    
    // 先检查账号是否存在
    [self checkAccountExistBeforeGetVercode:UserAuthTypeEmail account:email];
}

// 获取验证码前检查账号是否存在
- (void)checkAccountExistBeforeGetVercode:(int)registerWay account:(NSString *)account {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:account forKey:@"loginInfo"];
    [params setObjectSafe:(registerWay == UserAuthTypePhone ? self.phoneCountryCode : @"") forKey:@"areaCode"];
    [params setObjectSafe:[NSNumber numberWithInt:registerWay] forKey:@"loginType"];
    
    [HUD showActivityMessage:@""];
    
    WeakSelf
    [IMSDKManager authUserExistWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            
            BOOL exist = [data boolValue];
            if (!exist) {
                // 账号不存在，可以获取验证码
                [weakSelf requestGetVercode:registerWay account:account];
            } else {
                // 账号已存在
                if (registerWay == UserAuthTypePhone) {
                    [HUD showMessage:MultilingualTranslation(@"该手机号已被注册")];
                } else {
                    [HUD showMessage:MultilingualTranslation(@"该邮箱已被注册")];
                }
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
    }];
}

// 获取验证码
- (void)requestGetVercode:(int)registerWay account:(NSString *)account {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:account forKey:@"loginInfo"];
    [params setObjectSafe:[NSNumber numberWithInt:registerWay] forKey:@"loginType"];
    [params setObjectSafe:[NSNumber numberWithInt:1] forKey:@"type"]; // 1:注册
    [params setObjectSafe:(registerWay == UserAuthTypePhone ? self.phoneCountryCode : @"") forKey:@"areaCode"];
    
    [HUD showActivityMessage:@""];
    
    WeakSelf
    [IMSDKManager authGetPhoneEmailVerCodeWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessage:MultilingualTranslation(@"验证码已发送")];
            
            // 开始倒计时
            if (registerWay == UserAuthTypePhone) {
                [weakSelf startPhoneVercodeCountdown];
            } else {
                [weakSelf startEmailVercodeCountdown];
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
    }];
}

// 手机号验证码倒计时
- (void)startPhoneVercodeCountdown {
    self.phoneVercodeCountdown = 60;
    self.phoneGetVercodeBtn.enabled = NO;
    [self.phoneGetVercodeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)self.phoneVercodeCountdown] forState:UIControlStateNormal];
    
    self.phoneVercodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(phoneVercodeCountdownTick) userInfo:nil repeats:YES];
}

- (void)phoneVercodeCountdownTick {
    self.phoneVercodeCountdown--;
    if (self.phoneVercodeCountdown <= 0) {
        [self.phoneVercodeTimer invalidate];
        self.phoneVercodeTimer = nil;
        self.phoneGetVercodeBtn.enabled = YES;
        [self.phoneGetVercodeBtn setTitle:MultilingualTranslation(@"获取验证码") forState:UIControlStateNormal];
    } else {
        [self.phoneGetVercodeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)self.phoneVercodeCountdown] forState:UIControlStateNormal];
    }
}

// 邮箱验证码倒计时
- (void)startEmailVercodeCountdown {
    self.emailVercodeCountdown = 60;
    self.emailGetVercodeBtn.enabled = NO;
    [self.emailGetVercodeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)self.emailVercodeCountdown] forState:UIControlStateNormal];
    
    self.emailVercodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(emailVercodeCountdownTick) userInfo:nil repeats:YES];
}

- (void)emailVercodeCountdownTick {
    self.emailVercodeCountdown--;
    if (self.emailVercodeCountdown <= 0) {
        [self.emailVercodeTimer invalidate];
        self.emailVercodeTimer = nil;
        self.emailGetVercodeBtn.enabled = YES;
        [self.emailGetVercodeBtn setTitle:MultilingualTranslation(@"获取验证码") forState:UIControlStateNormal];
    } else {
        [self.emailGetVercodeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)self.emailVercodeCountdown] forState:UIControlStateNormal];
    }
}

// 获取加密密钥
- (void)requestGetEncryptKey {
    [HUD showActivityMessage:@""];
    
    WeakSelf
    [IMSDKManager authGetEncryptKeySuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            if ([data isKindOfClass:[NSString class]]) {
                NSString *encryptKey = (NSString *)data;
                [weakSelf requestRegisterWithEncryptKey:encryptKey];
            } else {
                [HUD hideHUD];
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
    }];
}

// 注册请求
- (void)requestRegisterWithEncryptKey:(NSString *)encryptKey {
    // 获取当前注册方式
    int registerWay = UserAuthTypePhone;
    NSString *account = @"";
    NSString *password = @"";
    NSString *vercode = @"";
    NSString *areaCode = @"";
    
    if (self.currentSelectedIndex == 0) {
        registerWay = UserAuthTypePhone;
        account = self.phoneTextField.text;
        password = self.phonePasswordField.text;
        vercode = self.phoneVercodeField.text;
        areaCode = self.phoneCountryCode;
    } else if (self.currentSelectedIndex == 1) {
        registerWay = UserAuthTypeEmail;
        account = self.emailTextField.text;
        password = self.emailPasswordField.text;
        vercode = self.emailVercodeField.text;
    } else {
        registerWay = UserAuthTypeAccount;
        account = self.accountTextField.text;
        password = self.accountPasswordField.text;
    }
    
    // AES对称加密密码
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@", encryptKey, password];
    NSString *userPwStr = [LXChatEncrypt method4:passwordKey];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:account forKey:@"loginInfo"];
    [params setObjectSafe:[NSNumber numberWithInt:registerWay] forKey:@"loginType"];
    [params setObjectSafe:vercode forKey:@"code"];
    [params setObjectSafe:encryptKey forKey:@"encryptKey"];
    [params setObjectSafe:[NSNumber numberWithInt:1] forKey:@"registerType"];
    [params setObjectSafe:[NSNumber numberWithInt:1] forKey:@"type"];
    [params setObjectSafe:areaCode forKey:@"areaCode"];
    [params setObjectSafe:@"" forKey:@"inviteCode"];
    [params setObjectSafe:userPwStr forKey:@"userPw"];
    
    WeakSelf
    [IMSDKManager authRegisterWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD showMessage:MultilingualTranslation(@"注册成功！")];
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                ZUserModel *registerUserModel = [ZUserModel mj_objectWithKeyValues:data];
                [registerUserModel saveUserInfo];
                [ZUserModel savePreAccount:account Type:registerWay];
                [UserManager setUserInfo:registerUserModel];
                
                // Socket用户登录连接
                LingIMSDKUserOptions *userOption = [LingIMSDKUserOptions new];
                userOption.userToken = UserManager.userInfo.token;
                userOption.userID = UserManager.userInfo.userUID;
                userOption.userNickname = UserManager.userInfo.nickname;
                userOption.userAvatar = UserManager.userInfo.avatar;
                [IMSDKManager configSDKUserWith:userOption];
                
                [ZWeakPwdCheckTool sharedInstance].userPwd = password;
                [ZTOOL setupTabBarUI];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate configDB];
                [delegate configMediaCall];
                
                // 日志模块
                NSString *loganURL = [ZTOOL loganEffectivePublishURL];
                [ZTOOL reloadLoganIfNeededWithPublishURL:loganURL];
                
                // 小程序
                [delegate checkMiniAppFloatShow];
                
                // 用户注册成功后调用
                [delegate openInstallReportRegister];
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            
            if (code == Auth_User_Account_Banned || code == Auth_User_Device_Banned || code == Auth_User_IPAddress_Banned) {
                if (registerWay == UserAuthTypeAccount) {
                    [ZTOOL setupAlertUserBannedUIWithErrorCode:code withContent:account loginType:UserAuthTypeAccount];
                } else {
                    [ZTOOL setupAlertUserBannedUIWithErrorCode:code withContent:msg loginType:0];
                }
                return;
            } else if (code == LingIMHttpResponseCodeUsedIpDisabled) {
                [HUD showMessage:[NSString stringWithFormat:MultilingualTranslation(@"登录IP：%@ 不在白名单内"), msg]];
            } else {
                [HUD showMessageWithCode:code errorMsg:msg];
            }
        }];
    }];
}

// 去登录
- (void)toLoginAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 按钮按下效果
- (void)buttonTouchDown:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.95, 0.95);
        button.alpha = 0.7;
    }];
}

// 按钮抬起效果
- (void)buttonTouchUp:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformIdentity;
        button.alpha = 1.0;
    }];
}

#pragma mark - Helper Methods

// 加载保存的企业号配置
- (void)loadSavedCompanyIdConfig {
    NSString *savedCompanyId = [[MMKV defaultMMKV] getStringForKey:@"LoginPresetCompanyId"];
    NSString *savedIpDomain = [[MMKV defaultMMKV] getStringForKey:@"LoginPresetIpDomain"];
    
    if (![NSString isNil:savedCompanyId]) {
        self.presetCompanyId = savedCompanyId;
    }
    
    if (![NSString isNil:savedIpDomain]) {
        self.presetIpDomain = savedIpDomain;
    }
}

// 保存企业号配置
- (void)saveCompanyIdConfig {
    if (![NSString isNil:self.presetCompanyId]) {
        [[MMKV defaultMMKV] setString:self.presetCompanyId forKey:@"LoginPresetCompanyId"];
    } else {
        [[MMKV defaultMMKV] removeValueForKey:@"LoginPresetCompanyId"];
    }
    
    if (![NSString isNil:self.presetIpDomain]) {
        [[MMKV defaultMMKV] setString:self.presetIpDomain forKey:@"LoginPresetIpDomain"];
    } else {
        [[MMKV defaultMMKV] removeValueForKey:@"LoginPresetIpDomain"];
    }
}

// 更新企业号按钮显示
- (void)updateCompanyIdButtonDisplay {
    NSString *title = @"";
    if (![NSString isNil:self.presetCompanyId]) {
        title = [NSString stringWithFormat:@" %@", self.presetCompanyId];
    } else if (![NSString isNil:self.presetIpDomain]) {
        title = [NSString stringWithFormat:@" %@", self.presetIpDomain];
    } else {
        title = @" 设置企业号";
    }
    
    [_companyIdBtn setTitle:title forState:UIControlStateNormal];
}

// 设置默认国家区号
- (void)setupDefaultCountryCode {
    // 使用系统地区设置
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    // 默认区号
    NSString *defaultAreaCode = @"+86";
    
    // 根据国家代码查询区号
    if (countryCode) {
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"areacode" ofType:@"db"];
        FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
        
        if ([db open]) {
            NSString *query = @"SELECT prefix FROM areacode WHERE countryCode = ?";
            FMResultSet *result = [db executeQuery:query, countryCode];
            
            if ([result next]) {
                NSString *prefix = [result stringForColumn:@"prefix"];
                if (![NSString isNil:prefix]) {
                    defaultAreaCode = [NSString stringWithFormat:@"+%@", prefix];
                }
            }
            
            [result close];
            [db close];
        }
    }
    
    self.phoneCountryCode = defaultAreaCode;
}

// 调整图片大小
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

#pragma mark - Lazy Load

- (ZCaptchaCodeTools *)captchaTools {
    if (!_captchaTools) {
        _captchaTools = [[ZCaptchaCodeTools alloc] init];
    }
    return _captchaTools;
}

@end
