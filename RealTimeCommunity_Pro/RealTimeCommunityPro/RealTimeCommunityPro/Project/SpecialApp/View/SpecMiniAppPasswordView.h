//
//  SpecMiniAppPasswordView.h
//  CIMKit
//
//  Created by cusPro on 2023/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpecMiniAppPasswordView : UIView
@property (nonatomic, strong) LingIMMiniAppModel *miniAppModel;

@property (nonatomic, copy) void(^sureBtnBlock)(void);   //确定按钮Block
@property (nonatomic, copy) void(^cancelBtnBlock)(void);   //取消按钮Block

- (void)miniAppPasswordShow;
- (void)miniAppPasswordDismiss;

@end

NS_ASSUME_NONNULL_END
