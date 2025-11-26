//
//  NSInviteFriendVC.m
//  CIMKit
//
//  Created by cusPro on 2022/9/22.
//

#import "NSInviteFriendVC.h"
#import "MainSearchView.h"
#import "NSInviteFriendHeaderView.h"
#import "NSInviteFriendCell.h"
#import "ZMessageTools.h"
#import "ZKnownTipView.h"
#import "ZBaseUserModel.h"
#import "LingIMGroup.h"
#import "EmptyDataView.h"
#import "NHChatViewController.h"
#import "NSExcursionSelectCell.h"
#import "NSMassMessageSelectModel.h"
#import "NSMassMessageGroupSelectedTopView.h"

@interface NSInviteFriendVC () <MainSearchViewDelegate,UITableViewDataSource,UITableViewDelegate,ZBaseCellDelegate>

@property (nonatomic, strong) MainSearchView *viewSearch;
@property (nonatomic, strong) NSMutableArray<ZBaseUserModel *> *searchList;//搜索结果
@property (nonatomic, strong) NSMutableArray<NSMassMessageSelectModel *> *selectModelList;//分组及子级
@property (nonatomic, strong) NSMutableArray<ZBaseUserModel *> *selectedList;//选中的
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, strong) EmptyDataView *viewNoData;//无数据提示
@property (nonatomic, strong) NSMassMessageGroupSelectedTopView *groupSelectedTopView;//已选择的

@end

@implementation NSInviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavUI];
    [self setupUI];
    [self setupLocalData];
    
    //顶部已选中有delete操作时，触发此通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupSelectedDeleteAction:) name:@"ZMassMessageSelectedGroupDeleteActionNotification" object:nil];
}
#pragma mark - 界面布局
- (void)setupNavUI {
    self.navTitleStr = MultilingualTranslation(@"创建群聊");
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:MultilingualTranslation(@"完成") forState:UIControlStateNormal];
    [self.navBtnRight setTitleColor:COLORWHITE forState:UIControlStateNormal];
    self.navBtnRight.tkThemebackgroundColors = @[COLOR_CCCCCC, COLOR_CCCCCC_DARK];
    self.navBtnRight.layer.cornerRadius = DWScale(12);
    self.navBtnRight.layer.masksToBounds = YES;
    self.navBtnRight.titleLabel.numberOfLines = 2;
    self.navBtnRight.enabled = NO;
    [self.navBtnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel);
        make.trailing.equalTo(self.navView).offset(-DWScale(16));
        make.height.mas_equalTo(DWScale(32));
        CGSize textSize = [self.navBtnRight.titleLabel.text sizeWithFont:FONTR(14) constrainedToSize:CGSizeMake(10000, DWScale(32))];
        make.width.mas_equalTo(MIN(textSize.width+DWScale(28), 60));
    }];
    
}
- (void)setupUI {
    _viewSearch = [[MainSearchView alloc] initWithPlaceholder:MultilingualTranslation(@"搜索")];
    _viewSearch.currentViewSearch = YES;
    _viewSearch.showClearBtn = YES;
    _viewSearch.returnKeyType = UIReturnKeyDefault;
    _viewSearch.delegate = self;
    [self.view addSubview:_viewSearch];
    [_viewSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(DWScale(38));
        make.top.mas_equalTo(self.view).offset(DNavStatusBarH + DWScale(6));
    }];
    

    _groupSelectedTopView = [[NSMassMessageGroupSelectedTopView alloc] init];
    _groupSelectedTopView.selectedTopUserList = self.selectedList;
    [self.view addSubview:_groupSelectedTopView];
    [_groupSelectedTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(self.selectedList.count > 0 ? DWScale(95) : 0);
        make.top.mas_equalTo(_viewSearch.mas_bottom).offset(DWScale(16));
    }];
    
    [self.view addSubview:self.viewNoData];
    [self.viewNoData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.groupSelectedTopView.mas_bottom).offset(DWScale(10));
        make.height.mas_equalTo(DWScale(60));
    }];
    
    [self.view addSubview:self.baseTableView];
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.delaysContentTouches = NO;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
        make.top.equalTo(self.groupSelectedTopView.mas_bottom).offset(DWScale(10));
    }];
    
    [self.baseTableView registerClass:[NSInviteFriendCell class] forCellReuseIdentifier:[NSInviteFriendCell cellIdentifier]];
    [self.baseTableView registerClass:[NSExcursionSelectCell class] forCellReuseIdentifier:[NSExcursionSelectCell cellIdentifier]];
    [self.baseTableView registerClass:[NSInviteFriendHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([NSInviteFriendHeaderView class])];
}

#pragma mark - 获取搜索数据
- (void)requestSearchList {
    //搜索
    if (![NSString isNil:self.searchStr]) {
        NSArray *showFriendList = [[IMSDKManager toolSearchMyFriendWith:_searchStr] mutableCopy];
        for (LingIMFriendModel *tempFriend in showFriendList) {
            if ((![NSString isNil:_friendUid] && [tempFriend.friendUserUID isEqualToString:self.friendUid]) || tempFriend.userType == 1) {
                //此处过滤处理
            } else {
                ZBaseUserModel *baseUserModel = [[ZBaseUserModel alloc] init];
                baseUserModel.userId = tempFriend.friendUserUID;
                baseUserModel.name = tempFriend.showName;
                baseUserModel.avatar = tempFriend.avatar;
                baseUserModel.roleId = tempFriend.roleId;
                baseUserModel.disableStatus = tempFriend.disableStatus;
                [self.searchList addObject:baseUserModel];
            }
        }
    }
    [self reloadInviteUI];
    [self.baseTableView reloadData];
}

#pragma mark - 初始化数据
- (void)setupLocalData {
    //最近联系人
    NSMutableArray *recentContactList = [NSMutableArray array];
    NSArray *localSessionArr = [IMSDKManager toolGetMySessionListFromSignlChatWithOffServer];
    for (LingIMSessionModel *obj in localSessionArr) {
        if (![NSString isNil:_friendUid] && [obj.sessionID isEqualToString:self.friendUid]) {
            //此处过滤处理
        } else {
            LingIMFriendModel *friendModel = [IMSDKManager toolCheckMyFriendWith:obj.sessionID];
            if (!friendModel) {
                continue;
            }
            
            if (friendModel.userType < 0 || friendModel.disableStatus < 0) {
                continue;
            }
            
            if (friendModel.userType != 1 && friendModel.disableStatus != 4) {//过滤系统级用户和已注销的用户
                ZBaseUserModel *baseUserModel = [[ZBaseUserModel alloc] init];
                baseUserModel.userId = obj.sessionID;
                baseUserModel.name = ![NSString isNil:friendModel.showName] ? friendModel.showName : (![NSString isNil:friendModel.nickname] ? friendModel.nickname : obj.sessionName);
                baseUserModel.avatar = obj.sessionAvatar;
                baseUserModel.roleId = friendModel.roleId;
                baseUserModel.showRole = YES;
                baseUserModel.disableStatus = friendModel.disableStatus;
                [recentContactList addObject:baseUserModel];
            }
        }
        if (recentContactList.count >= 50) {
            break;
        }
    }
    NSString *recentTitle = [NSString stringWithFormat:@"%@(%ld)",MultilingualTranslation(@"最新联系人"), recentContactList.count];
    NSMassMessageSelectModel *model = [NSMassMessageSelectModel new];
    model.title = recentTitle;
    model.list = recentContactList;
    model.isOpen = YES;
    model.isAllSelect = NO;
    [self.selectModelList addObject:model];
    
    //分组
    NSArray *localFriendGroupAr = [IMSDKManager toolGetMyFriendGroupList];
    for (LingIMFriendGroupModel *friendGroupModel in localFriendGroupAr) {
        //获取某个 好友分组 下的 好友列表(所有的，不包含已注销账号)
        NSString *friendGroupID = friendGroupModel.ugUuid;
        //找到该好友分组下的好友列表
        NSMutableArray *friendListForGroup = [NSMutableArray array];
        if (friendGroupModel.ugType == -1) {
            //默认分组
            NSArray *friendListTempY = [IMSDKManager toolGetMyFriendGroupFriendsWith:friendGroupID];
            NSArray *friendListTempN = [IMSDKManager toolGetMyFriendGroupFriendsWith:@""];
            [friendListForGroup addObjectsFromArray:friendListTempY];
            [friendListForGroup addObjectsFromArray:friendListTempN];
        }else {
            //用户自定义分组
            NSArray *friendListTemp = [IMSDKManager toolGetMyFriendGroupFriendsWith:friendGroupID];
            [friendListForGroup addObjectsFromArray:friendListTemp];
        }
        
        NSMutableArray *friendInGroupArr = [NSMutableArray array];
        for (LingIMFriendModel *tempFriend in friendListForGroup) {
            if ((![NSString isNil:_friendUid] && [tempFriend.friendUserUID isEqualToString:self.friendUid]) || tempFriend.userType == 1 || tempFriend.disableStatus == 4) {
                //此处过滤处理
            } else {
                ZBaseUserModel *baseUserModel = [[ZBaseUserModel alloc] init];
                baseUserModel.userId = tempFriend.friendUserUID;
                baseUserModel.name = ![NSString isNil:tempFriend.showName] ? tempFriend.showName : tempFriend.nickname;
                baseUserModel.avatar = tempFriend.avatar;
                baseUserModel.roleId = tempFriend.roleId;
                baseUserModel.showRole = YES;
                baseUserModel.disableStatus = tempFriend.disableStatus;
                
                [friendInGroupArr addObject:baseUserModel];
            }
        }
        NSString *groupFriendName = friendGroupModel.ugType == -1 ?(![NSString isNil:friendGroupModel.ugName] ? friendGroupModel.ugName : MultilingualTranslation(@"默认分组")) : friendGroupModel.ugName;
        NSString *groupFriendTitle = [NSString stringWithFormat:MultilingualTranslation(@"%@(%ld)"), groupFriendName, friendInGroupArr.count];
        NSMassMessageSelectModel *model = [NSMassMessageSelectModel new];
        model.title = groupFriendTitle;
        model.list = friendInGroupArr;
        model.isOpen = NO;
        model.isAllSelect = NO;
        [self.selectModelList addObject:model];
    }
    [self.baseTableView reloadData];

}

#pragma mark - Super
- (void)navBtnRightClicked {
    [HUD showActivityMessage:MultilingualTranslation(@"创建群聊中...")];

    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"ownerUid"];
    [dict setObjectSafe:UserManager.userInfo.nickname forKey:@"ownerNickname"];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    __block NSMutableArray *groupMemberList = [NSMutableArray array];

    if (![NSString isNil:_friendUid]) {
        NSDictionary *dict = @{@"userUid" : _friendUid,@"nickName":_friendNickname};
        [groupMemberList addObjectIfNotNil:dict];
    }
    [self.selectedList enumerateObjectsUsingBlock:^(ZBaseUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:obj.userId forKey:@"userUid"];
        [dict setValue:obj.name forKey:@"nickName"];
        [groupMemberList addObjectIfNotNil:dict];
    }];
    [dict setObjectSafe:groupMemberList forKey:@"groupMemberParams"];
    //创建群聊
    [IMSDKManager createGroupWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        LingIMGroup *groupInfoModel = [LingIMGroup mj_objectWithKeyValues:data];
        groupInfoModel.isMessageInform = 1;
        groupInfoModel.userGroupRole = 2;
        groupInfoModel.isActiveEnabled = 1;
        LingIMGroupModel *imGroupModel = [ZMessageTools netWorkGroupModelToDBGroupModel:groupInfoModel];
        if (imGroupModel) {
            [IMSDKManager toolInsertOrUpdateGroupModelWith:imGroupModel];
        }
        [weakSelf createGroupSuccessWith:groupInfoModel];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}
- (void)createGroupSuccessWith:(LingIMGroup *)groupInfoModel {
    //延迟一下
//    WeakSelf
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideHUD];
            LingIMGroupModel *imGroupModel = [ZMessageTools netWorkGroupModelToDBGroupModel:groupInfoModel];
            if (imGroupModel) {
                [IMSDKManager toolInsertOrUpdateGroupModelWith:imGroupModel];
            }
            
            //群聊创建成功后进入群聊
            NHChatViewController *vc = [NHChatViewController new];
            vc.groupInfo = groupInfoModel;
            vc.chatType = CIMChatType_GroupChat;
            vc.chatName = groupInfoModel.groupName;
            vc.sessionID = groupInfoModel.groupId;

            [self.navigationController pushViewController:vc animated:YES];
            //修改导航栏的栈
            self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject,vc];
//        });
//    });
}

- (void)reloadInviteUI {
    if (![NSString isNil:_searchStr]) {
        self.baseTableView.hidden = !(self.searchList.count > 0);
        self.viewNoData.lblNoDataTip.text = self.searchList.count > 0 ? @"" : MultilingualTranslation(@"无搜索结果");
    }else {
        self.baseTableView.hidden = NO;
        self.viewNoData.lblNoDataTip.text = @"";
    }
}

#pragma mark - MainSearchViewDelegate
- (void)searchViewTextValueChanged:(NSString *)searchStr {
    _searchStr = [searchStr trimString];
    [self.searchList removeAllObjects];
    [self requestSearchList];
}


#pragma mark - event
- (void)cellClickAction:(NSIndexPath *)indexPath {
    if ([NSString isNil:self.searchStr]) {
        ZBaseUserModel *model = self.selectModelList[indexPath.section].list[indexPath.row];
        if ([self.selectedList containsObject:model]) {
            [self.selectedList removeObject:model];
        } else {
            if (self.selectedList.count >= _maxNum) {
                ZKnownTipView *viewTip = [ZKnownTipView new];
                viewTip.lblTip.text = [NSString stringWithFormat:MultilingualTranslation(@"最多只能选择%ld人"),_maxNum];
                [viewTip knownTipViewSHow];
                return;
            }
            [self.selectedList addObject:model];
        }
        
    } else {
        ZBaseUserModel *model = self.searchList[indexPath.row];
        if ([self.selectedList containsObject:model]) {
            [self.selectedList removeObject:model];
        } else {
            if (self.selectedList.count >= _maxNum) {
                ZKnownTipView *viewTip = [ZKnownTipView new];
                viewTip.lblTip.text = [NSString stringWithFormat:MultilingualTranslation(@"最多只能选择%ld人"),_maxNum];
                [viewTip knownTipViewSHow];
                return;
            }
            [self.selectedList addObject:model];
        }
    }
    [self checkSelectModelIsAllSelected];
    [self.baseTableView reloadData];
    [self navBtnRightRefresh];
    [self groupSelectedTopViewRefresh];
}

- (void)checkSelectModelIsAllSelected {
    for (NSMassMessageSelectModel * selectModel in self.selectModelList) {
        selectModel.isAllSelect = YES;
        for (ZBaseUserModel * userModel in selectModel.list) {
            if(![self.selectedList containsObject:userModel]){
                selectModel.isAllSelect = NO;
                break;
            }
        }
    }
}

- (void)groupSelectedDeleteAction:(NSNotification *)sender{
    //更新list
    NSNumber *deleteNum = sender.object;
    [self.selectedList removeObjectAtIndex:[deleteNum integerValue]];
    [self checkSelectModelIsAllSelected];
    [self.baseTableView reloadData];
    [self navBtnRightRefresh];
    [self groupSelectedTopViewRefresh];
}

- (void)groupSelectedTopViewRefresh {
    [_groupSelectedTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(self.selectedList.count > 0 ? DWScale(95) : 0);
        make.top.mas_equalTo(_viewSearch.mas_bottom).offset(DWScale(16));
    }];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    _groupSelectedTopView.selectedTopUserList = self.selectedList;
}

- (void)navBtnRightRefresh {
    self.navBtnRight.tkThemebackgroundColors = @[COLOR_CCCCCC, COLOR_CCCCCC_DARK];
    self.navBtnRight.enabled = NO;
    if (self.selectedList.count > 0) {
        [self.navBtnRight setTitle:[NSString stringWithFormat:MultilingualTranslation(@"完成(%ld)"),self.selectedList.count] forState:UIControlStateNormal];
        if (self.selectedList.count >= _minNum) {
            self.navBtnRight.enabled = YES;
            self.navBtnRight.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF_DARK];
        }
    }else {
        [self.navBtnRight setTitle:MultilingualTranslation(@"完成") forState:UIControlStateNormal];
        self.navBtnRight.enabled = NO;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([NSString isNil:self.searchStr]) {
        return self.selectModelList.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([NSString isNil:self.searchStr]) {
        return self.selectModelList[section].isOpen ? self.selectModelList[section].list.count : 0;
    }
    return self.searchList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([NSString isNil:self.searchStr]) {
        NSExcursionSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSExcursionSelectCell cellIdentifier] forIndexPath:indexPath];
        ZBaseUserModel *model = self.selectModelList[indexPath.section].list[indexPath.row];
        [cell cellConfigBaseUserWith:model search:_searchStr];
        cell.selectedUser = [self.selectedList containsObject:model];
        return cell;
    } else {
        NSInviteFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSInviteFriendCell cellIdentifier] forIndexPath:indexPath];
        ZBaseUserModel *model = self.searchList[indexPath.row];
        [cell cellConfigBaseUserWith:model search:_searchStr];
        cell.selectedUser = [self.selectedList containsObject:model];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([NSString isNil:self.searchStr]) {
        return [NSExcursionSelectCell defaultCellHeight];
    }
    return [NSInviteFriendCell defaultCellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([NSString isNil:self.searchStr]) {
        NSInviteFriendHeaderView *viewHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NSInviteFriendHeaderView class])];
        viewHeader.contentStr = self.selectModelList[section].title;
        viewHeader.isOpen = self.selectModelList[section].isOpen;
        viewHeader.isSelected = self.selectModelList[section].isAllSelect;
        WeakSelf
        [viewHeader setOpenCallback:^(bool isOpen) {
            weakSelf.selectModelList[section].isOpen = isOpen;
            [weakSelf.baseTableView reloadData];
        }];
        [viewHeader setSelectAllCallback:^(bool isAll) {
            if (isAll) {
                for (ZBaseUserModel *obj in weakSelf.selectModelList[section].list) {
                    if (![weakSelf.selectedList containsObject:obj]) {
                        if (weakSelf.selectedList.count >= weakSelf.maxNum) {
                            ZKnownTipView *viewTip = [ZKnownTipView new];
                            viewTip.lblTip.text = [NSString stringWithFormat:MultilingualTranslation(@"最多只能选择%ld人"),weakSelf.maxNum];
                            [viewTip knownTipViewSHow];
                            weakSelf.selectModelList[section].isAllSelect = NO;
                            [weakSelf.baseTableView reloadData];
                            [weakSelf navBtnRightRefresh];
                            [weakSelf groupSelectedTopViewRefresh];
                            return;
                        }
                        [weakSelf.selectedList addObject:obj];
                    }
                }
                [weakSelf checkSelectModelIsAllSelected];
                weakSelf.selectModelList[section].isAllSelect = YES;
                [weakSelf.baseTableView reloadData];
                [weakSelf navBtnRightRefresh];
                [weakSelf groupSelectedTopViewRefresh];
            } else {
                weakSelf.selectModelList[section].isAllSelect = NO;
                for (ZBaseUserModel *obj in weakSelf.selectModelList[section].list)  {
                    if ([weakSelf.selectedList containsObject:obj]) {
                        [weakSelf.selectedList removeObject:obj];
                    }
                }
                [weakSelf checkSelectModelIsAllSelected];
                [weakSelf.baseTableView reloadData];
                [weakSelf navBtnRightRefresh];
                [weakSelf groupSelectedTopViewRefresh];
            }
        }];
        
        return viewHeader;
    } else {
        return [UIView new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([NSString isNil:self.searchStr]) {
        return DWScale(46);
    }
    return DWScale(0.01);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self cellClickAction:indexPath];
}

#pragma mark - 懒加载
- (EmptyDataView *)viewNoData {
    if (!_viewNoData) {
        _viewNoData = [[EmptyDataView alloc] init];
        _viewNoData.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    }
    return _viewNoData;
}

- (NSMutableArray<ZBaseUserModel *> *)searchList {
    if (_searchList == nil) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (NSMutableArray<NSMassMessageSelectModel *> *)selectModelList {
    if (_selectModelList == nil) {
        _selectModelList = [[NSMutableArray alloc] init];
    }
    return _selectModelList;
}

- (NSMutableArray<ZBaseUserModel *> *)selectedList {
    if (_selectedList == nil) {
        _selectedList = [NSMutableArray array];
    }
    return _selectedList;
}

#pragma mark - life cycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
