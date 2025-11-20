//
//  NFFriendGroupAddView.h
//  CIMKit
//
//  Created by cusPro on 2023/7/4.
//

// 添加 好友分组 View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NFFriendGroupAddViewDelegate <NSObject>
- (void)friendGroupAdd;
@end

@interface NFFriendGroupAddView : UIView

@property (nonatomic, weak) id <NFFriendGroupAddViewDelegate> delegate;

- (void)addViewShow;
- (void)addViewDismiss;

@end

NS_ASSUME_NONNULL_END
