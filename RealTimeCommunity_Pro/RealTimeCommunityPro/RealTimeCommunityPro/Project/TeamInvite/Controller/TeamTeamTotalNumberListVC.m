//
//  TeamTeamTotalNumberListVC.m
//  CIMKit
//
//  Created by cusPro on 2025/7/23.
//  团队邀请-团队总人数

#import "TeamTeamTotalNumberListVC.h"
#import "VVTTeamMemberCell.h"
#import "ZMessageAlertView.h"
@interface TeamTeamTotalNumberListVC() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSMutableArray *teamMemberList;

/// 是否进行了踢人操作，如果进行了踢人操作，需要刷新
@property (nonatomic, assign) BOOL isOperation;

@end

@implementation TeamTeamTotalNumberListVC

- (void)dealloc {
    CIMLog(@"%@ dealloc", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _teamMemberList = [NSMutableArray array];
    _pageNumber = 1;
    
    [self configNavUI];
    [self setupUI];
    [self requestTeamMemberListData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isOperation) {
        if (self.hadTickOutPeopleBlock) {
            self.hadTickOutPeopleBlock();
        }
    }
}

#pragma mark - 界面布局
- (void)configNavUI {
//    self.navTitleStr = MultilingualTranslation(@"团队总人数");
    self.navTitleStr = MultilingualTranslation(@"团队成员");
    self.navView.tkThemebackgroundColors = @[UIColor.clearColor, UIColor.clearColor];
}

- (void)setupUI {
    
    self.view.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    
    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = [UIImage imageNamed:@"team_list_top_bgImg"];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.baseTableViewStyle = UITableViewStylePlain;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.separatorColor = COLOR_CLEAR;
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(DWScale(16));
        make.trailing.mas_equalTo(self.view).offset(DWScale(-16));
        make.top.equalTo(self.navView.mas_bottom).offset(DWScale(12));
        make.bottom.equalTo(self.view).offset(-(DHomeBarH));
    }];
    [self.baseTableView registerClass:[VVTTeamMemberCell class] forCellReuseIdentifier:NSStringFromClass([VVTTeamMemberCell class])];
}

- (void)requestTeamMemberListData {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectSafe:self.teamId forKey:@"teamId"];
    [dict setObjectSafe:@(_pageNumber) forKey:@"pageNumber"];
    [dict setObjectSafe:@(50) forKey:@"pageSize"];
    [dict setObjectSafe:@((_pageNumber - 1) * 50) forKey:@"pageStart"];
    [IMSDKManager imTeamMemberListWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = (NSDictionary *)data;
            //数据处理
            if (weakSelf.pageNumber == 1) {
                [weakSelf.teamMemberList removeAllObjects];
            }
            NSArray *teamMemberListTemp = (NSArray *)[dataDict objectForKeySafe:@"records"];
            [teamMemberListTemp enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IVTTeamMemberModel *memberModel = [IVTTeamMemberModel mj_objectWithKeyValues:obj];
                [weakSelf.teamMemberList addObjectIfNotNil:memberModel];
            }];
            [weakSelf.baseTableView reloadData];
            
            //分页处理
            NSInteger totalPage = [[dataDict objectForKeySafe:@"pages"] integerValue];
            if (weakSelf.pageNumber < totalPage) {
                if (!weakSelf.baseTableView.mj_footer) {
                    weakSelf.baseTableView.mj_footer = weakSelf.refreshFooter;
                }
            }else {
                weakSelf.baseTableView.mj_footer = nil;
            }
        }
        
        [weakSelf.baseTableView.mj_header endRefreshing];
        [weakSelf.baseTableView.mj_footer endRefreshing];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
        [weakSelf.baseTableView.mj_header endRefreshing];
        [weakSelf.baseTableView.mj_footer endRefreshing];
    }];
    
}
- (void)headerRefreshData {
    _pageNumber = 1;
    [self requestTeamMemberListData];
}
- (void)footerRefreshData {
    _pageNumber++;
    [self requestTeamMemberListData];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teamMemberList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(110);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VVTTeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VVTTeamMemberCell class]) forIndexPath:indexPath];
    IVTTeamMemberModel *model = self.teamMemberList[indexPath.row];
    cell.memberModel = model;
    [cell setTickoutCallback:^{
        ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:ZMessageAlertTypeNomal supView:nil];
        msgAlertView.lblContent.text = MultilingualTranslation(@"是否确认将该用户踢出团队？ 踢出团队以后不可恢复");
        msgAlertView.lblContent.font = FONTN(16);
        msgAlertView.lblContent.tkThemetextColors = @[COLOR_33, COLOR_33_DARK];
        msgAlertView.lblContent.textAlignment = NSTextAlignmentCenter;
        [msgAlertView.btnSure setTitle:MultilingualTranslation(@"确认") forState:UIControlStateNormal];
        [msgAlertView.btnSure setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
        msgAlertView.btnSure.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF_DARK];
        [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
        [msgAlertView.btnCancel setTkThemeTitleColor:@[COLOR_66, COLOR_66_DARK] forState:UIControlStateNormal];
        msgAlertView.btnCancel.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F6F6F6_DARK];
        msgAlertView.isSizeDivide = YES;
        [msgAlertView alertShow];
        
        @weakify(self)
        msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
            @strongify(self)
            // 标记用户操作
            self.isOperation = YES;
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObjectSafe:model.userUid forKey:@"memberId"];
            [dict setObjectSafe:self.teamId forKey:@"teamId"];
            [IMSDKManager imTeamKickTeamWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
                [ZTOOL doInMain:^{
                    if (data) {
                        [HUD showMessage:MultilingualTranslation(@"踢出团队成功")];
                        NSArray<IVTTeamMemberModel *> *filteredArray = [self.teamMemberList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userUid != %@", model.userUid]];
                        self.teamMemberList = [NSMutableArray arrayWithArray:filteredArray];
                        [self.baseTableView reloadData];
                    }
                }];
                
            } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
                [HUD showMessageWithCode:code errorMsg:msg];
            }];
        };
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
