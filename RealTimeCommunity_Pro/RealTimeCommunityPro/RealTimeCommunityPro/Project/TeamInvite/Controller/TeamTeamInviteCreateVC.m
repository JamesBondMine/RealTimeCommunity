//
//  TeamTeamInviteCreateVC.m
//  CIMKit
//
//  Created by phl on 2025/7/22.
//  团队邀请-团队创建

#import "TeamTeamInviteCreateVC.h"
#import "IVTTeamCreateDataHandle.h"
#import "ZTeamCreateView.h"

@interface TeamTeamInviteCreateVC ()

@property (nonatomic, strong) ZTeamCreateView *teamCreateView;

@property (nonatomic, strong) IVTTeamCreateDataHandle *teamCreateDataHandle;

@end

@implementation TeamTeamInviteCreateVC

- (void)dealloc {
    CIMLog(@"%@ dealloc", [self class]);
}

- (ZTeamCreateView *)teamCreateView {
    if (!_teamCreateView) {
        _teamCreateView = [[ZTeamCreateView alloc] initWithFrame:CGRectZero
                                            TeamCreateDataHandle:self.teamCreateDataHandle];
    }
    return _teamCreateView;
}

- (IVTTeamCreateDataHandle *)teamCreateDataHandle {
    if (!_teamCreateDataHandle) {
        _teamCreateDataHandle = [IVTTeamCreateDataHandle new];
    }
    return _teamCreateDataHandle;
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
    self.navTitleStr = MultilingualTranslation(@"新建团队");
    
    // 上方导航条透明
    self.navView.tkThemebackgroundColors = @[UIColor.clearColor, UIColor.clearColor];
}

- (void)setupUI {
    [self.view addSubview:self.teamCreateView];
    [self.teamCreateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)processData {
    @weakify(self)
    [self.teamCreateDataHandle.backSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.createGroupSuccessHandle) {
            self.createGroupSuccessHandle();
        }
        [self.navigationController popViewControllerAnimated:YES];
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
