//
//  ZSafeCodeAuthViewController.m
//  CIMKit
//
//  Created by cusPro on 2024/12/30.
//

#import "ZSafeCodeAuthViewController.h"
#import "MainInputTextView.h"
#import "LXChatEncrypt.h"
#import "AppDelegate+DB.h"
#import "AppDelegate+MediaCall.h"
#import "AppDelegate+MiniApp.h"

@interface ZSafeCodeAuthViewController ()

@property (nonatomic, strong)MainInputTextView *safeCodeTextInput;
@property (nonatomic, strong)UIButton *authLoginButton;

@end

@implementation ZSafeCodeAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
    [self setupUI];
}

- (void)setupNavBar {
    self.navBtnBack.hidden = NO;
    self.navBtnRight.hidden = YES;
    self.navTitleLabel.hidden = YES;
    self.navLineView.hidden = YES;
}

- (void)setupUI {
    UIImageView *tipsLogoImgView = [UIImageView new];
    tipsLogoImgView.tkThemeimages = @[ImgNamed(@"relogimg_img_safe_code_logo_reb"), ImgNamed(@"relogimg_img_safe_code_logo_dark_reb")];
    [self.view addSubview:tipsLogoImgView];
    [tipsLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DWScale(112));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DWScale(104), DWScale(104)));
    }];
    
    UILabel *firstTipsLbl = [UILabel new];
    firstTipsLbl.textAlignment = NSTextAlignmentCenter;
    firstTipsLbl.text = MultilingualTranslation(@"在新设备登录需要验证");
    firstTipsLbl.font = FONTB(20);
    firstTipsLbl.numberOfLines = 0;
    firstTipsLbl.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    [self.view addSubview:firstTipsLbl];
    [firstTipsLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLogoImgView.mas_bottom).offset(DWScale(40));
        make.leading.equalTo(self.view.mas_leading).offset(DWScale(16));
        make.trailing.equalTo(self.view.mas_trailing).offset(DWScale(-16));
    }];
    
    UILabel *secondTipsLbl = [UILabel new];
    secondTipsLbl.textAlignment = NSTextAlignmentCenter;
    secondTipsLbl.text = MultilingualTranslation(@"为了保障您的账号安全，需输入设备安全码进行验证。");
    secondTipsLbl.font = FONTB(16);
    secondTipsLbl.tkThemetextColors = @[COLOR_66, COLOR_66_DARK];
    secondTipsLbl.numberOfLines = 0;
    [self.view addSubview:secondTipsLbl];
    [secondTipsLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstTipsLbl.mas_bottom).offset(DWScale(16));
        make.leading.equalTo(self.view.mas_leading).offset(DWScale(16));
        make.trailing.equalTo(self.view.mas_trailing).offset(DWScale(-16));
    }];
    
    self.safeCodeTextInput = [[MainInputTextView alloc] init];
    self.safeCodeTextInput.isPassword = YES;
    self.safeCodeTextInput.isShowBoard = NO;
    self.safeCodeTextInput.placeholderText = MultilingualTranslation(@"请输入安全码");
    self.safeCodeTextInput.bgViewBackColor = @[COLOR_F5F6F9, COLOR_F5F6F9_DARK];
    self.safeCodeTextInput.inputText.keyboardType = UIKeyboardTypeASCIICapable;
    if (@available(iOS 12.0, *)) {
        self.safeCodeTextInput.inputText.textContentType = UITextContentTypeOneTimeCode;
    } else {
        // Fallback on earlier versions
    }
    self.safeCodeTextInput.inputType = ZMessageInputViewTypePassword;
    self.safeCodeTextInput.tipsImgName = @"";
    [self.view addSubview:self.safeCodeTextInput];
    [self.safeCodeTextInput mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondTipsLbl.mas_bottom).offset(DWScale(32));
        make.leading.equalTo(self.view.mas_leading).offset(DWScale(16));
        make.trailing.equalTo(self.view.mas_trailing).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(48));
        
    }];
    
    self.authLoginButton = [[UIButton alloc] init];
    [self.authLoginButton setTitle:MultilingualTranslation(@"登录") forState:UIControlStateNormal];
    [self.authLoginButton setTitleColor:COLORWHITE forState:UIControlStateNormal];
    self.authLoginButton.enabled = NO;
    self.authLoginButton.tkThemebackgroundColors = @[[COLOR_81D8CF colorWithAlphaComponent:0.3], [COLOR_81D8CF_DARK colorWithAlphaComponent:0.3]];
    [self.authLoginButton setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
    [self.authLoginButton setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
    [self.authLoginButton rounded:DWScale(14)];
    [self.authLoginButton shadow:COLOR_81D8CF opacity:0.15 radius:5 offset:CGSizeMake(0, 0)];
    self.authLoginButton.clipsToBounds = YES;
    [self.authLoginButton addTarget:self action:@selector(authLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.authLoginButton];
    [self.authLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.safeCodeTextInput.mas_bottom).offset(DWScale(40));
        make.leading.equalTo(self.view.mas_leading).offset(DWScale(16));
        make.trailing.equalTo(self.view.mas_trailing).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(50));
    }];
    
    //输入框输入内容变化回调
    WeakSelf
    [self.safeCodeTextInput setInputStatus:^{
        [weakSelf checkLoginBtnAvailable];
    }];
}

- (void)checkLoginBtnAvailable {
    if (self.safeCodeTextInput.textLength > 0) {
        self.authLoginButton.enabled = YES;
        self.authLoginButton.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF_DARK];
    } else {
        self.authLoginButton.enabled = NO;
        self.authLoginButton.tkThemebackgroundColors = @[[COLOR_81D8CF colorWithAlphaComponent:0.3], [COLOR_81D8CF_DARK colorWithAlphaComponent:0.3]];
    }
}

#pragma mark - Request
- (void)requestGetEncryptKeyAction {
    [HUD showActivityMessage:@"" inView:self.view];
    @weakify(self)
    [IMSDKManager authGetEncryptKeySuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            
            if([data isKindOfClass:[NSString class]]){
                NSString *encryptKey = (NSString *)data;
                [self requestDeviceSafeCodeLoginWithEncryptkey:encryptKey];
            }
        }];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        
        [ZTOOL doInMain:^{
            [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
        }];
        
    }];
}

- (void)requestDeviceSafeCodeLoginWithEncryptkey:(NSString *)encryptKey {
    NSString *safeCodeEncryptStr = @"";
    if (![NSString isNil:encryptKey]) {
        //AES对称加密后的密码
        NSString *safeCodeKey = [NSString stringWithFormat:@"%@%@", encryptKey, [self.safeCodeTextInput.inputText.text trimString]];
        safeCodeEncryptStr = [LXChatEncrypt method4:safeCodeKey];
        if ([NSString isNil:safeCodeEncryptStr]) {
            [HUD showMessage:MultilingualTranslation(@"操作失败") inView:self.view];
            return;
        }
    }
    
    //调用安全码登录接口
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:self.scKey forKey:@"scKey"];
    [params setObjectSafe:encryptKey forKey:@"encryptKey"];
    [params setObjectSafe:safeCodeEncryptStr forKey:@"securityCode"];
    
    @weakify(self)
    [IMSDKManager authSecurityCodeLoginWith:params onSuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessage:MultilingualTranslation(@"登录成功") inView:self.view];
            //登录后
            ZUserModel *loginUserModel = [ZUserModel mj_objectWithKeyValues:data];
            [ZUserModel savePreAccount:self.loginInfo Type:self.loginType];
            [UserManager setUserInfo:loginUserModel];
            
            //socket用户登录连接
            LingIMSDKUserOptions *userOption = [LingIMSDKUserOptions new];
            userOption.userToken = loginUserModel.token;
            userOption.userID = loginUserModel.userUID;
            userOption.userNickname = loginUserModel.nickname;
            userOption.userAvatar = loginUserModel.avatar;
            [IMSDKManager configSDKUserWith:userOption];
                
            [ZTOOL setupTabBarUI];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate configDB];
            [delegate configMediaCall];
            //日志模块(登录后更新日志模块用户信息)
            NSString *loganURL = [ZTOOL loganEffectivePublishURL];
            [ZTOOL reloadLoganIfNeededWithPublishURL:loganURL];

            //小程序(在创建tabbar之后)
            [delegate checkMiniAppFloatShow];
        }];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            if (code == Auth_Login_SecurityCode_Has_Set_Error_Code || code == Auth_Login_SecurityCode_No_Set_Error_Code || code == Auth_Login_SecurityCode_Format_Error_Code || code == Auth_Login_SecurityCode_otherFormat_Error_Code) {
                return;
            } else if (code == Auth_Login_SecurityCode_Expire_Error_Code) {
                [HUD showMessage:MultilingualTranslation(@"停留时间过久 请重新登录") inView:self.view];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else if (code == Auth_Login_SecurityCode_Not_SameDevice_Error_Code) {
                [HUD showMessage:MultilingualTranslation(@"登录失败 请重新登录") inView:self.view];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
            }
        }];
        
    }];
}

#pragma mark - Action
- (void)authLoginAction {
    [self requestGetEncryptKeyAction];
}

@end
