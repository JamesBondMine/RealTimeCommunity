//
//  LJCategoryTitleImageView.m
// 
//
//  Created by LJ on 2023/03/12.
//  Copyright © 2018年 jiaxin. All rights reserved.
// 

#import "LJCategoryTitleImageView.h"
#import "LJCategoryTitleImageCell.h"
#import "LJCategoryTitleImageCellModel.h"
#import "NJCategoryFactory.h"

@implementation LJCategoryTitleImageView

- (void)dealloc {
    self.loadImageBlock = nil;
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];

    _imageSize = CGSizeMake(20, 20);
    _titleImageSpacing = 5;
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
}

- (Class)preferredCellClass {
    return [LJCategoryTitleImageCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titles.count];
    for (int i = 0; i < self.titles.count; i++) {
        LJCategoryTitleImageCellModel *cellModel = [[LJCategoryTitleImageCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = [NSArray arrayWithArray:tempArray];
    
    if (!self.imageTypes || (self.imageTypes.count == 0)) {
        NSMutableArray *types = [NSMutableArray arrayWithCapacity:self.titles.count];
        for (int i = 0; i< self.titles.count; i++) {
            [types addObject:@(JXCategoryTitleImageType_LeftImage)];
        }
        self.imageTypes = [NSArray arrayWithArray:types];
    }
}

- (void)refreshCellModel:(NJCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    LJCategoryTitleImageCellModel *myCellModel = (LJCategoryTitleImageCellModel *)cellModel;
    myCellModel.loadImageBlock = self.loadImageBlock;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageType = [self.imageTypes[index] integerValue];
    myCellModel.imageSize = self.imageSize;
    myCellModel.titleImageSpacing = self.titleImageSpacing;
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

- (void)refreshSelectedCellModel:(NJCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(NJCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    LJCategoryTitleImageCellModel *myUnselectedCellModel = (LJCategoryTitleImageCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;

    LJCategoryTitleImageCellModel *myselectedCellModel = (LJCategoryTitleImageCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshLeftCellModel:(NJCategoryBaseCellModel *)leftCellModel rightCellModel:(NJCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    LJCategoryTitleImageCellModel *leftModel = (LJCategoryTitleImageCellModel *)leftCellModel;
    LJCategoryTitleImageCellModel *rightModel = (LJCategoryTitleImageCellModel *)rightCellModel;

    if (self.isImageZoomEnabled) {
        leftModel.imageZoomScale = [NJCategoryFactory interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
        rightModel.imageZoomScale = [NJCategoryFactory interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == JXCategoryViewAutomaticDimension) {
        CGFloat titleWidth = [super preferredCellWidthAtIndex:index];
        JXCategoryTitleImageType type = [self.imageTypes[index] integerValue];
        CGFloat cellWidth = 0;
        switch (type) {
            case JXCategoryTitleImageType_OnlyTitle:
                cellWidth = titleWidth;
                break;
            case JXCategoryTitleImageType_OnlyImage:
                cellWidth = self.imageSize.width;
                break;
            case JXCategoryTitleImageType_LeftImage:
            case JXCategoryTitleImageType_RightImage:
                cellWidth = titleWidth + self.titleImageSpacing + self.imageSize.width;
                break;
            case JXCategoryTitleImageType_TopImage:
            case JXCategoryTitleImageType_BottomImage:
                cellWidth = MAX(titleWidth, self.imageSize.width);
                break;
        }
        return cellWidth;
    }
    return self.cellWidth;
}

@end
