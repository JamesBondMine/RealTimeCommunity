//
//  NMBlackListViewController.m
//  CIMKit
//
//  Created by cusPro on 2022/11/13.
//

#import "NMBlackListViewController.h"
#import "ZChineseSort.h"
#import "ZBlackListHeaderView.h"
#import "ZBlackListCell.h"
#import "NFUserHomePageVC.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface NMBlackListViewController () <UITableViewDataSource,UITableViewDelegate, MGSwipeTableCellDelegate, DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
//黑名单列表
@property (nonatomic, strong) NSMutableArray *blackList;
//排序后的出现过的拼音首字母数组
@property (nonatomic, strong) NSMutableArray *blackLetterArr;

@end

@implementation NMBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleStr = MultilingualTranslation(@"黑名单");
    [self setupUI];
    [self requestData];
}

- (void)requestData {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [IMSDKManager getBlackListFromServerWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        NSArray *dataArr = (NSArray *)data;
        NSMutableArray *blackListArr = [NSMutableArray array];
        for (NSDictionary *blackMemberDic in dataArr) {
            LingIMFriendModel * friendModel = [LingIMFriendModel mj_objectWithKeyValues:blackMemberDic];
            if(![NSString isNil:friendModel.remarks]){
                friendModel.showName = friendModel.remarks;
            } else {
                friendModel.showName = friendModel.nickname;
            }
            friendModel.showName = [NSString loadNickNameWithUserStatus:friendModel.disableStatus realNickName:friendModel.showName];
            [blackListArr addObject:friendModel];
        }
        [weakSelf configListData:blackListArr];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

- (void)setupUI {
    [self.view addSubview:self.baseTableView];
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.emptyDataSetSource = self;
    self.baseTableView.emptyDataSetDelegate = self;
    self.baseTableView.separatorColor = COLOR_CLEAR;
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DNavStatusBarH);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-DHomeBarH);
    }];
}

- (void)configListData:(NSArray *)dataArr {
    if (dataArr.count >0) {
        WeakSelf
        ZChineseSortSetting *manager = [ZChineseSortSetting share];
        manager.specialCharPositionIsFront = NO;//#结尾
        [ZChineseSort sortAndGroup:dataArr key:@"showName" finish:^(bool isSuccess, NSMutableArray *unGroupedArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
            if (isSuccess) {
                weakSelf.blackLetterArr = sectionTitleArr;
                weakSelf.blackList = sortedObjArr;
                [weakSelf.baseTableView reloadData];
            }
        }];
    }
}

#pragma mark - Tableview delegate dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.blackLetterArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArr = [self.blackList objectAtIndexSafe:section];
    return sectionArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(68);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return DWScale(32);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *headerID = @"ZBlackListHeaderView";
    ZBlackListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[ZBlackListHeaderView alloc] initWithReuseIdentifier:headerID];
    }
    headerView.contentLabel.text = [self.blackLetterArr objectAtIndex:section];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZBlackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZBlackListCell"];
    if (cell == nil){
        cell = [[ZBlackListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZBlackListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LingIMFriendModel *tempModel = [[self.blackList objectAtIndexSafe:indexPath.section] objectAtIndexSafe:indexPath.row];
    cell.blackModel = tempModel;
    cell.delegate = self;//设置代理
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LingIMFriendModel *friendModel = [[self.blackList objectAtIndexSafe:indexPath.section] objectAtIndexSafe:indexPath.row];
    NFUserHomePageVC *vc = [NFUserHomePageVC new];
    vc.userUID = friendModel.friendUserUID;
    vc.groupID = @"";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point {
    return YES;
}

- (NSArray<UIView *> *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings {
    
    if (direction == MGSwipeDirectionRightToLeft) {
        swipeSettings.transition = MGSwipeTransitionBorder;//动画效果
        expansionSettings.buttonIndex = 0;//可展开按钮索引
        expansionSettings.fillOnTrigger = NO;//是否填充
        expansionSettings.threshold = 10.0;//触发阈值
        
        NSIndexPath *cellIndex = [self.baseTableView indexPathForCell:cell];
      
        WeakSelf
        //从右到左滑动
        MGSwipeButton *btnRemove = [MGSwipeButton buttonWithTitle:MultilingualTranslation(@"移出黑名单") icon:ImgNamed(@"remi_icon_black_list_remove") backgroundColor:COLOR_FF504E callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
            [weakSelf removeUserFromBlackListWith:cellIndex];
            return NO;
        }];
        btnRemove.titleLabel.font = FONTR(12);
        btnRemove.buttonWidth = DWScale(86);
        [btnRemove setBtnImageAlignmentType:ButtonImageAlignmentTypeTop imageSpace:DWScale(6)];
        
        return @[btnRemove];
    } else {
        return @[];
    }
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

#pragma mark - DZNEmptyDataSetDelegate
//允许滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - Action
- (void)removeUserFromBlackListWith:(NSIndexPath *)indexPath {
    //移除黑名单
    LingIMFriendModel *removeFriendModel = [[self.blackList objectAtIndexSafe:indexPath.section] objectAtIndexSafe:indexPath.row];
    // status  黑名单状态(1:加入,0:移除)
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [dict setValue:removeFriendModel.friendUserUID forKey:@"friendUserUid"];
    [dict setValue:@(0) forKey:@"status"];
    
    [IMSDKManager removeUserFromBlackListWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        BOOL removeResult = [data boolValue];
        if (removeResult) {
            //移除黑名单
            NSMutableArray *sectionArr = [self.blackList objectAtIndexSafe:indexPath.section];
            if (sectionArr.count == 1) {
                [weakSelf.blackLetterArr removeObjectAtIndex:indexPath.section];
            }
            [sectionArr removeObjectAtIndex:indexPath.row];
            if (sectionArr.count == 0) {
                [weakSelf.blackList removeObject:sectionArr];
            }
            [weakSelf.baseTableView reloadData];
        } else {
            [HUD showMessage:MultilingualTranslation(@"移除失败")];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - Lazy
- (NSMutableArray *)blackList {
    if (!_blackList) {
        _blackList = [[NSMutableArray alloc] init];
    }
    return _blackList;
}

- (NSMutableArray *)blackLetterArr {
    if (!_blackLetterArr) {
        _blackLetterArr = [[NSMutableArray alloc] init];
    }
    return _blackLetterArr;
}

@end
