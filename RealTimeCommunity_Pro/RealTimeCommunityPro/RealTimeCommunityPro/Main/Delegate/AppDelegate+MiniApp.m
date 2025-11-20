//
//  AppDelegate+MiniApp.m
//  CIMKit
//
//  Created by cusPro on 2023/7/19.
//

#import "AppDelegate+MiniApp.h"
#import "ZToolManager.h"
#import "SpecMiniAppFloatListView.h"

@implementation AppDelegate (MiniApp)
#pragma mark - 检查是否要显示小程序浮窗
- (void)checkMiniAppFloatShow {
    
    //通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMiniAppFloat) name:@"MyMiniAppFloatRemove" object:nil];
    
    if (UserManager.isLogined) {
        //获取小程序浮窗列表
        NSArray *miniAppFloatList = [IMSDKManager imSdkGetMyFloatMiniAppList];
        if (miniAppFloatList.count > 0 && !self.viewFloatMiniApp) {
            //等待tabbar的创建，没有放在会话列表界面创建浮窗(防止以后修改tabbar对此处造成影响)
            WeakSelf
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showMiniAppFloatView];
            });
            
        }
    } else {
        //清空全部
        [IMSDKManager imSdkDeleteAllFloatMiniApp];
        [self removeMiniAppFloat];
    };
    
    
}
- (void)showMiniAppFloatView {
    self.viewFloatMiniApp = [[SpecMiniAppFloatView alloc] initWithFrame:CGRectMake(0, DWScale(100), DWScale(50), DWScale(50))];
    self.viewFloatMiniApp.tkThemebackgroundColors = @[COLOR_F5F6F9, COLOR_33];;
    self.viewFloatMiniApp.freeRect = CGRectMake(0, DNavStatusBarH, DScreenWidth, DScreenHeight - DNavStatusBarH - DHomeBarH);
    self.viewFloatMiniApp.delegate = self;
    self.viewFloatMiniApp.imageView.image = ImgNamed(@"remini_mini_app_float");
    self.viewFloatMiniApp.isKeepBounds = YES;
    [self.viewFloatMiniApp round:DWScale(10) RectCorners:UIRectCornerTopRight | UIRectCornerBottomRight];
    [CurrentWindow addSubview:self.viewFloatMiniApp];
}
#pragma mark - SpecMiniAppFloatViewDelegate
/// 开始拖动
- (void)beganDragMiniAppFloatView:(SpecMiniAppFloatView *)floatView {
    [floatView round:DWScale(10) RectCorners:UIRectCornerAllCorners];
}
/// 拖动中...
- (void)duringDragMiniAppFloatView:(SpecMiniAppFloatView *)floatView {
}
/// 结束拖动
- (void)endDragMiniAppFloatView:(SpecMiniAppFloatView *)floatView {
    //左右侧贴边
    switch (floatView.keepBoundsType) {
        case ZFloatKeepBoundsTypeLeft:
        {
            [floatView round:DWScale(10) RectCorners:UIRectCornerTopRight | UIRectCornerBottomRight];
        }
            break;
        case ZFloatKeepBoundsTypeRight:
        {
            [floatView round:DWScale(10) RectCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
        }
            break;
        case ZFloatKeepBoundsTypeTop:
        {
            [floatView round:DWScale(10) RectCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        }
            break;
        case ZFloatKeepBoundsTypeBottom:
        {
            [floatView round:DWScale(10) RectCorners:UIRectCornerTopLeft | UIRectCornerTopRight];
        }
            break;
            
        default:
        {
            [floatView round:DWScale(10) RectCorners:UIRectCornerAllCorners];
        }
            break;
    }
}
/// 点击事件
- (void)clickMiniAppFloatView:(SpecMiniAppFloatView *)floatView {
    NSArray *floatMiniAppList = [IMSDKManager imSdkGetMyFloatMiniAppList];
    if (floatMiniAppList.count > 0) {
        SpecMiniAppFloatListView *viewFloatList = [SpecMiniAppFloatListView new];
        [viewFloatList miniAppFloatListShow];
    }else {
        [self removeMiniAppFloat];
    }
}

//移除全局浮窗
- (void)removeMiniAppFloat {
    
    //清空浮窗体验的优化
    if (self.viewFloatMiniApp) {
        self.viewFloatMiniApp.hidden = YES;
    }
    
    //兼容因为上面0.3的延迟导致移除浮窗失败
    WeakSelf
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        if (weakSelf.viewFloatMiniApp) {
            
            weakSelf.viewFloatMiniApp.delegate = nil;
            //移除浮窗里所有的子视图
            [weakSelf.viewFloatMiniApp.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //移除浮窗
            [weakSelf.viewFloatMiniApp removeFromSuperview];
            weakSelf.viewFloatMiniApp = nil;
            
        }
    });
    
}

@end
