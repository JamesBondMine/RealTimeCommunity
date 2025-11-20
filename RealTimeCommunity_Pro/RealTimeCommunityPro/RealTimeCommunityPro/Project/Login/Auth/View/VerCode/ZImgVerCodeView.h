//
//  ZImgVerCodeView.h
//  CIMKit
//
//  Created by cusPro on 2022/9/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZImgVerCodeView : UIView

@property (nonatomic, copy)NSString *imgCodeStr;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, assign) NSInteger verCodeType;

@property (nonatomic, copy) void(^sureBtnBlock)(NSString *imgCode);

@property (nonatomic, copy) void(^cancelBtnBlock)(void);

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
