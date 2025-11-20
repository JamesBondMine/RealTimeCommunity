//
//  NJCategoryListContainerRTLCell.m
// 
//
//  Created by jiaxin on 2020/7/3.
// 

#import "NJCategoryListContainerRTLCell.h"
#import "RTLManager.h"

@implementation NJCategoryListContainerRTLCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [RTLManager horizontalFlipViewIfNeeded:self];
        [RTLManager horizontalFlipViewIfNeeded:self.contentView];
    }
    return self;
}

@end
