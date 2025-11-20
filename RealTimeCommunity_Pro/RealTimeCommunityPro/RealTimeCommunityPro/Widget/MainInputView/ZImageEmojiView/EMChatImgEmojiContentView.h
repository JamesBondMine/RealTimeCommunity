//
//  EMChatImgEmojiContentView.h
//  CIMKit
//
//  Created by cusPro on 2024/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EMChatImgEmojiContentViewDelegate <NSObject>

//滑动操作
- (void)scrollToPage:(int)page;

/** Emoji */
//选中表情
- (void)inputEmojiViewSelected:(NSString *)emojiName;
//删除
- (void)inputEmojiViewDelete;

/** 收藏的表情 */
//发送收藏的表情
- (void)inputCollectGifImgSelected:(LingIMStickersModel *)sendStickersModel;
//打开相册添加表情图片到收藏
- (void)addCollectionGifImgAction;
//游戏表情：石头剪刀布、摇骰子
- (void)chatGameStickerAction:(ZChatGameStickerType)gameType;

/** 表情包 */
//点击表情包表情发送
- (void)stickerPackageItemSelected:(LingIMStickersModel *)sendStickersModel;
//删除选中的表情包
- (void)deleteStickersPackageWithStickersSetId:(NSString *)stickersSetId;


@end

@interface EMChatImgEmojiContentView : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *contentItemList;
@property (nonatomic, weak) id <EMChatImgEmojiContentViewDelegate> delegate;

- (void)reloadMyCollectionStickers;

@end

NS_ASSUME_NONNULL_END
