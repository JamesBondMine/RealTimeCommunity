//
//  NJCategoryIndicatorView.m
//  DQGuess
//
//  Created by jiaxin on 2018/7/25.
//  Copyright © 2018年 jingbo. All rights reserved.
// 

#import "NJCategoryIndicatorView.h"
#import "NJSelectCategoryIndicatorBackgroundView.h"
#import "NJCategoryFactory.h"

@interface NJCategoryIndicatorView()

@end

@implementation NJCategoryIndicatorView

- (void)initializeData {
    [super initializeData];

    _separatorLineShowEnabled = NO;
    _separatorLineColor = [UIColor lightGrayColor];
    _separatorLineSize = CGSizeMake(1/[UIScreen mainScreen].scale, 20);
    _cellBackgroundColorGradientEnabled = NO;
    _cellBackgroundUnselectedColor = [UIColor whiteColor];
    _cellBackgroundSelectedColor = [UIColor lightGrayColor];
}

- (void)initializeViews {
    [super initializeViews];
}

- (void)setIndicators:(NSArray<UIView<NJCategoryIndicatorProtocol> *> *)indicators {
    _indicators = indicators;

    self.collectionView.indicators = indicators;
}

- (void)refreshState {
    [super refreshState];

    CGRect selectedCellFrame = CGRectZero;
    NJCategoryIndicatorCellModel *selectedCellModel;
    for (int i = 0; i < self.dataSource.count; i++) {
        NJCategoryIndicatorCellModel *cellModel = (NJCategoryIndicatorCellModel *)self.dataSource[i];
        cellModel.sepratorLineShowEnabled = self.isSeparatorLineShowEnabled;
        cellModel.separatorLineColor = self.separatorLineColor;
        cellModel.separatorLineSize = self.separatorLineSize;
        cellModel.backgroundViewMaskFrame = CGRectZero;
        cellModel.cellBackgroundColorGradientEnabled = self.isCellBackgroundColorGradientEnabled;
        cellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        cellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        if (i == self.dataSource.count - 1) {
            cellModel.sepratorLineShowEnabled = NO;
        }
        if (i == self.selectedIndex) {
            selectedCellModel = cellModel;
            selectedCellFrame = [self getTargetCellFrame:i];
        }
    }

    for (UIView<NJCategoryIndicatorProtocol> *indicator in self.indicators) {
        if (self.dataSource.count <= 0) {
            indicator.hidden = YES;
        } else {
            indicator.hidden = NO;
            NJCategoryIndicatorParamsModel *indicatorParamsModel = [[NJCategoryIndicatorParamsModel alloc] init];
            indicatorParamsModel.selectedIndex = self.selectedIndex;
            indicatorParamsModel.selectedCellFrame = selectedCellFrame;
            [indicator jx_refreshState:indicatorParamsModel];

            if ([indicator isKindOfClass:[NJSelectCategoryIndicatorBackgroundView class]]) {
                CGRect maskFrame = indicator.frame;
                maskFrame.origin.x = maskFrame.origin.x - selectedCellFrame.origin.x;
                selectedCellModel.backgroundViewMaskFrame = maskFrame;
            }
        }
    }
}

- (void)refreshSelectedCellModel:(NJCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(NJCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    NJCategoryIndicatorCellModel *myUnselectedCellModel = (NJCategoryIndicatorCellModel *)unselectedCellModel;
    myUnselectedCellModel.backgroundViewMaskFrame = CGRectZero;
    myUnselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myUnselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;

    NJCategoryIndicatorCellModel *myselectedCellModel = (NJCategoryIndicatorCellModel *)selectedCellModel;
    myselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    [super contentOffsetOfContentScrollViewDidChanged:contentOffset];
    
    CGFloat ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    if (ratio > self.dataSource.count - 1 || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    if (baseIndex + 1 >= self.dataSource.count) {
        //右边越界了，不需要处理
        return;
    }
    CGFloat remainderRatio = ratio - baseIndex;

    CGRect leftCellFrame = [self getTargetCellFrame:baseIndex];
    CGRect rightCellFrame = [self getTargetCellFrame:baseIndex + 1];

    NJCategoryIndicatorParamsModel *indicatorParamsModel = [[NJCategoryIndicatorParamsModel alloc] init];
    indicatorParamsModel.selectedIndex = self.selectedIndex;
    indicatorParamsModel.leftIndex = baseIndex;
    indicatorParamsModel.leftCellFrame = leftCellFrame;
    indicatorParamsModel.rightIndex = baseIndex + 1;
    indicatorParamsModel.rightCellFrame = rightCellFrame;
    indicatorParamsModel.percent = remainderRatio;
    if (remainderRatio == 0) {
        for (UIView<NJCategoryIndicatorProtocol> *indicator in self.indicators) {
            [indicator jx_contentScrollViewDidScroll:indicatorParamsModel];
        }
    } else {
        NJCategoryIndicatorCellModel *leftCellModel = (NJCategoryIndicatorCellModel *)self.dataSource[baseIndex];
        leftCellModel.selectedType = JXCategoryCellSelectedTypeUnknown;
        NJCategoryIndicatorCellModel *rightCellModel = (NJCategoryIndicatorCellModel *)self.dataSource[baseIndex + 1];
        rightCellModel.selectedType = JXCategoryCellSelectedTypeUnknown;
        [self refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:remainderRatio];

        for (UIView<NJCategoryIndicatorProtocol> *indicator in self.indicators) {
            [indicator jx_contentScrollViewDidScroll:indicatorParamsModel];
            if ([indicator isKindOfClass:[NJSelectCategoryIndicatorBackgroundView class]]) {
                CGRect leftMaskFrame = indicator.frame;
                leftMaskFrame.origin.x = leftMaskFrame.origin.x - leftCellFrame.origin.x;
                leftCellModel.backgroundViewMaskFrame = leftMaskFrame;

                CGRect rightMaskFrame = indicator.frame;
                rightMaskFrame.origin.x = rightMaskFrame.origin.x - rightCellFrame.origin.x;
                rightCellModel.backgroundViewMaskFrame = rightMaskFrame;
            }
        }

        NJCategoryBaseCell *leftCell = (NJCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
        [leftCell reloadData:leftCellModel];
        NJCategoryBaseCell *rightCell = (NJCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex + 1 inSection:0]];
        [rightCell reloadData:rightCellModel];
    }
}

- (BOOL)selectCellAtIndex:(NSInteger)index selectedType:(JXCategoryCellSelectedType)selectedType {
    NSInteger lastSelectedIndex = self.selectedIndex;
    BOOL result = [super selectCellAtIndex:index selectedType:selectedType];
    if (!result) {
        return NO;
    }

    CGRect clickedCellFrame = [self getTargetSelectedCellFrame:index selectedType:selectedType];
    
    NJCategoryIndicatorCellModel *selectedCellModel = (NJCategoryIndicatorCellModel *)self.dataSource[index];
    selectedCellModel.selectedType = selectedType;
    for (UIView<NJCategoryIndicatorProtocol> *indicator in self.indicators) {
        NJCategoryIndicatorParamsModel *indicatorParamsModel = [[NJCategoryIndicatorParamsModel alloc] init];
        indicatorParamsModel.lastSelectedIndex = lastSelectedIndex;
        indicatorParamsModel.selectedIndex = index;
        indicatorParamsModel.selectedCellFrame = clickedCellFrame;
        indicatorParamsModel.selectedType = selectedType;
        [indicator jx_selectedCell:indicatorParamsModel];
        if ([indicator isKindOfClass:[NJSelectCategoryIndicatorBackgroundView class]]) {
            CGRect maskFrame = indicator.frame;
            maskFrame.origin.x = maskFrame.origin.x - clickedCellFrame.origin.x;
            selectedCellModel.backgroundViewMaskFrame = maskFrame;
        }
    }

    NJCategoryIndicatorCell *selectedCell = (NJCategoryIndicatorCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [selectedCell reloadData:selectedCellModel];

    return YES;
}

@end

@implementation NJCategoryIndicatorView (UISubclassingIndicatorHooks)

- (void)refreshLeftCellModel:(NJCategoryBaseCellModel *)leftCellModel rightCellModel:(NJCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    if (self.isCellBackgroundColorGradientEnabled) {
        //处理cell背景色渐变
        NJCategoryIndicatorCellModel *leftModel = (NJCategoryIndicatorCellModel *)leftCellModel;
        NJCategoryIndicatorCellModel *rightModel = (NJCategoryIndicatorCellModel *)rightCellModel;
        if (leftModel.isSelected) {
            leftModel.cellBackgroundSelectedColor = [NJCategoryFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            leftModel.cellBackgroundUnselectedColor = [NJCategoryFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
        if (rightModel.isSelected) {
            rightModel.cellBackgroundSelectedColor = [NJCategoryFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            rightModel.cellBackgroundUnselectedColor = [NJCategoryFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
    }
}

@end
