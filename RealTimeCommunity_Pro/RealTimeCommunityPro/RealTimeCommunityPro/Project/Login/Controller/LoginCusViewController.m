//
//  LoginCusViewController.m
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/10/28.
//

#import "LoginCusViewController.h"
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
#import "NMLanguageSetViewController.h"
#import "SystermNetSettingViewController.h"
#import "RegisterCusViewController.h"
#import "MainInputTextView.h"
#import "ZQRcodeScanViewController.h"
#import "ZImgVerCodeView.h"
#import "ZCaptchaCodeTools.h"

// 页面模式枚举--ceshi
typedef NS_ENUM(NSInteger, LoginPageMode) {
    LoginPageModeJoinServer = 0,  // 加入企业号模式
    LoginPageModeLogin = 1        // 登录模式
};

// 服务器配置类型枚举
typedef NS_ENUM(NSInteger, ServerConfigType) {
    ServerConfigTypeCompanyId = 0,  // 企业号
    ServerConfigTypeIPDomain = 1    // IP直连
};

@interface LoginCusViewController () <NJSelectCategoryViewDelegate>

// 页面模式
@property (nonatomic, assign) LoginPageMode pageMode; // 当前页面模式
@property (nonatomic, assign) ServerConfigType serverConfigType; // 服务器配置类型（加入企业号模式下使用）

// UI组件
@property (nonatomic, strong) CAGradientLayer *gradientLayer; // 渐变背景
@property (nonatomic, strong) UIButton *languageBtn; // 多语言按钮
@property (nonatomic, strong) UIButton *networkBtn; // 网络设置按钮
@property (nonatomic, strong) UIButton *companyIdBtn; // 企业号设置按钮（仅登录模式显示）

// 企业号配置信息
@property (nonatomic, copy) NSString *presetCompanyId; // 预设的企业号
@property (nonatomic, copy) NSString *presetIpDomain; // 预设的IP/域名

// 切换视图
@property (nonatomic, strong) LJCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *loginTypeArr; // 动态登录方式数组

// 加入企业号模式的UI组件
@property (nonatomic, strong) UIView *joinServerContainerView; // 容器视图（加入企业号的内容区域）
@property (nonatomic, strong) MainInputTextView *companyIdInputView; // 企业号输入框
@property (nonatomic, strong) MainInputTextView *ipDomainHostInputView; // IP/域名输入框
@property (nonatomic, strong) MainInputTextView *ipDomainPortInputView; // 端口号输入框
@property (nonatomic, strong) UILabel *colonLbl; // 冒号标签
@property (nonatomic, strong) UIButton *scanServerButton; // 扫一扫加入服务器按钮
@property (nonatomic, strong) UIButton *confirmServerButton; // 确定按钮（加入企业号模式）
@property (nonatomic, assign) BOOL isScanning; // 是否正在扫码

// 三个登录类型的视图容器
@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UIView *emailView;
@property (nonatomic, strong) UIView *accountView;

@property (nonatomic, assign) NSInteger currentSelectedIndex; // 当前选中下标

// 手机号登录相关
@property (nonatomic, strong) UIButton *phoneAreaCodeBtn; // 区号按钮
@property (nonatomic, strong) UIView *phoneLineView; // 分割线
@property (nonatomic, copy) NSString *phoneCountryCode; // 当前选中的区号
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *phonePasswordField;
@property (nonatomic, assign) BOOL phonePasswordShown;
@property (nonatomic, assign) int phoneInputType; // 0:密码登录  1:验证码登录
@property (nonatomic, strong) UIButton *phoneSwitchBtn; // 切换密码/验证码按钮
@property (nonatomic, strong) UIView *phonePasswordContainer; // 密码容器，用于切换
@property (nonatomic, strong) UIButton *phoneGetVerCodeBtn; // 获取验证码按钮
@property (nonatomic, strong) NSTimer *phoneVerCodeTimer; // 验证码倒计时
@property (nonatomic, assign) NSInteger phoneVerCodeCountdown; // 倒计时秒数

// 邮箱登录相关
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *emailPasswordField;
@property (nonatomic, assign) BOOL emailPasswordShown;
@property (nonatomic, assign) int emailInputType; // 0:密码登录  1:验证码登录
@property (nonatomic, strong) UIButton *emailSwitchBtn; // 切换密码/验证码按钮
@property (nonatomic, strong) UIView *emailPasswordContainer; // 密码容器，用于切换
@property (nonatomic, strong) UIButton *emailGetVerCodeBtn; // 获取验证码按钮
@property (nonatomic, strong) NSTimer *emailVerCodeTimer; // 验证码倒计时
@property (nonatomic, assign) NSInteger emailVerCodeCountdown; // 倒计时秒数

// 验证码工具
@property (nonatomic, strong) ZCaptchaCodeTools *captchaTools;

// 账号登录相关
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *accountPasswordField;
@property (nonatomic, assign) BOOL accountPasswordShown;

// 共享按钮
@property (nonatomic, strong) UIButton *continueBtn; // 继续/登录按钮
@property (nonatomic, strong) UIButton *registerBtn; // 统一的注册按钮

// 服务协议
@property (nonatomic, strong) ProtocolPolicyView *policyView;

@end

@implementation LoginCusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 隐藏导航栏
    self.navView.hidden = YES;
    
    // 初始化默认区号
    [self setupDefaultCountryCode];
    
    // 加载保存的企业号配置
    [self loadSavedCompanyIdConfig];
    
    // 判断页面模式：未设置企业号则显示加入企业号模式
    if ([NSString isNil:self.presetCompanyId] && [NSString isNil:self.presetIpDomain]) {
        self.pageMode = LoginPageModeJoinServer;
    } else {
        self.pageMode = LoginPageModeLogin;
    }
    
    // 初始化通用UI
    [self setupGradientBackground];
    [self setupLanguageButton];
    
    // 注册通知
    [self setupNotifications];
    
    // 根据模式初始化不同的UI
    if (self.pageMode == LoginPageModeJoinServer) {
        // 加入企业号模式
        [self setupJoinServerUI];
    } else {
        // 登录模式
        [self setupLoginMethod]; // 动态配置登录方式
        [self setupCompanyIdButton];
        [self setupCategoryView];
        [self setupContentViews];
        [self updateCompanyIdButtonDisplay];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 更新渐变层大小
//    _gradientLayer.frame = self.view.bounds;
}

#pragma mark - Setup Notifications

// 注册通知
- (void)setupNotifications {
    // 监听竞速/直连结果
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(netWorkNodeRacingAndIpDomainConectResult:) 
                                                 name:@"AppSsoRacingAndIpDomainConectResultNotification" 
                                               object:nil];
}

#pragma mark - Setup Country Code and Company ID

// 加载保存的企业号配置
- (void)loadSavedCompanyIdConfig {
    NSString *savedCompanyId = [[MMKV defaultMMKV] getStringForKey:@"LoginPresetCompanyId"];
    NSString *savedIpDomain = [[MMKV defaultMMKV] getStringForKey:@"LoginPresetIpDomain"];
    
    if (![NSString isNil:savedCompanyId]) {
        self.presetCompanyId = savedCompanyId;
        NSLog(@"加载保存的企业号: %@", savedCompanyId);
    }
    
    if (![NSString isNil:savedIpDomain]) {
        self.presetIpDomain = savedIpDomain;
        NSLog(@"加载保存的IP/域名: %@", savedIpDomain);
    }
}

// 动态配置登录方式
- (void)setupLoginMethod {
    if (!self.loginTypeArr) {
        self.loginTypeArr = [NSMutableArray array];
    }
    [self.loginTypeArr removeAllObjects];
    
    NSString *loginMethod = ZHostTool.appSysSetModel.loginMethod;
    
    if ([loginMethod isEqualToString:@"1"]) {
        // 账号
        [self.loginTypeArr addObject:@(UserAuthTypeAccount)];
    } else if ([loginMethod isEqualToString:@"2"]) {
        // 邮箱
        [self.loginTypeArr addObject:@(UserAuthTypeEmail)];
    } else if ([loginMethod isEqualToString:@"3"]) {
        // 手机号
        [self.loginTypeArr addObject:@(UserAuthTypePhone)];
    } else if ([loginMethod isEqualToString:@"4"]) {
        // 手机号+邮箱
        [self.loginTypeArr addObjectsFromArray:@[
            @(UserAuthTypePhone),
            @(UserAuthTypeEmail)
        ]];
    } else if ([loginMethod isEqualToString:@"5"]) {
        // 手机号+账号
        [self.loginTypeArr addObjectsFromArray:@[
            @(UserAuthTypePhone),
            @(UserAuthTypeAccount)
        ]];
    } else if ([loginMethod isEqualToString:@"6"]) {
        // 邮箱+账号
        [self.loginTypeArr addObjectsFromArray:@[
            @(UserAuthTypeEmail),
            @(UserAuthTypeAccount)
        ]];
    } else if ([loginMethod isEqualToString:@"7"]) {
        // 手机号+邮箱+账号
        [self.loginTypeArr addObjectsFromArray:@[
            @(UserAuthTypePhone),
            @(UserAuthTypeEmail),
            @(UserAuthTypeAccount)
        ]];
    } else {
        // 默认：账号
        [self.loginTypeArr addObject:@(UserAuthTypeAccount)];
    }
    
    NSLog(@"配置登录方式: %@", self.loginTypeArr);
}

// 保存企业号配置
- (void)saveCompanyIdConfig {
    if (![NSString isNil:self.presetCompanyId]) {
        [[MMKV defaultMMKV] setString:self.presetCompanyId forKey:@"LoginPresetCompanyId"];
        NSLog(@"保存企业号: %@", self.presetCompanyId);
    } else {
        [[MMKV defaultMMKV] removeValueForKey:@"LoginPresetCompanyId"];
    }
    
    if (![NSString isNil:self.presetIpDomain]) {
        [[MMKV defaultMMKV] setString:self.presetIpDomain forKey:@"LoginPresetIpDomain"];
        NSLog(@"保存IP/域名: %@", self.presetIpDomain);
    } else {
        [[MMKV defaultMMKV] removeValueForKey:@"LoginPresetIpDomain"];
    }
}

// 设置默认区号（根据设备地区）
- (void)setupDefaultCountryCode {
    NSString *area_code = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NSString *prefixCode = nil;
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"sysdbdefault" ofType:@"db"];
    FMDatabase *db = [[FMDatabase alloc] initWithPath:dbPath];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"select prefix from SMS_country where country_code_2 = '%@'", area_code];
        FMResultSet *rs = [db executeQuery:sql, area_code];
        if ([rs next]) {
            prefixCode = [rs stringForColumn:@"prefix"];
        }
        [rs close];
        [db close];
    }
    
    if (![NSString isNil:prefixCode]) {
        self.phoneCountryCode = [NSString stringWithFormat:@"+%@", prefixCode];
    } else {
        self.phoneCountryCode = @"+86"; // 默认中国区号
    }
}

#pragma mark - Setup Background

// 设置渐变背景
- (void)setupGradientBackground {
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , DWScale(200));
    _gradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0.40 green:0.82 blue:0.77 alpha:1.0].CGColor, // 青绿色
        (__bridge id)[UIColor colorWithRed:0.50 green:0.86 blue:0.82 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.48 green:0.84 blue:0.92 alpha:1.0].CGColor
    ];
    _gradientLayer.locations = @[@0.0, @0.25, @0.6];
    _gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    _gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    [self.view.layer insertSublayer:_gradientLayer atIndex:0];
}

// 设置多语言和网络按钮
- (void)setupLanguageButton {
    // 箭头图标
    UIImageView *languageArrow = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_sso_language_arrow_reb")];
    [self.view addSubview:languageArrow];
    [languageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DStatusBarH + DWScale(12));
        make.trailing.equalTo(self.view).offset(-DWScale(16));
        make.size.mas_equalTo(CGSizeMake(DWScale(12), DWScale(12)));
    }];
    
    // 语言按钮
    NSString *languageBtnTitle = MultilingualTranslation(@"语言");
    _languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_languageBtn setTitle:languageBtnTitle forState:UIControlStateNormal];
    [_languageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_languageBtn setImage:ImgNamed(@"relogimg_icon_sso_language") forState:UIControlStateNormal];
    _languageBtn.titleLabel.font = FONTR(16);
    [_languageBtn setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:4];
    [_languageBtn addTarget:self action:@selector(languageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_languageBtn];
    
    // 计算语言按钮宽度
    CGRect languageBtnRect = [languageBtnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, DWScale(22)) 
                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading 
                                                          attributes:@{NSFontAttributeName: FONTR(16)} 
                                                             context:nil];
    [_languageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(languageArrow);
        make.trailing.equalTo(languageArrow.mas_leading).offset(-DWScale(5));
        make.size.mas_equalTo(CGSizeMake(languageBtnRect.size.width + DWScale(30), DWScale(22)));
    }];
    
    // 网络按钮
    NSString *networkBtnTitle = MultilingualTranslation(@"网络");
    _networkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_networkBtn setTitle:networkBtnTitle forState:UIControlStateNormal];
    [_networkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_networkBtn setImage:ImgNamed(@"relogimg_icon_sso_net") forState:UIControlStateNormal];
    _networkBtn.titleLabel.font = FONTR(16);
    [_networkBtn setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:4];
    [_networkBtn addTarget:self action:@selector(networkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_networkBtn];
    
    // 计算网络按钮宽度
    CGRect networkBtnRect = [networkBtnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, DWScale(22)) 
                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading 
                                                        attributes:@{NSFontAttributeName: FONTR(16)} 
                                                           context:nil];
    [_networkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(languageArrow);
        make.trailing.equalTo(_languageBtn.mas_leading).offset(-DWScale(6));
        make.size.mas_equalTo(CGSizeMake(networkBtnRect.size.width + DWScale(30), DWScale(22)));
    }];
}

// 设置企业号按钮
- (void)setupCompanyIdButton {
    _companyIdBtn = [[UIButton alloc] init];
    [_companyIdBtn setTitle:MultilingualTranslation(@"设置企业号") forState:UIControlStateNormal];
    [_companyIdBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9] forState:UIControlStateNormal];
    
    // 设置图标并调整大小为20x20
    UIImage *originalImage = ImgNamed(@"gl_qiye");
    UIImage *resizedImage = [self resizeImage:originalImage toSize:CGSizeMake(DWScale(20), DWScale(20))];
    [_companyIdBtn setImage:resizedImage forState:UIControlStateNormal];
    
    _companyIdBtn.titleLabel.font = FONTN(14);
    _companyIdBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    _companyIdBtn.layer.cornerRadius = DWScale(14);
    _companyIdBtn.layer.borderWidth = 0.5;
    _companyIdBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    [_companyIdBtn setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:4];
    _companyIdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, DWScale(12), 0, DWScale(12));
    [_companyIdBtn addTarget:self action:@selector(companyIdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_companyIdBtn];
    
    [_companyIdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.languageBtn); // 与语言按钮水平对齐
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.height.mas_equalTo(DWScale(28));
        make.width.mas_equalTo(DWScale(124));
    }];
}

// 调整图片大小
- (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

// 更新企业号按钮显示
- (void)updateCompanyIdButtonDisplay {
    if (![NSString isNil:self.presetCompanyId]) {
        // 显示企业号
        [_companyIdBtn setTitle:[NSString stringWithFormat:@" %@", self.presetCompanyId] forState:UIControlStateNormal];
    } else if (![NSString isNil:self.presetIpDomain]) {
        // 显示IP/域名
        [_companyIdBtn setTitle:[NSString stringWithFormat:@"IP: %@", self.presetIpDomain] forState:UIControlStateNormal];
    } else {
        // 未设置
        [_companyIdBtn setTitle:MultilingualTranslation(@"设置企业号") forState:UIControlStateNormal];
    }
}

#pragma mark - UI Setup

#pragma mark - Join Server UI

// 设置加入企业号UI
- (void)setupJoinServerUI {
    NSArray *titles = @[MultilingualTranslation(@"企业号"), MultilingualTranslation(@"IP/域名")];
    
    _categoryView = [[LJCategoryTitleView alloc] init];
    _categoryView.backgroundColor = [UIColor clearColor];
    _categoryView.delegate = self;
    _categoryView.titles = titles;
    _categoryView.titleFont = FONTN(15);
    _categoryView.titleSelectedFont = FONTN(15);
    _categoryView.titleColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    _categoryView.titleSelectedColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    
    // 使用平均分布
    _categoryView.averageCellSpacingEnabled = YES;
    _categoryView.cellSpacing = DWScale(10);
    _categoryView.cellWidth = DWScale(126);
    _categoryView.cellWidthIncrement = 0;
    
    // 背景指示器
    NJSelectCategoryIndicatorBackgroundView *backgroundView = [[NJSelectCategoryIndicatorBackgroundView alloc] init];
    backgroundView.indicatorHeight = DWScale(36);
    backgroundView.indicatorWidth = DWScale(126);
    backgroundView.indicatorCornerRadius = DWScale(18);
    backgroundView.indicatorColor = COLORWHITE;
    _categoryView.indicators = @[backgroundView];
    
    // 容器背景
    UIView *categoryContainerView = [[UIView alloc] init];
    categoryContainerView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.15];
    categoryContainerView.layer.cornerRadius = DWScale(20);
    
    [self.view addSubview:categoryContainerView];
    [categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DStatusBarH + DWScale(80));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(DWScale(300));
        make.height.mas_equalTo(DWScale(40));
    }];
    
    [categoryContainerView addSubview:_categoryView];
    [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(categoryContainerView).insets(UIEdgeInsetsMake(DWScale(2), DWScale(2), DWScale(2), DWScale(2)));
    }];
    
    // 加入企业号内容容器
    _joinServerContainerView = [[UIView alloc] init];
    _joinServerContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_joinServerContainerView];
    [_joinServerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(categoryContainerView.mas_bottom).offset(DWScale(40));
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(32));
        make.height.mas_equalTo(DWScale(300));
    }];
    
    // 企业号输入框
    _companyIdInputView = [[MainInputTextView alloc] init];
    _companyIdInputView.placeholderText = MultilingualTranslation(@"请输入企业号");
    _companyIdInputView.inputType = ZMessageInputViewTypeNoCancel;
    _companyIdInputView.tipsImgName = @"img_sso_input_tip_reb";
    _companyIdInputView.isSSO = YES;
    _companyIdInputView.inputKeyBoardType = UIKeyboardTypeASCIICapable;
    [_joinServerContainerView addSubview:_companyIdInputView];
    [_companyIdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_joinServerContainerView).offset(DWScale(20));
        make.leading.trailing.equalTo(_joinServerContainerView);
        make.height.mas_equalTo(DWScale(46));
    }];
    
    // IP/域名输入框
    _ipDomainHostInputView = [[MainInputTextView alloc] init];
    _ipDomainHostInputView.placeholderText = MultilingualTranslation(@"IP/域名");
    _ipDomainHostInputView.inputType = ZMessageInputViewTypeNoCancel;
    _ipDomainHostInputView.tipsImgName = @"img_sso_input_tip_reb";
    _ipDomainHostInputView.inputKeyBoardType = UIKeyboardTypeASCIICapable;
    _ipDomainHostInputView.hidden = YES;
    [_joinServerContainerView addSubview:_ipDomainHostInputView];
    
    // 端口号输入框
    _ipDomainPortInputView = [[MainInputTextView alloc] init];
    _ipDomainPortInputView.placeholderText = MultilingualTranslation(@"端口号");
    _ipDomainPortInputView.inputKeyBoardType = UIKeyboardTypeNumberPad;
    _ipDomainPortInputView.inputType = ZMessageInputViewTypeNoCancel;
    _ipDomainPortInputView.tipsImgName = @"";
    _ipDomainPortInputView.hidden = YES;
    [_joinServerContainerView addSubview:_ipDomainPortInputView];
    [_ipDomainPortInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_joinServerContainerView);
        make.trailing.equalTo(_joinServerContainerView);
        make.width.mas_equalTo(DWScale(95));
        make.height.mas_equalTo(DWScale(46));
    }];
    
    // 冒号标签
    _colonLbl = [[UILabel alloc] init];
    _colonLbl.text = @":";
    _colonLbl.textColor = COLOR_00;
    _colonLbl.font = FONTN(16);
    _colonLbl.textAlignment = NSTextAlignmentCenter;
    _colonLbl.hidden = YES;
    [_joinServerContainerView addSubview:_colonLbl];
    [_colonLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ipDomainPortInputView);
        make.trailing.equalTo(_ipDomainPortInputView.mas_leading);
        make.width.mas_equalTo(DWScale(16));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    [_ipDomainHostInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_joinServerContainerView);
        make.leading.equalTo(_joinServerContainerView);
        make.trailing.equalTo(_colonLbl.mas_leading);
        make.height.mas_equalTo(DWScale(46));
    }];
    
    // 扫一扫按钮
    _scanServerButton = [[UIButton alloc] init];
    [_scanServerButton setTitle:MultilingualTranslation(@"扫一扫加入服务器") forState:UIControlStateNormal];
    [_scanServerButton setImage:ImgNamed(@"relogimg_icon_sso_scan_reb") forState:UIControlStateNormal];
    [_scanServerButton setTitleColor:COLOR_81D8CF forState:UIControlStateNormal];
    _scanServerButton.titleLabel.font = FONTN(14);
    [_scanServerButton setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:DWScale(10)];
    [_scanServerButton addTarget:self action:@selector(scanServerAction) forControlEvents:UIControlEventTouchUpInside];
    [_joinServerContainerView addSubview:_scanServerButton];
    [_scanServerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_companyIdInputView.mas_bottom).offset(DWScale(16));
        make.centerX.equalTo(_joinServerContainerView);
        make.height.mas_equalTo(DWScale(32));
    }];
    
    // 确定按钮
    _confirmServerButton = [[UIButton alloc] init];
    [_confirmServerButton setTitle:MultilingualTranslation(@"确定") forState:UIControlStateNormal];
    [_confirmServerButton setTitleColor:COLORWHITE forState:UIControlStateNormal];
    _confirmServerButton.titleLabel.font = FONTB(17);
    _confirmServerButton.backgroundColor = [COLOR_81D8CF colorWithAlphaComponent:0.3];
    _confirmServerButton.layer.cornerRadius = DWScale(12);
    _confirmServerButton.enabled = NO;
    [_confirmServerButton addTarget:self action:@selector(confirmServerAction) forControlEvents:UIControlEventTouchUpInside];
    [_confirmServerButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_confirmServerButton addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_joinServerContainerView addSubview:_confirmServerButton];
    [_confirmServerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scanServerButton.mas_bottom).offset(DWScale(24));
        make.leading.trailing.equalTo(_joinServerContainerView);
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 默认选中企业号
    _serverConfigType = ServerConfigTypeCompanyId;
    _companyIdInputView.hidden = NO;
    _ipDomainHostInputView.hidden = YES;
    _ipDomainPortInputView.hidden = YES;
    _colonLbl.hidden = YES;
    
    // 监听输入框变化
    WeakSelf
    [_companyIdInputView setTextFieldEndInput:^{
        [weakSelf checkConfirmButtonAvailable];
    }];
    [_ipDomainHostInputView setTextFieldEndInput:^{
        [weakSelf checkConfirmButtonAvailable];
    }];
}

#pragma mark - Login UI

// 设置切换视图
- (void)setupCategoryView {
    // 根据动态登录方式数组构建 titles
    NSMutableArray *titles = [NSMutableArray array];
    for (NSNumber *typeNum in self.loginTypeArr) {
        int type = [typeNum intValue];
        if (type == UserAuthTypePhone) {
            [titles addObject:MultilingualTranslation(@"手机号")];
        } else if (type == UserAuthTypeEmail) {
            [titles addObject:MultilingualTranslation(@"邮箱")];
        } else if (type == UserAuthTypeAccount) {
            [titles addObject:MultilingualTranslation(@"账号")];
        }
    }
    
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
    
    // 根据登录方式数量动态计算容器宽度
    // 公式：宽度 = (cellWidth × count) + (cellSpacing × (count - 1)) + 左右内边距(4)
    NSInteger loginTypeCount = self.loginTypeArr.count;

    CGFloat containerWidth = 0;

    switch (loginTypeCount) {
        case 1:
            containerWidth = DWScale(120);
            break;
        case 2:
            containerWidth = DWScale(200);
            break;
        case 3:
            containerWidth = DWScale(300);
            break;
    }
    
    [self.view addSubview:categoryContainerView];
    [categoryContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DStatusBarH + DWScale(80));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(containerWidth);
        make.height.mas_equalTo(DWScale(40));
    }];
    
    [categoryContainerView addSubview:_categoryView];
    [_categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(categoryContainerView).insets(UIEdgeInsetsMake(DWScale(2), DWScale(2), DWScale(2), DWScale(2)));
    }];
}

// 设置内容视图
- (void)setupContentViews {
    // 创建滚动容器
    CGFloat scrollViewTop = DStatusBarH + DWScale(80) + DWScale(44) + DWScale(30); // 状态栏 + 上边距 + 切换视图高度 + 间距
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewTop, DScreenWidth, DScreenHeight - scrollViewTop)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    // 根据登录方式数量动态设置 contentSize
    _scrollView.contentSize = CGSizeMake(DScreenWidth * self.loginTypeArr.count, 0);
    _scrollView.bounces = NO;
    _scrollView.delegate = (id<UIScrollViewDelegate>)self;
    [self.view addSubview:_scrollView];
    
    // 关联切换视图和滚动视图
    _categoryView.contentScrollView = _scrollView;
    
    _currentSelectedIndex = 0;
    
    // 根据 loginTypeArr 动态创建登录类型视图
    for (NSInteger i = 0; i < self.loginTypeArr.count; i++) {
        int authType = [self.loginTypeArr[i] intValue];
        CGFloat xOffset = DScreenWidth * i;
        
        if (authType == UserAuthTypePhone) {
            // 手机号登录
            _phoneView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0, DScreenWidth, _scrollView.height)];
            _phoneView.backgroundColor = [UIColor whiteColor];
            [self setupPhoneLoginUI:_phoneView];
            [_scrollView addSubview:_phoneView];
        } else if (authType == UserAuthTypeEmail) {
            // 邮箱登录
            _emailView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0, DScreenWidth, _scrollView.height)];
            _emailView.backgroundColor = [UIColor whiteColor];
            [self setupEmailLoginUI:_emailView];
            [_scrollView addSubview:_emailView];
        } else if (authType == UserAuthTypeAccount) {
            // 账号登录
            _accountView = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 0, DScreenWidth, _scrollView.height)];
            _accountView.backgroundColor = [UIColor whiteColor];
            [self setupAccountLoginUI:_accountView];
            [_scrollView addSubview:_accountView];
        }
    }
    
    // 创建统一的继续按钮
    [self setupContinueButton];
    
    // 创建统一的注册按钮
    [self setupRegisterButton];
    
    // 创建服务协议视图
    [self setupPolicyView];
}

// 创建统一的继续按钮
- (void)setupContinueButton {
    _continueBtn = [[UIButton alloc] init];
    [_continueBtn setTitle:MultilingualTranslation(@"继续") forState:UIControlStateNormal];
    [_continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _continueBtn.titleLabel.font = FONTB(17);
    _continueBtn.backgroundColor = COLOR_81D8CF;
    _continueBtn.layer.cornerRadius = DWScale(12);
    _continueBtn.layer.shadowColor = [[UIColor colorWithRed:0.40 green:0.82 blue:0.77 alpha:0.4] CGColor];
    _continueBtn.layer.shadowOffset = CGSizeMake(0, 4);
    _continueBtn.layer.shadowOpacity = 0.3;
    _continueBtn.layer.shadowRadius = 8;
    _continueBtn.layer.masksToBounds = NO;
    [_continueBtn addTarget:self action:@selector(continueAction) forControlEvents:UIControlEventTouchUpInside];
    [_continueBtn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_continueBtn addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:_continueBtn];
    
    // 初始位置：紧贴第一个输入框下方（只有一个输入框的状态）
    CGFloat btnTop = DStatusBarH + DWScale(80) + DWScale(44) + DWScale(30) + DWScale(20) + DWScale(56) + DWScale(30);
    [_continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(24));
        make.top.equalTo(self.view).offset(btnTop);
        make.height.mas_equalTo(DWScale(56));
    }];
}

// 创建统一的注册按钮
- (void)setupRegisterButton {
    _registerBtn = [[UIButton alloc] init];
    [_registerBtn setTitle:MultilingualTranslation(@"注册账号") forState:UIControlStateNormal];
    [_registerBtn setTitleColor:COLOR_81D8CF forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = FONTB(17);
    _registerBtn.backgroundColor = [UIColor clearColor];
    _registerBtn.layer.cornerRadius = DWScale(12);
    _registerBtn.layer.borderWidth = 1.5;
    _registerBtn.layer.borderColor = COLOR_81D8CF.CGColor;
    [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [_registerBtn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_registerBtn addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:_registerBtn];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(24));
        make.bottom.equalTo(self.view).offset(-DWScale(80)); // 固定在底部
        make.height.mas_equalTo(DWScale(56));
    }];
}

// 创建服务协议视图
- (void)setupPolicyView {
    _policyView = [[ProtocolPolicyView alloc] init];
    [self.view addSubview:_policyView];
    [_policyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_continueBtn.mas_bottom).offset(DWScale(10));
        make.leading.equalTo(self.view).offset(DWScale(25));
        make.trailing.equalTo(self.view).offset(-DWScale(25));
    }];
}

#pragma mark - Setup Login UI

// 手机号登录UI
- (void)setupPhoneLoginUI:(UIView *)containerView {
    // 手机号输入框容器（带阴影）
    UIView *phoneInputContainer = [[UIView alloc] init];
    phoneInputContainer.backgroundColor = COLOR_F5F6F9; 
    phoneInputContainer.layer.cornerRadius = DWScale(12);
//    phoneInputContainer.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.48].CGColor;
//    phoneInputContainer.layer.shadowOffset = CGSizeMake(0, 2);
//    phoneInputContainer.layer.shadowOpacity = 0.15;
//    phoneInputContainer.layer.shadowRadius = 8;
    phoneInputContainer.layer.masksToBounds = NO;
    [containerView addSubview:phoneInputContainer];
    [phoneInputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(containerView).offset(DWScale(32));
        
        make.trailing.equalTo(containerView).offset(-DWScale(24));
        make.top.equalTo(containerView).offset(DWScale(20));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 手机号图标
//    UIImageView *phoneIcon = [[UIImageView alloc] init];
//    phoneIcon.image = ImgNamed(@"cim_login_phone");
//    phoneIcon.contentMode = UIViewContentModeScaleAspectFit;
//    phoneIcon.tintColor = COLOR_81D8CF;
//    [phoneInputContainer addSubview:phoneIcon];
//    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(phoneInputContainer).offset(DWScale(16));
//        make.centerY.equalTo(phoneInputContainer);
//        make.size.mas_equalTo(CGSizeMake(DWScale(22), DWScale(22)));
//    }];
//    
    // 区号按钮
    _phoneAreaCodeBtn = [[UIButton alloc] init];
    [_phoneAreaCodeBtn setTitle:self.phoneCountryCode forState:UIControlStateNormal];
    [_phoneAreaCodeBtn setTitleColor:COLOR_81D8CF forState:UIControlStateNormal];
    _phoneAreaCodeBtn.titleLabel.font = FONTN(16);
    [_phoneAreaCodeBtn addTarget:self action:@selector(selectPhoneCountryCode) forControlEvents:UIControlEventTouchUpInside];
    [phoneInputContainer addSubview:_phoneAreaCodeBtn];
    [_phoneAreaCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneInputContainer);
        make.leading.equalTo(phoneInputContainer).offset(DWScale(6));
        make.width.mas_equalTo(DWScale(50));
        make.height.mas_equalTo(DWScale(28));
    }];
    
    // 分割线
    _phoneLineView = [[UIView alloc] init];
    _phoneLineView.backgroundColor = COLOR_DFDFDF;
    [phoneInputContainer addSubview:_phoneLineView];
    [_phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(phoneInputContainer);
        make.leading.equalTo(_phoneAreaCodeBtn.mas_trailing).offset(DWScale(6));
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(DWScale(20));
    }];
    
    // 手机号输入框
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.placeholder = MultilingualTranslation(@"请输入手机号");
    _phoneTextField.font = FONTN(16);
    _phoneTextField.textColor = COLOR_33;
    _phoneTextField.backgroundColor = COLOR_F5F6F9;
    _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    [phoneInputContainer addSubview:_phoneTextField];
    [_phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_phoneLineView.mas_trailing).offset(DWScale(10));
        make.trailing.equalTo(phoneInputContainer).offset(-DWScale(16));
        make.centerY.equalTo(phoneInputContainer);
        make.height.mas_equalTo(DWScale(56));
    }];
}

// 邮箱登录UI
- (void)setupEmailLoginUI:(UIView *)containerView {
    // 邮箱输入框容器（带阴影）
    UIView *emailInputContainer = [[UIView alloc] init];
    emailInputContainer.backgroundColor = COLOR_F5F6F9; 
    emailInputContainer.layer.cornerRadius = DWScale(12);
//    emailInputContainer.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.48].CGColor;
//    emailInputContainer.layer.shadowOffset = CGSizeMake(0, 2);
//    emailInputContainer.layer.shadowOpacity = 0.15;
//    emailInputContainer.layer.shadowRadius = 8;
    emailInputContainer.layer.masksToBounds = NO;
    [containerView addSubview:emailInputContainer];
    [emailInputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(containerView).offset(DWScale(32));
        make.trailing.equalTo(containerView).offset(-DWScale(24));
        make.top.equalTo(containerView).offset(DWScale(20));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 邮箱图标
    UIImageView *emailIcon = [[UIImageView alloc] init];
    emailIcon.image = ImgNamed(@"relogimg_img_email_input_tip_reb");
    emailIcon.contentMode = UIViewContentModeScaleAspectFit;
    emailIcon.tintColor = COLOR_81D8CF;
    [emailInputContainer addSubview:emailIcon];
    [emailIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailInputContainer).offset(DWScale(16));
        make.centerY.equalTo(emailInputContainer);
        make.size.mas_equalTo(CGSizeMake(DWScale(22), DWScale(22)));
    }];
    
    // 邮箱输入框
    _emailTextField = [[UITextField alloc] init];
    _emailTextField.placeholder = MultilingualTranslation(@"请输入邮箱");
    _emailTextField.font = FONTN(16);
    _emailTextField.textColor = COLOR_33;
    _emailTextField.backgroundColor = COLOR_F5F6F9;
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailInputContainer addSubview:_emailTextField];
    [_emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(emailIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(emailInputContainer).offset(-DWScale(16));
        make.centerY.equalTo(emailInputContainer);
        make.height.mas_equalTo(DWScale(56));
    }];
}

// 账号登录UI
- (void)setupAccountLoginUI:(UIView *)containerView {
    // 账号输入框容器（带阴影）
    UIView *accountInputContainer = [[UIView alloc] init];
    accountInputContainer.backgroundColor = COLOR_F5F6F9; 
    accountInputContainer.layer.cornerRadius = DWScale(12);
//    accountInputContainer.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.48].CGColor;
//    accountInputContainer.layer.shadowOffset = CGSizeMake(0, 2);
//    accountInputContainer.layer.shadowOpacity = 0.15;
//    accountInputContainer.layer.shadowRadius = 8;
    accountInputContainer.layer.masksToBounds = NO;
    [containerView addSubview:accountInputContainer];
    [accountInputContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(containerView).offset(DWScale(32));
        make.trailing.equalTo(containerView).offset(-DWScale(24));
        make.top.equalTo(containerView).offset(DWScale(20));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 账号图标
    UIImageView *accountIcon = [[UIImageView alloc] init];
    accountIcon.image = ImgNamed(@"relogimg_img_account_input_tip_reb");
    accountIcon.contentMode = UIViewContentModeScaleAspectFit;
    accountIcon.tintColor = COLOR_81D8CF;
    [accountInputContainer addSubview:accountIcon];
    [accountIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(accountInputContainer).offset(DWScale(16));
        make.centerY.equalTo(accountInputContainer);
        make.size.mas_equalTo(CGSizeMake(DWScale(22), DWScale(22)));
    }];
    
    // 账号输入框
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.placeholder = MultilingualTranslation(@"请输入账号");
    _accountTextField.font = FONTN(16);
    _accountTextField.textColor = COLOR_33;
    _accountTextField.backgroundColor = COLOR_F5F6F9;
    [accountInputContainer addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(accountIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(accountInputContainer).offset(-DWScale(16));
        make.centerY.equalTo(accountInputContainer);
        make.height.mas_equalTo(DWScale(56));
    }];
}

#pragma mark - Button Animation

// 按钮按下效果
- (void)buttonTouchDown:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.96, 0.96);
        button.alpha = 0.8;
    }];
}

// 按钮松开效果
- (void)buttonTouchUp:(UIButton *)button {
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        button.transform = CGAffineTransformIdentity;
        button.alpha = 1.0;
    } completion:nil];
}

#pragma mark - Button Actions

// 统一的继续按钮点击
- (void)continueAction {
    // 根据按钮文字判断当前状态：继续 or 登录
    NSString *buttonTitle = _continueBtn.currentTitle;
    
    if ([buttonTitle isEqualToString:MultilingualTranslation(@"继续")]) {
        // 状态1：显示密码输入框
        [self showPasswordInputForCurrentTab];
    } else {
        // 状态2：执行登录逻辑
        [self performLoginForCurrentTab];
    }
}

// 显示密码输入框（根据当前tab）
- (void)showPasswordInputForCurrentTab {
    if (_currentSelectedIndex >= 0 && _currentSelectedIndex < self.loginTypeArr.count) {
        int authType = [self.loginTypeArr[_currentSelectedIndex] intValue];
        if (authType == UserAuthTypePhone) {
            [self showPhonePasswordInput];
        } else if (authType == UserAuthTypeEmail) {
            [self showEmailPasswordInput];
        } else if (authType == UserAuthTypeAccount) {
            [self showAccountPasswordInput];
        }
    }
}

// 执行登录逻辑（根据当前tab）
- (void)performLoginForCurrentTab {
    // 先验证输入
    if (_currentSelectedIndex >= 0 && _currentSelectedIndex < self.loginTypeArr.count) {
        int authType = [self.loginTypeArr[_currentSelectedIndex] intValue];
        
        if (authType == UserAuthTypePhone) {
            if (_phoneTextField.text.length == 0) {
                [HUD showMessage:MultilingualTranslation(@"请输入手机号")];
                return;
            }
            if (_phonePasswordField.text.length == 0) {
                if (_phoneInputType == 0) {
                    [HUD showMessage:MultilingualTranslation(@"请输入密码")];
                } else {
                    [HUD showMessage:MultilingualTranslation(@"请输入验证码")];
                }
                return;
            }
        } else if (authType == UserAuthTypeEmail) {
            if (_emailTextField.text.length == 0) {
                [HUD showMessage:MultilingualTranslation(@"请输入邮箱")];
                return;
            }
            if (_emailPasswordField.text.length == 0) {
                if (_emailInputType == 0) {
                    [HUD showMessage:MultilingualTranslation(@"请输入密码")];
                } else {
                    [HUD showMessage:MultilingualTranslation(@"请输入验证码")];
                }
                return;
            }
        } else if (authType == UserAuthTypeAccount) {
            if (_accountTextField.text.length == 0) {
                [HUD showMessage:MultilingualTranslation(@"请输入账号")];
                return;
            }
            if (_accountPasswordField.text.length == 0) {
                [HUD showMessage:MultilingualTranslation(@"请输入密码")];
                return;
            }
        }
    }
    
    // 检查是否勾选服务协议
    if (!self.policyView.checkBoxBtn.selected) {
        [HUD showMessage:MultilingualTranslation(@"请先阅读并同意服务协议和隐私政策")];
        return;
    }
    
    // 判断是否已经预设了企业号
    if (![NSString isNil:self.presetCompanyId] || ![NSString isNil:self.presetIpDomain]) {
        // 已预设，直接登录
        NSLog(@"使用预设的企业号登录");
        [self loginActionWithCompanyId:self.presetCompanyId ipDomain:self.presetIpDomain];
    } else {
        // 未预设，弹出配置弹窗
        [self showServerConfigView];
    }
}

// 显示手机号密码输入框
- (void)showPhonePasswordInput {
    // 如果已经显示过了，直接返回
    if (_phonePasswordShown) {
        return;
    }
    
    // 验证手机号输入
    if (_phoneTextField.text.length == 0) {
        [HUD showMessage:@"请先输入手机号"];
        return;
    }
    
    // 初始化输入类型为密码登录
    _phoneInputType = 0;
    
    // 创建密码输入框容器
    _phonePasswordContainer = [[UIView alloc] init];
    _phonePasswordContainer.backgroundColor = COLOR_F5F6F9;
    _phonePasswordContainer.layer.cornerRadius = DWScale(12);
    _phonePasswordContainer.layer.masksToBounds = NO;
    [_phoneView addSubview:_phonePasswordContainer];
    
    // 密码图标
    UIImageView *lockIcon = [[UIImageView alloc] init];
    lockIcon.image = ImgNamed(@"relogimg_img_password_input_tip_reb");
    lockIcon.contentMode = UIViewContentModeScaleAspectFit;
    lockIcon.tintColor = COLOR_81D8CF;
    lockIcon.tag = 1001; // 设置tag以便后续切换图标
    [_phonePasswordContainer addSubview:lockIcon];
    [lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_phonePasswordContainer).offset(DWScale(16));
        make.centerY.equalTo(_phonePasswordContainer);
        make.size.mas_equalTo(CGSizeMake(DWScale(22), DWScale(22)));
    }];
    
    // 创建获取验证码按钮（初始隐藏）
    _phoneGetVerCodeBtn = [[UIButton alloc] init];
    [_phoneGetVerCodeBtn setTitle:MultilingualTranslation(@"获取验证码") forState:UIControlStateNormal];
    [_phoneGetVerCodeBtn setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
    [_phoneGetVerCodeBtn setTitleColor:COLOR_99 forState:UIControlStateDisabled];
    _phoneGetVerCodeBtn.titleLabel.font = FONTN(14);
    [_phoneGetVerCodeBtn addTarget:self action:@selector(phoneGetVerCodeAction) forControlEvents:UIControlEventTouchUpInside];
    _phoneGetVerCodeBtn.hidden = YES;
    _phoneGetVerCodeBtn.tag = 1002; // 设置tag用于查找
    [_phonePasswordContainer addSubview:_phoneGetVerCodeBtn];
    [_phoneGetVerCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_phonePasswordContainer).offset(-DWScale(12));
        make.centerY.equalTo(_phonePasswordContainer);
        make.width.mas_equalTo(DWScale(90));
        make.height.mas_equalTo(DWScale(36));
    }];
    
    // 创建密码输入框
    _phonePasswordField = [[UITextField alloc] init];
    _phonePasswordField.placeholder = MultilingualTranslation(@"请输入密码");
    _phonePasswordField.font = FONTN(16);
    _phonePasswordField.textColor = COLOR_33;
    _phonePasswordField.backgroundColor = COLOR_F5F6F9;
    _phonePasswordField.secureTextEntry = YES;
    [_phonePasswordContainer addSubview:_phonePasswordField];
    [_phonePasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(_phonePasswordContainer).offset(-DWScale(16));
        make.centerY.equalTo(_phonePasswordContainer);
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 设置容器约束
    [_phonePasswordContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_phoneView).offset(DWScale(32));
        make.trailing.equalTo(_phoneView).offset(-DWScale(24));
        make.top.equalTo(_phoneView).offset(DWScale(20) + DWScale(56) + DWScale(16));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 创建切换按钮（在密码输入框左下方）
    _phoneSwitchBtn = [[UIButton alloc] init];
    [_phoneSwitchBtn setTitle:MultilingualTranslation(@"验证码登录") forState:UIControlStateNormal];
    [_phoneSwitchBtn setTitle:MultilingualTranslation(@"密码登录") forState:UIControlStateSelected];
    [_phoneSwitchBtn setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
    _phoneSwitchBtn.titleLabel.font = FONTN(14);
    [_phoneSwitchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_phoneSwitchBtn addTarget:self action:@selector(phoneSwitchLoginTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    _phoneSwitchBtn.selected = NO;
    [_phoneView addSubview:_phoneSwitchBtn];
    [_phoneSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_phonePasswordContainer);
        make.top.equalTo(_phonePasswordContainer.mas_bottom).offset(DWScale(10));
        make.width.mas_equalTo(DWScale(150));
        make.height.mas_equalTo(DWScale(20));
    }];
    
    // 更新继续按钮约束
    [_continueBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(24));
        make.top.equalTo(self.view).offset(DStatusBarH + DWScale(80) + DWScale(44) + DWScale(30) + DWScale(20) + DWScale(56) + DWScale(16) + DWScale(56) + DWScale(10) + DWScale(20) + DWScale(20));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 动画显示密码框
    [UIView animateWithDuration:0.3 animations:^{
        [self.phoneView layoutIfNeeded];
        [self.view layoutIfNeeded];
        _phonePasswordContainer.alpha = 1;
    } completion:^(BOOL finished) {
        [self.phonePasswordField becomeFirstResponder];
    }];
    
    // 修改按钮文字
    [_continueBtn setTitle:@"登录" forState:UIControlStateNormal];
    _phonePasswordShown = YES;
}

// 显示邮箱密码输入框
- (void)showEmailPasswordInput {
    // 如果已经显示过了，直接返回
    if (_emailPasswordShown) {
        return;
    }
    
    // 验证邮箱输入
    if (_emailTextField.text.length == 0) {
        [HUD showMessage:@"请先输入邮箱"];
        return;
    }
    
    // 初始化输入类型为密码登录
    _emailInputType = 0;
    
    // 创建密码输入框容器
    _emailPasswordContainer = [[UIView alloc] init];
    _emailPasswordContainer.backgroundColor = COLOR_F5F6F9;
    _emailPasswordContainer.layer.cornerRadius = DWScale(12);
    _emailPasswordContainer.layer.masksToBounds = NO;
    [_emailView addSubview:_emailPasswordContainer];
    
    // 密码图标
    UIImageView *lockIcon = [[UIImageView alloc] init];
    lockIcon.image = ImgNamed(@"relogimg_img_password_input_tip_reb");
    lockIcon.contentMode = UIViewContentModeScaleAspectFit;
    lockIcon.tintColor = COLOR_81D8CF;
    lockIcon.tag = 1001; // 设置tag以便后续切换图标
    [_emailPasswordContainer addSubview:lockIcon];
    [lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_emailPasswordContainer).offset(DWScale(16));
        make.centerY.equalTo(_emailPasswordContainer);
        make.size.mas_equalTo(CGSizeMake(DWScale(22), DWScale(22)));
    }];
    
    // 创建获取验证码按钮（初始隐藏）
    _emailGetVerCodeBtn = [[UIButton alloc] init];
    [_emailGetVerCodeBtn setTitle:MultilingualTranslation(@"获取验证码") forState:UIControlStateNormal];
    [_emailGetVerCodeBtn setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
    [_emailGetVerCodeBtn setTitleColor:COLOR_99 forState:UIControlStateDisabled];
    _emailGetVerCodeBtn.titleLabel.font = FONTN(14);
    [_emailGetVerCodeBtn addTarget:self action:@selector(emailGetVerCodeAction) forControlEvents:UIControlEventTouchUpInside];
    _emailGetVerCodeBtn.hidden = YES;
    _emailGetVerCodeBtn.tag = 1002; // 设置tag用于查找
    [_emailPasswordContainer addSubview:_emailGetVerCodeBtn];
    [_emailGetVerCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_emailPasswordContainer).offset(-DWScale(12));
        make.centerY.equalTo(_emailPasswordContainer);
        make.width.mas_equalTo(DWScale(90));
        make.height.mas_equalTo(DWScale(36));
    }];
    
    // 创建密码输入框
    _emailPasswordField = [[UITextField alloc] init];
    _emailPasswordField.placeholder = MultilingualTranslation(@"请输入密码");
    _emailPasswordField.font = FONTN(16);
    _emailPasswordField.textColor = COLOR_33;
    _emailPasswordField.backgroundColor = COLOR_F5F6F9;
    _emailPasswordField.secureTextEntry = YES;
    [_emailPasswordContainer addSubview:_emailPasswordField];
    [_emailPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(_emailPasswordContainer).offset(-DWScale(16));
        make.centerY.equalTo(_emailPasswordContainer);
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 设置容器约束
    [_emailPasswordContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_emailView).offset(DWScale(32));
        make.trailing.equalTo(_emailView).offset(-DWScale(24));
        make.top.equalTo(_emailView).offset(DWScale(20) + DWScale(56) + DWScale(16));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 创建切换按钮（在密码输入框左下方）
    _emailSwitchBtn = [[UIButton alloc] init];
    [_emailSwitchBtn setTitle:MultilingualTranslation(@"验证码登录") forState:UIControlStateNormal];
    [_emailSwitchBtn setTitle:MultilingualTranslation(@"密码登录") forState:UIControlStateSelected];
    [_emailSwitchBtn setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
    _emailSwitchBtn.titleLabel.font = FONTN(14);
    [_emailSwitchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_emailSwitchBtn addTarget:self action:@selector(emailSwitchLoginTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    _emailSwitchBtn.selected = NO;
    [_emailView addSubview:_emailSwitchBtn];
    [_emailSwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_emailPasswordContainer);
        make.top.equalTo(_emailPasswordContainer.mas_bottom).offset(DWScale(10));
        make.width.mas_equalTo(DWScale(150));
        make.height.mas_equalTo(DWScale(20));
    }];
    
    // 更新继续按钮约束
    [_continueBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(24));
        make.top.equalTo(self.view).offset(DStatusBarH + DWScale(80) + DWScale(44) + DWScale(30) + DWScale(20) + DWScale(56) + DWScale(16) + DWScale(56) + DWScale(10) + DWScale(20) + DWScale(20));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 动画显示密码框
    [UIView animateWithDuration:0.3 animations:^{
        [self.emailView layoutIfNeeded];
        [self.view layoutIfNeeded];
        _emailPasswordContainer.alpha = 1;
    } completion:^(BOOL finished) {
        [self.emailPasswordField becomeFirstResponder];
    }];
    
    [_continueBtn setTitle:MultilingualTranslation(@"登录") forState:UIControlStateNormal];
    _emailPasswordShown = YES;
}

// 手机号登录方式切换
- (void)phoneSwitchLoginTypeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _phonePasswordField.text = @"";
    
    // 获取图标视图和按钮
    UIImageView *lockIcon = (UIImageView *)[_phonePasswordContainer viewWithTag:1001];
    
    if (sender.selected) {
        // 切换到验证码登录
        _phoneInputType = 1;
        _phonePasswordField.placeholder = MultilingualTranslation(@"请输入验证码");
        _phonePasswordField.secureTextEntry = NO;
        _phonePasswordField.keyboardType = UIKeyboardTypeNumberPad;
        lockIcon.image = ImgNamed(@"img_vercode_input_tip_reb");
        
        // 显示获取验证码按钮，调整输入框约束
        _phoneGetVerCodeBtn.hidden = NO;
        [_phonePasswordField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
            make.trailing.equalTo(_phoneGetVerCodeBtn.mas_leading).offset(-DWScale(8));
            make.centerY.equalTo(_phonePasswordContainer);
            make.height.mas_equalTo(DWScale(56));
        }];
    } else {
        // 切换到密码登录
        _phoneInputType = 0;
        _phonePasswordField.placeholder = MultilingualTranslation(@"请输入密码");
        _phonePasswordField.secureTextEntry = YES;
        _phonePasswordField.keyboardType = UIKeyboardTypeASCIICapable;
        lockIcon.image = ImgNamed(@"relogimg_img_password_input_tip_reb");
        
        // 隐藏获取验证码按钮，恢复输入框约束
        _phoneGetVerCodeBtn.hidden = YES;
        [_phonePasswordField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
            make.trailing.equalTo(_phonePasswordContainer).offset(-DWScale(16));
            make.centerY.equalTo(_phonePasswordContainer);
            make.height.mas_equalTo(DWScale(56));
        }];
    }
}

// 邮箱登录方式切换
- (void)emailSwitchLoginTypeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _emailPasswordField.text = @"";
    
    // 获取图标视图
    UIImageView *lockIcon = (UIImageView *)[_emailPasswordContainer viewWithTag:1001];
    
    if (sender.selected) {
        // 切换到验证码登录
        _emailInputType = 1;
        _emailPasswordField.placeholder = MultilingualTranslation(@"请输入验证码");
        _emailPasswordField.secureTextEntry = NO;
        _emailPasswordField.keyboardType = UIKeyboardTypeNumberPad;
        lockIcon.image = ImgNamed(@"img_vercode_input_tip_reb");
        
        // 显示获取验证码按钮，调整输入框约束
        _emailGetVerCodeBtn.hidden = NO;
        [_emailPasswordField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
            make.trailing.equalTo(_emailGetVerCodeBtn.mas_leading).offset(-DWScale(8));
            make.centerY.equalTo(_emailPasswordContainer);
            make.height.mas_equalTo(DWScale(56));
        }];
    } else {
        // 切换到密码登录
        _emailInputType = 0;
        _emailPasswordField.placeholder = MultilingualTranslation(@"请输入密码");
        _emailPasswordField.secureTextEntry = YES;
        _emailPasswordField.keyboardType = UIKeyboardTypeASCIICapable;
        lockIcon.image = ImgNamed(@"relogimg_img_password_input_tip_reb");
        
        // 隐藏获取验证码按钮，恢复输入框约束
        _emailGetVerCodeBtn.hidden = YES;
        [_emailPasswordField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
            make.trailing.equalTo(_emailPasswordContainer).offset(-DWScale(16));
            make.centerY.equalTo(_emailPasswordContainer);
            make.height.mas_equalTo(DWScale(56));
        }];
    }
}

#pragma mark - 获取验证码

// 手机号获取验证码
- (void)phoneGetVerCodeAction {
    // 验证手机号
    if (_phoneTextField.text.length == 0) {
        [HUD showMessage:MultilingualTranslation(@"请先输入手机号")];
        return;
    }
    
    [IMSDKManager configSDKCaptchaChannel:ZHostTool.appSysSetModel.captchaChannel];
    
    if (ZHostTool.appSysSetModel.captchaChannel == 1) {
        // 无验证码，直接获取
        [self requestPhoneGetVercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:@""];
    } else if (ZHostTool.appSysSetModel.captchaChannel == 2) {
        // 图形验证码
        ZImgVerCodeView *vercodeView = [[ZImgVerCodeView alloc] init];
        vercodeView.loginName = _phoneTextField.text;
        vercodeView.verCodeType = 2;
        vercodeView.imgCodeStr = @"";
        [vercodeView show];
        @weakify(self)
        [vercodeView setSureBtnBlock:^(NSString * _Nonnull imgCode) {
            @strongify(self)
            [self requestPhoneGetVercode:imgCode ticket:@"" randstr:@"" captchaVerifyParam:@""];
        }];
    } else if (ZHostTool.appSysSetModel.captchaChannel == 3) {
        // 腾讯云无痕验证
        [self.captchaTools verCaptchaCode];
        @weakify(self)
        [self.captchaTools setTencentCaptchaResultSuccess:^(NSString * _Nonnull ticket, NSString * _Nonnull randstr) {
            @strongify(self)
            [self requestPhoneGetVercode:@"" ticket:ticket randstr:randstr captchaVerifyParam:@""];
        }];
        [self.captchaTools setCaptchaResultFail:^{
            @strongify(self)
            [IMSDKManager configSDKCaptchaChannel:2];
            ZImgVerCodeView *vercodeView = [[ZImgVerCodeView alloc] init];
            vercodeView.loginName = self->_phoneTextField.text;
            vercodeView.verCodeType = 2;
            vercodeView.imgCodeStr = @"";
            [vercodeView show];
            [vercodeView setSureBtnBlock:^(NSString * _Nonnull imgCode) {
                @strongify(self)
                [self requestPhoneGetVercode:imgCode ticket:@"" randstr:@"" captchaVerifyParam:@""];
            }];
        }];
    } else if (ZHostTool.appSysSetModel.captchaChannel == 4) {
        // 阿里云无痕验证
        [self.captchaTools verCaptchaCode];
        @weakify(self)
        [self.captchaTools setAliyunCaptchaResultSuccess:^(NSString * _Nonnull captchaVerifyParam) {
            @strongify(self)
            [self requestPhoneGetVercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:captchaVerifyParam];
        }];
        [self.captchaTools setCaptchaResultFail:^{
            @strongify(self)
            [IMSDKManager configSDKCaptchaChannel:2];
            ZImgVerCodeView *vercodeView = [[ZImgVerCodeView alloc] init];
            vercodeView.loginName = self->_phoneTextField.text;
            vercodeView.verCodeType = 2;
            vercodeView.imgCodeStr = @"";
            [vercodeView show];
            [vercodeView setSureBtnBlock:^(NSString * _Nonnull imgCode) {
                @strongify(self)
                [self requestPhoneGetVercode:imgCode ticket:@"" randstr:@"" captchaVerifyParam:@""];
            }];
        }];
    }
}

// 邮箱获取验证码
- (void)emailGetVerCodeAction {
    // 验证邮箱
    if (_emailTextField.text.length == 0) {
        [HUD showMessage:MultilingualTranslation(@"请先输入邮箱")];
        return;
    }
    
    // 邮箱不需要验证码，直接获取
    [self requestEmailGetVercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:@""];
}

// 手机号请求获取验证码
- (void)requestPhoneGetVercode:(NSString *)code ticket:(NSString *)ticket randstr:(NSString *)randstr captchaVerifyParam:(NSString *)captchaVerifyParam {
    [HUD showActivityMessage:@"" inView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:_phoneTextField.text forKey:@"loginInfo"];
    [params setObjectSafe:@(UserAuthTypePhone) forKey:@"loginType"];
    [params setObjectSafe:@(2) forKey:@"type"]; // 2表示登录
    [params setObjectSafe:_phoneCountryCode forKey:@"areaCode"];
    [params setObjectSafe:code forKey:@"code"];
    [params setObjectSafe:ticket forKey:@"ticket"];
    [params setObjectSafe:randstr forKey:@"randstr"];
    [params setObjectSafe:captchaVerifyParam forKey:@"captchaVerifyParam"];
    
    @weakify(self)
    [IMSDKManager authGetPhoneEmailVerCodeWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        [ZTOOL doInMain:^{
            NSString *vercodeStr = (NSString *)data;
            DLog(@"手机验证码：%@", vercodeStr);
            [HUD showMessage:MultilingualTranslation(@"验证码已发送") inView:self.view];
            [self startPhoneVerCodeCountdown];
            [IMSDKManager configSDKCaptchaChannel:ZHostTool.appSysSetModel.captchaChannel];
            self.captchaTools.aliyunVerNum = 0;
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        [ZTOOL doInMain:^{
            [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
        }];
    }];
}

// 邮箱请求获取验证码
- (void)requestEmailGetVercode:(NSString *)code ticket:(NSString *)ticket randstr:(NSString *)randstr captchaVerifyParam:(NSString *)captchaVerifyParam {
    [HUD showActivityMessage:@"" inView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:_emailTextField.text forKey:@"loginInfo"];
    [params setObjectSafe:@(UserAuthTypeEmail) forKey:@"loginType"];
    [params setObjectSafe:@(2) forKey:@"type"]; // 2表示登录
    [params setObjectSafe:@"" forKey:@"areaCode"];
    [params setObjectSafe:code forKey:@"code"];
    [params setObjectSafe:ticket forKey:@"ticket"];
    [params setObjectSafe:randstr forKey:@"randstr"];
    [params setObjectSafe:captchaVerifyParam forKey:@"captchaVerifyParam"];
    
    @weakify(self)
    [IMSDKManager authGetPhoneEmailVerCodeWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        [ZTOOL doInMain:^{
            NSString *vercodeStr = (NSString *)data;
            DLog(@"邮箱验证码：%@", vercodeStr);
            [HUD showMessage:MultilingualTranslation(@"验证码已发送") inView:self.view];
            [self startEmailVerCodeCountdown];
            [IMSDKManager configSDKCaptchaChannel:ZHostTool.appSysSetModel.captchaChannel];
            self.captchaTools.aliyunVerNum = 0;
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        [ZTOOL doInMain:^{
            [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
        }];
    }];
}

#pragma mark - 验证码倒计时

// 开始手机号验证码倒计时
- (void)startPhoneVerCodeCountdown {
    _phoneVerCodeCountdown = 60;
    _phoneGetVerCodeBtn.enabled = NO;
    [_phoneGetVerCodeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)_phoneVerCodeCountdown] forState:UIControlStateNormal];
    
    if (_phoneVerCodeTimer) {
        [_phoneVerCodeTimer invalidate];
        _phoneVerCodeTimer = nil;
    }
    
    @weakify(self)
    _phoneVerCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        self->_phoneVerCodeCountdown--;
        if (self->_phoneVerCodeCountdown <= 0) {
            [self stopPhoneVerCodeCountdown];
        } else {
            [self->_phoneGetVerCodeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)self->_phoneVerCodeCountdown] forState:UIControlStateNormal];
        }
    }];
}

// 停止手机号验证码倒计时
- (void)stopPhoneVerCodeCountdown {
    if (_phoneVerCodeTimer) {
        [_phoneVerCodeTimer invalidate];
        _phoneVerCodeTimer = nil;
    }
    _phoneGetVerCodeBtn.enabled = YES;
    [_phoneGetVerCodeBtn setTitle:MultilingualTranslation(@"获取验证码") forState:UIControlStateNormal];
}

// 开始邮箱验证码倒计时
- (void)startEmailVerCodeCountdown {
    _emailVerCodeCountdown = 60;
    _emailGetVerCodeBtn.enabled = NO;
    [_emailGetVerCodeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)_emailVerCodeCountdown] forState:UIControlStateNormal];
    
    if (_emailVerCodeTimer) {
        [_emailVerCodeTimer invalidate];
        _emailVerCodeTimer = nil;
    }
    
    @weakify(self)
    _emailVerCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        self->_emailVerCodeCountdown--;
        if (self->_emailVerCodeCountdown <= 0) {
            [self stopEmailVerCodeCountdown];
        } else {
            [self->_emailGetVerCodeBtn setTitle:[NSString stringWithFormat:@"%lds", (long)self->_emailVerCodeCountdown] forState:UIControlStateNormal];
        }
    }];
}

// 停止邮箱验证码倒计时
- (void)stopEmailVerCodeCountdown {
    if (_emailVerCodeTimer) {
        [_emailVerCodeTimer invalidate];
        _emailVerCodeTimer = nil;
    }
    _emailGetVerCodeBtn.enabled = YES;
    [_emailGetVerCodeBtn setTitle:MultilingualTranslation(@"获取验证码") forState:UIControlStateNormal];
}

#pragma mark - Lazy Loading

- (ZCaptchaCodeTools *)captchaTools {
    if (!_captchaTools) {
        _captchaTools = [[ZCaptchaCodeTools alloc] init];
    }
    return _captchaTools;
}

// 显示账号密码输入框
- (void)showAccountPasswordInput {
    // 如果已经显示过了，直接返回
    if (_accountPasswordShown) {
        return;
    }
    
    // 验证账号输入
    if (_accountTextField.text.length == 0) {
        [HUD showMessage:@"请先输入账号"];
        return;
    }
    
    // 创建密码输入框容器
    UIView *passwordContainer = [[UIView alloc] init];
    passwordContainer.backgroundColor = COLOR_F5F6F9;
    passwordContainer.layer.cornerRadius = DWScale(12);
    passwordContainer.layer.masksToBounds = NO;
    [_accountView addSubview:passwordContainer];
    
    // 密码图标
    UIImageView *lockIcon = [[UIImageView alloc] init];
    lockIcon.image = ImgNamed(@"relogimg_img_password_input_tip_reb");
    lockIcon.contentMode = UIViewContentModeScaleAspectFit;
    lockIcon.tintColor = COLOR_81D8CF;
    [passwordContainer addSubview:lockIcon];
    [lockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(passwordContainer).offset(DWScale(16));
        make.centerY.equalTo(passwordContainer);
        make.size.mas_equalTo(CGSizeMake(DWScale(22), DWScale(22)));
    }];
    
    // 创建密码输入框
    _accountPasswordField = [[UITextField alloc] init];
    _accountPasswordField.placeholder = MultilingualTranslation(@"请输入密码");
    _accountPasswordField.font = FONTN(16);
    _accountPasswordField.textColor = COLOR_33;
    _accountPasswordField.backgroundColor = COLOR_F5F6F9;
    _accountPasswordField.secureTextEntry = YES;
    [passwordContainer addSubview:_accountPasswordField];
    [_accountPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lockIcon.mas_trailing).offset(DWScale(12));
        make.trailing.equalTo(passwordContainer).offset(-DWScale(16));
        make.centerY.equalTo(passwordContainer);
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 设置容器约束
    [passwordContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_accountView).offset(DWScale(32));
        make.trailing.equalTo(_accountView).offset(-DWScale(24));
        make.top.equalTo(_accountView).offset(DWScale(20) + DWScale(56) + DWScale(16));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 更新继续按钮约束
    [_continueBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(DWScale(32));
        make.trailing.equalTo(self.view).offset(-DWScale(24));
        make.top.equalTo(self.view).offset(DStatusBarH + DWScale(80) + DWScale(44) + DWScale(30) + DWScale(20) + DWScale(56) + DWScale(16) + DWScale(56) + DWScale(30));
        make.height.mas_equalTo(DWScale(56));
    }];
    
    // 动画显示密码框
    [UIView animateWithDuration:0.3 animations:^{
        [self.accountView layoutIfNeeded];
        [self.view layoutIfNeeded];
        passwordContainer.alpha = 1;
    } completion:^(BOOL finished) {
        [self.accountPasswordField becomeFirstResponder];
    }];
    
    [_continueBtn setTitle:MultilingualTranslation(@"登录") forState:UIControlStateNormal];
    _accountPasswordShown = YES;
}

// 统一的注册按钮点击
- (void)registerAction {
    RegisterCusViewController *registerVC = [[RegisterCusViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

// 选择手机号国家区号
- (void)selectPhoneCountryCode {
    ZCountryCodeViewController *countryCodeVC = [[ZCountryCodeViewController alloc] init];
    [self.navigationController pushViewController:countryCodeVC animated:YES];
    WeakSelf
    [countryCodeVC setSelecgCountryCodeBlock:^(NSDictionary * _Nonnull dic) {
        NSString *prefix = [NSString stringWithFormat:@"%@",[dic objectForKey:@"prefix"]];
        if (![NSString isNil:prefix]) {
            weakSelf.phoneCountryCode = [NSString stringWithFormat:@"+%@", prefix];
            [weakSelf.phoneAreaCodeBtn setTitle:weakSelf.phoneCountryCode forState:UIControlStateNormal];
        }
    }];
}

// 点击多语言按钮
- (void)languageBtnClick {
    NMLanguageSetViewController *languageSetVC = [[NMLanguageSetViewController alloc] init];
    languageSetVC.changeType = LanguageChangeUITypeLogin;
    [self.navigationController pushViewController:languageSetVC animated:YES];
}

// 点击网络按钮
- (void)networkBtnClick {
    SystermNetSettingViewController *netSetVC = [[SystermNetSettingViewController alloc] init];
    [self.navigationController pushViewController:netSetVC animated:YES];
}

// 点击企业号按钮（预设企业号）
- (void)companyIdBtnClick {
    LoginServerConfigView *configView = [[LoginServerConfigView alloc] init];
    WeakSelf
    [configView setConfigCompleteBlock:^(NSString * _Nullable companyId, NSString * _Nullable ipDomain) {
        // 保存预设的企业号信息
        weakSelf.presetCompanyId = companyId;
        weakSelf.presetIpDomain = ipDomain;
        
        // 持久化保存
        [weakSelf saveCompanyIdConfig];
        
        // 更新按钮显示
        [weakSelf updateCompanyIdButtonDisplay];
        
        NSLog(@"预设企业号成功 - 企业号: %@, IP/域名: %@", companyId, ipDomain);
        [HUD showMessage:MultilingualTranslation(@"企业号设置成功")];
    }];
    [configView show];
}

// 显示服务器配置弹窗（用于登录流程）
- (void)showServerConfigView {
    LoginServerConfigView *configView = [[LoginServerConfigView alloc] init];
    WeakSelf
    [configView setConfigCompleteBlock:^(NSString * _Nullable companyId, NSString * _Nullable ipDomain) {
        // 保存配置信息
        weakSelf.presetCompanyId = companyId;
        weakSelf.presetIpDomain = ipDomain;
        
        // 持久化保存
        [weakSelf saveCompanyIdConfig];
        
        // 更新按钮显示
        [weakSelf updateCompanyIdButtonDisplay];
        
        // 配置完成后执行登录操作
        NSLog(@"服务器配置完成，开始登录");
        NSLog(@"企业号: %@, IP/域名: %@", companyId, ipDomain);
        
        // 执行登录
        if (weakSelf.currentSelectedIndex >= 0 && weakSelf.currentSelectedIndex < weakSelf.loginTypeArr.count) {
            int authType = [weakSelf.loginTypeArr[weakSelf.currentSelectedIndex] intValue];
            
            if (authType == UserAuthTypePhone) {
                // 手机号登录（包含区号）
                NSString *fullPhoneNumber = [NSString stringWithFormat:@"%@%@", weakSelf.phoneCountryCode, weakSelf.phoneTextField.text];
                NSLog(@"执行手机号登录: %@ (区号: %@, 手机号: %@), 密码: %@", 
                      fullPhoneNumber, weakSelf.phoneCountryCode, weakSelf.phoneTextField.text, weakSelf.phonePasswordField.text);
            } else if (authType == UserAuthTypeEmail) {
                // 邮箱登录
                NSLog(@"执行邮箱登录: %@, 密码: %@", weakSelf.emailTextField.text, weakSelf.emailPasswordField.text);
            } else if (authType == UserAuthTypeAccount) {
                // 账号登录
                NSLog(@"执行账号登录: %@, 密码: %@", weakSelf.accountTextField.text, weakSelf.accountPasswordField.text);
            }
            
            [weakSelf loginActionWithCompanyId:companyId ipDomain:ipDomain];
        }
    }];
    [configView show];
}

// 登录（带企业号或IP/域名信息）
- (void)loginActionWithCompanyId:(NSString *)companyId ipDomain:(NSString *)ipDomain {
    NSLog(@"开始登录 - 企业号: %@, IP/域名: %@", companyId, ipDomain);
    
    // 获取登录信息和类型
    NSString *loginInfo = @"";
    NSString *password = @"";
    NSString *areaCode = @"";
    int loginType = 0;
    int inputType = 0; // 0:密码登录  1:验证码登录
    
    if (self.currentSelectedIndex >= 0 && self.currentSelectedIndex < self.loginTypeArr.count) {
        int authType = [self.loginTypeArr[self.currentSelectedIndex] intValue];
        
        if (authType == UserAuthTypePhone) {
            // 手机号登录
            loginInfo = self.phoneTextField.text;
            password = self.phonePasswordField.text;
            areaCode = self.phoneCountryCode;
            loginType = UserAuthTypePhone;
            inputType = self.phoneInputType;
        } else if (authType == UserAuthTypeEmail) {
            // 邮箱登录
            loginInfo = self.emailTextField.text;
            password = self.emailPasswordField.text;
            areaCode = @"";
            loginType = UserAuthTypeEmail;
            inputType = self.emailInputType;
        } else if (authType == UserAuthTypeAccount) {
            // 账号登录
            loginInfo = self.accountTextField.text;
            password = self.accountPasswordField.text;
            areaCode = @"";
            loginType = UserAuthTypeAccount;
            inputType = 0; // 账号登录只支持密码
        }
    }
    
    // 判断登录方式
    if (inputType == 0) {
        // 密码登录：需要获取加密密钥
        
        // 验证密码长度
        if (password.length < 6 || password.length > 16) {
            [HUD showMessage:MultilingualTranslation(@"密码长度为6-16位")];
            return;
        }
        
        // 获取加密密钥
        [HUD showActivityMessage:@""];
        WeakSelf
        [IMSDKManager authGetEncryptKeySuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
            [ZTOOL doInMain:^{
                if ([data isKindOfClass:[NSString class]]) {
                    NSString *encryptKey = (NSString *)data;
                    // 执行密码登录
                    [weakSelf performLoginWithLoginInfo:loginInfo 
                                                password:password 
                                               loginType:loginType 
                                                areaCode:areaCode 
                                              encryptKey:encryptKey];
                } else {
                    [HUD hideHUD];
                    [HUD showMessage:MultilingualTranslation(@"获取加密密钥失败")];
                }
            }];
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            [ZTOOL doInMain:^{
                [HUD hideHUD];
                [HUD showMessageWithCode:code errorMsg:msg];
            }];
        }];
    } else {
        // 验证码登录：直接登录，不需要加密密钥
        [self performVerCodeLoginWithLoginInfo:loginInfo 
                                        verCode:password 
                                      loginType:loginType 
                                       areaCode:areaCode];
    }
}

// 执行登录请求
- (void)performLoginWithLoginInfo:(NSString *)loginInfo 
                          password:(NSString *)password 
                         loginType:(int)loginType 
                          areaCode:(NSString *)areaCode 
                        encryptKey:(NSString *)encryptKey {
    
    // AES对称加密密码
    NSString *passwordKey = [NSString stringWithFormat:@"%@%@", encryptKey, password];
    NSString *userPwStr = [LXChatEncrypt method4:passwordKey];
    
    if ([NSString isNil:userPwStr]) {
        [HUD hideHUD];
        [HUD showMessage:[NSString stringWithFormat:@"%@～", MultilingualTranslation(@"操作失败")]];
        return;
    }
    
    // 构建登录参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:loginInfo forKey:@"loginInfo"];
    [params setObjectSafe:[NSNumber numberWithInt:loginType] forKey:@"loginType"];
    [params setObjectSafe:@"" forKey:@"code"]; // 验证码（密码登录时为空）
    [params setObjectSafe:encryptKey forKey:@"encryptKey"];
    [params setObjectSafe:areaCode forKey:@"areaCode"];
    [params setObjectSafe:userPwStr forKey:@"userPw"];
    [params setObjectSafe:[NSNumber numberWithInt:2] forKey:@"type"]; // 2表示登录
    [params setObjectSafe:@"" forKey:@"loginFailVerifyCode"]; // 图形验证码
    [params setObjectSafe:@"" forKey:@"ticket"];
    [params setObjectSafe:@"" forKey:@"randstr"];
    [params setObjectSafe:@"" forKey:@"captchaVerifyParam"];
    
    WeakSelf
    [IMSDKManager authUserLoginWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessage:MultilingualTranslation(@"登录成功")];
            
            // 保存登录信息
            ZUserModel *loginUserModel = [ZUserModel mj_objectWithKeyValues:data];
            [ZUserModel savePreAccount:loginInfo Type:loginType];
            [UserManager setUserInfo:loginUserModel];
            
            // 配置SDK用户信息
            LingIMSDKUserOptions *userOption = [LingIMSDKUserOptions new];
            userOption.userToken = loginUserModel.token;
            userOption.userID = loginUserModel.userUID;
            userOption.userNickname = loginUserModel.nickname;
            userOption.userAvatar = loginUserModel.avatar;
            [IMSDKManager configSDKUserWith:userOption];
            
            // 保存密码用于弱密码检查
            [ZWeakPwdCheckTool sharedInstance].userPwd = password;
            
            // 设置TabBar UI
            [ZTOOL setupTabBarUI];
            
            // 配置数据库和其他模块
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate configDB];
            [delegate configMediaCall];
            
            // 日志模块（登录后更新日志模块用户信息）
            NSString *loganURL = [ZTOOL loganEffectivePublishURL];
            [ZTOOL reloadLoganIfNeededWithPublishURL:loganURL];
            
            // 小程序（在创建tabbar之后）
            [delegate checkMiniAppFloatShow];
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            
            // 处理各种错误情况
            if (code == Auth_User_Account_Banned || code == Auth_User_Device_Banned || code == Auth_User_IPAddress_Banned) {
                if (code == Auth_User_Account_Banned && loginType == UserAuthTypeAccount) {
                    [ZTOOL setupAlertUserBannedUIWithErrorCode:code withContent:loginInfo loginType:UserAuthTypeAccount];
                } else {
                    [ZTOOL setupAlertUserBannedUIWithErrorCode:code withContent:msg loginType:0];
                }
            } else if (code == LingIMHttpResponseCodeUsedIpDisabled) {
                // 登录不在白名单内
                [HUD showMessage:[NSString stringWithFormat:MultilingualTranslation(@"登录IP：%@ 不在白名单内"), msg]];
            } else if (code == Auth_User_Password_Error_Code) {
                // 密码错误
                if (loginType == UserAuthTypeEmail) {
                    [HUD showMessage:MultilingualTranslation(@"密码不正确")];
                } else if (loginType == UserAuthTypePhone) {
                    [HUD showMessage:MultilingualTranslation(@"手机号或密码不正确")];
                } else {
                    [HUD showMessageWithCode:code errorMsg:msg];
                }
            } else {
                // 其他错误
                [HUD showMessageWithCode:code errorMsg:msg];
            }
        }];
    }];
}

// 执行验证码登录请求
- (void)performVerCodeLoginWithLoginInfo:(NSString *)loginInfo 
                                  verCode:(NSString *)verCode 
                                loginType:(int)loginType 
                                 areaCode:(NSString *)areaCode {
    
    // 构建登录参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:loginInfo forKey:@"loginInfo"];
    [params setObjectSafe:[NSNumber numberWithInt:loginType] forKey:@"loginType"];
    [params setObjectSafe:verCode forKey:@"code"]; // 验证码
    [params setObjectSafe:@"" forKey:@"encryptKey"]; // 验证码登录不需要加密密钥
    [params setObjectSafe:areaCode forKey:@"areaCode"];
    [params setObjectSafe:@"" forKey:@"userPw"]; // 验证码登录不需要密码
    [params setObjectSafe:[NSNumber numberWithInt:2] forKey:@"type"]; // 2表示登录
    [params setObjectSafe:@"" forKey:@"loginFailVerifyCode"];
    [params setObjectSafe:@"" forKey:@"ticket"];
    [params setObjectSafe:@"" forKey:@"randstr"];
    [params setObjectSafe:@"" forKey:@"captchaVerifyParam"];
    
    [HUD showActivityMessage:@""];
    WeakSelf
    [IMSDKManager authUserLoginWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessage:MultilingualTranslation(@"登录成功")];
            
            // 保存登录信息
            ZUserModel *loginUserModel = [ZUserModel mj_objectWithKeyValues:data];
            [ZUserModel savePreAccount:loginInfo Type:loginType];
            [UserManager setUserInfo:loginUserModel];
            
            // 配置SDK用户信息
            LingIMSDKUserOptions *userOption = [LingIMSDKUserOptions new];
            userOption.userToken = loginUserModel.token;
            userOption.userID = loginUserModel.userUID;
            userOption.userNickname = loginUserModel.nickname;
            userOption.userAvatar = loginUserModel.avatar;
            [IMSDKManager configSDKUserWith:userOption];
            
            // 验证码登录不需要保存密码用于弱密码检查
            
            // 设置TabBar UI
            [ZTOOL setupTabBarUI];
            
            // 配置数据库和其他模块
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate configDB];
            [delegate configMediaCall];
            
            // 日志模块（登录后更新日志模块用户信息）
            NSString *loganURL = [ZTOOL loganEffectivePublishURL];
            [ZTOOL reloadLoganIfNeededWithPublishURL:loganURL];
            
            // 小程序（在创建tabbar之后）
            [delegate checkMiniAppFloatShow];
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            
            if (code == Auth_User_Account_Banned || code == Auth_User_Device_Banned || code == Auth_User_IPAddress_Banned) {
                if (code == Auth_User_Account_Banned && loginType == UserAuthTypeAccount) {
                    [ZTOOL setupAlertUserBannedUIWithErrorCode:code withContent:loginInfo loginType:UserAuthTypeAccount];
                } else {
                    [ZTOOL setupAlertUserBannedUIWithErrorCode:code withContent:msg loginType:0];
                }
            } else if (code == LingIMHttpResponseCodeUsedIpDisabled) {
                // 登录不在白名单内
                [HUD showMessage:[NSString stringWithFormat:MultilingualTranslation(@"登录IP：%@ 不在白名单内"), msg]];
            } else if (code == Auth_User_Password_Error_Code) {
                // 验证码错误（验证码登录时，Auth_User_Password_Error_Code 表示验证码错误）
                [HUD showMessage:MultilingualTranslation(@"验证码不正确")];
            } else if (code == Auth_User_reGet_Img_Code) {
                // 账号密码或验证码错误
                [HUD showMessage:MultilingualTranslation(@"验证码不正确")];
            } else {
                // 其他错误
                [HUD showMessageWithCode:code errorMsg:msg];
            }
        }];
    }];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(NJCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (self.pageMode == LoginPageModeJoinServer) {
        // 加入企业号模式：切换企业号/IP域名
        [self switchServerConfigType:index];
        return;
    }
    
    // 登录模式：切换登录方式
    _currentSelectedIndex = index;
    
    // 根据 loginTypeArr 获取当前选中的登录类型
    if (index >= 0 && index < self.loginTypeArr.count) {
        int authType = [self.loginTypeArr[index] intValue];
        NSString *typeName = @"";
        if (authType == UserAuthTypePhone) {
            typeName = @"手机号";
        } else if (authType == UserAuthTypeEmail) {
            typeName = @"邮箱";
        } else if (authType == UserAuthTypeAccount) {
            typeName = @"账号";
        }
        NSLog(@"切换到: %@", typeName);
    }
    
    // 切换tab时，根据当前状态更新按钮文本和位置
    BOOL hasPasswordField = NO;
    if (index >= 0 && index < self.loginTypeArr.count) {
        int authType = [self.loginTypeArr[index] intValue];
        if (authType == UserAuthTypePhone) {
            [_continueBtn setTitle:_phonePasswordShown ? MultilingualTranslation(@"登录") : MultilingualTranslation(@"继续") forState:UIControlStateNormal];
            hasPasswordField = _phonePasswordShown;
        } else if (authType == UserAuthTypeEmail) {
            [_continueBtn setTitle:_emailPasswordShown ? MultilingualTranslation(@"登录") : MultilingualTranslation(@"继续") forState:UIControlStateNormal];
            hasPasswordField = _emailPasswordShown;
        } else if (authType == UserAuthTypeAccount) {
            [_continueBtn setTitle:_accountPasswordShown ? MultilingualTranslation(@"登录") : MultilingualTranslation(@"继续") forState:UIControlStateNormal];
            hasPasswordField = _accountPasswordShown;
        }
    }
    
    // 动态调整按钮位置
    if (hasPasswordField) {
        // 有密码框：按钮在第二个输入框下方
        [_continueBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view).offset(DWScale(32));
            make.trailing.equalTo(self.view).offset(-DWScale(24));
            make.top.equalTo(self.view).offset(DStatusBarH + DWScale(80) + DWScale(44) + DWScale(30) + DWScale(20) + DWScale(56) + DWScale(16) + DWScale(56) + DWScale(30));
            make.height.mas_equalTo(DWScale(56));
        }];
    } else {
        // 无密码框：按钮在第一个输入框下方
        [_continueBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view).offset(DWScale(32));
            make.trailing.equalTo(self.view).offset(-DWScale(24));
            make.top.equalTo(self.view).offset(DStatusBarH + DWScale(80) + DWScale(44) + DWScale(30) + DWScale(20) + DWScale(56) + DWScale(30));
            make.height.mas_equalTo(DWScale(56));
        }];
    }
    
    // 平滑动画
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Join Server Actions

// 切换服务器配置类型（企业号/IP域名）
- (void)switchServerConfigType:(NSInteger)index {
    if (index == 0) {
        // 切换到企业号
        _serverConfigType = ServerConfigTypeCompanyId;
        _companyIdInputView.hidden = NO;
        _ipDomainHostInputView.hidden = YES;
        _ipDomainPortInputView.hidden = YES;
        _colonLbl.hidden = YES;
    } else {
        // 切换到IP/域名
        _serverConfigType = ServerConfigTypeIPDomain;
        _companyIdInputView.hidden = YES;
        _ipDomainHostInputView.hidden = NO;
        _ipDomainPortInputView.hidden = NO;
        _colonLbl.hidden = NO;
    }
    
    [self checkConfirmButtonAvailable];
}

// 检查确定按钮是否可用
- (void)checkConfirmButtonAvailable {
    BOOL isAvailable = NO;
    
    if (_serverConfigType == ServerConfigTypeCompanyId) {
        isAvailable = _companyIdInputView.textLength > 0;
    } else {
        isAvailable = _ipDomainHostInputView.textLength > 0;
    }
    
    _confirmServerButton.enabled = isAvailable;
    if (isAvailable) {
        _confirmServerButton.backgroundColor = COLOR_81D8CF;
    } else {
        _confirmServerButton.backgroundColor = [COLOR_81D8CF colorWithAlphaComponent:0.3];
    }
}

// 扫一扫按钮点击
- (void)scanServerAction {
    // 标记正在扫码
    self.isScanning = YES;
    
    // 企业号扫一扫
    ZQRcodeScanViewController *vc = [[ZQRcodeScanViewController alloc] init];
    vc.isRacing = YES;
    
    // 记录当前的 view controller 数量
    NSInteger beforeCount = self.navigationController.viewControllers.count;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    WeakSelf
    [vc setQRcodeSacnLicenseBlock:^(NSString * _Nonnull liceseId, NSString * _Nonnull ipDomainPort) {
        // 标记扫码完成
        weakSelf.isScanning = NO;
        // 扫码后结果处理
        [weakSelf qrcodeScanResultHandlerWithLiceseId:liceseId ipDomainPort:ipDomainPort];
    }];
    
    [vc setQRcodeSacnNavBlock:^(IMServerListResponseBody * _Nonnull model, NSString *appKey) {
        // 标记扫码完成
        weakSelf.isScanning = NO;
        
        if ([ZSsoInfoModel isConfigSSO]) {
            ZSsoInfoModel *infoModel = [ZSsoInfoModel getSSOInfo];
            infoModel.liceseId = appKey;
            [infoModel saveSSOInfo];
        } else {
            ZSsoInfoModel *infoModel = [ZSsoInfoModel new];
            infoModel.liceseId = appKey;
            [infoModel saveSSOInfo];
        }
        
        weakSelf.companyIdInputView.inputText.text = appKey;
        [weakSelf checkConfirmButtonAvailable];
        ZHostTool.isReloadRacing = NO;
        [ZHostTool QRcodeSacnNav:model];
    }];
}

// 确定按钮点击
- (void)confirmServerAction {
    if (_serverConfigType == ServerConfigTypeCompanyId) {
        if (_companyIdInputView.isEmpty) {
            [HUD showMessage:MultilingualTranslation(@"企业号错误")];
            return;
        }
        
        // 清除旧的企业号信息
        [self clearAllServerInfo];
        
        [HUD showActivityMessage:@""];
        // 保存企业号并开始竞速
        [self saveUserInputCompanyIdSSoInfo:[_companyIdInputView.inputText.text lowercaseString]];
    } else {
        if (_ipDomainHostInputView.isEmpty) {
            [HUD showMessage:MultilingualTranslation(@"域名错误")];
            return;
        }
        
        // 清除旧的IP/域名信息
        [self clearAllServerInfo];
        
        [HUD showActivityMessage:@""];
        // 保存IP/域名并开始直连
        NSString *ipDomainPortStr = _ipDomainHostInputView.inputText.text;
        if (![NSString isNil:_ipDomainPortInputView.inputText.text]) {
            ipDomainPortStr = [NSString stringWithFormat:@"%@:%@", _ipDomainHostInputView.inputText.text, _ipDomainPortInputView.inputText.text];
        }
        [self saveUserInputIPAndDomainSSoInfo:ipDomainPortStr];
        _confirmServerButton.enabled = NO; // 按钮防连点
    }
}

// 扫码结果处理
- (void)qrcodeScanResultHandlerWithLiceseId:(NSString *)liceseId ipDomainPort:(NSString *)ipDomainPortStr {
    if (![NSString isNil:liceseId] && ipDomainPortStr.length <= 0) {
        // 扫到企业号
        _serverConfigType = ServerConfigTypeCompanyId;
        
        // 切换到企业号tab
        [_categoryView selectItemAtIndex:0];
        
        _companyIdInputView.hidden = NO;
        _ipDomainHostInputView.hidden = YES;
        _ipDomainPortInputView.hidden = YES;
        _colonLbl.hidden = YES;
        
        _companyIdInputView.preInputText = liceseId;
        [HUD showActivityMessage:@""];
        [self checkConfirmButtonAvailable];
        [self saveUserInputCompanyIdSSoInfo:liceseId];
    }
    
    if (![NSString isNil:ipDomainPortStr] && liceseId.length <= 0) {
        // 扫到IP/域名
        _serverConfigType = ServerConfigTypeIPDomain;
        
        // 切换到IP/域名tab
        [_categoryView selectItemAtIndex:1];
        
        _companyIdInputView.hidden = YES;
        _ipDomainHostInputView.hidden = NO;
        _ipDomainPortInputView.hidden = NO;
        _colonLbl.hidden = NO;
        
        NSString *resultIpDomainPort = [ipDomainPortStr stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        resultIpDomainPort = [resultIpDomainPort stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        
        NSArray *array = [resultIpDomainPort componentsSeparatedByString:@":"];
        if (array.count > 1) {
            _ipDomainHostInputView.inputText.text = array[0];
            _ipDomainPortInputView.inputText.text = array[1];
        } else {
            _ipDomainHostInputView.inputText.text = resultIpDomainPort;
        }
        
        [HUD showActivityMessage:@""];
        [self checkConfirmButtonAvailable];
        [self saveUserInputIPAndDomainSSoInfo:resultIpDomainPort];
    }
}

// 清除所有服务器信息，保持最初状态
- (void)clearAllServerInfo {
    // 1. 获取当前的SSO信息
    ZSsoInfoModel *currentSsoModel = [ZSsoInfoModel getSSOInfo];
    if (currentSsoModel) {
        // 清除旧企业号的缓存
        if (![NSString isNil:currentSsoModel.liceseId]) {
            [[MMKV defaultMMKV] removeValueForKey:[NSString stringWithFormat:@"%@%@", CONNECT_LOCAL_CACHE, currentSsoModel.liceseId]];
            [ZSsoInfoModel clearSSOInfoWithLiceseId:currentSsoModel.liceseId];
        }
        
        // 清除旧的lastLiceseId缓存
        if (![NSString isNil:currentSsoModel.lastLiceseId]) {
            [[MMKV defaultMMKV] removeValueForKey:[NSString stringWithFormat:@"%@%@", CONNECT_LOCAL_CACHE, currentSsoModel.lastLiceseId]];
            [ZSsoInfoModel clearSSOInfoWithLiceseId:currentSsoModel.lastLiceseId];
        }
    }
    
    // 2. 清除MMKV中保存的登录相关配置
    [[MMKV defaultMMKV] removeValueForKey:@"LoginPresetCompanyId"];
    [[MMKV defaultMMKV] removeValueForKey:@"LoginPresetIpDomain"];
    
    // 3. 完全清空SSO信息
    ZSsoInfoModel *cleanModel = [[ZSsoInfoModel alloc] init];
    cleanModel.liceseId = @"";
    cleanModel.ipDomainPortStr = @"";
    cleanModel.lastLiceseId = @"";
    cleanModel.lastIPDomainPortStr = @"";
    [cleanModel saveSSOInfo];
    
    // 4. 断开当前连接，禁止重连
    [IMSDKManager toolDisconnectNoReconnect];
    
    NSLog(@"✅ 已清除所有旧的企业号信息，准备设置新企业号");
}

// 输入的是企业号，走SSO竞速
- (void)saveUserInputCompanyIdSSoInfo:(NSString *)liceseId {
    // 设置新的企业号信息
    ZSsoInfoModel *tempSsoModel = [ZSsoInfoModel getSSOInfo];
    if (!tempSsoModel) {
        tempSsoModel = [[ZSsoInfoModel alloc] init];
    }
    tempSsoModel.liceseId = liceseId;
    tempSsoModel.ipDomainPortStr = @"";
    [tempSsoModel saveSSOInfo];
    
    // 清除新企业号可能存在的旧缓存
    [[MMKV defaultMMKV] removeValueForKey:[NSString stringWithFormat:@"%@%@", CONNECT_LOCAL_CACHE, liceseId]];
    [ZSsoInfoModel clearSSOInfoWithLiceseId:liceseId];
    
    NSLog(@"🔄 开始企业号竞速: %@", liceseId);
    
    [ZTOOL doAsync:^{
        // 节点竞速
        ZHostTool.isReloadRacing = NO;
        [ZHostTool startHostNodeRace];
    } completion:^{
    }];
}

// 输入的是 IP/域名 请求SystemSetting信息
- (void)saveUserInputIPAndDomainSSoInfo:(NSString *)ipDomainPortStr {
    // 去除用户可能输入的 http:// 或者 https://
    NSString *resultIpDomain = [ipDomainPortStr stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    resultIpDomain = [resultIpDomain stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    
    // 设置新的IP/域名信息
    ZSsoInfoModel *tempSsoModel = [ZSsoInfoModel getSSOInfo];
    if (!tempSsoModel) {
        tempSsoModel = [[ZSsoInfoModel alloc] init];
    }
    tempSsoModel.liceseId = @"";
    tempSsoModel.ipDomainPortStr = resultIpDomain;
    [tempSsoModel saveSSOInfo];
    
    NSLog(@"🔄 开始IP/域名直连: %@", resultIpDomain);
    
    [ZTOOL doAsync:^{
        // 请求SystemSetting接口
        ZHostTool.isReloadRacing = NO;
        [ZHostTool startHostNodeRace];
    } completion:^{
    }];
}

// SSO竞速结果 或者 IP/Domain直连 结果
- (void)netWorkNodeRacingAndIpDomainConectResult:(NSNotification *)notification {
    WeakSelf
    [ZTOOL doInMain:^{
        if (weakSelf.pageMode == LoginPageModeJoinServer) {
            weakSelf.confirmServerButton.enabled = YES;
        }
        [HUD hideHUD];
    }];
    
    ZSsoInfoModel *tempSsoModel = [ZSsoInfoModel getSSOInfo];
    if (!tempSsoModel) {
        tempSsoModel = [[ZSsoInfoModel alloc] init];
    }
    
    NSDictionary *dict = notification.userInfo;
    BOOL result = [[dict objectForKey:@"result"] boolValue];
    ZNetRacingStep step = [[dict objectForKey:@"step"] integerValue];
    NSInteger code = [[dict objectForKey:@"code"] integerValue];
    NSString *errorCode = [dict objectForKeySafe:@"errorCode"];
    
    if (result) {
        // 竞速成功
        tempSsoModel.lastLiceseId = tempSsoModel.liceseId;
        tempSsoModel.lastIPDomainPortStr = tempSsoModel.ipDomainPortStr;
        [tempSsoModel saveSSOInfo];
        
        [ZTOOL doInMain:^{
            // 保存配置
            NSString *companyId = ![NSString isNil:tempSsoModel.liceseId] ? tempSsoModel.liceseId : nil;
            NSString *ipDomain = ![NSString isNil:tempSsoModel.ipDomainPortStr] ? tempSsoModel.ipDomainPortStr : nil;
            
            weakSelf.presetCompanyId = companyId;
            weakSelf.presetIpDomain = ipDomain;
            [weakSelf saveCompanyIdConfig];
            
            [HUD showMessage:MultilingualTranslation(@"企业号设置成功")];
            
            // 延迟切换到登录模式
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf switchToLoginMode];
            });
        }];
    } else {
        // 竞速失败
        tempSsoModel.liceseId = tempSsoModel.lastLiceseId;
        tempSsoModel.ipDomainPortStr = tempSsoModel.lastIPDomainPortStr;
        [tempSsoModel saveSSOInfo];
        
        // 显示错误信息
        switch (step) {
            case ZNetRacingStepOss:
            {
                NSString *lastTwo = errorCode.length >= 2 ? [errorCode substringFromIndex:errorCode.length - 2] : errorCode;
                if ([lastTwo isEqualToString:@"01"]) {
                    [ZTOOL doInMain:^{
                        [HUD showMessage:[NSString stringWithFormat:@"%@%@", MultilingualTranslation(@"获取企业号配置失败"), errorCode]];
                    }];
                } else {
                    if (code == 100000) {
                        [ZTOOL doInMain:^{
                            [HUD showMessage:[NSString stringWithFormat:@"%@%@", MultilingualTranslation(@"服务器连接失败 ，请联系管理员"), errorCode]];
                        }];
                    } else {
                        if (code == 404 || code == 403) {
                            [ZTOOL doInMain:^{
                                [HUD showMessage:[NSString stringWithFormat:@"%@%@", MultilingualTranslation(@"获取企业号配置失败"), errorCode]];
                            }];
                        } else {
                            [ZTOOL doInMain:^{
                                [HUD showMessage:[NSString stringWithFormat:@"%@%@", MultilingualTranslation(@"服务器连接失败"), errorCode]];
                            }];
                        }
                    }
                }
            }
                break;
            case ZNetRacingStepHttp:
            {
                [ZTOOL doInMain:^{
                    [HUD showMessage:[NSString stringWithFormat:@"%@%@", MultilingualTranslation(@"获取配置失败"), errorCode]];
                }];
            }
                break;
            case ZNetRacingStepTcp:
            {
                [ZTOOL doInMain:^{
                    [HUD showMessage:[NSString stringWithFormat:@"%@%@", MultilingualTranslation(@"IM连接失败"), errorCode]];
                }];
            }
                break;
            case ZNetIpDomainStepHttp:
            {
                [ZTOOL doInMain:^{
                    [HUD showMessage:[NSString stringWithFormat:@"%@%@", MultilingualTranslation(@"获取配置失败"), errorCode]];
                }];
            }
                break;
            case ZNetIpDomainStepTcp:
            {
                [ZTOOL doInMain:^{
                    [HUD showMessage:[NSString stringWithFormat:@"%@%@", MultilingualTranslation(@"IM连接失败"), errorCode]];
                }];
            }
                break;
            default:
                break;
        }
    }
}

// 切换到登录模式
- (void)switchToLoginMode {
    // 更新页面模式
    self.pageMode = LoginPageModeLogin;
    
    // 移除加入企业号相关的视图
    [_joinServerContainerView removeFromSuperview];
    _joinServerContainerView = nil;
    _companyIdInputView = nil;
    _ipDomainHostInputView = nil;
    _ipDomainPortInputView = nil;
    _colonLbl = nil;
    _scanServerButton = nil;
    _confirmServerButton = nil;
    
    // 移除当前的categoryView
    [_categoryView removeFromSuperview];
    _categoryView = nil;
    
    // 初始化登录模式UI
    [self setupCompanyIdButton];
    [self setupCategoryView];
    [self setupContentViews];
    [self updateCompanyIdButtonDisplay];
    
    NSLog(@"✅ 已切换到登录模式");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 清理验证码倒计时
    if (_phoneVerCodeTimer) {
        [_phoneVerCodeTimer invalidate];
        _phoneVerCodeTimer = nil;
    }
    if (_emailVerCodeTimer) {
        [_emailVerCodeTimer invalidate];
        _emailVerCodeTimer = nil;
    }
}

@end
