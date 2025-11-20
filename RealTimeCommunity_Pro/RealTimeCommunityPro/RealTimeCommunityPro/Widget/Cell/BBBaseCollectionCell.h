//
//  BBBaseCollectionCell.h
//  CIMKit
//
//  Created by cusPro on 2023/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BBBaseCollectionCellDelegate <NSObject>
//需要可视化交互界面，可用此方法代理系统的
- (void)baseCellDidSelectedRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BBBaseCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *baseCellIndexPath;
@property (nonatomic, weak) id <BBBaseCollectionCellDelegate> baseCellDelegate;
@property (nonatomic, strong) UIButton *baseContentButton;//可视化交互背景按钮

//cell大小
+ (CGSize)defaultCellSize;

//重用标识
+ (NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
