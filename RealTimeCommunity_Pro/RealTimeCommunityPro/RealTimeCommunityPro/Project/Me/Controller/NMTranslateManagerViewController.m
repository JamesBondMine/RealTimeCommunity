//
//  NMTranslateManagerViewController.m
//  CIMKit
//
//  Created by cusPro on 2023/9/26.
//

#import "NMTranslateManagerViewController.h"
//#import "ZContentTranslateViewController.h"//内容翻译
#import "ZCharacterManagerViewController.h"//字符管理
#import "ZTranslateManagerCell.h"

@interface NMTranslateManagerViewController () <UITableViewDelegate, UITableViewDataSource, ZBaseCellDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation NMTranslateManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleStr = MultilingualTranslation(@"翻译管理");
    [self setUpData];
    [self setupUI];
}

- (void)setUpData {
    self.dataArr = @[MultilingualTranslation(@"内容翻译"), MultilingualTranslation(@"字符管理")];

}

- (void)setupUI {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.bounces = NO;
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DNavStatusBarH);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
    }];
    
    [self.baseTableView registerClass:[ZTranslateManagerCell class] forCellReuseIdentifier:NSStringFromClass([ZTranslateManagerCell class])];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(54);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DWScale(16);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DWScale(16))];
    headerView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZTranslateManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZTranslateManagerCell class]) forIndexPath:indexPath];
    NSString *itemTitle = (NSString *)[self.dataArr objectAtIndex:indexPath.row];
    cell.contentStr = itemTitle;
    [cell configCellRoundWithCellIndex:indexPath.row totalIndex:self.dataArr.count];
    cell.baseCellIndexPath = indexPath;
    cell.baseDelegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ZBaseCellDelegate
- (void)cellClickAction:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //内容翻译
        //ZContentTranslateViewController *vc = [[ZContentTranslateViewController alloc] init];
        //[self.navigationController pushViewController:vc animated:YES];
    } else {
        //字符管理
        ZCharacterManagerViewController *vc = [[ZCharacterManagerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
