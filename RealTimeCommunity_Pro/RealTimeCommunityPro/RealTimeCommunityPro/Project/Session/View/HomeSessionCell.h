//
//  HomeSessionCell.h
//  CIMKit
//
//  Created by cusPro on 2022/9/23.
//

// 会话列表 Cell

#import "MGSwipeTableCell.h"

@protocol HomeSessionCellDelegate <NSObject>
//点击
- (void)cellClickAction:(NSIndexPath *_Nullable)indexPath;
@end

NS_ASSUME_NONNULL_BEGIN

@interface HomeSessionCell : MGSwipeTableCell
@property (nonatomic, strong) LingIMSessionModel *model;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, weak) id <HomeSessionCellDelegate> cellDelegate;
@property (nonatomic, copy) void(^clearSessionBlock)(void);
@end

NS_ASSUME_NONNULL_END
