//
//  SideMenuViewController.m
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import "SideMenuViewController.h"
#import "MenuContentViewController.h"
// #import "ZMineVC.h" // 已移除，改用 MenuContentViewController

// 导入所有需要跳转的 ViewController
#import "NMUserInfoViewController.h"//个人资料
#import "NMBlackListViewController.h"//黑名单
#import "NMSafeSettingViewController.h"//安全设置
#import "NMSystemSettingViewController.h"//系统设置
#import "NMMyQRCodeViewController.h"//我的二维码
#import "ZNMMyCollectionViewController.h"//我的收藏
#import "ZComplainVC.h"//投诉与支持
#import "NMLanguageSetViewController.h"//多语言
#import "NMAboutUsViewController.h"//关于我们
#import "NMShareInviteViewController.h"//分享邀请
#import "ZSignInViewController.h" //签到页面
#import "NMTranslateSetDefaultViewController.h" //翻译管理
#import "NMPrivacySettingViewController.h"//隐私设置
#import "TeamTeamListVC.h"//团队管理
#import "ZQRCodeModel.h"
#import "ZNetworkDetectionVC.h"//网络检测页面


@interface SideMenuViewController ()

@property (nonatomic, strong) UIButton *closeButton;
//@property (nonatomic, strong) ZMineVC *contentViewController;

@property (nonatomic, strong) MenuContentViewController *contentViewController;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.95 blue:0.88 alpha:1.0];
    
    [self setupBackgroundImage];
    [self setupContentViewController];
    [self setupCloseButton];
}

- (void)setupBackgroundImage {
    CGFloat imageHeight = 250;
    
    // 添加背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, imageHeight)];
    backgroundImageView.image = [UIImage imageNamed:@"user_head_bg"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [self.view addSubview:backgroundImageView];
    
    // 添加毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = backgroundImageView.bounds;
    blurView.alpha = 0.8;
    // [backgroundImageView addSubview:blurView];
    
    // 添加半透明遮罩层
    UIView *overlayView = [[UIView alloc] initWithFrame:backgroundImageView.bounds];
    overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [backgroundImageView addSubview:overlayView];
}

- (void)setupContentViewController {
    self.contentViewController = [[MenuContentViewController alloc] init];
    self.contentViewController.delegate = self;
    
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
}

- (void)setupCloseButton {
    CGFloat closeButtonSize = 40;
    CGFloat topMargin = 50;
    CGFloat rightMargin = 20;
    CGFloat screenWidth = self.view.bounds.size.width;
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - closeButtonSize - rightMargin, topMargin, closeButtonSize, closeButtonSize)];
    self.closeButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.5 alpha:1.0];
    self.closeButton.layer.cornerRadius = closeButtonSize / 2;
    self.closeButton.layer.masksToBounds = YES;
    
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [self.closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
}

- (void)closeButtonTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerDidRequestClose:)]) {
        [self.delegate sideMenuViewControllerDidRequestClose:self];
    }
}

#pragma mark - MenuContentViewControllerDelegate

- (void)menuContentViewController:(MenuContentViewController *)controller didSelectAction:(MenuActionType)actionType {
    NSLog(@"收到菜单点击事件，类型：%ld", (long)actionType);
    
    // 获取 navigationController
    UINavigationController *navigationController = [self getNavigationController];
    
    if (!navigationController) {
        NSLog(@"⚠️ 无法获取 navigationController，跳转失败");
        return;
    }
    
    // 根据不同的枚举类型进行相应的跳转
    switch (actionType) {
        case MenuActionTypeQRCode: {
            // 二维码
            NMMyQRCodeViewController *qrVC = [[NMMyQRCodeViewController alloc] init];
            [navigationController pushViewController:qrVC animated:YES];
            break;
        }
        case MenuActionTypeCheckIn: {
            // 签到
            ZSignInViewController *signInVC = [[ZSignInViewController alloc] init];
            [navigationController pushViewController:signInVC animated:YES];
            break;
        }
        case MenuActionTypeTeamManagement: {
            // 团队管理
            TeamTeamListVC *teamVC = [TeamTeamListVC new];
            [navigationController pushViewController:teamVC animated:YES];
            break;
        }
        case MenuActionTypeShareInvite: {
            // 分享邀请
            NMShareInviteViewController *shareInviteVC = [[NMShareInviteViewController alloc] init];
            [navigationController pushViewController:shareInviteVC animated:YES];
            break;
        }
        case MenuActionTypeMyCollection: {
            // 我的收藏
            ZNMMyCollectionViewController *myCollectionVC = [[ZNMMyCollectionViewController alloc] init];
            myCollectionVC.isFromChat = NO;
            [navigationController pushViewController:myCollectionVC animated:YES];
            break;
        }
        case MenuActionTypeBlacklist: {
            // 黑名单
            NMBlackListViewController *blackListVC = [[NMBlackListViewController alloc] init];
            [navigationController pushViewController:blackListVC animated:YES];
            break;
        }
        case MenuActionTypeTranslate: {
            // 翻译管理
            NMTranslateSetDefaultViewController *vc = [[NMTranslateSetDefaultViewController alloc] init];
            [navigationController pushViewController:vc animated:YES];
            break;
        }
        case MenuActionTypeLanguage: {
            // 多语言
            NMLanguageSetViewController *languageSetVC = [[NMLanguageSetViewController alloc] init];
            languageSetVC.changeType = LanguageChangeUITypeTabbar;
            [navigationController pushViewController:languageSetVC animated:YES];
            break;
        }
        case MenuActionTypePrivacySetting: {
            // 隐私设置
            NMPrivacySettingViewController *privacySettingVC = [[NMPrivacySettingViewController alloc] init];
            [navigationController pushViewController:privacySettingVC animated:YES];
            break;
        }
        case MenuActionTypeSafeSetting: {
            // 安全设置
            NMSafeSettingViewController *safeSettingVC = [[NMSafeSettingViewController alloc] init];
            [navigationController pushViewController:safeSettingVC animated:YES];
            break;
        }
        case MenuActionTypeComplain: {
            // 投诉与支持
            ZComplainVC *vc = [ZComplainVC new];
            [navigationController pushViewController:vc animated:YES];
            break;
        }
        case MenuActionTypeNetworkDetection: {
            // 网络检测
            ZNetworkDetectionVC *vc = [ZNetworkDetectionVC new];
            ZSsoInfoModel *ssoModel = [ZSsoInfoModel getSSOInfo];
            vc.currentSsoNumber = ssoModel.liceseId;
            [navigationController pushViewController:vc animated:YES];
            break;
        }
        case MenuActionTypeAboutUs: {
            // 关于我们
            NMAboutUsViewController *aboutUsVC = [[NMAboutUsViewController alloc] init];
            [navigationController pushViewController:aboutUsVC animated:YES];
            break;
        }
        case MenuActionTypeSystemSetting: {
            // 系统设置
            NMSystemSettingViewController *sysSettingVC = [[NMSystemSettingViewController alloc] init];
            [navigationController pushViewController:sysSettingVC animated:YES];
            break;
        }
        case MenuActionTypeUserEdit: {
            // 编辑个人资料
            NMUserInfoViewController *userInfoVC = [[NMUserInfoViewController alloc] init];
            [navigationController pushViewController:userInfoVC animated:YES];
            break;
        }
        default:
            NSLog(@"⚠️ 未知的菜单类型：%ld", (long)actionType);
            break;
    }
    
    // 跳转后关闭侧边栏
    if ([self.delegate respondsToSelector:@selector(sideMenuViewControllerDidRequestClose:)]) {
        [self.delegate sideMenuViewControllerDidRequestClose:self];
    }
}

#pragma mark - 辅助方法

// 获取 navigationController
- (UINavigationController *)getNavigationController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootVC = keyWindow.rootViewController;
    
    // 查找第一个可用的 navigationController
    for (UIViewController *child in rootVC.childViewControllers) {
        if ([child isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarController = (UITabBarController *)child;
            if ([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
                return (UINavigationController *)tabBarController.selectedViewController;
            }
        }
    }
    
    return nil;
}

@end

