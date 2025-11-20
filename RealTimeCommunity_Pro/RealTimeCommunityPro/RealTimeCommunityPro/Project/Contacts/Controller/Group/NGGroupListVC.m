//
//  NGGroupListVC.m
//  CIMKit
//
//  Created by cusPro on 2022/9/9.
//

#import "NGGroupListVC.h"
#import "MainSearchView.h"
#import "CNGroupListCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "NHChatViewController.h"//聊天界面
#import "ZToolManager.h"//工具类

@interface NGGroupListVC () <MainSearchViewDelegate,CIMToolGroupDelegate,UITableViewDataSource,UITableViewDelegate,ZBaseCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    dispatch_queue_t _groupListQueue;
}

@property (nonatomic, strong) MainSearchView *viewSearch;
@property (nonatomic, strong) NSMutableArray *groupList;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation NGGroupListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _groupList = [NSMutableArray array];
    _pageNum = 1;
    _groupListQueue = dispatch_queue_create("com.CIMKit.groupListQueue", DISPATCH_QUEUE_SERIAL);
    
    [self initTableView];
    
    [self requestGroupListFromDB];
    [IMSDKManager addGroupDelegate:self];
    
}

//初始化TableView
-(void)initTableView{
    
    self.navView.hidden = YES;
    
    _viewSearch = [[MainSearchView alloc] initWithPlaceholder:MultilingualTranslation(@"搜索")];
    _viewSearch.frame = CGRectMake(0, DWScale(6), DScreenWidth, DWScale(38));
    _viewSearch.currentViewSearch = YES;
    _viewSearch.delegate = self;
    _viewSearch.showClearBtn = YES;
    _viewSearch.hidden = YES;
    [self.view addSubview:_viewSearch];
    
    [self.view addSubview:self.baseTableView];
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.emptyDataSetSource = self;
    self.baseTableView.emptyDataSetDelegate = self;
    self.baseTableView.backgroundColor = UIColor.clearColor;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //默认不可滑动
    self.baseTableView.scrollEnabled = NO;
    
}
- (void)groupListScrollEnable:(BOOL)canScroll {
    self.baseTableView.scrollEnabled = canScroll;
    if (!canScroll) {
        [self.baseTableView setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *string = MultilingualTranslation(@"暂无群聊");
    __block NSMutableAttributedString *accessAttributeString;
    self.view.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        switch (themeIndex) {
            case 1:
            {
                //暗黑
                accessAttributeString  = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:FONTR(14),NSForegroundColorAttributeName:COLOR_00_DARK}];
            }
                break;
                
            default:
            {
                accessAttributeString  = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:FONTR(14),NSForegroundColorAttributeName:COLOR_00}];
            }
                break;
        }
    };
    
    return accessAttributeString;
}
//图片距离中心偏移量
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -DWScale(100);
}
//空态图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImgNamed(@"com_c_no_history_chat");
}

#pragma mark - DZNEmptyDataSetDelegate
//允许滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groupList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CNGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:[CNGroupListCell cellIdentifier]];
    if (cell == nil){
        cell = [[CNGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CNGroupListCell cellIdentifier]];
    }
    LingIMGroupModel *model = [_groupList objectAtIndexSafe:indexPath.row];
    cell.groupModel = model;
    cell.baseDelegate = self;
    cell.baseCellIndexPath = indexPath;
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CNGroupListCell defaultCellHeight];
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    LingIMGroupModel *model = [_groupList objectAtIndexSafe:indexPath.row];
//    NHChatViewController *vc = [NHChatViewController new];
//    vc.chatType = CIMChatType_GroupChat;
//    vc.chatName = model.groupName;
//    vc.sessionID = model.groupId;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
    }else {
        [self groupListScrollEnable:NO];
        //告知上层进行滑动
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactScrollEnable" object:nil];
    }
}

#pragma mark - ZBaseCellDelegate
- (void)cellClickAction:(NSIndexPath *)indexPath {
    LingIMGroupModel *model = [_groupList objectAtIndexSafe:indexPath.row];
    NHChatViewController *vc = [NHChatViewController new];
    vc.chatType = CIMChatType_GroupChat;
    vc.chatName = model.groupName;
    vc.sessionID = model.groupId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - MainSearchViewDelegate
- (void)searchViewTextValueChanged:(NSString *)searchStr {
    NSString *search = [searchStr trimString];
    if (![NSString isNil:search]) {
        _groupList = [IMSDKManager toolSearchMyGroupWith:search].mutableCopy;
    }else {
        _groupList = [IMSDKManager toolGetMyGroupList].mutableCopy;
    }
    [self.baseTableView reloadData];
}

#pragma mark - CIMToolGroupDelegate
- (void)cimToolGroupReceiveWith:(LingIMGroupModel *)model {
    [self requestGroupListFromDB];
}
- (void)cimToolGroupUpdateWith:(LingIMGroupModel *)model {
    [self requestGroupListFromDB];
}
- (void)cimToolGroupDeleteWith:(LingIMGroupModel *)model {
    [self requestGroupListFromDB];
}
- (void)imSdkGroupSyncFinish {
    DLog(@"同步服务器群组成功");
    [self requestGroupListFromDB];
}
- (void)imSdkGroupSyncFailed:(NSString *)errorMsg {
    DLog(@"同步服务器群组失败:%@",errorMsg);
}

#pragma mark - 数据处理
//数据更新群组列表数据
- (void)requestGroupListFromDB {
    WeakSelf
    dispatch_async(_groupListQueue, ^{
        weakSelf.groupList = [[IMSDKManager toolGetMyGroupList] mutableCopy];
        [ZTOOL doInMain:^{
            [weakSelf.baseTableView reloadData];                    
        }];
    });
}

@end
