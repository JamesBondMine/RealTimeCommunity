//
//  NJCategoryIndicatorBallView.h
// 
//
//  Created by jiaxin on 2018/8/21.
//  Copyright © 2018年 jiaxin. All rights reserved.
// 

#import "NJSelectCategoryIndicatorComponentView.h"

/// QQ 小红点样式的指示器
@interface NJCategoryIndicatorBallView : NJSelectCategoryIndicatorComponentView

// 球沿的 X 轴方向上的偏移量。默认值为 20
@property (nonatomic, assign) CGFloat ballScrollOffsetX;

@end
