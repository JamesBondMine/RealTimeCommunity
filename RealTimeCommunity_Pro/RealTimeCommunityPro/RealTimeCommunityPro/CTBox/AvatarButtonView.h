//
//  AvatarButtonView.h
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AvatarButtonView;

@protocol AvatarButtonViewDelegate <NSObject>

- (void)avatarButtonViewDidTap:(AvatarButtonView *)avatarView;

@end

@interface AvatarButtonView : UIView

@property (nonatomic, weak) id<AvatarButtonViewDelegate> delegate;

// 可自定义的属性
@property (nonatomic, strong) UIColor *avatarBackgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, copy) NSString *avatarText;

@end

NS_ASSUME_NONNULL_END

