//
//  FileFileHelperSetVC.m
//  CIMKit
//
//  Created by cusPro on 2023/6/7.
//

#import "FileFileHelperSetVC.h"
#import "ChatZZSingleSetCommonCell.h"
#import "ZChatHistoryVC.h"//查找聊天记录
#import "ZMessageAlertView.h"
#import "ZMessageTools.h"


@interface FileFileHelperSetVC () <UITableViewDataSource, UITableViewDelegate, ZBaseCellDelegate>
//好友 文件助手 信息
@property (nonatomic, strong) LingIMFriendModel *friendModel;
@end

@implementation FileFileHelperSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitleStr = MultilingualTranslation(@"设置");
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    
    self.friendModel = [IMSDKManager toolCheckMyFriendWith:self.sessionID];
    if (!self.friendModel) {
        [self requestUserInfo];
    }
    
    //用户角色权限发生变化(是否线上文件助手)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRoleAuthorityFileHelperChange) name:@"UserRoleAuthorityFileHelperChangeNotification" object:nil];
    
    [self setupUI];
}

#pragma mark - 界面布局
- (void)setupUI {
    [self defaultTableViewUI];
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.delaysContentTouches = NO;
    [self.baseTableView registerClass:[ChatZZSingleSetCommonCell class] forCellReuseIdentifier:[ChatZZSingleSetCommonCell cellIdentifier]];
}

#pragma mark - 数据请求
- (void)requestUserInfo {
    WeakSelf
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [params setValue:self.sessionID forKey:@"friendUserUid"];
    [IMSDKManager getFriendInfoWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = (NSDictionary *)data;

            LingIMFriendModel *friendModel = [LingIMFriendModel mj_objectWithKeyValues:dataDict];
            friendModel.showName = friendModel.remarks.length > 0 ? friendModel.remarks : friendModel.nickname;
            [DBTOOL insertModelToTable:CIMDBFriendTableName model:friendModel];
            weakSelf.friendModel = friendModel;
            
        }
        [weakSelf.baseTableView reloadData];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0://查找聊天记录 消息置顶
            return 2;
            break;
        case 1://清空聊天记录
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatZZSingleSetCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChatZZSingleSetCommonCell cellIdentifier] forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell cellConfigWith:ChatSingleSetCellTypeCommon itemStr:MultilingualTranslation(@"查找聊天记录") model:self.friendModel];
            cell.baseDelegate = self;
            cell.viewLine.hidden = NO;
            cell.baseCellIndexPath = indexPath;
            [cell setCornerRadiusWithIsShow:YES location:CornerRadiusLocationTop];
        }else {
            [cell cellConfigWith:ChatSingleSetCellTypeSelect itemStr:MultilingualTranslation(@"消息置顶") model:self.friendModel];
            cell.baseDelegate = self;
            cell.viewLine.hidden = YES;
            cell.baseCellIndexPath = indexPath;
            [cell setCornerRadiusWithIsShow:YES location:CornerRadiusLocationBottom];
            cell.btnAction.selected = self.friendModel.msgTop;
        }
        
    }else if (indexPath.section == 1) {
        [cell cellConfigWith:ChatSingleSetCellTypeCommon itemStr:MultilingualTranslation(@"清空聊天记录") model:self.friendModel];
        cell.viewLine.hidden = YES;
        cell.baseDelegate = self;
        cell.baseCellIndexPath = indexPath;
        [cell setCornerRadiusWithIsShow:YES location:CornerRadiusLocationAll];
        cell.ivArrow.hidden = YES;
    }
    return cell;
}

#pragma mark - ZBaseCellDelegate
- (void)cellClickAction:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //查看聊天记录
            ZChatHistoryVC *vc = [ZChatHistoryVC new];
            vc.chatType = CIMChatType_SingleChat;
            vc.sessionID = _sessionID;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            //消息置顶
            [self sessionTop];
        }
    }else {
        //清空聊天记录
        if (![NSString isNil:_sessionID]) {
            ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeNomal supView:nil];
            msgAlertView.lblContent.text = MultilingualTranslation(@"清空聊天记录");
            [msgAlertView.btnSure setTitle:MultilingualTranslation(@"确认") forState:UIControlStateNormal];
            [msgAlertView.btnSure setTkThemeTitleColor:@[COLOR_FF3333,COLOR_FF3333] forState:UIControlStateNormal];
            msgAlertView.btnSure.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_66];
            [msgAlertView.btnSure setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateSelected];
            [msgAlertView.btnSure setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_EEEEEE],[UIImage ImageForColor:COLOR_EEEEEE_DARK]] forState:UIControlStateHighlighted];
            
            [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
            [msgAlertView.btnCancel setTkThemeTitleColor:@[COLORWHITE,COLORWHITE] forState:UIControlStateNormal];
            msgAlertView.btnCancel.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF];
            [msgAlertView.btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateSelected];
            [msgAlertView.btnCancel setTkThemeBackgroundImage:@[[UIImage ImageForColor:COLOR_4069B9],[UIImage ImageForColor:COLOR_4069B9_DARK]] forState:UIControlStateHighlighted];
            [msgAlertView alertShow];
            WeakSelf
            msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
                [weakSelf requestClearSingleHistory];
            };
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ChatZZSingleSetCommonCell defaultCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DWScale(16))];
    viewHeader.backgroundColor = UIColor.clearColor;
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DWScale(16);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Notification
- (void)userRoleAuthorityFileHelperChange {
    if ([UserManager.userRoleAuthInfo.isShowFileAssistant.configValue isEqualToString:@"false"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 交互事件
//会话置顶
- (void)sessionTop {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [dict setValue:_sessionID forKey:@"friendUserUid"];
    if (_friendModel.msgTop) {
        //取消置顶的操作
        [dict setValue:@(0) forKey:@"status"];
    }else {
        //置顶操作
        [dict setValue:@(1) forKey:@"status"];
    }
    
    WeakSelf
    [[LingIMSDKManager sharedTool] singleConversationTop:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        //更新操作，已放在SDK里，用户无感实现
        //更新数据
        weakSelf.friendModel.msgTop = !weakSelf.friendModel.msgTop;
        [weakSelf.baseTableView reloadData];
        
        //会话置顶状态发生改变
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionTopStateChange" object:nil];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//清空聊天记录
- (void)requestClearSingleHistory {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_sessionID forKey:@"receiveId"];
    [dict setValue:@(0) forKey:@"chatType"];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    
    [[LingIMSDKManager sharedTool] clearChatMessageHistory:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        
        [ZMessageTools clearChatLocalImgAndVideoFromSessionId:weakSelf.sessionID];
        [HUD showMessage:MultilingualTranslation(@"清除成功")];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
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
