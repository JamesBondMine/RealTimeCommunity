//
//  NJCategoryCollectionView.h
//  UI系列测试
//
//  Created by jiaxin on 2018/3/21.
//  Copyright © 2018年 jiaxin. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "NJCategoryIndicatorProtocol.h"
@class NJCategoryCollectionView;

@protocol NJCategoryCollectionViewGestureDelegate <NSObject>
@optional
- (BOOL)categoryCollectionView:(NJCategoryCollectionView *)collectionView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)categoryCollectionView:(NJCategoryCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end

@interface NJCategoryCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <UIView<NJCategoryIndicatorProtocol> *> *indicators;
@property (nonatomic, weak) id<NJCategoryCollectionViewGestureDelegate> gestureDelegate;

@end
