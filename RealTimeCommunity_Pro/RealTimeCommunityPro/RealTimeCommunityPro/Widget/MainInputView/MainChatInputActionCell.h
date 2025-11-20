//
//  MainChatInputActionCell.h
//  CIMKit
//
//  Created by cusPro on 2023/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MainChatInputActionCellDelegate <NSObject>
- (void)actionCellSelected:(NSIndexPath *)cellIndex;
@end

@interface MainChatInputActionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *ivAction;
@property (nonatomic, strong) NSIndexPath *cellIndex;

@property (nonatomic, weak) id <MainChatInputActionCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
