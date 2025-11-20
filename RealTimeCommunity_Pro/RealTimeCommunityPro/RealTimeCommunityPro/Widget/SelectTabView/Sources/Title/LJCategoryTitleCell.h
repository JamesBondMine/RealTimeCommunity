//
//  LJCategoryTitleCell.h
//  UI系列测试
//
//  Created by jiaxin on 2018/3/15.
//  Copyright © 2018年 jiaxin. All rights reserved.
// 

#import "NJCategoryIndicatorCell.h"
#import "JXCategoryViewDefines.h"
@class LJCategoryTitleCellModel;

@interface LJCategoryTitleCell : NJCategoryIndicatorCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *maskTitleLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterX;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterY;
@property (nonatomic, strong) NSLayoutConstraint *maskTitleLabelCenterX;

- (JXCategoryCellSelectedAnimationBlock)preferredTitleZoomAnimationBlock:(LJCategoryTitleCellModel *)cellModel baseScale:(CGFloat)baseScale;

- (JXCategoryCellSelectedAnimationBlock)preferredTitleStrokeWidthAnimationBlock:(LJCategoryTitleCellModel *)cellModel attributedString:(NSMutableAttributedString *)attributedString;

- (JXCategoryCellSelectedAnimationBlock)preferredTitleColorAnimationBlock:(LJCategoryTitleCellModel *)cellModel;

@end
