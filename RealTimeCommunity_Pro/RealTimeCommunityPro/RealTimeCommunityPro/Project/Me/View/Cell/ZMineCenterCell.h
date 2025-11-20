//
//  ZMineCenterCell.h
//  CIMKit
//
//  Created by cusPro on 2022/11/12.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMineCenterCell : ZBaseCell

@property (nonatomic, strong)NSDictionary *dataDic;

/// 根据下标配置圆角
/// - Parameters:
///   - cellIndexPath: 当前下标
///   - totalIndex: 该区总row数
- (void)configCellCornerWith:(NSIndexPath *)cellIndexPath totalIndex:(NSInteger)totalIndex;

/// 提示文案的展示
/// - Parameter cellIndexPath: 当前下标
- (void)configCellTipWith:(NSIndexPath *)cellIndexPath;
@end

NS_ASSUME_NONNULL_END
