//
//  HomeSessionTopView.m
//  CIMKit
//
//  Created by cusPro on 2022/9/23.
//

#import "HomeSessionTopView.h"
#import "BBBaseImageView.h"

//#import "ZSessionMoreView.h" // 已废弃，改用悬浮按钮 FloatingActionButton
#import "SpecMyMiniAppView.h"

@interface HomeSessionTopView ()
@property (nonatomic, strong) BBBaseImageView *ivHeader;//头像
@property (nonatomic, strong) UIButton *btnSearch;//搜索
@property (nonatomic, strong) UIButton *btnMini;//小程序
@property (nonatomic, strong) CAGradientLayer *gradientLayer;//渐变背景层
@end

@implementation HomeSessionTopView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        //监听用户信息更新
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewAppearUpdateUI) name:@"MineUserInfoUpdate" object:nil];
    }
    return self;
}
#pragma mark - 界面布局
- (void)setupUI {
    // 精致的渐变背景
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0.40 green:0.85 blue:0.75 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.92 green:0.98 blue:0.96 alpha:1.0].CGColor,
        (__bridge id)[UIColor whiteColor].CGColor
    ];
    self.gradientLayer.locations = @[@0.0, @0.5, @1.0];
    self.gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    self.gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    
    // 头像容器 - 右侧，带精美阴影和光晕效果
    UIView *avatarContainer = [[UIView alloc] init];
    avatarContainer.backgroundColor = [UIColor clearColor];
    avatarContainer.layer.shadowColor = [UIColor colorWithRed:0.40 green:0.85 blue:0.75 alpha:0.6].CGColor;
    avatarContainer.layer.shadowOffset = CGSizeMake(0, 4);
    avatarContainer.layer.shadowOpacity = 0.3;
    avatarContainer.layer.shadowRadius = 10;
    avatarContainer.userInteractionEnabled = YES;
    [self addSubview:avatarContainer];
    [avatarContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-DWScale(24));
        make.top.equalTo(self).offset(DWScale(2) + DStatusBarH);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    
    // 头像 - 圆形，带渐变边框效果
    _ivHeader = [[BBBaseImageView alloc] init];
    _ivHeader.layer.cornerRadius = DWScale(56)/2;
    _ivHeader.layer.masksToBounds = YES;
    _ivHeader.layer.borderWidth = 2.5;
    _ivHeader.layer.borderColor = [UIColor whiteColor].CGColor;
    [_ivHeader sd_setImageWithURL:[UserManager.userInfo.avatar getImageFullUrl] placeholderImage:DefaultAvatar options:SDWebImageAllowInvalidSSLCertificates];
    [avatarContainer addSubview:_ivHeader];
    [_ivHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(avatarContainer);
    }];
    
    // 头像上添加一个细微的高光效果
    UIView *highlightView = [[UIView alloc] init];
    highlightView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    highlightView.layer.cornerRadius = DWScale(56)/2;
    highlightView.layer.masksToBounds = YES;
    highlightView.userInteractionEnabled = NO;
    [avatarContainer addSubview:highlightView];
    [highlightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(_ivHeader);
        make.height.equalTo(_ivHeader).multipliedBy(0.4);
    }];
    
    // 添加点击手势
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapClick)];
    [avatarContainer addGestureRecognizer:avatarTap];
    
    // 小程序按钮 - 左侧长条状设计
    _btnMini = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMini.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.98];
    _btnMini.layer.cornerRadius = DWScale(15);
    _btnMini.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    _btnMini.layer.shadowOffset = CGSizeMake(0, 3);
    _btnMini.layer.shadowOpacity = 0.15;
    _btnMini.layer.shadowRadius = 6;
    _btnMini.layer.masksToBounds = NO;
    
    // 设置小程序图标在左侧
    [_btnMini setImage:ImgNamed(@"remini_mini_app_icon") forState:UIControlStateNormal];
    _btnMini.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnMini.imageEdgeInsets = UIEdgeInsetsMake(0, DWScale(12), 0, 0);
    
    // 添加"小程序"文字
    [_btnMini setTitle:[NSString stringWithFormat:@"  %@",MultilingualTranslation(@"小程序")] forState:UIControlStateNormal];
    _btnMini.titleLabel.font = FONTN(13);
    [_btnMini setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
    _btnMini.titleEdgeInsets = UIEdgeInsetsMake(0, DWScale(8), 0, 0);
    
    [_btnMini addTarget:self action:@selector(btnMiniClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnMini];
    [_btnMini mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(DWScale(24));
        make.centerY.equalTo(avatarContainer);
        make.width.mas_equalTo(DWScale(120));
        make.height.mas_equalTo(DWScale(30));
    }];
    
    // 小程序按钮添加点击反馈效果
    [_btnMini addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_btnMini addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    // 搜索框 - 极简现代设计
    _btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSearch.backgroundColor = [UIColor whiteColor];
    _btnSearch.layer.cornerRadius = DWScale(24);
    _btnSearch.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.08].CGColor;
    _btnSearch.layer.shadowOffset = CGSizeMake(0, 2);
    _btnSearch.layer.shadowOpacity = 0.1;
    _btnSearch.layer.shadowRadius = 12;
    _btnSearch.layer.masksToBounds = NO;
    [_btnSearch setTkThemeImage:@[ImgNamed(@"com_c_search_black"), ImgNamed(@"com_c_search_black_dark")] forState:UIControlStateNormal];
    _btnSearch.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _btnSearch.imageEdgeInsets = UIEdgeInsetsMake(0, DWScale(20), 0, 0);
    [_btnSearch addTarget:self action:@selector(btnSearchClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnSearch];
    [_btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(DWScale(24));
        make.trailing.equalTo(self).offset(-DWScale(24));
        make.bottom.equalTo(self).offset(-DWScale(16));
        make.height.mas_equalTo(DWScale(48));
    }];
    
    // 搜索框添加点击反馈效果
    [_btnSearch addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_btnSearch addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    // 搜索提示文字 - 更优雅
    UILabel *searchPlaceholder = [[UILabel alloc] init];
    searchPlaceholder.text = MultilingualTranslation(@"搜索会话、联系人");
    searchPlaceholder.font = FONTN(15);
    searchPlaceholder.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    searchPlaceholder.userInteractionEnabled = NO;
    [_btnSearch addSubview:searchPlaceholder];
    [searchPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_btnSearch).offset(DWScale(54));
        make.centerY.equalTo(_btnSearch);
    }];
    
    // 搜索图标右边添加竖线分隔
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    separatorLine.userInteractionEnabled = NO;
    [_btnSearch addSubview:separatorLine];
    [separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_btnSearch).offset(DWScale(50));
        make.centerY.equalTo(_btnSearch);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(DWScale(20));
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 更新渐变层大小
    self.gradientLayer.frame = self.bounds;
}

// 按钮按下效果
- (void)btnTouchDown:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.95, 0.95);
        sender.alpha = 0.8;
    }];
}

// 按钮松开效果
- (void)btnTouchUp:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformIdentity;
        sender.alpha = 1.0;
    }];
}
#pragma mark - 界面数据更新
- (void)viewAppearUpdateUI {
    [_ivHeader sd_setImageWithURL:[UserManager.userInfo.avatar getImageFullUrl] placeholderImage:DefaultAvatar options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)setShowLoading:(BOOL)showLoading {
    _showLoading = showLoading;
    // 加载状态显示已移除
}

#pragma mark - 交互事件
- (void)avatarTapClick {
    if (self.avatarClickBlock) {
        self.avatarClickBlock();
    }
}

- (void)btnSearchClick {
    if (self.searchBlock) {
        self.searchBlock();
    }
}

- (void)btnMiniClick {
    SpecMyMiniAppView *viewMyMiniApp = [SpecMyMiniAppView new];
    
    // 设置小程序跳转block - 转发给外层处理
    WeakSelf
    viewMyMiniApp.miniAppJumpBlock = ^(LingIMMiniAppModel *miniAppModel) {
        if (weakSelf.miniAppJumpBlock) {
            weakSelf.miniAppJumpBlock(miniAppModel);
        }
    };
    
    [viewMyMiniApp myMiniAppShow];
}

// btnAddClick 方法已删除，添加按钮已移除，改用悬浮按钮 FloatingActionButton

// 以下方法已废弃，功能已集成到悬浮按钮 FloatingActionButton
/*
- (void)showMoreView {
    ZSessionMoreView *viewMore = [ZSessionMoreView new];
    viewMore.delegate = self;
    [viewMore viewShow];
}
#pragma mark - ZSessionMoreViewDelegate
- (void)moreViewDelegateWithAction:(ZSessionMoreActionType)actionType {
    //直接恢复原状态，交互不好看
    //_btnAdd.transform = CGAffineTransformIdentity;
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.btnAdd.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        if (weakSelf.addBlock && finished) {
            weakSelf.addBlock(actionType);
        }
    }];
    
}
*/


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
