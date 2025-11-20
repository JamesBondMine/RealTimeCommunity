//
//  SpecMyMiniAppView.h
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LingIMMiniAppModel;

// 小程序跳转的block
typedef void(^MiniAppJumpBlock)(LingIMMiniAppModel *miniAppModel);

@interface SpecMyMiniAppView : UIView

// 小程序跳转block
@property (nonatomic, copy) MiniAppJumpBlock miniAppJumpBlock;

- (void)myMiniAppShow;
- (void)myMiniAppDismiss;

@end

NS_ASSUME_NONNULL_END
