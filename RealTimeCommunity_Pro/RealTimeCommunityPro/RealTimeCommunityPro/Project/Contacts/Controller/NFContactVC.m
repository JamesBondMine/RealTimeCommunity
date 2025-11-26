//
//  NFContactVC.m
//  CIMKit
//
//  Created by Apple on 2022/9/2.
//

#import "NFContactVC.h"
#import "NVContactHeaderView.h"
#import "NVContactSectionHeaderView.h"
#import "JXCategoryView.h"

#import "ZScrollView.h"
#import "NFFriendListVC.h"//好友列表
#import "NFFriendGroupListVC.h"//好友分组列表
#import "NGGroupListVC.h"//群聊列表

//跳转
#import "NFAddFriendVC.h"//添加好友
#import "NFGlobalSearchVC.h"//搜索
#import "NFNewFriendListVC.h"//新朋友
#import "FileFileHelperVC.h"//文件助手
#import "HomeSystemMessageVC.h"//群助手
//#import "NMShareInviteViewController.h"//分享邀请

#import "NTTabBarController.h"//tabbar
#import "NJSelectCategoryIndicatorBackgroundView.h"

@interface NFContactVC () <NVContactHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource, NJSelectCategoryViewDelegate>

@property (nonatomic, strong) UIButton *searchView;
@property (nonatomic, strong) NVContactHeaderView *viewHeader;
//指示器控件
@property (nonatomic, strong) LJCategoryTitleView *viewCategory;
@property (nonatomic, strong) ZScrollView *scrollView;
@property (nonatomic, strong) NFFriendListVC *friendVC;//好友
@property (nonatomic, strong) NFFriendGroupListVC *friendGroupVC;//好友分组
@property (nonatomic, strong) NGGroupListVC *groupVC;//群组VC
@property (nonatomic, assign) NSInteger currentSelectedIndex;//当前选中下标
@end

@implementation NFContactVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self initNavBar];
    //全局搜索
    [self initSearchBar];
    //布局
    [self initTableView];
    
    //好友申请红点变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFriendApplyCount) name:@"FriendApplyCountChange" object:nil];
    //主界面是否可以滑动通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainTableViewScrollEnable) name:@"ContactScrollEnable" object:nil];
    //用户角色权限发生变化(是否线上文件助手)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRoleAuthorityFileHelperChange) name:@"UserRoleAuthorityFileHelperChangeNotification" object:nil];
}

//初始化导航
-(void)initNavBar{
    self.navLineView.hidden = YES;
    self.navBtnBack.hidden = YES;
    self.navTitleLabel.text = MultilingualTranslation(@"通讯录");
    if ([UserManager.userRoleAuthInfo.allowAddFriend.configValue isEqualToString:@"true"]) {
        self.navBtnRight.hidden = NO;
        [self.navBtnRight setTkThemeImage:@[ImgNamed(@"recon_cim_contacts_add"), ImgNamed(@"recon_cim_contacts_add_dark")] forState:UIControlStateNormal];
    } else {
        self.navBtnRight.hidden = YES;
    }
}

//搜索框
-(void)initSearchBar{
    self.searchView = [[UIButton alloc] init];
    self.searchView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_EEEEEE_DARK];
    [self.searchView rounded:12.0];
    [self.searchView addTarget:self action:@selector(searchViewClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(DWScale(16));
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-DWScale(16));
        make.top.mas_equalTo(self.navView.mas_bottom).offset(DWScale(0));
        make.height.mas_equalTo(DWScale(38));
    }];
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = ImgNamed(@"recon_cim_contacts_search_icon_grey");
    [self.searchView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.searchView.mas_leading).offset(DWScale(16));
        make.centerY.mas_equalTo(self.searchView);
        make.width.mas_equalTo(DWScale(16));
        make.height.mas_equalTo(DWScale(16));
    }];
    
    UILabel *searchTitleLbl = [[UILabel alloc] init];
    searchTitleLbl.text = MultilingualTranslation(@"搜索");
    searchTitleLbl.tkThemetextColors = @[COLOR_99, COLOR_99];
    if([ZLanguageTOOL.currentLanguage.languageName_zn isEqualToString:@"法语"]){
        searchTitleLbl.font = FONTR(12);
    }else{
        searchTitleLbl.font = FONTR(16);
    }
    [self.searchView addSubview:searchTitleLbl];
    [searchTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(searchIcon.mas_trailing).offset(DWScale(6));
        make.centerY.mas_equalTo(self.searchView);
        make.trailing.mas_equalTo(self.searchView.mas_trailing).offset(DWScale(-10));
        make.height.mas_equalTo(DWScale(38));
    }];
}

//初始化TableView
-(void)initTableView{
    
    [self.view addSubview:self.baseTableView];
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.backgroundColor = UIColor.clearColor;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.searchView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-DTabBarH);
    }];
    [self.baseTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    _viewHeader = [[NVContactHeaderView alloc] init];
    if ([UserManager.userRoleAuthInfo.isShowFileAssistant.configValue isEqualToString:@"true"]) {
        _viewHeader.frame = CGRectMake(0, 0, DScreenWidth, DWScale(162));
    } else {
        _viewHeader.frame = CGRectMake(0, 0, DScreenWidth, DWScale(108));
    }
    _viewHeader.delegate = self;
    _viewHeader.newFriendApplyNum = [IMSDKManager toolFriendApplyCount];
    self.baseTableView.tableHeaderView = _viewHeader;
    
    _viewCategory = [[LJCategoryTitleView alloc] initWithFrame:CGRectMake(16, 0, DScreenWidth *2/3, DWScale(44))];
    
    // 1. 主题背景：灰色带4像素圆角
    _viewCategory.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_EEEEEE_DARK];
    _viewCategory.layer.cornerRadius = DWScale(22);
    _viewCategory.layer.masksToBounds = YES;
    
    _viewCategory.delegate = self;
    _viewCategory.titles = @[MultilingualTranslation(@"好友"), MultilingualTranslation(@"分组"), MultilingualTranslation(@"群聊")];
    _viewCategory.titleColorGradientEnabled = YES;
    _viewCategory.titleLabelZoomScale = NO;
    _viewCategory.titleFont = FONTB(16);
    
    // 2. 配置选中项的白色背景指示器
    NJSelectCategoryIndicatorComponentView *backgroundView = [[NJSelectCategoryIndicatorComponentView alloc] init];
//    backgroundView.tkThemebackgroundColors = @[COLORWHITE, COLOR_EAEAEA]; // 白色背景
    backgroundView.indicatorColor = [UIColor whiteColor];
    backgroundView.indicatorCornerRadius = DWScale(17); // 圆角4像素
    backgroundView.indicatorHeight = DWScale(44) - DWScale(10); // 高度减去上下内边距(5+5=10)
    backgroundView.indicatorWidthIncrement = DScreenWidth *2/18; // 宽度减去左右内边距(5+5=10)
    _viewCategory.indicators = @[backgroundView];

    WeakSelf
    self.view.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        switch (themeIndex) {
            case 1:
            {
                //暗黑
                weakSelf.viewCategory.titleColor = COLOR_99;
                weakSelf.viewCategory.titleSelectedColor = COLOR_4791FF;
            }
                break;
                
            default:
            {
                weakSelf.viewCategory.titleColor = COLOR_99;
                weakSelf.viewCategory.titleSelectedColor = COLOR_4791FF;
            }
                break;
        }
    };
    
    _scrollView = [[ZScrollView alloc] initWithFrame:CGRectMake(0, DWScale(54), DScreenWidth, DScreenHeight - DNavStatusBarH - DWScale(38) - DWScale(54) - DTabBarH)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delaysContentTouches = NO;
    _scrollView.contentSize = CGSizeMake(DScreenWidth * 3, 0);
    _scrollView.bounces = NO;
    self.viewCategory.contentScrollView = self.scrollView;
    
    _currentSelectedIndex = 0;
    
    
    _friendVC = [[NFFriendListVC alloc] init];
    _friendVC.view.frame = CGRectMake(0, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_friendVC];
    [self.scrollView addSubview:_friendVC.view];
    
    _friendGroupVC = [[NFFriendGroupListVC alloc] init];
    _friendGroupVC.view.frame = CGRectMake(DScreenWidth, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_friendGroupVC];
    [self.scrollView addSubview:_friendGroupVC.view];
    
    _groupVC = [[NGGroupListVC alloc] init];
    _groupVC.view.frame = CGRectMake(DScreenWidth * 2, 0, DScreenWidth, _scrollView.height);
    [self addChildViewController:_groupVC];
    [self.scrollView addSubview:_groupVC.view];
}

//添加好友
- (void)navBtnRightClicked {
    NFAddFriendVC *vc = [NFAddFriendVC new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - NVContactHeaderViewDelegate
- (void)contactHeaderAction:(NSInteger)actionTag {
    if (actionTag == 0) {
        //新朋友
        [self newFriendAction];
    } else if (actionTag == 1){
        //文件助手
        [self fileHelperAction];
    }
    else if (actionTag == 2){
        //群助手
        [self groupHelperAction];
    }
}
//新朋友
- (void)newFriendAction {
    NFNewFriendListVC *newFriendVC = [[NFNewFriendListVC alloc] init];
    [self.navigationController pushViewController:newFriendVC animated:YES];
}

//文件助手
- (void)fileHelperAction {
    //好友 系统用户级别
    //文件助手 100002
    FileFileHelperVC *vc = [FileFileHelperVC new];
    vc.sessionID = @"100002";
    [self.navigationController pushViewController:vc animated:YES];
}

//群助手
- (void)groupHelperAction {
    LingIMSessionModel *sssionModel = [IMSDKManager toolCheckMySessionWithType:CIMSessionTypeSystemMessage];
    //群助手
    HomeSystemMessageVC *vc = [HomeSystemMessageVC new];
    vc.groupHelperType = ZGroupHelperFormTypeSessionList;
    vc.groupId = @"";
    vc.sessionModel = sssionModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Notification
- (void)userRoleAuthorityFileHelperChange {
    if ([UserManager.userRoleAuthInfo.isShowFileAssistant.configValue isEqualToString:@"true"]) {
        _viewHeader.frame = CGRectMake(0, 0, DScreenWidth, DWScale(162));
    } else {
        _viewHeader.frame = CGRectMake(0, 0, DScreenWidth, DWScale(108));
    }
    [_viewHeader updateUI];
}

#pragma mark - SearchClickAction
- (void)searchViewClickAction {
    NFGlobalSearchVC *vc = [NFGlobalSearchVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 好友申请红点变化
- (void)updateFriendApplyCount {
    NSInteger count = [IMSDKManager toolFriendApplyCount];
    
    _viewHeader.newFriendApplyNum = count;
    
    NTTabBarController *tab = (NTTabBarController *)self.tabBarController;
    [tab setBadgeValue:1 number:count];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [cell.contentView addSubview:_viewCategory];
    [cell.contentView addSubview:_scrollView];
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DScreenHeight - DNavStatusBarH - DWScale(38) - DTabBarH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
//    static NSString *headerID = @"NVContactSectionHeaderView";
//    NVContactSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
//    if (headerView == nil) {
//        headerView = [[NVContactSectionHeaderView alloc] initWithReuseIdentifier:headerID];
//        [headerView addSubview:_viewCategory];
//        [headerView addSubview:_scrollView];
//    }
//
//    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //return DScreenHeight - DNavStatusBarH - DWScale(216) - DTabBarH - DHomeBarH;
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= DWScale(162)) {
        
        self.baseTableView.scrollEnabled = NO;
        [self.baseTableView setContentOffset:CGPointMake(0, DWScale(162))];
        //[_friendVC friendListScrollEnable:YES];
        [_friendGroupVC friendGroupListScrollEnable:YES];
        [_groupVC groupListScrollEnable:YES];
        
    }else {
        
        self.baseTableView.scrollEnabled = YES;
        //[_friendVC friendListScrollEnable:NO];
        [_friendGroupVC friendGroupListScrollEnable:NO];
        [_groupVC groupListScrollEnable:NO];
    }
    
}

- (void)mainTableViewScrollEnable {
    self.baseTableView.scrollEnabled = YES;
}
#pragma mark - #pragma mark - JXCategoryViewDelegate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
