//
//  NJCategoryBaseCell.h
//  UI系列测试
//
//  Created by jiaxin on 2018/3/15.
//  Copyright © 2018年 jiaxin. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "NJCategoryBaseCellModel.h"
#import "NJCategoryViewAnimator.h"
#import "JXCategoryViewDefines.h"

@interface NJCategoryBaseCell : UICollectionViewCell

@property (nonatomic, strong, readonly) NJCategoryBaseCellModel *cellModel;
@property (nonatomic, strong, readonly) NJCategoryViewAnimator *animator;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData:(NJCategoryBaseCellModel *)cellModel NS_REQUIRES_SUPER;

- (BOOL)checkCanStartSelectedAnimation:(NJCategoryBaseCellModel *)cellModel;

- (void)addSelectedAnimationBlock:(JXCategoryCellSelectedAnimationBlock)block;

- (void)startSelectedAnimationIfNeeded:(NJCategoryBaseCellModel *)cellModel;

@end
