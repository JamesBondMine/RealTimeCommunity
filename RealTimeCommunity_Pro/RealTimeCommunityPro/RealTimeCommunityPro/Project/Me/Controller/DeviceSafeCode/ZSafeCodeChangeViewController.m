//
//  ZSafeCodeChangeViewController.m
//  CIMKit
//
//  Created by cusPro on 2025/1/2.
//

#import "ZSafeCodeChangeViewController.h"
#import "MainInputTextView.h"
#import "ZSafeSettingTools.h"
#import "LXChatEncrypt.h"

@interface ZSafeCodeChangeViewController ()

@property (nonatomic, strong)MainInputTextView *originSafeCodeInput;
@property (nonatomic, strong)UILabel *originSafeCodeInputTipsLbl;
@property (nonatomic, strong)MainInputTextView *freshSafeCodeInput;
@property (nonatomic, strong)UILabel *freshSafeCodeInputTipsLbl;
@property (nonatomic, strong)MainInputTextView *confimFreshSafeCodeInput;
@property (nonatomic, strong)UILabel *confimFreshSafeCodeInputTipsLbl;

@end

@implementation ZSafeCodeChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self setupNavBarUI];
    [self setupUI];
}

- (void)setupNavBarUI {
    self.navTitleStr = MultilingualTranslation(@"修改安全码");
    
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:MultilingualTranslation(@"完成") forState:UIControlStateNormal];
    [self.navBtnRight setTkThemeTitleColor:@[COLORWHITE, COLOR_CCCCCC_DARK] forState:UIControlStateNormal];
    self.navBtnRight.enabled = NO;
    self.navBtnRight.tkThemebackgroundColors = @[COLOR_CCCCCC, COLOR_EEEEEE_DARK];
    [self.navBtnRight setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
    [self.navBtnRight setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
    [self.navBtnRight rounded:DWScale(12)];
    [self.navBtnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel);
        make.trailing.equalTo(self.navView).offset(-DWScale(20));
        make.height.mas_equalTo(DWScale(32));
        CGSize textSize = [self.navBtnRight.titleLabel.text sizeWithFont:FONTR(14) constrainedToSize:CGSizeMake(10000, DWScale(32))];
        make.width.mas_equalTo(textSize.width+DWScale(28));
    }];
}

- (void)setupUI {
    UILabel *originTitleLab = [[UILabel alloc] init];
    originTitleLab.text = MultilingualTranslation(@"请输入原安全码");
    originTitleLab.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    originTitleLab.font = FONTN(14);
    originTitleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:originTitleLab];
    [originTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(DWScale(20));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    [self.view addSubview:self.originSafeCodeInput];
    [self.originSafeCodeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(originTitleLab.mas_bottom).offset(DWScale(8));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(44));
    }];
    
    [self.view addSubview:self.originSafeCodeInputTipsLbl];
    [self.originSafeCodeInputTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originSafeCodeInput.mas_bottom);
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(0);
    }];

    //再次输入安全码
    UILabel *freshTitleLab = [[UILabel alloc] init];
    freshTitleLab.text = MultilingualTranslation(@"请输入新安全码");
    freshTitleLab.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    freshTitleLab.font = FONTN(14);
    freshTitleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:freshTitleLab];
    [freshTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originSafeCodeInputTipsLbl.mas_bottom).offset(DWScale(16));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    [self.view addSubview:self.freshSafeCodeInput];
    [self.freshSafeCodeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(freshTitleLab.mas_bottom).offset(DWScale(8));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(44));
    }];
    
    [self.view addSubview:self.freshSafeCodeInputTipsLbl];
    [self.freshSafeCodeInputTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.freshSafeCodeInput.mas_bottom);
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(0);
    }];
    
    //请再次输入新安全码
    UILabel *confimFreshTitleLab = [[UILabel alloc] init];
    confimFreshTitleLab.text = MultilingualTranslation(@"请再次输入新安全码");
    confimFreshTitleLab.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    confimFreshTitleLab.font = FONTN(14);
    confimFreshTitleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:confimFreshTitleLab];
    [confimFreshTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.freshSafeCodeInputTipsLbl.mas_bottom).offset(DWScale(16));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(18));
    }];
    
    [self.view addSubview:self.confimFreshSafeCodeInput];
    [self.confimFreshSafeCodeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confimFreshTitleLab.mas_bottom).offset(DWScale(8));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(DWScale(44));
    }];
    
    [self.view addSubview:self.confimFreshSafeCodeInputTipsLbl];
    [self.confimFreshSafeCodeInputTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confimFreshSafeCodeInput.mas_bottom);
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
        make.height.mas_equalTo(0);
    }];
    
    //请再次输入新安全码
    UILabel *tipsTitleLab = [[UILabel alloc] init];
    tipsTitleLab.text = MultilingualTranslation(@"安全码6位，包含字母、数字");
    tipsTitleLab.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    tipsTitleLab.font = FONTN(14);
    tipsTitleLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipsTitleLab];
    [tipsTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confimFreshSafeCodeInputTipsLbl.mas_bottom).offset(DWScale(12));
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.equalTo(self.view).offset(DWScale(-16));
    }];
    
    @weakify(self)
    //输入框结束输入
    self.originSafeCodeInput.inputStatus = ^{
        @strongify(self)
        [self listenOriginSafeCodeInput];
    };
    self.freshSafeCodeInput.inputStatus = ^{
        @strongify(self)
        [self listenFreshSafeCodeInput];
    };
    self.confimFreshSafeCodeInput.inputStatus = ^{
        @strongify(self)
        [self listenConfimFreshSafeCodeInput];
    };
}

//原安全码监听
- (void)listenOriginSafeCodeInput {
    if ([ZSafeSettingTools checkInputDeviceSafeCodeEndWithText:self.originSafeCodeInput.inputText.text]) {
        self.originSafeCodeInputTipsLbl.hidden = YES;
        [self.originSafeCodeInputTipsLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else {
        self.originSafeCodeInputTipsLbl.hidden = NO;
        [self.originSafeCodeInputTipsLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(DWScale(16));
        }];
    }
    
    [self checkFinishBtnAvailable];
}

//新安全密码监听
- (void)listenFreshSafeCodeInput {
    if ([ZSafeSettingTools checkInputDeviceSafeCodeEndWithText:self.freshSafeCodeInput.inputText.text]) {
        self.freshSafeCodeInputTipsLbl.hidden = YES;
        [self.freshSafeCodeInputTipsLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } else {
        self.freshSafeCodeInputTipsLbl.hidden = NO;
        [self.freshSafeCodeInputTipsLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(DWScale(16));
        }];
    }
    
    [self checkFinishBtnAvailable];
}

//确认安全密码监听
- (void)listenConfimFreshSafeCodeInput {
    if (![self.freshSafeCodeInput.inputText.text isEqualToString:self.confimFreshSafeCodeInput.inputText.text]) {
        self.confimFreshSafeCodeInputTipsLbl.hidden = NO;
        [self.confimFreshSafeCodeInputTipsLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(DWScale(16));
        }];
    } else {
        self.confimFreshSafeCodeInputTipsLbl.hidden = YES;
        [self.confimFreshSafeCodeInputTipsLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    [self checkFinishBtnAvailable];
}

- (void)checkFinishBtnAvailable {
    if (self.originSafeCodeInput.textLength > 0 && self.freshSafeCodeInput.textLength > 0 && self.confimFreshSafeCodeInput.textLength > 0) {
        self.navBtnRight.enabled = YES;
        [self.navBtnRight setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
        self.navBtnRight.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF_DARK];
        [self.navBtnRight setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
        [self.navBtnRight setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
    } else {
        self.navBtnRight.enabled = NO;
        [self.navBtnRight setTkThemeTitleColor:@[COLORWHITE, COLOR_CCCCCC_DARK] forState:UIControlStateNormal];
        self.navBtnRight.tkThemebackgroundColors = @[COLOR_CCCCCC, COLOR_EEEEEE_DARK];
    }
}

#pragma mark - Action
- (void)navBtnRightClicked {
    if (![ZSafeSettingTools checkInputDeviceSafeCodeEndWithText:self.originSafeCodeInput.inputText.text]) {
        [HUD showMessage:MultilingualTranslation(@"请输入6位包含字母、数字的安全码") inView:self.view];
        return;
    }
    if (![ZSafeSettingTools checkInputDeviceSafeCodeEndWithText:self.freshSafeCodeInput.inputText.text]) {
        [HUD showMessage:MultilingualTranslation(@"请输入6位包含字母、数字的安全码") inView:self.view];
        return;
    }
    if (![self.freshSafeCodeInput.inputText.text isEqualToString:self.confimFreshSafeCodeInput.inputText.text]) {
        [HUD showMessage:MultilingualTranslation(@"两次安全码需保持一致") inView:self.view];
        return;
    }
        
    [self requestGetEncryptKeyAction];
}

#pragma mark - Request
- (void)requestGetEncryptKeyAction {
    @weakify(self)
    [HUD showActivityMessage:@"" inView:self.view];
    [IMSDKManager authGetEncryptKeySuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        [HUD hideHUD];
        
        if([data isKindOfClass:[NSString class]]){
            NSString *encryptKey = (NSString *)data;
            [self requestChangeDeviceSafeCodeWithEncryptkey:encryptKey];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        
        [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
    }];
}

//修改安全码
- (void)requestChangeDeviceSafeCodeWithEncryptkey:(NSString *)encryptKey {
    NSString *originalSafeCodeEncryptStr = @"";
    NSString *newSafeCodeEncryptStr = @"";
    if (![NSString isNil:encryptKey]) {
        //AES对称加密后的密码
        //原安全码
        NSString *originalSafeCodeKey = [NSString stringWithFormat:@"%@%@", encryptKey, [self.originSafeCodeInput.inputText.text trimString]];
        originalSafeCodeEncryptStr = [LXChatEncrypt method4:originalSafeCodeKey];
        if ([NSString isNil:originalSafeCodeEncryptStr]) {
            [HUD showMessage:MultilingualTranslation(@"操作失败") inView:self.view];
            return;
        }
        //新安全码
        NSString *newSafeCodeKey = [NSString stringWithFormat:@"%@%@", encryptKey, [self.freshSafeCodeInput.inputText.text trimString]];
        newSafeCodeEncryptStr = [LXChatEncrypt method4:newSafeCodeKey];
        if ([NSString isNil:newSafeCodeEncryptStr]) {
            [HUD showMessage:MultilingualTranslation(@"操作失败") inView:self.view];
            return;
        }
    }
    
    //调用修改安全码接口
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:encryptKey forKey:@"encryptKey"];
    [params setObjectSafe:newSafeCodeEncryptStr forKey:@"securityCode"];
    [params setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    [params setObjectSafe:originalSafeCodeEncryptStr forKey:@"originalSecurityCode"];
    
    @weakify(self)
    [IMSDKManager authUpdatecurityCodeWith:params onSuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
        @strongify(self)
        
        BOOL result = [data boolValue];
        if (result) {
            [HUD showMessage:MultilingualTranslation(@"修改成功") inView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [HUD showMessage:MultilingualTranslation(@"操作失败") inView:self.view];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        @strongify(self)
        
        if (code == Auth_Login_SecurityCode_Has_Set_Error_Code || code == Auth_Login_SecurityCode_No_Set_Error_Code || code == Auth_Login_SecurityCode_Format_Error_Code || code == Auth_Login_SecurityCode_otherFormat_Error_Code) {
            return;
        } else {
            [HUD showMessageWithCode:code errorMsg:msg inView:self.view];
        }
    }];
}

#pragma mark - Lazy
- (MainInputTextView *)originSafeCodeInput {
    if (!_originSafeCodeInput) {
        _originSafeCodeInput = [[MainInputTextView alloc] init];
        _originSafeCodeInput.clipsToBounds = YES;
        _originSafeCodeInput.isPassword = YES;
        _originSafeCodeInput.isShowBoard = NO;
        _originSafeCodeInput.placeholderText = MultilingualTranslation(@"请输入原安全码");
        _originSafeCodeInput.bgViewBackColor = @[COLORWHITE, COLOR_F5F6F9_DARK];
        _originSafeCodeInput.inputText.keyboardType = UIKeyboardTypeASCIICapable;
      
        if (@available(iOS 12.0, *)) {
            _originSafeCodeInput.inputText.textContentType = UITextContentTypeOneTimeCode;
        } else {
            // Fallback on earlier versions
        }
        _originSafeCodeInput.inputType = ZMessageInputViewTypePassword;
        _originSafeCodeInput.tipsImgName = @"";
    }
    return _originSafeCodeInput;
}

- (UILabel *)originSafeCodeInputTipsLbl {
    if (!_originSafeCodeInputTipsLbl) {
        _originSafeCodeInputTipsLbl = [[UILabel alloc] init];
        _originSafeCodeInputTipsLbl.text = MultilingualTranslation(@"请输入6位包含字母、数字的安全码");
        _originSafeCodeInputTipsLbl.tkThemetextColors = @[COLOR_FF3333, COLOR_FF3333_DARK];
        _originSafeCodeInputTipsLbl.font = FONTN(12);
        _originSafeCodeInputTipsLbl.textAlignment = NSTextAlignmentLeft;
        _originSafeCodeInputTipsLbl.hidden = YES;
    }
    return _originSafeCodeInputTipsLbl;
}

- (MainInputTextView *)freshSafeCodeInput {
    if (!_freshSafeCodeInput) {
        _freshSafeCodeInput = [[MainInputTextView alloc] init];
        _freshSafeCodeInput.isPassword = YES;
        _freshSafeCodeInput.isShowBoard = NO;
        _freshSafeCodeInput.placeholderText = MultilingualTranslation(@"请输入新安全码");
        _freshSafeCodeInput.bgViewBackColor = @[COLORWHITE, COLOR_F5F6F9_DARK];
        _freshSafeCodeInput.inputText.keyboardType = UIKeyboardTypeASCIICapable;
        if (@available(iOS 12.0, *)) {
            _freshSafeCodeInput.inputText.textContentType = UITextContentTypeOneTimeCode;
        } else {
            // Fallback on earlier versions
        }
        _freshSafeCodeInput.inputType = ZMessageInputViewTypePassword;
        _freshSafeCodeInput.tipsImgName = @"";
    }
    return _freshSafeCodeInput;
}

- (UILabel *)freshSafeCodeInputTipsLbl {
    if (!_freshSafeCodeInputTipsLbl) {
        _freshSafeCodeInputTipsLbl = [[UILabel alloc] init];
        _freshSafeCodeInputTipsLbl.text = MultilingualTranslation(@"请输入6位包含字母、数字的安全码");
        _freshSafeCodeInputTipsLbl.tkThemetextColors = @[COLOR_FF3333, COLOR_FF3333_DARK];
        _freshSafeCodeInputTipsLbl.font = FONTN(12);
        _freshSafeCodeInputTipsLbl.textAlignment = NSTextAlignmentLeft;
        _freshSafeCodeInputTipsLbl.hidden = YES;
    }
    return _freshSafeCodeInputTipsLbl;
}

- (MainInputTextView *)confimFreshSafeCodeInput {
    if (!_confimFreshSafeCodeInput) {
        _confimFreshSafeCodeInput = [[MainInputTextView alloc] init];
        _confimFreshSafeCodeInput.isPassword = YES;
        _confimFreshSafeCodeInput.isShowBoard = NO;
        _confimFreshSafeCodeInput.placeholderText = MultilingualTranslation(@"请再次输入新安全码");
        _confimFreshSafeCodeInput.bgViewBackColor = @[COLORWHITE, COLOR_F5F6F9_DARK];
        _confimFreshSafeCodeInput.inputText.keyboardType = UIKeyboardTypeASCIICapable;
        if (@available(iOS 12.0, *)) {
            _confimFreshSafeCodeInput.inputText.textContentType = UITextContentTypeOneTimeCode;
        } else {
            // Fallback on earlier versions
        }
        _confimFreshSafeCodeInput.inputType = ZMessageInputViewTypePassword;
        _confimFreshSafeCodeInput.tipsImgName = @"";
    }
    return _confimFreshSafeCodeInput;
}

- (UILabel *)confimFreshSafeCodeInputTipsLbl {
    if (!_confimFreshSafeCodeInputTipsLbl) {
        _confimFreshSafeCodeInputTipsLbl = [[UILabel alloc] init];
        _confimFreshSafeCodeInputTipsLbl.text = MultilingualTranslation(@"两次安全码需保持一致");
        _confimFreshSafeCodeInputTipsLbl.tkThemetextColors = @[COLOR_FF3333, COLOR_FF3333_DARK];
        _confimFreshSafeCodeInputTipsLbl.font = FONTN(12);
        _confimFreshSafeCodeInputTipsLbl.textAlignment = NSTextAlignmentLeft;
        _confimFreshSafeCodeInputTipsLbl.hidden = YES;
    }
    return _confimFreshSafeCodeInputTipsLbl;
}

@end
