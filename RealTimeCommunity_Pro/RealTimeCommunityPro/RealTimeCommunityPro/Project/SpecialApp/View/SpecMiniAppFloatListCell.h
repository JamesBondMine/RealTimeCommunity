//
//  SpecMiniAppFloatListCell.h
//  CIMKit
//
//  Created by cusPro on 2023/7/19.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SpecMiniAppFloatListCellDelegate <NSObject>
- (void)miniAppDeleteWith:(NSIndexPath *)cellIndex;
@end

@interface SpecMiniAppFloatListCell : ZBaseCell

@property (nonatomic, weak) id <SpecMiniAppFloatListCellDelegate> delegate;
@property (nonatomic, strong) LingFloatMiniAppModel * floatMiniAppModel;
@end

NS_ASSUME_NONNULL_END
