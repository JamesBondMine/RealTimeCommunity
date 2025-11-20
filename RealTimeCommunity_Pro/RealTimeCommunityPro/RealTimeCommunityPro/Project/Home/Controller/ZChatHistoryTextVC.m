//
//  ZChatHistoryTextVC.m
//  CIMKit
//
//  Created by cusPro on 2022/11/11.
//

#import "ZChatHistoryTextVC.h"
#import "MainSearchView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "ChatHHHistoryHeaderView.h"
#import "ZChatHistoryTextCell.h"
#import "HomeChatHistoryChoiceUserVC.h"

@interface ZChatHistoryTextVC () <MainSearchViewDelegate,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ZBaseCellDelegate, ChatHHHistoryHeaderViewDelegate, ZChatHistoryChoiceUserDelegate>

@property (nonatomic, strong) ChatHHHistoryHeaderView *selectHeadView;
@property (nonatomic, strong) NSMutableArray *historyList;
@property (nonatomic, copy) NSString *searchStr;

@end

@implementation ZChatHistoryTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navView.hidden = YES;
    _historyList = [NSMutableArray array];
    _searchStr = @"";
    
    [self setupUI];
    [self refreshHeaderView];
}

#pragma mark - 界面布局
- (void)setupUI {
    MainSearchView *viewSearch = [[MainSearchView alloc] initWithPlaceholder:MultilingualTranslation(@"搜索")];
    viewSearch.frame = CGRectMake(0, DWScale(6), DScreenWidth, DWScale(38));
    viewSearch.currentViewSearch = YES;
    viewSearch.delegate = self;
    viewSearch.returnKeyType = UIReturnKeyDefault;
    [self.view addSubview:viewSearch];
    
    self.selectHeadView = [[ChatHHHistoryHeaderView alloc] init];
    self.selectHeadView.delegate = self;
    [self.view addSubview:self.selectHeadView];
    [self.selectHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewSearch.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(DWScale(38));
    }];
    
    [self.view addSubview:self.baseTableView];
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.emptyDataSetSource = self;
    self.baseTableView.emptyDataSetDelegate = self;
    self.baseTableView.delaysContentTouches = NO;
    [self.baseTableView registerClass:[ZChatHistoryTextCell class] forCellReuseIdentifier:[ZChatHistoryTextCell cellIdentifier]];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectHeadView.mas_bottom).offset(DWScale(6));
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
    }];
}


- (void)refreshHeaderView{
    if (self.chatType == CIMChatType_GroupChat) {
        self.selectHeadView.hidden = self.groupInfo.closeSearchUser;
        [self.selectHeadView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.groupInfo.closeSearchUser ? DWScale(0) : DWScale(38));
        }];
    }
}


#pragma mark - 返回到指定VC
- (void)popToVC {
    WeakSelf
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //返回到聊天界面
        if ([NSStringFromClass([obj class]) isEqualToString:@"NHChatViewController"]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
        //返回到文件助手界面
        if ([NSStringFromClass([obj class]) isEqualToString:@"FileFileHelperVC"]) {
            [weakSelf.navigationController popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

#pragma mark - MainSearchViewDelegate
- (void)searchViewReturnKeySearch:(NSString *)searchStr {
    if (![NSString isNil:[searchStr trimString]] && ![NSString isNil:_sessionID]) {
        _searchStr = [searchStr trimString];
        [self checkLocalDBData];
        [self.view endEditing:YES];
    }
}

- (void)searchViewTextValueChanged:(NSString *)searchStr {
    if ([NSString isNil:searchStr]) {
        _searchStr = @"";
        if(self.selectHeadView.userInfoList.count <= 0) {
            //清空搜索内容
            [_historyList removeAllObjects];
            [self.baseTableView reloadData];
        } else {
            [self checkLocalDBData];
        }
    }
}

#pragma mark - ChatHHHistoryHeaderViewDelegate
- (void)headerClickAction {
    HomeChatHistoryChoiceUserVC *vc = [[HomeChatHistoryChoiceUserVC alloc] init];
    vc.choicedList = self.selectHeadView.userInfoList;
    vc.chatType = self.chatType;
    vc.sessionID = self.sessionID;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerResetAction {
    if([NSString isNil:self.searchStr]) {
        [_historyList removeAllObjects];
        [self.baseTableView reloadData];
    } else {
        [self checkLocalDBData];
    }
}

#pragma mark - ZChatHistoryChoiceUserDelegate
- (void)chatHistoryChoicedUserList:(NSArray<ZBaseUserModel *> *)selectedUserList {
    self.selectHeadView.userInfoList = [selectedUserList mutableCopy];
    if(self.selectHeadView.userInfoList.count <= 0 && [NSString isNil:self.searchStr]) {
        [_historyList removeAllObjects];
        [self.baseTableView reloadData];
    } else {
        [self checkLocalDBData];
    }
}

#pragma mark - 搜索数据库
- (void)checkLocalDBData {
    NSMutableArray *userIdList = [NSMutableArray array];
    for (ZBaseUserModel *userModel in self.selectHeadView.userInfoList) {
        [userIdList addObject:userModel.userId];
    }
    _historyList = [IMSDKManager toolGetChatMessageHistoryWith:_sessionID offset:0 messageType:@[@(CIMChatMessageType_TextMessage),@(CIMChatMessageType_AtMessage)] textMessageLike:_searchStr userIdList:userIdList].mutableCopy;
    [self.baseTableView reloadData];
}

#pragma mark - ZBaseCellDelegate
- (void)cellClickAction:(NSIndexPath *)indexPath {
    LingIMChatMessageModel *model = [_historyList objectAtIndexSafe:indexPath.row];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.msgID forKey:@"selectMessageID"];
    [dict setValue:@(model.sendTime) forKey:@"selectMessageSendTime"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatHistorySelectMessage" object:nil userInfo:dict];
    
    [self performSelector:@selector(popToVC) withObject:self afterDelay:0.5];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZChatHistoryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZChatHistoryTextCell cellIdentifier] forIndexPath:indexPath];
    cell.baseCellIndexPath = indexPath;
    cell.baseDelegate = self;
    LingIMChatMessageModel *model = [_historyList objectAtIndexSafe:indexPath.row];
    [cell configCellWith:model searchContent:_searchStr];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZChatHistoryTextCell defaultCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - DZNEmptyDataSetSource
//图片距离中心偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return DWScale(-120);
}

//空态图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImgNamed(@"com_c_no_history_chat");
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (![NSString isNil:_searchStr]) {
        NSString *string = MultilingualTranslation(@"换个关键词试试吧～");
        NSMutableAttributedString *accessAttributeString  = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:FONTR(16),NSForegroundColorAttributeName:COLOR_81D8CF}];
        return accessAttributeString;
    }else {
        NSString *string = @" ";
        NSMutableAttributedString *accessAttributeString  = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:FONTR(16),NSForegroundColorAttributeName:COLOR_81D8CF}];
        return accessAttributeString;
    }
}

#pragma mark - DZNEmptyDataSetDelegate
//允许滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
