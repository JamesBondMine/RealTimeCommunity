//
//  NMSafeSettingViewController.m
//  CIMKit
//
//  Created by cusPro on 2022/11/13.
//

#import "NMSafeSettingViewController.h"
#import "ZSafeSettingCell.h"
#import "ZInputOldPasswordViewController.h"
#import "ZInputNewPasswordViewController.h"
#import "ZGestureLockSetVC.h"
#import "ZGestureLockCheckVC.h"
#import "ZMessageAlertView.h"
#import "ZSafeCodeSettingViewController.h"
#import "ZSafeCodeChangeViewController.h"
#import "ZSafeCodeCloseViewController.h"

@interface NMSafeSettingViewController () <UITableViewDelegate, UITableViewDataSource, ZBaseCellDelegate, ZGestureLockCheckVCDelegate>

@property (nonatomic, strong)NSArray *dataArr;
@property (nonatomic, assign)BOOL safeCodeStatus;

@end

@implementation NMSafeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleStr = MultilingualTranslation(@"安全设置");
    [self setUpData];
    [self setupUI];
    [self requestCheckDeviceSafeCodeStatus];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadGesturePassword) name:@"UserSetGesturePassword" object:nil];
}

- (void)setUpData {
    self.dataArr = @[MultilingualTranslation(@"修改密码"), MultilingualTranslation(@"手势图案解锁"), MultilingualTranslation(@"设备安全码")];
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
    
    [self.baseTableView registerClass:[ZSafeSettingCell class] forCellReuseIdentifier:NSStringFromClass([ZSafeSettingCell class])];
}

//检查是否设置过设备安去码
- (void)checkDeviceSafeCodeStatus {
    [self requestCheckDeviceSafeCodeStatus];
}

#pragma mark - NetWork
- (void)requestCheckUserHasSetPwd {
    //通过userName去检查该账号是否设置过密码
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:UserManager.userInfo.userName forKey:@"loginInfo"];
    [params setObjectSafe:@"" forKey:@"areaCode"];
    [params setObjectSafe:[NSNumber numberWithInt:1] forKey:@"loginType"];
    
    WeakSelf
    [IMSDKManager authUserExistAndHasPwdWith:params onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDict = (NSDictionary *)data;
            BOOL pwdExit = [[dataDict objectForKey:@"pwdExit"] boolValue];
            if (pwdExit) {
                //存在密码
                ZInputOldPasswordViewController *oldPasswordVC = [[ZInputOldPasswordViewController alloc] init];
                [weakSelf.navigationController pushViewController:oldPasswordVC animated:YES];
            } else {
                //不存在密码
                ZInputNewPasswordViewController *newPwInputVC = [[ZInputNewPasswordViewController alloc] init];
                [weakSelf.navigationController pushViewController:newPwInputVC animated:YES];
            }
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

//检查是否设置过设备安去码
- (void)requestCheckDeviceSafeCodeStatus {
    WeakSelf
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:UserManager.userInfo.userUID forKey:@"userUid"];
    [IMSDKManager getUserInfoWith:dict onSuccess:^(id _Nullable data, NSString * _Nullable traceId) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userDict = (NSDictionary *)data;
            ZUserModel *userModel = [ZUserModel mj_objectWithKeyValues:userDict];
            weakSelf.safeCodeStatus = userModel.hasSecurityCode;
            [weakSelf.baseTableView reloadData];
        }
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [HUD showMessageWithCode:code errorMsg:msg];
    }];
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DWScale(70);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSafeSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZSafeSettingCell class]) forIndexPath:indexPath];
    cell.titleStr = (NSString *)[self.dataArr objectAtIndex:indexPath.row];
    cell.contentStr = @"";
    cell.baseCellIndexPath = indexPath;
    cell.baseDelegate = self;
    
    switch (indexPath.row) {
        case 0://修改密码
            break;
        case 1://手势图案解锁
        {
            NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
            NSString *gesturePasswordJson = [[MMKV defaultMMKV] getStringForKey:userKey];
            if (![NSString isNil:gesturePasswordJson]) {
                cell.contentStr = MultilingualTranslation(@"开启");
            }else {
                cell.contentStr = MultilingualTranslation(@"关闭");
            }
        }
            break;
        case 2://设备安全码
        {
            if (self.safeCodeStatus) {
                cell.contentStr = MultilingualTranslation(@"开启");
            } else {
                cell.contentStr = MultilingualTranslation(@"关闭");
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Action
- (void)cellClickAction:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //修改密码
        [self requestCheckUserHasSetPwd];
    } else if (indexPath.row == 1) {
        //手势图案解锁
        NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
        NSString *gesturePassword = [[MMKV defaultMMKV] getStringForKey:userKey];
        if (![NSString isNil:gesturePassword]) {
            //提示
            [self gestureLockAlertTipView];
            
        }else {
            //设置密码
            ZGestureLockSetVC *vc = [ZGestureLockSetVC new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
            
        }
    } else if (indexPath.row == 2) {
        //设备安全码
        if (self.safeCodeStatus) {
            //提示
            [self deviceSafeCodeAlertTipView];
        } else {
            ZSafeCodeSettingViewController *vc = [[ZSafeCodeSettingViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - ZGestureLockCheckVCDelegate
- (void)gestureLockCheckResultType:(GestureLockCheckResultType)checkResultType checkType:(GestureLockCheckType)checkType {
    if (checkResultType == GestureLockCheckResultTypeRight) {
        if (checkType == GestureLockCheckTypeClose) {
            //关闭手势密码
            [HUD showMessage:MultilingualTranslation(@"关闭手势密码")];
            NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
            [[MMKV defaultMMKV] removeValueForKey:userKey];
            
            [self.baseTableView reloadData];
        }else if (checkType == GestureLockCheckTypeChange) {
            //修改手势密码
            ZGestureLockSetVC *vc = [ZGestureLockSetVC new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }else {
            //普通手势密码验证
        }
    }
}

#pragma mark - 提示弹窗
//手势锁屏
- (void)gestureLockAlertTipView {
    WeakSelf
    ZPresentItem *changeItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"修改手势密码") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(56) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            changeItem.textColor = COLOR_33;
            changeItem.backgroundColor = COLORWHITE;
        }else {
            changeItem.textColor = COLORWHITE;
            changeItem.backgroundColor = COLOR_33;
        }
    };
    
    ZPresentItem *closeItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"关闭手势密码") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(56) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            closeItem.textColor = COLOR_33;
            closeItem.backgroundColor = COLORWHITE;
        }else {
            closeItem.textColor = COLORWHITE;
            closeItem.backgroundColor = COLOR_33;
        }
    };
    
    ZPresentItem *cancelItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"取消") textColor:COLOR_99 font:FONTR(17) itemHeight:DWScale(52) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            cancelItem.textColor = COLOR_B3B3B3;
            cancelItem.backgroundColor = COLORWHITE;
        }else {
            cancelItem.textColor = COLOR_99;
            cancelItem.backgroundColor = COLOR_33;
        }
    };
    
    ZPresentView *viewAlert = [[ZPresentView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DScreenHeight) titleItem:nil selectItems:@[changeItem, closeItem] cancleItem:cancelItem doneClick:^(NSInteger index) {
        if (index == 0) {
            //修改手势密码
            [weakSelf changeGestureLock];
        }else if (index == 1) {
            //关闭手势密码
            [weakSelf closeGestureLock];
        }
        
    } cancleClick:^{
    }];
    [self.view addSubview:viewAlert];
    [viewAlert showPresentView];
}

- (void)changeGestureLock {
    ZGestureLockCheckVC *vc = [ZGestureLockCheckVC new];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.checkType = GestureLockCheckTypeChange;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)closeGestureLock {
    ZGestureLockCheckVC *vc = [ZGestureLockCheckVC new];
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.checkType = GestureLockCheckTypeClose;
    [self presentViewController:vc animated:YES completion:nil];
}

//安全码
- (void)deviceSafeCodeAlertTipView {
    WeakSelf
    ZPresentItem *changeItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"修改安全码") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(56) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            changeItem.textColor = COLOR_33;
            changeItem.backgroundColor = COLORWHITE;
        }else {
            changeItem.textColor = COLORWHITE;
            changeItem.backgroundColor = COLOR_33;
        }
    };
    
    ZPresentItem *closeItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"关闭安全码") textColor:COLOR_33 font:FONTR(17) itemHeight:DWScale(56) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            closeItem.textColor = COLOR_33;
            closeItem.backgroundColor = COLORWHITE;
        }else {
            closeItem.textColor = COLORWHITE;
            closeItem.backgroundColor = COLOR_33;
        }
    };
    
    ZPresentItem *cancelItem = [ZPresentItem creatPresentViewItemWithText:MultilingualTranslation(@"取消") textColor:COLOR_99 font:FONTR(17) itemHeight:DWScale(52) backgroundColor:COLORWHITE];
    self.tkThemeChangeBlock = ^(id  _Nullable itself, NSUInteger themeIndex) {
        if (themeIndex == 0) {
            cancelItem.textColor = COLOR_B3B3B3;
            cancelItem.backgroundColor = COLORWHITE;
        }else {
            cancelItem.textColor = COLOR_99;
            cancelItem.backgroundColor = COLOR_33;
        }
    };
    
    ZPresentView *viewAlert = [[ZPresentView alloc] initWithFrame:CGRectMake(0, 0, DScreenWidth, DScreenHeight) titleItem:nil selectItems:@[changeItem, closeItem] cancleItem:cancelItem doneClick:^(NSInteger index) {
        if (index == 0) {
            //修改安全码
            [weakSelf changeDeviceSafeCode];
        }else if (index == 1) {
            //关闭安全码
            [weakSelf closeDeviceSafeCode];
        }
    } cancleClick:^{
    }];
    [self.view addSubview:viewAlert];
    [viewAlert showPresentView];
}

//修改安全码
- (void)changeDeviceSafeCode {
    ZSafeCodeChangeViewController *vc = [ZSafeCodeChangeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

//关闭安全码
- (void)closeDeviceSafeCode {
    ZSafeCodeCloseViewController *vc = [ZSafeCodeCloseViewController new];
    vc.operatorType = SafeCodeOperatorTypeClose;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 通知监听处理
- (void)reloadGesturePassword {
    [self.baseTableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
