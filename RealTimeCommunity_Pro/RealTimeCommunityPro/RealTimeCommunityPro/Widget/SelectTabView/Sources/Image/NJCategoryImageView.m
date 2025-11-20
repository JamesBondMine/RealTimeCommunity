//
//  NJCategoryImageView.m
// 
//
//  Created by jiaxin on 2018/8/20.
//  Copyright © 2018年 jiaxin. All rights reserved.
// 

#import "NJCategoryImageView.h"
#import "NJCategoryFactory.h"

@implementation NJCategoryImageView

- (void)dealloc {
    self.loadImageBlock = nil;
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];

    _imageSize = CGSizeMake(20, 20);
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
    _imageCornerRadius = 0;
}

- (Class)preferredCellClass {
    return [NJCategoryImageCell class];
}

- (void)refreshDataSource {
    NSUInteger count = 0;
    if (self.imageInfoArray.count > 0) {
        count = self.imageInfoArray.count;
    }else if (self.imageNames.count > 0) {
        count = self.imageNames.count;
    }else {
        count = self.imageURLs.count;
    }
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NJCategoryImageCellModel *cellModel = [[NJCategoryImageCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
}

- (void)refreshSelectedCellModel:(NJCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(NJCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    NJCategoryImageCellModel *myUnselectedCellModel = (NJCategoryImageCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;

    NJCategoryImageCellModel *myselectedCellModel = (NJCategoryImageCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshCellModel:(NJCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    NJCategoryImageCellModel *myCellModel = (NJCategoryImageCellModel *)cellModel;
    myCellModel.loadImageBlock = self.loadImageBlock;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageSize = self.imageSize;
    myCellModel.imageCornerRadius = self.imageCornerRadius;
    if (self.imageInfoArray && self.imageInfoArray.count != 0) {
        myCellModel.imageInfo = self.imageInfoArray[index];
    }else if (self.imageNames && self.imageNames.count != 0) {
        myCellModel.imageName = self.imageNames[index];
    }else if (self.imageURLs && self.imageURLs.count != 0) {
        myCellModel.imageURL = self.imageURLs[index];
    }
    if (self.selectedImageInfoArray && self.selectedImageInfoArray.count != 0) {
        myCellModel.selectedImageInfo = self.selectedImageInfoArray[index];
    }else if (self.selectedImageNames && self.selectedImageNames.count != 0) {
        myCellModel.selectedImageName = self.selectedImageNames[index];
    }else if (self.selectedImageURLs && self.selectedImageURLs.count != 0) {
        myCellModel.selectedImageURL = self.selectedImageURLs[index];
    }
    myCellModel.imageZoomEnabled = self.imageZoomEnabled;
    myCellModel.imageZoomScale = ((index == self.selectedIndex) ? self.imageZoomScale : 1.0);
}

- (void)refreshLeftCellModel:(NJCategoryBaseCellModel *)leftCellModel rightCellModel:(NJCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    NJCategoryImageCellModel *leftModel = (NJCategoryImageCellModel *)leftCellModel;
    NJCategoryImageCellModel *rightModel = (NJCategoryImageCellModel *)rightCellModel;

    if (self.isImageZoomEnabled) {
        leftModel.imageZoomScale = [NJCategoryFactory interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
        rightModel.imageZoomScale = [NJCategoryFactory interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == JXCategoryViewAutomaticDimension) {
        return self.imageSize.width;
    }
    return self.cellWidth;
}

@end
