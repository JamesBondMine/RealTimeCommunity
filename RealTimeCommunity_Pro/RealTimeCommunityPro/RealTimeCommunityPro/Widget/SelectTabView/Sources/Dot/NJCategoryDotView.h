//
//  NJCategoryDotView.h
// 
//
//  Created by jiaxin on 2018/8/20.
//  Copyright © 2018年 jiaxin. All rights reserved.
// 

#import "LJCategoryTitleView.h"
#import "NJCategoryDotCell.h"
#import "NJCategoryDotCellModel.h"

@interface NJCategoryDotView : LJCategoryTitleView

//相对于titleLabel的位置，默认：JXCategoryDotRelativePosition_TopRight
@property (nonatomic, assign) JXCategoryDotRelativePosition relativePosition;
//@[@(布尔值)]数组，控制红点是否显示
@property (nonatomic, strong) NSArray <NSNumber *> *dotStates;
//红点的尺寸。默认：CGSizeMake(10, 10)
@property (nonatomic, assign) CGSize dotSize;
//红点的圆角值。默认：JXCategoryViewAutomaticDimension（self.dotSize.height/2）
@property (nonatomic, assign) CGFloat dotCornerRadius;
//红点的颜色。默认：[UIColor redColor]
@property (nonatomic, strong) UIColor *dotColor;
/**
 红点  x,y方向的偏移 （+值：水平方向向右，竖直方向向下）
 */
@property (nonatomic, assign) CGPoint dotOffset;

@end
