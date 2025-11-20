//
//  ZRaceCheckErrorViewController.m
//  CIMKit
//
//  Created by cusPro on 2024/5/11.
//

#import "ZRaceCheckErrorViewController.h"
#import "ZRaceCheckErrorModel.h"
#import "ZRaceCheckErrorCell.h"

@interface ZRaceCheckErrorViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZRaceCheckErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navTitleStr = MultilingualTranslation(@"异常详情");
    [self setupUI];
}

- (void)setupUI {
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.bounces = NO;
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.estimatedRowHeight = DWScale(92);
    self.baseTableView.tkThemebackgroundColors = @[COLORWHITE, COLORWHITE_DARK];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(DNavStatusBarH);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DHomeBarH);
    }];
    
    [self.baseTableView registerClass:[ZRaceCheckErrorCell class] forCellReuseIdentifier:NSStringFromClass([ZRaceCheckErrorCell class])];
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    
    [self.baseTableView reloadData];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRaceCheckErrorCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZRaceCheckErrorCell class]) forIndexPath:indexPath];
    
    ZRaceCheckErrorModel *errorModel = (ZRaceCheckErrorModel *)[self.dataArr objectAtIndex:indexPath.row];
    cell.cellIndex = indexPath.row;
    cell.model = errorModel;
    return cell;
}

@end
