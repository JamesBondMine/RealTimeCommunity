//
//  LoginServerConfigView.m
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/10/29.
//

#import "LoginServerConfigView.h"
#import "MainInputTextView.h"
#import "ZToolManager.h"
#import "ZQRcodeScanViewController.h"

typedef NS_ENUM(NSInteger, ServerConfigType) {
    ServerConfigTypeCompanyId = 0,  // 企业号
    ServerConfigTypeIPDomain = 1    // IP直连
};

@interface LoginServerConfigView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) ServerConfigType configType;

// 切换按钮
@property (nonatomic, strong) UIButton *companyIdBtn;
@property (nonatomic, strong) UIButton *ipDomainBtn;
@property (nonatomic, strong) UIView *bottomLine;

// 输入框
@property (nonatomic, strong) MainInputTextView *companyIdInputView;
@property (nonatomic, strong) MainInputTextView *ipDomainHostInputView;
@property (nonatomic, strong) MainInputTextView *ipDomainPortInputView;
@property (nonatomic, strong) UILabel *colonLbl;

// 确定按钮
@property (nonatomic, strong) UIButton *confirmButton;

// 扫一扫按钮
@property (nonatomic, strong) UIButton *scanButton;

// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

// 标记是否正在扫码
@property (nonatomic, assign) BOOL isScanning;

@end

@implementation LoginServerConfigView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self setupNotifications];
    }
    return self;
}

- (void)setupUI {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    // 容器视图（背景遮罩）
    _containerView = [[UIView alloc] initWithFrame:self.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    [_containerView addGestureRecognizer:tap];
    [self addSubview:_containerView];
    
    // 内容视图
    _contentView = [[UIView alloc] init];
    _contentView.tkThemebackgroundColors = @[COLOR_FAFAFA, COLOR_FF3333];
    _contentView.layer.cornerRadius = DWScale(16);
    _contentView.layer.masksToBounds = YES;
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(DStatusBarH + DWScale(80)); // 往上移动，距离顶部有一定间距
        make.leading.equalTo(self).offset(DWScale(40));
        make.trailing.equalTo(self).offset(-DWScale(40));
    }];
    
    // 标题
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = MultilingualTranslation(@"服务器配置");
    titleLab.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    titleLab.font = FONTB(20);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(DWScale(24));
        make.leading.equalTo(_contentView).offset(DWScale(20));
        make.trailing.equalTo(_contentView).offset(-DWScale(20));
    }];
    
    // 关闭按钮
    [_contentView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(DWScale(16));
        make.trailing.equalTo(_contentView).offset(-DWScale(16));
        make.width.height.mas_equalTo(DWScale(32));
    }];
    
    // 企业号按钮
    [_contentView addSubview:self.companyIdBtn];
    [self.companyIdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_contentView).offset(DWScale(30));
        make.top.equalTo(titleLab.mas_bottom).offset(DWScale(30));
        make.width.mas_equalTo(DWScale(95));
        make.height.mas_equalTo(DWScale(28));
    }];
    
    // IP/域名按钮
    [_contentView addSubview:self.ipDomainBtn];
    [self.ipDomainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.companyIdBtn.mas_trailing).offset(DWScale(25));
        make.top.equalTo(titleLab.mas_bottom).offset(DWScale(30));
        make.width.mas_equalTo(DWScale(95));
        make.height.mas_equalTo(DWScale(28));
    }];
    
    // 底部指示线
    [_contentView addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.companyIdBtn);
        make.top.equalTo(self.companyIdBtn.mas_bottom).offset(DWScale(2));
        make.width.mas_equalTo(DWScale(36));
        make.height.mas_equalTo(DWScale(3));
    }];
    
    // 企业号输入框
    [_contentView addSubview:self.companyIdInputView];
    [self.companyIdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).offset(DWScale(27));
        make.leading.equalTo(_contentView).offset(DWScale(20));
        make.trailing.equalTo(_contentView).offset(-DWScale(20));
        make.height.mas_equalTo(DWScale(46));
    }];
    
    // 先添加冒号到视图上
    [_contentView addSubview:self.colonLbl];
    
    // 端口输入框（先添加右边的）
    [_contentView addSubview:self.ipDomainPortInputView];
    [self.ipDomainPortInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).offset(DWScale(27));
        make.trailing.equalTo(_contentView).offset(-DWScale(20));
        make.width.mas_equalTo(DWScale(95));
        make.height.mas_equalTo(DWScale(46));
    }];
    
    // 冒号约束
    [self.colonLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ipDomainPortInputView);
        make.trailing.equalTo(self.ipDomainPortInputView.mas_leading);
        make.width.mas_equalTo(DWScale(16));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    // IP/域名输入框（最后添加左边的）
    [_contentView addSubview:self.ipDomainHostInputView];
    [self.ipDomainHostInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom).offset(DWScale(27));
        make.leading.equalTo(_contentView).offset(DWScale(20));
        make.trailing.equalTo(self.colonLbl.mas_leading);
        make.height.mas_equalTo(DWScale(46));
    }];
    
    // 扫一扫按钮
    [_contentView addSubview:self.scanButton];
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.companyIdInputView.mas_bottom).offset(DWScale(16));
        make.centerX.equalTo(_contentView);
        make.height.mas_equalTo(DWScale(32));
    }];
    
    // 确定按钮
    [_contentView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scanButton.mas_bottom).offset(DWScale(16));
        make.leading.equalTo(_contentView).offset(DWScale(20));
        make.trailing.equalTo(_contentView).offset(-DWScale(20));
        make.height.mas_equalTo(DWScale(48));
        make.bottom.equalTo(_contentView).offset(-DWScale(24));
    }];
    
    // 默认选中企业号
    self.configType = ServerConfigTypeCompanyId;
    self.companyIdInputView.hidden = NO;
    self.ipDomainHostInputView.hidden = YES;
    self.ipDomainPortInputView.hidden = YES;
    self.colonLbl.hidden = YES;
    
    WeakSelf
    [self.companyIdInputView setTextFieldEndInput:^{
        [weakSelf checkConfirmButtonAvailable];
    }];
    [self.ipDomainHostInputView setTextFieldEndInput:^{
        [weakSelf checkConfirmButtonAvailable];
    }];
}

- (void)setupNotifications {
    // 监听竞速/直连结果
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(netWorkNodeRacingAndIpDomainConectResult:) 
                                                 name:@"AppSsoRacingAndIpDomainConectResultNotification" 
                                               object:nil];
}

#pragma mark - Public Methods

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    // 动画显示
    _contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
        self.contentView.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.contentView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Actions

- (void)backgroundTapped {
    [self dismiss];
}

- (void)closeButtonTapped {
    [self dismiss];
}

- (void)switchTypeAction:(UIButton *)btn {
    if (btn.tag == ServerConfigTypeCompanyId) {
        self.configType = ServerConfigTypeCompanyId;
        
        self.companyIdBtn.selected = YES;
        self.companyIdBtn.titleLabel.font = FONTN(18);
        self.ipDomainBtn.selected = NO;
        self.ipDomainBtn.titleLabel.font = FONTN(16);
        
        self.companyIdInputView.hidden = NO;
        self.ipDomainHostInputView.hidden = YES;
        self.ipDomainPortInputView.hidden = YES;
        self.colonLbl.hidden = YES;
        
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.companyIdBtn);
            make.top.equalTo(self.companyIdBtn.mas_bottom).offset(DWScale(2));
            make.width.mas_equalTo(DWScale(36));
            make.height.mas_equalTo(DWScale(3));
        }];
    } else {
        self.configType = ServerConfigTypeIPDomain;
        
        self.ipDomainBtn.selected = YES;
        self.ipDomainBtn.titleLabel.font = FONTN(18);
        self.companyIdBtn.selected = NO;
        self.companyIdBtn.titleLabel.font = FONTN(16);
        
        self.companyIdInputView.hidden = YES;
        self.ipDomainHostInputView.hidden = NO;
        self.ipDomainPortInputView.hidden = NO;
        self.colonLbl.hidden = NO;
        
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.ipDomainBtn);
            make.top.equalTo(self.ipDomainBtn.mas_bottom).offset(DWScale(2));
            make.width.mas_equalTo(DWScale(36));
            make.height.mas_equalTo(DWScale(3));
        }];
    }
    
    [self checkConfirmButtonAvailable];
}

- (void)confirmAction {
    @try {
        if (self.configType == ServerConfigTypeCompanyId) {
            if (self.companyIdInputView.isEmpty) {
                [HUD showMessage:MultilingualTranslation(@"企业号错误")];
                return;
            }
            [HUD showActivityMessage:@""];
            // 清除旧的企业号信息，保持最初状态
            [self clearAllServerInfo:^{                // 保存企业号并开始竞速
                [self saveUserInputCompanyIdSSoInfo:[self.companyIdInputView.inputText.text lowercaseString]];
//                [HUD hideHUD];
            }];
        } else {
            if (self.ipDomainHostInputView.isEmpty) {
                [HUD showMessage:MultilingualTranslation(@"域名错误")];
                return;
            }
            
            // 清除旧的IP/域名信息，保持最初状态
            [HUD showActivityMessage:@""];
            [self clearAllServerInfo:^{
                // 保存IP/域名并开始直连
                NSString *ipDomainPortStr = self.ipDomainHostInputView.inputText.text;
                if (![NSString isNil:self.ipDomainPortInputView.inputText.text]) {
                    ipDomainPortStr = [NSString stringWithFormat:@"%@:%@", self.ipDomainHostInputView.inputText.text, self.ipDomainPortInputView.inputText.text];
                }
                [self saveUserInputIPAndDomainSSoInfo:ipDomainPortStr];
                self.confirmButton.enabled = NO; // 按钮防连点
                [HUD hideHUD];
            }];
        }
    } @catch (NSException *exception) {
        [HUD hideHUD];
    } @finally {
        [HUD hideHUD];
    }
}

// 扫一扫按钮点击
- (void)ssoInpfoScanAction {
    // 获取当前的 navigation controller
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *navVC = nil;
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        navVC = (UINavigationController *)rootVC;
    } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabVC = (UITabBarController *)rootVC;
        if ([tabVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            navVC = (UINavigationController *)tabVC.selectedViewController;
        }
    }
    
    if (!navVC) {
        [HUD showMessage:@"无法打开扫码页面"];
        return;
    }
    
    // 临时隐藏弹窗，避免遮挡扫码页面
    self.hidden = YES;
    self.isScanning = YES;
    
    // 企业号扫一扫
    ZQRcodeScanViewController *vc = [[ZQRcodeScanViewController alloc] init];
    vc.isRacing = YES;
    
    // 记录当前的 view controller 数量
    NSInteger beforeCount = navVC.viewControllers.count;
    
    [navVC pushViewController:vc animated:YES];
    
    WeakSelf
    [vc setQRcodeSacnLicenseBlock:^(NSString * _Nonnull liceseId, NSString * _Nonnull ipDomainPort) {
        // 标记扫码完成
        weakSelf.isScanning = NO;
        // 重新显示弹窗
        weakSelf.hidden = NO;
        // 扫码后结果处理
        [weakSelf qrcodeScanResultHandlerWithLiceseId:liceseId ipDomainPort:ipDomainPort];
    }];
    
    [vc setQRcodeSacnNavBlock:^(IMServerListResponseBody * _Nonnull model, NSString *appKey) {
        // 标记扫码完成
        weakSelf.isScanning = NO;
        // 重新显示弹窗
        weakSelf.hidden = NO;
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
    
    // 延迟检查扫码页面是否还在栈中，如果用户返回了就重新显示弹窗
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf checkScanViewControllerStatus:navVC beforeCount:beforeCount];
    });
}

// 检查扫码页面状态
- (void)checkScanViewControllerStatus:(UINavigationController *)navVC beforeCount:(NSInteger)beforeCount {
    if (!self.isScanning) {
        return; // 已经扫码完成，不需要再检查
    }
    
    // 检查扫码页面是否还在栈中
    NSInteger currentCount = navVC.viewControllers.count;
    if (currentCount <= beforeCount) {
        // 扫码页面已经被 pop，用户取消了扫码
        self.isScanning = NO;
        self.hidden = NO;
    } else {
        // 扫码页面还在，继续检查
        WeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf checkScanViewControllerStatus:navVC beforeCount:beforeCount];
        });
    }
}

// 扫码结果处理
- (void)qrcodeScanResultHandlerWithLiceseId:(NSString *)liceseId ipDomainPort:(NSString *)ipDomainPortStr {
    if (![NSString isNil:liceseId] && ipDomainPortStr.length <= 0) {
        // 扫到企业号
        self.configType = ServerConfigTypeCompanyId;
        self.companyIdBtn.selected = YES;
        self.companyIdBtn.titleLabel.font = FONTN(18);
        self.ipDomainBtn.selected = NO;
        self.ipDomainBtn.titleLabel.font = FONTN(16);
        
        self.companyIdInputView.hidden = NO;
        self.ipDomainHostInputView.hidden = YES;
        self.ipDomainPortInputView.hidden = YES;
        self.colonLbl.hidden = YES;
        
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.companyIdBtn);
            make.top.equalTo(self.companyIdBtn.mas_bottom).offset(DWScale(2));
            make.width.mas_equalTo(DWScale(36));
            make.height.mas_equalTo(DWScale(3));
        }];
        
        self.companyIdInputView.preInputText = liceseId;
        [HUD showActivityMessage:@""];
        [self checkConfirmButtonAvailable];
        [self saveUserInputCompanyIdSSoInfo:liceseId];
    }
    
    if (![NSString isNil:ipDomainPortStr] && liceseId.length <= 0) {
        // 扫到IP/域名
        self.configType = ServerConfigTypeIPDomain;
        self.ipDomainBtn.selected = YES;
        self.ipDomainBtn.titleLabel.font = FONTN(18);
        self.companyIdBtn.selected = NO;
        self.companyIdBtn.titleLabel.font = FONTN(16);
        
        self.companyIdInputView.hidden = YES;
        self.ipDomainHostInputView.hidden = NO;
        self.ipDomainPortInputView.hidden = NO;
        self.colonLbl.hidden = NO;
        
        [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.ipDomainBtn);
            make.top.equalTo(self.ipDomainBtn.mas_bottom).offset(DWScale(2));
            make.width.mas_equalTo(DWScale(36));
            make.height.mas_equalTo(DWScale(3));
        }];
        
        NSString *resultIpDomainPort = [ipDomainPortStr stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        resultIpDomainPort = [resultIpDomainPort stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        
        NSArray *array = [resultIpDomainPort componentsSeparatedByString:@":"];
        if (array.count > 1) {
            self.ipDomainHostInputView.inputText.text = array[0];
            self.ipDomainPortInputView.inputText.text = array[1];
        } else {
            self.ipDomainHostInputView.inputText.text = resultIpDomainPort;
        }
        
        [HUD showActivityMessage:@""];
        [self checkConfirmButtonAvailable];
        [self saveUserInputIPAndDomainSSoInfo:resultIpDomainPort];
    }
}

#pragma mark - Private Methods

// 清除所有服务器信息，保持最初状态
- (void)clearAllServerInfo:(void(^)(void))completion {
    
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
    
    // 5. 执行回调（延迟3秒）
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

// 检查输入框是否有内容，确定按钮是否可点击
- (void)checkConfirmButtonAvailable {
    BOOL isAvailable = NO;
    
    if (self.configType == ServerConfigTypeCompanyId) {
        isAvailable = self.companyIdInputView.textLength > 0;
    } else {
        isAvailable = self.ipDomainHostInputView.textLength > 0;
    }
    
    self.confirmButton.enabled = isAvailable;
    if (isAvailable) {
        self.confirmButton.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF_DARK];
    } else {
        self.confirmButton.tkThemebackgroundColors = @[[COLOR_81D8CF colorWithAlphaComponent:0.3], [COLOR_81D8CF_DARK colorWithAlphaComponent:0.3]];
    }
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

#pragma mark - Notification

// SSO竞速结果 或者 IP/Domain直连 结果
- (void)netWorkNodeRacingAndIpDomainConectResult:(NSNotification *)notification {
    WeakSelf
    [ZTOOL doInMain:^{
        weakSelf.confirmButton.enabled = YES;
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
            [weakSelf dismiss];
            if (weakSelf.configCompleteBlock) {
                // 回调时传递企业号和IP/域名信息
                NSString *companyId = ![NSString isNil:tempSsoModel.liceseId] ? tempSsoModel.liceseId : nil;
                NSString *ipDomain = ![NSString isNil:tempSsoModel.ipDomainPortStr] ? tempSsoModel.ipDomainPortStr : nil;
                weakSelf.configCompleteBlock(companyId, ipDomain);
            }
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

#pragma mark - Lazy Load

- (UIButton *)companyIdBtn {
    if (!_companyIdBtn) {
        _companyIdBtn = [[UIButton alloc] init];
        [_companyIdBtn setTitle:MultilingualTranslation(@"企业号") forState:UIControlStateNormal];
        [_companyIdBtn setTkThemeTitleColor:@[COLOR_66, COLOR_66_DARK] forState:UIControlStateNormal];
        [_companyIdBtn setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateSelected];
        _companyIdBtn.titleLabel.font = FONTN(18);
        _companyIdBtn.selected = YES;
        _companyIdBtn.tag = ServerConfigTypeCompanyId;
        [_companyIdBtn addTarget:self action:@selector(switchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _companyIdBtn;
}

- (UIButton *)ipDomainBtn {
    if (!_ipDomainBtn) {
        _ipDomainBtn = [[UIButton alloc] init];
        [_ipDomainBtn setTitle:MultilingualTranslation(@"IP/域名") forState:UIControlStateNormal];
        [_ipDomainBtn setTkThemeTitleColor:@[COLOR_66, COLOR_66_DARK] forState:UIControlStateNormal];
        [_ipDomainBtn setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateSelected];
        _ipDomainBtn.titleLabel.font = FONTN(16);
        _ipDomainBtn.selected = NO;
        _ipDomainBtn.tag = ServerConfigTypeIPDomain;
        [_ipDomainBtn addTarget:self action:@selector(switchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ipDomainBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF_DARK];
    }
    return _bottomLine;
}

- (MainInputTextView *)companyIdInputView {
    if (!_companyIdInputView) {
        _companyIdInputView = [[MainInputTextView alloc] init];
        _companyIdInputView.placeholderText = MultilingualTranslation(@"请输入企业号");
        _companyIdInputView.inputType = ZMessageInputViewTypeNoCancel;
        _companyIdInputView.tipsImgName = @"img_sso_input_tip_reb";
        _companyIdInputView.hidden = NO;
        _companyIdInputView.isSSO = YES;
        _companyIdInputView.inputKeyBoardType = UIKeyboardTypeASCIICapable;
    }
    return _companyIdInputView;
}

- (MainInputTextView *)ipDomainHostInputView {
    if (!_ipDomainHostInputView) {
        _ipDomainHostInputView = [[MainInputTextView alloc] init];
        _ipDomainHostInputView.placeholderText = MultilingualTranslation(@"IP/域名");
        _ipDomainHostInputView.inputType = ZMessageInputViewTypeNoCancel;
        _ipDomainHostInputView.tipsImgName = @"img_sso_input_tip_reb";
        _ipDomainHostInputView.hidden = YES;
        _ipDomainHostInputView.inputKeyBoardType = UIKeyboardTypeASCIICapable;
    }
    return _ipDomainHostInputView;
}

- (MainInputTextView *)ipDomainPortInputView {
    if (!_ipDomainPortInputView) {
        _ipDomainPortInputView = [[MainInputTextView alloc] init];
        _ipDomainPortInputView.placeholderText = MultilingualTranslation(@"端口号");
        _ipDomainPortInputView.inputKeyBoardType = UIKeyboardTypeNumberPad;
        _ipDomainPortInputView.inputType = ZMessageInputViewTypeNoCancel;
        _ipDomainPortInputView.tipsImgName = @"";
        _ipDomainPortInputView.hidden = YES;
    }
    return _ipDomainPortInputView;
}

- (UILabel *)colonLbl {
    if (!_colonLbl) {
        _colonLbl = [[UILabel alloc] init];
        _colonLbl.text = @":";
        _colonLbl.tkThemetextColors = @[COLOR_00, COLOR_00_DARK];
        _colonLbl.font = FONTN(16);
        _colonLbl.textAlignment = NSTextAlignmentCenter;
        _colonLbl.hidden = YES;
    }
    return _colonLbl;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        _scanButton = [[UIButton alloc] init];
        [_scanButton setTitle:MultilingualTranslation(@"扫一扫加入服务器") forState:UIControlStateNormal];
        [_scanButton setImage:ImgNamed(@"relogimg_icon_sso_scan_reb") forState:UIControlStateNormal];
        [_scanButton setTitleColor:COLOR_81D8CF forState:UIControlStateNormal];
        _scanButton.titleLabel.font = FONTN(14);
        [_scanButton setBtnImageAlignmentType:ButtonImageAlignmentTypeLeft imageSpace:DWScale(10)];
        [_scanButton addTarget:self action:@selector(ssoInpfoScanAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:ImgNamed(@"relogimg_icon_sso_close_reb") forState:UIControlStateNormal];
        _closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTitle:MultilingualTranslation(@"确定") forState:UIControlStateNormal];
        [_confirmButton setTitleColor:COLORWHITE forState:UIControlStateNormal];
        _confirmButton.enabled = NO;
        _confirmButton.tkThemebackgroundColors = @[[COLOR_81D8CF colorWithAlphaComponent:0.3], [COLOR_81D8CF_DARK colorWithAlphaComponent:0.3]];
        _confirmButton.titleLabel.font = FONTN(16);
        [_confirmButton rounded:DWScale(12)];
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

