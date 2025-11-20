//
//  AppDelegate.h
//  CIMKit
//
//  Created by Apple on 2022/8/9.
//

#import <UIKit/UIKit.h> 
#import "ZWindowFloatView.h"
#import "SpecMiniAppFloatView.h"
#import "ZMessageAlertView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ZWindowFloatViewDelegate, SpecMiniAppFloatViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ZWindowFloatView *viewFloatWindow;//音视频通话 浮窗
@property (nonatomic, strong) SpecMiniAppFloatView *viewFloatMiniApp;//小程序 浮窗
@property (nonatomic, strong) ZMessageAlertView *translateAlertView;//翻译失败弹窗

- (void)showLocalPush:(NSString *)title body:(NSString *)body userInfo:(NSDictionary *)userInfo withIdentifier:(NSString *)ident playSoud:(BOOL)sound soundName:(NSString *)soundName;


@end

