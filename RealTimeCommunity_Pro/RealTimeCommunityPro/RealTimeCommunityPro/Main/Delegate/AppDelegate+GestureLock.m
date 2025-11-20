//
//  AppDelegate+GestureLock.m
//  CIMKit
//
//  Created by cusPro on 2023/4/24.
//

#import "AppDelegate+GestureLock.h"
#import "ZToolManager.h"

@implementation AppDelegate (GestureLock)

#pragma mark - 检查用户的手势锁配置情况
- (void)checkUserGestureLock {
    
    if (!UserManager.isLogined) return;
    if ([CurrentVC isKindOfClass:[ZGestureLockCheckVC class]]) return;
    
    WeakSelf
    NSString *userKey = [NSString stringWithFormat:@"%@-GesturePassword", UserManager.userInfo.userUID];
    NSString *gesturePasswordJson = [[MMKV defaultMMKV] getStringForKey:userKey];
    if (![NSString isNil:gesturePasswordJson]) {
        //设置了手势验证
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            ZGestureLockCheckVC *vc = [ZGestureLockCheckVC new];
//            vc.delegate = weakSelf;
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            vc.checkType = GestureLockCheckTypeNormal;
//            [CurrentVC presentViewController:vc animated:YES completion:nil];
//        });
        
        ZGestureLockCheckVC *vc = [ZGestureLockCheckVC new];
        vc.delegate = weakSelf;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.checkType = GestureLockCheckTypeNormal;
        [CurrentVC presentViewController:vc animated:YES completion:nil];
        
    }
}

#pragma mark - ZGestureLockCheckVCDelegate
- (void)gestureLockCheckResultType:(GestureLockCheckResultType)checkResultType checkType:(GestureLockCheckType)checkType {
    if (checkResultType == GestureLockCheckResultTypeRight) {
        if (checkType == GestureLockCheckTypeClose) {
            //关闭手势密码
        }else if (checkType == GestureLockCheckTypeChange) {
            //修改手势密码
        }else {
            //普通手势密码验证
        }
    }
}

@end
