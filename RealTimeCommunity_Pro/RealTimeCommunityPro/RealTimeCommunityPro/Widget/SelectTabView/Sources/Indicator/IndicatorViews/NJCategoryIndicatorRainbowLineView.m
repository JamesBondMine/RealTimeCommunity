//
//  NJCategoryIndicatorRainbowLineView.m
// 
//
//  Created by jiaxin on 2018/12/13.
//  Copyright © 2018 jiaxin. All rights reserved.
// 

#import "NJCategoryIndicatorRainbowLineView.h"
#import "NJCategoryFactory.h"

@implementation NJCategoryIndicatorRainbowLineView

- (void)jx_refreshState:(NJCategoryIndicatorParamsModel *)model {
    [super jx_refreshState:model];

    UIColor *color = self.indicatorColors[model.selectedIndex];
    self.backgroundColor = color;
}

- (void)jx_contentScrollViewDidScroll:(NJCategoryIndicatorParamsModel *)model {
    [super jx_contentScrollViewDidScroll:model];

    UIColor *leftColor = self.indicatorColors[model.leftIndex];
    UIColor *rightColor = self.indicatorColors[model.rightIndex];
    UIColor *color = [NJCategoryFactory interpolationColorFrom:leftColor to:rightColor percent:model.percent];
    self.backgroundColor = color;
}

- (void)jx_selectedCell:(NJCategoryIndicatorParamsModel *)model {
    [super jx_selectedCell:model];

    UIColor *color = self.indicatorColors[model.selectedIndex];
    self.backgroundColor = color;
}


@end
