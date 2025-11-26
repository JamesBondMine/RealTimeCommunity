//
//  LoginProxyInputViewViewController.m
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/11/8.
//

#import "LoginProxyInputViewViewController.h"
#import "ZToolManager.h"
#import "LXChatEncrypt.h"

@interface LoginProxyInputViewViewController () <UITextFieldDelegate>

// 数据
@property (nonatomic, assign) ProxyType currentType;
@property (nonatomic, strong) ZProxySettings *currentSettings;

// XIB 连接的 UI 控件（需要在 XIB 中创建并连接）
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;     // 滚动视图（新增）
@property (weak, nonatomic) IBOutlet UITextField *addressField;    // 地址输入框
@property (weak, nonatomic) IBOutlet UITextField *portField;       // 端口输入框
@property (weak, nonatomic) IBOutlet UITextField *userNameField;   // 用户名输入框
@property (weak, nonatomic) IBOutlet UITextField *passWordField;   // 密码输入框
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;        // 完成按钮
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;           // 测试连接按钮
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;          // 标题标签
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;        // 地址标签
@property (weak, nonatomic) IBOutlet UILabel *portLabel;           // 端口标签
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;       // 用户名标签
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;       // 密码标签

// 当前激活的输入框
@property (nonatomic, weak) UITextField *activeTextField;

@end

@implementation LoginProxyInputViewViewController

#pragma mark - 初始化

- (instancetype)initWithProxyType:(ProxyType)proxyType {
    self = [super initWithNibName:@"LoginProxyInputViewViewController" bundle:nil];
    if (self) {
        self.currentType = proxyType;
        // 加载已保存的设置
        ZProxySettings *setting = [[MMKV defaultMMKV] getObjectOfClass:[ZProxySettings class] 
                                                                 forKey:proxyType == ProxyTypeHTTP ? HTTP_PROXY_KEY : SOCKS_PROXY_KEY];
        self.currentSettings = setting ?: [ZProxySettings new];
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navTitleStr = self.currentType == ProxyTypeHTTP ? MultilingualTranslation(@"使用HTTP代理") : @"SOCKS5";
    
    // 设置背景色
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    
    // 设置导航栏
    [self setupNavigationBar];
    
    // 配置UI
    [self configureUI];
    
    // 监听键盘
    [self registerKeyboardNotifications];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 如果是返回（非完成），执行取消回调
    if (self.isMovingFromParentViewController && self.cancleCallback) {
        self.cancleCallback();
    }
}

#pragma mark - 导航栏设置

- (void)setupNavigationBar {
    // 使用基类提供的右侧按钮
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:MultilingualTranslation(@"完成") forState:UIControlStateNormal];
    [self.navBtnRight setTkThemeTitleColor:@[COLOR_4791FF, COLOR_4791FF_DARK] forState:UIControlStateNormal];
    [self.navBtnRight setTkThemeTitleColor:@[[COLOR_4791FF colorWithAlphaComponent:0.5], [COLOR_4791FF_DARK colorWithAlphaComponent:0.5]] forState:UIControlStateDisabled];
    self.navBtnRight.titleLabel.font = FONTB(16);
    self.navBtnRight.enabled = NO; // 初始禁用，等输入后启用
    
    // 保存引用以便后续更新状态
    self.completeBtn = self.navBtnRight;
}

#pragma mark - UI 配置

- (void)configureUI {
    // 配置标题标签（通过 XIB 连接）
    if (self.titleLabel) {
        self.titleLabel.text = self.currentType == ProxyTypeHTTP ? MultilingualTranslation(@"使用HTTP代理") : @"SOCKS5";
        self.titleLabel.font = FONTB(18);
        self.titleLabel.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
    }
    
    // 配置标签文字和样式
    if (self.addressLabel) {
        self.addressLabel.attributedText = [self createHighlightedLabelTextWith:MultilingualTranslation(@"*地址") keyword:@"*"];
    }
    if (self.portLabel) {
        self.portLabel.attributedText = [self createHighlightedLabelTextWith:MultilingualTranslation(@"*端口") keyword:@"*"];
    }
    if (self.usernameLabel) {
        self.usernameLabel.attributedText = [self createHighlightedLabelTextWith:MultilingualTranslation(@"用户名") keyword:@"*"];
    }
    if (self.passwordLabel) {
        self.passwordLabel.attributedText = [self createHighlightedLabelTextWith:MultilingualTranslation(@"密码") keyword:@"*"];
    }
    
    // 配置输入框
    [self configureTextField:self.addressField 
                 placeholder:MultilingualTranslation(@"请输入") 
                        text:self.currentSettings.address
                keyboardType:UIKeyboardTypeDefault];
    
    [self configureTextField:self.portField 
                 placeholder:MultilingualTranslation(@"请输入") 
                        text:self.currentSettings.port
                keyboardType:UIKeyboardTypeNumberPad];
    
    [self configureTextField:self.userNameField 
                 placeholder:MultilingualTranslation(@"选填") 
                        text:self.currentSettings.username
                keyboardType:UIKeyboardTypeDefault];
    
    [self configureTextField:self.passWordField 
                 placeholder:MultilingualTranslation(@"选填") 
                        text:self.currentSettings.password
                keyboardType:UIKeyboardTypeDefault];
    
    // 配置测试连接按钮
    if (self.checkBtn) {
        [self.checkBtn setTitle:MultilingualTranslation(@"测试连接") forState:UIControlStateNormal];
        [self.checkBtn setTkThemeTitleColor:@[COLOR_4791FF, COLOR_4791FF_DARK] forState:UIControlStateNormal];
        self.checkBtn.titleLabel.font = FONTR(16);
        [self.checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 检查初始状态
    [self checkTextFieldStatus];
}

- (void)configureTextField:(UITextField *)textField 
               placeholder:(NSString *)placeholder 
                      text:(NSString *)text 
              keyboardType:(UIKeyboardType)keyboardType {
    if (!textField) return;
    
    textField.font = FONTN(15);
    textField.placeholder = placeholder;
    textField.text = text;
    textField.keyboardType = keyboardType;
    textField.tkThemetextColors = @[COLOR_33, COLORWHITE];
    textField.delegate = self; // 设置代理
    
    // 商务风格：圆角和边框
    textField.layer.cornerRadius = DWScale(6);
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = COLOR_E6E6E6.CGColor;
    
    // 设置内边距
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    textField.leftView = leftPadding;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 40)];
    textField.rightView = rightPadding;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    // 监听输入变化
    [textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 键盘通知

- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // 获取键盘高度和动画时长
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 调整 ScrollView 的 contentInset，为键盘留出空间
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboardHeight - DHomeBarH;
    
    UIEdgeInsets scrollIndicatorInsets = self.scrollView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = keyboardHeight - DHomeBarH;
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0
                        options:([curve integerValue] << 16)
                     animations:^{
        self.scrollView.contentInset = contentInset;
        self.scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
        
        // 如果有激活的输入框，滚动到可见位置
        if (self.activeTextField) {
            CGRect textFieldFrame = [self.activeTextField convertRect:self.activeTextField.bounds toView:self.scrollView];
            CGFloat visibleHeight = self.scrollView.frame.size.height - keyboardHeight + DHomeBarH;
            
            // 如果输入框被键盘遮挡，滚动到合适位置
            if (textFieldFrame.origin.y + textFieldFrame.size.height > visibleHeight) {
                CGPoint scrollPoint = CGPointMake(0, textFieldFrame.origin.y - visibleHeight + textFieldFrame.size.height + 20);
                [self.scrollView setContentOffset:scrollPoint animated:NO];
            }
        }
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    // 获取动画时长和曲线
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 恢复 ScrollView 的 contentInset
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = 0;
    
    UIEdgeInsets scrollIndicatorInsets = self.scrollView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = 0;
    
    [UIView animateWithDuration:[duration doubleValue]
                          delay:0
                        options:([curve integerValue] << 16)
                     animations:^{
        self.scrollView.contentInset = contentInset;
        self.scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    } completion:nil];
}

#pragma mark - 交互事件

// 重写基类方法
- (void)navBtnRightClicked {
    [self completeBtnClick];
}

- (void)completeBtnClick {
    // 保存设置
    ZProxySettings *setting = [ZProxySettings new];
    setting.address = self.addressField.text;
    setting.port = self.portField.text;
    setting.username = self.userNameField.text;
    setting.password = self.passWordField.text;
    
    [[MMKV defaultMMKV] setObject:setting forKey:self.currentType == ProxyTypeHTTP ? HTTP_PROXY_KEY : SOCKS_PROXY_KEY];
    
    // 返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkBtnClick {
    if (self.addressField.text.length > 0 && self.portField.text.length > 0) {
        // 创建临时设置进行测试
        self.currentSettings = [ZProxySettings new];
        self.currentSettings.address = self.addressField.text;
        self.currentSettings.port = self.portField.text;
        self.currentSettings.username = self.userNameField.text;
        self.currentSettings.password = self.passWordField.text;
        [self checkProxy];
    } else {
        [HUD showMessage:MultilingualTranslation(@"访问失败,请检查网络设置")];
    }
}

- (void)checkProxy {
    [HUD showActivityMessage:@""];
    [self filtrateNetWorkWithUrl:@"http://www.baidu.com" compelete:^(NSInteger code, NSString *msg, NSData *data, NSString *traceId) {
        if (code == 200) {
            [HUD showMessage:MultilingualTranslation(@"校验通过")];
        } else {
            [HUD showMessage:MultilingualTranslation(@"访问失败,请检查网络设置")];
        }
    }];
}

#pragma mark - 输入框状态检查

- (void)textFieldDidChange {
    [self checkTextFieldStatus];
}

- (void)checkTextFieldStatus {
    // 地址和端口必填，才能启用完成按钮
    if (self.addressField.text.length > 0 && self.portField.text.length > 0) {
        self.completeBtn.enabled = YES;
    } else {
        self.completeBtn.enabled = NO;
    }
}

#pragma mark - 网络测试

- (void)filtrateNetWorkWithUrl:(NSString *)urlStr compelete:(void(^)(NSInteger code, NSString *msg, NSData *data, NSString *traceId))compelete {
    ProxyType currentType = self.currentType;
    
    NSString *traceId = [[LingIMManagerTool sharedManager] getMessageID];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    config.URLCache = nil;
    
    if (currentType == ProxyTypeHTTP) {
        ZProxySettings *setting = self.currentSettings;
        config.connectionProxyDictionary = @{
            // 开启 HTTP 代理
            (__bridge id)kCFNetworkProxiesHTTPEnable: @YES,
            // 代理服务器地址和端口
            (__bridge id)kCFNetworkProxiesHTTPProxy: setting.address,
            (__bridge id)kCFNetworkProxiesHTTPPort: @([setting.port intValue]),
            // 代理认证（可选）
            (__bridge id)kCFProxyUsernameKey: setting.username,
            (__bridge id)kCFProxyPasswordKey: setting.password
        };
    } else if (currentType == ProxyTypeSOCKS5) {
        ZProxySettings *setting = self.currentSettings;
        config.connectionProxyDictionary = @{
            (__bridge NSString *)kCFStreamPropertySOCKSProxyHost: setting.address,
            (__bridge NSString *)kCFStreamPropertySOCKSProxyPort: @([setting.port intValue]),
            (__bridge NSString *)kCFStreamPropertySOCKSUser: setting.username,
            (__bridge NSString *)kCFStreamPropertySOCKSPassword: setting.password
        };
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error == nil && (long)httpResponse.statusCode == 200) {
            compelete(httpResponse.statusCode, @"-", data, traceId);
        } else {
            if (error == nil) {
                compelete(httpResponse.statusCode, @"", nil, traceId);
            } else {
                NSString *errorDescription = [NSString isNil:[error localizedDescription]] ? @"-" : [error localizedDescription];
                compelete(error.code, errorDescription, nil, traceId);
            }
        }
    }];
    [dataTask resume];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 记录当前激活的输入框
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 清除激活的输入框记录
    if (self.activeTextField == textField) {
        self.activeTextField = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 点击键盘的返回键，收起键盘
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 辅助方法

// 创建带高亮文本的 AttributedString
- (NSAttributedString *)createHighlightedLabelTextWith:(NSString *)text keyword:(NSString *)keyword {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_33
                             range:NSMakeRange(0, text.length)];
    
    NSRange searchRange = NSMakeRange(0, text.length);
    while (YES) {
        NSRange foundRange = [text rangeOfString:keyword
                                         options:0
                                           range:searchRange];
        if (foundRange.location == NSNotFound) break;
        
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:COLOR_F81205
                                 range:foundRange];
        
        searchRange.location = foundRange.location + foundRange.length;
        searchRange.length = text.length - searchRange.location;
    }
    
    return attributedString;
}

@end
