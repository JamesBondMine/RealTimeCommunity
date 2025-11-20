//
//  EMChatGitImgCollectionView.h
//  CIMKit
//
//  Created by cusPro on 2023/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EMChatGitImgCollectionViewDelegate <NSObject>

//发送收藏的表情
- (void)inputCollectGifImgSelected:(LingIMStickersModel *)sendStickersModel;
//打开相册添加表情图片到收藏
- (void)addCollectionGifImgAction;
//游戏表情：石头剪刀布、摇骰子
- (void)chatGameStickerAction:(ZChatGameStickerType)gameType;

@end

@interface EMChatGitImgCollectionView : UIView

@property (nonatomic, weak) id <EMChatGitImgCollectionViewDelegate> delegate;

//每一次点击表情按钮，都从第1页重新拉取接口数据
- (void)reloadMyCollectionStickers;

@end

NS_ASSUME_NONNULL_END
