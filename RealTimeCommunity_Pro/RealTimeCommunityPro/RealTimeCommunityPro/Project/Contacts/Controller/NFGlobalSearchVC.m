//
//  NFGlobalSearchVC.m
//  CIMKit
//
//  Created by cusPro on 2022/9/14.
//

#import "NFGlobalSearchVC.h"
#import "MainSearchView.h"
#import "EmptyDataView.h"
#import "NVGlobalSearchSectionHeaderView.h"
#import "CNGlobalSearchCell.h"
#import "NVGlobalSearchSectionFooterView.h"

#import "NFUserHomePageVC.h"
#import "NHChatViewController.h"
#import "FileFileHelperVC.h"

@interface NFGlobalSearchVC () <MainSearchViewDelegate,UITableViewDataSource,UITableViewDelegate,ZGlobalSearchSectinFooterViewDelegate>

@property (nonatomic, strong) UITextField *tfSearch;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, strong) MainSearchView *viewSearch;//搜索控件

@property (nonatomic, strong) EmptyDataView *viewNoData;//无搜索内容

@property (nonatomic, strong) NSMutableArray *friendList;//联系人
@property (nonatomic, assign) BOOL showMoreFriend;//展示更多联系人

@property (nonatomic, strong) NSMutableArray *groupList;//群组
@property (nonatomic, assign) BOOL showMoreGroup;//展示更多群组

@property (nonatomic, strong) NSMutableArray *chatHistoryList;//聊天记录
@property (nonatomic, assign) BOOL showMoreHistory;//展示更多聊天记录

@end

@implementation NFGlobalSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitleStr = MultilingualTranslation(@"搜索");
    
    _friendList = [NSMutableArray array];
    _groupList = [NSMutableArray array];
    _chatHistoryList = [NSMutableArray array];
    
    [self setupUI];
}
#pragma mark - 界面布局
- (void)setupUI {
    _viewSearch = [[MainSearchView alloc] initWithPlaceholder:MultilingualTranslation(@"搜索群聊/好友")];
    _viewSearch.frame = CGRectMake(0, DWScale(6) + DNavStatusBarH, DScreenWidth, DWScale(38));
    _viewSearch.currentViewSearch = YES;
    _viewSearch.showClearBtn = YES;
    _viewSearch.delegate = self;
    [self.view addSubview:_viewSearch];
    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.viewSearch.showKeyboard = YES;
    });
    
    self.baseTableViewStyle = UITableViewStyleGrouped;
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
        make.top.equalTo(_viewSearch.mas_bottom).offset(DWScale(6));
    }];
    
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    
    [self.baseTableView registerClass:[NVGlobalSearchSectionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([NVGlobalSearchSectionHeaderView class])];
    
    [self.baseTableView registerClass:[CNGlobalSearchCell class] forCellReuseIdentifier:[CNGlobalSearchCell cellIdentifier]];
    
    [self.baseTableView registerClass:[NVGlobalSearchSectionFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([NVGlobalSearchSectionFooterView class])];
}
#pragma mark - 交互事件
//搜索联系人
- (void)searchFriendList {
    _showMoreFriend = NO;
    WeakSelf
    [ZTOOL doAsync:^{
        if (![NSString isNil:weakSelf.searchStr]) {
            NSArray *localFriendList = [IMSDKManager toolSearchMyFriendWith:weakSelf.searchStr];
            if (localFriendList.count <= 0) {
                [weakSelf.friendList removeAllObjects];
            } else {
                [weakSelf.friendList removeAllObjects];
                // 使用 NSSet 存储已存在的 friendUserUID，提高查找效率
                NSMutableSet *existingUIDs = [NSMutableSet set];
                for (LingIMFriendModel *existingFriend in self.friendList) {
                    [existingUIDs addObject:existingFriend.friendUserUID];
                }
                
                for (LingIMFriendModel *tempFriend in localFriendList) {
                    if ([tempFriend.friendUserUID isEqualToString:@"100002"] && [UserManager.userRoleAuthInfo.isShowFileAssistant.configValue isEqualToString:@"false"]) {
                        //此处过滤处理
                    } else {
                        // 使用 NSSet 的 containsObject 方法，O(1) 时间复杂度
                        if (![existingUIDs containsObject:tempFriend.friendUserUID]) {
                            [self.friendList addObject:tempFriend];
                            [existingUIDs addObject:tempFriend.friendUserUID]; // 更新已存在的 UID 集合
                        }
                    }
                }
            }
        }else {
            [weakSelf.friendList removeAllObjects];
        }
    } completion:^{
        [weakSelf.baseTableView reloadData];
        if (weakSelf.friendList.count == 0 && weakSelf.groupList.count == 0 && weakSelf.chatHistoryList.count == 0) {
            weakSelf.baseTableView.tableHeaderView = weakSelf.viewNoData;
        }else {
            weakSelf.baseTableView.tableHeaderView = nil;
        }
        if ([NSString isNil:weakSelf.searchStr]) {
            weakSelf.baseTableView.tableHeaderView = nil;
        }
    }];
}
//搜索群聊
- (void)searchGroupList {
    _showMoreGroup = NO;
    WeakSelf
    [ZTOOL doAsync:^{
        if (![NSString isNil:weakSelf.searchStr]) {
           weakSelf.groupList = [IMSDKManager toolSearchMyGroupWith:weakSelf.searchStr].mutableCopy;
        }else {
            [weakSelf.groupList removeAllObjects];
        }
    } completion:^{
        [weakSelf.baseTableView reloadData];
        if (weakSelf.friendList.count == 0 && weakSelf.groupList.count == 0 && weakSelf.chatHistoryList.count == 0) {
            weakSelf.baseTableView.tableHeaderView = weakSelf.viewNoData;
        }else {
            weakSelf.baseTableView.tableHeaderView = nil;
        }
        if ([NSString isNil:weakSelf.searchStr]) {
            weakSelf.baseTableView.tableHeaderView = nil;
        }
    }];
}
//搜索聊天历史
- (void)searchChatHistoryList {
    _showMoreHistory = NO;
    WeakSelf
    [ZTOOL doAsync:^{
        weakSelf.chatHistoryList = [IMSDKManager toolSearchMessageWith:weakSelf.searchStr].mutableCopy;
        
        // 移除被删除消息的列表数据
        [weakSelf.chatHistoryList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(LingIMChatMessageModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.messageStatus == 0) {
                CIMLog(@"[用户消息禁言] 这是被删除的消息");
                [weakSelf.chatHistoryList removeObject:obj];
            }
        }];
    } completion:^{
        [weakSelf.baseTableView reloadData];
        if (weakSelf.friendList.count == 0 && weakSelf.groupList.count == 0 && weakSelf.chatHistoryList.count == 0) {
            weakSelf.baseTableView.tableHeaderView = weakSelf.viewNoData;
        }else {
            weakSelf.baseTableView.tableHeaderView = nil;
        }
        if ([NSString isNil:weakSelf.searchStr]) {
            weakSelf.baseTableView.tableHeaderView = nil;
        }
        //[weakSelf.baseTableView reloadSections:[[NSIndexSet alloc] initWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}
#pragma mark - MainSearchViewDelegate
//搜索内容发生变化
- (void)searchViewTextValueChanged:(NSString *)searchStr {
    NSString *search = [searchStr trimString];
    if (![_searchStr isEqualToString:search]) {
        //执行搜索方法
        _searchStr = search;
        [self searchFriendList];
        [self searchGroupList];
        [self searchChatHistoryList];
    }
    DLog(@"搜索内容%@",search);
}
//回车触发
- (void)searchViewReturnKeySearch:(NSString *)searchStr {
    NSString *search = [searchStr trimString];
    if (![_searchStr isEqualToString:search]) {
        //执行搜索方法
        _searchStr = search;
        [self searchFriendList];
        [self searchGroupList];
        [self searchChatHistoryList];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _showMoreFriend ? _friendList.count : (_friendList.count > 3 ? 3 : _friendList.count);
            break;
        case 1:
            return _showMoreGroup ? _groupList.count : (_groupList.count > 3 ? 3 : _groupList.count);
            break;
        case 2:
            return _showMoreHistory ? _chatHistoryList.count : (_chatHistoryList.count > 3 ? 3 : _chatHistoryList.count);
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //联系人分区：有备注：备注+昵称 无备注：昵称
    //群聊分区：群名称
    //聊天记录分区：单聊：名称+聊天内容 群聊：名称+发送人：聊天内容
    CNGlobalSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:[CNGlobalSearchCell cellIdentifier] forIndexPath:indexPath];
    if (indexPath.section == 0) {
        LingIMFriendModel *friendModel = [_friendList objectAtIndexSafe:indexPath.row];
        [cell globalSearchConfigWith:indexPath model:friendModel search:_searchStr];
    } else if (indexPath.section == 1) {
        LingIMGroupModel *groupModel = [_groupList objectAtIndexSafe:indexPath.row];
        [cell globalSearchConfigWith:indexPath model:groupModel search:_searchStr];
    }  else if (indexPath.section == 2) {
        LingIMChatMessageModel *messageModel = [_chatHistoryList objectAtIndexSafe:indexPath.row];
        [cell globalSearchConfigWith:indexPath model:messageModel search:_searchStr];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CNGlobalSearchCell defaultCellHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //联系人
    if (section == 0 && _friendList.count > 0) {
        NVGlobalSearchSectionHeaderView *viewHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NVGlobalSearchSectionHeaderView class])];
        viewHeader.headerSection = section;
        return viewHeader;
    }
    //群组
    if (section == 1 && _groupList.count > 0) {
        NVGlobalSearchSectionHeaderView *viewHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NVGlobalSearchSectionHeaderView class])];
        viewHeader.headerSection = section;
        return viewHeader;
    }
    //聊天记录
    if (section == 2 && _chatHistoryList.count > 0) {
        NVGlobalSearchSectionHeaderView *viewHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NVGlobalSearchSectionHeaderView class])];
        viewHeader.headerSection = section;
        return viewHeader;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && _friendList.count > 0) {
        return DWScale(37);
    }
    if (section == 1 && _groupList.count > 0) {
        return DWScale(37);
    }
    if (section == 2 && _chatHistoryList.count > 0) {
        return DWScale(37);
    }
    
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && _friendList.count > 3 && !_showMoreFriend) {
        NVGlobalSearchSectionFooterView *viewFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NVGlobalSearchSectionFooterView class])];
        viewFooter.footerSection = section;
        viewFooter.delegate = self;
        return viewFooter;
    }
    
    if (section == 1 && _groupList.count > 3 && !_showMoreGroup) {
        NVGlobalSearchSectionFooterView *viewFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NVGlobalSearchSectionFooterView class])];
        viewFooter.footerSection = section;
        viewFooter.delegate = self;
        return viewFooter;
    }
    
    if (section == 2 && _chatHistoryList.count > 3 && !_showMoreHistory) {
        NVGlobalSearchSectionFooterView *viewFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NVGlobalSearchSectionFooterView class])];
        viewFooter.footerSection = section;
        viewFooter.delegate = self;
        return viewFooter;
    }
    
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && _friendList.count > 3 && !_showMoreFriend) {
        return DWScale(40);
    }
    
    if (section == 1 && _groupList.count > 3 && !_showMoreGroup) {
        return DWScale(40);
    }
    
    if (section == 2 && _chatHistoryList.count > 3 && !_showMoreHistory) {
        return DWScale(40);
    }
    
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //好友主页
        LingIMFriendModel *friendModel = [_friendList objectAtIndexSafe:indexPath.row];
        if (friendModel.userType == 0) {
            //普通级 好友
            NFUserHomePageVC *vc = [NFUserHomePageVC new];
            vc.userUID = friendModel.friendUserUID;
            vc.groupID = @"";
            [self.navigationController pushViewController:vc animated:YES];
        }else if (friendModel.userType == 1) {
            //系统级 好友
            if ([friendModel.friendUserUID isEqualToString:@"100002"]) {
                //文件助手
                FileFileHelperVC *vc = [FileFileHelperVC new];
                vc.sessionID = friendModel.friendUserUID;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else if (indexPath.section == 1) {
        //群聊
        LingIMGroupModel *model = [_groupList objectAtIndexSafe:indexPath.row];
        NHChatViewController *vc = [NHChatViewController new];
        vc.chatName = model.groupName;
        vc.sessionID = model.groupId;
        vc.chatType = CIMChatType_GroupChat;
        [self.navigationController pushViewController:vc animated:YES];
    }  else if (indexPath.section == 2) {
        //历史聊天消息
        LingIMChatMessageModel *model = [_chatHistoryList objectAtIndexSafe:indexPath.row];
        NSString *sessionId;
        NSInteger chatType = model.chatType;
        NSString *chatName;
        if (model.chatType == ChatType_SingleChat) {
            if ([model.fromID isEqualToString:UserManager.userInfo.userUID]) {
                sessionId = model.toID;
            } else {
                sessionId = model.fromID;
            }
            LingIMFriendModel *friendModel = [IMSDKManager toolCheckMyFriendWith:sessionId];
            chatName = friendModel.showName;
            if (friendModel.userType == 0) {
                //普通级 好友
                //聊天详情VC
                NHChatViewController *chatVC = [[NHChatViewController alloc] init];
                chatVC.chatName = chatName;
                chatVC.sessionID = sessionId;
                chatVC.chatType = chatType;
                [self.navigationController pushViewController:chatVC animated:YES];
                
                [chatVC clickSearchResultInChatRoomWithMessage:model];
                
            }else if (friendModel.userType == 1) {
                //系统级 好友
                if ([friendModel.friendUserUID isEqualToString:@"100002"]) {
                    //文件助手
                    FileFileHelperVC *vc = [FileFileHelperVC new];
                    vc.sessionID = friendModel.friendUserUID;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc clickSearchResultInChatRoomWithMessage:model];
                }
            }
        }
        
        if (model.chatType == ChatType_GroupChat) {
            sessionId = model.toID;
            LingIMGroupModel *groupModel = [IMSDKManager toolCheckMyGroupWith:sessionId];
            chatName = groupModel.groupName;
            
            //聊天详情VC
            NHChatViewController *chatVC = [[NHChatViewController alloc] init];
            chatVC.chatName = chatName;
            chatVC.sessionID = sessionId;
            chatVC.chatType = chatType;
            [self.navigationController pushViewController:chatVC animated:YES];
            
            [chatVC clickSearchResultInChatRoomWithMessage:model];
        }
        
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tfSearch resignFirstResponder];
}
#pragma mark - ZGlobalSearchSectinFooterViewDelegate
- (void)sectionFooterShowMore:(NSInteger)footerSection {
    switch (footerSection) {
        case 0:
            _showMoreFriend = YES;
            break;
        case 1:
            _showMoreGroup = YES;
            break;
        case 2:
            _showMoreHistory = YES;
            break;
            
        default:
            break;
    }
    [self.baseTableView reloadData];
    [_tfSearch resignFirstResponder];
}
#pragma mark - 懒加载
- (EmptyDataView *)viewNoData {
    if (!_viewNoData) {
        _viewNoData = [[EmptyDataView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DWScale(60))];
        _viewNoData.lblNoDataTip.text = MultilingualTranslation(@"无搜索结果");
        _viewNoData.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    }
    return _viewNoData;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
