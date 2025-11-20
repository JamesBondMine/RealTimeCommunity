//
//  HomeSessionTopView.h
//  CIMKit
//
//  Created by cusPro on 2022/9/23.
//

// 会话列表VC 顶部View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LingIMMiniAppModel;

//typedef void (^ZSessionTopAddBlock) (ZSessionMoreActionType actionType); // 已删除，改用悬浮按钮
typedef void (^ZSessionTopSearchBlock) (void);
typedef void (^ZSessionTopAvatarClickBlock) (void); // New block for avatar click
typedef void (^ZSessionTopMiniAppJumpBlock) (LingIMMiniAppModel *miniAppModel); // 小程序跳转block

@interface HomeSessionTopView : UIView
@property (nonatomic, copy) ZSessionTopSearchBlock searchBlock;
//@property (nonatomic, copy) ZSessionTopAddBlock addBlock; // 已删除，改用悬浮按钮
@property (nonatomic, copy) ZSessionTopAvatarClickBlock avatarClickBlock; // New property
@property (nonatomic, copy) ZSessionTopMiniAppJumpBlock miniAppJumpBlock; // 小程序跳转block
@property (nonatomic, assign) BOOL showLoading;

- (void)viewAppearUpdateUI;
@end

NS_ASSUME_NONNULL_END
