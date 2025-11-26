//
//  ZWeakPwdCheckTool.m
//  RealTimeCommunityPro
//
//  Created by blackcat on 2025/10/13.
//

#import "ZWeakPwdCheckTool.h"
#import "ZMessageAlertView.h"
#import "ZPwdWeakCheckModel.h"
#import "ZInputOldPasswordViewController.h"
#import "ZInputNewPasswordViewController.h"
#import "LXChatEncrypt.h"


static NSString *const ZPwdWeakCheckModelTypePasswordEqAccount = @"PASSWORD_EQ_ACCOUNT";
static NSString *const ZPwdWeakCheckModelTypeWeekPassword = @"WEAK_PASSWORD";

@interface ZWeakPwdCheckTool ()
@property (nonatomic, strong) ZPwdWeakCheckModel *pwdWeakCheckModel;
@end

@implementation ZWeakPwdCheckTool

// 单例实现
+ (instancetype)sharedInstance {
    static ZWeakPwdCheckTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZWeakPwdCheckTool alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _userPwd = nil;
    }
    return self;
}

- (void)getEncryptKeyWithCompletion: (void(^)(NSString *encryptKey))completion {
    [IMSDKManager authGetEncryptKeySuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            //调用注册接口，传入加密密钥
            if([data isKindOfClass:[NSString class]]){
                NSString *encryptKey = (NSString *)data;
                if (completion) {
                    completion(encryptKey);
                }
            }
        }];
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            if (completion) {
                completion(nil);
            }
        }];
        
    }];
}

- (void)checkPwdStrengthWithCompletion: (void(^)(BOOL doNext))completion {
    [self getEncryptKeyWithCompletion:^(NSString *encryptKey) {
        if (![NSString isNil:encryptKey]) {
            [self alertCheckPwdStrengthWithEncryptKey:encryptKey completion:completion];
        } else {
            completion(false);
        }
    }];
}
  

- (void)alertCheckPwdStrengthWithEncryptKey: (NSString *)encryptKey completion: (void(^)(BOOL doNext))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectSafe:UserManager.userInfo.userUID forKey:@"userUid"];
    if (![NSString isNil:self.userPwd] && ![NSString isNil:encryptKey]) {
        // 在工具内部加密密码 - 先拼接encryptKey和密码，再加密
        NSString *passwordKey = [NSString stringWithFormat:@"%@%@", encryptKey, self.userPwd];
        NSString *encryptedPassword = [LXChatEncrypt method4:passwordKey];
        [params setObjectSafe:encryptedPassword forKey:@"password"];
        [params setObjectSafe:encryptKey forKey:@"encryptKey"];
        self.userPwd = nil;
    }
    WeakSelf
    [IMSDKManager authCheckPasswordStrengthWith:params onSuccess:^(id  _Nullable data, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            weakSelf.pwdWeakCheckModel = [ZPwdWeakCheckModel mj_objectWithKeyValues:data];
            BOOL forcedPasswordReset = weakSelf.pwdWeakCheckModel.roleConfigMap.forcedPasswordReset;
            BOOL showAlert = NO;
            if (weakSelf.pwdWeakCheckModel.isWeakPassword) {
                if (params[@"password"] && !forcedPasswordReset) {
                    showAlert = YES;
                } else if (forcedPasswordReset) {
                    showAlert = YES;
                } else {
                    showAlert = NO;
                }
            } else {
                showAlert = NO;
            }
            if (completion) {
                completion(showAlert);
            }
        }];
        
    } onFailure:^(NSInteger code, NSString * _Nullable msg, NSString * _Nullable traceId) {
        [ZTOOL doInMain:^{
            if (completion) {
                completion(NO);
            }
        }];
        
    }];
}

- (void)alertChangePwdTipView  {
    NSString *content = MultilingualTranslation(@"弱密码提示");

    if ([self.pwdWeakCheckModel.type isEqualToString:ZPwdWeakCheckModelTypePasswordEqAccount]) {
        content = MultilingualTranslation(@"密码与账户名相同提示");
    } else if ([self.pwdWeakCheckModel.type isEqualToString:ZPwdWeakCheckModelTypeWeekPassword]) {
        content = MultilingualTranslation(@"弱密码提示");
    } else {
        return;
    }
    BOOL isForcedReset = self.pwdWeakCheckModel.roleConfigMap.forcedPasswordReset;

    ZMessageAlertType alertType = isForcedReset ? ZMessageAlertTypeSingleBtn : ZMessageAlertTypeTitle;

    ZMessageAlertView *msgAlertView = [[ZMessageAlertView alloc] initWithMsgAlertType:alertType supView:nil];
    msgAlertView.lblTitle.text = MultilingualTranslation(@"安全提醒");
    msgAlertView.lblContent.text = content;
    msgAlertView.lblContent.textAlignment = NSTextAlignmentLeft;
    [msgAlertView.btnSure setTitle:MultilingualTranslation(@"去修改") forState:UIControlStateNormal];
    [msgAlertView.btnSure setTkThemeTitleColor:@[COLORWHITE, COLORWHITE] forState:UIControlStateNormal];
    msgAlertView.btnSure.tkThemebackgroundColors = @[COLOR_4791FF, COLOR_4791FF];
    [msgAlertView.btnCancel setTitle:MultilingualTranslation(@"取消") forState:UIControlStateNormal];
    [msgAlertView.btnCancel setTkThemeTitleColor:@[COLOR_66, COLOR_66_DARK] forState:UIControlStateNormal];
    msgAlertView.btnCancel.tkThemebackgroundColors = @[COLOR_F6F6F6, COLOR_F6F6F6_DARK];
    [msgAlertView alertShow];
    msgAlertView.sureBtnBlock = ^(BOOL isCheckBox) {
      [self requestCheckUserHasSetPwd];
    };
}

- (void)requestCheckUserHasSetPwd {
    ZInputOldPasswordViewController *oldPasswordVC = [[ZInputOldPasswordViewController alloc] init];
    // 传递强制重置标记以控制返回按钮与手势
    BOOL isForcedReset = self.pwdWeakCheckModel.roleConfigMap.forcedPasswordReset;
    oldPasswordVC.isForcedReset = isForcedReset;
    [self.currentNavigationController pushViewController:oldPasswordVC animated:YES];
}
@end
