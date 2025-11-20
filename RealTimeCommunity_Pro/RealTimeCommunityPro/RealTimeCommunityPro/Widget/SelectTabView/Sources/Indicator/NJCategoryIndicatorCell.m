//
//  JXCategoryComponetCell.m
//  DQGuess
//
//  Created by jiaxin on 2018/7/25.
//  Copyright © 2018年 jingbo. All rights reserved.
// 

#import "NJCategoryIndicatorCell.h"
#import "NJCategoryIndicatorCellModel.h"

@interface NJCategoryIndicatorCell ()
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation NJCategoryIndicatorCell

- (void)initializeViews {
    [super initializeViews];

    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.hidden = YES;
    [self.contentView addSubview:self.separatorLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NJCategoryIndicatorCellModel *model = (NJCategoryIndicatorCellModel *)self.cellModel;
    CGFloat lineWidth = model.separatorLineSize.width;
    CGFloat lineHeight = model.separatorLineSize.height;

    self.separatorLine.frame = CGRectMake(self.bounds.size.width - lineWidth + self.cellModel.cellSpacing/2, (self.bounds.size.height - lineHeight)/2.0, lineWidth, lineHeight);
}

- (void)reloadData:(NJCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    NJCategoryIndicatorCellModel *model = (NJCategoryIndicatorCellModel *)cellModel;
    self.separatorLine.backgroundColor = model.separatorLineColor;
    self.separatorLine.hidden = !model.isSepratorLineShowEnabled;

    if (model.isCellBackgroundColorGradientEnabled) {
        if (model.isSelected) {
            self.contentView.backgroundColor = model.cellBackgroundSelectedColor;
        }else {
            self.contentView.backgroundColor = model.cellBackgroundUnselectedColor;
        }
    }
}

@end
