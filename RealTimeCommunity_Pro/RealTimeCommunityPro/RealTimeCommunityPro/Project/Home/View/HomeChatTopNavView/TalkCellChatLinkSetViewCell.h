//
//  TalkCellChatLinkSetViewCell.h
//  CIMKit
//
//  Created by cusPro on 2023/7/18.
//

#import <UIKit/UIKit.h>
#import "ZChatTagModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TalkCellChatLinkSetViewCellDelegate <NSObject>

- (void)deleteChatLinkAction:(NSInteger)cellIndex;
- (void)editChatLinkAction:(NSInteger)cellIndex;

@end

@interface TalkCellChatLinkSetViewCell : UITableViewCell

@property (nonatomic, weak) id<TalkCellChatLinkSetViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *cellaPath;
@property (nonatomic, strong) ZChatTagModel *tagModel;

@end

NS_ASSUME_NONNULL_END
