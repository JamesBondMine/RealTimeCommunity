//
//  ZPasswordViewController.m
//  CIMKit
//
//  Created by cusPro on 2022/9/19.
//

#import "ZPasswordViewController.h"
#import "MainInputTextView.h"
#import "ZToolManager.h"
#import "AppDelegate.h"
#import "AppDelegate+DB.h"
#import "AppDelegate+MediaCall.h"
#import "AppDelegate+MiniApp.h"
#import "ZFindPasswordViewController.h"
#import "ZAuthInputTools.h"
#import "ZImgVerCodeView.h"
#import "LXChatEncrypt.h"
#import "ZImgVerCodeInputView.h"
#import "ZCaptchaCodeTools.h"
#import "ZSafeCodeAuthViewController.h"
#import "ZWeakPwdCheckTool.h"
#import "ZEncryptKeyGuard.h"

@interface ZPasswordViewController ()

@property (nonatomic, strong)MainInputTextView *passwordInput;
@property (nonatomic, strong)UIButton *switchBtn;
@property (nonatomic, strong)UIButton *forgetBtn;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, assign) int inputType; //0:密码登录  1:验证码登录
@property (nonatomic, copy) NSString *imgCodeStr;
@property (nonatomic, assign) BOOL isShowImgCode;
@property (nonatomic, assign) BOOL isShowCaptcha;
@property (nonatomic, strong)ZImgVerCodeInputView *imageCodeView;
@property (nonatomic, strong)ZCaptchaCodeTools *captchaTools;

@end

@implementation ZPasswordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 注销键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    // 注销键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver: self name:UIKeyboardWillHideNotification object: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    [self setupUI];
    self.passwordInput.preInputText = @"";
}

//验证码类型，0:用户名登录，1:手机号注册 2:手机号登录 3:手机号找回密码
-(int)type{
    if(self.loginType == UserAuthTypeAccount){
        return 0;
    }else if(self.loginType == UserAuthTypePhone){
        return 2;
    }
    return 0;
}

- (void)setupNavBar {
    self.navBtnBack.hidden = NO;
    self.navBtnRight.hidden = YES;
    self.navTitleLabel.hidden = YES;
    self.navLineView.hidden = YES;
}

- (void)setupUI {
    [self.view addSubview:self.passwordInput];
    [self.passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DWScale(105));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(48));
    }];
    
    [self.view addSubview:self.imageCodeView];
    
    if (self.loginType == UserAuthTypePhone || self.loginType == UserAuthTypeEmail) {
        [self.imageCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordInput.mas_bottom).offset(DWScale(0));
            make.leading.equalTo(self.view).offset(DWScale(16));
            make.trailing.equalTo(self.view).offset(DWScale(-16));
            make.height.mas_equalTo(0);
        }];
        
        [self.view addSubview:self.switchBtn];
        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageCodeView.mas_bottom).offset(DWScale(10));
            make.leading.equalTo(self.passwordInput);
            make.width.mas_equalTo(DWScale(150));
            make.height.mas_equalTo(DWScale(20));
        }];
        
        [self.view addSubview:self.forgetBtn];
        [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageCodeView.mas_bottom).offset(DWScale(10));
            make.trailing.equalTo(self.passwordInput);
            make.width.mas_equalTo(DWScale(120));
            make.height.mas_equalTo(DWScale(20));
        }];
    } else {
        [self.imageCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordInput.mas_bottom).offset(DWScale(20));
            make.leading.equalTo(self.view).offset(DWScale(16));
            make.trailing.equalTo(self.view).offset(DWScale(-16));
            make.height.mas_equalTo(DWScale(70));
        }];
    }
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(DWScale(26) + DHomeBarH));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(48));
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(DWScale(26) + DHomeBarH));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(48));
    }];
    
    //输入框输入block回调
    @weakify(self)
    [self.passwordInput setInputStatus:^{
        @strongify(self)
        [self checkLoginBtnAvailable];
    }];
    self.passwordInput.textFieldEndInput = ^{
        @strongify(self)
        [self listenTextFieldEndInputAction];
    };
    self.passwordInput.getVerCodeBlock = ^{
        @strongify(self)
        
        if (self.loginType == UserAuthTypePhone) {
            [IMSDKManager configSDKCaptchaChannel:ZHostTool.appSysSetModel.captchaChannel];
            if (ZHostTool.appSysSetModel.captchaChannel == 1) {
                [self requestGetVercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:@""];
            }
            if (ZHostTool.appSysSetModel.captchaChannel == 2) {
                //图形验证码
                ZImgVerCodeView *vercodeView = [[ZImgVerCodeView alloc] init];
                vercodeView.loginName = self.loginInfo;
                vercodeView.verCodeType = 2;
                vercodeView.imgCodeStr = @"";
                [vercodeView show];
                [vercodeView setSureBtnBlock:^(NSString * _Nonnull imgCode) {
                    //未注册，可以获取短信/邮箱验证码
                    [self requestGetVercode:imgCode ticket:@"" randstr:@"" captchaVerifyParam:@""];
                }];
            }
            if (ZHostTool.appSysSetModel.captchaChannel == 3) {
                //腾讯云无痕验证
                [self.captchaTools verCaptchaCode];
                [self.captchaTools setTencentCaptchaResultSuccess:^(NSString * _Nonnull ticket, NSString * _Nonnull randstr) {
                    @strongify(self)
                    //获取短信验证码接口
                    [self requestGetVercode:@"" ticket:ticket randstr:randstr captchaVerifyParam:@""];
                }];
                [self.captchaTools setCaptchaResultFail:^{
                    @strongify(self)
                    //图形验证码
                    [IMSDKManager configSDKCaptchaChannel:2];
                    ZImgVerCodeView *vercodeView = [[ZImgVerCodeView alloc] init];
                    vercodeView.loginName = self.loginInfo;
                    vercodeView.verCodeType = 2;
                    vercodeView.imgCodeStr = @"";
                    [vercodeView show];
                    [vercodeView setSureBtnBlock:^(NSString * _Nonnull imgCode) {
                        //未注册，可以获取短信/邮箱验证码
                        [self requestGetVercode:imgCode ticket:@"" randstr:@"" captchaVerifyParam:@"" ];
                    }];
                }];
            }
            if (ZHostTool.appSysSetModel.captchaChannel == 4) {
                //阿里云无痕验证
                [self.captchaTools verCaptchaCode];
                [self.captchaTools setAliyunCaptchaResultSuccess:^(NSString * _Nonnull captchaVerifyParam) {
                    @strongify(self)
                    //获取短信验证码接口
                    [self requestGetVercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:captchaVerifyParam];
                }];
                [self.captchaTools setCaptchaResultFail:^{
                    @strongify(self)
                    //图形验证码
                    [IMSDKManager configSDKCaptchaChannel:2];
                    ZImgVerCodeView *vercodeView = [[ZImgVerCodeView alloc] init];
                    vercodeView.loginName = self.loginInfo;
                    vercodeView.verCodeType = 2;
                    vercodeView.imgCodeStr = @"";
                    [vercodeView show];
                    [vercodeView setSureBtnBlock:^(NSString * _Nonnull imgCode) {
                        @strongify(self)
                        //未注册，可以获取短信/邮箱验证码
                        [self requestGetVercode:imgCode ticket:@"" randstr:@"" captchaVerifyParam:@"" ];
                    }];
                }];
            }
        }
        if (self.loginType == UserAuthTypeEmail) {
            [self requestGetVercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:@""];
        }
    };
}

#pragma mark - 状态监听
//通过检查输入框是否有内容来决定确定按钮是否可点击
- (void)checkLoginBtnAvailable {
    if (self.passwordInput.textLength > 0) {
        self.loginBtn.enabled = YES;
        self.loginBtn.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF_DARK];
    } else {
        self.loginBtn.enabled = NO;
        self.loginBtn.tkThemebackgroundColors = @[[COLOR_4791FF colorWithAlphaComponent:0.3], [COLOR_4791FF_DARK colorWithAlphaComponent:0.3]];
    }
}

//监听输入框输入内容变化，做条件判断处理
- (void)listenTextFieldEndInputAction {
    if (self.inputType == 0) { //密码登录
        if (self.passwordInput.inputText.text.length <= 0) {
            [HUD showMessage:MultilingualTranslation(@"请输入密码") inView:self.view];
        }
        if (self.passwordInput.inputText.text.length < 6 || self.passwordInput.inputText.text.length > 16) {
            [HUD showMessage:MultilingualTranslation(@"密码长度为6-16位") inView:self.view];
        }
    }
    if (self.inputType == 1) { //验证码登录
        [ZAuthInputTools checkVerCodeWithText:self.passwordInput.inputText.text];
    }
}

#pragma mark - Keyboard Notification
-(void)keyboardWillShow:(NSNotification *) notification{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyboardHeight = keyboardRect.size.height;
    //更新约束
    [self.loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(keyboardHeight + 40));
    }];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillHide:(NSNotification *) notification{
    [self.loginBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(DWScale(26) + DHomeBarH));
    }];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//如果是通过验证码注册的账号并且未设置过密码，则只显示验证码登录方式
- (void)setPwdExit:(BOOL)pwdExit {
    _pwdExit = pwdExit;
    if (pwdExit == NO) {
        self.switchBtn.selected = YES;
        self.switchBtn.hidden = YES;
        self.passwordInput.inputText.text = @"";
        self.inputType = 1;
        self.passwordInput.placeholderText = MultilingualTranslation(@"请输入验证码");
        self.passwordInput.inputType = ZMessageInputViewTypeVercode;
        self.passwordInput.tipsImgName = @"img_vercode_input_tip_reb";
    }
}

#pragma mark - Action
- (void)switchLoginTypeAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    _passwordInput.inputText.text = @"";
    if (btn.selected) {
        self.inputType = 1;
        _passwordInput.placeholderText = MultilingualTranslation(@"请输入验证码");
        _passwordInput.inputType = ZMessageInputViewTypeVercode;
        _passwordInput.tipsImgName = @"img_vercode_input_tip_reb";
    } else {
        self.inputType = 0;
        _passwordInput.placeholderText = MultilingualTranslation(@"请输入密码");
        _passwordInput.inputType = ZMessageInputViewTypePassword;
        _passwordInput.tipsImgName = @"img_password_input_tip_reb";
    }
    self.isShowImgCode = NO;
    self.isShowCaptcha = YES;
    self.imageCodeView.hidden = YES;
    [self.imageCodeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordInput.mas_bottom).offset(DWScale(0));
        make.height.mas_equalTo(0);
    }];
    [IMSDKManager configSDKCaptchaChannel:ZHostTool.appSysSetModel.captchaChannel];
    self.captchaTools.aliyunVerNum = 0;
}

- (void)forgetPasswordAction {
    ZFindPasswordViewController *findPasswordVC = [[ZFindPasswordViewController alloc] init];
    findPasswordVC.loginInfo = self.loginInfo;
    findPasswordVC.findPasswordWay = self.loginType;
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}

- (void)accountLoginAction {
    //对输入框的内容进行验证
    NSString *inputText = self.passwordInput.inputText.text;
    if ((self.inputType == 0 && [ZAuthInputTools checkPasswordWithText:inputText] == NO) || (self.inputType == 1 && [ZAuthInputTools checkVerCodeWithText:inputText] == NO)) {
        return;
    }
    
    if ([NSString isNil:self.imageCodeView.imgCodeStr] && self.imageCodeView.hidden == NO) {
        [HUD showMessage:MultilingualTranslation(@"请输入验证码") inView:self.view];
        return;
    }
    
    
    //防连续点击事件
    @weakify(self)
    self.loginBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        self.loginBtn.enabled = YES;
    });
    
    [self.view endEditing:YES];
    //获取密码加密密钥或者验证码
    if (self.inputType == 0) {
        [self getEncryptKeyAction];
    } else {
        [self LoginActionWithEncryptKey:@"" vercode:self.passwordInput.inputText.text ticket:@"" randstr:@"" captchaVerifyParam:@""];
    }
}

#pragma mark - Network
//校验验证码，如果校验通过 返回短信/邮箱验证码
- (void)requestGetVercode:(NSString *)code ticket:(NSString *)ticket randstr:(NSString *)randstr captchaVerifyParam:(NSString *)captchaVerifyParam {
    [HUD showActivityMessage:@"" inView:self.view];
    if (self.loginType == UserAuthTypePhone || self.loginType == UserAuthTypeEmail) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObjectSafe:self.loginInfo forKey:@"loginInfo"];
        [params setObjectSafe:[NSNumber numberWithInt:self.loginType] forKey:@"loginType"];
        [params setObjectSafe:[NSNumber numberWithInt:2] forKey:@"type"];
        [params setObjectSafe:self.areaCode forKey:@"areaCode"];
        [params setObjectSafe:code forKey:@"code"];
        [params setObjectSafe:ticket forKey:@"ticket"];
        [params setObjectSafe:randstr forKey:@"randstr"];
        [params setObjectSafe:captchaVerifyParam forKey:@"captchaVerifyParam"];
        
        @weakify(self)
        [IMSDKManager authGetPhoneEmailVerCodeWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            @strongify(self)
            [ZTOOL doInMain:^{
                NSString *vercodeStr = (NSString *)data;
                DLog(@"短信/邮箱 验证码：%@", vercodeStr);
                [HUD showMessage:MultilingualTranslation(@"验证码已发送") inView:self.view];
                [self.passwordInput configVercodeBtnCountdown];
                [IMSDKManager configSDKCaptchaChannel:ZHostTool.appSysSetModel.captchaChannel];
                self.captchaTools.aliyunVerNum = 0;
            }];
            
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            @strongify(self)
            [ZTOOL doInMain:^{
                [self requestAliyunCaptchaErrorResult:code msg:msg];
            }];
            
        }];
    }
}

- (void)requestAliyunCaptchaErrorResult:(NSInteger)errorCode msg:(NSString *)errorMsg {
    @weakify(self)
    if (errorCode == Auth_User_Capcha_Error_Code) {
        //51002：阿里云验证异常，需进行二次验证(图形验证码)
        if (self.captchaTools.aliyunVerNum < 2) {
            [self.captchaTools secondVerCaptchaCode];
            [self.captchaTools setAliyunCaptchaResultSuccess:^(NSString * _Nonnull captchaVerifyParam) {
                @strongify(self)
                //获取短信验证码接口
                [HUD hideHUD];
                [self requestGetVercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:captchaVerifyParam];
            }];
            [self.captchaTools setCaptchaResultFail:^{
                @strongify(self)
                [self showImgVerCodeView];
            }];
        } else {
            [self showImgVerCodeView];
        }
    } else if (errorCode == Auth_User_Capcha_TimeOut_Code) {
        //51006：阿里云验证超时，展示图文验证码
        [self showImgVerCodeView];
    } else if (errorCode == Auth_User_Capcha_ChangeImgVer_Code) {
        //图形验证码不正确，请重新输入
        [HUD showMessage:MultilingualTranslation(@"验证码不正确，请重新输入") inView:self.view];
        [self showImgVerCodeView];
    } else {
        [HUD showMessageWithCode:errorCode errorMsg:errorMsg inView:self.view];
    }
}

- (void)showImgVerCodeView {
    [HUD hideHUD];
    [self.view endEditing:YES];
    @weakify(self)
    [IMSDKManager configSDKCaptchaChannel:2];
    ZImgVerCodeView *vercodeView = [[ZImgVerCodeView alloc] init];
    vercodeView.loginName = self.loginInfo;
    vercodeView.verCodeType = 2;
    vercodeView.imgCodeStr = @"";
    [vercodeView show];
    [vercodeView setSureBtnBlock:^(NSString * _Nonnull imgCode) {
        @strongify(self)
        //验证不通过，重新验证并 返回短信/邮箱验证码
        [self requestGetVercode:imgCode ticket:@"" randstr:@"" captchaVerifyParam:@""];
        [IMSDKManager configSDKCaptchaChannel:ZHostTool.appSysSetModel.captchaChannel];
        self.captchaTools.aliyunVerNum = 0;
    }];
    [vercodeView setCancelBtnBlock:^{
        @strongify(self)
        [IMSDKManager configSDKCaptchaChannel:ZHostTool.appSysSetModel.captchaChannel];
        self.captchaTools.aliyunVerNum = 0;
    }];
}

- (void)getEncryptKeyAction {
    if (self.passwordInput.isEmpty) {
        [HUD showMessage:MultilingualTranslation(@"请输入密码") inView:self.view];
        return;
    }
    [HUD showActivityMessage:@"" inView:self.view];
    @weakify(self)
    [IMSDKManager authGetEncryptKeySuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        [ZTOOL doInMain:^{
            if([data isKindOfClass:[NSString class]]){
                ZEncryptKeyGuard *guard = [ZEncryptKeyGuard guardWithKey:(NSString *)data];
                //调用注册接口，传入加密密钥
                if (self.isShowCaptcha == NO) {
                    NSString *ek = [guard consume];
                    if (ek.length > 0) {
                        [self LoginActionWithEncryptKey:ek vercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:@""];
                    }
                } else {
                    // 将一次性 key 传入验证码回调链路，内部消费一次
                    [self checkCaptchaGuard:guard];
                }
            }
        }];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        
        [ZTOOL doInMain:^{
            [HUD hideHUD];
            [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
        }];
        
    }];
}

- (void)otherGetEncryptKeyActionWith:(NSString *)captchaVerifyParam {
    if (self.passwordInput.isEmpty) {
        [HUD showMessage:MultilingualTranslation(@"请输入密码") inView:self.view];
        return;
    }
    [HUD showActivityMessage:@"" inView:self.view];
    
    @weakify(self)
    [IMSDKManager authGetEncryptKeySuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        
        if([data isKindOfClass:[NSString class]]){
            NSString *encryptKey = (NSString *)data;
            //调用注册接口，传入加密密钥
            [self LoginActionWithEncryptKey:encryptKey vercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:captchaVerifyParam];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        
        [HUD hideHUD];
        [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
    }];
}

- (void)checkCaptchaGuard:(ZEncryptKeyGuard *)guard {
    @weakify(self)
    [self.captchaTools verCaptchaCode];
    //腾讯云无感验证
    [self.captchaTools setTencentCaptchaResultSuccess:^(NSString * _Nonnull ticket, NSString * _Nonnull randstr) {
        @strongify(self)
        //登录接口
        [HUD hideHUD];
        NSString *ek = [guard consume];
        if (ek.length > 0) {
            [self LoginActionWithEncryptKey:ek vercode:@"" ticket:ticket randstr:randstr captchaVerifyParam:@""];
        }
    }];
    //阿里云无感验证
    [self.captchaTools setAliyunCaptchaResultSuccess:^(NSString * _Nonnull captchaVerifyParam) {
        @strongify(self)
        //登录接口
        [HUD hideHUD];
        NSString *ek = [guard consume];
        if (ek.length > 0) {
            [self LoginActionWithEncryptKey:ek vercode:@"" ticket:@"" randstr:@"" captchaVerifyParam:captchaVerifyParam];
        }
    }];
    [self.captchaTools setCaptchaResultFail:^{
        @strongify(self)
        
        [HUD hideHUD];
        //获取图形验证码
        [IMSDKManager configSDKCaptchaChannel:2];
        NSInteger verCodeType = 0;
        if (self.loginType == UserAuthTypePhone) {
            verCodeType = 2;
        }
        if (self.loginType == UserAuthTypeAccount) {
            verCodeType = 0;
        }
        self.isShowImgCode = YES;
        self.isShowCaptcha = NO;
        self.imageCodeView.loginName = self.loginInfo;
        self.imageCodeView.verCodeType = verCodeType;
        self.imageCodeView.hidden = NO;
        self.imageCodeView.imgCodeInput.text = @"";
        self.imageCodeView.imgCodeStr = @"";
        [self.imageCodeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordInput.mas_bottom).offset(DWScale(20));
            make.height.mas_equalTo(70);
        }];
    }];
}

- (void)LoginActionWithEncryptKey:(NSString *)encryptKey vercode:(NSString *)vercode ticket:(NSString *)ticket randstr:(NSString *)randstr captchaVerifyParam:(NSString *)captchaVerifyParam {
    if (self.inputType == 0) { //密码登录
        if ([NSString isNil:self.passwordInput.inputText.text]) {
            [HUD showMessage:MultilingualTranslation(@"请输入密码") inView:self.view];
            return;
        }
        if (self.passwordInput.inputText.text.length < 6 || self.passwordInput.inputText.text.length > 16) {
            [HUD showMessage:MultilingualTranslation(@"密码长度为6-16位") inView:self.view];
            return;
        }
    }
    if (self.inputType == 1 && ![ZAuthInputTools checkVerCodeWithText:self.passwordInput.inputText.text]) { //验证码登录
        return;
    }
    NSString *userPwStr = @"";
    if (![NSString isNil:encryptKey]) {
        //AES对称加密后的密码
        NSString *passwordKey = [NSString stringWithFormat:@"%@%@", encryptKey, self.passwordInput.inputText.text];
        userPwStr = [LXChatEncrypt method4:passwordKey];
        if ([NSString isNil:userPwStr]) {
            [HUD showMessage:[NSString stringWithFormat:@"%@～",MultilingualTranslation(@"操作失败")] inView:self.view];
            return;
        }
    }
    
    //调用登录接口
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:self.loginInfo forKey:@"loginInfo"];
    [params setObjectSafe:[NSNumber numberWithInt:self.loginType] forKey:@"loginType"];
    [params setObjectSafe:vercode forKey:@"code"];
    [params setObjectSafe:encryptKey forKey:@"encryptKey"];
    [params setObjectSafe:self.areaCode forKey:@"areaCode"];
    [params setObjectSafe:userPwStr forKey:@"userPw"];
    [params setObjectSafe:[NSNumber numberWithInt:2] forKey:@"type"];
    [params setObjectSafe:self.isShowImgCode ? self.imageCodeView.imgCodeInput.text : @"" forKey:@"loginFailVerifyCode"];
    [params setObjectSafe:ticket forKey:@"ticket"];
    [params setObjectSafe:randstr forKey:@"randstr"];
    [params setObjectSafe:captchaVerifyParam forKey:@"captchaVerifyParam"];
    
    @weakify(self)
    [HUD showActivityMessage:@"" inView:self.view];
    [IMSDKManager authUserLoginWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
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
                
            [ZWeakPwdCheckTool sharedInstance].userPwd = self.passwordInput.inputText.text;
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
            if (code == Auth_User_Account_Banned || code == Auth_User_Device_Banned || code == Auth_User_IPAddress_Banned) {
                if (code == Auth_User_Account_Banned && self.loginType == UserAuthTypeAccount) {
                    [ZTOOL setupAlertUserBannedUIWithErrorCode:code withContent:self.loginInfo loginType:UserAuthTypeAccount];
                } else {
                    [ZTOOL setupAlertUserBannedUIWithErrorCode:code withContent:msg loginType:0];
                }
                return;
            } else if (code == LingIMHttpResponseCodeUsedIpDisabled) {
                //登录不在白名单内，需展示IP地址
                [HUD showMessage:[NSString stringWithFormat:MultilingualTranslation(@"登录IP：%@ 不在白名单内"), msg] inView:self.view];
            } else if (code == Auth_User_Password_Error_Code) {
                if (self.imageCodeView.hidden == NO) {
                    NSInteger verCodeType = 0;
                    if (self.loginType == UserAuthTypePhone) {
                        verCodeType = 2;
                    }
                    if (self.loginType == UserAuthTypeAccount) {
                        verCodeType = 0;
                    }
                    self.isShowImgCode = YES;
                    self.isShowCaptcha = NO;
                    self.imageCodeView.loginName = self.loginInfo;
                    self.imageCodeView.verCodeType = verCodeType;
                    self.imageCodeView.hidden = NO;
                    self.imageCodeView.imgCodeInput.text = @"";
                    self.imageCodeView.imgCodeStr = @"";
                    [self.imageCodeView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.passwordInput.mas_bottom).offset(DWScale(20));
                        make.height.mas_equalTo(70);
                    }];
                }
                if (self.loginType == UserAuthTypeEmail) {
                    [HUD showMessage:MultilingualTranslation(@"密码不正确") inView:self.view];
                } else if (self.loginType == UserAuthTypePhone) {
                    [HUD showMessage:MultilingualTranslation(@"手机号或密码不正确") inView:self.view];
                } else {
                    [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
                }
            } else if (code == Auth_User_Get_Img_Code || code == Auth_User_reGet_Img_Code || code == Auth_User_Banned_Five_Code || code == Auth_User_Banned_24Hour_Code) {
                if (ZHostTool.appSysSetModel.captchaChannel == 2) {
                    //获取图形验证码
                    [HUD hideHUD];
                    [self showLoginImgVerCodeView];
                    
                    if (code == Auth_User_Banned_Five_Code || code == Auth_User_Banned_24Hour_Code) {
                        [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
                    }
                }
                if (code == Auth_User_Get_Img_Code) {
                    if (ZHostTool.appSysSetModel.captchaChannel == 3) {
                        //腾讯云无痕验证
                        self.isShowImgCode = NO;
                        self.isShowCaptcha = YES;
                        //客户端主动调用一次登录
                        [self getEncryptKeyAction];
                    }
                    if (ZHostTool.appSysSetModel.captchaChannel == 4) {
                        //阿里云无痕验证
                        self.isShowImgCode = NO;
                        self.isShowCaptcha = YES;
                        //客户端主动调用一次登录
                        [self getEncryptKeyAction];
                    }
                } else {
                    [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
                }
            } else if (code == Auth_User_Capcha_Error_Code) {
                //51002：阿里云验证异常，需进行二次验证(图形验证码)
                if (self.captchaTools.aliyunVerNum < 3) {
                    [self.captchaTools secondVerCaptchaCode];
                    [self.captchaTools setAliyunCaptchaResultSuccess:^(NSString * _Nonnull captchaVerifyParam) {
                        @strongify(self)
                        //获取短信验证码接口
                        [HUD hideHUD];
                        //阿里云无痕验证
                        self.isShowImgCode = NO;
                        self.isShowCaptcha = YES;
                        //客户端主动调用一次登录
                        [self otherGetEncryptKeyActionWith:captchaVerifyParam];
                    }];
                    [self.captchaTools setCaptchaResultFail:^{
                        @strongify(self)
                        [self showLoginImgVerCodeView];
                    }];
                } else {
                    [self showLoginImgVerCodeView];
                }
            } else if (code == Auth_User_Capcha_TimeOut_Code) {
                //51006：阿里云验证超时，展示图文验证码
                [self showLoginImgVerCodeView];
            } else if (code == Auth_User_Capcha_ChangeImgVer_Code) {
                //图形验证码不正确，请重新输入
                [HUD showMessage:MultilingualTranslation(@"验证码不正确，请重新输入") inView:self.view];
                [self showLoginImgVerCodeView];
            } else if (code == Auth_Login_Security_Code_Error_Code) {
                [HUD hideHUD];
                //登录需要安全码，跳转到安全码输入界面
                ZSafeCodeAuthViewController *vc = [[ZSafeCodeAuthViewController alloc] init];
                vc.scKey = msg;
                vc.loginInfo = self.loginInfo;
                vc.loginType = self.loginType;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
            }
            
        }];
    }];
}

- (void)showLoginImgVerCodeView {
    [HUD hideHUD];
    [IMSDKManager configSDKCaptchaChannel:2];
    NSInteger verCodeType = 0;
    if (self.loginType == UserAuthTypePhone) {
        verCodeType = 2;
    }
    if (self.loginType == UserAuthTypeAccount) {
        verCodeType = 0;
    }
    self.isShowImgCode = YES;
    self.isShowCaptcha = NO;
    self.imageCodeView.loginName = self.loginInfo;
    self.imageCodeView.verCodeType = verCodeType;
    self.imageCodeView.hidden = NO;
    self.imageCodeView.imgCodeInput.text = @"";
    self.imageCodeView.imgCodeStr = @"";
    [self.imageCodeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordInput.mas_bottom).offset(DWScale(20));
        make.height.mas_equalTo(70);
    }];
}

#pragma mark - Lazy
- (MainInputTextView *)passwordInput {
    if (!_passwordInput) {
        _passwordInput = [[MainInputTextView alloc] init];
        _passwordInput.inputText.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordInput.placeholderText = MultilingualTranslation(@"请输入密码");
        _passwordInput.inputType = ZMessageInputViewTypePassword;
        _passwordInput.tipsImgName = @"img_password_input_tip_reb";
    }
    return _passwordInput;
}

- (UIButton *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UIButton alloc] init];
        [_switchBtn setTitle:MultilingualTranslation(@"验证码登录") forState:UIControlStateNormal];
        [_switchBtn setTitle:MultilingualTranslation(@"账密登录") forState:UIControlStateSelected];
        [_switchBtn setTkThemeTitleColor:@[COLOR_4791FF, COLOR_4791FF_DARK] forState:UIControlStateNormal];
        _switchBtn.titleLabel.font = FONTN(14);
        [_switchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_switchBtn addTarget:self action:@selector(switchLoginTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        _switchBtn.selected = NO;
    }
    return _switchBtn;
}

- (UIButton *)forgetBtn {
    if (!_forgetBtn) {
        _forgetBtn = [[UIButton alloc] init];
        [_forgetBtn setTitle:MultilingualTranslation(@"忘记密码") forState:UIControlStateNormal];
        [_forgetBtn setTkThemeTitleColor:@[COLOR_33, COLOR_33_DARK] forState:UIControlStateNormal];
        _forgetBtn.titleLabel.font = FONTN(14);
        [_forgetBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_forgetBtn addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}

- (ZImgVerCodeInputView *)imageCodeView {
    if (!_imageCodeView) {
        _imageCodeView = [[ZImgVerCodeInputView alloc] init];
        _imageCodeView.hidden = YES;
    }
    return _imageCodeView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:MultilingualTranslation(@"登录") forState:UIControlStateNormal];
        [_loginBtn setTitleColor:COLORWHITE forState:UIControlStateNormal];
        _loginBtn.enabled = NO;
        _loginBtn.tkThemebackgroundColors = @[[COLOR_4791FF colorWithAlphaComponent:0.3], [COLOR_4791FF_DARK colorWithAlphaComponent:0.3]];
        [_loginBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
        [_loginBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
        _loginBtn.titleLabel.font = FONTN(16);
        [_loginBtn rounded:DWScale(14)];
        _loginBtn.clipsToBounds = YES;
        [_loginBtn addTarget:self action:@selector(accountLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (ZCaptchaCodeTools *)captchaTools {
    if (!_captchaTools) {
        _captchaTools = [[ZCaptchaCodeTools alloc] init];
        _captchaTools.aliyunVerNum = 0;
    }
    return _captchaTools;
}

@end
