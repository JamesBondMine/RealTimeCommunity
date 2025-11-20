//
//  HomeMssageTimeDeleteView.h
//  CIMKit
//
//  Created by cusPro on 2023/4/18.
//

// 消息定时删除View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HomeMssageTimeDeleteViewDelegate <NSObject>
- (void)messageTimeDeleteType:(NSInteger)deleteType;
@end

@interface HomeMssageTimeDeleteView : UIView
//界面是否显示关闭操作
- (instancetype)initWithShowCloseView:(BOOL)showClose;
- (void)viewShow;
- (void)viewDismiss;

@property (nonatomic, weak) id <HomeMssageTimeDeleteViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
