//
//  CNNewFriendListCell.h
//  CIMKit
//
//  Created by cusPro on 2022/9/9.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "CMFriendApplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CNNewFriendListCellDelegate <NSObject>
//点击
- (void)cellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CNNewFriendListCell : MGSwipeTableCell
@property (nonatomic, strong) CMFriendApplyModel *model;
@property (nonatomic, copy) void(^stateBtnClick)(void);//按钮交互事件

@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, weak) id <CNNewFriendListCellDelegate> cellDelegate;

@end

NS_ASSUME_NONNULL_END
