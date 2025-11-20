//
//  ZChatGroupSetVC.m
//  CIMKit
//
//  Created by cusPro on 2022/11/5.
//

#import "ZChatGroupSetVC.h"
#import "ZChatSetGroupInfoCell.h"
#import "ZGroupSetBasicInfoCell.h"
#import "ZChatSetGroupNoteCell.h"
#import "ZChatSetGroupCommonCell.h"
#import "LingIMGroup.h"
#import "ZMessageTools.h"

#import "ZSureCancelTipView.h"
#import "ZGroupSetBasicInfoVC.h"
#import "ZGroupMemberListVC.h"
#import "ZChatHistoryVC.h"//搜索聊天记录
#import "HomeGroupMyNicknameVC.h"//我在本群的昵称VC
#import "ZGroupInviteFriendVC.h"
#import "ZGroupRemoveFriendVC.h"
#import "ZGroupModifyNoticeVC.h"
#import "ZGroupManageVC.h"//群管理页面
#import "NHChatViewController.h"
#import "ZToolManager.h"
#import "ZGroupQRCodeVC.h"  //群二维码
#import "ZComplainVC.h"//投诉与支持
#import "ZGroupChangeOwnerVC.h"
#import "ZQRCodeModel.h"
#import "ZGroupNoticeListVC.h" // 新版本群公告

@interface ZChatGroupSetVC () <UITableViewDataSource,UITableViewDelegate,ZBaseCellDelegate,CIMToolGroupDelegate>

@property (nonatomic, strong) LingIMGroup *groupInfoModel;
@property (nonatomic, strong) NSMutableArray * groupMemberIdArr;
//请求群成员接口队列
@property (nonatomic, strong) dispatch_queue_t groupChatGetMemberQueue;

@end

@implementation ZChatGroupSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.groupMemberIdArr = [NSMutableArray array];
    _groupChatGetMemberQueue = dispatch_queue_create("com.CIMKit.groupChatGetMemberQueue", DISPATCH_QUEUE_CONCURRENT);
    self.navTitleStr = MultilingualTranslation(@"群设置");
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    
    [self setupUI];
    
    [self requestAllGroupMember];
    
    [IMSDKManager addGroupDelegate:self];
    
    //群内禁止私聊状态更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupNoChatStatusChange:) name:@"GroupNoChatStatusChange" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestGroupInfo];
}

#pragma mark - 界面布局
- (void)setupUI {
    [self defaultTableViewUI];
    self.baseTableView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.delaysContentTouches = NO;
    [self.baseTableView registerClass:[ZChatSetGroupInfoCell class] forCellReuseIdentifier:[ZChatSetGroupInfoCell cellIdentifier]];
    [self.baseTableView registerClass:[ZGroupSetBasicInfoCell class] forCellReuseIdentifier:[ZGroupSetBasicInfoCell cellIdentifier]];
    [self.baseTableView registerClass:[ZChatSetGroupNoteCell class] forCellReuseIdentifier:[ZChatSetGroupNoteCell cellIdentifier]];
    [self.baseTableView registerClass:[ZChatSetGroupCommonCell class] forCellReuseIdentifier:[ZChatSetGroupCommonCell cellIdentifier]];
}

#pragma mark - 查询群组详情 数据请求
- (void)requestGroupInfo {
    WeakSelf
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_groupID forKey:@"groupId"];
    if (![NSString isNil:UserManager.userInfo.userUID]) {
          [params setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    }
    [[LingIMSDKManager sharedTool] getGroupInfoWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)data;
                weakSelf.groupInfoModel = [LingIMGroup mj_objectWithKeyValues:dict];
                LingIMGroupModel *imGroupModel = [ZMessageTools netWorkGroupModelToDBGroupModel:weakSelf.groupInfoModel];
                if (imGroupModel) {
                    LingIMGroupModel *localGroupModel = [IMSDKManager toolCheckMyGroupWith:weakSelf.groupInfoModel.groupId];
                    imGroupModel.lastSyncMemberTime = localGroupModel.lastSyncMemberTime;
                    imGroupModel.lastSyncActiviteScoreime = localGroupModel.lastSyncActiviteScoreime;
                    [IMSDKManager toolInsertOrUpdateGroupModelWith:imGroupModel];
                }
                [weakSelf.baseTableView reloadData];
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            //如果请求失败，则从数据库中去群组信息赋值刷新
            LingIMGroupModel * groupModel = [IMSDKManager toolCheckMyGroupWith:self.groupID];
            weakSelf.groupInfoModel = [[LingIMGroup alloc] init];
            weakSelf.groupInfoModel.groupAvatar = groupModel.groupAvatar;
            weakSelf.groupInfoModel.groupName = groupModel.groupName;
            weakSelf.groupInfoModel.msgTop = groupModel.msgTop;
            weakSelf.groupInfoModel.msgNoPromt = groupModel.msgNoPromt;
            weakSelf.groupInfoModel.groupId = groupModel.groupId;
            [weakSelf.baseTableView reloadData];
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
        
    }];
}

- (void)requestAllGroupMember{
    WeakSelf;
    dispatch_async(_groupChatGetMemberQueue, ^{
        [weakSelf.groupMemberIdArr removeAllObjects];
        NSArray * memberArr = [IMSDKManager imSdkGetAllGroupMemberWith:self.groupInfoModel.groupId];
        for (LingIMGroupMemberModel *groupMemberModel  in memberArr) {
            if(groupMemberModel.memberIsInGroup){
                [weakSelf.groupMemberIdArr addObject:groupMemberModel.userUid];
            }
        }
    });
}


#pragma mark - ZBaseCellDelegate
- (void)cellClickAction:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
        {
            if (self.groupInfoModel.isShowQrCode == 0) {
                //群公告
                /**
                 * TODO: 老版本群公告页面代码
                 ZGroupModifyNoticeVC * vc = [ZGroupModifyNoticeVC new];
                 vc.groupInfoModel = self.groupInfoModel;
                 */
                ZGroupNoticeListVC *vc = [ZGroupNoticeListVC new];
                vc.groupInfoModel = self.groupInfoModel;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                if (indexPath.row == 0) {
                    [self getQtcondeContent]; //群二维码
                }
                if (indexPath.row == 1) {
                    //群公告
                    /**
                     * TODO: 老版本群公告页面代码
                     ZGroupModifyNoticeVC * vc = [ZGroupModifyNoticeVC new];
                     vc.groupInfoModel = self.groupInfoModel;
                     */
                    ZGroupNoticeListVC *vc = [ZGroupNoticeListVC new];
                    vc.groupInfoModel = self.groupInfoModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
            break;
        case 2://群管理
        {
            ZGroupManageVC * vc = [ZGroupManageVC new];
            vc.groupInfoModel = self.groupInfoModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            if (indexPath.row == 0) {
                //搜索聊天记录
                [self searchChatHistory];
            }else if (indexPath.row == 1) {
                //消息置顶
                [self sessionTopAction];
            }else if (indexPath.row == 2) {
                //消息免打扰
                [self sessionPromtAction];
            }else if (indexPath.row == 3) {
                //我的群昵称
                [self myGroupNicknameChange];
            }
        }
            break;
        case 4://清空聊天记录
        {
            [self deleteAllChatMessage];
        }
            break;
        case 5://投诉
        {
            [self complainGroup];
        }
            break;
        case 6://退出群聊
        {
            [self quiteGroup];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0://群信息
            return 1;
            break;
        case 1://群二维码、群公告
            if (self.groupInfoModel.isShowQrCode == 0) {
                return 1;
            } else {
                return 2;
            }
            break;
        case 2://群主或管理员1，群成员0
            if (self.groupInfoModel.userGroupRole == 0) {
                //群成员0
                return 0;
            } else if (self.groupInfoModel.userGroupRole == 1 || self.groupInfoModel.userGroupRole == 2) {
                //群主或管理员1
                return 1;
            } else {
                return 0;
            }
            break;
        case 3://群的功能
            return 4;
            break;
        case 4://清空聊天记录
            if ([UserManager.userRoleAuthInfo.deleteMessage.configValue isEqualToString:@"true"]) {
                return 1;
            } else {
                return 0;
            }
            break;
        case 5://投诉
            return 1;
            break;
        case 6://退出群聊
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            //群资料
            WeakSelf;
            ZChatSetGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZChatSetGroupInfoCell cellIdentifier] forIndexPath:indexPath];
            cell.groupModel = self.groupInfoModel;
            //查看群组信息
            [cell setTapGroupInfoViewBlock:^{
                ZGroupSetBasicInfoVC * vc = [ZGroupSetBasicInfoVC new];
                vc.groupInfoModel = weakSelf.groupInfoModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            //查看群组成员
            [cell setTapVisitGroupMemberBlock:^{
                //防止获取群信息接口失败，可以进行用户头像点击跳转
                if ([UserManager.userRoleAuthInfo.groupSecurity.configValue isEqualToString:@"true"]) {
                    if (!weakSelf.groupInfoModel) {
                        //[HUD showMessage:MultilingualTranslation(@"数据加载中，请稍后重试")];
                        return;
                    }
                    LingIMGroupModel *groupInfoModel = [IMSDKManager toolCheckMyGroupWith:weakSelf.groupInfoModel.groupId];
                    if (groupInfoModel.lastSyncMemberTime == 0) {
                        //[HUD showMessage:MultilingualTranslation(@"群成员同步中，请稍后")];
                        return;
                    }
                    ZGroupMemberListVC * vc = [ZGroupMemberListVC new];
                    vc.groupInfoModel = weakSelf.groupInfoModel;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    //开启了群内禁止私聊，普通群成员不可以进行用户头像点击跳转
                    if (weakSelf.groupInfoModel.isPrivateChat && weakSelf.groupInfoModel.userGroupRole == 0) return;
                    if (!weakSelf.groupInfoModel) {
                        //[HUD showMessage:MultilingualTranslation(@"数据加载中，请稍后重试")];
                        return;
                    }
                    LingIMGroupModel *groupInfoModel = [IMSDKManager toolCheckMyGroupWith:weakSelf.groupInfoModel.groupId];
                    if (groupInfoModel.lastSyncMemberTime == 0) {
                        //[HUD showMessage:MultilingualTranslation(@"群成员同步中，请稍后")];
                        return;
                    }
                    ZGroupMemberListVC * vc = [ZGroupMemberListVC new];
                    vc.groupInfoModel = weakSelf.groupInfoModel;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }];
            
            //增加群组成员回调
            [cell setTapInviteFriendBlock:^{
                if (!weakSelf.groupInfoModel) {
                    //[HUD showMessage:MultilingualTranslation(@"数据加载中，请稍后重试")];
                    return;
                }
                LingIMGroupModel *groupInfoModel = [IMSDKManager toolCheckMyGroupWith:weakSelf.groupInfoModel.groupId];
                if (groupInfoModel.lastSyncMemberTime == 0) {
                    //[HUD showMessage:MultilingualTranslation(@"群成员同步中，请稍后")];
                    return;
                }
                NSMutableArray *memberList = [NSMutableArray new];
                //群主
                LingIMGroupMemberModel *ownerModel = [IMSDKManager imSdkGetGroupOwnerWith:self.groupInfoModel.groupId exceptUserId:@""];
                if (ownerModel != nil) {
                    [memberList addObject:ownerModel];
                }
                //群管理
                NSArray *managerArr = [IMSDKManager imSdkGetGrouManagerWith:self.groupInfoModel.groupId exceptUserId:@""];
                if (managerArr != nil && managerArr.count > 0) {
                    [memberList addObjectsFromArray:managerArr];
                }
                //普通群成员
                NSArray *memberArr = [IMSDKManager imSdkGetGroupNomalMemberWith:self.groupInfoModel.groupId exceptUserId:@""];
                if (memberArr != nil && memberArr.count > 0) {
                    [memberList addObjectsFromArray:memberArr];
                }
                
                ZGroupInviteFriendVC * vc = [ZGroupInviteFriendVC new];
                vc.groupMemberList = memberList;
                vc.groupInfoModel = weakSelf.groupInfoModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            //移除群组成员
            [cell setTapRemoveFriendBlock:^{
                if (!weakSelf.groupInfoModel) {
                    //[HUD showMessage:MultilingualTranslation(@"数据加载中，请稍后重试")];
                    return;
                }
                LingIMGroupModel *groupInfoModel = [IMSDKManager toolCheckMyGroupWith:weakSelf.groupInfoModel.groupId];
                if (groupInfoModel.lastSyncMemberTime == 0) {
                    //[HUD showMessage:MultilingualTranslation(@"群成员同步中，请稍后")];
                    return;
                }
                ZGroupRemoveFriendVC * vc = [ZGroupRemoveFriendVC new];
                vc.groupInfoModel = weakSelf.groupInfoModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            return cell;
        }
            break;
        case 1:
        {
            if (self.groupInfoModel.isShowQrCode == 0) {
                //群公告
                ZChatSetGroupNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZChatSetGroupNoteCell cellIdentifier] forIndexPath:indexPath];
                cell.baseCellIndexPath = indexPath;
                cell.baseDelegate = self;
                cell.groupModel = self.groupInfoModel;
                cell.isShowLine = NO;
                return cell;
            } else {
                if (indexPath.row == 0) {
                    //群二维码
                    ZGroupSetBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZGroupSetBasicInfoCell cellIdentifier] forIndexPath:indexPath];
                    cell.baseCellIndexPath = indexPath;
                    cell.baseDelegate = self;
                    [cell cellConfigWithTitle:MultilingualTranslation(@"群二维码") model:self.groupInfoModel];
                    return cell;
                } else if (indexPath.row == 1) {
                    //群公告
                    ZChatSetGroupNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZChatSetGroupNoteCell cellIdentifier] forIndexPath:indexPath];
                    cell.baseCellIndexPath = indexPath;
                    cell.baseDelegate = self;
                    cell.groupModel = self.groupInfoModel;
                    cell.isShowLine = YES;
                    return cell;
                } else {
                    return nil;
                }
            }
            
        }
            break;
        case 2://群管理
        case 3://搜索聊天记录，消息置顶，消息免打扰，我的群昵称
        case 4://清空聊天记录
        case 5://投诉
        case 6://退出群聊
        {
            ZChatSetGroupCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZChatSetGroupCommonCell cellIdentifier] forIndexPath:indexPath];
            cell.baseCellIndexPath = indexPath;
            cell.baseDelegate = self;
            if (indexPath.section == 2) {
                [cell cellConfigWithTitle:MultilingualTranslation(@"群管理") model:self.groupInfoModel];
            } else if (indexPath.section == 3) {
                if (indexPath.row == 0) {
                    [cell cellConfigWithTitle:MultilingualTranslation(@"查看聊天记录") model:self.groupInfoModel];
                } else if (indexPath.row == 1) {
                    [cell cellConfigWithTitle:MultilingualTranslation(@"消息置顶") model:self.groupInfoModel];
                } else if (indexPath.row == 2) {
                    [cell cellConfigWithTitle:MultilingualTranslation(@"消息免打扰") model:self.groupInfoModel];
                } else if (indexPath.row == 3) {
                    [cell cellConfigWithTitle:MultilingualTranslation(@"我的群昵称") model:self.groupInfoModel];
                } else {
                    [cell cellConfigWithTitle:@"" model:self.groupInfoModel];
                }
            } else if (indexPath.section == 4) {
                [cell cellConfigWithTitle:MultilingualTranslation(@"清空聊天记录") model:self.groupInfoModel];
            } else if (indexPath.section == 5) {
                [cell cellConfigWithTitle:MultilingualTranslation(@"投诉与支持") model:self.groupInfoModel];
            } else if (indexPath.section == 6) {
                [cell cellConfigWithTitle:MultilingualTranslation(@"退出群聊") model:self.groupInfoModel];
            } else {
                [cell cellConfigWithTitle:@"" model:self.groupInfoModel];
            }
            return cell;
            
        }
            break;
            
        default:
            return [UITableViewCell new];
            break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [ZChatSetGroupInfoCell defaultCellHeight];
            break;
        case 1:
            if (self.groupInfoModel.isShowQrCode == 0) {
                //群公告
                return [ZChatSetGroupNoteCell defaultCellHeight];
            } else {
                if (indexPath.row == 0) {
                    //群二维码
                    return [ZGroupSetBasicInfoCell defaultCellHeight];
                } else if (indexPath.row == 1) {
                    //群公告
                    return [ZChatSetGroupNoteCell defaultCellHeight];
                } else {
                    return CGFLOAT_MIN;
                }
            }
          
            break;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            return [ZChatSetGroupCommonCell defaultCellHeight];
            break;
            
        default:
            return CGFLOAT_MIN;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 4) {
        if ([UserManager.userRoleAuthInfo.deleteMessage.configValue isEqualToString:@"true"]) {
            UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DWScale(16))];
            viewHeader.backgroundColor = UIColor.clearColor;
            return viewHeader;
        } else {
            return nil;
        }
    } else {
        UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DWScale(16))];
        viewHeader.backgroundColor = UIColor.clearColor;
        return viewHeader;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        if (self.groupInfoModel.userGroupRole == 0) {
            //群成员0
            return CGFLOAT_MIN;
        }else if (self.groupInfoModel.userGroupRole == 1 || self.groupInfoModel.userGroupRole == 2){
            //群主或管理员1
            return DWScale(16);
        }
    }
    if (section == 4) {
        if ([UserManager.userRoleAuthInfo.deleteMessage.configValue isEqualToString:@"true"]) {
            return DWScale(16);
        } else {
            return CGFLOAT_MIN;
        }
    }
    return DWScale(16);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - 交互事件
-  (void)searchChatHistory {
    ZChatHistoryVC *vc = [ZChatHistoryVC new];
    vc.chatType = CIMChatType_GroupChat;
    vc.sessionID = _groupID;
    vc.groupInfoModel = self.groupInfoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myGroupNicknameChange {
    if (self.groupInfoModel) {
        WeakSelf
        HomeGroupMyNicknameVC *vc = [HomeGroupMyNicknameVC new];
        vc.groupInfoModel = self.groupInfoModel;
        vc.myGroupNicknameChange = ^{
            [weakSelf.baseTableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//会话置顶
- (void)sessionTopAction {
    if (!self.groupInfoModel) return;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [dict setValue:_groupID forKey:@"groupId"];
    if (self.groupInfoModel.msgTop) {
        //取消置顶的操作
        [dict setValue:@(0) forKey:@"status"];
    }else {
        //置顶操作
        [dict setValue:@(1) forKey:@"status"];
    }
    
    WeakSelf
    [[LingIMSDKManager sharedTool] groupConversationTop:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        //更新UI
        weakSelf.groupInfoModel.msgTop = !weakSelf.groupInfoModel.msgTop;
        [weakSelf.baseTableView reloadData];
        
        //会话置顶状态发生改变
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionTopStateChange" object:nil];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//会话消息免打扰
- (void)sessionPromtAction {
    if (!self.groupInfoModel) return;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [dict setValue:_groupID forKey:@"groupId"];
    if (self.groupInfoModel.msgNoPromt) {
        //取消免打扰的操作
        [dict setValue:@(0) forKey:@"status"];
    }else {
        //免打扰操作
        [dict setValue:@(1) forKey:@"status"];
    }
    
    WeakSelf
    [[LingIMSDKManager sharedTool] groupConversationPromt:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        //更新UI
        weakSelf.groupInfoModel.msgNoPromt = !weakSelf.groupInfoModel.msgNoPromt;
        [weakSelf.baseTableView reloadData];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//清空聊天记录
- (void)deleteAllChatMessage {
    if (![NSString isNil:_groupID]) {
        ZSureCancelTipView *viewTip = [ZSureCancelTipView new];
        viewTip.lblTitle.text = MultilingualTranslation(@"清空聊天记录");
        viewTip.lblContent.text = MultilingualTranslation(@"清空当前群内聊天记录，不可撤销");
        [viewTip.btnSure setTitle:MultilingualTranslation(@"确认") forState:UIControlStateNormal];
        [viewTip.btnSure setTkThemeTitleColor:@[COLOR_FF3333,COLOR_FF3333] forState:UIControlStateNormal];
        viewTip.btnSure.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F5F6F9_DARK];
        [viewTip.btnSure setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
        [viewTip.btnSure setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
        viewTip.btnSure.titleLabel.font = FONTN(17);
        
        [viewTip.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
        [viewTip.btnCancel setTkThemeTitleColor:@[COLORWHITE,COLORWHITE] forState:UIControlStateNormal];
        viewTip.btnCancel.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF];
        [viewTip.btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
        [viewTip.btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
        viewTip.btnCancel.titleLabel.font = FONTN(17);
        WeakSelf
        viewTip.sureBtnBlock = ^{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:weakSelf.groupID forKey:@"receiveId"];
            [dict setValue:@(1) forKey:@"chatType"];//0单聊1群聊
            if (![NSString isNil:UserManager.userInfo.userUID]) {
                [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
            }
            
            [[LingIMSDKManager sharedTool] clearChatMessageHistory:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
                //清空本地缓存图片，视频，语音
                [ZMessageTools clearChatLocalImgAndVideoFromSessionId:weakSelf.groupID];
                [HUD showMessage:MultilingualTranslation(@"清除成功")];
            } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
                [HUD showMessageWithCode:code errorMsg:msg];
            }];
            
        };
        [viewTip tipViewSHow];
    }
}

//退出群聊
- (void)quiteGroup{
    if (![NSString isNil:_groupID]) {
        WeakSelf
        if (self.groupInfoModel.userGroupRole == 2) {
            //群主
            ZSureCancelTipView *viewTip = [ZSureCancelTipView new];
            viewTip.lblTitle.text = MultilingualTranslation(@"请移交群主权限！");
            viewTip.lblContent.text = MultilingualTranslation(@"您是当前群聊的群主，需移交群主权限后才可操作退群。");
            viewTip.btnCancel.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F5F6F9_DARK];
            [viewTip.btnCancel setTkThemeTitleColor:@[COLOR_66, COLOR_66_DARK] forState:UIControlStateNormal];
            viewTip.btnSure.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF];
            [viewTip.btnSure setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
            [viewTip.btnSure setTitle:MultilingualTranslation(@"移交群主") forState:UIControlStateNormal];
            viewTip.sureBtnBlock = ^{
                ZGroupChangeOwnerVC * vc = [ZGroupChangeOwnerVC new];
                vc.groupInfoModel = weakSelf.groupInfoModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [viewTip tipViewSHow];
        } else {
            LingIMSessionModel *model = [IMSDKManager toolCheckMySessionWith:_groupID];
            ZSureCancelTipView *viewTip = [ZSureCancelTipView new];
            viewTip.lblTitle.text = MultilingualTranslation(@"退出群聊");
            viewTip.lblContent.text = MultilingualTranslation(@"退出当前群聊，并清空群内聊天记录");
            viewTip.sureBtnBlock = ^{
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:weakSelf.groupID forKey:@"groupId"];
                if (![NSString isNil:UserManager.userInfo.userUID]) {
                    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
                }
                
                [IMSDKManager groupQuitWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
                    //删除会话
                    [weakSelf deleteSessionAndChatMessage];
                    //清空聊天内容
                    [IMSDKManager toolDeleteSessionModelWith:model andDeleteAllChatModel:YES];
                    //清空缓存
                    [ZMessageTools clearChatLocalImgAndVideoFromSessionId:weakSelf.groupID];
                } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
                    [HUD showMessageWithCode:code errorMsg:msg];
                }];
            };
            [viewTip tipViewSHow];
        }
    }
}

//删除会话 + 清空聊天内容 + 清除群聊
- (void)deleteSessionAndChatMessage {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_groupID forKey:@"peerUid"];
    //群聊
    [dict setValue:@(1) forKey:@"dialogType"];
    if (![NSString isNil:UserManager.userInfo.userUID]) {
        [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    }
    
    [[LingIMSDKManager sharedTool] deleteServerConversation:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        NSMutableArray *vcArr = self.navigationController.viewControllers.mutableCopy;
        [vcArr removeLastObject];
        [vcArr removeLastObject];
        weakSelf.navigationController.viewControllers = vcArr;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//投诉与支持
- (void)complainGroup {
    ZComplainVC *vc = [ZComplainVC new];
    vc.complainID = self.groupID;
    vc.complainType = CIMChatType_GroupChat;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 先获取生成二维码的content，再本地生成二维码
- (void)getQtcondeContent {
    NSString *contentStr = [NSString stringWithFormat:@"{\"groupId\":\"%@\"}", self.groupInfoModel.groupId];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:contentStr forKey:@"content"];
    [dict setObjectSafe:@2 forKey:@"type"];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    
    WeakSelf
    [HUD showActivityMessage:@""];
    [IMSDKManager UserGetCreatQrcodeContentWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD hideHUD];
        ZQRCodeModel *qrCodeModel = [ZQRCodeModel mj_objectWithKeyValues:data];
        //跳转到群二维码
        ZGroupQRCodeVC * vc = [ZGroupQRCodeVC new];
        vc.groupInfoModel = weakSelf.groupInfoModel;
        vc.qrcoceContent = ![NSString isNil:qrCodeModel.content] ? qrCodeModel.content : @"";
        vc.expireTime = qrCodeModel.expireTime;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD hideHUD];
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - 通知方法处理
//群内禁止私聊状态更新
- (void)groupNoChatStatusChange:(NSNotification *)sender {
    NSDictionary *groupNoChatDict = sender.userInfo;
    NSString *groupID = [groupNoChatDict objectForKeySafe:@"gid"];
    if ([groupID isEqualToString:_groupID]) {
        //当前群的 群内禁止私聊状态更新
        NSInteger status = [[groupNoChatDict objectForKeySafe:@"status"] integerValue];
        self.groupInfoModel.isPrivateChat = status == 1 ? YES : NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
