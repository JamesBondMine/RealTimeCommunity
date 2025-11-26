//
//  NSMiniAppWebVC.h
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

typedef NS_ENUM(NSUInteger, NSMiniAppWebVCType) {
    NSMiniAppWebVCTypeDefault = 0,      //通用占位
    NSMiniAppWebVCTypeMiniApp = 1,      //小程序
};

#import "BBBaseWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMiniAppWebVC : BBBaseWebViewController
@property (nonatomic, assign) NSMiniAppWebVCType webType;//类型
//小程序专用
@property (nonatomic, strong) LingFloatMiniAppModel * floatMiniAppModel;
@end

NS_ASSUME_NONNULL_END
