//
//  MenuContentViewController.h
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 定义所有点击事件的枚举
typedef NS_ENUM(NSInteger, MenuActionType) {
    MenuActionTypeQRCode,           // 二维码
    MenuActionTypeCheckIn,          // 签到
    MenuActionTypeTeamManagement,   // 团队管理
    MenuActionTypeShareInvite,      // 分享邀请
    MenuActionTypeMyCollection,     // 我的收藏
    MenuActionTypeBlacklist,        // 黑名单
    MenuActionTypeTranslate,        // 翻译管理
    MenuActionTypeLanguage,         // 语言
    MenuActionTypePrivacySetting,   // 隐私设置
    MenuActionTypeSafeSetting,      // 安全设置
    MenuActionTypeComplain,         // 投诉与支持
    MenuActionTypeNetworkDetection, // 网络检测
    MenuActionTypeAboutUs,          // 关于我们
    MenuActionTypeSystemSetting,    // 系统设置
    MenuActionTypeUserEdit,    // 编辑用户
};

@class MenuContentViewController;

@protocol MenuContentViewControllerDelegate <NSObject>

- (void)menuContentViewController:(MenuContentViewController *)controller didSelectAction:(MenuActionType)actionType;

@end

@interface MenuContentViewController : UIViewController

@property (nonatomic, weak) id<MenuContentViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

