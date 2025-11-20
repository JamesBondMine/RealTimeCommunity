//
//  FloatingActionButton.h
//  CT Model
//
//  Created by LJ on 2025/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FloatingActionButton;

@protocol FloatingActionButtonDelegate <NSObject>

- (void)floatingActionButton:(FloatingActionButton *)button didSelectActionType:(ZSessionMoreActionType)actionType;

@end

@interface FloatingActionButton : UIView

@property (nonatomic, weak) id<FloatingActionButtonDelegate> delegate;

/**
 * 便捷初始化方法
 * @param parentView 父视图
 * @param position 位置：0-右下角（默认），1-左下角，2-右上角，3-左上角
 * @return 悬浮按钮实例
 */
+ (instancetype)addToView:(UIView *)parentView atPosition:(NSInteger)position;

/**
 * 便捷初始化方法（默认在右下角）
 * @param parentView 父视图
 * @return 悬浮按钮实例
 */
+ (instancetype)addToView:(UIView *)parentView;

@end

NS_ASSUME_NONNULL_END

