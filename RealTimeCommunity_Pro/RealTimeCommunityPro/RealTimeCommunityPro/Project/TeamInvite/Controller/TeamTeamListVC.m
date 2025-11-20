//
//  TeamTeamListVC.m
//  CIMKit
//
//  Created by phl on 2025/7/21.
//  团队邀请-团队列表UI

#import "TeamTeamListVC.h"
#import "IVTTeamListDataHandle.h"
#import "WidgetTeamListView.h"
#import "TeamTeamInviteCreateVC.h"
#import "TeamTeamInviteDetailVC.h"

@interface TeamTeamListVC ()

@property (nonatomic, strong) WidgetTeamListView *teamListView;

@property (nonatomic, strong) IVTTeamListDataHandle *teamListDataHandle;

@end

@implementation TeamTeamListVC

- (void)dealloc {
    CIMLog(@"%@ dealloc", [self class]);
}

- (WidgetTeamListView *)teamListView {
    if (!_teamListView) {
        _teamListView = [[WidgetTeamListView alloc] initWithFrame:CGRectZero
                                          TeamListDataHandle:self.teamListDataHandle];
    }
    return _teamListView;
}

- (IVTTeamListDataHandle *)teamListDataHandle {
    if (!_teamListDataHandle) {
        _teamListDataHandle = [IVTTeamListDataHandle new];
    }
    return _teamListDataHandle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavUI];
    [self setupUI];
    [self processData];
}

// MARK: UI
/// 界面布局
- (void)configNavUI {
//    self.view.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    
    self.navTitleStr = MultilingualTranslation(@"团队列表");
    
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:MultilingualTranslation(@"新建团队") forState:UIControlStateNormal];
    [self.navBtnRight setTkThemeTitleColor:@[COLOR_81D8CF, COLOR_81D8CF_DARK] forState:UIControlStateNormal];
    
    // 上方导航条透明
    self.navView.tkThemebackgroundColors = @[UIColor.clearColor, UIColor.clearColor];
}

- (void)setupUI {
    [self.view addSubview:self.teamListView];
    [self.teamListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)processData {
    @weakify(self)
    [self.teamListView.jumpDetailVCSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        TeamTeamInviteDetailVC *detailVC = [TeamTeamInviteDetailVC new];
        if ([x isKindOfClass:[NTMTeamModel class]]) {
            NTMTeamModel *teamModel = x;
            detailVC.currentTeamModel = teamModel;
        }
        detailVC.reloadDataBlock = ^{
            @strongify(self)
            [self.teamListView reloadData];
        };
        [self.navigationController pushViewController:detailVC animated:YES];
    }];
}

- (void)navBtnRightClicked {
    TeamTeamInviteCreateVC *createVC = [TeamTeamInviteCreateVC new];
    @weakify(self)
    createVC.createGroupSuccessHandle = ^{
        @strongify(self)
        [self.teamListView reloadData];
    };
    [self.navigationController pushViewController:createVC animated:YES];
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
