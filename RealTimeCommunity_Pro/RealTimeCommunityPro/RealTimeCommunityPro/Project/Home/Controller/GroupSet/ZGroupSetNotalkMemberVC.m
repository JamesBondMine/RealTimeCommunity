//
//  ZGroupSetNotalkMemberVC.m
//  CIMKit
//
//  Created by cusPro on 2022/11/15.
//

#import "ZGroupSetNotalkMemberVC.h"
#import "MainSearchView.h"
#import "GpInviteAndRemoveFriendCell.h"
#import "ZChineseSort.h"
#import "UITableView+SCIndexView.h"
#import "ZKnownTipView.h"
#import "NVFriendListSectionHeaderView.h"
#import "LingIMGroup.h"
#import "NHChatViewController.h"
#import "ZSheetCustomView.h"
#import "ZMessageAlertView.h"
@interface ZGroupSetNotalkMemberVC ()<MainSearchViewDelegate,UITableViewDataSource,UITableViewDelegate,ZBaseCellDelegate>

@property (nonatomic, strong) MainSearchView *viewSearch;
@property (nonatomic, strong) NSMutableArray *reqFriendList;//从后台请求下来的数据集合
@property (nonatomic, strong) NSMutableArray *showFriendList;//展示的好友列表
@property (nonatomic, strong) NSMutableArray *selectedFriendList;//选中的好友id
@property (nonatomic, strong) NSMutableArray *selectedNicknameList;//选中的好友昵称
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, copy) NSString * groupMemberTabName;

@end

@implementation ZGroupSetNotalkMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavUI];
    [self setupUI];
    
    _reqFriendList = [NSMutableArray array];
    _showFriendList = [NSMutableArray array];
    _selectedFriendList = [NSMutableArray array];
    _selectedNicknameList = [NSMutableArray array];
    
    //该群在本地存储群成员表的表名称
    self.groupMemberTabName = [NSString stringWithFormat:@"CIMSDKDB_%@_GroupMemberTable",self.groupInfoModel.groupId];
    //加载本地数据库换成的群成员表
    [self.reqFriendList addObjectsFromArray:[IMSDKManager imSdkGetGroupMemberExceptOwnerWith:self.groupInfoModel.groupId]];
    // 过滤掉自己
    NSString *myUid = UserManager.userInfo.userUID;
    NSPredicate *filterMe = [NSPredicate predicateWithBlock:^BOOL(LingIMGroupMemberModel *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ![evaluatedObject.userUid isEqualToString:myUid];
    }];
    [self.reqFriendList filterUsingPredicate:filterMe];
    
    [self requestFriendList];
}
#pragma mark - 界面布局
- (void)setupNavUI {
    self.navTitleStr = MultilingualTranslation(@"单人禁言");
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:MultilingualTranslation(@"完成") forState:UIControlStateNormal];
    [self.navBtnRight setTitleColor:COLORWHITE forState:UIControlStateNormal];
    self.navBtnRight.tkThemebackgroundColors = @[COLOR_CCCCCC, COLOR_CCCCCC_DARK];
    self.navBtnRight.layer.cornerRadius = DWScale(12);
    self.navBtnRight.layer.masksToBounds = YES;
    [self.navBtnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel);
        make.trailing.equalTo(self.navView).offset(-DWScale(20));
        make.height.mas_equalTo(DWScale(32));
        CGSize textSize = [self.navBtnRight.titleLabel.text sizeWithFont:FONTR(14) constrainedToSize:CGSizeMake(10000, DWScale(32))];
        make.width.mas_equalTo(MIN(textSize.width+DWScale(28), 60));
    }];
}

- (void)setupUI {
    _viewSearch = [[MainSearchView alloc] initWithPlaceholder:MultilingualTranslation(@"搜索")];
    _viewSearch.frame = CGRectMake(0, DNavStatusBarH + DWScale(6), DScreenWidth, DWScale(38));
    _viewSearch.currentViewSearch = YES;
    _viewSearch.showClearBtn = YES;
    _viewSearch.returnKeyType = UIReturnKeyDefault;
    _viewSearch.delegate = self;
    [self.view addSubview:_viewSearch];
    
    [self.view addSubview:self.baseTableView];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.delaysContentTouches = NO;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
        make.top.equalTo(_viewSearch.mas_bottom).offset(DWScale(6));
    }];
    
    [self.baseTableView registerClass:[GpInviteAndRemoveFriendCell class] forCellReuseIdentifier:[GpInviteAndRemoveFriendCell cellIdentifier]];
    [self.baseTableView registerClass:[NVFriendListSectionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([NVFriendListSectionHeaderView class])];
    
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
    configuration.indexItemSelectedBackgroundColor = COLOR_4791FF;
    configuration.indexItemsSpace = DWScale(6);
    self.baseTableView.sc_indexViewConfiguration = configuration;
    self.baseTableView.sc_translucentForTableViewInNavigationBar = NO;
}

- (void)navBtnRightClicked {
    NSArray * itemStrArr = @[MultilingualTranslation(@"禁言10分钟"),
                             MultilingualTranslation(@"禁言1小时"),
                             MultilingualTranslation(@"禁言12小时"),
                             MultilingualTranslation(@"禁言24小时"),
                             MultilingualTranslation(@"禁言7天"),
                             MultilingualTranslation(@"禁言30天"),
                             MultilingualTranslation(@"永久禁言")];
    NSArray * minutesArr = @[@"10",@"60",@"720",@"1440",@"10080",@"43200",@"-1"];
    ZSheetCustomView * view = [[ZSheetCustomView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) titleStr:MultilingualTranslation(@"选择禁言时间") itemArr:itemStrArr];
    WeakSelf;
    view.sureBtnBlock = ^(NSInteger index) {
        if (index == 6) {
            ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeTitle supView:nil];
            msgAlertView.lblTitle.text = MultilingualTranslation(@"是否永久禁言当前用户？");
            msgAlertView.lblTitle.font = FONTB(18);
            msgAlertView.lblTitle.textAlignment = NSTextAlignmentCenter;
            msgAlertView.lblContent.text = @"";
            msgAlertView.lblContent.font = FONTN(14);
            msgAlertView.lblContent.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
            msgAlertView.lblContent.textAlignment = NSTextAlignmentCenter;
            [msgAlertView.btnSure setTitle:MultilingualTranslation(@"确认") forState:UIControlStateNormal];
            [msgAlertView.btnSure setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
            msgAlertView.btnSure.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF_DARK];
            [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
            [msgAlertView.btnCancel setTkThemeTitleColor:@[COLOR_66, COLOR_66_DARK] forState:UIControlStateNormal];
            msgAlertView.btnCancel.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F6F6F6_DARK];
            msgAlertView.isSizeDivide = YES;
            [msgAlertView alertShow];
            msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObjectSafe:minutesArr[index] forKey:@"expireTime"];
                [dict setObjectSafe:self.selectedFriendList forKey:@"forbidUidList"];
                [dict setObjectSafe:self.groupInfoModel.groupId forKey:@"groupId"];
                [dict setObjectSafe:@"1" forKey:@"operationType"];
                if (![NSString isNil:UserManager.userInfo.userUID]) {
                    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
                }
                [IMSDKManager groupSetNotalkMemberWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
                    if (data) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        [HUD showMessage:MultilingualTranslation(@"成员禁言成功")];
                    }
                } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
                    [HUD showMessageWithCode:code errorMsg:msg];
                }];
            };
        } else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObjectSafe:minutesArr[index] forKey:@"expireTime"];
            [dict setObjectSafe:self.selectedFriendList forKey:@"forbidUidList"];
            [dict setObjectSafe:self.groupInfoModel.groupId forKey:@"groupId"];
            [dict setObjectSafe:@"1" forKey:@"operationType"];
            if (![NSString isNil:UserManager.userInfo.userUID]) {
                [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
            }
            [IMSDKManager groupSetNotalkMemberWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
                if (data) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [HUD showMessage:MultilingualTranslation(@"成员禁言成功")];
                }
            } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
                [HUD showMessageWithCode:code errorMsg:msg];
            }];
        }
    };

    [view customViewSHow];
}



- (void)requestFriendList {
    [self.showFriendList removeAllObjects];
    if (![NSString isNil:_searchStr]) {
        //搜索联系人
        [self.showFriendList removeAllObjects];
        [self.showFriendList addObjectsFromArray:[DBTOOL checkGroupMemberWithTabName:self.groupMemberTabName searchContent:_searchStr exceptUserId:UserManager.userInfo.userUID]];
    }else {
        //群组成员
        [self.showFriendList addObjectsFromArray:self.reqFriendList];
    }
    [self.baseTableView reloadData];
}

#pragma mark - MainSearchViewDelegate
- (void)searchViewTextValueChanged:(NSString *)searchStr {
    _searchStr = [searchStr trimString];
    [self requestFriendList];
}

#pragma mark - ZBaseCellDelegate
- (void)cellClickAction:(NSIndexPath *)indexPath {
    LingIMGroupMemberModel *model = [self.showFriendList objectAtIndexSafe:indexPath.row];
    // 双重防御：自己不可选
    if ([model.userUid isEqualToString:UserManager.userInfo.userUID]) {
        return;
    }
    if (model.isGroupMember) {
        return;
    }
    if ([_selectedFriendList containsObject:model.userUid]) {
        [_selectedFriendList removeObject:model.userUid];
        [_selectedNicknameList removeObject:model.userNickname];
    }else {
        [_selectedFriendList addObjectIfNotNil:model.userUid];
        [_selectedNicknameList addObjectIfNotNil:model.userNickname];
    }
    
    [self.baseTableView reloadData];
    
    self.navBtnRight.tkThemebackgroundColors = @[COLOR_CCCCCC, COLOR_CCCCCC_DARK];
    if (_selectedFriendList.count > 0) {
        [self.navBtnRight setTitle:[NSString stringWithFormat:MultilingualTranslation(@"完成(%ld)"),_selectedFriendList.count] forState:UIControlStateNormal];
        self.navBtnRight.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF_DARK];
    }else {
        [self.navBtnRight setTitle:MultilingualTranslation(@"完成") forState:UIControlStateNormal];
    }
    [self.navBtnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel);
        make.trailing.equalTo(self.navView).offset(-DWScale(20));
        make.height.mas_equalTo(DWScale(32));
        CGSize textSize = [self.navBtnRight.titleLabel.text sizeWithFont:FONTR(14) constrainedToSize:CGSizeMake(10000, DWScale(32))];
        make.width.mas_equalTo(MIN(textSize.width+DWScale(28), 60));
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showFriendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GpInviteAndRemoveFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:[GpInviteAndRemoveFriendCell cellIdentifier] forIndexPath:indexPath];
    cell.baseDelegate = self;
    cell.baseCellIndexPath = indexPath;
    LingIMGroupMemberModel *model = [_showFriendList objectAtIndexSafe:indexPath.row];
    [cell cellConfigWith:model search:_searchStr];
    if (model.isGroupMember) {
        cell.selectedUser = 1;
    }else{
        if ([_selectedFriendList containsObject:model.userUid]) {
            cell.selectedUser = 2;
        }else {
            cell.selectedUser = 3;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [GpInviteAndRemoveFriendCell defaultCellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
