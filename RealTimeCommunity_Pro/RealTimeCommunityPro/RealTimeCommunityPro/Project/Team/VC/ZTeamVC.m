//
//  ZTeamVC.m
//  CIMKit
//
//  Created by cusPro on 2023/7/19.
//

#import "ZTeamVC.h"
#import "NTTeamHomeHeaderView.h"
#import "NTTeamTitleHeaderView.h"
#import "ZTeamCell.h"
#import "NTMTeamModel.h"
#import "ZTeamManagerVC.h"
#import "ZTeamDetailVC.h"
#import "NMShareInviteViewController.h"
#import "ZAlertTipView.h"
#import "NTTeamUpdateNameView.h"

@interface ZTeamVC () <UITableViewDelegate, UITableViewDataSource, ZTeamHomeHeaderViewDelegate, ZTeamUpdateNameViewDelegate>

@property (nonatomic, strong) NSMutableArray *teamList;
@property (nonatomic, strong) NSMutableArray *defaultDataArr;
@property (nonatomic, strong) NTMTeamModel *defaultTeamModel;
@property (nonatomic, strong) UIButton *quickCreateBtn;

@end

@implementation ZTeamVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestTeamHomeData];
    [self requestTeamListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _teamList = [NSMutableArray array];
    _defaultDataArr = [NSMutableArray array];
    
    [self configNavUI];
    [self setupUI];
}

#pragma mark - 界面布局
- (void)configNavUI {
    self.navTitleStr = MultilingualTranslation(@"团队邀请");
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:MultilingualTranslation(@"分享默认") forState:UIControlStateNormal];
    [self.navBtnRight setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
}

- (void)setupUI {
    
    self.view.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    
    self.baseTableViewStyle = UITableViewStylePlain;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.separatorColor = COLOR_CLEAR;
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-(DTabBarH + DWScale(25) + DWScale(44) + DWScale(25)));
    }];
    [self.baseTableView registerClass:[NTTeamHomeHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([NTTeamHomeHeaderView class])];
    [self.baseTableView registerClass:[NTTeamTitleHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([NTTeamTitleHeaderView class])];
    [self.baseTableView registerClass:[ZTeamCell class] forCellReuseIdentifier:NSStringFromClass([ZTeamCell class])];
    
    //一键建群
    self.quickCreateBtn = [UIButton new];
    [self.quickCreateBtn setTitle:MultilingualTranslation(@"一键建群") forState:UIControlStateNormal];
    [self.quickCreateBtn setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
    self.quickCreateBtn.tkThemebackgroundColors = @[COLOR_81D8CF, COLOR_81D8CF];
    self.quickCreateBtn.titleLabel.font = FONTN(14);
    [self.quickCreateBtn rounded:DWScale(8)];
    [self.quickCreateBtn addTarget:self action:@selector(defaultTeamQuickCreateGroupClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.quickCreateBtn];
    [self.quickCreateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(DWScale(25));
        make.trailing.equalTo(self.view).offset(-DWScale(25));
        make.bottom.equalTo(self.view).offset(-(DTabBarH + DWScale(25)));
        make.height.mas_equalTo(DWScale(44));
    }];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return self.defaultDataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_teamList.count > 0) {
            return DWScale(140);
        } else {
            return 0;
        }
    } else {
        return DWScale(50);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NTTeamHomeHeaderView *viewHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NTTeamHomeHeaderView class])];
        viewHeader.headerTeamList = self.teamList;
        viewHeader.delegate = self;
        return viewHeader;
    } else {
        NTTeamTitleHeaderView *viewHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([NTTeamTitleHeaderView class])];
        return viewHeader;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTeamCell class]) forIndexPath:indexPath];
    NSDictionary *dict = [self.defaultDataArr objectAtIndex:indexPath.row];
    cell.titleStr = (NSString *)[dict objectForKeySafe:@"titleStr"];
    cell.subTitleStr = (NSString *)[dict objectForKeySafe:@"subTitleStr"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //修改团队名称
            NTTeamUpdateNameView *viewUpdate = [NTTeamUpdateNameView new];
            viewUpdate.model = self.defaultTeamModel;
            viewUpdate.delegate = self;
            [viewUpdate updateViewShow];
        }
        if (indexPath.row == 1) {
            //复制团队邀请码
            if (![NSString isNil:_defaultTeamModel.inviteCode]) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = _defaultTeamModel.inviteCode;
                [HUD showMessage:MultilingualTranslation(@"复制成功")];
            }
        }
    }
}

#pragma mark - ZTeamHomeHeaderViewDelegate
- (void)headerTeamListTitleAction {
    //团队列表
    ZTeamManagerVC *vc = [[ZTeamManagerVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerTeamItemAction:(NTMTeamModel *)teamModel {
    //团队详情
    if (![NSString isNil:teamModel.teamId]) {
        ZTeamDetailVC *vc = [ZTeamDetailVC new];
        vc.teamModel = teamModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)headerSetDefaultTeamAction:(NTMTeamModel *)model {
    //设置为默认
    [self requestSetDefaultTeam:model];
}

#pragma mark - ZTeamUpdateNameViewDelegate
- (void)teamUpdateNameAction:(NSString *)newName {
    [self requestTeamHomeData];
    [self requestTeamListData];
}

#pragma mark - Action
//一键建群
- (void)defaultTeamQuickCreateGroupClick {
    if (_defaultTeamModel.totalInviteNum >= 3) {
        WeakSelf
        ZAlertTipView *alertView = [ZAlertTipView new];
        alertView.lblTitle.text = MultilingualTranslation(@"提示");
        alertView.lblTitle.font = FONTB(16);
        alertView.lblContent.text = MultilingualTranslation(@"建群时只会拉取你的好友");
        alertView.lblContent.font = FONTN(15);
        self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
            UIColor *color = nil;
            if (themeIndex == 0) {
                color = COLOR_66;
            } else {
                color = COLOR_66_DARK;
            }
           alertView.lblContent.textColor = color;
        };
        [alertView.btnSure setTitle:MultilingualTranslation(@"确定") forState:UIControlStateNormal];
        [alertView.btnSure setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
        [alertView.btnCancel setTkThemeTitleColor:@[COLOR_33, COLOR_33_DARK] forState:UIControlStateNormal];
        [alertView alertTipViewSHow];
        alertView.sureBtnBlock = ^{
            [weakSelf requestTeamCreateGroup];
        };
    } else {
        [HUD showMessage:MultilingualTranslation(@"人数不足三人，无法创建群聊")];
    }
}

#pragma mark - 数据请求
- (void)requestTeamHomeData {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    [IMSDKManager imTeamHomeWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = (NSDictionary *)data;
            weakSelf.defaultTeamModel = [NTMTeamModel mj_objectWithKeyValues:dataDic];
            weakSelf.defaultTeamModel.teamName = MultilingualTranslation(weakSelf.defaultTeamModel.teamName);
            [weakSelf updateDataAndUI];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

- (void)requestTeamListData {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:@(1) forKey:@"pageNumber"];
    [dict setObjectSafe:@(20) forKey:@"pageSize"];
    [dict setObjectSafe:@(0) forKey:@"pageStart"];
    [IMSDKManager imTeamListWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            //数据处理
            [weakSelf.teamList removeAllObjects];
            NSDictionary *dataDict = (NSDictionary *)data;
            NSArray *teamListTemp = (NSArray *)[dataDict objectForKeySafe:@"records"];
            [teamListTemp enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NTMTeamModel *model = [NTMTeamModel mj_objectWithKeyValues:obj];
                if([model.teamName isEqualToString:@"默认团队"]){
                    model.teamName = MultilingualTranslation(@"默认团队");
                }
                [weakSelf.teamList addObjectIfNotNil:model];
            }];
            
            [weakSelf.baseTableView reloadData];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//设置为默认
- (void)requestSetDefaultTeam:(NTMTeamModel *)teamModel {
    if (teamModel && teamModel.isDefaultTeam != 1) {
        //设置为默认团队
        WeakSelf
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObjectSafe:teamModel.teamId forKey:@"teamId"];
        [dict setObjectSafe:@(1) forKey:@"isDefaultTeam"];
        [IMSDKManager imTeamEditWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
            teamModel.isDefaultTeam = 1;
            [HUD showMessage:MultilingualTranslation(@"设置成功")];
            [weakSelf requestTeamHomeData];
            [weakSelf requestTeamListData];
        } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
            [HUD showMessageWithCode:code errorMsg:msg];
        }];
    }
}

//一键建群
- (void)requestTeamCreateGroup {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:self.defaultTeamModel.teamId forKey:@"teamId"];
    [IMSDKManager imTeamCreateGroupWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        [HUD showMessage:MultilingualTranslation(@"操作成功")];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}


- (void)updateDataAndUI {
    if (_defaultTeamModel) {
        [_defaultDataArr removeAllObjects];
        
        [_defaultDataArr addObject:@{@"titleStr":MultilingualTranslation(@"团队名称"), @"subTitleStr":_defaultTeamModel.teamName}];
        [_defaultDataArr addObject:@{@"titleStr":MultilingualTranslation(@"邀请码"), @"subTitleStr":_defaultTeamModel.inviteCode}];
        
        [_defaultDataArr addObject:@{@"titleStr":MultilingualTranslation(@"团队总人数"), @"subTitleStr":[NSString stringWithFormat:@"%ld", (long)_defaultTeamModel.totalInviteNum]}];
        
        [_defaultDataArr addObject:@{@"titleStr":MultilingualTranslation(@"团队关联群聊数"), @"subTitleStr":[NSString stringWithFormat:@"%ld", (long)_defaultTeamModel.groupNum]}];
        
        [_defaultDataArr addObject:@{@"titleStr":MultilingualTranslation(@"昨日邀请"), @"subTitleStr":[NSString stringWithFormat:@"%ld", (long)_defaultTeamModel.yesterdayInviteNum]}];
        
        [_defaultDataArr addObject:@{@"titleStr":MultilingualTranslation(@"今日邀请"), @"subTitleStr":[NSString stringWithFormat:@"%ld", (long)_defaultTeamModel.todayInviteNum]}];
        
        [_defaultDataArr addObject:@{@"titleStr":MultilingualTranslation(@"本月邀请"), @"subTitleStr":[NSString stringWithFormat:@"%ld", (long)_defaultTeamModel.mouthInviteCount]}];
       
        [self.baseTableView reloadData];
    }
}
#pragma mark - 交互事件
- (void)navBtnRightClicked {
    if (![NSString isNil:_defaultTeamModel.teamId]) {
        NMShareInviteViewController *vc = [NMShareInviteViewController new];
        vc.teamID = _defaultTeamModel.teamId;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
