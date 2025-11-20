//
//  UIFont+Addition.h
//  CIMKit
//
//  Created by cusPro on 2024/02/28.
//

#import <UIKit/UIKit.h>

#define FONTR(a) [UIFont fontWithName:@"PingFangSC-Regular" size:([ZDeviceTool isSmallScreen] ? a - 1 : a)]

#define FONTSB(a) [UIFont fontWithName:@"PingFangSC-Semibold" size:([ZDeviceTool isSmallScreen] ? a - 1 : a)]

#define FONTM(a) [UIFont fontWithName:@"PingFangSC-Medium" size:([ZDeviceTool isSmallScreen] ? a - 1 : a)]

#define FONTB(a) [UIFont boldSystemFontOfSize:([ZDeviceTool isSmallScreen] ? a - 1 : a)]

#define FONTN(a) [UIFont systemFontOfSize:([ZDeviceTool isSmallScreen] ? a - 1 : a)]


NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Addition)

@end

NS_ASSUME_NONNULL_END
