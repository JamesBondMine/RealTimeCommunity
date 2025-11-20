//
//  TalkCellChatHistoryFileCell.h
//  CIMKit
//
//  Created by cusPro on 2023/2/2.
//

#import "MGSwipeTableCell.h"
@protocol TalkCellChatHistoryFileCellDelegate <NSObject>
//点击
- (void)cellClickAction:(NSIndexPath *_Nullable)indexPath;
@end

NS_ASSUME_NONNULL_BEGIN

@interface TalkCellChatHistoryFileCell : MGSwipeTableCell
@property (nonatomic, weak) id <TalkCellChatHistoryFileCellDelegate> cellDelegate;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
+ (CGFloat)defaultCellHeight;
+(NSString *)cellIdentifier;
- (void)configCellWith:(LingIMChatMessageModel *)chatMessageModel searchContent:(NSString *)searchStr;
@end

NS_ASSUME_NONNULL_END
