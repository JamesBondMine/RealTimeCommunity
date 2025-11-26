//
//  ZGroupChangeOwnerVC.m
//  CIMKit
//
//  Created by cusPro on 2022/11/16.
//

#import "ZGroupChangeOwnerVC.h"
#import "MainSearchView.h"
#import "ZGroupMemberListCell.h"
#import "ZChineseSort.h"
#import "UITableView+SCIndexView.h"
#import "ZKnownTipView.h"
#import "NVFriendListSectionHeaderView.h"
#import "LingIMGroup.h"
#import "NHChatViewController.h"
#import "ZMessageAlertView.h"
#import "ZChatGroupSetVC.h"

@interface ZGroupChangeOwnerVC ()<MainSearchViewDelegate,UITableViewDataSource,UITableViewDelegate,ZBaseCellDelegate>

@property (nonatomic, strong) NSMutableArray *reqFriendList;//从后台请求下来的数据集合
@property (nonatomic, strong) NSMutableArray *showFriendList;//展示的好友列表
@property (nonatomic, strong) MainSearchView *viewSearch;
@property (nonatomic, copy) NSString *searchStr;
@property (nonatomic, copy) NSString * groupMemberTabName;

@end

@implementation ZGroupChangeOwnerVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupNavUI];
    [self setupUI];
    
    _reqFriendList = [NSMutableArray array];
    _showFriendList = [NSMutableArray array];
    
    //该群在本地存储群成员表的表名称
    self.groupMemberTabName = [NSString stringWithFormat:@"CIMSDKDB_%@_GroupMemberTable",self.groupInfoModel.groupId];
    //加载本地数据库换成的群成员表
    [self.reqFriendList addObjectsFromArray:[IMSDKManager imSdkGetGroupMemberExceptOwnerWith:self.groupInfoModel.groupId]];
    
    [self requestMemberListList];
}

#pragma mark - 界面布局
- (void)setupNavUI {
    self.navTitleStr = MultilingualTranslation(@"群成员");
    self.navBtnRight.hidden = YES;
}

- (void)setupUI {
    _viewSearch = [[MainSearchView alloc] initWithPlaceholder:MultilingualTranslation(@"搜索群成员")];
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
    
    [self.baseTableView registerClass:[ZGroupMemberListCell class] forCellReuseIdentifier:[ZGroupMemberListCell cellIdentifier]];
    [self.baseTableView registerClass:[NVFriendListSectionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([NVFriendListSectionHeaderView class])];
    
    SCIndexViewConfiguration *configuration = [SCIndexViewConfiguration configurationWithIndexViewStyle:SCIndexViewStyleDefault];
    configuration.indexItemSelectedBackgroundColor = COLOR_4791FF;
    configuration.indexItemsSpace = DWScale(6);
    self.baseTableView.sc_indexViewConfiguration = configuration;
    self.baseTableView.sc_translucentForTableViewInNavigationBar = NO;
}

- (void)requestMemberListList {
    [self.showFriendList removeAllObjects];
    if (![NSString isNil:_searchStr]) {
        //搜索联系人
        [self.showFriendList removeAllObjects];
        [self.showFriendList addObjectsFromArray:[DBTOOL checkGroupMemberWithTabName:self.groupMemberTabName searchContent:_searchStr exceptUserId:@""]];
    } else {
        //群组成员
        [self.showFriendList addObjectsFromArray:self.reqFriendList];
    }
    [self.baseTableView reloadData];
}

- (void)changeGroupOwnerReq:(LingIMGroupMemberModel *)memberModel{
    WeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.groupInfoModel.groupId forKey:@"groupId"];
    [dict setValue:memberModel.userUid forKey:@"ownerUid"];
    if (![NSString isNil:UserManager.userInfo.userUID]) {
        [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    }
    [IMSDKManager groupChangeGroupOwnerWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if (data) {
            ZChatGroupSetVC * vc;
            for (UIViewController * ctrl in weakSelf.navigationController.childViewControllers) {
                if ([ctrl isKindOfClass:[ZChatGroupSetVC class]]) {
                    vc = (ZChatGroupSetVC *)ctrl;
                    break;
                }
            }
            //将原群主role设置为普通群成员
            LingIMGroupMemberModel *oldOwerMember = [IMSDKManager imSdkCheckGroupMemberWith:UserManager.userInfo.userUID groupID:weakSelf.groupInfoModel.groupId];
            oldOwerMember.role = 0;//原群主身份变成普通群成员
            [IMSDKManager imSdkInsertOrUpdateGroupMember:oldOwerMember groupID:weakSelf.groupInfoModel.groupId];
            //设置新的群主身份为群主身份
            memberModel.role = 2;
            [IMSDKManager imSdkInsertOrUpdateGroupMember:memberModel groupID:weakSelf.groupInfoModel.groupId];
            
            [weakSelf.navigationController popToViewController:vc animated:YES];
            [HUD showMessage:MultilingualTranslation(@"群主移交成功")];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - MainSearchViewDelegate
- (void)searchViewTextValueChanged:(NSString *)searchStr {
    _searchStr = [searchStr trimString];
    [self requestMemberListList];
}

#pragma mark - ZBaseCellDelegate
- (void)cellClickAction:(NSIndexPath *)indexPath {
    //弹窗
    LingIMGroupMemberModel * memberModel = self.showFriendList[indexPath.row];
    WeakSelf
    ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeTitle supView:nil];
    msgAlertView.lblTitle.text = MultilingualTranslation(@"移交群主");
    msgAlertView.lblContent.text = [NSString stringWithFormat:MultilingualTranslation(@"确认将群主移交给 “%@” ？移交后不可撤回，你将失去群的管理权限。"),memberModel.userNickname];
    msgAlertView.lblContent.textAlignment = NSTextAlignmentLeft;
    [msgAlertView alertShow];
    msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
        [weakSelf changeGroupOwnerReq:memberModel];
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _showFriendList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZGroupMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZGroupMemberListCell cellIdentifier] forIndexPath:indexPath];
    cell.baseCellIndexPath = indexPath;
    cell.baseDelegate = self;
    [cell cellConfigWithmodel:_showFriendList[indexPath.row] searchStr:_searchStr activityInfo:nil isActivityEnable:self.groupInfoModel.isActiveEnabled];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZGroupMemberListCell defaultCellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
