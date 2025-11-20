//
//  NFFriendGroupSectionHeaderView.h
//  CIMKit
//
//  Created by cusPro on 2023/7/3.
//

#import <UIKit/UIKit.h>
#import "CMFriendGroupModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol NFFriendGroupSectionHeaderViewDelegate <NSObject>
- (void)friendGroupSectionOpenWith:(CMFriendGroupModel *)friendGroupModel;
- (void)friendGroupSectionLongPress;
@end

@interface NFFriendGroupSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIImageView *ivArrow;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblNumber;
@property (nonatomic, weak) id <NFFriendGroupSectionHeaderViewDelegate> delegate;

@property (nonatomic, strong) CMFriendGroupModel *friendGroupModel;

@end

NS_ASSUME_NONNULL_END
