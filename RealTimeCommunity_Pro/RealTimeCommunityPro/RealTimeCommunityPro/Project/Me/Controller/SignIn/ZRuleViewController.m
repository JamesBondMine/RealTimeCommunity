//
//  ZRuleViewController.m
//  CIMKit
//
//  Created by Apple on 2023/8/9.
//

#import "ZRuleViewController.h"
#import "YYTextLayout.h"
#import "ZRuleContentHeader.h"
#import "ZRuleRewardHeader.h"
#import "ZRuleRewardCell.h"

@interface ZRuleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *signRewardList;

@end

@implementation ZRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    self.navTitleStr = MultilingualTranslation(@"签到规则");
    
    [self signSetupUI];
}

-(void)signSetupUI {
    if (self.signRuleModel.signMode == 2) {
        //连签模式
        NSDictionary *rewardDic = [NSDictionary dictionaryWithJsonString:self.signRuleModel.signContinueReward];
        // 获取字典的所有键并排序
        NSArray *allKeys = [rewardDic allKeys];
        // 获取所有键并排序
        NSArray *sortedKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSInteger num1 = [obj1 integerValue];
            NSInteger num2 = [obj2 integerValue];
            return (num1 > num2) ? NSOrderedDescending : NSOrderedAscending;
        }];
        // 提取有序值
        for (NSString *key in sortedKeys) {
            NSDictionary *subDict = @{key: rewardDic[key]};
            [self.signRewardList addObject:subDict];
        }
    }
    
    self.baseTableViewStyle = UITableViewStyleGrouped;
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    self.baseTableView.separatorColor = COLOR_CLEAR;
    self.baseTableView.delaysContentTouches = NO;
    self.baseTableView.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];
    [self.view addSubview:self.baseTableView];
    [self.baseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(16);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-16);
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-DHomeBarH);
    }];
    [self.baseTableView registerClass:[ZRuleRewardCell class] forCellReuseIdentifier:NSStringFromClass([ZRuleRewardCell class])];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return self.signRewardList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(40);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.ruleContentAttHeight + DWScale(20);
    } else {
        if (self.signRuleModel.signMode == 2) {
            return DWScale(40);
        } else {
            return CGFLOAT_MIN;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ZRuleContentHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZRuleContentHeader"];
        if (headerView == nil) {
            headerView = [[ZRuleContentHeader alloc] initWithReuseIdentifier:@"ZRuleContentHeader"];
        }
        headerView.ruleContentAtt = self.ruleContentAtt;
        return headerView;
    } else {
        if (self.signRuleModel.signMode == 2) {
            ZRuleRewardHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZRuleRewardHeader"];
            if (headerView == nil) {
                headerView = [[ZRuleRewardHeader alloc] initWithReuseIdentifier:@"ZRuleRewardHeader"];
            }
            return headerView;
        } else {
            return nil;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZRuleRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZRuleRewardCell"];
    if (cell == nil){
        cell = [[ZRuleRewardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZRuleRewardCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.baseCellIndexPath = indexPath;
    NSDictionary *rewardDataDic = [self.signRewardList objectAtIndexSafe:indexPath.row];
    cell.rewardDic = rewardDataDic;
    return cell;
}


#pragma mark - Lazy
- (NSMutableArray *)signRewardList {
    if (!_signRewardList) {
        _signRewardList = [[NSMutableArray alloc] init];
    }
    return _signRewardList;
}

@end
