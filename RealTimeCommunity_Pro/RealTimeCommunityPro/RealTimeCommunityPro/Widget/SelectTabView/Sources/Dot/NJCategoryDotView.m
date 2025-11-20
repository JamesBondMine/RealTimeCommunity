//
//  NJCategoryDotView.m
// 
//
//  Created by jiaxin on 2018/8/20.
//  Co pyright © 2018年 jiaxin. All rights reserved.
//

#import "NJCategoryDotView.h"

@implementation NJCategoryDotView

- (void)initializeData {
    [super initializeData];

    _relativePosition = JXCategoryDotRelativePosition_TopRight;
    _dotSize = CGSizeMake(10, 10);
    _dotCornerRadius = JXCategoryViewAutomaticDimension;
    _dotColor = [UIColor redColor];
    _dotOffset = CGPointZero;
}

- (Class)preferredCellClass {
    return [NJCategoryDotCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titles.count];
    for (int i = 0; i < self.titles.count; i++) {
        NJCategoryDotCellModel *cellModel = [[NJCategoryDotCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
}

- (void)refreshCellModel:(NJCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    NJCategoryDotCellModel *myCellModel = (NJCategoryDotCellModel *)cellModel;
    myCellModel.dotHidden = [self.dotStates[index] boolValue];
    myCellModel.relativePosition = self.relativePosition;
    myCellModel.dotSize = self.dotSize;
    myCellModel.dotColor = self.dotColor;
    myCellModel.dotOffset = self.dotOffset;
    if (self.dotCornerRadius == JXCategoryViewAutomaticDimension) {
        myCellModel.dotCornerRadius = self.dotSize.height/2;
    }else {
        myCellModel.dotCornerRadius = self.dotCornerRadius;
    }
}

@end
