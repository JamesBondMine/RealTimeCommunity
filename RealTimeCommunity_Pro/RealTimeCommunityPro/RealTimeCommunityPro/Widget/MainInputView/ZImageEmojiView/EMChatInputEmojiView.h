//
//  EMChatInputEmojiView.h
//  CIMKit
//
//  Created by cusPro on 2022/10/12.
//

// 自定义表情 View

#import <UIKit/UIKit.h>
#import "EMChatInputEmojiManager.h"

NS_ASSUME_NONNULL_BEGIN
@protocol EMChatInputEmojiViewDelegate <NSObject>
//选中表情
- (void)inputEmojiViewSelected:(NSString *)emojiName;
//删除
- (void)inputEmojiViewDelete;
@end

@interface EMChatInputEmojiView : UIView
@property (nonatomic, weak) id <EMChatInputEmojiViewDelegate> delegate;
@end


@interface ZChatInputEmojiCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *ivEmoji;
@end

NS_ASSUME_NONNULL_END
