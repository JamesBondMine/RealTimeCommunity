//
//  EMChatEmojiSearchView.h
//  CIMKit
//
//  Created by cusPro on 2023/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EMChatEmojiSearchViewDelegate <NSObject>
//更多表情
- (void)moreEmojiAction;
//点击发送搜索到的表情
- (void)sendSearchStickersForModel:(LingIMStickersModel *)stickersModel;
//收藏表情
- (void)collectionStickerFromSearchResult;

@end

@interface EMChatEmojiSearchView : UIView

@property (nonatomic, weak) id <EMChatEmojiSearchViewDelegate> delegate;

- (void)emojiSearchViewShow;
- (void)emojiSearchViewDismiss;

@end

NS_ASSUME_NONNULL_END
