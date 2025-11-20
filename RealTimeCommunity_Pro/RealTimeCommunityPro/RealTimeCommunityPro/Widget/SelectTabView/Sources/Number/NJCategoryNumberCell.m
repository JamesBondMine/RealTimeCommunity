//
//  NJCategoryNumberCell.m
//  DQGuess
//
//  Created by jiaxin on 2018/4/9.
//  Copyright © 2018年 jingbo. All rights reserved.
// 

#import "NJCategoryNumberCell.h"
#import "NJCategoryNumberCellModel.h"

@interface NJCategoryNumberCell ()
@property (nonatomic, strong) NSLayoutConstraint *numberCenterXConstraint;
@property (nonatomic, strong) NSLayoutConstraint *numberCenterYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *numberHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *numberWidthConstraint;
@end

@implementation NJCategoryNumberCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.numberLabel.text = nil;
}

- (void)initializeViews {
    [super initializeViews];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.numberLabel];
    self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.numberCenterXConstraint = [self.numberLabel.centerXAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor];
    self.numberCenterYConstraint = [self.numberLabel.centerYAnchor constraintEqualToAnchor:self.titleLabel.topAnchor];
    self.numberHeightConstraint = [self.numberLabel.heightAnchor constraintEqualToConstant:0];
    self.numberWidthConstraint = [self.numberLabel.widthAnchor constraintEqualToConstant:0];
    [NSLayoutConstraint activateConstraints:@[self.numberCenterXConstraint, self.numberCenterYConstraint, self.numberWidthConstraint, self.numberHeightConstraint]];
}

- (void)reloadData:(NJCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    NJCategoryNumberCellModel *myCellModel = (NJCategoryNumberCellModel *)cellModel;
    self.numberLabel.hidden = (myCellModel.count == 0);
    self.numberLabel.backgroundColor = myCellModel.numberBackgroundColor;
    self.numberLabel.font = myCellModel.numberLabelFont;
    self.numberLabel.textColor = myCellModel.numberTitleColor;
    self.numberLabel.text = myCellModel.numberString;
    self.numberLabel.layer.cornerRadius = myCellModel.numberLabelHeight/2.0;
    self.numberHeightConstraint.constant = myCellModel.numberLabelHeight;
    self.numberCenterXConstraint.constant = myCellModel.numberLabelOffset.x;
    self.numberCenterYConstraint.constant = myCellModel.numberLabelOffset.y;
    if (myCellModel.count < 10 && myCellModel.shouldMakeRoundWhenSingleNumber) {
        self.numberWidthConstraint.constant = myCellModel.numberLabelHeight;
    }else {
        self.numberWidthConstraint.constant = myCellModel.numberStringWidth + myCellModel.numberLabelWidthIncrement;
    }
}

@end
