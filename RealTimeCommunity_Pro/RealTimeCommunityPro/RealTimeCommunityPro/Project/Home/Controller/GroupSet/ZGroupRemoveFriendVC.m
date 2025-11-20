//
//  ZGroupRemoveFriendVC.m
//  CIMKit
//
//  Created by cusPro on 2022/11/10.
//

#import "ZGroupRemoveFriendVC.h"
#import "MainSearchView.h"
#import "GpInviteAndRemoveFriendCell.h"
#import "ZChineseSort.h"
#import "UITableView+SCIndexView.h"
#import "ZKnownTipView.h"
#import "NVFriendListSectionHeaderView.h"

#import "LingIMGroup.h"
#import "NHChatViewController.h"
#import "ZMessageAlertView.h"

@interface ZGroupRemoveFriendVC ()<MainSearchViewDelegate,UITableViewDataSource,UITableViewDelegate,ZBaseCellDelegate>

@property (nonatomic, strong) MainSearchView *viewSearch;
@property (nonatomic, strong) NSMutableArray *reqFriendList;//从后台请求下来的数据集合
@property (nonatomic, strong) NSMutableArray *showFriendList;//展示的好友列表
@property (nonatomic, strong) NSMutableArray *selectedFriendList;//选中的好友id
@property (nonatomic, strong) NSMutableArray *selectedNicknameList;//选中的好友昵称
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, copy) NSString * groupMemberTabName;

@end

@implementation ZGroupRemoveFriendVC

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
    
    [self requestFriendList];
}

#pragma mark - 界面布局
- (void)setupNavUI {
    self.navTitleStr = MultilingualTranslation(@"移除群成员");
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
    configuration.indexItemSelectedBackgroundColor = COLOR_81D8CF;
    configuration.indexItemsSpace = DWScale(6);
    self.baseTableView.sc_indexViewConfiguration = configuration;
    self.baseTableView.sc_translucentForTableViewInNavigationBar = NO;
}

- (void)navBtnRightClicked {
    if ((self.reqFriendList.count - _selectedFriendList.count) >= GroupMemberMinValue) {
        WeakSelf
        ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeTitleCheckBox supView:nil];
        msgAlertView.lblTitle.text = MultilingualTranslation(@"移除成员");
        msgAlertView.lblContent.text = MultilingualTranslation(@"将所选成员移除群聊");
        msgAlertView.lblContent.textAlignment = NSTextAlignmentLeft;
        [msgAlertView.btnSure setTitle:MultilingualTranslation(@"确认") forState:UIControlStateNormal];
        [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
        msgAlertView.checkboxLblContent.text = MultilingualTranslation(@"删除所选成员全部已发消息");
        [msgAlertView alertShow];
        msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObjectSafe:weakSelf.selectedFriendList forKey:@"groupMemberUidList"];
            [dict setObjectSafe:@(isCheckBox) forKey:@"delMemberMsg"];
            [dict setObjectSafe:self.groupInfoModel.groupId forKey:@"groupId"];
            if (![NSString isNil:UserManager.userInfo.userUID]) {
                [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
            }
            [IMSDKManager groupRemoveMemberWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
                if (data) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [HUD showMessage:MultilingualTranslation(@"成员移除成功")];
                    //更新本地群成员数据库
                    for (LingIMGroupMemberModel *groupMemberModel in self.reqFriendList) {
                        for (NSString * userID in weakSelf.selectedFriendList) {
                            if([groupMemberModel.userUid isEqualToString:userID]){
                                [IMSDKManager imSdkDeleteGroupMemberWith:userID groupID:weakSelf.groupInfoModel.groupId];
                                if (isCheckBox) {
                                    //删除所选成员全部已发消息
                                    [IMSDKManager toolDeleteGroupMemberAllSendMessageWith:userID groupID:weakSelf.groupInfoModel.groupId];
                                }
                            }
                        }
                    }
                }
            } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
                [HUD showMessageWithCode:code errorMsg:msg];
            }];
        };
    } else{
        DLog(@"成员移除过多");
    }
}

#pragma mark - 加载本地缓存的群成员数据
- (void)requestFriendList {
    [self.showFriendList removeAllObjects];
    if (![NSString isNil:_searchStr]) {
        //搜索联系人
        [self.showFriendList removeAllObjects];
        [self.showFriendList addObjectsFromArray:[DBTOOL checkGroupMemberWithTabName:self.groupMemberTabName searchContent:_searchStr exceptUserId:@""]];
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
    if (_selectedFriendList.count >= GroupMemberMaxValue) {
        ZKnownTipView *viewTip = [ZKnownTipView new];
        viewTip.lblTip.text = [NSString stringWithFormat:MultilingualTranslation(@"最多只能选择%ld人"),GroupMemberMaxValue];
        [viewTip knownTipViewSHow];
        return;
    }
    LingIMGroupMemberModel *model = [self.showFriendList objectAtIndexSafe:indexPath.row];
    if ([_selectedFriendList containsObject:model.userUid]) {
        [_selectedFriendList removeObject:model.userUid];
        [_selectedNicknameList removeObject:model.userNickname];
    } else {
        [_selectedFriendList addObjectIfNotNil:model.userUid];
        [_selectedNicknameList addObjectIfNotNil:model.userNickname];
    }
    [self.baseTableView reloadData];
    
    self.navBtnRight.tkThemebackgroundColors = @[COLOR_CCCCCC, COLOR_CCCCCC_DARK];
    if (_selectedFriendList.count > 0) {
        [self.navBtnRight setTitle:[NSString stringWithFormat:MultilingualTranslation(@"完成(%ld)"),_selectedFriendList.count] forState:UIControlStateNormal];
        if ((self.reqFriendList.count - _selectedFriendList.count) >= GroupMemberMinValue) {
            self.navBtnRight.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF_DARK];
        }
    } else {
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
    if ([_selectedFriendList containsObject:model.userUid]) {
        cell.selectedUser = 2;
    }else {
        cell.selectedUser = 3;
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
