//
//  ZChatEmojiSearchCell.h
//  CIMKit
//
//  Created by cusPro on 2023/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZChatEmojiSearchCellDelegate <NSObject>

- (void)searchStickerResultLongTapAction:(NSIndexPath *)indexPath;

@end

@interface ZChatEmojiSearchCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, strong) LingIMStickersModel *stickersModel;
@property (nonatomic, weak) id <ZChatEmojiSearchCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
