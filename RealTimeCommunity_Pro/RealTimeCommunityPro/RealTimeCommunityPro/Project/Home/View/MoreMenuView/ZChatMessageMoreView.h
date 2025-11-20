//
//  ZChatMessageMoreView.h
//  CIMKit
//
//  Created by cusPro on 2022/9/28.
//

// 消息长按 更多功能 View

#import <UIKit/UIKit.h>
#import "CMessageMoreItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZChatMessageMoreView : UIView

@property (nonatomic, copy)void(^menuClick)(MessageMenuItemActionType actionType);

- (instancetype)initWithMenu:(NSArray *)menuArr targetRect:(CGRect)targetRect isFromMy:(BOOL)isFromMy isBottom:(BOOL)isBottom msgContentSize:(CGSize)msgContentSize;

@end

NS_ASSUME_NONNULL_END
