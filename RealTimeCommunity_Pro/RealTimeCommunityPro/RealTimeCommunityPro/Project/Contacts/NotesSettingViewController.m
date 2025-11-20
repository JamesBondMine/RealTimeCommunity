//
//  NotesSettingViewController.m
//  RealTimeCommunityPro
//
//  Created by LJ on 2025/11/8.
//

#import "NotesSettingViewController.h"
#import "ZToolManager.h"

@interface NotesSettingViewController () <UITextFieldDelegate, UITextViewDelegate>

// 数据
@property (nonatomic, copy) NSString *titleStr;      // 标题
@property (nonatomic, copy) NSString *remarkStr;     // 备注
@property (nonatomic, copy) NSString *desStr;        // 描述
@property (nonatomic, assign) NSInteger textViewHeightChangeIndex; // textView高度变化次数
@property (nonatomic, assign) CGFloat curTextHeight; // 记录当前text高度

// UI 组件 - 备注部分
@property (nonatomic, strong) UILabel *remarkTipLabel;           // "设置备注"标签
@property (nonatomic, strong) UIView *setRemarkBgView;           // 备注背景视图
@property (nonatomic, strong) UITextField *setRemarkTextField;   // 备注输入框
@property (nonatomic, strong) UILabel *setRemarkNumberLabel;     // 备注字数统计

// UI 组件 - 描述部分
@property (nonatomic, strong) UILabel *desTipLabel;              // "描述"标签
@property (nonatomic, strong) UIView *setDesBgView;              // 描述背景视图
@property (nonatomic, strong) UITextView *setDesTextView;        // 描述输入框
@property (nonatomic, strong) UILabel *setDesNumberLabel;        // 描述字数统计
@property (nonatomic, strong) UILabel *textViewPlaceHolderLabel; // TextView占位符

// UI 组件 - 按钮
@property (nonatomic, strong) UIButton *saveBtn;                 // 保存按钮

@end

@implementation NotesSettingViewController

#pragma mark - 初始化

- (instancetype)initWithTitle:(NSString *)titleStr remark:(NSString *)remarkStr description:(NSString *)desStr {
    self = [super init];
    if (self) {
        self.titleStr = titleStr ?: @"";
        self.remarkStr = remarkStr ?: @"";
        self.desStr = desStr ?: @"";
        self.textViewHeightChangeIndex = 0;
        self.curTextHeight = 0.0;
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navTitleStr = self.titleStr;
    
    // 设置背景色
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    
    // 设置返回按钮
    [self setupNavigationBar];
    
    // 设置UI
    [self setupUI];
    
    // 监听键盘
    [self registerKeyboardNotifications];
    
    // 监听TextView变化
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(textViewDidChange) 
                                                 name:UITextViewTextDidChangeNotification 
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 自动弹出键盘
    [self.setRemarkTextField becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 导航栏设置

- (void)setupNavigationBar {
    // 左侧取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
    [cancelBtn setTkThemeTitleColor:@[COLOR_99, COLOR_99_DARK] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONTN(15);
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn sizeToFit];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelItem;
}

#pragma mark - UI布局

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DNavStatusBarH);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    // 备注标签
    _remarkTipLabel = [UILabel new];
    _remarkTipLabel.tkThemetextColors = @[COLOR_66, COLOR_CCCCCC];
    _remarkTipLabel.font = FONTR(12);
    _remarkTipLabel.text = MultilingualTranslation(@"设置备注");
    _remarkTipLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:_remarkTipLabel];
    [_remarkTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(DWScale(16));
        make.top.equalTo(contentView).offset(DWScale(20));
        make.height.mas_equalTo(DWScale(16));
    }];
    
    // 备注输入框背景
    _setRemarkBgView = [UIView new];
    _setRemarkBgView.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
    _setRemarkBgView.layer.cornerRadius = DWScale(6);
    _setRemarkBgView.layer.masksToBounds = NO;
    _setRemarkBgView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
    _setRemarkBgView.layer.shadowOffset = CGSizeMake(0, 2);
    _setRemarkBgView.layer.shadowOpacity = 0.06;
    _setRemarkBgView.layer.shadowRadius = 4;
    [contentView addSubview:_setRemarkBgView];
    [_setRemarkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(DWScale(16));
        make.top.equalTo(_remarkTipLabel.mas_bottom).offset(DWScale(8));
        make.trailing.equalTo(contentView).offset(-DWScale(16));
        make.height.mas_equalTo(DWScale(52));
    }];
    
    // 备注字数统计
    _setRemarkNumberLabel = [UILabel new];
    _setRemarkNumberLabel.tkThemetextColors = @[COLOR_99, COLOR_99];
    _setRemarkNumberLabel.font = FONTR(12);
    _setRemarkNumberLabel.textAlignment = NSTextAlignmentRight;
    _setRemarkNumberLabel.text = [NSString stringWithFormat:@"%ld/50", (long)self.remarkStr.length];
    [_setRemarkBgView addSubview:_setRemarkNumberLabel];
    [_setRemarkNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_setRemarkBgView).offset(-DWScale(16));
        make.centerY.equalTo(_setRemarkBgView);
        make.height.mas_equalTo(DWScale(17));
        make.width.mas_equalTo(44);
    }];
    
    // 备注输入框
    _setRemarkTextField = [UITextField new];
    _setRemarkTextField.tkThemetextColors = @[COLOR_33, COLORWHITE];
    _setRemarkTextField.font = FONTN(15);
    _setRemarkTextField.text = self.remarkStr;
    _setRemarkTextField.delegate = self;
    NSMutableAttributedString *placeHolderAttStr = [[NSMutableAttributedString alloc] initWithString:MultilingualTranslation(@"请填写备注") 
                                                                                          attributes:@{NSForegroundColorAttributeName: COLOR_99, NSFontAttributeName: FONTN(15)}];
    _setRemarkTextField.attributedPlaceholder = placeHolderAttStr;
    [_setRemarkBgView addSubview:_setRemarkTextField];
    [_setRemarkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_setRemarkBgView).offset(DWScale(16));
        make.centerY.equalTo(_setRemarkBgView);
        make.trailing.equalTo(_setRemarkNumberLabel.mas_leading).offset(-DWScale(8));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    // 描述标签
    _desTipLabel = [UILabel new];
    _desTipLabel.tkThemetextColors = @[COLOR_66, COLOR_CCCCCC];
    _desTipLabel.font = FONTR(12);
    _desTipLabel.text = MultilingualTranslation(@"描述");
    _desTipLabel.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:_desTipLabel];
    [_desTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(DWScale(16));
        make.top.equalTo(_setRemarkBgView.mas_bottom).offset(DWScale(20));
        make.height.mas_equalTo(DWScale(16));
    }];
    
    // 描述输入框背景
    _setDesBgView = [UIView new];
    _setDesBgView.tkThemebackgroundColors = @[COLORWHITE, COLOR_F5F6F9_DARK];
    _setDesBgView.layer.cornerRadius = DWScale(6);
    _setDesBgView.layer.masksToBounds = NO;
    _setDesBgView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
    _setDesBgView.layer.shadowOffset = CGSizeMake(0, 2);
    _setDesBgView.layer.shadowOpacity = 0.06;
    _setDesBgView.layer.shadowRadius = 4;
    [contentView addSubview:_setDesBgView];
    [_setDesBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(DWScale(16));
        make.top.equalTo(_desTipLabel.mas_bottom).offset(DWScale(8));
        make.trailing.equalTo(contentView).offset(-DWScale(16));
        make.height.mas_equalTo(DWScale(160));
    }];
    
    // 描述字数统计
    _setDesNumberLabel = [UILabel new];
    _setDesNumberLabel.tkThemetextColors = @[COLOR_99, COLOR_99];
    _setDesNumberLabel.font = FONTR(12);
    _setDesNumberLabel.textAlignment = NSTextAlignmentRight;
    _setDesNumberLabel.text = [NSString stringWithFormat:@"%ld/200", (long)self.desStr.length];
    [_setDesBgView addSubview:_setDesNumberLabel];
    [_setDesNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(_setDesBgView).offset(-DWScale(16));
        make.bottom.equalTo(_setDesBgView).offset(-DWScale(12));
        make.height.mas_equalTo(DWScale(17));
    }];
    
    // 描述输入框
    _setDesTextView = [UITextView new];
    _setDesTextView.tkThemetextColors = @[COLOR_33, COLORWHITE];
    _setDesTextView.font = FONTN(15);
    _setDesTextView.textContainerInset = UIEdgeInsetsZero;
    _setDesTextView.textContainer.lineFragmentPadding = 0;
    _setDesTextView.text = self.desStr;
    _setDesTextView.delegate = self;
    _setDesTextView.tkThemebackgroundColors = @[[UIColor clearColor], [UIColor clearColor]];
    [_setDesBgView addSubview:_setDesTextView];
    [_setDesTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_setDesBgView).offset(DWScale(16));
        make.trailing.equalTo(_setDesBgView).offset(-DWScale(16));
        make.top.equalTo(_setDesBgView).offset(DWScale(12));
        make.bottom.equalTo(_setDesNumberLabel.mas_top).offset(-DWScale(8));
    }];
    
    // TextView占位符
    _textViewPlaceHolderLabel = [UILabel new];
    _textViewPlaceHolderLabel.tkThemetextColors = @[COLOR_99, COLOR_99];
    _textViewPlaceHolderLabel.font = FONTN(15);
    _textViewPlaceHolderLabel.text = MultilingualTranslation(@"添加描述");
    _textViewPlaceHolderLabel.hidden = (self.desStr.length > 0);
    [_setDesBgView addSubview:_textViewPlaceHolderLabel];
    [_textViewPlaceHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_setDesBgView).offset(DWScale(16));
        make.top.equalTo(_setDesBgView).offset(DWScale(12));
        make.height.mas_equalTo(DWScale(22));
    }];
    
    // 保存按钮
    _saveBtn = [[UIButton alloc] init];
    [_saveBtn setTitle:MultilingualTranslation(@"保存") forState:UIControlStateNormal];
    [_saveBtn setTitleColor:COLORWHITE forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = FONTB(16);
    _saveBtn.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF_DARK];
    [_saveBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9], [UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
    [_saveBtn setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9], [UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
    _saveBtn.layer.cornerRadius = DWScale(6);
    _saveBtn.layer.masksToBounds = NO;
    _saveBtn.layer.shadowColor = COLOR_81D8CF.CGColor;
    _saveBtn.layer.shadowOffset = CGSizeMake(0, 3);
    _saveBtn.layer.shadowOpacity = 0.25;
    _saveBtn.layer.shadowRadius = 6;
    [_saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_saveBtn];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(contentView).offset(DWScale(16));
        make.trailing.equalTo(contentView).offset(-DWScale(16));
        make.top.equalTo(_setDesBgView.mas_bottom).offset(DWScale(24));
        make.height.mas_equalTo(DWScale(50));
        make.bottom.equalTo(contentView).offset(-DWScale(30));
    }];
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
    if ([self.setRemarkTextField isFirstResponder]) {
        // 备注输入框获取焦点
    } else {
        // 描述输入框获取焦点
        self.setDesNumberLabel.text = [NSString stringWithFormat:@"%ld/200", (long)self.setDesTextView.text.length];
        self.textViewPlaceHolderLabel.hidden = YES;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.setDesNumberLabel.text = [NSString stringWithFormat:@"%ld/200", (long)self.setDesTextView.text.length];
    self.textViewPlaceHolderLabel.hidden = (self.setDesTextView.text.length > 0);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.setRemarkTextField) {
        // 禁止输入单引号
        if ([string isEqualToString:@"'"]) {
            [self textFieldDidChange];
            return NO;
        }
        [self textFieldDidChange];
        return YES;
    }
    return YES;
}

- (void)textFieldDidChange {
    // 判断是否存在高亮字符（拼音输入中）
    UITextRange *selectedRange = self.setRemarkTextField.markedTextRange;
    UITextPosition *position = [self.setRemarkTextField positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return;
    }
    
    // 限制最大字数
    if (self.setRemarkTextField.text.length > 50) {
        self.setRemarkTextField.text = [self.setRemarkTextField.text substringToIndex:50];
    }
    
    // 更新字数统计
    self.setRemarkNumberLabel.text = [NSString stringWithFormat:@"%ld/50", (long)self.setRemarkTextField.text.length];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange {
    // 判断是否存在高亮字符（拼音输入中）
    UITextRange *selectedRange = self.setDesTextView.markedTextRange;
    UITextPosition *position = [self.setDesTextView positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return;
    }
    
    // 限制最大字数
    if (self.setDesTextView.text.length > 200) {
        self.setDesTextView.text = [self.setDesTextView.text substringToIndex:200];
    }
    
    // 更新字数统计
    self.setDesNumberLabel.text = [NSString stringWithFormat:@"%ld/200", (long)self.setDesTextView.text.length];
    
    // 更新占位符显示
    self.textViewPlaceHolderLabel.hidden = (self.setDesTextView.text.length > 0);
}

#pragma mark - 交互事件

- (void)saveBtnAction {
    // 验证备注不能为纯空格
    if (self.setRemarkTextField.text.length > 0 && 
        [self.setRemarkTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
        [HUD showMessage:MultilingualTranslation(@"备注不能为空格")];
        return;
    }
    
    // 执行保存回调
    if (self.saveBtnBlock) {
        self.saveBtnBlock(self.setRemarkTextField.text, self.setDesTextView.text);
    }
    
    // 返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnAction {
    // 执行取消回调
    if (self.cancelBtnBlock) {
        self.cancelBtnBlock();
    }
    
    // 返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

@end
