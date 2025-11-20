//
//  NFFriendGroupManagerCell.h
//  CIMKit
//
//  Created by cusPro on 2023/7/4.
//

#import "ZBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NFFriendGroupManagerCellDelegate <NSObject>
- (void)friendGroupManagerDelete:(LingIMFriendGroupModel *)friendGroupModel;
- (void)friendGroupManagerChangeName:(LingIMFriendGroupModel *)friendGroupModel newFriendGroupName:(NSString *)friendGroupName;
@end

@interface NFFriendGroupManagerCell : ZBaseCell

@property (nonatomic, strong) UIButton *btnDelete;
@property (nonatomic, strong) UITextField *tfTitle;
@property (nonatomic, strong) UIImageView *ivSelect;
@property (nonatomic, strong) UIView *viewLine;

@property (nonatomic, weak) id <NFFriendGroupManagerCellDelegate> delegate;

//配置Cell信息
- (void)configCellWith:(LingIMFriendGroupModel *)friendGroupModel canEdit:(BOOL)canEdit;
@end

NS_ASSUME_NONNULL_END
