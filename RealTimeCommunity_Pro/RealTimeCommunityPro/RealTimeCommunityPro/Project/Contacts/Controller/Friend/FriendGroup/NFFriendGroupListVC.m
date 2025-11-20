//
//  NFFriendGroupListVC.m
//  CIMKit
//
//  Created by cusPro on 2023/7/3.
//

#import "NFFriendGroupListVC.h"
#import "NFFriendGroupSectionHeaderView.h"
#import "CNContactListTableCell.h"
#import "CMFriendGroupModel.h"
#import "ZToolManager.h"//工具类
#import "ZChineseSort.h"//排序
//跳转
#import "NFUserHomePageVC.h"//用户主页
#import "NFFriendGroupManagerVC.h"//分组管理

@interface NFFriendGroupListVC () <UITableViewDataSource, UITableViewDelegate, CIMToolUserDelegate, ZBaseCellDelegate, NFFriendGroupSectionHeaderViewDelegate, CIMToolUserDelegate>

//好友分组列表
@property (nonatomic, strong) NSMutableArray *friendGroupList;
//好友分组列表展开的数据
@property (nonatomic, strong) NSMutableArray *friendGroupOpenList;
@property (nonatomic, strong) UIView *viewNoData;
@end

@implementation NFFriendGroupListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _friendGroupList = [NSMutableArray array];
    _friendGroupOpenList = [NSMutableArray array];

    [self requestFriendGroupListFromDB];
    
    [IMSDKManager addUserDelegate:self];
    
    [self setupUI];
    
    [self setupNoDataUI];
}

#pragma mark - 界面布局
- (void)setupNoDataUI {
    _viewNoData = [UIView new];
    _viewNoData.tkThemebackgroundColors = @[COLOR_CLEAR, COLOR_CLEAR_DARK];
    _viewNoData.hidden = YES;
    [self.view addSubview:_viewNoData];
    [_viewNoData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(DScreenWidth, DScreenWidth * 0.8));
        make.centerY.equalTo(self.baseTableView).offset(-DWScale(100));
    }];
    
    UIImageView *ivNoData = [[UIImageView alloc] initWithImage:ImgNamed(@"com_c_no_history_chat")];
    ivNoData.contentMode = UIViewContentModeScaleAspectFit;
    [_viewNoData addSubview:ivNoData];
    [ivNoData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_viewNoData);
        make.centerX.equalTo(_viewNoData);
    }];
    
    UILabel *lblNoData = [UILabel new];
    lblNoData.text = MultilingualTranslation(@"暂无分组");
    lblNoData.font = FONTR(14);
    lblNoData.tkThemetextColors = @[COLOR_00, COLOR_00_DARK];
    [_viewNoData addSubview:lblNoData];
    [lblNoData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_viewNoData);
        make.centerX.equalTo(_viewNoData);
    }];
}
- (void)setupUI {
    self.navView.hidden = YES;
    
    //列表布局
    [self.view addSubview:self.baseTableView];
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.backgroundColor = UIColor.clearColor;
    [self.baseTableView registerClass:[CNContactListTableCell class] forCellReuseIdentifier:[CNContactListTableCell cellIdentifier]];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //默认不可滑动
    self.baseTableView.scrollEnabled = NO;
}
- (void)friendGroupListScrollEnable:(BOOL)canScroll {
    self.baseTableView.scrollEnabled = canScroll;
    if (!canScroll) {
        [self.baseTableView setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_friendGroupList.count > 0) {
        _viewNoData.hidden = YES;
    }else {
        _viewNoData.hidden = NO;
    }
    
    return _friendGroupList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CMFriendGroupModel *friendGroupModel = [_friendGroupList objectAtIndexSafe:section];
    
    if (friendGroupModel.openedSection) {
        return friendGroupModel.friendList.count;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CNContactListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[CNContactListTableCell cellIdentifier] forIndexPath:indexPath];
    
    CMFriendGroupModel *friendGroupModel = [_friendGroupList objectAtIndexSafe:indexPath.section];
    CMFriendModel *tempModel = [friendGroupModel.friendList objectAtIndexSafe:indexPath.row];
    LingIMFriendModel *friendModel = [LingIMFriendModel mj_objectWithKeyValues:[tempModel mj_JSONString]];
    cell.friendModel = friendModel;
    cell.baseDelegate = self;
    cell.baseCellIndexPath = indexPath;
    cell.viewOnline.hidden = !friendModel.onlineStatus;
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(68);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *headerID = @"NFFriendGroupSectionHeaderView";
    
    NFFriendGroupSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (headerView == nil) {
        headerView = [[NFFriendGroupSectionHeaderView alloc] initWithReuseIdentifier:headerID];
    }
    
    //更新赋值
    headerView.delegate = self;
    headerView.friendGroupModel = [_friendGroupList objectAtIndexSafe:section];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return DWScale(54);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - ZBaseCellDelegate
- (void)cellClickAction:(NSIndexPath *)indexPath {
    CMFriendGroupModel *friendGroupModel = [_friendGroupList objectAtIndexSafe:indexPath.section];
    CMFriendModel *friendModel = [friendGroupModel.friendList objectAtIndexSafe:indexPath.row];
    if (friendModel.userType == 0) {
        //好友 普通用户级别
        NFUserHomePageVC *vc = [NFUserHomePageVC new];
        vc.userUID = friendModel.friendUserUID;
        vc.groupID = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
    }else {
        [self friendGroupListScrollEnable:NO];
        //告知上层进行滑动
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactScrollEnable" object:nil];
    }
}

#pragma mark - NFFriendGroupSectionHeaderViewDelegate
- (void)friendGroupSectionOpenWith:(CMFriendGroupModel *)friendGroupModel {
    [self.baseTableView reloadData];
    
    if (friendGroupModel.openedSection) {
        //展开
        if (![_friendGroupOpenList containsObject:friendGroupModel.friendGroupModel.ugUuid]) {
            [_friendGroupOpenList addObjectIfNotNil:friendGroupModel.friendGroupModel.ugUuid];
        }
    }else {
        //关闭
        if ([_friendGroupOpenList containsObject:friendGroupModel.friendGroupModel.ugUuid]) {
            [_friendGroupOpenList removeObject:friendGroupModel.friendGroupModel.ugUuid];
        }
    }
}

- (void)friendGroupSectionLongPress {
    //分组管理
    ZPresentItem *item = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"分组管理") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(56) backgroundColor:COLORWHITE];
    
    //取消
    ZPresentItem *cancelItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"取消") textColor:COLOR_99 font:FONTR(17) itemHeight:DWScale(52) backgroundColor:COLORWHITE];
    
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            item.textColor = COLOR_33;
            item.backgroundColor = COLORWHITE;
            
            cancelItem.textColor = COLOR_B3B3B3;
            cancelItem.backgroundColor = COLORWHITE;
        } else {
            item.textColor = COLORWHITE;
            item.backgroundColor = COLOR_33;
            
            cancelItem.textColor = COLOR_99;
            cancelItem.backgroundColor = COLOR_33;
        }
    };
    
    WeakSelf
    ZPresentView *viewAlert = [[ZPresentView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DScreenHeight) titleItem:nil selectItems:@[item] cancleItem:cancelItem doneClick:^(NSInteger index) {
        NFFriendGroupManagerVC *vc = [NFFriendGroupManagerVC new];
        vc.friendGroupCanEdit = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } cancleClick:^{
        //取消
    }];
    
    [CurrentWindow addSubview:viewAlert];
    [viewAlert showPresentView];
}

#pragma mark - CIMToolUserDelegate
- (void)imSdkUserFriendGroupChange {
    [self requestFriendGroupListFromDB];
}

#pragma mark - 请求好友分组信息
- (void)requestFriendGroupListFromDB {
    WeakSelf
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *newFriednGroupList = [[NSMutableArray alloc] init];
        
        NSArray *friendGroupListTemp = [IMSDKManager toolGetMyFriendGroupList];
        __block NSMutableArray *tempFriendArray = [NSMutableArray new];
        [friendGroupListTemp enumerateObjectsUsingBlock:^(LingIMFriendGroupModel * _Nonnull friendGroupModel, NSUInteger idx, BOOL * _Nonnull stop) {
            CMFriendGroupModel * cMFriendGroupModel = [CMFriendGroupModel new];
            cMFriendGroupModel.friendGroupModel = friendGroupModel;
            if ([weakSelf.friendGroupOpenList containsObject:friendGroupModel.ugUuid]){
                //展开
                cMFriendGroupModel.openedSection = YES;
            }else {
                //未展开
                cMFriendGroupModel.openedSection = NO;
            }
            [newFriednGroupList addObjectIfNotNil:cMFriendGroupModel];
        }];
        
        [newFriednGroupList enumerateObjectsUsingBlock:^(CMFriendGroupModel * _Nonnull CMFriendGroupModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *friendGroupID = CMFriendGroupModel.friendGroupModel.ugUuid;
            //找到该好友分组下的好友列表
            NSMutableArray *friendListForGroup = [NSMutableArray array];
            if (CMFriendGroupModel.friendGroupModel.ugType == -1) {
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
            //在线离线排序
            [friendListForGroup enumerateObjectsUsingBlock:^(CMFriendModel * _Nonnull friendModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if (friendModel.userType == 0) {
                    NSString *jsonStr = [friendModel mj_JSONString];
                    CMFriendModel *model = [CMFriendModel mj_objectWithKeyValues:jsonStr];
                    NSMutableString *tempSortName;
                    if (![NSString isNil:model.userName]) {
                        tempSortName = [NSMutableString stringWithFormat:@"%@%@", model.showName, model.userName];
                    } else {
                        tempSortName = [NSMutableString stringWithFormat:@"%@", model.showName];
                    }
                    
                    //判断字符串是否包含汉字
                    NSString *pattern = @".*[\u4e00-\u9fa5].*";
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
                    if ([predicate evaluateWithObject:tempSortName]) {//包含汉字
                        NSMutableString *result = [NSMutableString string];
                        //遍历待汉字的字符串
                        for (int i = 0; i < tempSortName.length; i++) {
                            unichar character = [tempSortName characterAtIndex:i];
                            //判断该字符是否为汉字
                            if ((character >= 0x4e00 && character <= 0x9fff)) {
                                NSString *chineseCharacter = [NSString stringWithCharacters:&character length:1];
                                NSMutableString *pinyinString = [chineseCharacter mutableCopy];
                                CFStringTransform((__bridge CFMutableStringRef)pinyinString, NULL, kCFStringTransformMandarinLatin, NO);
                                // 去除拼音中的空格和音标
                                NSString *resultPinyinString = [pinyinString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
                                NSString *pinyinInitial = [resultPinyinString safeSubstringWithRange:NSMakeRange(0, 1)];
                                [result appendString:pinyinInitial];
                            } else {
                                // 字母、数字等直接添加到结果中
                                [result appendString:[NSString stringWithFormat:@"%c", character]];
                            }
                        }
                        tempSortName = result;
                    }
                    //去除空格
                    model.sortName = [[tempSortName stringByReplacingOccurrencesOfString:@" " withString:@""] uppercaseString];
                    [tempFriendArray addObject:model];
                }

            }];
            // 使用NSSortDescriptor进行排序
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sortName" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
                return [self customCompare:obj1 str2:obj2 index:0];
            }];
            NSArray *sortedFriendsArray = [tempFriendArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            __block NSMutableArray *friendList = [NSMutableArray array];//总好友列表
            __block NSMutableArray *friendOnLineList = [NSMutableArray array];//在线好友列表
            __block NSMutableArray *friendOffLineList = [NSMutableArray array];//离线好友列表
            __block NSMutableArray *friendSignOutList = [NSMutableArray array];//注销好友列表
            
            [sortedFriendsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CMFriendModel *objModel = (CMFriendModel *)obj;
                if (objModel.disableStatus == 4) {
                    //注销账号
                    [friendSignOutList addObjectIfNotNil:objModel];
                }else {
                    if (objModel.onlineStatus) {
                        [friendOnLineList addObjectIfNotNil:objModel];
                    }else {
                        [friendOffLineList addObjectIfNotNil:objModel];
                    }
                }
            }];
            [friendList addObjectsFromArray:friendOnLineList];
            [friendList addObjectsFromArray:friendOffLineList];
            [friendList addObjectsFromArray:friendSignOutList];
            
            CMFriendGroupModel.friendList = friendList;
            CMFriendGroupModel.friendOnLineList = friendOnLineList;
            CMFriendGroupModel.friendOffLineList = friendOffLineList;
            CMFriendGroupModel.friendSignOutList = friendSignOutList;
            [tempFriendArray removeAllObjects];
            [weakSelf.friendGroupList removeAllObjects];
            [weakSelf.friendGroupList addObjectsFromArray:newFriednGroupList];
            [ZTOOL doInMain:^{
                [weakSelf.baseTableView reloadData];
            }];
        }];
    });
}

- (NSComparisonResult)customCompare:(NSString *)str1 str2:(NSString *)str2 index:(NSUInteger)index {
    unichar char1 = [str1 characterAtIndex:index];
    unichar char2 = [str2 characterAtIndex:index];

    if (char1 == char2) {
        // 如果相同位置的字符相等，递归比较下一个位置
        if (index < str1.length - 1 && index < str2.length - 1) {
            return [self customCompare:str1 str2:str2 index:index+1];
        }
    } else {
        NSCharacterSet *letterCharacterSet = [NSCharacterSet letterCharacterSet];
        NSCharacterSet *digitCharacterSet = [NSCharacterSet decimalDigitCharacterSet];
        
        NSInteger typeA;
        if ([letterCharacterSet characterIsMember:char1]) {
            typeA = 10;
        } else if ([digitCharacterSet characterIsMember:char1]) {
            typeA = 8;
        } else {
            return 0;
        }
        
        NSInteger typeB;
        if ([letterCharacterSet characterIsMember:char2]) {
            typeB = 10;
        } else if ([digitCharacterSet characterIsMember:char2]) {
            typeB = 8;
        } else {
            return 0;
        }
        
        if (typeA > typeB) {
            return NSOrderedAscending;
        } else if (typeA < typeB) {
            return NSOrderedDescending;
        } else {
            return [@(char1) compare:@(char2)];
        }
    }

    // 如果相同位置的字符相等，或者已经比较到字符串末尾，则按照字符串长度进行比较
    return [@(str1.length) compare:@(str2.length)];
}
@end
