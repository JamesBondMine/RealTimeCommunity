//
//  EMChatPackageInEmojiView.h
//  CIMKit
//
//  Created by cusPro on 2023/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EMChatPackageInEmojiViewDelegate <NSObject>

//点击表情包表情发送
- (void)stickerPackageItemSelected:(LingIMStickersModel *)sendStickersModel;

//删除选中的表情包
- (void)deleteStickersPackageWithStickersSetId:(NSString *)stickersSetId;

@end

@interface EMChatPackageInEmojiView : UIView

@property (nonatomic, copy) NSString *stickersId;
@property (nonatomic, copy) NSString *packageNameStr;
@property (nonatomic, strong) NSMutableArray *stickersList;
@property (nonatomic, weak) id <EMChatPackageInEmojiViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
