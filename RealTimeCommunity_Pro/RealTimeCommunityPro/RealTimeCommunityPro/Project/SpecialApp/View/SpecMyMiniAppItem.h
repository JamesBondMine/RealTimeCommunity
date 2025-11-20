//
//  SpecMyMiniAppItem.h
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

#import "BBBaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SpecMyMiniAppItemDelete <NSObject>
- (void)myMiniAppDelete:(NSIndexPath *)indexPath;
@end

@interface SpecMyMiniAppItem : BBBaseCollectionCell
@property (nonatomic, weak) id <SpecMyMiniAppItemDelete> delegate;

- (void)configItemWith:(LingIMMiniAppModel *)miniAppModel manage:(BOOL)manageItem;
@end

NS_ASSUME_NONNULL_END
