//
//  MainChatInputCommonEmojiView.h
//  CIMKit
//
//  Created by cusPro on 2023/6/28.
//

// 常用表情View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MainChatInputCommonEmojiViewDelegate <NSObject>
- (void)commonEmojiSelected:(NSString *)emojiName;
@end

@interface MainChatInputCommonEmojiView : UIView
@property (nonatomic, weak) id <MainChatInputCommonEmojiViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
