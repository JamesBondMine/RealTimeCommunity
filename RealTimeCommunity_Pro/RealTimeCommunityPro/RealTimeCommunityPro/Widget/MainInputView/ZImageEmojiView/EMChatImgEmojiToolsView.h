//
//  EMChatImgEmojiToolsView.h
//  CIMKit
//
//  Created by cusPro on 2023/8/10.
//

#import <UIKit/UIKit.h>
#import "SyncMutableArray.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EMChatImgEmojiToolsViewDelegate <NSObject>
//选中
- (void)toolsViewSelectedIndex:(NSInteger)toolsIndex;

@end


@interface EMChatImgEmojiToolsView : UIView

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *toolsItemList;
@property (nonatomic, weak) id <EMChatImgEmojiToolsViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
