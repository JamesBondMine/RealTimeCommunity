//
//  ZAlertInputTipView.h
//  CIMKit
//
//  Created by cusPro on 2023/5/4.
//

#import <UIKit/UIKit.h>
#import "MainPlaceHolderTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZAlertInputTipView : UIView

@property (nonatomic, strong) UILabel *lblTip;//提示内容
@property (nonatomic, strong) MainPlaceHolderTextView *textView;
@property (nonatomic, strong) UIButton *btnCancel;  //取消按钮
@property (nonatomic, strong) UIButton *btnSure;    //确定按钮
@property (nonatomic, copy) void(^sureBtnBlock)(NSString *inputStr);   //确定按钮Block
@property (nonatomic, copy) void(^cancelBtnBlock)(void);   //取消按钮Block

- (void)alertTipViewShow;
- (void)alertTipViewDismiss;

@end

NS_ASSUME_NONNULL_END
