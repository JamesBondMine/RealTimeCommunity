//
//  ZEmojiShopPackagCell.h
//  CIMKit
//
//  Created by cusPro on 2023/10/25.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZEmojiShopPackagCellDelegate <NSObject>

- (void)emojiPackageAddNewEmoji:(NSIndexPath *)cellIndexPath;

@end

@interface ZEmojiShopPackagCell : ZBaseCell

@property (nonatomic, strong) LingIMStickersPackageModel *model;
@property (nonatomic, weak) id<ZEmojiShopPackagCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
