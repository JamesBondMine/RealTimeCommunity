//
//  ZGroupNoticeListVC.m
//  CIMKit
//
//  Created by phl on 2025/8/11.
//

#import "ZGroupNoticeListVC.h"
#import "LLGroupGNNoticeListView.h"
#import "GGNBroupNoticeListDataHandle.h"
#import "ZGroupModifyNoticeVC.h"
#import "ZGroupNoticeDetailVC.h"

@interface ZGroupNoticeListVC ()

/// 列表展示
@property (nonatomic, strong) LLGroupGNNoticeListView *listView;

/// 数据处理类
@property (nonatomic, strong) GGNBroupNoticeListDataHandle *dataHandle;

@end

@implementation ZGroupNoticeListVC

- (LLGroupGNNoticeListView *)listView {
    if (!_listView) {
        _listView = [[LLGroupGNNoticeListView alloc] initWithFrame:CGRectZero GroupNoticeListDataHandle:self.dataHandle];
    }
    return _listView;
}

- (GGNBroupNoticeListDataHandle *)dataHandle {
    if (!_dataHandle) {
        _dataHandle = [[GGNBroupNoticeListDataHandle alloc] initWithGroupInfo:self.groupInfoModel];
    }
    return _dataHandle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpUI];
    [self processData];
    // Do any additional setup after loading the view.
}

/// 设置导航
- (void)setUpNav {
    self.navTitleStr = MultilingualTranslation(@"群公告");
    
    [self.navBtnRight setTitle:MultilingualTranslation(@"新建") forState:UIControlStateNormal];
    [self.navBtnRight setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
    self.navBtnRight.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF];
    self.navBtnRight.titleLabel.font = FONTM(14);
    [self.navBtnRight rounded:DWScale(12)];
    [self.navBtnRight mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel);
        make.trailing.equalTo(self.navView).offset(-DWScale(20));
        make.height.mas_equalTo(DWScale(32));
        make.width.mas_equalTo(DWScale(60));
    }];
    
    @weakify(self)
    [[self.navBtnRight rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        CIMLog(@"点击了群公告列表创建按钮");
        ZGroupModifyNoticeVC *vc = [ZGroupModifyNoticeVC new];
        self.groupInfoModel.groupNotice = nil;
        vc.groupInfoModel = self.groupInfoModel;
        vc.groupNoticeSuccessBlock = ^{
            [self.listView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    if (self.groupInfoModel.userGroupRole == 1 || self.groupInfoModel.userGroupRole == 2) {
        // 只有管理员跟群主能新建
        self.navBtnRight.hidden = NO;
    }else {
        // 普通用户无新建
        self.navBtnRight.hidden = YES;
    }
}

/// 设置UI
- (void)setUpUI {
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];
}

- (void)processData {
    @weakify(self)
    [self.dataHandle.jumpGroupInfoDetailSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        ZGroupNoteModel *groupNoticeModel = x;
        ZGroupNoticeDetailVC *vc = [ZGroupNoticeDetailVC new];
        vc.groupInfoModel = self.groupInfoModel;
        vc.groupNoticeModel = groupNoticeModel;
        vc.deleteNoticyCallback = ^{
            [self reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.dataHandle.jumpEditSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        ZGroupNoteModel *groupNoticeModel = x;
        ZGroupModifyNoticeVC *vc = [ZGroupModifyNoticeVC new];
        self.groupInfoModel.groupNotice = groupNoticeModel;
        vc.groupInfoModel = self.groupInfoModel;
        vc.groupNoticeSuccessBlock = ^{
            [self reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)reloadData {
    [self.listView reloadData];
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
