//
//  ZGestureLockCheckVC.m
//  CIMKit
//
//  Created by cusPro on 2023/4/24.
//

#import "ZGestureLockCheckVC.h"
#import "ZGestureLockView.h"
#import "MGGestureLockCheckAccountPasswordView.h"
#import "ZToolManager.h"

@interface ZGestureLockCheckVC () <ZGestureLockViewDelegate, ZGestureLockCheckAccountPasswordDelegate>
@property (nonatomic, strong) UILabel *lblTitle;//标题
@property (nonatomic, strong) UIImageView *ivLogo;//logo
@property (nonatomic, strong) ZGestureLockView *viewGesture;//手势图案
@property (nonatomic, strong) UIButton *btnCancel;//取消绘制
@property (nonatomic, copy) NSString *gesturePassword;//手势密码
@property (nonatomic, assign) NSInteger checkNumber;//密码验证次数
@end

@implementation ZGestureLockCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
    NSString *jsonStr = [[MMKV defaultMMKV] getStringForKey:userKey];
    
    if (![NSString isNil:jsonStr]) {
        
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            _gesturePassword = [dict objectForKeySafe:@"password"];
            _checkNumber = [[dict objectForKeySafe:@"checkNumber"] integerValue];
            if (_checkNumber >= 5) {
                MGGestureLockCheckAccountPasswordView *viewCheckAccount = [MGGestureLockCheckAccountPasswordView new];
                viewCheckAccount.delegate = self;
                [self.view addSubview:viewCheckAccount];
            }
        }
        
    }
    
}

#pragma mark - 界面布局
- (void)setupUI {
    self.navView.hidden = YES;
    
    UIImageView *ivBg = [[UIImageView alloc] init];
    ivBg.image = [UIImage gradientColorImageFromColors:@[HEXCOLOR(@"2A54CA"), HEXCOLOR(@"719FDF")] gradientType:GradientColorTypeTopToBottom imageSize:CGSizeMake(DScreenWidth, DScreenHeight)];
    [self.view addSubview:ivBg];
    [ivBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _lblTitle = [UILabel new];
    _lblTitle.text = MultilingualTranslation(@"请绘制解锁图案");
    _lblTitle.tkThemetextColors = @[COLORWHITE, COLORWHITE_DARK];
    _lblTitle.font = FONTR(18);
    [self.view addSubview:_lblTitle];
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(DWScale(55));
    }];
    
    _ivLogo = [[UIImageView alloc] initWithImage:ImgNamed(@"relogimg_img_login_logo_reb")];
    [self.view addSubview:_ivLogo];
    [_ivLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_lblTitle.mas_bottom).offset(DWScale(33));
        make.size.mas_equalTo(CGSizeMake(DWScale(82), DWScale(82)));
    }];
    
    _viewGesture = [ZGestureLockView new];
    _viewGesture.delegate = self;
    [self.view addSubview:_viewGesture];
    [_viewGesture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(_ivLogo.mas_bottom).offset(DWScale(80));
        make.height.mas_equalTo(DScreenWidth);
    }];
    
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel setTitle:MultilingualTranslation(@"取消图案绘制") forState:UIControlStateNormal];
    [_btnCancel setTkThemeTitleColor:@[COLORWHITE, COLORWHITE_DARK] forState:UIControlStateNormal];
    _btnCancel.titleLabel.font = FONTR(14);
    [_btnCancel addTarget:self action:@selector(btnCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCancel];
    [_btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-DWScale(14) - DHomeBarH);
    }];
    
    _btnCancel.hidden = _checkType == GestureLockCheckTypeNormal;
}
#pragma mark - 交互事件
- (void)btnCancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - ZGestureLockViewDelegate
- (void)gestureLockViewFinishWith:(NSMutableString *)gesturePassword {
    
    if (_checkNumber >= 5) return;
    
    if ([gesturePassword isEqualToString:_gesturePassword]) {
        //手势密码验证成功
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:_gesturePassword forKey:@"password"];
        [dict setValue:@(0) forKey:@"checkNumber"];
        [dict setValue:@(0) forKey:@"checkAccountPassword"];
        NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
        [[MMKV defaultMMKV] setString:[dict mj_JSONString] forKey:userKey];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (_delegate && [_delegate respondsToSelector:@selector(gestureLockCheckResultType:checkType:)]) {
            [_delegate gestureLockCheckResultType:GestureLockCheckResultTypeRight checkType:_checkType];
        }
    }else {
        
        //手势密码验证失败
        _checkNumber++;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:_gesturePassword forKey:@"password"];
        [dict setValue:@(_checkNumber) forKey:@"checkNumber"];
        [dict setValue:@(0) forKey:@"checkAccountPassword"];
        NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
        [[MMKV defaultMMKV] setString:[dict mj_JSONString] forKey:userKey];
        
        
        if (_checkNumber >= 5) {
            [HUD showMessage:MultilingualTranslation(@"账户被锁定\n请输入账户密码")];
            
            if (_delegate && [_delegate respondsToSelector:@selector(gestureLockCheckResultType:checkType:)]) {
                [_delegate gestureLockCheckResultType:GestureLockCheckResultTypeLock checkType:_checkType];
            }
            
            MGGestureLockCheckAccountPasswordView *viewCheckAccount = [MGGestureLockCheckAccountPasswordView new];
            viewCheckAccount.delegate = self;
            [self.view addSubview:viewCheckAccount];
            
        }else {
            [HUD showMessage:MultilingualTranslation(@"密码错误")];
            if (_delegate && [_delegate respondsToSelector:@selector(gestureLockCheckResultType:checkType:)]) {
                [_delegate gestureLockCheckResultType:GestureLockCheckResultTypeError checkType:_checkType];
            }
        }
        
        
    }

}

#pragma mark - ZGestureLockCheckAccountPasswordDelegate
- (void)gestureLockCheckAccountPasswordSuccess {
    //手势密码验证成功
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_gesturePassword forKey:@"password"];
    [dict setValue:@(0) forKey:@"checkNumber"];
    [dict setValue:@(0) forKey:@"checkAccountPassword"];
    NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
    [[MMKV defaultMMKV] setString:[dict mj_JSONString] forKey:userKey];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(gestureLockCheckResultType:checkType:)]) {
        [_delegate gestureLockCheckResultType:GestureLockCheckResultTypeRight checkType:_checkType];
    }
}
- (void)gestureLockCheckAccountPasswordFail {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:_gesturePassword forKey:@"password"];
    [dict setValue:@(0) forKey:@"checkNumber"];
    [dict setValue:@(0) forKey:@"checkAccountPassword"];
    NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
    [[MMKV defaultMMKV] setString:[dict mj_JSONString] forKey:userKey];
    
    
    //五次手势密码错误，5次账号密码错误，进行重新登录操作
    [ZTOOL setupLoginUI];
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
