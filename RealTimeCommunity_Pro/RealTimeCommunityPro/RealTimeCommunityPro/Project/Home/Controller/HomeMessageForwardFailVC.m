//
//  HomeMessageForwardFailVC.m
//  CIMKit
//
//  Created by cusPro on 2024/3/18.
//

#import "HomeMessageForwardFailVC.h"
#import "HomeMessageForwardFailCell.h"
#import "FMsgPrecheckModel.h"

@interface HomeMessageForwardFailVC () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation HomeMessageForwardFailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleStr = MultilingualTranslation(@"转发失败");
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.baseTableView];
    self.baseTableView.dataSource = self;
    self.baseTableView.delegate = self;
    self.baseTableView.separatorColor = COLOR_CLEAR;
    self.baseTableView.tkThemebackgroundColors = @[COLORWHITE, COLOR_33];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DNavStatusBarH);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-DHomeBarH);
    }];
    [self.baseTableView registerClass:[HomeMessageForwardFailCell class] forCellReuseIdentifier:NSStringFromClass([HomeMessageForwardFailCell class])];
}

- (void)setForwardErroInfoList:(NSArray *)forwardErroInfoList {
    _forwardErroInfoList = forwardErroInfoList;
    
    [self.baseTableView reloadData];
}

#pragma mark - Tableview delegate dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _forwardErroInfoList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(68);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeMessageForwardFailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeMessageForwardFailCell class]) forIndexPath:indexPath];
    FMsgPrecheckModel *preCheckModel = [_forwardErroInfoList objectAtIndexSafe:indexPath.row];
    cell.preCheckFailModel = preCheckModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
